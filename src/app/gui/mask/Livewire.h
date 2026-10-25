#pragma once

// Livewire (intelligent scissors, Mortensen and Barrett 1995): a cost image
// from gradient magnitude, gradient direction and Laplacian zero crossings
// over the frame decimated to at most kLivewireMaxEdge on its long side, and
// a lazy Dijkstra from one anchor that expands only as far as the cursor
// asks. Coordinates are grid pixels; to_grid/to_frame map them to frame
// pixels. No ImGui, no GL. Design: docs/notes/mask-editor.md.

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace gui {
namespace mask {

inline constexpr int kLivewireMaxEdge = 4096;

// The three local-cost weights of the paper; a knob, not a claim.
struct LivewireWeights {
    float zero_cross = 0.43f;
    float direction = 0.43f;
    float magnitude = 0.14f;
};

class Livewire {
public:
    // Builds the cost image from an interleaved RGB frame. Counts one build.
    // A set `cancel`, read between the passes, returns early: not ready,
    // not counted. Bounds a worker join to one pass instead of the build.
    void build(const uint8_t* rgb, int fw, int fh, int max_edge = kLivewireMaxEdge,
               const LivewireWeights& w = LivewireWeights{},
               const std::atomic<bool>* cancel = nullptr);
    void clear();
    bool ready() const { return _gw > 0 && _gh > 0; }
    int width() const { return _gw; }
    int height() const { return _gh; }
    int step() const { return _step; }
    int frame_width() const { return _fw; }
    int frame_height() const { return _fh; }
    int builds() const { return _builds; }
    size_t bytes() const;

    // Frame pixels <-> grid pixels. to_frame gives the block centre in
    // continuous frame coordinates, clamped inside the frame.
    void to_grid(float fx, float fy, int& gx, int& gy) const;
    void to_frame(int gx, int gy, float& fx, float& fy) const;

    // The features, for tests and tuning.
    uint8_t magnitude_cost(int gx, int gy) const;
    bool zero_crossing(int gx, int gy) const;
    void direction(int gx, int gy, float& dx, float& dy) const;
    // fD(p, q) and the full link cost between 8-neighbours; -1 when not adjacent.
    float direction_cost(int px, int py, int qx, int qy) const;
    float link_cost(int px, int py, int qx, int qy) const;

    // The search. set_anchor resets it; path_to expands lazily and returns
    // the lowest-cost path as grid x,y pairs, anchor first, target last.
    void set_anchor(int gx, int gy);
    bool has_anchor() const { return _anchor >= 0; }
    bool path_to(int gx, int gy, std::vector<int>& out_xy);
    double path_cost(int gx, int gy);
    size_t pops() const { return _pops; }

private:
    struct Node {
        float d;
        uint32_t i;
    };
    bool in_grid(int x, int y) const { return x >= 0 && y >= 0 && x < _gw && y < _gh; }
    int link_index(int dx, int dy) const;
    float fd_cost(uint8_t cp, uint8_t cq, int k) const;
    float link_cost_k(size_t p, size_t q, int k) const;
    void expand_until(size_t target);
    void build_tables();

    int _fw = 0, _fh = 0, _gw = 0, _gh = 0, _step = 1, _builds = 0;
    LivewireWeights _w;
    std::vector<uint8_t> _fg;      // 255 * (1 - G / Gmax)
    std::vector<uint8_t> _dir;     // D'(p) as an angle code 0..254; 255 = no gradient
    std::vector<uint8_t> _zc;      // 1 on a Laplacian zero crossing
    std::vector<float> _dist;
    std::vector<uint8_t> _parent;  // low nibble: back link 0..7, 8 anchor, 15 unseen; 0x80 settled
    std::vector<Node> _heap;
    int64_t _anchor = -1;
    size_t _pops = 0;
    float _acos_abs[256][8];       // acos(|D'(code) . L_k|)
    float _acos_dot[256][8];       // acos(L_k . D'(code))
    int8_t _sign[256][8];          // sign of D'(code) . L_k, +1 at zero
};

}  // namespace mask
}  // namespace gui
