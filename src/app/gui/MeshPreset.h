#pragma once

// A saved meshing preset: how a surface is extracted, under a name the user
// chose. What it never carries is which model, which photographs and where the
// result goes -- so one preset meshes every run in a folder the same way.

#include "app/gui/MeshJob.h"
#include "app/gui/PresetFile.h"

#include <string>
#include <vector>

namespace gui {

struct MeshPreset {
    std::string name;
    std::string description;
    std::string path;
    // The job with its three context fields left at their defaults.
    MeshJob job;
};

// Throws std::runtime_error when the file cannot be written / read.
void save_mesh_preset(const MeshPreset& p, const std::string& path);
MeshPreset load_mesh_preset(const std::string& path);
void delete_mesh_preset(const std::string& path);
std::vector<MeshPreset> list_mesh_presets();

// Every bounded field back inside its range, and at least one output format
// the colour mode can actually carry.
void sanitize_mesh_job(MeshJob& job);

}  // namespace gui
