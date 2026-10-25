// MaskSlideshow.cpp -- see MaskSlideshow.h.

#include "app/gui/mask/MaskSlideshow.h"

#include <algorithm>
#include <utility>

namespace gui {
namespace mask {

void SlidePrefetch::start(std::vector<SlideFrame> frames, int threads) {
    stop();
    {
        std::lock_guard<std::mutex> lk(_mu);
        _frames = std::move(frames);
        _stop = false;
        _running = true;
        _from = 0;
        _count = 0;
        _inflight.clear();
        _decoded = 0;
        _picture_allocs = 0;
    }
    const int n = std::clamp(threads, 1, 8);
    for (int i = 0; i < n; i++) _threads.emplace_back([this] { worker(); });
}

void SlidePrefetch::stop() {
    {
        std::lock_guard<std::mutex> lk(_mu);
        _stop = true;
        _running = false;
    }
    _cv.notify_all();
    for (std::thread& t : _threads) t.join();
    _threads.clear();
    std::lock_guard<std::mutex> lk(_mu);
    for (Slot& s : _slots) s = Slot{};
    _bytes = 0;
    _inflight.clear();
    _count = 0;
}

// _inflight is left alone: each worker erases its own index when its decode ends.
void SlidePrefetch::halt() {
    {
        std::lock_guard<std::mutex> lk(_mu);
        _stop = true;
        _running = false;
        for (Slot& s : _slots) s = Slot{};
        _bytes = 0;
        _count = 0;
    }
    _cv.notify_all();
}

// A flag, not the thread vector: start() and stop() push and clear _threads
// outside the lock, so reading it under the lock advertises a safety it does
// not have.
bool SlidePrefetch::running() const {
    std::lock_guard<std::mutex> lk(_mu);
    return _running;
}

void SlidePrefetch::set_target(int side) {
    std::lock_guard<std::mutex> lk(_mu);
    _target = std::max(side, 1);
}

bool SlidePrefetch::wanted_locked(int index) const {
    const int n = (int)_frames.size();
    if (n == 0 || index < 0 || index >= n) return false;
    const int d = ((index - _from) % n + n) % n;
    return d < _count;
}

void SlidePrefetch::want(int from, int count) {
    {
        std::lock_guard<std::mutex> lk(_mu);
        const int n = (int)_frames.size();
        _from = n ? ((from % n) + n) % n : 0;
        _count = std::clamp(count, 0, std::min(n, (int)kReelSlots));
        for (Slot& s : _slots)
            if (s.index >= 0 && !wanted_locked(s.index)) {
                _bytes -= s.pic.bytes();
                s.index = -1;
                s.pic.rgb.clear();
            }
    }
    _cv.notify_all();
}

bool SlidePrefetch::has(int index) const {
    std::lock_guard<std::mutex> lk(_mu);
    for (const Slot& s : _slots)
        if (s.index == index) return true;
    return false;
}

// Taking the front of the window moves the window past it under this lock, so no
// decoder re-picks the frame before the caller's want(), which then notifies.
bool SlidePrefetch::take(int index, Picture& out) {
    std::lock_guard<std::mutex> lk(_mu);
    for (Slot& s : _slots)
        if (s.index == index) {
            std::swap(out, s.pic);
            s.pic.rgb.clear();
            s.index = -1;
            _bytes -= out.bytes();
            if (_count > 0 && index == _from) {
                _from = (_from + 1) % (int)_frames.size();
                _count--;
            }
            return true;
        }
    return false;
}

size_t SlidePrefetch::bytes() const {
    std::lock_guard<std::mutex> lk(_mu);
    return _bytes;
}

int SlidePrefetch::decoded() const {
    std::lock_guard<std::mutex> lk(_mu);
    return _decoded;
}

int SlidePrefetch::picture_allocs() const {
    std::lock_guard<std::mutex> lk(_mu);
    return _picture_allocs;
}

size_t SlidePrefetch::capacity_bytes() const {
    std::lock_guard<std::mutex> lk(_mu);
    size_t n = 0;
    for (const Slot& s : _slots) n += s.pic.rgb.capacity();
    return n;
}

// The first wanted index, from the front of the window, that is neither
// held nor being decoded.
int SlidePrefetch::pick_locked() const {
    const int n = (int)_frames.size();
    for (int k = 0; k < _count && k < n; k++) {
        const int idx = (_from + k) % n;
        bool held = false;
        for (const Slot& s : _slots) held = held || s.index == idx;
        if (held) continue;
        if (std::find(_inflight.begin(), _inflight.end(), idx) != _inflight.end()) continue;
        return idx;
    }
    return -1;
}

// Swaps the decoder's picture into a free slot, so the decoder takes that
// slot's cleared buffer back for its next frame.
void SlidePrefetch::put_locked(int index, Picture& pic) {
    Slot* pick = nullptr;
    for (Slot& s : _slots)
        if (s.index < 0) { pick = &s; break; }
    // Over budget: evict the held frame farthest from the front of the window,
    // the one needed last. A free slot always exists while _count is clamped
    // to kReelSlots, so the !pick arm is a guard against that, not a path.
    while (!pick || _bytes + pic.bytes() > _budget) {
        Slot* far_slot = nullptr;
        int far_d = -1;
        const int n = (int)_frames.size();
        for (Slot& s : _slots) {
            if (s.index < 0 || &s == pick) continue;
            const int d = ((s.index - _from) % n + n) % n;
            if (d > far_d) { far_d = d; far_slot = &s; }
        }
        if (!far_slot) break;
        _bytes -= far_slot->pic.bytes();
        far_slot->index = -1;
        far_slot->pic.rgb.clear();
        if (!pick) pick = far_slot;
    }
    if (!pick) return;
    pick->index = index;
    std::swap(pick->pic, pic);
    pic.rgb.clear();
    _bytes += pick->pic.bytes();
}

// Each decoder keeps one picture for its lifetime, swapped with the ring's on
// every put.
void SlidePrefetch::worker() {
    Picture mine;
    for (;;) {
        int index = -1;
        SlideFrame f;
        int target = 0;
        {
            std::unique_lock<std::mutex> lk(_mu);
            _cv.wait(lk, [&] { return _stop || (index = pick_locked()) >= 0; });
            if (_stop) return;
            _inflight.push_back(index);
            f = _frames[(size_t)index];
            target = _target;
        }
        const size_t before = mine.rgb.capacity();
        // A decode that throws would be std::terminate off a worker thread;
        // an empty picture is what a missing file already produces.
        try {
            load_picture(f.image, f.mask, target, mine, f.flipped);
        } catch (...) {
            mine.rgb.clear();
        }
        std::lock_guard<std::mutex> lk(_mu);
        _inflight.erase(std::find(_inflight.begin(), _inflight.end(), index));
        _decoded++;
        _picture_allocs += mine.rgb.capacity() > before;
        if (_stop || !wanted_locked(index)) continue;
        put_locked(index, mine);
    }
}

}  // namespace mask
}  // namespace gui
