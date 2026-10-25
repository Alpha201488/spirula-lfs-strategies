// MaskSam.cpp -- see MaskSam.h.

#include "app/gui/mask/MaskSam.h"

#include "app/gui/MaskSettings.h"
#include "i18n/catalog/MaskEdit.h"

#include <algorithm>
#include <exception>
#include <mutex>

#ifdef SS_BUILD_SAM
#include "nn/vk/Memory.h"
#include "sam/Masking.h"   // split_phrases, downscale_to_fit -- never sam::Masker
#include "sam/Sam.h"

#include <atomic>
#include <chrono>
#include <cstdlib>
#include <thread>
#endif

namespace gui {
namespace mask {

namespace msg = spirula::i18n::msg::maskedit;

struct MaskSam::State {
    std::string model;
    std::string device;              // the app's frozen selector; "" = nn's own
    bool text_hint = false;
    MaskSettings prompt;             // the EDITOR'S own, never the dataset screen's
    mutable std::mutex mu;
    std::string status, error;       // guarded by mu, with the result below
    bool ready = false;
    SamResult result;
#ifdef SS_BUILD_SAM
    // The job thread's alone while `running`; the UI thread's after a join.
    std::unique_ptr<sam::Session> session;
    std::string loaded_model, encoded_key;
    std::thread worker;              // UI thread only
    std::atomic<bool> running{false}, cancel{false};
    bool loaded = false;             // guarded by mu, with the two below
    bool loaded_text = false;
    double vram_mib = -1.0;
#endif
};

MaskSam::MaskSam() : _s(std::make_unique<State>()) {}
MaskSam::~MaskSam() { release(); }

void MaskSam::set_model(const std::string& path, bool text_prompts) {
    _s->model = path;
    _s->text_hint = text_prompts;
}

const std::string& MaskSam::model_path() const { return _s->model; }
void MaskSam::set_device(const std::string& selector) { _s->device = selector; }
const std::string& MaskSam::device() const { return _s->device; }
bool MaskSam::has_model() const { return !_s->model.empty(); }
MaskSettings& MaskSam::prompt() { return _s->prompt; }
const MaskSettings& MaskSam::prompt() const { return _s->prompt; }

void MaskSam::add_click(long long frame, const std::string& camera, float x, float y,
                        bool positive) {
    MaskClick c;
    c.x = x;
    c.y = y;
    c.positive = positive;
    c.object = _s->prompt.current_object;
    c.frame = frame;
    c.camera = camera;
    _s->prompt.clicks.push_back(std::move(c));
}

// `source` stays empty: the editor has no input path to give. Empty is NOT
// safe: a dataset run reads it as every input, so an editor click must never
// reach the dataset's MaskSettings, or it would prompt the whole capture.
std::vector<SamPoint> MaskSam::object_points(long long frame, const std::string& camera) const {
    std::vector<SamPoint> out;
    for (const MaskClick& c : _s->prompt.clicks)
        if (c.source.empty() && c.object == _s->prompt.current_object && c.frame == frame &&
            c.camera == camera)
            out.push_back(SamPoint{c.x, c.y, c.positive});
    return out;
}

std::vector<SamPoint> MaskSam::prompt_points(long long frame, const std::string& camera,
                                             SamPoint click) const {
    std::vector<SamPoint> out = object_points(frame, camera);
    out.push_back(click);
    return out;
}

std::string MaskSam::status() const {
    std::lock_guard<std::mutex> lk(_s->mu);
    return _s->status;
}

std::string MaskSam::error() const {
    std::lock_guard<std::mutex> lk(_s->mu);
    return _s->error;
}

void run_guarded(const std::function<void()>& body,
                 const std::function<void(const std::string&)>& on_throw) {
    try {
        body();
    } catch (const std::exception& e) {
        on_throw(e.what());
    } catch (...) {
        on_throw("unknown error");
    }
}

bool publish_unless_cancelled(const std::function<SamResult()>& build,
                              const std::function<bool()>& cancelled,
                              const std::function<void(SamResult)>& publish) {
    SamResult r = build();
    if (cancelled()) return false;
    publish(std::move(r));
    return true;
}

bool MaskSam::clear_error_if(const std::string& reason) {
    std::lock_guard<std::mutex> lk(_s->mu);
    if (_s->error != reason) return false;
    _s->error.clear();
    return true;
}

SamResult MaskSam::prepare(std::string frame_key, std::vector<AddRegion> regions, int doc_w,
                           int doc_h, Paint mode, float margin, float score, bool hold,
                           const std::vector<AddRegion>& veto) {
    SamResult r;
    if (hold)
        for (const AddRegion& g : regions) r.held.push_back(hold_region(g));
    r.frame_key = std::move(frame_key);
    r.mode = mode;
    r.score = score;
    r.detections = (int)regions.size();
    const auto any_set = [](const AddRegion& g) {
        return std::any_of(g.mask.begin(), g.mask.end(), [](uint8_t v) { return v != 0; });
    };
    const bool matched = !veto.empty() && std::any_of(regions.begin(), regions.end(), any_set);
    r.landed = build_add_stencil(regions, doc_w, doc_h, r.stencil, r.bounds, r.set_px,
                                 add_margin(margin), veto);
    r.vetoed_all = matched && !r.landed;
    return r;
}

SamResult MaskSam::remargin(std::string frame_key, std::vector<HeldRegion> held, int doc_w,
                            int doc_h, Paint mode, float margin) {
    std::vector<AddRegion> regions;
    for (const HeldRegion& h : held) regions.push_back(expand_region(h));
    SamResult r = prepare(std::move(frame_key), std::move(regions), doc_w, doc_h,
                          mode, margin, 0.0f, false);
    r.held = std::move(held);
    r.margin_job = true;
    return r;
}

void MaskSam::publish(State& s, SamResult r) {
    std::lock_guard<std::mutex> lk(s.mu);
    s.result = std::move(r);
    s.ready = true;
    s.status.clear();
}

void MaskSam::margin_begin(State& s) {
    std::lock_guard<std::mutex> lk(s.mu);
    s.status = msg::sam_working.get();
}

void MaskSam::margin_end(State& s, const std::string& job_error) {
    std::lock_guard<std::mutex> lk(s.mu);
    s.status.clear();
    if (!job_error.empty()) s.error = job_error;
}

void MaskSam::post_result(std::string frame_key, std::vector<AddRegion> regions, int doc_w,
                          int doc_h, Paint mode, float margin, float score, double ms,
                          const std::vector<AddRegion>& veto) {
    SamResult r = prepare(std::move(frame_key), std::move(regions), doc_w, doc_h, mode, margin,
                          score, true, veto);
    r.ms = ms;
    publish(*_s, std::move(r));
}

bool MaskSam::take_result(SamResult& out) {
    std::lock_guard<std::mutex> lk(_s->mu);
    if (!_s->ready) return false;
    _s->ready = false;
    out = std::move(_s->result);
    _s->result = SamResult{};
    return true;
}

// Joins any job first (release_device), so nothing it writes can land after.
bool MaskSam::release() {
    release_device();
    std::lock_guard<std::mutex> lk(_s->mu);
    const bool discarded = _s->ready;
    _s->ready = false;
    _s->result = SamResult{};
    _s->status.clear();
    _s->error.clear();
    return discarded;
}

void MaskSam::refuse(const std::string& reason) {
    std::lock_guard<std::mutex> lk(_s->mu);
    _s->status.clear();
    _s->error = reason;
}

#ifdef SS_BUILD_SAM

struct MaskSam::Job {
    std::string model, device, frame_key, phrases, negative;
    std::shared_ptr<const std::vector<uint8_t>> rgb;
    int fw = 0, fh = 0, doc_w = 0, doc_h = 0;
    std::vector<SamPoint> points;
    Paint mode = Paint::ForceDrop;
    float margin = 0.0f;
    bool text = false;
    int max_size = 0;
    float score_threshold = 0.5f, nms_threshold = 0.1f;
};

namespace {

std::atomic<int> g_loads{0};

// The MiB on the TOTAL line of Session::vramReport(); -1 when there is none.
double total_mib(const std::string& report) {
    const size_t at = report.find("TOTAL");
    return at == std::string::npos ? -1.0 : std::strtod(report.c_str() + at + 5, nullptr);
}

}  // namespace

bool MaskSam::available() { return true; }
int MaskSam::load_count() { return g_loads.load(); }

double MaskSam::pool_mib() {
    return (double)nn::vk::VramPool::get().totalCapacity() / 1048576.0;
}

bool MaskSam::text_supported() const {
    std::lock_guard<std::mutex> lk(_s->mu);
    return _s->loaded ? _s->loaded_text : _s->text_hint;
}

bool MaskSam::busy() const { return _s->running.load(); }

void MaskSam::cancel() { _s->cancel = true; }

void MaskSam::release_device() {
    _s->cancel = true;
    if (_s->worker.joinable()) _s->worker.join();
    if (_s->session) _s->session->unload();
    _s->session.reset();
    _s->loaded_model.clear();
    _s->encoded_key.clear();
    std::lock_guard<std::mutex> lk(_s->mu);
    _s->loaded = false;
    _s->loaded_text = false;
    _s->vram_mib = -1.0;
}

double MaskSam::vram_mib() const {
    std::lock_guard<std::mutex> lk(_s->mu);
    return _s->vram_mib;
}

bool MaskSam::start_points(const std::string& frame_key,
                           std::shared_ptr<const std::vector<uint8_t>> rgb, int fw, int fh,
                           int doc_w, int doc_h, std::vector<SamPoint> points, Paint mode,
                           float margin) {
    // SAM needs a "this" to exclude a "not this" from.
    if (std::none_of(points.begin(), points.end(), [](const SamPoint& p) { return p.positive; }))
        return false;
    Job j;
    j.frame_key = frame_key;
    j.rgb = std::move(rgb);
    j.fw = fw;
    j.fh = fh;
    j.doc_w = doc_w;
    j.doc_h = doc_h;
    j.points = std::move(points);
    j.mode = mode;
    j.margin = margin;
    return launch(std::move(j));
}

// A phrase names what to DROP. The editor's own settings cap the encode and
// set the thresholds, read here on the UI thread so the job never touches them.
bool MaskSam::start_text(const std::string& frame_key,
                         std::shared_ptr<const std::vector<uint8_t>> rgb, int fw, int fh,
                         int doc_w, int doc_h, const std::string& phrases, float margin) {
    if (!text_supported()) {
        refuse(msg::sam_text_unsupported.get());
        return false;
    }
    Job j;
    j.frame_key = frame_key;
    j.rgb = std::move(rgb);
    j.fw = fw;
    j.fh = fh;
    j.doc_w = doc_w;
    j.doc_h = doc_h;
    j.phrases = phrases;
    j.negative = _s->prompt.negative_prompt;
    j.margin = margin;
    j.text = true;
    j.max_size = _s->prompt.max_image_size;
    j.score_threshold = _s->prompt.threshold;
    j.nms_threshold = _s->prompt.nms;
    return launch(std::move(j));
}

// The same worker and hand-off as a prompt, so the two can never land out of
// order; the ~150-300 ms of stencil work at 15520x7760 stays off the UI thread.
bool MaskSam::start_margin(std::string frame_key, std::vector<HeldRegion> held, int doc_w,
                           int doc_h, Paint mode, float margin) {
    if (busy() || held.empty()) return false;
    if (_s->worker.joinable()) _s->worker.join();
    margin_begin(*_s);
    _s->cancel = false;
    _s->running = true;
    State* s = _s.get();
    try {
        _s->worker = std::thread([s, key = std::move(frame_key), held = std::move(held), doc_w,
                                  doc_h, mode, margin]() mutable {
            auto finish = [s](const std::string& error) {
                margin_end(*s, error);
                s->running = false;
            };
            run_guarded(
                [&] {
                    const auto t0 = std::chrono::steady_clock::now();
                    publish_unless_cancelled(
                        [&] {
                            SamResult r =
                                remargin(std::move(key), std::move(held), doc_w, doc_h, mode,
                                         margin);
                            r.ms = std::chrono::duration<double, std::milli>(
                                       std::chrono::steady_clock::now() - t0).count();
                            return r;
                        },
                        [s] { return s->cancel.load(); },
                        [s](SamResult r) { publish(*s, std::move(r)); });
                    finish(std::string());
                },
                finish);
        });
    } catch (const std::exception& e) {
        _s->running = false;
        refuse(e.what());
        return false;
    }
    return true;
}

// Refuses while a job runs, so at most one frame buffer is ever held here; a
// refused job's reference dies with `j` on return.
bool MaskSam::launch(Job j) {
    if (_s->model.empty() || !j.rgb || j.fw <= 0 || j.fh <= 0 ||
        j.rgb->size() != (size_t)j.fw * (size_t)j.fh * 3u || busy())
        return false;
    if (_s->worker.joinable()) _s->worker.join();
    j.model = _s->model;
    j.device = _s->device;
    const bool warm = _s->session && _s->loaded_model == j.model;
    {
        std::lock_guard<std::mutex> lk(_s->mu);
        _s->error.clear();
        _s->status = warm ? msg::sam_working.get() : msg::sam_first_load.get();
    }
    _s->cancel = false;
    _s->running = true;
    State* s = _s.get();
    try {
        _s->worker = std::thread([s, j = std::move(j)]() mutable { run(*s, std::move(j)); });
    } catch (const std::exception& e) {
        _s->running = false;
        refuse(e.what());
        return false;
    }
    return true;
}

// The job thread. A throw, the 361 MB frame copy's bad_alloc among them, ends
// the job with the reason in error (run_guarded).
void MaskSam::run(State& s, Job j) {
    auto finish = [&s](const std::string& error) {
        {
            std::lock_guard<std::mutex> lk(s.mu);
            s.status.clear();
            s.error = error;
        }
        s.running = false;
    };
    run_guarded([&] { run_stages(s, std::move(j), finish); }, finish);
}

// `cancel` is read between stages, never inside one. Measured at 15520x7760
// (M5 Pro, q4_0): a load is ~2.5 s, an encode 1.9 s with its upload, and three
// unexplained runs took 3.3 s; a cancel waits out whichever stage it lands in.
void MaskSam::run_stages(State& s, Job j, const std::function<void(const std::string&)>& finish) {
    const auto t0 = std::chrono::steady_clock::now();
    if (!s.session || s.loaded_model != j.model) {
        if (s.session) s.session->unload();
        s.session = std::make_unique<sam::Session>();
        s.loaded_model.clear();
        s.encoded_key.clear();
        sam::ModelParams p;
        p.model_path = j.model;
        p.device = j.device;
        g_loads++;
        if (!s.session->loadModel(p)) {
            const std::string e = s.session->lastError();
            s.session.reset();
            finish(e);
            return;
        }
        s.loaded_model = j.model;
        const double mib = total_mib(s.session->vramReport());
        std::lock_guard<std::mutex> lk(s.mu);
        s.loaded = true;
        s.loaded_text = s.session->supportsTextPrompts();
        s.vram_mib = mib;
        s.status = msg::sam_working.get();
    }
    if (s.cancel) {
        finish(std::string());
        return;
    }
    if (j.text && !s.session->supportsTextPrompts()) {
        finish(msg::sam_text_unsupported.get());
        return;
    }
    // Masks come back at the ENCODED size, so a capped text encode and a full
    // click encode of the same frame are different keys; switching re-encodes.
    const std::string key = j.frame_key + (j.text ? "#capped" : "#full");
    if (s.encoded_key != key) {
        s.encoded_key.clear();
        nn::Image img;
        img.width = j.fw;
        img.height = j.fh;
        img.channels = 3;
        img.data.assign(j.rgb->begin(), j.rgb->end());
        j.rgb.reset();
        if (j.text) img = sam::downscale_to_fit(img, j.max_size);
        if (s.cancel) {
            finish(std::string());
            return;
        }
        if (!s.session->encodeImage(img)) {
            finish(s.session->lastError());
            return;
        }
        s.encoded_key = key;
    }
    j.rgb.reset();
    sam::Result r;
    std::vector<AddRegion> veto;
    if (j.text) {
        for (const std::string& phrase : sam::split_phrases(j.phrases)) {
            if (s.cancel) break;
            sam::ConceptPrompt cp;
            cp.text = phrase;
            cp.score_threshold = j.score_threshold;
            cp.nms_threshold = j.nms_threshold;
            sam::Result one = s.session->segmentConcept(cp);
            for (sam::Detection& d : one.detections) r.detections.push_back(std::move(d));
        }
        // The exception chips' phrases, off the same encode, so every plane matches.
        for (const std::string& phrase : sam::split_phrases(j.negative)) {
            if (s.cancel || r.detections.empty()) break;
            sam::ConceptPrompt cp;
            cp.text = phrase;
            cp.score_threshold = j.score_threshold;
            cp.nms_threshold = j.nms_threshold;
            sam::Result neg = s.session->segmentConcept(cp);
            for (sam::Detection& d : neg.detections) {
                AddRegion v;
                v.w = d.mask.width;
                v.h = d.mask.height;
                v.mask = std::move(d.mask.data);
                veto.push_back(std::move(v));
            }
        }
    } else if (!s.cancel) {
        sam::VisualPrompt vp;
        for (const SamPoint& p : j.points)
            (p.positive ? vp.pos_points : vp.neg_points).push_back(sam::Point{p.x, p.y});
        r = s.session->segmentVisual(vp);
    }
    if (s.cancel) {
        finish(std::string());
        return;
    }
    if (r.detections.empty() && !s.session->lastError().empty()) {
        finish(s.session->lastError());
        return;
    }
    std::vector<AddRegion> out;
    float best = 0.0f;
    for (sam::Detection& d : r.detections) {
        AddRegion g;
        g.w = d.mask.width;
        g.h = d.mask.height;
        g.mask = std::move(d.mask.data);
        g.score = d.score;
        g.box = RegionBox{d.box.x0, d.box.y0, d.box.x1, d.box.y1, true};
        best = std::max(best, d.score);
        out.push_back(std::move(g));
    }
    const double mib = total_mib(s.session->vramReport());
    {
        std::lock_guard<std::mutex> lk(s.mu);
        s.vram_mib = mib;
    }
    // The stencil takes ~150 ms at 15520x7760; an Esc during it must still win.
    const bool published = publish_unless_cancelled(
        [&] {
            SamResult res = prepare(j.frame_key, std::move(out), j.doc_w, j.doc_h, j.mode,
                                    j.margin, best, !j.text, veto);
            res.ms = std::chrono::duration<double, std::milli>(
                         std::chrono::steady_clock::now() - t0).count();
            return res;
        },
        [&s] { return s.cancel.load(); }, [&s](SamResult res) { publish(s, std::move(res)); });
    if (published) s.running = false;
    else finish(std::string());
}

#endif  // SS_BUILD_SAM

#ifndef SS_BUILD_SAM

bool MaskSam::available() { return false; }
int MaskSam::load_count() { return 0; }
double MaskSam::pool_mib() { return -1.0; }
bool MaskSam::text_supported() const { return false; }
bool MaskSam::busy() const { return false; }
void MaskSam::cancel() {}
void MaskSam::release_device() {}
double MaskSam::vram_mib() const { return -1.0; }

bool MaskSam::start_points(const std::string&, std::shared_ptr<const std::vector<uint8_t>>, int,
                           int, int, int, std::vector<SamPoint>, Paint, float) {
    refuse(msg::sam_unavailable_build.get());
    return false;
}
bool MaskSam::start_text(const std::string&, std::shared_ptr<const std::vector<uint8_t>>, int,
                         int, int, int, const std::string&, float) {
    refuse(msg::sam_unavailable_build.get());
    return false;
}

bool MaskSam::start_margin(std::string frame_key, std::vector<HeldRegion> held, int doc_w,
                           int doc_h, Paint mode, float margin) {
    if (held.empty()) return false;
    margin_begin(*_s);
    publish(*_s, remargin(std::move(frame_key), std::move(held), doc_w, doc_h, mode, margin));
    margin_end(*_s, std::string());
    return true;
}

#endif  // !SS_BUILD_SAM

bool MaskSam::has_result() const {
    std::lock_guard<std::mutex> lk(_s->mu);
    return _s->ready;
}

}  // namespace mask
}  // namespace gui
