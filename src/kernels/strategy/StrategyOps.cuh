#pragma once


#include <core/Tensor.h>


// LFS-style densification strategy kernels (see StrategyOps.cu for the
// ported-logic provenance). CUDA-include-free: parses in the portable
// (Vulkan) build; the Vulkan backend provides throwing stubs in
// backend/vulkan/kernels/StrategyOps.cpp.


/* == AUTO HEADER GENERATOR - DO NOT EDIT THIS LINE OR ANYTHING BELOW THIS LINE == */



void strat_pack_lane0_tensor(
    int64_t numel, DeviceVector<float> src, DeviceVector<float2> dst);


void strat_extract_lane0_tensor(
    int64_t numel, DeviceVector<float2> src, DeviceVector<float> dst);


void strat_prune_mask_tensor(
    int64_t num_splats,
    DeviceVector<float> opacities,
    DeviceVector<float3> log_scales,
    DeviceVector<float4> quats,
    float min_opacity,
    float log_min_scale,
    bool* out_mask);


void strat_dual_score_tensor(
    int64_t num_splats,
    DeviceVector<float> error_scores,
    DeviceVector<float> edge_scores,
    float edge_weight,
    DeviceVector<float> out);


void strat_ew_mul_inplace_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> b);


void strat_ew_add_inplace_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> b);


void strat_ew_mul_scalar_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float s);


void strat_ew_add_scalar_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float s);


void strat_ew_clamp_min_inplace_tensor(
    int64_t numel, DeviceVector<float> a, float lo);


void strat_mask_apply_inplace_tensor(
    int64_t numel, DeviceVector<float> a, bool* keep);


void strat_mask_ge_tensor(
    int64_t numel, DeviceVector<float> a, float thr, bool* out);


void strat_mask_or_inplace_tensor(
    int64_t numel, bool* a, bool* b);


void strat_mask_and_inplace_tensor(
    int64_t numel, bool* a, bool* b);


void strat_mask_not_inplace_tensor(int64_t numel, bool* a);


void strat_count_nonzero_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<int64_t> out_scalar);


void strat_sum_tensor(
    int64_t numel, DeviceVector<float> a, DeviceVector<float> out_scalar);


void strat_mask_count_tensor(
    int64_t numel, bool* mask, DeviceVector<int64_t> out_scalar);


void strat_extract_indices_tensor(
    int64_t numel, bool* mask,
    DeviceVector<int32_t> out_indices, DeviceVector<int64_t> out_count);


void strat_scatter_set_rows_tensor(
    int64_t n_idx, DeviceVector<int32_t> indices,
    int64_t stride, float value, DeviceVector<float> dst);


void strat_scatter_zero_rows_tensor(
    int64_t n_idx, DeviceVector<int32_t> indices,
    int64_t stride, DeviceVector<float> dst);


void strat_opacity_reset_tensor(
    int64_t numel, DeviceVector<float> opacities,
    float logit_reset, bool* clamped_out);


void strat_far_mask_tensor(
    int64_t numel, DeviceVector<float3> means,
    float cx, float cy, float cz, float radius_sq, bool* out);


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
    DeviceVector<int32_t> bias_correction_steps);


void strat_accumulate_edge_score_tensor(
    int64_t num_splats,
    int32_t cam_idx,
    int32_t num_cameras, int32_t width, int32_t height,
    DeviceVector<float4> viewmats,
    DeviceVector<float4> intrins,
    DeviceVector<float3> means,
    DeviceTensor3D<float3> render_rgb,
    DeviceTensor3D<float> render_alpha,
    DeviceVector<float> edge_acc);
