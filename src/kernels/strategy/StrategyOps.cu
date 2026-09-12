// StrategyOps.cu -- LFS-style densification strategy kernels for Spirula.
//
// Ported from LichtFeld Studio's IGS+ / MRNF / MCMC strategy logic
// (upstream sources improved_gs_plus.cpp / mcmc.cpp / mrnf.cpp, GPL-3.0),
// adapted to Spirula's DeviceVector / DeviceTensor data flow and pool-backed
// buffers. The host orchestration lives in src/engine/EngineStrategy.cpp;
// this file provides only the leaf kernels.
//
// SPDX-FileCopyrightText: 2025 LichtFeld Studio Authors (ported logic)
// SPDX-FileCopyrightText: 2026 Spirula strategy-port Authors
// SPDX-License-Identifier: GPL-3.0-or-later

#include "kernels/densify/DensifyCommon.cuh"

// ================
// Pack a plain [N] score vector into lane 0 of a [N,2] float2 buffer
// (lane 1 zeroed). The Spirula weighted sampler reads weights with a fixed
// stride of 2, so strategy scores must live in float2 layout.
// ================

__global__ void strat_pack_lane0_kernel(
    int64_t n, const float* __restrict__ src, float2* __restrict__ dst)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    dst[i] = make_float2(src[i], 0.0f);
}

/*[AutoHeaderGeneratorExport]*/
void strat_pack_lane0_tensor(
    int64_t numel, DeviceVector<float> src, DeviceVector<float2> dst)
{
    if (numel == 0) return;
    strat_pack_lane0_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, src.data_ptr(), dst.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Extract lane 0 of an [N,2] float2 buffer into a contiguous [N] float
// buffer (the densify accumulators are [N,2] interleaved; strategy scoring
// wants a plain [N] error vector).
// ================

__global__ void strat_extract_lane0_kernel(
    int64_t n, const float2* __restrict__ src, float* __restrict__ dst)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    dst[i] = src[i].x;
}

/*[AutoHeaderGeneratorExport]*/
void strat_extract_lane0_tensor(
    int64_t numel, DeviceVector<float2> src, DeviceVector<float> dst)
{
    if (numel == 0) return;
    strat_extract_lane0_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, src.data_ptr(), dst.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Prune mask: opacity below threshold, collapsed scale, or degenerate quat.
// Mirrors LFS MRNF::refine prune_mask / MCMC dead-mask logic.
// ================

__global__ void strat_prune_mask_kernel(
    int64_t num_splats,
    const float* __restrict__ opacities,   // logit
    const float3* __restrict__ log_scales, // [N,3]
    const float4* __restrict__ quats,      // [N,4]
    float logit_min_opacity,
    float log_min_scale,
    bool* __restrict__ out_mask)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= num_splats)
        return;
    float opac = opacities[i];
    float3 ls = log_scales[i];
    float4 q  = quats[i];
    float scale_max = fmaxf(fmaxf(ls.x, ls.y), ls.z);
    float qn2 = q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w;
    bool dead = (opac < logit_min_opacity) ||
                (scale_max < log_min_scale) ||
                (qn2 < 1e-6f);   // rotation magnitude near zero
    out_mask[i] = dead;
}

/*[AutoHeaderGeneratorExport]*/
void strat_prune_mask_tensor(
    int64_t num_splats,
    DeviceVector<float> opacities,
    DeviceVector<float3> log_scales,
    DeviceVector<float4> quats,
    float min_opacity,
    float log_min_scale,
    bool* out_mask)
{
    if (num_splats == 0)
        return;
    const float x = fminf(fmaxf(min_opacity, 1e-7f), 1.0f - 1e-7f);
    const float logit_min_opacity = logf(x / (1.0f - x));  // host-side logit
    strat_prune_mask_kernel<<<_LAUNCH_ARGS_1D(num_splats, 256)>>>(
        num_splats, opacities.data_ptr(), log_scales.data_ptr(), quats.data_ptr(),
        logit_min_opacity, log_min_scale, out_mask);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// IGS+ dual score: out = max(err,eps) * (max(edge,0) * edge_weight + 1)
// (LFS improved_gs_plus.cpp: sampling_scores = normalized_error *
//  (normalized_edge * EDGE_SCORE_WEIGHT + 1.0f))
// ================

__global__ void strat_dual_score_kernel(
    int64_t num_splats,
    const float* __restrict__ error_scores,
    const float* __restrict__ edge_scores,
    float edge_weight,
    float* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= num_splats)
        return;
    float err = fmaxf(error_scores[i], 1e-12f);
    float edge = fmaxf(edge_scores[i], 0.0f);
    out[i] = err * (edge * edge_weight + 1.0f);
}

/*[AutoHeaderGeneratorExport]*/
void strat_dual_score_tensor(
    int64_t num_splats,
    DeviceVector<float> error_scores,
    DeviceVector<float> edge_scores,
    float edge_weight,
    DeviceVector<float> out)
{
    if (num_splats == 0)
        return;
    strat_dual_score_kernel<<<_LAUNCH_ARGS_1D(num_splats, 256)>>>(
        num_splats, error_scores.data_ptr(), edge_scores.data_ptr(),
        edge_weight, out.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Elementwise in-place helpers (host-side weight algebra).
// ================

__global__ void strat_ew_mul_kernel(
    int64_t n, const float* __restrict__ b, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] *= b[i];
}

/*[AutoHeaderGeneratorExport]*/
void strat_ew_mul_inplace_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> b)
{
    if (numel == 0) return;
    strat_ew_mul_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, b.data_ptr(), a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_ew_add_kernel(
    int64_t n, const float* __restrict__ b, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] += b[i];
}

/*[AutoHeaderGeneratorExport]*/
void strat_ew_add_inplace_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> b)
{
    if (numel == 0) return;
    strat_ew_add_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, b.data_ptr(), a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_ew_mul_scalar_kernel(
    int64_t n, float s, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] *= s;
}

/*[AutoHeaderGeneratorExport]*/
void strat_ew_mul_scalar_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float s)
{
    if (numel == 0) return;
    strat_ew_mul_scalar_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, s, a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_ew_add_scalar_kernel(
    int64_t n, float s, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] += s;
}

/*[AutoHeaderGeneratorExport]*/
void strat_ew_add_scalar_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float s)
{
    if (numel == 0) return;
    strat_ew_add_scalar_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, s, a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_ew_clamp_min_kernel(
    int64_t n, float lo, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] = fmaxf(a[i], lo);
}

/*[AutoHeaderGeneratorExport]*/
void strat_ew_clamp_min_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float lo)
{
    if (numel == 0) return;
    strat_ew_clamp_min_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, lo, a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Mask ops.
// ================

__global__ void strat_mask_apply_kernel(
    int64_t n, const bool* __restrict__ keep, float* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    if (!keep[i]) a[i] = 0.0f;
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_apply_inplace_tensor(
    int64_t numel, DeviceVector<float> a, bool* keep)
{
    if (numel == 0) return;
    strat_mask_apply_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, keep, a.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_mask_ge_kernel(
    int64_t n, const float* __restrict__ a, float thr, bool* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    out[i] = a[i] >= thr;
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_ge_tensor(
    int64_t numel, DeviceVector<float> a, float thr, bool* out)
{
    if (numel == 0) return;
    strat_mask_ge_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, a.data_ptr(), thr, out);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_mask_or_kernel(
    int64_t n, const bool* __restrict__ b, bool* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] = a[i] || b[i];
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_or_inplace_tensor(
    int64_t numel, bool* a, bool* b)
{
    if (numel == 0) return;
    strat_mask_or_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, b, a);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_mask_and_kernel(
    int64_t n, const bool* __restrict__ b, bool* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] = a[i] && b[i];
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_and_inplace_tensor(
    int64_t numel, bool* a, bool* b)
{
    if (numel == 0) return;
    strat_mask_and_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, b, a);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_mask_not_kernel(int64_t n, bool* __restrict__ a)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    a[i] = !a[i];
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_not_inplace_tensor(int64_t numel, bool* a)
{
    if (numel == 0) return;
    strat_mask_not_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(numel, a);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Reductions (single scalar out).
// ================

__global__ void strat_count_nonzero_kernel(
    int64_t n, const float* __restrict__ a, int64_t* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    if (a[i] != 0.0f)
        atomicAdd(out, 1LL);
}

/*[AutoHeaderGeneratorExport]*/
void strat_count_nonzero_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<int64_t> out_scalar)
{
    if (numel == 0) return;
    strat_count_nonzero_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, a.data_ptr(), out_scalar.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_sum_kernel(
    int64_t n, const float* __restrict__ a, float* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    atomicAdd(out, a[i]);
}

/*[AutoHeaderGeneratorExport]*/
void strat_sum_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> out_scalar)
{
    if (numel == 0) return;
    strat_sum_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, a.data_ptr(), out_scalar.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_mask_count_kernel(
    int64_t n, const bool* __restrict__ mask, int64_t* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    if (mask[i])
        atomicAdd(out, 1LL);
}

/*[AutoHeaderGeneratorExport]*/
void strat_mask_count_tensor(
    int64_t numel, bool* mask, DeviceVector<int64_t> out_scalar)
{
    if (numel == 0) return;
    strat_mask_count_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, mask, out_scalar.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Compact a boolean mask into a dense int32 index list.
// ================

__global__ void strat_extract_indices_kernel(
    int64_t n, const bool* __restrict__ mask,
    int32_t* __restrict__ out_idx, int64_t* __restrict__ out_count)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    if (mask[i]) {
        int64_t pos = atomicAdd(out_count, 1LL);
        out_idx[pos] = (int32_t)i;
    }
}

/*[AutoHeaderGeneratorExport]*/
void strat_extract_indices_tensor(
    int64_t numel, bool* mask,
    DeviceVector<int32_t> out_indices, DeviceVector<int64_t> out_count)
{
    if (numel == 0) return;
    strat_extract_indices_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, mask, out_indices.data_ptr(), out_count.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Zero `stride` consecutive floats at each given row (optimizer-state reset
// for slots being reused by densification).
// ================

__global__ void strat_scatter_set_rows_kernel(
    int64_t n_idx, const int32_t* __restrict__ indices,
    int64_t stride, float value, float* __restrict__ dst)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n_idx) return;
    int64_t row = (int64_t)indices[i];
    float* base = dst + row * stride;
    for (int64_t k = 0; k < stride; ++k)
        base[k] = value;
}

/*[AutoHeaderGeneratorExport]*/
void strat_scatter_set_rows_tensor(
    int64_t n_idx, DeviceVector<int32_t> indices,
    int64_t stride, float value, DeviceVector<float> dst)
{
    if (n_idx == 0) return;
    strat_scatter_set_rows_kernel<<<_LAUNCH_ARGS_1D(n_idx, 256)>>>(
        n_idx, indices.data_ptr(), stride, value, dst.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

__global__ void strat_scatter_zero_rows_kernel(
    int64_t n_idx, const int32_t* __restrict__ indices,
    int64_t stride, float* __restrict__ dst)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n_idx) return;
    int64_t row = (int64_t)indices[i];
    float* base = dst + row * stride;
    for (int64_t k = 0; k < stride; ++k)
        base[k] = 0.0f;
}

/*[AutoHeaderGeneratorExport]*/
void strat_scatter_zero_rows_tensor(
    int64_t n_idx, DeviceVector<int32_t> indices,
    int64_t stride, DeviceVector<float> dst)
{
    if (n_idx == 0) return;
    strat_scatter_zero_rows_kernel<<<_LAUNCH_ARGS_1D(n_idx, 256)>>>(
        n_idx, indices.data_ptr(), stride, dst.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Opacity reset (IGS+): clamp logit opacity to logit(0.1) and report which
// rows were clamped (their optimizer state is zeroed by the caller).
// Mirrors LFS ImprovedGSPlus::reset_opacity.
// ================

__global__ void strat_opacity_reset_kernel(
    int64_t n, float logit_reset,
    float* __restrict__ opacs, bool* __restrict__ clamped_out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    bool above = opacs[i] > logit_reset;
    if (above) opacs[i] = logit_reset;
    if (clamped_out) clamped_out[i] = above;
}

/*[AutoHeaderGeneratorExport]*/
void strat_opacity_reset_tensor(
    int64_t numel, DeviceVector<float> opacities,
    float logit_reset, bool* clamped_out)
{
    if (numel == 0) return;
    strat_opacity_reset_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, logit_reset, opacities.data_ptr(), clamped_out);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Far-field mask (MRNF): splat farther than `radius_sq` from the camera
// centroid is in the far field. Mirrors LFS mrnf_strategy::launch_far_field_mask
// with kFarMaskOrbits * orbit_radius baked into radius_sq by the caller.
// ================

__global__ void strat_far_mask_kernel(
    int64_t n,
    const float3* __restrict__ means,
    float cx, float cy, float cz, float radius_sq,
    bool* __restrict__ out)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    float dx = means[i].x - cx;
    float dy = means[i].y - cy;
    float dz = means[i].z - cz;
    out[i] = (dx*dx + dy*dy + dz*dz) > radius_sq;
}

/*[AutoHeaderGeneratorExport]*/
void strat_far_mask_tensor(
    int64_t numel, DeviceVector<float3> means,
    float cx, float cy, float cz, float radius_sq, bool* out)
{
    if (numel == 0) return;
    strat_far_mask_kernel<<<_LAUNCH_ARGS_1D(numel, 256)>>>(
        numel, means.data_ptr(), cx, cy, cz, radius_sq, out);
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Long-axis split into explicit src/dst slots (LFS IGS+/MRNF grow-and-split:
// parents sampled WITHOUT replacement, one child written into a free slot or
// the append range; the parent is split in place). Mirrors LFS
// kernels::launch_long_axis_split_gaussians_inplace and Spirula's
// relocate_with_long_axis_split_kernel, but with caller-controlled dst rows.
//
// fp32 Adam-state only: when SH-optim quantization is enabled the engine
// falls back to the append-only path (add_splats_with_long_axis_split_tensor)
// so quantized packed bytes stay consistent.
// ================

__global__ void strat_las_split_into_slots_kernel(
    int64_t num_children,
    float split_opacity_k,
    const int32_t* __restrict__ src_indices,
    const int32_t* __restrict__ dst_indices,
    float3* __restrict__ means,
    float4* __restrict__ quats,
    float3* __restrict__ scales,
    float* __restrict__ opacs,
    float3* __restrict__ features_dc,
    float3* __restrict__ features_sh,
    int num_sh,
    float3* __restrict__ g1_means, float3* __restrict__ g2_means,
    float4* __restrict__ g1_quats, float4* __restrict__ g2_quats,
    float3* __restrict__ g1_scales, float3* __restrict__ g2_scales,
    float* __restrict__ g1_opacs, float* __restrict__ g2_opacs,
    float3* __restrict__ g1_features_dc, float3* __restrict__ g2_features_dc,
    float3* __restrict__ g1_features_sh, float3* __restrict__ g2_features_sh,
    int32_t* __restrict__ bias_correction_steps)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= num_children) return;
    int64_t idx_src = src_indices[i];
    int64_t idx_dst = dst_indices[i];

    float3 mean = means[idx_src], mean_delta;
    float3 scale = scales[idx_src], new_scale;
    float4 quat = quats[idx_src];
    float opac = opacs[idx_src], new_opac;
    SlangDensify::long_axis_split_3dgs(
        split_opacity_k, scale, opac, quat,
        &new_scale, &new_opac, &mean_delta);

    means[idx_src] = make_float3(mean.x - mean_delta.x, mean.y - mean_delta.y, mean.z - mean_delta.z);
    means[idx_dst] = make_float3(mean.x + mean_delta.x, mean.y + mean_delta.y, mean.z + mean_delta.z);
    scales[idx_src] = new_scale;
    scales[idx_dst] = new_scale;
    opacs[idx_src] = new_opac;
    opacs[idx_dst] = new_opac;
    quats[idx_dst] = quat;

    features_dc[idx_dst] = features_dc[idx_src];
    if (features_sh && num_sh > 0) {
        for (int k = 0; k < num_sh; ++k)
            features_sh[(int64_t)num_sh * idx_dst + k] = features_sh[(int64_t)num_sh * idx_src + k];
    }

    // optimizer state at dst: zero
    if (g1_means) {
        g1_means[idx_dst] = make_float3(0.0f);
        g2_means[idx_dst] = make_float3(0.0f);
        g1_quats[idx_dst] = make_float4(0.0f);
        g2_quats[idx_dst] = make_float4(0.0f);
        g1_scales[idx_dst] = make_float3(0.0f);
        g2_scales[idx_dst] = make_float3(0.0f);
        g1_opacs[idx_dst] = 0.0f;
        g2_opacs[idx_dst] = 0.0f;
        g1_features_dc[idx_dst] = make_float3(0.0f);
        g2_features_dc[idx_dst] = make_float3(0.0f);
        for (int k = 0; k < num_sh; ++k) {
            g1_features_sh[(int64_t)num_sh * idx_dst + k] = make_float3(0.0f);
            g2_features_sh[(int64_t)num_sh * idx_dst + k] = make_float3(0.0f);
        }
    }
    if (bias_correction_steps)
        bias_correction_steps[idx_dst] = 0;
}

/*[AutoHeaderGeneratorExport]*/
void strat_las_split_into_slots_tensor(
    int64_t num_children,
    float split_opacity_k,
    DeviceVector<int32_t> src_indices,
    DeviceVector<int32_t> dst_indices,
    DeviceVector<float3> means,
    DeviceVector<float4> quats,
    DeviceVector<float3> scales,
    DeviceVector<float> opacities,
    DeviceVector<float3> features_dc,
    DeviceVector<float3> features_sh,
    int num_sh,
    DeviceVector<float3> g1_means, DeviceVector<float3> g2_means,
    DeviceVector<float4> g1_quats, DeviceVector<float4> g2_quats,
    DeviceVector<float3> g1_scales, DeviceVector<float3> g2_scales,
    DeviceVector<float> g1_opacities, DeviceVector<float> g2_opacities,
    DeviceVector<float3> g1_features_dc, DeviceVector<float3> g2_features_dc,
    DeviceVector<float3> g1_features_sh, DeviceVector<float3> g2_features_sh,
    DeviceVector<int32_t> bias_correction_steps)
{
    if (num_children == 0)
        return;
    strat_las_split_into_slots_kernel<<<_LAUNCH_ARGS_1D(num_children, 256)>>>(
        num_children, split_opacity_k,
        src_indices.data_ptr(), dst_indices.data_ptr(),
        means.data_ptr(), quats.data_ptr(), scales.data_ptr(),
        opacities.data_ptr(), features_dc.data_ptr(), features_sh.data_ptr(),
        num_sh,
        g1_means.data_ptr(), g2_means.data_ptr(),
        g1_quats.data_ptr(), g2_quats.data_ptr(),
        g1_scales.data_ptr(), g2_scales.data_ptr(),
        g1_opacities.data_ptr(), g2_opacities.data_ptr(),
        g1_features_dc.data_ptr(), g2_features_dc.data_ptr(),
        g1_features_sh.data_ptr(), g2_features_sh.data_ptr(),
        bias_correction_steps.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}

// ================
// Per-splat edge score accumulation (IGS+/MRNF edge channel).
//
// Renders a laplacian edge map of the current camera's RGB, projects each
// splat center into the image (PINHOLE model only), and scatter-adds
//   edge_map[px] * alpha[px]
// into edge_acc[splat]. This is the Spirula-native equivalent of LFS's
// render-edge scoring: splats that sit on strong image edges (under- or
// over-reconstructed boundaries) accumulate high scores and win the next
// densification draw. Only the current batch camera is scored per call; the
// engine accumulates across the refine window, exactly like LFS's
// _edge_score_sum / _edge_view_scores window.
// ================

__global__ void strat_accumulate_edge_score_kernel(
    int64_t num_splats,
    int32_t cam_idx,
    int32_t C, int32_t width, int32_t height,
    const float4* __restrict__ viewmats,   // [C,4] float4 rows (c2w)
    const float4* __restrict__ intrins,    // [C] (fx, fy, cx, cy)
    const float3* __restrict__ means,
    const float3* __restrict__ render_rgb, // [C,H,W,3]
    const float*  __restrict__ render_alpha, // [C,H,W]
    float* __restrict__ edge_acc)
{
    int64_t i = (int64_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= num_splats) return;
    if (cam_idx >= C) return;
    // Score against camera `cam_idx` of the batch (the engine issues one
    // call per camera, one splat-index-space pass each).
    float3 p = means[i];
    const float4* vm = viewmats + (int64_t)cam_idx * 4;
    float3 t = make_float3(vm[3].x, vm[3].y, vm[3].z);
    float3 d = make_float3(p.x - t.x, p.y - t.y, p.z - t.z);
    float3 R0 = make_float3(vm[0].x, vm[0].y, vm[0].z);
    float3 R1 = make_float3(vm[1].x, vm[1].y, vm[1].z);
    float3 R2 = make_float3(vm[2].x, vm[2].y, vm[2].z);
    float pcx = R0.x*d.x + R0.y*d.y + R0.z*d.z;
    float pcy = R1.x*d.x + R1.y*d.y + R1.z*d.z;
    float pcz = R2.x*d.x + R2.y*d.y + R2.z*d.z;
    if (pcz <= 1e-3f) return;
    const float4 intr = intrins[cam_idx];
    float fx = intr.x, fy = intr.y;
    float cx = intr.z, cy = intr.w;
    float sx = fx * pcx / pcz + cx;
    float sy = fy * pcy / pcz + cy;
    int x = (int)floorf(sx);
    int y = (int)floorf(sy);
    if (x < 1 || y < 1 || x >= width - 1 || y >= height - 1) return;

    const float3* I = render_rgb + (int64_t)cam_idx * height * width + (int64_t)y * width + x;
    const float3 cL = I[-1];
    const float3 cR = I[+1];
    const float3 cU = I[-width];
    const float3 cD = I[+width];
    const float3 cc = I[0];
    float ex = fabsf(2.0f*cc.x - cL.x - cR.x) + fabsf(2.0f*cc.y - cL.y - cR.y) + fabsf(2.0f*cc.z - cL.z - cR.z);
    float ey = fabsf(2.0f*cc.x - cU.x - cD.x) + fabsf(2.0f*cc.y - cU.y - cD.y) + fabsf(2.0f*cc.z - cU.z - cD.z);
    float edge = (ex + ey) / 6.0f;
    float alpha = render_alpha[(int64_t)cam_idx * height * width + (int64_t)y * width + x];
    atomicAdd(&edge_acc[i], edge * alpha);
}

/*[AutoHeaderGeneratorExport]*/
void strat_accumulate_edge_score_tensor(
    int64_t num_splats,
    int32_t cam_idx,
    int32_t num_cameras, int32_t width, int32_t height,
    DeviceVector<float4> viewmats,
    DeviceVector<float4> intrins,
    DeviceVector<float3> means,
    DeviceTensor3D<float3> render_rgb,
    DeviceTensor3D<float> render_alpha,
    DeviceVector<float> edge_acc)
{
    if (num_splats == 0 || num_cameras == 0) return;
    strat_accumulate_edge_score_kernel<<<_LAUNCH_ARGS_1D(num_splats, 256)>>>(
        num_splats, cam_idx, num_cameras, width, height,
        (const float4*)viewmats.data_ptr(), intrins.data_ptr(),
        means.data_ptr(),
        render_rgb.data_ptr(), render_alpha.data_ptr(),
        edge_acc.data_ptr());
    CHECK_DEVICE_ERROR(cudaGetLastError());
}
