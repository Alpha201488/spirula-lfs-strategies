// Livewire.cpp -- see Livewire.h.

#include "app/gui/mask/Livewire.h"

#include "nn/core/Parallel.h"

#include <algorithm>
#include <cmath>
#include <limits>
#include <utility>

namespace gui {
namespace mask {

namespace {

constexpr float kPi = 3.14159265358979f;
// 8-connectivity, in order; the back link of k is (k + 4) & 7.
constexpr int kDx[8] = {1, 1, 0, -1, -1, -1, 0, 1};
constexpr int kDy[8] = {0, 1, 1, 1, 0, -1, -1, -1};
constexpr float kLen[8] = {1.0f, 1.41421356f, 1.0f, 1.41421356f,
                           1.0f, 1.41421356f, 1.0f, 1.41421356f};
constexpr uint8_t kNoDir = 255;
constexpr uint8_t kAnchor = 8;
constexpr uint8_t kUnseen = 15;
constexpr uint8_t kSettled = 0x80;

}  // namespace

void Livewire::clear() {
    _fw = _fh = _gw = _gh = 0;
    _step = 1;
    _fg.clear();
    _dir.clear();
    _zc.clear();
    _dist.clear();
    _parent.clear();
    _heap.clear();
    _anchor = -1;
    _pops = 0;
}

size_t Livewire::bytes() const {
    return _fg.capacity() + _dir.capacity() + _zc.capacity() + _parent.capacity() +
           _dist.capacity() * sizeof(float) + _heap.capacity() * sizeof(Node) +
           sizeof(_acos_abs) + sizeof(_acos_dot) + sizeof(_sign);
}

void Livewire::build_tables() {
    for (int c = 0; c < 256; c++) {
        float dx = 0.0f, dy = 0.0f;
        if (c != kNoDir) {
            const float th = (float)c * (2.0f * kPi / 255.0f) - kPi;
            dx = std::cos(th);
            dy = std::sin(th);
        }
        for (int k = 0; k < 8; k++) {
            const float lx = (float)kDx[k] / kLen[k], ly = (float)kDy[k] / kLen[k];
            const float dot = std::clamp(dx * lx + dy * ly, -1.0f, 1.0f);
            _acos_abs[c][k] = std::acos(std::fabs(dot));
            _acos_dot[c][k] = std::acos(dot);
            _sign[c][k] = dot >= 0.0f ? 1 : -1;
        }
    }
}

void Livewire::build(const uint8_t* rgb, int fw, int fh, int max_edge,
                     const LivewireWeights& w, const std::atomic<bool>* cancel) {
    clear();
    if (!rgb || fw <= 0 || fh <= 0) return;
    if (cancel && cancel->load()) return;
    _w = w;
    _fw = fw;
    _fh = fh;
    const int cap = std::max(1, max_edge);
    _step = std::max(1, (std::max(fw, fh) + cap - 1) / cap);
    _gw = (fw + _step - 1) / _step;
    _gh = (fh + _step - 1) / _step;
    const int gw = _gw, gh = _gh, step = _step;
    const size_t n = (size_t)gw * gh;

    // Luma of the box-averaged block, the way Picture.cpp decimates.
    std::vector<uint8_t> luma(n);
    nn::parallel_for(gh, [&](int64_t y0, int64_t y1) {
        for (int64_t gy = y0; gy < y1; gy++) {
            const int sy0 = (int)gy * step, sy1 = std::min(fh, sy0 + step);
            for (int gx = 0; gx < gw; gx++) {
                const int sx0 = gx * step, sx1 = std::min(fw, sx0 + step);
                uint32_t acc = 0, cnt = 0;
                for (int sy = sy0; sy < sy1; sy++)
                    for (int sx = sx0; sx < sx1; sx++) {
                        const uint8_t* p = rgb + ((size_t)sy * fw + sx) * 3;
                        acc += 77u * p[0] + 150u * p[1] + 29u * p[2];
                        cnt++;
                    }
                luma[(size_t)gy * gw + gx] = (uint8_t)((acc / cnt) >> 8);
            }
        }
    });
    if (cancel && cancel->load()) { clear(); return; }

    // Sobel and the 4-neighbour Laplacian on the interior; borders stay 0.
    std::vector<float> mag(n, 0.0f), lap(n, 0.0f);
    _dir.assign(n, kNoDir);
    nn::parallel_for(gh, [&](int64_t y0, int64_t y1) {
        for (int64_t y = std::max<int64_t>(1, y0); y < std::min<int64_t>(y1, gh - 1); y++) {
            const uint8_t* r0 = &luma[(size_t)(y - 1) * gw];
            const uint8_t* r1 = r0 + gw;
            const uint8_t* r2 = r1 + gw;
            for (int x = 1; x + 1 < gw; x++) {
                const float sx = (float)((int)r0[x + 1] + 2 * r1[x + 1] + r2[x + 1] -
                                         r0[x - 1] - 2 * r1[x - 1] - r2[x - 1]);
                const float sy = (float)((int)r2[x - 1] + 2 * r2[x] + r2[x + 1] -
                                         r0[x - 1] - 2 * r0[x] - r0[x + 1]);
                const size_t i = (size_t)y * gw + x;
                mag[i] = std::sqrt(sx * sx + sy * sy);
                lap[i] = (float)((int)r1[x - 1] + r1[x + 1] + r0[x] + r2[x] - 4 * r1[x]);
                if (mag[i] > 0.0f) {
                    // D' is perpendicular to the gradient: (Gy, -Gx).
                    const float th = std::atan2(-sx, sy);
                    _dir[i] = (uint8_t)(((int)std::lround((th + kPi) / (2.0f * kPi) * 255.0f)) % 255);
                }
            }
        }
    });
    if (cancel && cancel->load()) { clear(); return; }

    float gmax = 0.0f;
    for (float m : mag) gmax = std::max(gmax, m);
    _fg.assign(n, 255);
    _zc.assign(n, 0);
    nn::parallel_for(gh, [&](int64_t y0, int64_t y1) {
        for (int64_t y = y0; y < y1; y++)
            for (int x = 0; x < gw; x++) {
                const size_t i = (size_t)y * gw + x;
                if (gmax > 0.0f)
                    _fg[i] = (uint8_t)std::lround(255.0f * (1.0f - mag[i] / gmax));
                if (y < 1 || y + 1 >= gh || x < 1 || x + 1 >= gw) continue;
                const float l = lap[i];
                const float ln[4] = {lap[i - 1], lap[i + 1], lap[i - gw], lap[i + gw]};
                bool zc = false;
                if (l != 0.0f) {
                    for (float v : ln)
                        if (l * v < 0.0f && std::fabs(l) <= std::fabs(v)) zc = true;
                } else {
                    zc = ln[0] * ln[1] < 0.0f || ln[2] * ln[3] < 0.0f;
                }
                _zc[i] = zc ? 1 : 0;
            }
    });
    if (cancel && cancel->load()) { clear(); return; }
    build_tables();
    _builds++;
}

void Livewire::to_grid(float fx, float fy, int& gx, int& gy) const {
    gx = std::clamp((int)std::floor(fx / (float)_step), 0, std::max(0, _gw - 1));
    gy = std::clamp((int)std::floor(fy / (float)_step), 0, std::max(0, _gh - 1));
}

void Livewire::to_frame(int gx, int gy, float& fx, float& fy) const {
    fx = std::min(((float)gx + 0.5f) * (float)_step, (float)_fw - 0.5f);
    fy = std::min(((float)gy + 0.5f) * (float)_step, (float)_fh - 0.5f);
}

uint8_t Livewire::magnitude_cost(int gx, int gy) const {
    return in_grid(gx, gy) ? _fg[(size_t)gy * _gw + gx] : 255;
}

bool Livewire::zero_crossing(int gx, int gy) const {
    return in_grid(gx, gy) && _zc[(size_t)gy * _gw + gx] != 0;
}

void Livewire::direction(int gx, int gy, float& dx, float& dy) const {
    dx = dy = 0.0f;
    if (!in_grid(gx, gy)) return;
    const uint8_t c = _dir[(size_t)gy * _gw + gx];
    if (c == kNoDir) return;
    const float th = (float)c * (2.0f * kPi / 255.0f) - kPi;
    dx = std::cos(th);
    dy = std::sin(th);
}

int Livewire::link_index(int dx, int dy) const {
    for (int k = 0; k < 8; k++)
        if (kDx[k] == dx && kDy[k] == dy) return k;
    return -1;
}

float Livewire::fd_cost(uint8_t cp, uint8_t cq, int k) const {
    const float a = _acos_abs[cp][k];
    const float c = _sign[cp][k] > 0 ? _acos_dot[cq][k] : kPi - _acos_dot[cq][k];
    return (2.0f / (3.0f * kPi)) * (a + c);
}

float Livewire::link_cost_k(size_t p, size_t q, int k) const {
    const float fd = fd_cost(_dir[p], _dir[q], k);
    const float fz = _zc[q] ? 0.0f : 1.0f;
    const float fg = (float)_fg[q] / 255.0f;
    return (_w.zero_cross * fz + _w.direction * fd + _w.magnitude * fg) * kLen[k];
}

float Livewire::direction_cost(int px, int py, int qx, int qy) const {
    const int k = link_index(qx - px, qy - py);
    if (k < 0 || !in_grid(px, py) || !in_grid(qx, qy)) return -1.0f;
    return fd_cost(_dir[(size_t)py * _gw + px], _dir[(size_t)qy * _gw + qx], k);
}

float Livewire::link_cost(int px, int py, int qx, int qy) const {
    const int k = link_index(qx - px, qy - py);
    if (k < 0 || !in_grid(px, py) || !in_grid(qx, qy)) return -1.0f;
    return link_cost_k((size_t)py * _gw + px, (size_t)qy * _gw + qx, k);
}

// ---------------------------------------------------------------------------
// The search
// ---------------------------------------------------------------------------

void Livewire::set_anchor(int gx, int gy) {
    _anchor = -1;
    _pops = 0;
    _heap.clear();
    if (!ready() || !in_grid(gx, gy)) return;
    const size_t n = (size_t)_gw * _gh;
    _dist.assign(n, std::numeric_limits<float>::infinity());
    _parent.assign(n, kUnseen);
    _anchor = (int64_t)gy * _gw + gx;
    _dist[(size_t)_anchor] = 0.0f;
    _parent[(size_t)_anchor] = kAnchor;
    _heap.push_back(Node{0.0f, (uint32_t)_anchor});
}

void Livewire::expand_until(size_t target) {
    auto later = [](const Node& a, const Node& b) { return a.d > b.d; };
    while (!(_parent[target] & kSettled) && !_heap.empty()) {
        std::pop_heap(_heap.begin(), _heap.end(), later);
        const Node top = _heap.back();
        _heap.pop_back();
        const size_t i = top.i;
        // Lazy deletion: a stale entry for a settled node is skipped.
        if (_parent[i] & kSettled) continue;
        _parent[i] |= kSettled;
        _pops++;
        const int x = (int)(i % (size_t)_gw), y = (int)(i / (size_t)_gw);
        for (int k = 0; k < 8; k++) {
            const int nx = x + kDx[k], ny = y + kDy[k];
            if (!in_grid(nx, ny)) continue;
            const size_t j = (size_t)ny * _gw + nx;
            if (_parent[j] & kSettled) continue;
            const float nd = top.d + link_cost_k(i, j, k);
            if (nd < _dist[j]) {
                _dist[j] = nd;
                _parent[j] = (uint8_t)((k + 4) & 7);
                _heap.push_back(Node{nd, (uint32_t)j});
                std::push_heap(_heap.begin(), _heap.end(), later);
            }
        }
    }
}

bool Livewire::path_to(int gx, int gy, std::vector<int>& out) {
    out.clear();
    if (_anchor < 0 || !in_grid(gx, gy)) return false;
    const size_t t = (size_t)gy * _gw + gx;
    expand_until(t);
    if (!(_parent[t] & kSettled)) return false;
    int x = gx, y = gy;
    while (true) {
        out.push_back(x);
        out.push_back(y);
        const uint8_t back = _parent[(size_t)y * _gw + x] & 0x0F;
        if (back == kAnchor) break;
        x += kDx[back];
        y += kDy[back];
    }
    // Backtraced target first; the caller wants the anchor first.
    for (size_t a = 0, b = out.size() / 2 - 1; a < b; a++, b--) {
        std::swap(out[2 * a], out[2 * b]);
        std::swap(out[2 * a + 1], out[2 * b + 1]);
    }
    return true;
}

double Livewire::path_cost(int gx, int gy) {
    if (_anchor < 0 || !in_grid(gx, gy)) return -1.0;
    const size_t t = (size_t)gy * _gw + gx;
    expand_until(t);
    return (_parent[t] & kSettled) ? (double)_dist[t] : -1.0;
}

}  // namespace mask
}  // namespace gui
