#pragma once

// EngineStrategy -- engine-level ports of the LichtFeld Studio densification
// strategies (IGS+ / MRNF / MCMC), adapted to Spirula's out-of-core splat
// storage and kernel set.
//
// Provenance: the algorithmic flows (budget schedule, dual scoring, prune /
// reset, free-slot reuse, far-field management, starvation weighting,
// MCMC relocation ratios) are ported from LichtFeld Studio
// (src/training/strategies/{improved_gs_plus,mcmc,mrnf}.cpp, GPL-3.0) and
// re-implemented on Spirula's engine primitives. The out-of-core memory
// scheduling itself is unchanged Spirula -- that is the whole point: LFS
// quality logic on Spirula's memory model.
//
// SPDX-FileCopyrightText: 2025 LichtFeld Studio Authors (ported logic)
// SPDX-FileCopyrightText: 2026 Spirula strategy-port Authors
// SPDX-License-Identifier: GPL-3.0-or-later

#include "engine/EngineConfig.h"

#include <string>

// "revised" / "igs+" / "mrnf" / "mcmc". Unknown strings map to Revised.
StrategyId engine_strategy_id_from_string(const std::string& s);

// Release strategy state (called from engine_reset()).
void engine_strategy_reset();

// Strategy densify entrypoint. Called from engine_densify_step() when
// cfg.strategy != StrategyId::Revised; owns the whole accumulate-every-step /
// densify-at-refine cadence, mirroring the stock path's contract:
// returns the number of splats added this step and updates
// engine().cur_num_splats.
int engine_strategy_densify(int step, int max_steps, const DensifyConfig& cfg);
