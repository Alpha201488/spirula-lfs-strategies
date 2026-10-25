// WorldGrid.cpp -- see WorldGrid.h.

#include "app/gui/edit/WorldGrid.h"

#include "app/gui/Layout.h"

#include "imgui.h"

#include <algorithm>
#include <cmath>

namespace gui {

namespace {

// Cells either side of the focus. Every cell edge is its own segment, so a
// fisheye view bends the lines and a line crossing behind the camera loses
// only the part that did: 2 * 41 * 40 segments a frame.
constexpr int kHalf = 20;

struct Pen {
    ImDrawList* dl;
    const ViewProjection* cam;
    const spirula::Sim3* to_shared;
    ImVec2 origin;

    bool at(const double p[3], ImVec2& out) const {
        double q[3];
        to_shared->apply(p, q);
        const float f[3] = {(float)q[0], (float)q[1], (float)q[2]};
        float x, y, depth;
        if (!cam->project(f, x, y, depth) || !(depth > 0.0f)) return false;
        // A point far outside the image is a line ImGui would have to clip
        // across half a million pixels; nothing on screen needs it.
        if (std::fabs(x) > 1e5f || std::fabs(y) > 1e5f) return false;
        out = ImVec2(origin.x + x, origin.y + y);
        return true;
    }
    void line(const double a[3], const double b[3], ImU32 col, float w) const {
        ImVec2 pa, pb;
        if (at(a, pa) && at(b, pb)) dl->AddLine(pa, pb, col, w);
    }
};

}  // namespace

void draw_world_grid(ImDrawList* dl, const ImVec2& origin,
                     const ViewProjection& cam, const spirula::Sim3& to_shared,
                     double cell, const double focus[3]) {
    if (!(cell > 0.0)) return;
    const Pen pen{dl, &cam, &to_shared, origin};
    double f[3];
    to_shared.inverse().apply(focus, f);
    const long gx = std::lround(f[0] / cell), gy = std::lround(f[1] / cell);
    const float thin = px(1.0f);

    for (int i = -kHalf; i <= kHalf; i++) {
        const bool major_x = (gx + i) % 10 == 0, major_y = (gy + i) % 10 == 0;
        for (int j = -kHalf; j < kHalf; j++) {
            // Faded toward the edge of the patch, so it has no edge.
            const double r = std::max(std::abs(i), std::max(std::abs(j), std::abs(j + 1)));
            const int alpha = (int)(std::clamp(1.0 - r / kHalf, 0.0, 1.0) * 150.0);
            if (alpha < 8) continue;
            const double x = (gx + i) * cell, y = (gy + i) * cell;
            const double a0 = (gy + j) * cell, a1 = (gy + j + 1) * cell;
            const double b0 = (gx + j) * cell, b1 = (gx + j + 1) * cell;
            const double pa[3] = {x, a0, 0}, pb[3] = {x, a1, 0};
            const double qa[3] = {b0, y, 0}, qb[3] = {b1, y, 0};
            pen.line(pa, pb, IM_COL32(200, 205, 215, major_x ? alpha : alpha / 2), thin);
            pen.line(qa, qb, IM_COL32(200, 205, 215, major_y ? alpha : alpha / 2), thin);
        }
    }

    const ImU32 axis_col[3] = {IM_COL32(250, 51, 79, 230), IM_COL32(140, 219, 0, 230),
                               IM_COL32(41, 140, 250, 230)};
    for (int a = 0; a < 3; a++)
        for (int j = 0; j < kHalf; j++) {
            double p0[3] = {0, 0, 0}, p1[3] = {0, 0, 0};
            p0[a] = j * cell;
            p1[a] = (j + 1) * cell;
            pen.line(p0, p1, axis_col[a], px(2.0f));
        }
}

}  // namespace gui
