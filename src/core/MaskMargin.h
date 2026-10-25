#pragma once
// Moving one binary mask's boundary by a share of its own size: the geometry
// sam::Masker applies to every detection and the mask editor to a SAM drop.
// Header-only and model-free, so the editor's test binary links no sam::.

#include "core/DistanceTransform.h"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace margin {

// Signed Euclidean pixels for a box: the odd kernel SIZE first, the radius half
// of it, so the box changes by 2r = `ratio` of its mean side. Floor of 3 on the
// size keeps a tiny detection moving; ratio 0 is exactly 0.
inline int radius_px(float x0, float y0, float x1, float y1, float ratio) {
    if (ratio == 0.0f) return 0;
    const float bw = std::max(1.0f, x1 - x0);
    const float bh = std::max(1.0f, y1 - y0);
    int k = (int)(std::fabs(ratio) * 0.5f * (bw + bh));
    if (k < 3) k = 3;
    k |= 1;
    const int r = (k - 1) / 2;
    return ratio > 0.0f ? r : -r;
}

// ORs a w x h mask (>127 = set) into `hit` (1 = covered) with its boundary moved
// `radius` px: outward stops at the frame border, inward repeats the border
// pixel, so a subject the frame cuts off keeps that edge.
inline void accumulate(const uint8_t* m, int w, int h, int radius, std::vector<uint8_t>& hit) {
    const size_t n = (size_t)w * (size_t)h;
    if (w <= 0 || h <= 0 || hit.size() != n) return;
    if (radius == 0) {
        for (size_t i = 0; i < n; ++i)
            if (m[i] > 127) hit[i] = 1;
        return;
    }
    int x0 = w, y0 = h, x1 = -1, y1 = -1;
    for (int y = 0; y < h; ++y) {
        const uint8_t* row = m + (size_t)y * w;
        int rx0 = -1, rx1 = -1;
        for (int x = 0; x < w; ++x)
            if (row[x] > 127) { if (rx0 < 0) rx0 = x; rx1 = x; }
        if (rx0 < 0) continue;
        if (rx0 < x0) x0 = rx0;
        if (rx1 > x1) x1 = rx1;
        if (y < y0) y0 = y;
        y1 = y;
    }
    if (x1 < 0) return;
    // The bounding box plus the offset holds the whole answer.
    const int pad = radius < 0 ? -radius : radius;
    const int cx0 = radius > 0 ? std::max(0, x0 - pad) : x0 - pad;
    const int cy0 = radius > 0 ? std::max(0, y0 - pad) : y0 - pad;
    const int cx1 = radius > 0 ? std::min(w - 1, x1 + pad) : x1 + pad;
    const int cy1 = radius > 0 ? std::min(h - 1, y1 + pad) : y1 + pad;
    const int cw = cx1 - cx0 + 1, ch = cy1 - cy0 + 1;
    std::vector<uint8_t> crop((size_t)cw * ch);
    for (int y = 0; y < ch; ++y) {
        const uint8_t* src = m + (size_t)std::clamp(cy0 + y, 0, h - 1) * w;
        uint8_t* dst = crop.data() + (size_t)y * cw;
        for (int x = 0; x < cw; ++x)
            dst[x] = src[std::clamp(cx0 + x, 0, w - 1)] > 127 ? 1 : 0;
    }
    edt::apply_mask_boundary_offset_in_place(crop.data(), ch, cw, (float)radius);
    for (int y = 0; y < ch; ++y) {
        const int dy = cy0 + y;
        if (dy < 0 || dy >= h) continue;
        const uint8_t* src = crop.data() + (size_t)y * cw;
        uint8_t* dst = hit.data() + (size_t)dy * w;
        for (int x = 0; x < cw; ++x) {
            const int dx = cx0 + x;
            if (dx >= 0 && dx < w && src[x]) dst[dx] = 1;
        }
    }
}

}  // namespace margin
