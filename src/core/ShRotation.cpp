// ShRotation.cpp -- see ShRotation.h.

#include "core/ShRotation.h"

#include <algorithm>
#include <cmath>
#include <stdexcept>

namespace spirula {

namespace {

// A band matrix indexed by m, n in [-l, l].
struct Band {
    const double* m;
    int l;
    double operator()(int a, int b) const {
        return m[(size_t)(a + l) * (2 * l + 1) + (b + l)];
    }
};

}  // namespace

ShRotation::ShRotation(const double R[9], int degree)
    : _degree(std::clamp(degree, 0, kMaxDegree)) {
    if (degree > kMaxDegree)
        throw std::runtime_error("ShRotation: degree above 4 is not supported");
    _m[0] = {1.0};
    if (_degree < 1) return;

    // Band 1 of the SIGN-FREE real basis is (y, z, x), so its matrix is R
    // under that permutation. The recursion below runs in that basis.
    const int p[3] = {1, 2, 0};
    std::vector<double> r1(9);
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++) r1[(size_t)i * 3 + j] = R[p[i] * 3 + p[j]];
    _m[1] = r1;
    const Band B1{_m[1].data(), 1};

    for (int l = 2; l <= _degree; l++) {
        const int w = 2 * l + 1;
        _m[l].assign((size_t)w * w, 0.0);
        const Band prev{_m[l - 1].data(), l - 1};
        auto P = [&](int i, int a, int b) {
            if (b == l)
                return B1(i, 1) * prev(a, l - 1) - B1(i, -1) * prev(a, -l + 1);
            if (b == -l)
                return B1(i, 1) * prev(a, -l + 1) + B1(i, -1) * prev(a, l - 1);
            return B1(i, 0) * prev(a, b);
        };
        for (int m = -l; m <= l; m++)
            for (int n = -l; n <= l; n++) {
                const int am = std::abs(m);
                const double d = std::abs(n) == l ? (double)(2 * l) * (2 * l - 1)
                                                  : (double)(l + n) * (l - n);
                const double d0 = m == 0 ? 1.0 : 0.0;
                const double u = std::sqrt((double)(l + m) * (l - m) / d);
                const double v = 0.5 * (1.0 - 2.0 * d0) *
                    std::sqrt((1.0 + d0) * (l + am - 1) * (l + am) / d);
                const double ww = -0.5 * (1.0 - d0) *
                    std::sqrt((double)(l - am - 1) * (l - am) / d);
                double acc = 0.0;
                if (u != 0.0) acc += u * P(0, m, n);
                if (v != 0.0) {
                    double V;
                    if (m == 0) V = P(1, 1, n) + P(-1, -1, n);
                    else if (m > 0)
                        V = m == 1 ? std::sqrt(2.0) * P(1, 0, n)
                                   : P(1, m - 1, n) - P(-1, -m + 1, n);
                    else
                        V = m == -1 ? std::sqrt(2.0) * P(-1, 0, n)
                                    : P(1, m + 1, n) + P(-1, -m - 1, n);
                    acc += v * V;
                }
                if (ww != 0.0)
                    acc += ww * (m > 0 ? P(1, m + 1, n) + P(-1, -m - 1, n)
                                       : P(1, m - 1, n) - P(-1, -m + 1, n));
                _m[l][(size_t)(m + l) * w + (n + l)] = acc;
            }
    }

    // harmonics.slang carries the Condon-Shortley phase, (-1)^m on Y_lm, so
    // its matrices are these conjugated by that diagonal.
    for (int l = 1; l <= _degree; l++) {
        const int w = 2 * l + 1;
        for (int a = -l; a <= l; a++)
            for (int b = -l; b <= l; b++)
                if ((a + b) & 1) _m[l][(size_t)(a + l) * w + (b + l)] *= -1.0;
    }
}

void ShRotation::apply(float* rest, int coeffs) const {
    double tmp[2 * kMaxDegree + 1][3];
    for (int l = 1; l <= _degree; l++) {
        const int w = 2 * l + 1;
        const int at = l * l - 1;             // DC is not in `rest`
        if (at + w > coeffs) break;
        const double* M = _m[l].data();
        for (int a = 0; a < w; a++) {
            double acc[3] = {0, 0, 0};
            for (int b = 0; b < w; b++) {
                const double k = M[(size_t)a * w + b];
                const float* c = rest + (size_t)(at + b) * 3;
                acc[0] += k * c[0];
                acc[1] += k * c[1];
                acc[2] += k * c[2];
            }
            tmp[a][0] = acc[0]; tmp[a][1] = acc[1]; tmp[a][2] = acc[2];
        }
        for (int a = 0; a < w; a++) {
            float* c = rest + (size_t)(at + a) * 3;
            c[0] = (float)tmp[a][0]; c[1] = (float)tmp[a][1]; c[2] = (float)tmp[a][2];
        }
    }
}

}  // namespace spirula
