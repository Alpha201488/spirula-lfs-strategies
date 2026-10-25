#pragma once

// Even-odd scanline fill of a closed polygon into a byte image, sampled at
// pixel centres (x + 0.5, y + 0.5). Header-only for the reason
// DistanceTransform.h is: its callers, app/FrameMask.cpp (CLI and GUI) and
// app/gui/edit/SelectShape.cpp (GUI only), link nothing in common.

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace polyfill {

namespace detail {

// `xy`'s edges crossing height `sy`, as sorted x values. The one piece
// `fill_even_odd` and `contains` must never restate independently.
inline void crossings(const float* xy, size_t n, float sy, std::vector<float>& xs) {
    xs.clear();
    for (size_t i = 0, j = n - 1; i < n; j = i++) {
        const float ay = xy[2 * i + 1], by = xy[2 * j + 1];
        if ((ay > sy) == (by > sy)) continue;
        const float t = (sy - ay) / (by - ay);
        xs.push_back(xy[2 * i] + t * (xy[2 * j] - xy[2 * i]));
    }
    std::sort(xs.begin(), xs.end());
}

}  // namespace detail

// `xy` holds n x,y pairs in pixel units. Pixels whose centre is inside get
// `value`; the rest are left as they are. Fewer than 3 points fill nothing.
inline void fill_even_odd(const float* xy, size_t n, int W, int H, uint8_t* out,
                          uint8_t value) {
    if (n < 3 || W <= 0 || H <= 0) return;
    float ymin = xy[1], ymax = xy[1];
    for (size_t i = 1; i < n; i++) {
        ymin = std::min(ymin, xy[2 * i + 1]);
        ymax = std::max(ymax, xy[2 * i + 1]);
    }
    const int y0 = std::max(0, (int)std::floor(ymin));
    const int y1 = std::min(H - 1, (int)std::ceil(ymax));
    std::vector<float> xs;
    for (int y = y0; y <= y1; y++) {
        const float sy = (float)y + 0.5f;
        detail::crossings(xy, n, sy, xs);
        for (size_t k = 0; k + 1 < xs.size(); k += 2) {
            const int a = std::max(0, (int)std::ceil(xs[k] - 0.5f));
            const int b = std::min(W - 1, (int)std::floor(xs[k + 1] - 0.5f));
            for (int x = a; x <= b; x++) out[(size_t)y * W + x] = value;
        }
    }
}

// Even-odd containment of one point, sharing `crossings` with fill_even_odd.
// Its closed `[xs[k],xs[k+1]]` test is what the fill's pixel span reduces to
// at that pixel's own sample point, so a point on a crossing agrees with it.
inline bool contains(const float* xy, size_t n, float sx, float sy) {
    if (n < 3) return false;
    std::vector<float> xs;
    detail::crossings(xy, n, sy, xs);
    for (size_t k = 0; k + 1 < xs.size(); k += 2)
        if (sx >= xs[k] && sx <= xs[k + 1]) return true;
    return false;
}

}  // namespace polyfill
