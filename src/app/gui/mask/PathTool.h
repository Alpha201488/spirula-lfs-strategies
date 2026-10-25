#pragma once

// The pen tool: anchors dropped along an edge, each joined to the next by
// the livewire's lowest-cost path (a straight segment with no livewire),
// closed by clicking the first anchor, Enter or a right click. Fed one
// ViewportInput a frame in a panel's own pixels; keeps its points in the
// livewire's frame pixels through PathSpace, so the view may zoom mid-path.
// No ImGui: PathOverlay.cpp draws it. Keys: docs/notes/mask-editor.md.

#include "app/gui/ViewportInput.h"

#include <cstddef>
#include <functional>
#include <vector>

namespace gui {
namespace mask {

class Livewire;

// Fed pixels <-> the livewire's frame pixels. Identity while a callback is unset.
struct PathSpace {
    std::function<void(float x, float y, float& fx, float& fy)> to_frame;
    std::function<void(float fx, float fy, float& x, float& y)> from_frame;
};

inline constexpr float kPathCloseRadius = 10.0f;   // fed pixels, as EditTool's
inline constexpr int kPathMinAnchors = 3;

class PathTool {
public:
    void set_livewire(Livewire* lw);
    void set_space(const PathSpace& s) { _space = s; }
    bool snapping() const;
    bool in_progress() const { return !_anchors.empty(); }
    int anchor_count() const { return (int)(_anchors.size() / 2); }

    // One frame. True when the path closed: `out` is the closed polyline as
    // x,y pairs in fed pixels. `consumed` says the left button was the tool's.
    bool update(const ViewportInput& in, std::vector<float>& out, bool& consumed);
    bool commit_pending(std::vector<float>& out);
    void cancel();
    bool pop_anchor();

    // For the overlay, all in fed pixels.
    void overlay(std::vector<float>& anchors, std::vector<float>& committed,
                 std::vector<float>& live) const;
    bool near_first() const;
    double last_segment_ms() const { return _last_ms; }

    // A pen has no drag to read a held modifier off at release: call every
    // frame with the live modifiers. They mirror while idle and freeze on
    // the first anchor, however the path later closes or cancels.
    void note_modifiers(bool shift, bool ctrl);
    bool mode_shift() const { return _mode_shift; }
    bool mode_ctrl() const { return _mode_ctrl; }

private:
    void to_frame(float x, float y, float& fx, float& fy) const;
    void from_frame(float fx, float fy, float& x, float& y) const;
    void to_fed(const std::vector<float>& frame_pts, std::vector<float>& out) const;
    void segment_to(float fx, float fy, std::vector<float>& out);
    void refresh_live(float fx, float fy);
    void seed();

    Livewire* _lw = nullptr;
    PathSpace _space;
    std::vector<float> _anchors;      // frame px
    std::vector<size_t> _seg_start;   // size of _committed before each anchor's segment
    std::vector<float> _committed;    // frame px, first anchor through the last
    std::vector<float> _live;         // frame px, last anchor to the cursor
    int _live_gx = -1, _live_gy = -1;
    float _cur[2] = {0.0f, 0.0f};     // fed px
    double _last_ms = 0.0;
    bool _mode_shift = false, _mode_ctrl = false;
};

}  // namespace mask
}  // namespace gui
