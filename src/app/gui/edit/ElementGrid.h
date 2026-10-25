#pragma once

// A uniform grid over element positions: the neighbour queries a selection
// grows by, and the union-find behind "keep only the big piece".
//
// Hashed rather than dense. A dense table over a bounding box needs O(dim^3)
// cells to reach the spacing of a SURFACE, which is where splats and sparse
// points both sit -- a million of them want cells a thousandth of the scene
// across, and 10^9 mostly-empty cells is not a table anyone can afford.
//
// Everything below works on CELLS rather than on pairs of elements, so the
// cost is the occupied cell count and not the square of what a cell holds.
// The cell size IS the reach: two elements link when their cells touch.

#include <atomic>
#include <cstdint>
#include <vector>

namespace gui {

class EditDoc;

class ElementGrid {
public:
    // A cell that holds a handful of elements, which is also the one honest
    // measure of how far apart they are. A volume estimate from the count is
    // not: these sit on surfaces, and it comes out ten times too large.
    float measure_spacing(const EditDoc& doc);
    // Rebuild at an explicit cell size, which is the reach every query works
    // at.
    void build(const EditDoc& doc, float cell);
    void clear();
    bool built() const { return _cell > 0.0f; }
    float cell() const { return _cell; }
    int64_t occupied() const { return (int64_t)_beg.size() - 1; }

    // One shell of neighbouring CELLS added to (grow) or peeled off (shrink)
    // the selection. Dead elements never join it.
    void grow(std::vector<uint8_t>& sel, const uint8_t* alive, int64_t n) const;
    void shrink(std::vector<uint8_t>& sel, const uint8_t* alive, int64_t n) const;

    // Connected components: two touching cells are one piece, and `label` is
    // -1 for a dead element. With `radii` an element also joins the cells its
    // own extent covers, which is what gathers the big sky Gaussians.
    bool components(const uint8_t* alive, int64_t n,
                    std::vector<int32_t>& label, std::vector<int64_t>& sizes,
                    const float* radii = nullptr, float scale = 1.0f,
                    const std::atomic<bool>* cancel = nullptr) const;

    // The median distance from each live element to its `k` nearest live
    // neighbours, NaN for the dead. The search gives up four shells of cells
    // out and takes the median of what it found: still "far from everything".
    void knn_median(int k, const uint8_t* alive, std::vector<float>& out,
                    const std::atomic<bool>* cancel = nullptr) const;

private:
    void coords_of(const float* p, int32_t c[3]) const;
    // Cell index, or -1 when nothing is in that cell.
    int32_t find_cell(const int32_t c[3]) const;
    // Which cell each element went into, parallel to the element array.
    const std::vector<int32_t>& cell_of_element() const { return _of_element; }

    const float* _pos = nullptr;
    int64_t _n = 0;
    float _cell = 0.0f;
    float _origin[3] = {0, 0, 0};
    // Elements grouped by cell: `_beg[k] .. _beg[k+1]` index `_items`.
    std::vector<int32_t> _items;
    std::vector<int32_t> _beg;
    std::vector<int32_t> _of_element;
    // The integer coordinates of each cell, for walking its neighbours.
    std::vector<int32_t> _coords;      // [cells, 3]
    // Open addressing, power-of-two, linear probe: key -> cell index.
    std::vector<uint64_t> _hkey;
    std::vector<int32_t> _hval;
    uint64_t _hmask = 0;
};

// Connected components over a topology given outright -- a mesh's edges, two
// int32 per pair. Exact, and the only right answer where one exists: a
// distance rule calls a sparse floater several pieces and a dense wall one.
void components_from_pairs(const int32_t* pairs, int64_t n_pairs,
                           const uint8_t* alive, int64_t n,
                           std::vector<int32_t>& label,
                           std::vector<int64_t>& sizes);

}  // namespace gui
