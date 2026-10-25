#pragma once

// The mask editor's SAM half: the checkpoint, the editor's own prompt state and
// a dedicated job thread. Fully pimpl'd and sam::-free, so MaskSession.h -- which
// mask_doc_test compiles -- can hold one without the inference layer existing.
// The whole model call is #ifdef SS_BUILD_SAM inside MaskSam.cpp.

#include "app/gui/mask/MaskAdd.h"

#include <functional>
#include <memory>
#include <string>
#include <vector>

namespace gui {

struct MaskSettings;

namespace mask {

// Runs `body`; a throw of any kind becomes one `on_throw(reason)` call rather
// than std::terminate on the job thread.
void run_guarded(const std::function<void()>& body,
                 const std::function<void(const std::string&)>& on_throw);

// A finished job, its stencil built at the document's size on the thread that
// finished it, so the UI thread only paints. `landed` false: no pixel landed.
// A click's drop also holds its detections, so the margin can be re-applied.
struct SamResult {
    std::string frame_key;
    Paint mode = Paint::ForceDrop;
    float score = 0.0f;
    double ms = 0.0;
    int detections = 0;
    bool landed = false;
    Stencil stencil;
    Rect bounds;
    int64_t set_px = 0;
    std::vector<HeldRegion> held;
    bool margin_job = false;    // start_margin()'s, not a prompt's
    bool vetoed_all = false;    // it matched, and the exceptions cleared every pixel
};

// A job's tail: `build` the result, THEN read `cancelled`, so an Esc during the
// ~150 ms stencil build still wins; only then `publish`. True if it published.
bool publish_unless_cancelled(const std::function<SamResult()>& build,
                              const std::function<bool()>& cancelled,
                              const std::function<void(SamResult)>& publish);

struct SamPoint {
    float x = 0.0f, y = 0.0f;   // frame pixels
    bool positive = true;       // false: "not this", as SegmentPanel's right click
};

class MaskSam {
public:
    MaskSam();
    ~MaskSam();
    MaskSam(const MaskSam&) = delete;
    MaskSam& operator=(const MaskSam&) = delete;

    // False in a build with no inference layer; every start_* then refuses.
    static bool available();
    // The inference layer's whole device pool, MiB, with or without a session;
    // -1 when there is no inference layer.
    static double pool_mib();

    // `text_prompts` is the catalog's word for the checkpoint, trusted until a
    // load answers for itself.
    void set_model(const std::string& path, bool text_prompts);
    const std::string& model_path() const;
    // The device the app froze for inference, passed to every load.
    void set_device(const std::string& selector);
    const std::string& device() const;
    bool has_model() const;
    bool text_supported() const;
    bool busy() const;
    void cancel();
    // Joins any job, hands the weights back and forgets status, error and any
    // untaken result -- true if there was one. Keeps the model path and clicks.
    bool release();
    // The session's own TOTAL, MiB, as of the last job; -1 with no session.
    double vram_mib() const;
    // loadModel calls in this process, by any MaskSam: a reload is +1, a
    // session that survived a release is +0. 0 with no inference layer.
    static int load_count();

    // The editor's own prompt state -- never the dataset screen's.
    MaskSettings& prompt();
    const MaskSettings& prompt() const;
    // A click joins prompt().current_object on `frame` (a MaskSession frame
    // index) and `camera`; object_points() is what a prompt then sends.
    void add_click(long long frame, const std::string& camera, float x, float y,
                   bool positive = true);
    std::vector<SamPoint> object_points(long long frame, const std::string& camera) const;
    // What a click sends: object_points(), then the click itself.
    std::vector<SamPoint> prompt_points(long long frame, const std::string& camera,
                                        SamPoint click) const;

    // The job co-owns `rgb`, so the caller may drop its copy at once. `points`
    // are frame pixels, `phrases` semicolon separated, and prompt().negative_prompt
    // vetoes what they find; the stencil is doc_w x doc_h, `margin` via add_margin().
    bool start_points(const std::string& frame_key,
                      std::shared_ptr<const std::vector<uint8_t>> rgb, int fw, int fh,
                      int doc_w, int doc_h, std::vector<SamPoint> points, Paint mode,
                      float margin);
    bool start_text(const std::string& frame_key,
                    std::shared_ptr<const std::vector<uint8_t>> rgb, int fw, int fh,
                    int doc_w, int doc_h, const std::string& phrases, float margin);
    // Rebuilds a held add at `margin` on the job thread; no model is needed. A
    // build with no inference layer rebuilds inline. The result keeps `held`.
    bool start_margin(std::string frame_key, std::vector<HeldRegion> held, int doc_w, int doc_h,
                      Paint mode, float margin);
    // One finished job, or false with `out` untouched.
    bool take_result(SamResult& out);
    // A finished job take_result() has not handed over yet.
    bool has_result() const;

    std::string status() const;
    std::string error() const;
    // A prompt refused before it reached the job: `reason` becomes error().
    void refuse(const std::string& reason);
    // Clears error() only if it still reads `reason`, and says whether it did.
    bool clear_error_if(const std::string& reason);
    // The job's hand-off of a finished result, stencil built on the calling
    // thread; public so a test can stand in for the job in a build without SAM.
    void post_result(std::string frame_key, std::vector<AddRegion> regions, int doc_w,
                     int doc_h, Paint mode, float margin, float score, double ms,
                     const std::vector<AddRegion>& veto = {});

private:
    struct State;
    struct Job;
    bool launch(Job job);
    void release_device();   // the SAM-only half of release()
    static SamResult prepare(std::string frame_key, std::vector<AddRegion> regions, int doc_w,
                             int doc_h, Paint mode, float margin, float score, bool hold,
                             const std::vector<AddRegion>& veto = {});
    static SamResult remargin(std::string frame_key, std::vector<HeldRegion> held, int doc_w,
                              int doc_h, Paint mode, float margin);
    static void publish(State& s, SamResult r);
    // A margin job's status, in both builds. It leaves error() alone unless it
    // fails itself: a slider release must not wipe a pause's reason.
    static void margin_begin(State& s);
    static void margin_end(State& s, const std::string& job_error);
    static void run(State& s, Job job);
    static void run_stages(State& s, Job job,
                           const std::function<void(const std::string&)>& finish);
    std::unique_ptr<State> _s;
};

}  // namespace mask
}  // namespace gui
