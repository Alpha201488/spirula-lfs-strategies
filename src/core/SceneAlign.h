#pragma once

// Finding the frame a scene WANTS: its ground, its walls, a corner of it.
//
// Everything here is geometry over a bare point array, in whatever frame the
// caller hands it, so it is testable without a window. Planes come from
// RANSAC and are then refit by least squares over their inliers; a fit that
// starts from a click GROWS outward while the surface keeps agreeing with it,
// because a floor measured over a metre levels a room better than one
// measured over the hand-width around the cursor.

#include "core/Similarity.h"

#include <cstdint>
#include <vector>

namespace spirula {
namespace align {

// n . x + d = 0, n unit.
struct Plane {
    double n[3] = {0, 0, 1};
    double d = 0.0;
    int64_t inliers = 0;
    double distance(const double p[3]) const {
        return n[0]*p[0] + n[1]*p[1] + n[2]*p[2] + d;
    }
};

// The best-supported plane within `tol`. `inlier`, when given, comes back one
// flag per point. False when no three points agree on anything.
bool fit_plane(const double* pts, int64_t n, double tol, uint32_t seed,
               Plane& out, std::vector<uint8_t>* inlier = nullptr);

// Up to `k` planes, largest first, each one's inliers removed before the next
// is looked for. A plane holding under `min_frac` of the points ends the list.
std::vector<Plane> find_planes(const double* pts, int64_t n, double tol, int k,
                               double min_frac);

// The surface under a click: fitted within `r0` of `at`, then refitted over
// twice the radius for as long as the wider patch still lies on it.
bool fit_plane_at(const double* pts, int64_t n, const double at[3], double r0,
                  Plane& out);

// Up to three mutually perpendicular surfaces meeting near `at`, made exactly
// orthogonal. `axes` rows are their normals; `corner` is where they meet (the
// click, projected, when fewer than three were found). Returns how many.
int fit_corner(const double* pts, int64_t n, const double at[3], double r0,
               double axes[9], double corner[3]);

// The shortest rotation taking unit `a` onto unit `b`, row-major.
void rotation_between(const double a[3], const double b[3], double R[9]);

struct AutoAlignOptions {
    double tol = 0.01;           // plane thickness, in the points' own units
    bool yaw = true;             // turn the walls onto the axes
    bool centre = true;          // put the middle of the footprint at x=y=0
};

struct AutoAlignResult {
    Sim3 T;
    bool ground = false, walls = false;
    double ground_share = 0.0;   // of the points, within tol of the ground
    Plane plane;                 // the ground, in the input frame, facing up
};

// Twice the median distance from the per-axis median: a size floaters do not
// inflate, which is what `AutoAlignOptions::tol` is best taken a fraction of.
double robust_extent(const double* pts, int64_t n);

// Ground to z = 0 with +Z up, walls onto the axes, footprint on the origin.
// `up` is a prior (null for +Z). `normals` / `weights` are optional, one per
// point: with them the walls come from the normals rather than from planes.
AutoAlignResult auto_align(const double* pts, int64_t n, const double* up,
                           const float* normals, const float* weights,
                           const AutoAlignOptions& opt);

}  // namespace align
}  // namespace spirula
