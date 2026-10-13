#pragma once

// How the per-cell optimizers treat the lobe cells of a features_sh row
// (core/ColorBasis.h, SbOptimCells): their own rate, no colour trust region,
// and the regularizer as an L2 on the activated amplitude only.

#include "shaders/spherical_beta.slang"

static const uint kSbNoLobes = 0xffffffffu;

// Gradient of 0.5 * decay * softplus(x)^2 on lobe cell `k`, 0 on the axis
// and sharpness cells.
[ForceInline]
float sb_cell_reg_grad(uint k, float x, float decay) {
    if (k % 6u >= 3u)
        return 0.0f;
    return decay * sb_softplus(x) /
           (1.0f + exp(-kSbSoftplusBeta * x));
}
