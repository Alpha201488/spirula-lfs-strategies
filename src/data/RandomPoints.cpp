#include "data/RandomPoints.h"

#include "data/SceneCenter.h"
#include "i18n/catalog/Data.h"
#include "sfm/geometry/LinAlg.h"

#include <algorithm>
#include <cmath>
#include <random>
#include <stdexcept>
#include <vector>

namespace {

double median_of(std::vector<double> v) {
    if (v.empty()) return 0.0;
    const size_t mid = v.size() / 2;
    std::nth_element(v.begin(), v.begin() + (long)mid, v.end());
    const double hi = v[mid];
    if (v.size() % 2) return hi;
    return 0.5 * (hi + *std::max_element(v.begin(), v.begin() + (long)mid));
}

dsparse::CenterMode center_mode(const std::string& name) {
    if (name == "camera-median") return dsparse::CenterMode::CameraMedian;
    if (name == "camera-focus")  return dsparse::CenterMode::CameraFocus;
    if (name == "camera-mean")   return dsparse::CenterMode::CameraMean;
    if (name == "origin")        return dsparse::CenterMode::None;
    throw std::runtime_error("unknown random_init_center '" + name + "'");
}

}  // namespace

ColmapPoints3D random_seed_points(const float* c2w_f, int64_t n,
                                  const RandomPointsConfig& cfg,
                                  RandomPointsFit* fit) {
    const std::string& dist = cfg.distribution;
    if (dist != "isotropic-gaussian" && dist != "anisotropic-gaussian" &&
        dist != "ellipsoid" && dist != "box")
        throw std::runtime_error("unknown random_init_distribution '" + dist + "'");
    if (cfg.spread != "median" && cfg.spread != "mean")
        throw std::runtime_error("unknown random_init_spread '" + cfg.spread + "'");

    std::vector<double> c2w(c2w_f, c2w_f + (size_t)std::max<int64_t>(n, 0) * 12);
    const std::array<double, 3> mu =
        dsparse::scene_center(center_mode(cfg.center), c2w.data(), n,
                              (const double*)nullptr, 0);

    // The cameras' second moment about the centre, and its principal axes.
    std::vector<std::array<double, 3>> d((size_t)std::max<int64_t>(n, 0));
    std::vector<double> M(9, 0.0);
    for (int64_t i = 0; i < n; i++) {
        for (int r = 0; r < 3; r++) d[(size_t)i][r] = c2w[(size_t)i * 12 + r * 4 + 3] - mu[r];
        for (int r = 0; r < 3; r++)
            for (int c = 0; c < 3; c++) M[r * 3 + c] += d[(size_t)i][r] * d[(size_t)i][c];
    }
    for (double& m : M) m /= (double)std::max<int64_t>(n, 1);
    const double trace = M[0] + M[4] + M[8];
    std::vector<double> w, V;
    std::vector<double> A = M;
    sfm::jacobiEigenSymmetric(A, 3, w, V);
    int order[3] = {0, 1, 2};
    std::sort(order, order + 3, [&](int a, int b) { return w[a] > w[b]; });
    double axis[3][3];
    for (int k = 0; k < 3; k++)
        for (int r = 0; r < 3; r++) axis[k][r] = V[(size_t)r * 3 + order[k]];

    // Variance along each axis, and the isotropic one: a third of the squared
    // distance, averaged or its median.
    double var[3], iso;
    const bool median = cfg.spread == "median";
    if (median) {
        std::vector<double> sq((size_t)std::max<int64_t>(n, 0));
        for (int k = 0; k < 3; k++) {
            for (int64_t i = 0; i < n; i++) {
                const auto& v = d[(size_t)i];
                const double p = v[0] * axis[k][0] + v[1] * axis[k][1] + v[2] * axis[k][2];
                sq[(size_t)i] = p * p;
            }
            var[k] = median_of(sq);
        }
        for (int64_t i = 0; i < n; i++) {
            const auto& v = d[(size_t)i];
            sq[(size_t)i] = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
        }
        iso = median_of(sq) / 3.0;
    } else {
        for (int k = 0; k < 3; k++) var[k] = std::max(0.0, w[order[k]]);
        iso = trace / 3.0;
    }

    double sigma[3];
    for (int k = 0; k < 3; k++)
        sigma[k] = cfg.std_scale * std::sqrt(dist == "isotropic-gaussian" ? iso : var[k]);
    if (!(sigma[0] > 0.0) || !std::isfinite(sigma[0]))
        throw std::runtime_error(spirula::i18n::format(
            spirula::i18n::msg::data::random_init_no_spread, {cfg.center}));
    if (fit) {
        fit->center = mu;
        for (int k = 0; k < 3; k++) fit->sigma[k] = sigma[k];
    }

    // Each shape's extent along an axis, for the covariance the Gaussian has:
    // a uniform [-h, h] has variance h^2 / 3, a solid ball of radius a a^2 / 5.
    double extent[3];
    for (int k = 0; k < 3; k++)
        extent[k] = sigma[k] * (dist == "box" ? std::sqrt(3.0)
                                : dist == "ellipsoid" ? std::sqrt(5.0) : 1.0);

    std::mt19937_64 rng(cfg.seed);
    std::normal_distribution<double> gauss(0.0, 1.0);
    std::uniform_real_distribution<double> uni(0.0, 1.0);
    std::uniform_int_distribution<int> byte(0, 255);

    ColmapPoints3D out;
    const int64_t count = std::max<int64_t>(cfg.count, 0);
    out.xyz.resize((size_t)count * 3);
    out.rgb.resize((size_t)count * 3);
    for (int64_t i = 0; i < count; i++) {
        double u[3];
        if (dist == "box") {
            for (double& x : u) x = 2.0 * uni(rng) - 1.0;
        } else {
            for (double& x : u) x = gauss(rng);
            if (dist == "ellipsoid") {
                const double len = std::sqrt(u[0] * u[0] + u[1] * u[1] + u[2] * u[2]);
                const double r = std::cbrt(uni(rng)) / std::max(len, 1e-300);
                for (double& x : u) x *= r;
            }
        }
        for (int r = 0; r < 3; r++) {
            double p = mu[r];
            for (int k = 0; k < 3; k++) p += extent[k] * u[k] * axis[k][r];
            out.xyz[(size_t)i * 3 + r] = p;
        }
        for (int c = 0; c < 3; c++) out.rgb[(size_t)i * 3 + c] = (uint8_t)byte(rng);
    }
    return out;
}
