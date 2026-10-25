#pragma once

/*
 * MeshImport.h
 *
 * The read side of MeshExport.h: a triangle mesh back out of every format the
 * pipeline writes (PLY, OBJ, glTF, GLB, STL), into the same MeshData. It is a
 * reader for REAL FILES, not only for ours -- an OBJ from Blender and a
 * textured GLB from anywhere else open too. What each one accepts is at the
 * top of that format's section in MeshImport.cpp.
 *
 * `viewer/` keeps a mesh reader of its own on purpose: it parses
 * multi-gigabyte files through a chunk buffer straight into WebGL upload
 * buffers, where this one loads a whole mesh into a MeshData. They read the
 * SAME files, so a quirk fixed in one is worth checking against the other.
 */

#include <string>

#include "mesh/MeshExport.h"   // MeshData

namespace meshing {

// True when `path`'s extension is one this reader handles. Says nothing about
// the contents -- a .ply is a container (see mesh_ply_has_faces).
bool is_mesh_path(const std::string& path);

// True when `path` is a PLY whose header declares a non-empty face element,
// i.e. a mesh rather than a Gaussian cloud or an SfM point cloud. False for
// anything unreadable, so a caller can use it as "should I treat this .ply as
// a mesh?" without a second check.
bool ply_is_mesh(const std::string& path);

// Read `path` into `out`. Returns false and fills `error` on failure; `out`
// is left in an unspecified state in that case.
//
// Positions are always filled. Normals are filled when the file has them (the
// caller can generate them otherwise -- see mesh_compute_normals). Colors,
// UVs and the texture are filled only when present.
bool read_mesh(const std::string& path, MeshData& out, std::string& error);

// Area-weighted vertex normals, for a file that carried none. No-op when
// `mesh.N` is already the right size unless `force`.
void mesh_compute_normals(MeshData& mesh, bool force = false);

}  // namespace meshing
