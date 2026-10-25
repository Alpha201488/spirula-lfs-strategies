// The gauge a finished model is written in when nothing measured one.
//
// A monocular reconstruction has no absolute orientation, position or scale,
// so the model is turned so the cameras' mean up axis is +Z, centred on the
// cameras and sized so the furthest camera coordinate is 1 -- the similarity
// the trainer computes from the poses it loads -- and then levelled on the
// ground its points stand on (groundTransform). "Up" from the cameras is a
// statistical claim about how the capture was held; src/sfm/README.md,
// "--orient", has the reasoning and `--level cameras` / `--no-orient`.
#pragma once

#include <algorithm>
#include <cmath>
#include <string>
#include <vector>

#include "core/SceneAlign.h"
#include "sfm/core/Exif.h"
#include "sfm/core/Model.h"
#include "sfm/core/Pose.h"

namespace sfm {

// The cameras' mean up axis in world coordinates, unnormalized: up is minus the
// second ROW of R (world -> camera, x right, y DOWN, z forward). `use_exif`
// takes each image's up from its Orientation tag -- a portrait file's is 90 off.
inline Vec3 meanCameraUp(const Reconstruction& rec, bool use_exif = false) {
    Vec3 up{0, 0, 0};
    for (const auto& kv : rec.images) {
        const Image& im = kv.second;
        if (!im.registered) continue;
        double u[3] = {0, -1, 0};
        if (use_exif) exifUpInCamera(im.exif_orientation, u);
        // R^T u: the camera-frame up written in world coordinates.
        for (int c = 0; c < 3; c++)
            up = up + Vec3{im.pose.R[3 * c] * u[c], im.pose.R[3 * c + 1] * u[c],
                           im.pose.R[3 * c + 2] * u[c]};
    }
    return up;
}

// Rodrigues rotation taking the unit vector `up` onto +Z, about up x z.
inline Mat3 rotationUpToZ(const Vec3& up) {
    Vec3 axis{up.y, -up.x, 0.0};
    const double s = std::sqrt(axis.x * axis.x + axis.y * axis.y);
    const double c = up.z;
    Mat3 R = mat3Identity();
    if (s > 1e-12) {
        axis = axis * (1.0 / s);
        const double C = 1.0 - c;
        R = Mat3{c + axis.x * axis.x * C,       axis.x * axis.y * C - axis.z * s, axis.y * s,
                 axis.x * axis.y * C + axis.z * s, c + axis.y * axis.y * C,      -axis.x * s,
                 -axis.y * s,                   axis.x * s,                       c};
    } else if (c < 0.0) {
        R = Mat3{1, 0, 0, 0, -1, 0, 0, 0, -1};   // up == -z: flip
    }
    return R;
}

// The similarity turning `rec` by `R`, centred on the cameras and unit-sized.
// Identity with under two registered images.
inline Sim3 normalizingTransform(const Reconstruction& rec, const Mat3& R) {
    Sim3 T;
    std::vector<Vec3> centers;
    Vec3 mid{0, 0, 0};
    for (const auto& kv : rec.images) {
        const Image& im = kv.second;
        if (!im.registered) continue;
        Vec3 c = mul(transpose(im.pose.R), im.pose.t) * -1.0;
        centers.push_back(c);
        mid = mid + c;
    }
    if (centers.size() < 2) return T;
    mid = mid * (1.0 / (double)centers.size());

    // Scale so the furthest camera coordinate lands on 1. Per component, not
    // by norm: that is what the trainer does, and the point of doing this here
    // is that the two agree.
    double max_abs = 0.0;
    for (const Vec3& p : centers) {
        const Vec3 d = mul(R, p - mid);
        max_abs = std::max(max_abs, std::abs(d.x));
        max_abs = std::max(max_abs, std::abs(d.y));
        max_abs = std::max(max_abs, std::abs(d.z));
    }
    T.scale = max_abs > 1e-12 ? 1.0 / max_abs : 1.0;
    T.R = R;
    T.t = mul(R, mid) * -T.scale;
    return T;
}

// The same, turned so that `up` is +Z. Identity when `up` is zero.
inline Sim3 normalizingTransform(const Reconstruction& rec, const Vec3& up) {
    const double un = up.norm();
    if (!(un > 1e-12)) return Sim3{};
    return normalizingTransform(rec, rotationUpToZ(up * (1.0 / un)));
}

// Orientation tags for models that did not come from this run's features --
// `merge` and a resumed `map` read theirs off disk, which records no tag. One
// image already carrying a turn stops it: the features are the authority.
inline int fillExifOrientations(std::vector<Reconstruction>& models,
                                const std::string& imagedir) {
    if (imagedir.empty()) return 0;
    for (const Reconstruction& m : models)
        for (const auto& kv : m.images)
            if (kv.second.exif_orientation != 1) return 0;
    int read = 0;
    for (Reconstruction& m : models)
        for (auto& kv : m.images)
            if (kv.second.registered) {
                kv.second.exif_orientation =
                    (uint8_t)exifOrientation(imagedir + "/" + kv.second.name);
                read++;
            }
    return read;
}

// The same, with up taken from the cameras themselves.
inline Sim3 uprightTransform(const Reconstruction& rec, bool use_exif = false) {
    return normalizingTransform(rec, meanCameraUp(rec, use_exif));
}

// Apply it. Poses and 3D points are the only things in a Reconstruction with
// world units in them: intrinsics are per-camera, 2D observations are pixels,
// and a reprojection error is a pixel count -- all unchanged by a change of
// world gauge, which is the whole reason this is safe to do at the end.
inline void applySim3(Reconstruction& rec, const Sim3& T) {
    for (auto& kv : rec.images)
        if (kv.second.registered) kv.second.pose = transformPose(T, kv.second.pose);
    for (auto& kv : rec.points3D) kv.second.xyz = transformPoint(T, kv.second.xyz);
    transformRigs(rec.rigs, T.scale);
}

// Levelled on the ground the points stand on rather than on how the cameras
// were held: the editor's Auto align (core/SceneAlign.h). `rec`'s +Z is the
// prior, and a ground more than 60 degrees from it is not taken.
struct GroundFit {
    Sim3 T;               // identity when no ground was found
    bool found = false;
    double share = 0.0;   // of the points, on the ground
};

// `full`: ground at z = 0 and level, walls onto the axes, footprint on the
// origin, scale kept; otherwise only a move along Z putting the ground at 0.
// `pre` is where the model is about to go, applied to the points sampled.
inline GroundFit groundTransform(const Reconstruction& rec, bool full,
                                 const Sim3& pre = Sim3{}) {
    GroundFit out;
    std::vector<double> pts;
    const size_t step = std::max<size_t>(1, rec.points3D.size() / 250000);
    size_t k = 0;
    for (const auto& kv : rec.points3D) {
        if (k++ % step) continue;
        const Vec3 p = transformPoint(pre, kv.second.xyz);
        pts.insert(pts.end(), {p.x, p.y, p.z});
    }
    const int64_t n = (int64_t)pts.size() / 3;
    if (n < 16) return out;
    namespace al = spirula::align;
    al::AutoAlignOptions opt;
    opt.tol = 0.01 * al::robust_extent(pts.data(), n);
    opt.yaw = opt.centre = full;
    const double up[3] = {0, 0, 1};
    const al::AutoAlignResult r = al::auto_align(pts.data(), n, up, nullptr, nullptr, opt);
    if (!r.ground || !(opt.tol > 0.0)) return out;
    out.found = true;
    out.share = r.ground_share;
    if (full) {
        for (int i = 0; i < 9; i++) out.T.R[(size_t)i] = r.T.R[i];
        out.T.t = Vec3{r.T.t[0], r.T.t[1], r.T.t[2]};
        return out;
    }
    // The plane's height under the middle of the footprint.
    std::vector<double> xs, ys;
    for (int64_t i = 0; i < n; i++) {
        xs.push_back(pts[(size_t)i * 3]);
        ys.push_back(pts[(size_t)i * 3 + 1]);
    }
    std::nth_element(xs.begin(), xs.begin() + xs.size() / 2, xs.end());
    std::nth_element(ys.begin(), ys.begin() + ys.size() / 2, ys.end());
    const al::Plane& g = r.plane;
    const double z = -(g.n[0] * xs[xs.size() / 2] + g.n[1] * ys[ys.size() / 2] + g.d) / g.n[2];
    out.T.t = Vec3{0, 0, -z};
    return out;
}

}  // namespace sfm
