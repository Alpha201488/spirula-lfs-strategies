// LensPresets.cpp -- see LensPresets.h.

#include "app/gui/render/LensPresets.h"

#include "data/DatasetParser.h"
#include "i18n/catalog/Render.h"

#include <algorithm>
#include <cmath>
#include <map>
#include <tuple>

namespace msg = spirula::i18n::msg::render;

namespace gui::render {

namespace {

LensPreset perspective_mm(const spirula::i18n::Msg& name, int mm) {
    LensPreset p;
    p.name = &name;
    p.arg = std::to_string(mm);
    p.lens.projection = Projection::Perspective;
    p.lens.focal = mm / 36.0;
    return p;
}

LensPreset wide(const spirula::i18n::Msg& name, Projection proj, double fov) {
    LensPreset p;
    p.name = &name;
    p.arg = std::to_string((int)std::lround(fov));
    p.lens.projection = proj;
    lens_set_fov(p.lens, fov);
    return p;
}

// One fisheye of a dual-lens 360 camera: FISHEYE with the four radial terms
// of the ThinPrism tier, from COLMAP calibrations of real captures.
LensPreset fisheye_of(const char* camera, int size, double focal,
                      const float k[4]) {
    LensPreset p;
    p.name = &msg::preset_one_lens;
    p.arg = camera;
    p.lens.projection = Projection::Fisheye;
    p.lens.focal = focal;
    p.lens.tier = 2;
    for (int i = 0; i < 4; i++) p.lens.dist[i] = k[i];
    p.width = p.height = size;
    return p;
}

}  // namespace

const std::vector<LensPreset>& generic_lens_presets() {
    static const std::vector<LensPreset> presets = [] {
        std::vector<LensPreset> v;
        v.push_back(perspective_mm(msg::preset_ultra_wide, 14));
        v.push_back(perspective_mm(msg::preset_wide, 24));
        v.push_back(perspective_mm(msg::preset_normal_wide, 35));
        v.push_back(perspective_mm(msg::preset_normal, 50));
        v.push_back(perspective_mm(msg::preset_portrait, 85));
        v.push_back(perspective_mm(msg::preset_tele, 135));
        v.push_back(wide(msg::preset_fisheye, Projection::Fisheye, 180.0));
        v.push_back(wide(msg::preset_equisolid, Projection::Equisolid, 180.0));
        LensPreset sphere;
        sphere.name = &msg::preset_sphere;
        sphere.lens.projection = Projection::Equirect;
        v.push_back(sphere);
        return v;
    }();
    return presets;
}

const std::vector<LensPreset>& camera_lens_presets() {
    // Focal ratios and radial terms averaged over the lenses of COLMAP
    // THIN_PRISM_FISHEYE reconstructions: Insta360 X-series frames at
    // 1920 px (f 518.3), DJI Osmo 360 at 3840 px (f 1049.5).
    static const float kInsta[4] = {0.0259f, 0.0117f, -0.0033f, -0.0004f};
    static const float kOsmo[4] = {0.0523f, 0.0136f, -0.0108f, 0.0008f};
    static const std::vector<LensPreset> presets = [] {
        std::vector<LensPreset> v;
        v.push_back(fisheye_of("Insta360 X3 / X4", 2880, 518.3 / 1920.0, kInsta));
        v.push_back(fisheye_of("Insta360 X4 / X5 (8K)", 3840, 518.3 / 1920.0, kInsta));
        v.push_back(fisheye_of("DJI Osmo 360", 3840, 1049.5 / 3840.0, kOsmo));
        return v;
    }();
    return presets;
}

std::vector<DatasetLens> cluster_dataset_lenses(const ParsedDataset& ds) {
    struct Cam { double focal; const float* dist; };
    using Key = std::tuple<int, int, int, int>;   // model, tier, w, h
    std::map<Key, std::vector<Cam>> groups;
    static const float kZero[kLensCoeffs] = {};
    for (int64_t i = 0; i < ds.num_cameras; i++) {
        if ((size_t)i >= ds.widths.size() || (size_t)i * 4 + 3 >= ds.intrins.size()) break;
        const int w = ds.widths[(size_t)i], h = ds.heights[(size_t)i];
        if (w <= 0 || h <= 0) continue;
        const int model = ds.camera_models.empty() ? 0 : ds.camera_models[(size_t)i];
        const int tier = ds.camera_distortions.empty() ? 0 : ds.camera_distortions[(size_t)i];
        const float* d = ds.dist_coeffs.size() >= (size_t)(i + 1) * kLensCoeffs
                             ? &ds.dist_coeffs[(size_t)i * kLensCoeffs] : kZero;
        groups[{model, tier, w, h}].push_back({ds.intrins[(size_t)i * 4] / (double)w, d});
    }

    std::vector<DatasetLens> out;
    for (auto& [key, cams] : groups) {
        // 1D k-means, k grown until every cluster is within 3% of its mean:
        // zoom lenses and several bodies split, one body does not.
        std::vector<double> f;
        for (const Cam& c : cams) f.push_back(c.focal);
        std::sort(f.begin(), f.end());
        std::vector<int> label(cams.size(), 0);
        std::vector<double> centre;
        for (int k = 1; k <= 4; k++) {
            centre.assign((size_t)k, 0.0);
            for (int j = 0; j < k; j++)
                centre[(size_t)j] = f[(size_t)((f.size() - 1) * (2 * j + 1) / (2 * k))];
            for (int iter = 0; iter < 30; iter++) {
                std::vector<double> sum((size_t)k, 0.0);
                std::vector<int> n((size_t)k, 0);
                for (size_t c = 0; c < cams.size(); c++) {
                    int best = 0;
                    for (int j = 1; j < k; j++)
                        if (std::fabs(cams[c].focal - centre[(size_t)j]) <
                            std::fabs(cams[c].focal - centre[(size_t)best]))
                            best = j;
                    label[c] = best;
                    sum[(size_t)best] += cams[c].focal;
                    n[(size_t)best]++;
                }
                for (int j = 0; j < k; j++)
                    if (n[(size_t)j]) centre[(size_t)j] = sum[(size_t)j] / n[(size_t)j];
            }
            bool tight = true;
            for (size_t c = 0; c < cams.size(); c++)
                if (std::fabs(cams[c].focal / centre[(size_t)label[c]] - 1.0) > 0.03)
                    tight = false;
            if (tight) break;
        }
        for (size_t j = 0; j < centre.size(); j++) {
            DatasetLens l;
            l.width = std::get<2>(key);
            l.height = std::get<3>(key);
            l.lens.projection = (Projection)std::clamp(std::get<0>(key), 0, 3);
            l.lens.tier = std::clamp(std::get<1>(key), 0, 2);
            double sum_f = 0.0, sum_d[kLensCoeffs] = {};
            for (size_t c = 0; c < cams.size(); c++) {
                if (label[c] != (int)j) continue;
                l.count++;
                sum_f += cams[c].focal;
                for (int d = 0; d < kLensCoeffs; d++) sum_d[d] += cams[c].dist[d];
            }
            if (!l.count) continue;
            l.lens.focal = sum_f / l.count;
            for (int d = 0; d < kLensCoeffs; d++) l.lens.dist[d] = (float)(sum_d[d] / l.count);
            out.push_back(l);
        }
    }
    std::sort(out.begin(), out.end(),
              [](const DatasetLens& a, const DatasetLens& b) { return a.count > b.count; });
    return out;
}

}  // namespace gui::render
