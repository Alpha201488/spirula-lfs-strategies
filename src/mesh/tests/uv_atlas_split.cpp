// uv_atlas_split -- build_uv_atlas on a mesh where most charts fail to
// flatten and must take the split-and-retry path, with enough charts that the
// chart list reallocates while it does.
//
//   ./build_vulkan/uv_atlas_split
//
// A chart list past ~1 MB is freed straight back to the OS on Windows, so a
// reference held across that reallocation faults here rather than corrupting
// the heap quietly (spirula-studio#91).

#include "core/SourcePath.h"
#include "mesh/MeshUV.h"

#include <cmath>
#include <cstdio>
#include <vector>

namespace {

int g_fail = 0;

void check(bool ok, const char* what, int line) {
    if (ok) return;
    std::printf("FAIL %s:%d  %s\n", SS_FILE, line, what);
    g_fail++;
}
#define CHECK(cond) check((cond), #cond, __LINE__)

constexpr int kSlivers = 60000;
constexpr int kGrid = 32;

// kSlivers disconnected pairs of zero-area triangles: each pair is one chart
// that LSCM and the planar fallback both reject. Then one flat kGrid x kGrid
// quad grid that flattens fine.
meshing::MeshData slivers_and_grid() {
    meshing::MeshData m;
    m.V.reserve((size_t)kSlivers * 4 + (kGrid + 1) * (kGrid + 1));
    m.F.reserve((size_t)kSlivers * 2 + 2 * kGrid * kGrid);
    for (int s = 0; s < kSlivers; s++) {
        const int b = (int)m.V.size();
        const float y = 0.01f * (float)s;
        for (int k = 0; k < 4; k++) m.V.push_back({0.1f * (float)k, y, 0.0f});
        m.F.push_back({b, b + 1, b + 2});
        m.F.push_back({b + 1, b + 3, b + 2});
    }
    const int g0 = (int)m.V.size();
    for (int i = 0; i <= kGrid; i++)
        for (int j = 0; j <= kGrid; j++)
            m.V.push_back({(float)j / kGrid, (float)i / kGrid, -5.0f});
    auto at = [&](int i, int j) { return g0 + i * (kGrid + 1) + j; };
    for (int i = 0; i < kGrid; i++)
        for (int j = 0; j < kGrid; j++) {
            m.F.push_back({at(i, j), at(i, j + 1), at(i + 1, j + 1)});
            m.F.push_back({at(i, j), at(i + 1, j + 1), at(i + 1, j)});
        }
    return m;
}

}  // namespace

int main() {
    meshing::MeshData mesh = slivers_and_grid();
    const size_t nf = mesh.F.size();
    const size_t grid_f0 = (size_t)kSlivers * 2;

    meshing::UVAtlasConfig cfg;
    cfg.verbose = false;
    const std::vector<int> face_chart = meshing::build_uv_atlas(mesh, cfg);

    CHECK(face_chart.size() == nf);
    CHECK(mesh.F.size() == nf);
    CHECK(mesh.UV.size() == mesh.V.size());
    bool charts_valid = true, uv_in_unit = true;
    for (int c : face_chart) charts_valid &= c >= 0;
    for (const auto& uv : mesh.UV)
        uv_in_unit &= std::isfinite(uv[0]) && std::isfinite(uv[1]) &&
                      uv[0] >= 0.0f && uv[0] <= 1.0f && uv[1] >= 0.0f && uv[1] <= 1.0f;
    CHECK(charts_valid);
    CHECK(uv_in_unit);

    // the grid must still come out flattened, not parked on a point
    double grid_uv_area = 0.0;
    for (size_t t = grid_f0; t < nf; t++) {
        const auto& f = mesh.F[t];
        const auto &a = mesh.UV[f[0]], &b = mesh.UV[f[1]], &c = mesh.UV[f[2]];
        grid_uv_area += 0.5 * std::fabs((double)(b[0] - a[0]) * (c[1] - a[1]) -
                                        (double)(b[1] - a[1]) * (c[0] - a[0]));
    }
    CHECK(grid_uv_area > 1e-6);

    if (g_fail) {
        std::printf("uv_atlas_split: %d failure(s)\n", g_fail);
        return 1;
    }
    std::printf("uv_atlas_split: OK\n");
    return 0;
}
