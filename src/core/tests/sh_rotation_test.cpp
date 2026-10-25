// sh_rotation_test -- core/ShRotation.h against the basis it has to match.
//
// The reference is the slow, obviously-right method: sample directions on the
// sphere, evaluate the basis at d and at R d, and solve for the matrix that
// maps one to the other. The closed form must agree with it to rounding, be
// orthogonal, compose like the rotations do, and leave a rotated model
// looking from R d exactly as the original looked from d.

#include "core/ShRotation.h"

#include <array>
#include <cmath>
#include <cstdio>
#include <random>
#include <string>
#include <vector>

namespace {

int g_failures = 0;

void check(bool ok, const std::string& what) {
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", what.c_str());
    if (!ok) g_failures++;
}

// The 25 basis values of shaders/harmonics.slang sh_coeffs_to_color, constant
// for constant: a change there has to be a change here.
void basis(const double d[3], double o[25]) {
    const double x = d[0], y = d[1], z = d[2];
    o[0] = 0.2820947917738781;
    const double c1 = 0.48860251190292;
    o[1] = -c1 * y; o[2] = c1 * z; o[3] = -c1 * x;
    const double z2 = z * z;
    const double fTmp0B = -1.092548430592079 * z;
    const double fTmp1A = 0.5462742152960395;
    const double fC1 = x * x - y * y, fS1 = 2.0 * x * y;
    o[6] = 0.9461746957575601 * z2 - 0.3153915652525201;
    o[7] = fTmp0B * x; o[5] = fTmp0B * y;
    o[8] = fTmp1A * fC1; o[4] = fTmp1A * fS1;
    const double fTmp0C = -2.285228997322329 * z2 + 0.4570457994644658;
    const double fTmp1B = 1.445305721320277 * z;
    const double fTmp2A = -0.5900435899266435;
    const double fC2 = x * fC1 - y * fS1, fS2 = x * fS1 + y * fC1;
    o[12] = z * (1.865881662950577 * z2 - 1.119528997770346);
    o[13] = fTmp0C * x; o[11] = fTmp0C * y;
    o[14] = fTmp1B * fC1; o[10] = fTmp1B * fS1;
    o[15] = fTmp2A * fC2; o[9] = fTmp2A * fS2;
    const double fTmp0D = z * (-4.683325804901025 * z2 + 2.007139630671868);
    const double fTmp1C = 3.31161143515146 * z2 - 0.47308734787878;
    const double fTmp2B = -1.770130769779931 * z;
    const double fC3 = x * fC2 - y * fS2, fS3 = x * fS2 + y * fC2;
    o[20] = 1.984313483298443 * z * o[12] - 1.006230589874905 * o[6];
    o[21] = fTmp0D * x; o[19] = fTmp0D * y;
    o[22] = fTmp1C * fC1; o[18] = fTmp1C * fS1;
    o[23] = fTmp2B * fC2; o[17] = fTmp2B * fS2;
    o[24] = 0.6258357354491763 * fC3; o[16] = 0.6258357354491763 * fS3;
}

void quat_to_R(const double q[4], double R[9]) {
    const double w = q[0], x = q[1], y = q[2], z = q[3];
    const double M[9] = {1-2*(y*y+z*z), 2*(x*y-z*w), 2*(x*z+y*w),
                         2*(x*y+z*w), 1-2*(x*x+z*z), 2*(y*z-x*w),
                         2*(x*z-y*w), 2*(y*z+x*w), 1-2*(x*x+y*y)};
    for (int i = 0; i < 9; i++) R[i] = M[i];
}

void rotate(const double R[9], const double d[3], double o[3]) {
    for (int r = 0; r < 3; r++)
        o[r] = R[r*3+0]*d[0] + R[r*3+1]*d[1] + R[r*3+2]*d[2];
}

void matmul3(const double a[9], const double b[9], double o[9]) {
    for (int r = 0; r < 3; r++)
        for (int c = 0; c < 3; c++) {
            o[r*3+c] = 0;
            for (int k = 0; k < 3; k++) o[r*3+c] += a[r*3+k] * b[k*3+c];
        }
}

// Gaussian elimination with partial pivoting, A [n,n] and B [n,m] in place.
bool solve(std::vector<double>& A, std::vector<double>& B, int n, int m) {
    for (int c = 0; c < n; c++) {
        int best = c;
        for (int r = c + 1; r < n; r++)
            if (std::fabs(A[r*n+c]) > std::fabs(A[best*n+c])) best = r;
        if (std::fabs(A[best*n+c]) < 1e-14) return false;
        for (int k = 0; k < n; k++) std::swap(A[c*n+k], A[best*n+k]);
        for (int k = 0; k < m; k++) std::swap(B[c*m+k], B[best*m+k]);
        for (int r = 0; r < n; r++) {
            if (r == c) continue;
            const double f = A[r*n+c] / A[c*n+c];
            for (int k = c; k < n; k++) A[r*n+k] -= f * A[c*n+k];
            for (int k = 0; k < m; k++) B[r*m+k] -= f * B[c*m+k];
        }
    }
    for (int r = 0; r < n; r++)
        for (int k = 0; k < m; k++) B[r*m+k] /= A[r*n+r];
    return true;
}

// M with Y_l(R d) = M Y_l(d), by least squares over `dirs`.
std::vector<double> sampled_band(const double R[9], int l,
                                 const std::vector<double>& dirs) {
    const int w = 2 * l + 1, at = l * l;
    std::vector<double> AtA((size_t)w * w, 0.0), AtB((size_t)w * w, 0.0);
    for (size_t i = 0; i + 2 < dirs.size(); i += 3) {
        double a[25], b[25], rd[3];
        basis(&dirs[i], a);
        rotate(R, &dirs[i], rd);
        basis(rd, b);
        for (int r = 0; r < w; r++)
            for (int c = 0; c < w; c++) {
                AtA[(size_t)r*w+c] += a[at+r] * a[at+c];
                AtB[(size_t)r*w+c] += a[at+r] * b[at+c];
            }
    }
    solve(AtA, AtB, w, w);               // AtB = X with A X = B, X = M^T
    std::vector<double> M((size_t)w * w);
    for (int r = 0; r < w; r++)
        for (int c = 0; c < w; c++) M[(size_t)r*w+c] = AtB[(size_t)c*w+r];
    return M;
}

double eval(const std::vector<float>& rest, int degree, const double d[3]) {
    double y[25];
    basis(d, y);
    double acc = 0.0;
    const int n = (degree + 1) * (degree + 1);
    for (int j = 1; j < n; j++) acc += y[j] * rest[(size_t)(j - 1) * 3];
    return acc;
}

}  // namespace

int main() {
    std::mt19937 rng(11);
    std::normal_distribution<double> g(0.0, 1.0);
    auto unit = [&](int n, double* o) {
        double s = 0;
        for (int i = 0; i < n; i++) { o[i] = g(rng); s += o[i] * o[i]; }
        s = std::sqrt(s);
        for (int i = 0; i < n; i++) o[i] /= s;
    };
    std::vector<double> dirs(3 * 600);
    for (size_t i = 0; i < dirs.size(); i += 3) unit(3, &dirs[i]);

    // Random rotations plus the ones most likely to expose a sign or an
    // ordering slip: quarter and half turns about each axis, and identity.
    std::vector<std::array<double, 9>> rots;
    for (int k = 0; k < 24; k++) {
        double q[4];
        unit(4, q);
        std::array<double, 9> R;
        quat_to_R(q, R.data());
        rots.push_back(R);
    }
    const double h = std::sqrt(0.5);
    const double special[][4] = {{1,0,0,0}, {h,h,0,0}, {h,0,h,0}, {h,0,0,h},
                                 {0,1,0,0}, {0,0,1,0}, {0,0,0,1},
                                 {h,-h,0,0}, {0.5,0.5,0.5,0.5}};
    for (const auto& q : special) {
        std::array<double, 9> R;
        quat_to_R(q, R.data());
        rots.push_back(R);
    }

    double worst_fit = 0, worst_orth = 0;
    for (const auto& R : rots) {
        const spirula::ShRotation sh(R.data(), 4);
        for (int l = 1; l <= 4; l++) {
            const int w = 2 * l + 1;
            const std::vector<double> ref = sampled_band(R.data(), l, dirs);
            const double* M = sh.band(l);
            for (int i = 0; i < w * w; i++)
                worst_fit = std::max(worst_fit, std::fabs(M[i] - ref[(size_t)i]));
            for (int r = 0; r < w; r++)
                for (int c = 0; c < w; c++) {
                    double v = 0;
                    for (int k = 0; k < w; k++) v += M[r*w+k] * M[c*w+k];
                    worst_orth = std::max(worst_orth,
                                          std::fabs(v - (r == c ? 1.0 : 0.0)));
                }
        }
    }
    std::printf("     closed form vs sampled fit: max |diff| = %.3g\n", worst_fit);
    check(worst_fit < 1e-9, "bands 1-4 equal the sampled least-squares fit");
    check(worst_orth < 1e-12, "every band matrix is orthogonal");

    double worst_comp = 0;
    for (size_t i = 0; i + 1 < rots.size(); i += 2) {
        double R12[9];
        matmul3(rots[i].data(), rots[i + 1].data(), R12);
        const spirula::ShRotation a(rots[i].data(), 4), b(rots[i + 1].data(), 4),
                                  ab(R12, 4);
        for (int l = 1; l <= 4; l++) {
            const int w = 2 * l + 1;
            for (int r = 0; r < w; r++)
                for (int c = 0; c < w; c++) {
                    double v = 0;
                    for (int k = 0; k < w; k++)
                        v += a.band(l)[r*w+k] * b.band(l)[k*w+c];
                    worst_comp = std::max(worst_comp,
                                          std::fabs(v - ab.band(l)[r*w+c]));
                }
        }
    }
    check(worst_comp < 1e-12, "M(R1 R2) = M(R1) M(R2)");

    // What it is for: the turned model seen from R d is the model seen from d.
    for (int degree = 0; degree <= 4; degree++) {
        const int n = (degree + 1) * (degree + 1) - 1;
        double worst = 0;
        for (const auto& R : rots) {
            std::vector<float> c((size_t)std::max(n, 1) * 3);
            for (float& v : c) v = (float)g(rng);
            std::vector<float> turned = c;
            spirula::ShRotation(R.data(), degree).apply(turned.data(), n);
            for (size_t i = 0; i < 60 * 3; i += 3) {
                double rd[3];
                rotate(R.data(), &dirs[i], rd);
                worst = std::max(worst, std::fabs(eval(turned, degree, rd) -
                                                  eval(c, degree, &dirs[i])));
            }
        }
        check(worst < 2e-5, "degree " + std::to_string(degree) +
                                ": colour(R d) of the turned model = colour(d)");
    }

    // A file with fewer bands than the rotation was built for.
    {
        std::vector<float> c(8 * 3, 1.0f), was = c;
        spirula::ShRotation(rots[0].data(), 4).apply(c.data(), 3);
        bool tail_kept = true;
        for (size_t i = 9; i < c.size(); i++) tail_kept &= c[i] == was[i];
        check(tail_kept, "rows past the last complete band are left alone");
    }

    std::printf("%s\n", g_failures ? "FAILED" : "all passed");
    return g_failures ? 1 : 0;
}
