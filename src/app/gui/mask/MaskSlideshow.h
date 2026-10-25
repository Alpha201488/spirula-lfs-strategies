#pragma once

// The slideshow's decoder: slide_threads' count of threads that turn frames into
// pane-sized Pictures (the composite tinted over the photo) a little ahead of the
// one on screen, held in a ring under FilmReel's byte and slot budget that keeps
// its buffers while playing, plus the clock that paces playback. No ImGui, no GL
// calls. Design: docs/notes/mask-editor.md.

#include "app/gui/FilmReel.h"
#include "app/gui/Picture.h"

#include <algorithm>
#include <condition_variable>
#include <cstddef>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace gui {
namespace mask {

struct SlideFrame {
    std::string image;
    std::string mask;       // "" for none
    bool flipped = false;   // the mask folder's 255 is drop
};

// What size_picture (Picture.cpp:71-83) produces for a w x h source at this
// target: a whole-pixel box step, never upscaling. An unknown source gets the
// strict upper bound, since the box step leaves dw and dh each at most target.
inline size_t slide_picture_bytes(int src_w, int src_h, int target) {
    if (target <= 0) target = 1;
    if (src_w <= 0 || src_h <= 0) return (size_t)target * (size_t)target * 3u;
    const int step = std::max(1, (std::max(src_w, src_h) + target - 1) / target);
    return (size_t)std::max(1, src_w / step) * (size_t)std::max(1, src_h / step) * 3u;
}

// How many frames to hold AHEAD of the one shown: what the byte budget
// affords, never past the slot count or the frames that are not it. Floor 1 --
// a window of two the budget cannot hold evicts the frame needed next.
inline int slide_depth(size_t picture_bytes, int frames) {
    const int room = std::min((int)kReelSlots - 1, frames - 1);
    if (room <= 1) return std::max(0, room);
    const int fits = picture_bytes ? (int)(kReelBudget / picture_bytes) : (int)kReelSlots;
    return std::clamp(fits, 1, room);
}

inline constexpr size_t kSlideDecodeBudget = 300u << 20;

// What one stb decode of a w x h JPEG holds at its peak: the 4:2:0 planes and the RGB
// output, 4.5 bytes a pixel (126.6 MB measured on 7680x3840). 4:4:4 is 6 and over-runs by a third.
inline size_t slide_decode_bytes(int w, int h) {
    return w > 0 && h > 0 ? (size_t)w * (size_t)h * 9u / 2u : 0;
}

// Decoders to run at once under kSlideDecodeBudget: 2 at 8K, 4 at 4K and below, never more
// than the machine's cores minus one, never more than 4. Unknown size decodes one at a time.
inline int slide_threads(int w, int h, unsigned hardware_threads) {
    const int cap = std::clamp((int)hardware_threads - 1, 1, 4);
    const size_t one = slide_decode_bytes(w, h);
    if (one == 0) return 1;
    return std::clamp((int)std::min<size_t>(kSlideDecodeBudget / one, 4), 1, cap);
}

class SlidePrefetch {
public:
    SlidePrefetch() = default;
    ~SlidePrefetch() { stop(); }
    SlidePrefetch(const SlidePrefetch&) = delete;
    SlidePrefetch& operator=(const SlidePrefetch&) = delete;

    // start, stop, set_target, want and the test hook are the owner's, from
    // one thread; has, take, bytes, decoded and running are safe from any.
    void start(std::vector<SlideFrame> frames, int threads);
    // Joins the threads and drops the ring.
    void stop();
    // stop() without the join: a decode in flight ends on its own, unput, and
    // stop(), start() or the destructor joins it. For the UI thread.
    void halt();
    bool running() const;
    // The pane's long edge, as FilmReel sizes its pictures.
    void set_target(int side);
    // The frames to hold: `count` from `from` on, wrapping. Anything held
    // outside that window is dropped. Size it with slide_depth().
    void want(int from, int count);
    bool has(int index) const;
    // Swaps the picture into `out` and keeps out's old buffer, cleared, in the
    // ring; taking the window's front steps the window past it. Take the frame
    // shown, then want() the next window: a want() first evicts it unshown.
    bool take(int index, Picture& out);
    size_t bytes() const;
    int decoded() const;
    // Pictures the decoders had to grow a buffer for, and what the ring's slots hold.
    int picture_allocs() const;
    size_t capacity_bytes() const;
    // Test-only: shrinks the ring's byte budget so eviction is reachable
    // without a 64 MB fixture. Defaults to kReelBudget; call it before start().
    void set_byte_budget_for_test(size_t bytes) {
        std::lock_guard<std::mutex> lk(_mu);
        _budget = bytes;
    }

private:
    struct Slot {
        int index = -1;
        Picture pic;
    };
    void worker();
    bool wanted_locked(int index) const;
    int pick_locked() const;
    void put_locked(int index, Picture& pic);

    std::vector<std::thread> _threads;   // start() and stop() alone
    std::condition_variable _cv;
    mutable std::mutex _mu;              // guards every member below
    bool _stop = false;
    bool _running = false;
    std::vector<SlideFrame> _frames;
    int _target = 1024;
    int _from = 0, _count = 0;
    size_t _budget = kReelBudget;
    std::vector<int> _inflight;
    Slot _slots[kReelSlots];
    size_t _bytes = 0;
    int _decoded = 0;
    int _picture_allocs = 0;
};

// Paces playback. The period runs from the frame actually shown, so a late
// frame never queues up a burst of catch-up frames.
struct SlideClock {
    double fps = 10.0;
    double next = 0.0;
    void start(double now) { next = now + 1.0 / fps; }
    bool due(double now) {
        if (now < next) return false;
        next = now + 1.0 / fps;
        return true;
    }
};

}  // namespace mask
}  // namespace gui
