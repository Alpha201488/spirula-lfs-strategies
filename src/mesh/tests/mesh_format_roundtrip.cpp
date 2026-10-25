// mesh_format_roundtrip -- every format the mesher writes reads back, and a
// run asking for several colors writes each of them exactly once.
//
//   ./build_vulkan/mesh_format_roundtrip
//
// The writers and the reader are two hand-written implementations of the same
// five container formats; nothing but a round trip keeps them honest.

#include "core/SourcePath.h"
#include "mesh/MeshExport.h"
#include "mesh/MeshImport.h"

#include <cmath>
#include <cstdio>
#include <filesystem>
#include <string>
#include <vector>

namespace fs = std::filesystem;

namespace {

int g_fail = 0;

void check(bool ok, const char* what, int line) {
    if (ok) return;
    std::printf("FAIL %s:%d  %s\n", SS_FILE, line, what);
    g_fail++;
}
#define CHECK(cond) check((cond), #cond, __LINE__)

fs::path scratch() {
    const fs::path dir = fs::temp_directory_path() / "ss_mesh_format_test";
    std::error_code ec;
    fs::create_directories(dir, ec);
    return dir;
}

// A tetrahedron: four vertices, four faces, every one of them wound outward.
meshing::MeshData tetra(meshing::MeshColorMode mode) {
    meshing::MeshData m;
    m.V = {{0, 0, 0}, {1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    m.F = {{0, 2, 1}, {0, 1, 3}, {0, 3, 2}, {1, 2, 3}};
    meshing::compute_vertex_normals(m);
    if (mode == meshing::MeshColorMode::Vertex)
        m.C = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}, {255, 255, 0}};
    if (mode == meshing::MeshColorMode::Texture) {
        m.UV = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
        m.tex_width = m.tex_height = 2;
        m.texture.assign(2 * 2 * 3, 128);
    }
    return m;
}

void test_roundtrip(const char* fmt, meshing::MeshColorMode mode) {
    const meshing::MeshData src = tetra(mode);
    meshing::MeshFormatSpec spec;
    spec.fmt = fmt;
    const std::string base =
        (scratch() / (std::string("tetra_") + fmt + "_" +
                      meshing::mesh_color_token(mode))).string();
    meshing::write_mesh(src, mode, spec, base, /*verbose=*/false);

    meshing::MeshData back;
    std::string error;
    const bool ok = meshing::read_mesh(base + "." + fmt, back, error);
    if (!ok) std::printf("  read_mesh(%s): %s\n", fmt, error.c_str());
    CHECK(ok);
    if (!ok) return;
    CHECK(back.F.size() == src.F.size());
    // STL and a fan-triangulated OBJ may not share vertices the way the source
    // did; the surface is what has to survive, so compare its extent.
    float lo[3] = {1e30f, 1e30f, 1e30f}, hi[3] = {-1e30f, -1e30f, -1e30f};
    for (const auto& v : back.V)
        for (int c = 0; c < 3; c++) {
            lo[c] = std::min(lo[c], v[c]);
            hi[c] = std::max(hi[c], v[c]);
        }
    for (int c = 0; c < 3; c++) {
        CHECK(std::fabs(lo[c] - 0.0f) < 1e-5f);
        CHECK(std::fabs(hi[c] - 1.0f) < 1e-5f);
    }
    if (mode == meshing::MeshColorMode::Vertex && std::string(fmt) != "obj")
        CHECK(back.C.size() == back.V.size());
    if (mode == meshing::MeshColorMode::Texture)
        CHECK(back.tex_width == 2 && back.tex_height == 2);
}

// The plan is what decides where each file lands, so it is what has to be
// right before a three-minute run writes anything.
void test_plan() {
    const std::vector<meshing::MeshFormatSpec> ply_glb = {
        meshing::parse_one_mesh_format("ply"),
        meshing::parse_one_mesh_format("glb")};

    // One colour: the names a run has always had, no suffix.
    auto one = meshing::plan_mesh_outputs(
        ply_glb, {meshing::MeshColorMode::Vertex}, "out/mesh");
    CHECK(one.size() == 2);
    for (const auto& r : one) CHECK(r.base == "out/mesh");

    // Two: each writes at its own base, and the pair PLY cannot carry is
    // dropped rather than failing the run.
    std::vector<std::string> dropped;
    auto two = meshing::plan_mesh_outputs(
        ply_glb, {meshing::MeshColorMode::Vertex, meshing::MeshColorMode::Texture},
        "out/mesh", &dropped);
    CHECK(two.size() == 3);
    CHECK(dropped.size() == 1);
    for (const auto& r : two) {
        CHECK(r.base != "out/mesh");
        CHECK(!(r.spec.fmt == "ply" && r.mode == meshing::MeshColorMode::Texture));
    }

    // Nothing at all is the mistake, and it comes back empty.
    auto none = meshing::plan_mesh_outputs(
        {meshing::parse_one_mesh_format("stl")},
        {meshing::MeshColorMode::Texture}, "out/mesh");
    CHECK(none.empty());

    // A colour list parses like a format list, and rejects what it should.
    const auto modes = meshing::parse_mesh_colors("texture, none");
    CHECK(modes.size() == 2);
    CHECK(modes[0] == meshing::MeshColorMode::Texture);
    bool threw = false;
    try { meshing::parse_mesh_colors("vertex,vertex"); }
    catch (const std::exception&) { threw = true; }
    CHECK(threw);

    // An --output that already carries an extension means the same thing.
    CHECK(meshing::mesh_output_strip_ext("out/mesh.glb") == "out/mesh");
    CHECK(meshing::mesh_output_strip_ext("out/mesh") == "out/mesh");
}

}  // namespace


int main() {
    for (const char* fmt : {"ply", "gltf", "glb"})
        test_roundtrip(fmt, meshing::MeshColorMode::Vertex);
    for (const char* fmt : {"ply", "obj", "gltf", "glb", "stl"})
        test_roundtrip(fmt, meshing::MeshColorMode::None);
    for (const char* fmt : {"obj", "gltf", "glb"})
        test_roundtrip(fmt, meshing::MeshColorMode::Texture);
    test_plan();

    if (g_fail) {
        std::printf("mesh_format_roundtrip: %d failure(s)\n", g_fail);
        return 1;
    }
    std::printf("mesh_format_roundtrip: OK\n");
    return 0;
}
