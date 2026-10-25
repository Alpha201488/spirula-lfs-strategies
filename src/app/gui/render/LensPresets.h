#pragma once

// Lenses to start from: the focal lengths photographers name, the lenses of
// a few 360 cameras measured off real reconstructions, and the lenses a
// dataset was shot with, grouped so a thousand frames of one camera are one.

#include "app/gui/render/RenderProject.h"
#include "i18n/Message.h"

#include <string>
#include <vector>

struct ParsedDataset;

namespace gui::render {

struct LensPreset {
    // The label: `name` alone, or `name` filled with `arg` (a number or a
    // camera model, never translated).
    const spirula::i18n::Msg* name = nullptr;
    std::string arg;
    Lens lens;
    int width = 0, height = 0;          // 0 = leave the output size alone
};

// Ordinary lenses by their 35 mm-equivalent focal length, then fisheyes and
// the whole sphere -- one entry, since a sphere has no lens to tell apart,
// only a size, which is the output's.
const std::vector<LensPreset>& generic_lens_presets();
// 360 cameras: one lens of each.
const std::vector<LensPreset>& camera_lens_presets();

// The lenses in `ds`, one per group of cameras sharing a model, a size and a
// focal length to within a few percent: k-means over the focal ratio inside
// each (model, distortion, size) group, the coefficients averaged.
struct DatasetLens {
    Lens lens;
    int width = 0, height = 0;
    int count = 0;
};
std::vector<DatasetLens> cluster_dataset_lenses(const ParsedDataset& ds);

}  // namespace gui::render
