// EngineStrategy.cpp -- engine-level ports of the LichtFeld Studio
// densification strategies (IGS+ / MRNF / MCMC), adapted to Spirula's
// out-of-core splat storage and kernel set.
//
// Provenance: the algorithmic flows below (Taming-3DGS budget schedule,
// IGS+ dual edge+error scoring / candidate top-k / opacity prune+reset /
// free-slot reuse, MRNF camera-hull far-field + starvation / grow-and-split
// pacing / max-cap enforcement, MCMC relocation ratios) are ported from
// LichtFeld Studio (GPL-3.0) -- see the upstream strategy sources
//   improved_gs_plus.cpp / mrnf.cpp / mcmc.cpp
// in the LichtFeld Studio repository, and re-implemented here on Spirula's engine primitives (accum_buffer,
// quantile, weighted sampling without replacement, long-axis split,
// MCMC relocate/add/noise). See the upstream strategy sources
// improved_gs_plus.cpp / mrnf.cpp / mcmc.cpp in the LichtFeld Studio
// repository for the original algorithms. The out-of-core memory scheduling
// itself is unchanged Spirula: that is the point of the port -- LFS quality
// logic on Spirula's memory model.
//
// Differences vs LFS (documented, deliberate):
//  * Spirula has no free-slot skip in the rasterizer, so a pruned splat is
//    physically zeroed (opacity -> -30 logit) instead of masked, then its
//    slot is reused by the next split (fill-then-append, same order as LFS).
//  * The edge channel scores splats by the laplacian edge of the CURRENT
//    batch render (projected per splat, alpha-weighted), accumulated over the
//    refine window with per-view median normalization -- LFS's render-edge
//    accumulation, re-expressed on Spirula's forward buffers. Pinhole-only;
//    other camera models fall back to error-only scoring.
//  * The MCMC strategy routes to Spirula's stock MCMC kernels (same 3DGS-MCMC
//    algorithm family LFS implements), with the LFS windowed-error and noise
//    cadence applied by this engine.
//
// SPDX-FileCopyrightText: 2025 LichtFeld Studio Authors (ported logic)
// SPDX-FileCopyrightText: 2026 Spirula strategy-port Authors
// SPDX-License-Identifier: GPL-3.0-or-later

#include "engine/Engine.h"
#include "engine/EngineCommon.h"
#include "engine/EngineState.h"
#include "engine/EngineStrategy.h"

#include "kernels/densify/Densify.cuh"
#include "kernels/strategy/StrategyOps.cuh"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <vector>

namespace {

// ---- tiny helpers (same idiom as EngineDensify.cpp) ----
template<typename T>
inline DeviceVector<T> _dv(const TorchTensorView& tv) {
    return DeviceVector<T>(tv);
}
template<typename T>
inline DeviceVector<T> _dv_flat(const TorchTensorView& tv) {
    if (std::get<0>(tv) == 0) return DeviceVector<T>();
    const auto& shape = std::get<2>(tv);
    int64_t flat_count = 1;
    for (size_t i = 0; i + 1 < shape.size(); i++) flat_count *= shape[i];
    TorchTensorView flat_tv(std::get<0>(tv), std::get<1>(tv),
        {flat_count, (int64_t)(sizeof(T) / std::get<1>(tv))});
    return DeviceVector<T>(flat_tv);
}

inline StrategyState& S() { return engine().strategy; }

int64_t _host_count(DeviceVector<int64_t>& dev_scalar) {
    int64_t v = 0;
    backend::memcpy_sync(&v, dev_scalar.data_ptr(), sizeof(int64_t),
                         backend::MemcpyKind::DeviceToHost);
    return v;
}

float _host_sum(DeviceVector<float>& dev_scalar) {
    float v = 0.0f;
    backend::memcpy_sync(&v, dev_scalar.data_ptr(), sizeof(float),
                         backend::MemcpyKind::DeviceToHost);
    return v;
}

void _zero_count(DeviceVector<int64_t>& dev_scalar) {
    backend::memset_sync(dev_scalar.data_ptr(), 0, sizeof(int64_t));
}

void _zero_sum(DeviceVector<float>& dev_scalar) {
    backend::memset_sync(dev_scalar.data_ptr(), 0, sizeof(float));
}

// host-side logit (the device logit() in Common.cuh is __device__ only)
inline float _logit(float x) {
    x = std::max(1e-7f, std::min(1.0f - 1e-7f, x));
    return std::log(x / (1.0f - x));
}

// DeviceVector<float> view over an [N] float array owned elsewhere.
DeviceVector<float> _float_view(float* ptr, int64_t n) {
    TorchTensorView tv((uint64_t)ptr, 4, {n, 1LL});
    return DeviceVector<float>(tv);
}

// Reinterpret a typed row buffer (float3 / float4 / int32 / ...) as a flat
// float view spanning the whole allocation; `stride` is the per-row float
// count passed to the scatter kernels (row indexing stays in floats).
template<typename T>
DeviceVector<float> _row_view(const DeviceVector<T>& v, int64_t stride) {
    if (!v.data_ptr()) return DeviceVector<float>();
    return _float_view((float*)v.data_ptr(), v.size() * stride);
}

// ---- IGS+ budget schedule: Taming 3DGS Eq. (2) (LFS get_count_array) ----
void _build_budget_schedule(StrategyState& st, int64_t initial, int64_t budget,
                            int refine_start, int refine_stop, int refine_every) {
    int total_steps = (refine_every <= 0)
        ? 2
        : (std::max(0, refine_stop - refine_start) / refine_every) + 2;
    total_steps = std::max(2, total_steps);
    const float slope = (float)(budget - initial) / (float)total_steps;
    const float k = 2.0f * slope;
    const float a = ((float)(budget - initial) - k * (float)total_steps)
                    / ((float)total_steps * (float)total_steps);
    const float b = k;
    const float c = (float)initial;
    st.budget_schedule.clear();
    st.budget_schedule.reserve((size_t)total_steps);
    for (int i = 1; i <= total_steps; ++i) {
        double v = (double)a * (double)i * (double)i + (double)b * (double)i + (double)c;
        st.budget_schedule.push_back((int64_t)std::max(1.0, v));
    }
}

// ---- MRNF camera hull (centroid + orbit radius; c2w viewmats) ----
void _update_camera_hull(StrategyState& st) {
    auto& cam = engine().camera;
    st.camera_hull_valid = false;
    int C = cam.num;
    if (C <= 0 || cam.viewmats.data_ptr() == nullptr)
        return;
    std::vector<float4> vm((size_t)C * 4);
    backend::memcpy_sync(vm.data(), cam.viewmats.data_ptr(),
                         (size_t)C * 4 * sizeof(float4),
                         backend::MemcpyKind::DeviceToHost);
    double cx = 0.0, cy = 0.0, cz = 0.0;
    for (int i = 0; i < C; ++i) {
        cx += vm[(size_t)i * 4 + 3].x;
        cy += vm[(size_t)i * 4 + 3].y;
        cz += vm[(size_t)i * 4 + 3].z;
    }
    cx /= (double)C; cy /= (double)C; cz /= (double)C;
    double r = 0.0;
    for (int i = 0; i < C; ++i) {
        double dx = vm[(size_t)i * 4 + 3].x - cx;
        double dy = vm[(size_t)i * 4 + 3].y - cy;
        double dz = vm[(size_t)i * 4 + 3].z - cz;
        r = std::max(r, std::sqrt(dx * dx + dy * dy + dz * dz));
    }
    st.cam_centroid[0] = (float)cx;
    st.cam_centroid[1] = (float)cy;
    st.cam_centroid[2] = (float)cz;
    st.orbit_radius = (float)r;
    st.camera_hull_valid = (float)r > 1e-6f;
}

// Pack the [N] score scratch into [N,2] lane-0 for the weighted sampler,
// then weighted-sample WITHOUT replacement into out_idx.
void _sample_scores(int64_t cur, DeviceVector<int32_t> out_idx,
                    int64_t n_sample, uint32_t seed, bool* mask) {
    strat_pack_lane0_tensor(cur, S().score_scratch, S().score_pair);
    // the sampler reads weights with a fixed stride of 2: reinterpret the
    // float2 allocation as floats so lane 0 lands on even elements
    DeviceVector<float> w = _float_view(
        (float*)S().score_pair.data_ptr(), S().score_pair.size() * 2);
    weighted_sample_without_replacement_tensor(
        cur, w, mask, (uint32_t)n_sample, seed, out_idx);
}

// MRNF far-field starvation: 1.0 when the far share is at/below the target
// cap, ramping to 0.0 at twice the cap (LFS far_starvation_factor shape).
float _far_starvation(const StrategyState& st, int64_t far_active,
                      int64_t total_active, float far_cap) {
    if (total_active <= 0) return 1.0f;
    float share = (float)far_active / (float)total_active;
    float ratio = share / std::max(far_cap, 1e-6f);
    if (ratio <= 1.0f) return 1.0f;
    if (ratio >= 2.0f) return 0.0f;
    return 2.0f - ratio;
}

// ---- allocate strategy buffers on first use ----
void _ensure_strategy_state(const DensifyConfig& cfg, int64_t cur_num_splats) {
    StrategyState& st = S();
    if (st.inited)
        return;
    int64_t max_n = engine().max_num_splats;
    if (max_n <= 0)
        max_n = std::max<int64_t>(1024, cur_num_splats);
    st.mask_a.resize(PoolSlot::EngStrategyMask, max_n);
    st.mask_b.resize(PoolSlot::EngStrategyMask, max_n);
    st.score_scratch.resize(PoolSlot::EngStrategyScore, max_n);
    st.score_pair.resize(PoolSlot::EngStrategyScorePair, max_n);
    st.error_scores.resize(PoolSlot::EngStrategyScore, max_n);
    st.edge_score_sum.resize(PoolSlot::EngStrategyEdge, max_n);
    st.edge_view_score.resize(PoolSlot::EngStrategyEdge, max_n);
    st.idx_scratch.resize(PoolSlot::EngStrategyIdx, max_n);
    st.idx_scratch2.resize(PoolSlot::EngStrategyIdx, max_n);
    st.count_scratch.resize(PoolSlot::EngStrategyScalar, 1);
    st.sum_scratch.resize(PoolSlot::EngStrategyScalar, 1);
    st.mask_a.zero();
    st.mask_b.zero();
    st.score_scratch.zero();
    st.score_pair.zero();
    st.error_scores.zero();
    st.edge_score_sum.zero();
    st.edge_view_score.zero();

    st.initial_splats = cur_num_splats;
    st.refine_step_idx = 0;
    st.max_cap_reached = false;
    st.camera_hull_valid = false;
    st.far_starvation = 1.0f;
    st.edge_view_count = 0;
    st.refine_count = 0;

    int64_t cap = cfg.strategy_max_cap > 0
        ? std::min<int64_t>(cfg.strategy_max_cap, engine().max_num_splats)
        : engine().max_num_splats;
    if (st.id == StrategyId::IgsPlus) {
        _build_budget_schedule(st, cur_num_splats, cap,
                               cfg.refine_start_iter, cfg.refine_stop_iter,
                               cfg.refine_every);
    }
    st.inited = true;
}

// ---- edge accumulation over the current batch render (IGS+/MRNF) ----
void _accumulate_edge_scores(const DensifyConfig& cfg) {
    StrategyState& st = S();
    auto& cam = engine().camera;
    auto& renders = engine().fwd.renders;
    auto rgb = std::get<0>(renders);
    auto& rTs = engine().fwd.render_Ts;
    int64_t cur = engine().cur_num_splats;
    if (cur <= 0) return;
    if (cam.model != CameraModelType::PINHOLE ||
        cam.distortion != CameraDistortionType::None)
        return;  // edge projection is pinhole-only; error-only scoring fallback
    if (rgb.data_ptr() == nullptr || rTs.data_ptr() == nullptr) return;
    int C = cam.num, W = cam.width, H = cam.height;
    if (C <= 0 || W <= 0 || H <= 0) return;

    // flat view over the [C,4] c2w viewmat table for the kernel
    TorchTensorView vm_tv((uint64_t)cam.viewmats.data_ptr(), 4,
                          {(int64_t)C * 4, 1LL});
    DeviceVector<float4> vm = DeviceVector<float4>(vm_tv);

    backend::memset_sync(st.edge_view_score.data_ptr(), 0,
                         (size_t)cur * sizeof(float));
    for (int c = 0; c < C; ++c) {
        strat_accumulate_edge_score_tensor(
            cur, c, C, W, H,
            vm, cam.intrins,
            engine().world.means,
            rgb, rTs, st.edge_view_score);
    }
    // Per-view median normalization before folding into the window sum
    // (LFS: normalize_by_positive_median_inplace then add to edge_score_sum).
    TorchTensorView tv((uint64_t)st.edge_view_score.data_ptr(), 4, {cur, 1LL});
    normalize_clip_map_inplace_tensor(tv, /*normalize_median=*/true,
                                      /*clip_quantile=*/1.0f, /*power=*/1.0f);
    strat_ew_add_inplace_tensor(cur, st.edge_score_sum, st.edge_view_score);
    st.edge_view_count++;
}

// ---- shared score accumulation for the current step (mirrors the stock
//      engine_densify_step's accum-weight path, minus the revised draw) ----
void _accumulate_error_scores(const DensifyConfig& cfg, int64_t cur) {
    auto& dv_accum_buf = engine().optim.accum_buffer;
    if (dv_accum_buf.data_ptr() == nullptr)
        return;
    if (engine().fwd.accum_mode == DensifyAccumMode::Avg &&
        engine().fwd.accum_weight.data_ptr() != nullptr) {
        densify_accum_finalize_tensor(cur, engine().fwd.accum_weight);
    }
    DeviceVector<float> score;
    bool weight_by_opacity = false;
    if (engine().fwd.accum_weight.data_ptr() != nullptr) {
        score = engine().fwd.accum_weight;
    } else {
        score = engine().grad.opacities.data_ptr()
            ? engine().grad.opacities : engine().world.opacities;
        weight_by_opacity = true;
    }
    auto& dv_oversize = engine().optim.densify_oversize;
    densify_update_weight(
        cur, engine().optim.radii,
        nullptr,
        weight_by_opacity ? (float*)engine().world.opacities.data_ptr() : nullptr,
        score, DeviceVector<float>(), 0.0f, cfg.score_power,
        dv_accum_buf, cfg.score_mode,
        cfg.max_screen_size, dv_oversize);
    if (cfg.final_score_power != 1.0f) {
        engine().optim.densify_sample_score.resize(
            PoolSlot::EngDensifySampleScore, engine().max_num_splats);
    } else {
        engine().optim.densify_sample_score = DeviceVector<float2>();
    }
    densify_clip_score_tensor(cur, dv_accum_buf,
                              cfg.score_clip_quantile,
                              cfg.final_score_power,
                              engine().optim.densify_sample_score);
    // plain [N] copy of the windowed error for the strategy scoring
    if (S().error_scores.data_ptr() != nullptr) {
        strat_extract_lane0_tensor(cur, dv_accum_buf, S().error_scores);
    }
}

// ---- common zero-out of the accumulation window at refine time ----
void _zero_densify_window() {
    if (engine().optim.accum_buffer.data_ptr() != nullptr) {
        backend::memset_sync(engine().optim.accum_buffer.data_ptr(), 0,
                             engine().optim.accum_buffer.size() * sizeof(float2));
    }
    if (engine().optim.densify_oversize.data_ptr() != nullptr) {
        backend::memset_sync(engine().optim.densify_oversize.data_ptr(), 0,
                             engine().optim.densify_oversize.size() * sizeof(float));
    }
    if (S().edge_score_sum.data_ptr() != nullptr) {
        backend::memset_sync(S().edge_score_sum.data_ptr(), 0,
                             S().edge_score_sum.size() * sizeof(float));
        S().edge_view_count = 0;
    }
}

// ---- shared splat-parameter bundle (same idiom as engine_densify_step) ----
struct SplatBundle {
    DeviceVector<float3> means, features_dc, features_sh;
    DeviceVector<float4> quats;
    DeviceVector<float3> scales;
    DeviceVector<float>  opacities;
    DeviceVector<float3> g1_means, g2_means, g1_scales, g2_scales;
    DeviceVector<float4> g1_quats, g2_quats;
    DeviceVector<float>  g1_opacs, g2_opacs;
    DeviceVector<float3> g1_features_dc, g2_features_dc;
    DeviceVector<float3> g1_features_sh, g2_features_sh;
    DeviceVector<int32_t> bias_steps;
    int num_sh = 0;
    int num_sh_buffer = 0;
    bool quantize_sh = false;
    int64_t sh_flat = 0;
};

SplatBundle _make_bundle() {
    SplatBundle b;
    b.means = engine().world.means;
    b.quats = engine().world.quats;
    b.scales = engine().world.scales;
    b.opacities = engine().world.opacities;
    b.features_dc = engine().world.features_dc;
    {
        auto& t = engine().world.features_sh;
        TorchTensorView tv((uint64_t)t.data_ptr(), 4,
            {t.size<0>() * t.size<1>(), 3LL});
        b.features_sh = DeviceVector<float3>(tv);
    }
    b.g1_means = engine().optim.g1_means;
    b.g1_quats = engine().optim.g1_quats;
    b.g1_scales = engine().optim.g1_scales;
    b.g1_opacs = engine().optim.g1_opacities;
    b.g1_features_dc = engine().optim.g1_features_dc;
    b.g2_means = engine().optim.g2_means;
    b.g2_quats = engine().optim.g2_quats;
    b.g2_scales = engine().optim.g2_scales;
    b.g2_opacs = engine().optim.g2_opacities;
    b.g2_features_dc = engine().optim.g2_features_dc;
    b.num_sh = engine().num_sh;
    b.num_sh_buffer = b.num_sh;
    b.quantize_sh = engine().optim.sh_quantize_enabled();
    b.sh_flat = (int64_t)engine().max_num_splats * (int64_t)b.num_sh;
    if (b.quantize_sh) {
        uint8_t* packed = engine().optim.use_fused_proj_bwd_optim
            ? engine().optim.sh_quant_state_fpbo.packed_ptr()
            : engine().optim.sh_quant_state.packed_ptr();
        TorchTensorView tv((uint64_t)packed, 1, {b.sh_flat, 12LL});
        b.g1_features_sh = DeviceVector<float3>(tv);
        b.g2_features_sh = DeviceVector<float3>(tv);
    } else {
        TorchTensorView tv1((uint64_t)engine().optim.g1_features_sh.data_ptr(),
                            4, {b.sh_flat, 3LL});
        TorchTensorView tv2((uint64_t)engine().optim.g2_features_sh.data_ptr(),
                            4, {b.sh_flat, 3LL});
        b.g1_features_sh = DeviceVector<float3>(tv1);
        b.g2_features_sh = DeviceVector<float3>(tv2);
    }
    b.bias_steps = engine().optim.bias_correction_steps;
    return b;
}

// Free a set of slot indices: opacity -> -30 logit (raster skips it; the
// prune mask re-derivation below still catches it) and zero optimizer state.
void _free_slots(const SplatBundle& b, DeviceVector<int32_t> indices,
                 int64_t n, int64_t stride_sh) {
    if (n <= 0 || indices.data_ptr() == nullptr) return;
    strat_scatter_set_rows_tensor(n, indices, 1, -30.0f,
                                  _row_view(b.opacities, 1));
    if (b.g1_means.data_ptr()) {
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g1_means, 3));
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g2_means, 3));
        strat_scatter_zero_rows_tensor(n, indices, 4, _row_view(b.g1_quats, 4));
        strat_scatter_zero_rows_tensor(n, indices, 4, _row_view(b.g2_quats, 4));
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g1_scales, 3));
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g2_scales, 3));
        strat_scatter_zero_rows_tensor(n, indices, 1, _row_view(b.g1_opacs, 1));
        strat_scatter_zero_rows_tensor(n, indices, 1, _row_view(b.g2_opacs, 1));
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g1_features_dc, 3));
        strat_scatter_zero_rows_tensor(n, indices, 3, _row_view(b.g2_features_dc, 3));
        if (!b.quantize_sh && b.g1_features_sh.data_ptr() && stride_sh > 0) {
            strat_scatter_zero_rows_tensor(n, indices, stride_sh,
                                           _row_view(b.g1_features_sh, stride_sh));
            strat_scatter_zero_rows_tensor(n, indices, stride_sh,
                                           _row_view(b.g2_features_sh, stride_sh));
        }
    }
    if (b.bias_steps.data_ptr()) {
        strat_scatter_zero_rows_tensor(n, indices, 1,
                                       _row_view(b.bias_steps, 1));
    }
}

// Split `n_children` parents (src) into slots (dst). Parents must be distinct
// (sampled without replacement). Returns n on success, -1 when quantized
// optimizer state forces the append-only fallback.
int64_t _las_split_into(const SplatBundle& b, DeviceVector<int32_t> src,
                        DeviceVector<int32_t> dst, int64_t n,
                        float split_opacity_k, int64_t cur_num_splats) {
    if (n <= 0) return 0;
    if (b.quantize_sh || engine().optim.non_sh_optim_bits != 32)
        return -1;  // quantized state: use the stock append kernel
    strat_las_split_into_slots_tensor(
        n, split_opacity_k, src, dst,
        b.means, b.quats, b.scales, b.opacities,
        b.features_dc, b.features_sh, b.num_sh,
        b.g1_means, b.g2_means,
        b.g1_quats, b.g2_quats,
        b.g1_scales, b.g2_scales,
        b.g1_opacs, b.g2_opacs,
        b.g1_features_dc, b.g2_features_dc,
        b.g1_features_sh, b.g2_features_sh,
        b.bias_steps);
    return n;
}

// Stock append-only long-axis-split add (quantized-safe path).
int64_t _append_las(const SplatBundle& b, int64_t cur, int64_t n_new,
                    DeviceVector<float2> weights, float split_opacity_k,
                    uint32_t seed) {
    if (n_new <= 0) return 0;
    DeviceVector<float4> dv_sh_quant_bounds;
    bool sh_bounds_per_splat = false;
    if (b.quantize_sh) {
        if (engine().optim.use_fused_proj_bwd_optim) {
            dv_sh_quant_bounds = engine().optim.sh_quant_state_fpbo.bounds;
            sh_bounds_per_splat = true;
        } else {
            dv_sh_quant_bounds = engine().optim.sh_quant_state.bounds;
            sh_bounds_per_splat = false;
        }
    }
    DeviceVector<uint8_t> dv_sh_value_packed;
    DeviceVector<float2> dv_sh_value_bounds;
    bool sh_value_bounds_per_splat = false;
    int sh_value_bits = engine().world.sh_value_bits;
    if (sh_value_bits == 8) {
        if (engine().world.features_sh_quant8_fpbo.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant8_fpbo.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant8_fpbo.bounds;
            sh_value_bounds_per_splat = true;
        } else if (engine().world.features_sh_quant8.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant8.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant8.bounds;
        }
    } else if (sh_value_bits == 16) {
        if (engine().world.features_sh_quant16_fpbo.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant16_fpbo.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant16_fpbo.bounds;
            sh_value_bounds_per_splat = true;
        } else if (engine().world.features_sh_quant16.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant16.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant16.bounds;
        }
    }
    NonShQuantState non_sh;
    if (engine().optim.non_sh_optim_bits == 16
        && engine().optim.means_quant_state_fpbo.initialized()) {
        non_sh.enabled            = true;
        non_sh.means_packed       = engine().optim.means_quant_state_fpbo.packed_ptr();
        non_sh.quats_packed       = engine().optim.quats_quant_state_fpbo.packed_ptr();
        non_sh.scales_packed      = engine().optim.scales_quant_state_fpbo.packed_ptr();
        non_sh.opacities_packed   = engine().optim.opacities_quant_state_fpbo.packed_ptr();
        non_sh.features_dc_packed = engine().optim.features_dc_quant_state_fpbo.packed_ptr();
        non_sh.means_bounds       = engine().optim.means_quant_state_fpbo.bounds_ptr();
        non_sh.quats_bounds       = engine().optim.quats_quant_state_fpbo.bounds_ptr();
        non_sh.scales_bounds      = engine().optim.scales_quant_state_fpbo.bounds_ptr();
        non_sh.opacities_bounds   = engine().optim.opacities_quant_state_fpbo.bounds_ptr();
        non_sh.features_dc_bounds = engine().optim.features_dc_quant_state_fpbo.bounds_ptr();
    }
    add_splats_with_long_axis_split_tensor(
        cur, n_new, split_opacity_k,
        b.means, b.quats, b.scales, b.opacities, b.features_dc, b.features_sh,
        b.g1_means, b.g1_quats, b.g1_scales, b.g1_opacs, b.g1_features_dc, b.g1_features_sh,
        b.g2_means, b.g2_quats, b.g2_scales, b.g2_opacs, b.g2_features_dc, b.g2_features_sh,
        engine().optim.accum_buffer, weights,
        b.bias_steps,
        b.quantize_sh ? engine().optim.sh_optim_bits : 32, b.num_sh,
        dv_sh_quant_bounds, sh_bounds_per_splat,
        dv_sh_value_packed, dv_sh_value_bounds,
        sh_value_bits, sh_value_bounds_per_splat, b.num_sh_buffer,
        non_sh,
        seed);
    return n_new;
}

// ======================= IGS+ =======================

int64_t _densify_igs_plus(int step, const DensifyConfig& cfg,
                          SplatBundle& b, int64_t cur, int64_t cap) {
    StrategyState& st = S();
    int64_t sh_stride = (int64_t)b.num_sh * 3;

    // ---- 1. budget from the Taming ramp ----
    int64_t budget = cap;
    if (!st.budget_schedule.empty()) {
        size_t si = (size_t)std::min<int64_t>(
            st.refine_step_idx, (int64_t)st.budget_schedule.size() - 1);
        budget = std::min<int64_t>(st.budget_schedule[si], cap);
    }
    int64_t budget_for_alloc = std::max<int64_t>(0, budget - cur);

    // ---- 2. opacity prune -> free slots (LFS opacity_prune) ----
    strat_prune_mask_tensor(cur, b.opacities, b.scales, b.quats,
                            cfg.igs_prune_opacity, -20.0f, st.mask_a.data_ptr());
    _zero_count(st.count_scratch);
    strat_extract_indices_tensor(cur, st.mask_a.data_ptr(),
                                 st.idx_scratch, st.count_scratch);
    int64_t n_pruned = _host_count(st.count_scratch);
    if (n_pruned > 0)
        _free_slots(b, st.idx_scratch, n_pruned, sh_stride);

    // ---- 3. reset opacity every `reset_every` iters (LFS reset_opacity) ----
    if (cfg.igs_reset_opacity_every > 0 &&
        step > cfg.refine_start_iter &&
        (step % cfg.igs_reset_opacity_every) == 0) {
        strat_opacity_reset_tensor(cur, b.opacities, _logit(0.1f), nullptr);
    }

    if (budget_for_alloc <= 0) {
        _zero_densify_window();
        st.refine_step_idx++;
        return 0;
    }

    // ---- 4. candidate mask: top ERROR_CANDIDATE_FACTOR*budget by error ----
    DeviceVector<float>& err = st.error_scores;
    DeviceVector<float>& edge = st.edge_score_sum;
    bool have_edge = (st.edge_view_count > 0) && edge.data_ptr() != nullptr;

    int64_t active = cur;
    int64_t candidate_budget = std::min<int64_t>(
        active, std::max<int64_t>(budget_for_alloc,
            budget_for_alloc * cfg.igs_error_candidate_factor));
    if (candidate_budget < active) {
        float q = 1.0f - (float)candidate_budget / (float)active;
        quantile_of_abs_of_finite_elements_tensor(err, q, false, st.sum_scratch);
        float thr = _host_sum(st.sum_scratch);
        strat_mask_ge_tensor(cur, err, thr, st.mask_a.data_ptr());
    } else {
        backend::memset_sync(st.mask_a.data_ptr(), 1, (size_t)cur * sizeof(bool));
    }

    // ---- 5. dual score: norm(err) * (norm(edge) * w + 1) ----
    // error norm in place on score_scratch
    backend::memcpy_sync(st.score_scratch.data_ptr(), err.data_ptr(),
                         (size_t)cur * sizeof(float),
                         backend::MemcpyKind::DeviceToDevice);
    {
        TorchTensorView tv((uint64_t)st.score_scratch.data_ptr(), 4, {cur, 1LL});
        normalize_clip_map_inplace_tensor(tv, true, 1.0f, 1.0f);
    }
    // edge norm in edge_view_score (scratch)
    if (have_edge) {
        backend::memcpy_sync(st.edge_view_score.data_ptr(), edge.data_ptr(),
                             (size_t)cur * sizeof(float),
                             backend::MemcpyKind::DeviceToDevice);
        TorchTensorView tv((uint64_t)st.edge_view_score.data_ptr(), 4, {cur, 1LL});
        normalize_clip_map_inplace_tensor(tv, true, 1.0f, 1.0f);
    } else {
        backend::memset_sync(st.edge_view_score.data_ptr(), 0,
                             (size_t)cur * sizeof(float));
    }
    strat_ew_mul_scalar_inplace_tensor(cur, st.edge_view_score,
                                       cfg.igs_edge_score_weight);
    strat_ew_add_scalar_inplace_tensor(cur, st.edge_view_score, 1.0f);
    strat_ew_mul_inplace_tensor(cur, st.score_scratch, st.edge_view_score);
    // zero non-candidates
    strat_mask_apply_inplace_tensor(cur, st.score_scratch, st.mask_a.data_ptr());

    // ---- 6. selectable fallbacks (LFS: edge fallback, then uniform) ----
    int64_t n_select = std::min<int64_t>(budget_for_alloc, active);
    _zero_count(st.count_scratch);
    strat_count_nonzero_tensor(cur, st.score_scratch, st.count_scratch);
    int64_t selectable = _host_count(st.count_scratch);
    if (selectable < n_select && have_edge) {
        backend::memcpy_sync(st.score_scratch.data_ptr(),
                             st.edge_view_score.data_ptr(),
                             (size_t)cur * sizeof(float),
                             backend::MemcpyKind::DeviceToDevice);
        strat_mask_apply_inplace_tensor(cur, st.score_scratch, st.mask_a.data_ptr());
        _zero_count(st.count_scratch);
        strat_count_nonzero_tensor(cur, st.score_scratch, st.count_scratch);
        selectable = _host_count(st.count_scratch);
    }
    if (selectable <= 0) {
        backend::memset_sync(st.score_scratch.data_ptr(), 0,
                             (size_t)cur * sizeof(float));
        strat_ew_add_scalar_inplace_tensor(cur, st.score_scratch, 1.0f);
        strat_mask_apply_inplace_tensor(cur, st.score_scratch, st.mask_a.data_ptr());
        _zero_count(st.count_scratch);
        strat_count_nonzero_tensor(cur, st.score_scratch, st.count_scratch);
        selectable = _host_count(st.count_scratch);
    }
    n_select = std::min<int64_t>(n_select, selectable);
    if (n_select <= 0) {
        _zero_densify_window();
        st.refine_step_idx++;
        return 0;
    }

    // ---- 7. sample parents WITHOUT replacement, then split ----
    strat_ew_clamp_min_inplace_tensor(cur, st.score_scratch, 1e-12f);
    _sample_scores(cur, st.idx_scratch, n_select,
                   (uint32_t)(0x9e3779b9u ^ (uint32_t)step),
                   st.mask_a.data_ptr());

    // free slots (re-derive: opac == -30 after _free_slots)
    strat_prune_mask_tensor(cur, b.opacities, b.scales, b.quats,
                            cfg.igs_prune_opacity, -20.0f, st.mask_b.data_ptr());
    _zero_count(st.count_scratch);
    strat_extract_indices_tensor(cur, st.mask_b.data_ptr(),
                                 st.idx_scratch2, st.count_scratch);
    int64_t n_free = _host_count(st.count_scratch);
    int64_t n_reuse = std::min<int64_t>(n_free, n_select);
    int64_t n_append = n_select - n_reuse;

    int64_t added = 0;
    if (n_reuse > 0) {
        // parents = idx_scratch[0..n_reuse); dst = idx_scratch2[0..n_reuse)
        int64_t r = _las_split_into(b, st.idx_scratch, st.idx_scratch2,
                                    n_reuse, cfg.las_split_opacity_k_final, cur);
        if (r < 0) {
            DeviceVector<float2> w = engine().optim.densify_sample_score.data_ptr()
                ? engine().optim.densify_sample_score : engine().optim.accum_buffer;
            added += _append_las(b, cur, n_select, w,
                                 cfg.las_split_opacity_k_final,
                                 (uint32_t)(0x9e3779b9u ^ (uint32_t)step));
        } else {
            added += n_reuse;
        }
    }
    if (n_append > 0) {
        // parents = idx_scratch[n_reuse .. n_select)
        DeviceVector<int32_t> parents = st.idx_scratch;
        // dst = cur + added + i (only valid when no quantized fallback above
        // consumed slots; when r<0 we appended all n_select, so cur+added is
        // the new tail)
        std::vector<int32_t> dst_host((size_t)n_append);
        for (int64_t i = 0; i < n_append; ++i)
            dst_host[(size_t)i] = (int32_t)(cur + added + i);
        backend::memcpy_sync(st.idx_scratch2.data_ptr(), dst_host.data(),
                             (size_t)n_append * sizeof(int32_t),
                             backend::MemcpyKind::HostToDevice);
        int64_t r = _las_split_into(b, parents, st.idx_scratch2, n_append,
                                    cfg.las_split_opacity_k_final, cur);
        if (r < 0) {
            DeviceVector<float2> w = engine().optim.densify_sample_score.data_ptr()
                ? engine().optim.densify_sample_score : engine().optim.accum_buffer;
            added += _append_las(b, cur + added, n_append, w,
                                 cfg.las_split_opacity_k_final,
                                 (uint32_t)(0x9e3779b9u ^ (uint32_t)step));
        } else {
            added += n_append;
        }
    }
    _zero_densify_window();
    st.refine_step_idx++;
    return added;
}

// ======================= MRNF =======================

int64_t _densify_mrnf(int step, const DensifyConfig& cfg,
                      SplatBundle& b, int64_t cur, int64_t cap) {
    StrategyState& st = S();
    int64_t sh_stride = (int64_t)b.num_sh * 3;

    // ---- camera hull (far field) ----
    _update_camera_hull(st);
    bool far_ok = st.camera_hull_valid;

    // ---- prune: opacity / collapsed scale / degenerate rotation ----
    strat_prune_mask_tensor(cur, b.opacities, b.scales, b.quats,
                            cfg.mrnf_min_opacity, -20.0f, st.mask_a.data_ptr());
    _zero_count(st.count_scratch);
    strat_extract_indices_tensor(cur, st.mask_a.data_ptr(),
                                 st.idx_scratch, st.count_scratch);
    int64_t n_pruned = _host_count(st.count_scratch);
    if (n_pruned > 0)
        _free_slots(b, st.idx_scratch, n_pruned, sh_stride);

    // ---- far-field mask + starvation ----
    int64_t n_far = 0;
    if (far_ok) {
        float r2 = 2.0f * st.orbit_radius;   // kFarMaskOrbits = 2.0
        r2 *= r2;
        strat_far_mask_tensor(cur, b.means,
                              st.cam_centroid[0], st.cam_centroid[1],
                              st.cam_centroid[2], r2, st.mask_b.data_ptr());
        _zero_count(st.count_scratch);
        strat_mask_count_tensor(cur, st.mask_b.data_ptr(), st.count_scratch);
        n_far = _host_count(st.count_scratch);
        st.far_starvation = _far_starvation(st, n_far, std::max<int64_t>(1, cur),
                                            cfg.mrnf_far_growth_cap);
    } else {
        st.far_starvation = 1.0f;
    }

    // ---- error + edge-guidance score (MRNF edge_guidance_factor) ----
    DeviceVector<float>& err = st.error_scores;
    bool have_edge = (st.edge_view_count > 0) && st.edge_score_sum.data_ptr() != nullptr;
    if (have_edge) {
        strat_dual_score_tensor(cur, err, st.edge_score_sum,
                                cfg.igs_edge_score_weight, st.score_scratch);
    } else {
        backend::memcpy_sync(st.score_scratch.data_ptr(), err.data_ptr(),
                             (size_t)cur * sizeof(float),
                             backend::MemcpyKind::DeviceToDevice);
    }
    strat_ew_clamp_min_inplace_tensor(cur, st.score_scratch, 1e-12f);
    _zero_count(st.count_scratch);
    strat_count_nonzero_tensor(cur, st.score_scratch, st.count_scratch);
    int64_t selectable = _host_count(st.count_scratch);

    // ---- growth target (paced until fill_target_iter) ----
    int64_t n_grow = (int64_t)std::lround((float)cur * cfg.mrnf_grow_fraction);
    if (cfg.mrnf_fill_target_iter > 0 && step < cfg.mrnf_fill_target_iter) {
        float t = std::max(0.0f, std::min(1.0f,
            (float)step / (float)cfg.mrnf_fill_target_iter));
        n_grow = (int64_t)std::lround((float)n_grow * t);
    }
    n_grow = std::min<int64_t>(n_grow, std::max<int64_t>(0, cap - cur));
    n_grow = std::min<int64_t>(n_grow, selectable);

    // ---- replace pruned first (LFS replace_pruned) ----
    int64_t added = 0;
    int64_t n_replace = std::min<int64_t>(n_pruned, n_grow);
    if (n_replace > 0) {
        _sample_scores(cur, st.idx_scratch, n_replace,
                       (uint32_t)(0x85ebca6bu ^ (uint32_t)step), nullptr);
        // free slots (opac == -30)
        strat_prune_mask_tensor(cur, b.opacities, b.scales, b.quats,
                                cfg.mrnf_min_opacity, -20.0f, st.mask_b.data_ptr());
        _zero_count(st.count_scratch);
        strat_extract_indices_tensor(cur, st.mask_b.data_ptr(),
                                     st.idx_scratch2, st.count_scratch);
        int64_t n_free = _host_count(st.count_scratch);
        n_replace = std::min<int64_t>(n_replace, n_free);
        if (n_replace > 0) {
            int64_t r = _las_split_into(b, st.idx_scratch, st.idx_scratch2,
                                        n_replace, cfg.las_split_opacity_k_final, cur);
            if (r < 0) {
                DeviceVector<float2> w = engine().optim.densify_sample_score.data_ptr()
                    ? engine().optim.densify_sample_score : engine().optim.accum_buffer;
                added += _append_las(b, cur, n_replace, w,
                                     cfg.las_split_opacity_k_final,
                                     (uint32_t)(0x85ebca6bu ^ (uint32_t)step));
            } else {
                added += n_replace;
            }
        }
    }

    // ---- grow (append) ----
    int64_t n_append_grow = n_grow - n_replace;
    if (n_append_grow > 0) {
        _sample_scores(cur, st.idx_scratch, n_append_grow,
                       (uint32_t)(0xc2b2ae35u ^ (uint32_t)step), nullptr);
        std::vector<int32_t> dst_host((size_t)n_append_grow);
        for (int64_t i = 0; i < n_append_grow; ++i)
            dst_host[(size_t)i] = (int32_t)(cur + added + i);
        backend::memcpy_sync(st.idx_scratch2.data_ptr(), dst_host.data(),
                             (size_t)n_append_grow * sizeof(int32_t),
                             backend::MemcpyKind::HostToDevice);
        int64_t r = _las_split_into(b, st.idx_scratch, st.idx_scratch2,
                                    n_append_grow, cfg.las_split_opacity_k_final, cur);
        if (r < 0) {
            DeviceVector<float2> w = engine().optim.densify_sample_score.data_ptr()
                ? engine().optim.densify_sample_score : engine().optim.accum_buffer;
            added += _append_las(b, cur + added, n_append_grow, w,
                                 cfg.las_split_opacity_k_final,
                                 (uint32_t)(0xc2b2ae35u ^ (uint32_t)step));
        } else {
            added += n_append_grow;
        }
    }

    // ---- far-field seeds (LFS far_seed_dose, scaled by starvation) ----
    int64_t n_far_grow = 0;
    if (far_ok && n_far > 0 && cfg.mrnf_far_seed_dose > 0) {
        n_far_grow = (int64_t)std::lround(
            (float)cfg.mrnf_far_seed_dose * st.far_starvation);
        n_far_grow = std::min<int64_t>(n_far_grow, n_grow);
    }
    if (far_ok && n_far_grow > 0 && (cur + added) < cap) {
        int64_t n_far_draw = std::min<int64_t>(n_far_grow, cap - (cur + added));
        n_far_draw = std::min<int64_t>(n_far_draw, n_far);
        if (n_far_draw > 0) {
            strat_mask_apply_inplace_tensor(cur, st.score_scratch,
                                            st.mask_b.data_ptr());
            _sample_scores(cur, st.idx_scratch, n_far_draw,
                           (uint32_t)(0x165667b1u ^ (uint32_t)step), nullptr);
            std::vector<int32_t> dst_host((size_t)n_far_draw);
            for (int64_t i = 0; i < n_far_draw; ++i)
                dst_host[(size_t)i] = (int32_t)(cur + added + i);
            backend::memcpy_sync(st.idx_scratch2.data_ptr(), dst_host.data(),
                                 (size_t)n_far_draw * sizeof(int32_t),
                                 backend::MemcpyKind::HostToDevice);
            int64_t r = _las_split_into(b, st.idx_scratch, st.idx_scratch2,
                                        n_far_draw, cfg.las_split_opacity_k_final, cur);
            if (r < 0) {
                DeviceVector<float2> w = engine().optim.densify_sample_score.data_ptr()
                    ? engine().optim.densify_sample_score : engine().optim.accum_buffer;
                added += _append_las(b, cur + added, n_far_draw, w,
                                     cfg.las_split_opacity_k_final,
                                     (uint32_t)(0x165667b1u ^ (uint32_t)step));
            } else {
                added += n_far_draw;
            }
        }
    }

    // ---- far decay (LFS apply_decay, applied globally per refine window;
    //      far splats additionally decay by mrnf_far_decay_scale) ----
    {
        float decay = 0.99f;  // baseline per-window decay
        if (cfg.mrnf_far_decay_scale > 0.0f)
            decay = 1.0f - 0.02f * cfg.mrnf_far_decay_scale;
        strat_ew_mul_scalar_inplace_tensor(cur, b.opacities, decay);
    }

    // ---- max-cap enforcement: prune lowest-score OLD splats ----
    int64_t new_cur = cur + added;
    if (new_cur > cap) {
        int64_t keep_old = std::max<int64_t>(0, cap - added);
        if (keep_old < cur) {
            float q = (float)keep_old / (float)cur;
            quantile_of_abs_of_finite_elements_tensor(
                st.score_scratch, q, false, st.sum_scratch);
            float thr = _host_sum(st.sum_scratch);
            // keep = score >= thr
            strat_mask_ge_tensor(cur, st.score_scratch, thr, st.mask_b.data_ptr());
            // zero opacity where !keep (do not touch new splats)
            strat_mask_not_inplace_tensor(cur, st.mask_b.data_ptr());
            strat_mask_apply_inplace_tensor(cur, st.score_scratch,
                                            st.mask_b.data_ptr());  // scratch reuse ok
            DeviceVector<float> opac_view =
                _float_view((float*)b.opacities.data_ptr(), cur);
            strat_mask_not_inplace_tensor(cur, st.mask_b.data_ptr());
            strat_mask_apply_inplace_tensor(cur, opac_view, st.mask_b.data_ptr());
        }
    }

    _zero_densify_window();
    st.refine_count++;
    return added;
}

// ======================= MCMC =======================

// LFS-MCMC on Spirula's stock MCMC kernels: windowed error accumulation
// (done in _accumulate_error_scores) + LFS noise cadence. The relocate/add
// kernels implement the 3DGS-MCMC sampling LFS's mcmc.cpp follows; the
// strategy switch additionally treats degenerate-quaternion splats as dead
// via the prune path of the relocate kernel (min_opacity).
int64_t _densify_mcmc(int step, const DensifyConfig& cfg,
                      SplatBundle& b, int64_t cur, int64_t cap) {
    DeviceVector<float4> dv_sh_quant_bounds;
    bool sh_bounds_per_splat = false;
    if (b.quantize_sh) {
        if (engine().optim.use_fused_proj_bwd_optim) {
            dv_sh_quant_bounds = engine().optim.sh_quant_state_fpbo.bounds;
            sh_bounds_per_splat = true;
        } else {
            dv_sh_quant_bounds = engine().optim.sh_quant_state.bounds;
            sh_bounds_per_splat = false;
        }
    }
    DeviceVector<uint8_t> dv_sh_value_packed;
    DeviceVector<float2> dv_sh_value_bounds;
    bool sh_value_bounds_per_splat = false;
    int sh_value_bits = engine().world.sh_value_bits;
    if (sh_value_bits == 8) {
        if (engine().world.features_sh_quant8_fpbo.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant8_fpbo.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant8_fpbo.bounds;
            sh_value_bounds_per_splat = true;
        } else if (engine().world.features_sh_quant8.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant8.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant8.bounds;
        }
    } else if (sh_value_bits == 16) {
        if (engine().world.features_sh_quant16_fpbo.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant16_fpbo.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant16_fpbo.bounds;
            sh_value_bounds_per_splat = true;
        } else if (engine().world.features_sh_quant16.initialized()) {
            dv_sh_value_packed = engine().world.features_sh_quant16.packed;
            dv_sh_value_bounds = engine().world.features_sh_quant16.bounds;
        }
    }
    NonShQuantState non_sh;
    if (engine().optim.non_sh_optim_bits == 16
        && engine().optim.means_quant_state_fpbo.initialized()) {
        non_sh.enabled            = true;
        non_sh.means_packed       = engine().optim.means_quant_state_fpbo.packed_ptr();
        non_sh.quats_packed       = engine().optim.quats_quant_state_fpbo.packed_ptr();
        non_sh.scales_packed      = engine().optim.scales_quant_state_fpbo.packed_ptr();
        non_sh.opacities_packed   = engine().optim.opacities_quant_state_fpbo.packed_ptr();
        non_sh.features_dc_packed = engine().optim.features_dc_quant_state_fpbo.packed_ptr();
        non_sh.means_bounds       = engine().optim.means_quant_state_fpbo.bounds_ptr();
        non_sh.quats_bounds       = engine().optim.quats_quant_state_fpbo.bounds_ptr();
        non_sh.scales_bounds      = engine().optim.scales_quant_state_fpbo.bounds_ptr();
        non_sh.opacities_bounds   = engine().optim.opacities_quant_state_fpbo.bounds_ptr();
        non_sh.features_dc_bounds = engine().optim.features_dc_quant_state_fpbo.bounds_ptr();
    }
    uint32_t sh_optim_bits = b.quantize_sh ? engine().optim.sh_optim_bits : 32;

    relocate_splats_mcmc_tensor(
        cur, cfg.min_opacity,
        b.means, b.quats, b.scales, b.opacities, b.features_dc, b.features_sh,
        b.g1_means, b.g1_quats, b.g1_scales, b.g1_opacs, b.g1_features_dc, b.g1_features_sh,
        b.g2_means, b.g2_quats, b.g2_scales, b.g2_opacs, b.g2_features_dc, b.g2_features_sh,
        b.bias_steps,
        (int)sh_optim_bits, b.num_sh,
        dv_sh_quant_bounds, sh_bounds_per_splat,
        dv_sh_value_packed, dv_sh_value_bounds,
        sh_value_bits, sh_value_bounds_per_splat, b.num_sh_buffer,
        non_sh,
        (uint32_t)(0x2545f491u ^ (uint32_t)step));

    int64_t n_target = std::min(cap, (int64_t)(cfg.growth_factor * cur));
    int64_t num_added = std::max<int64_t>(0, n_target - cur);
    if (num_added > 0) {
        add_splats_mcmc_tensor(
            cur, num_added, cfg.min_opacity,
            b.means, b.quats, b.scales, b.opacities, b.features_dc, b.features_sh,
            b.g1_means, b.g1_quats, b.g1_scales, b.g1_opacs, b.g1_features_dc, b.g1_features_sh,
            b.g2_means, b.g2_quats, b.g2_scales, b.g2_opacs, b.g2_features_dc, b.g2_features_sh,
            b.bias_steps,
            (int)sh_optim_bits, b.num_sh,
            dv_sh_quant_bounds, sh_bounds_per_splat,
            dv_sh_value_packed, dv_sh_value_bounds,
            sh_value_bits, sh_value_bounds_per_splat, b.num_sh_buffer,
            non_sh,
            (uint32_t)(0x2545f491u ^ (uint32_t)step));
    }

    // LFS noise cadence (progress-scaled like the stock path)
    float progress = ((float)step + 0.5f) / (float)std::max(1, step + 1);
    if (cfg.noise_lr > 0.0f && cfg.noise_lr_final > 0.0f) {
        float noise_scalar = cfg.noise_lr
            * powf(cfg.noise_lr_final / cfg.noise_lr, progress);
        mcmc_add_noise_tensor(cur + num_added, noise_scalar,
                              b.means, b.scales, b.quats, b.opacities);
    }

    _zero_densify_window();
    S().refine_count++;
    return num_added;
}

}  // namespace

// ======================= public API =======================

StrategyId engine_strategy_id_from_string(const std::string& s) {
    if (s == "igs+") return StrategyId::IgsPlus;
    if (s == "mrnf") return StrategyId::Mrnf;
    if (s == "mcmc") return StrategyId::Mcmc;
    return StrategyId::Revised;
}

void engine_strategy_reset() {
    StrategyState& st = S();
    st.id = StrategyId::Revised;
    st.active = false;
    st.inited = false;
    st.mask_a = DeviceVector<bool>();
    st.mask_b = DeviceVector<bool>();
    st.score_scratch = DeviceVector<float>();
    st.score_pair = DeviceVector<float2>();
    st.error_scores = DeviceVector<float>();
    st.edge_score_sum = DeviceVector<float>();
    st.edge_view_score = DeviceVector<float>();
    st.idx_scratch = DeviceVector<int32_t>();
    st.idx_scratch2 = DeviceVector<int32_t>();
    st.count_scratch = DeviceVector<int64_t>();
    st.sum_scratch = DeviceVector<float>();
    st.budget_schedule.clear();
    st.initial_splats = 0;
    st.refine_step_idx = 0;
    st.max_cap_reached = false;
    st.camera_hull_valid = false;
    st.far_starvation = 1.0f;
    st.edge_view_count = 0;
    st.refine_count = 0;
}

int engine_strategy_densify(int step, int max_steps, const DensifyConfig& cfg) {
    StrategyState& st = S();
    st.id = cfg.strategy;
    st.active = (cfg.strategy != StrategyId::Revised);

    int64_t cur = engine().cur_num_splats;
    int64_t max_n = engine().max_num_splats;
    int64_t cap = cfg.strategy_max_cap > 0
        ? std::min<int64_t>(cfg.strategy_max_cap, max_n) : max_n;
    if (cap <= 0) cap = std::max<int64_t>(1024, cur);

    _ensure_strategy_state(cfg, cur);
    if (st.id == StrategyId::IgsPlus && st.budget_schedule.empty())
        _build_budget_schedule(st, st.initial_splats, cap,
                               cfg.refine_start_iter, cfg.refine_stop_iter,
                               cfg.refine_every);

    bool densify_ongoing =
        (step < std::max(cfg.refine_stop_iter, max_steps - cfg.refine_stop_num_iter));
    bool do_densify = densify_ongoing
        && (step > cfg.refine_start_iter && step % cfg.refine_every == 0);

    // accumulate error channel every step (windowed); edge too for IGS+/MRNF
    _accumulate_error_scores(cfg, cur);
    if (st.id == StrategyId::IgsPlus || st.id == StrategyId::Mrnf)
        _accumulate_edge_scores(cfg);

    if (!do_densify)
        return 0;

    SplatBundle b = _make_bundle();
    int added = 0;
    switch (st.id) {
        case StrategyId::IgsPlus:
            added = (int)_densify_igs_plus(step, cfg, b, cur, cap);
            break;
        case StrategyId::Mrnf:
            added = (int)_densify_mrnf(step, cfg, b, cur, cap);
            break;
        case StrategyId::Mcmc:
            added = (int)_densify_mcmc(step, cfg, b, cur, cap);
            break;
        default:
            break;
    }
    engine().cur_num_splats = cur + added;
    return added;
}
