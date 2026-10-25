// align_fit_test -- core/SceneAlign.h over a room whose answer is known:
// a floor, two walls and a box standing on the floor, with noise and floaters,
// tipped over by a rotation the fit then has to find its way back from.

#include "core/SceneAlign.h"

#include <cmath>
#include <cstdio>
#include <random>
#include <string>
#include <vector>

using spirula::Sim3;
namespace al = spirula::align;

namespace {

int g_failures = 0;

void check(bool ok, const std::string& what) {
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", what.c_str());
    if (!ok) g_failures++;
}

double deg(double rad) { return rad * 180.0 / 3.14159265358979; }

}  // namespace

int main() {
    std::mt19937 rng(3);
    std::uniform_real_distribution<double> u(0.0, 1.0);
    std::normal_distribution<double> g(0.0, 1.0);
    const double noise = 0.004;

    // The room, in the frame it SHOULD end up in: floor z = 0, walls x = 0
    // and y = 0, 4 x 3 x 2.5 units, and a box on the floor.
    std::vector<double> room;
    auto add = [&](double x, double y, double z) {
        room.insert(room.end(), {x + noise * g(rng), y + noise * g(rng),
                                 z + noise * g(rng)});
    };
    for (int i = 0; i < 9000; i++) add(4 * u(rng), 3 * u(rng), 0);
    for (int i = 0; i < 5000; i++) add(0, 3 * u(rng), 2.5 * u(rng));
    for (int i = 0; i < 4000; i++) add(4 * u(rng), 0, 2.5 * u(rng));
    for (int i = 0; i < 1500; i++) add(1.5 + 0.5 * u(rng), 1.2 + 0.5 * u(rng), 0.6);
    for (int i = 0; i < 1500; i++) add(1.5, 1.2 + 0.5 * u(rng), 0.6 * u(rng));
    for (int i = 0; i < 600; i++)                      // floaters
        room.insert(room.end(), {8 * u(rng) - 2, 8 * u(rng) - 2, 6 * u(rng) - 1});
    const int64_t n = (int64_t)room.size() / 3;

    // Tipped over and carried off.
    const double axis[3] = {0.6, -0.64, 0.48}, origin[3] = {0, 0, 0};
    Sim3 tip = Sim3::rotation_about(axis, 0.7, origin);
    tip.t[0] = 3.0; tip.t[1] = -2.0; tip.t[2] = 1.5;
    std::vector<double> pts(room.size());
    for (int64_t i = 0; i < n; i++) tip.apply(&room[i*3], &pts[i*3]);
    double up_tipped[3];
    const double zaxis[3] = {0, 0, 1};
    tip.rotate(zaxis, up_tipped);

    // ---- one plane ----
    {
        al::Plane pl;
        const bool ok = al::fit_plane(pts.data(), n, 0.02, 1u, pl);
        const double c = std::fabs(pl.n[0]*up_tipped[0] + pl.n[1]*up_tipped[1] +
                                   pl.n[2]*up_tipped[2]);
        check(ok && deg(std::acos(std::min(1.0, c))) < 0.3,
              "the largest plane is the floor, to a third of a degree");
    }

    // ---- auto align, with the camera-style up prior 25 degrees off ----
    {
        const double lean[3] = {0.0, 1.0, 0.0};
        Sim3 off = Sim3::rotation_about(lean, 0.43, origin);
        double prior[3];
        off.rotate(up_tipped, prior);
        al::AutoAlignOptions opt;
        opt.tol = 0.02;
        const al::AutoAlignResult r =
            al::auto_align(pts.data(), n, prior, nullptr, nullptr, opt);
        check(r.ground, "auto align: a ground was found");
        check(r.walls, "auto align: the walls were found");
        // r.T * tip should be the identity up to quarter turns about z and a
        // shift in x, y.
        const Sim3 net = r.T * tip;
        check(deg(std::acos(std::min(1.0, net.R[8]))) < 0.3, "auto align: +Z is up");
        const double yaw = deg(std::atan2(net.R[3], net.R[0]));
        const double folded = std::fabs(std::remainder(yaw, 90.0));
        std::printf("     residual yaw %.3f deg, floor height %.4f\n", folded, net.t[2]);
        check(folded < 0.5, "auto align: walls on the axes");
        check(std::fabs(net.t[2]) < 0.01, "auto align: floor at z = 0");
    }

    // ---- a click on the floor beside the box ----
    {
        const double click_room[3] = {1.2, 1.4, 0.0};
        double click[3];
        tip.apply(click_room, click);
        al::Plane pl;
        const bool ok = al::fit_plane_at(pts.data(), n, click, 0.15, pl);
        const double c = std::fabs(pl.n[0]*up_tipped[0] + pl.n[1]*up_tipped[1] +
                                   pl.n[2]*up_tipped[2]);
        std::printf("     click fit: %.3f deg off, %lld points\n",
                    deg(std::acos(std::min(1.0, c))), (long long)pl.inliers);
        check(ok && deg(std::acos(std::min(1.0, c))) < 0.3,
              "a click on the floor finds the floor, not the box beside it");
        check(pl.inliers > 2000, "... and grows well past the first patch");
    }

    // ---- the room's corner ----
    {
        const double corner_room[3] = {0.05, 0.08, 0.04};
        double click[3], axes[9], corner[3];
        tip.apply(corner_room, click);
        const int m = al::fit_corner(pts.data(), n, click, 0.4, axes, corner);
        check(m == 3, "three surfaces meet at the corner");
        double want[3];
        tip.apply(origin, want);
        const double miss = std::sqrt((corner[0]-want[0])*(corner[0]-want[0]) +
                                      (corner[1]-want[1])*(corner[1]-want[1]) +
                                      (corner[2]-want[2])*(corner[2]-want[2]));
        std::printf("     corner found %.4f from where it is\n", miss);
        check(miss < 0.02, "... and the corner point is where they meet");
        // Every found axis is one of the room's, either way round.
        double worst = 0;
        for (int r = 0; r < 3; r++) {
            double best = 0;
            for (int k = 0; k < 3; k++) {
                double e[3] = {0, 0, 0}, w[3];
                e[k] = 1;
                tip.rotate(e, w);
                best = std::max(best, std::fabs(axes[r*3]*w[0] + axes[r*3+1]*w[1] +
                                                axes[r*3+2]*w[2]));
            }
            worst = std::max(worst, deg(std::acos(std::min(1.0, best))));
        }
        check(worst < 0.6, "... and its axes are the room's");
    }

    // ---- rotation_between, including the half turn ----
    {
        const double a[3] = {0, 0, 1}, b[3] = {0, 0, -1};
        double R[9];
        al::rotation_between(a, b, R);
        check(std::fabs(R[8] + 1.0) < 1e-12 &&
                  std::fabs(R[0]*R[4]*R[8] + R[1]*R[5]*R[6] + R[2]*R[3]*R[7] -
                            R[2]*R[4]*R[6] - R[1]*R[3]*R[8] - R[0]*R[5]*R[7] - 1.0) < 1e-9,
              "opposite vectors: a proper half turn");
    }

    std::printf("%s\n", g_failures ? "FAILED" : "all passed");
    return g_failures ? 1 : 0;
}
