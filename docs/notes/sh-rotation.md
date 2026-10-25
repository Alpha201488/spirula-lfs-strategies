# Rotating spherical harmonics with a model

Turning a trained model is three lines for its geometry and one real problem
for its colour. The view-dependent part of a Gaussian's colour is a set of
real spherical-harmonic coefficients, evaluated in the direction from the
camera to the Gaussian. Rotate the geometry and leave those coefficients
alone and the highlights stay where they were in the old world while the
object turns under them. This note derives what has to happen to them instead,
and records how that is checked. The code is `src/core/ShRotation.{h,cpp}`;
what uses it is `src/checkpoint/SplatTransform.{h,cpp}`.

## What has to hold

Write a Gaussian's colour as

    colour(d) = sum over l, m of  c_lm * Y_lm(d)

with `d` the unit view direction and `Y_lm` the real basis
`shaders/harmonics.slang` evaluates (`sh_coeffs_to_color`), bands `l = 0..4`.

Rotate the whole scene by `R` -- model and camera together -- and nothing about
the image may change. The direction that was `d` is now `R d`, so the rotated
model's coefficients `c'` have to satisfy

    colour'(R d) = colour(d)      for every d.

## The band matrices

Rotations do not mix bands. For each `l` there is an orthogonal
`(2l+1) x (2l+1)` matrix `M_l(R)`, a representation of the rotation group,
with

    Y_l(R d) = M_l(R) Y_l(d)

where `Y_l(d)` is the column of the `2l+1` basis values of band `l`. Substitute:

    colour'(R d) = c'_l . Y_l(R d) = c'_l . M_l(R) Y_l(d) = (M_l(R)^T c'_l) . Y_l(d)

and this equals `c_l . Y_l(d)` for every `d` exactly when `M_l(R)^T c'_l = c_l`.
`M_l` is orthogonal, so

    c'_l = M_l(R) c_l.

Band 0 is a constant and does not move, which is why the DC colour and the
opacity are untouched by a placement. A translation and a uniform scale do not
change any direction, so only `R` matters.

## Closed form: Ivanic-Ruedenberg

`M_l` can be had by sampling: evaluate the basis at many `d` and at `R d` and
solve for the matrix that maps one to the other. That is what several
implementations in the wild do, and it is what the test below uses as its
reference -- but it is a least-squares solve per rotation, and its accuracy is
the sampling's.

The closed form is the recursion of Ivanic and Ruedenberg ("Rotation Matrices
for Real Spherical Harmonics. Direct Determination by Recursion", J. Phys. Chem.
100:6342, 1996, with the 1998 erratum): `M_l` from `M_1` and `M_(l-1)`, a few
hundred multiplies for all of bands 1 to 4. A placement is one rotation for a
whole model, so the matrices are built ONCE and every Gaussian is then a
matrix-vector product per band per channel: 3 x (9 + 25 + 49 + 81) multiplies
at degree 4.

## The sign convention, which is where this goes wrong

The recursion is stated for the real harmonics WITHOUT the Condon-Shortley
phase. In that basis band 1 is `(y, z, x)`, so `M_1` is simply `R` with its
rows and columns permuted the same way, and the recursion takes it from there.

`harmonics.slang` carries the phase: its band 1 is `(-y, z, -x)`, and in
general its `Y_lm` is `(-1)^m` times the phase-free one. With `S_l` the
diagonal matrix of those signs, `Y^engine = S_l Y^plain`, so

    M_l^engine = S_l M_l^plain S_l

-- entry `(m, n)` changes sign exactly when `m + n` is odd. `ShRotation` runs
the recursion in the phase-free basis and applies that conjugation at the end.

Skipping the conjugation is the classic mistake, and it is a quiet one: bands 1
and 3 come out wrong by signs that a casual look at a render does not catch. It
was caught here before any C++ was written, by prototyping both variants
against the sampled fit: the phase-free matrices were off by order 1 in every
band, the conjugated ones agreed to 1e-15.

## How it is held to that

`src/core/tests/sh_rotation_test.cpp` transcribes the 25 basis functions from
`harmonics.slang`, constant for constant, and checks, over random rotations
plus the quarter and half turns about each axis:

- every band matrix equals the sampled least-squares fit of that basis
  (measured: 2.8e-15);
- every band matrix is orthogonal;
- `M(R1 R2) = M(R1) M(R2)`;
- for degrees 0 to 4, random coefficients rotated by `apply()` give
  `colour'(R d) = colour(d)` in float;
- coefficient rows past the last complete band are left alone.

That test shares no code with the engine, so it cannot say the transcription
is right. `src/backend/tests/engine/splat_transform_render.cpp` closes the
loop on the real thing: render a random scene with strong view dependence,
bake a similarity into the splats with `transform_splats`, move the camera by
the same similarity, render again. The two images have to match -- measured
mean |difference| 3e-7 for 3dgs, mip and 3dgut, pinhole and fisheye, SH degree
3 and 4 -- and a control that moves everything EXCEPT the SH has to differ
visibly (it does, by 0.07 to 0.13), so the test is known to see the thing it is
for.

One thing that test found that is not about SH: the 3dgut rasterizer builds its
rotation from the stored quaternion as is, without normalizing, so it is only
rotation-equivariant for unit quaternions. The optimizer leaves them unit after
every step (`FusedGeometryOptim.cu`), so trained models are fine, and
`SplatTransform` keeps whatever length the file had rather than renormalizing
-- a second edit nobody asked for.
