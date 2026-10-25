#pragma once

// Rotating spherical-harmonic colour with the model that carries it.
//
// For the real basis shaders/harmonics.slang evaluates there is, per band l,
// an orthogonal (2l+1)^2 matrix M_l with Y_l(R d) = M_l(R) Y_l(d). A model
// turned by R must look from R d the way it looked from d, so its band-l
// coefficients become M_l(R) c_l. M_l comes from M_1 and M_(l-1) by the
// Ivanic-Ruedenberg recursion (J. Phys. Chem. 100:6342, 1996; erratum 1998):
// closed form, no sampling. Derivation and the sign convention are in
// docs/notes/sh-rotation.md; core/tests/sh_rotation_test.cpp holds it to a
// sampled least-squares fit of that exact basis.

#include <vector>

namespace spirula {

class ShRotation {
public:
    static constexpr int kMaxDegree = 4;

    // `R` is row-major 3x3, a proper rotation. Bands 1..degree are built.
    ShRotation(const double R[9], int degree);

    int degree() const { return _degree; }
    // M_l, row-major (2l+1) x (2l+1), rows and columns ordered m = -l..l.
    const double* band(int l) const { return _m[l].data(); }

    // One splat's rows in place: [coeffs, 3] coefficient-major, band 1 first
    // and DC excluded, as checkpoint/SplatPly.h holds them. A band the rows
    // do not complete is left alone.
    void apply(float* rest, int coeffs) const;

private:
    int _degree;
    std::vector<double> _m[kMaxDegree + 1];
};

}  // namespace spirula
