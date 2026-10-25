// PathTool.cpp -- see PathTool.h.

#include "app/gui/mask/PathTool.h"

#include "app/gui/mask/Livewire.h"

#include <chrono>
#include <cmath>

namespace gui {
namespace mask {

void PathTool::set_livewire(Livewire* lw) {
    _lw = lw;
    _live.clear();
    _live_gx = _live_gy = -1;
    seed();
}

bool PathTool::snapping() const { return _lw && _lw->ready(); }

void PathTool::to_frame(float x, float y, float& fx, float& fy) const {
    if (_space.to_frame) {
        _space.to_frame(x, y, fx, fy);
    } else {
        fx = x;
        fy = y;
    }
}

void PathTool::from_frame(float fx, float fy, float& x, float& y) const {
    if (_space.from_frame) {
        _space.from_frame(fx, fy, x, y);
    } else {
        x = fx;
        y = fy;
    }
}

void PathTool::to_fed(const std::vector<float>& frame_pts, std::vector<float>& out) const {
    out.resize(frame_pts.size());
    for (size_t i = 0; i + 1 < frame_pts.size(); i += 2)
        from_frame(frame_pts[i], frame_pts[i + 1], out[i], out[i + 1]);
}

void PathTool::seed() {
    if (!snapping() || _anchors.empty()) return;
    int gx, gy;
    _lw->to_grid(_anchors[_anchors.size() - 2], _anchors.back(), gx, gy);
    _lw->set_anchor(gx, gy);
}

// The lowest-cost path from the last anchor to (fx, fy), both ends exact.
void PathTool::segment_to(float fx, float fy, std::vector<float>& out) {
    out.clear();
    const float ax = _anchors[_anchors.size() - 2], ay = _anchors.back();
    if (snapping() && _lw->has_anchor()) {
        const auto t0 = std::chrono::steady_clock::now();
        int gx, gy;
        _lw->to_grid(fx, fy, gx, gy);
        std::vector<int> grid;
        if (_lw->path_to(gx, gy, grid)) {
            out.reserve(grid.size());
            for (size_t i = 0; i + 1 < grid.size(); i += 2) {
                float px, py;
                _lw->to_frame(grid[i], grid[i + 1], px, py);
                out.push_back(px);
                out.push_back(py);
            }
        }
        _last_ms = std::chrono::duration<double, std::milli>(
                       std::chrono::steady_clock::now() - t0).count();
    }
    if (out.size() < 4) out = {ax, ay, fx, fy};
    out[0] = ax;
    out[1] = ay;
    out[out.size() - 2] = fx;
    out[out.size() - 1] = fy;
}

// Re-walks the search only when the cursor changed grid cell; inside one
// cell only the exact end point moves.
void PathTool::refresh_live(float fx, float fy) {
    if (snapping()) {
        int gx, gy;
        _lw->to_grid(fx, fy, gx, gy);
        if (gx == _live_gx && gy == _live_gy && _live.size() >= 4) {
            _live[_live.size() - 2] = fx;
            _live[_live.size() - 1] = fy;
            return;
        }
        _live_gx = gx;
        _live_gy = gy;
    }
    segment_to(fx, fy, _live);
}

bool PathTool::update(const ViewportInput& in, std::vector<float>& out, bool& consumed) {
    consumed = false;
    _cur[0] = in.x;
    _cur[1] = in.y;
    if (in.hovered && in.clicked) {
        consumed = true;
        if (anchor_count() >= kPathMinAnchors && near_first()) return commit_pending(out);
        float fx, fy;
        to_frame(in.x, in.y, fx, fy);
        if (in_progress()) {
            std::vector<float> seg;
            segment_to(fx, fy, seg);
            _seg_start.push_back(_committed.size());
            _committed.insert(_committed.end(), seg.begin() + 2, seg.end());
        } else {
            _seg_start.assign(1, 0);
            _committed = {fx, fy};
        }
        _anchors.push_back(fx);
        _anchors.push_back(fy);
        seed();
        _live.clear();
        _live_gx = _live_gy = -1;
        return false;
    }
    if (in_progress() && in.right_clicked) {
        consumed = true;
        return commit_pending(out);
    }
    if (in_progress()) {
        consumed = in.down;
        if (in.hovered) {
            float fx, fy;
            to_frame(in.x, in.y, fx, fy);
            refresh_live(fx, fy);
        }
    }
    return false;
}

bool PathTool::commit_pending(std::vector<float>& out) {
    out.clear();
    if (anchor_count() < kPathMinAnchors) return false;
    std::vector<float> back;
    segment_to(_anchors[0], _anchors[1], back);
    std::vector<float> closed = _committed;
    // The closing segment minus both ends, which are the last and first anchors.
    if (back.size() > 4) closed.insert(closed.end(), back.begin() + 2, back.end() - 2);
    to_fed(closed, out);
    cancel();
    return out.size() >= 6;
}

void PathTool::cancel() {
    _anchors.clear();
    _seg_start.clear();
    _committed.clear();
    _live.clear();
    _live_gx = _live_gy = -1;
}

bool PathTool::pop_anchor() {
    if (_anchors.empty()) return false;
    _committed.resize(_seg_start.back());
    _seg_start.pop_back();
    _anchors.resize(_anchors.size() - 2);
    _live.clear();
    _live_gx = _live_gy = -1;
    seed();
    return true;
}

void PathTool::overlay(std::vector<float>& anchors, std::vector<float>& committed,
                       std::vector<float>& live) const {
    to_fed(_anchors, anchors);
    to_fed(_committed, committed);
    to_fed(_live, live);
}

bool PathTool::near_first() const {
    if (_anchors.empty()) return false;
    float x, y;
    from_frame(_anchors[0], _anchors[1], x, y);
    const float dx = _cur[0] - x, dy = _cur[1] - y;
    return dx * dx + dy * dy <= kPathCloseRadius * kPathCloseRadius;
}

void PathTool::note_modifiers(bool shift, bool ctrl) {
    if (in_progress()) return;
    _mode_shift = shift;
    _mode_ctrl = ctrl;
}

}  // namespace mask
}  // namespace gui
