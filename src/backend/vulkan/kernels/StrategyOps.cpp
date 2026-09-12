// StrategyOps.cpp -- Vulkan-backend throwing stubs for the LFS-style strategy
// kernels (src/kernels/strategy/StrategyOps.cu). The strategy engine is part
// of the portable layer; on the Vulkan backend these training-phase kernels
// are not implemented yet, so calling one throws -- matching the pattern of
// TrainingStubs.gen.cpp. Porting any of these to Vulkan means moving the
// definition here and out of the stub.
//
// SPDX-FileCopyrightText: 2026 Spirula strategy-port Authors
// SPDX-License-Identifier: GPL-3.0-or-later

#include "kernels/strategy/StrategyOps.cuh"

#include <stdexcept>
#include <string>

namespace {
[[noreturn]] void _vk_strat_stub(const char* name) {
    throw std::runtime_error(std::string("Vulkan backend: ") + name +
                             " is not implemented yet (LFS-style strategy kernels)");
}
}  // namespace

void strat_prune_mask_tensor(
    int64_t, DeviceVector<float>, DeviceVector<float3>, DeviceVector<float4>,
    float, float, bool*)
{
    _vk_strat_stub("strat_prune_mask_tensor");
}

void strat_extract_lane0_tensor(
    int64_t, DeviceVector<float2>, DeviceVector<float>)
{
    _vk_strat_stub("strat_extract_lane0_tensor");
}

void strat_pack_lane0_tensor(
    int64_t, DeviceVector<float>, DeviceVector<float2>)
{
    _vk_strat_stub("strat_pack_lane0_tensor");
}

void strat_dual_score_tensor(
    int64_t, DeviceVector<float>, DeviceVector<float>, float, DeviceVector<float>)
{
    _vk_strat_stub("strat_dual_score_tensor");
}

void strat_ew_mul_inplace_tensor(int64_t, DeviceVector<float>, DeviceVector<float>)
{
    _vk_strat_stub("strat_ew_mul_inplace_tensor");
}

void strat_ew_add_inplace_tensor(int64_t, DeviceVector<float>, DeviceVector<float>)
{
    _vk_strat_stub("strat_ew_add_inplace_tensor");
}

void strat_ew_mul_scalar_inplace_tensor(int64_t, DeviceVector<float>, float)
{
    _vk_strat_stub("strat_ew_mul_scalar_inplace_tensor");
}

void strat_ew_add_scalar_inplace_tensor(int64_t, DeviceVector<float>, float)
{
    _vk_strat_stub("strat_ew_add_scalar_inplace_tensor");
}

void strat_ew_clamp_min_inplace_tensor(int64_t, DeviceVector<float>, float)
{
    _vk_strat_stub("strat_ew_clamp_min_inplace_tensor");
}

void strat_mask_apply_inplace_tensor(int64_t, DeviceVector<float>, bool*)
{
    _vk_strat_stub("strat_mask_apply_inplace_tensor");
}

void strat_mask_ge_tensor(int64_t, DeviceVector<float>, float, bool*)
{
    _vk_strat_stub("strat_mask_ge_tensor");
}

void strat_mask_or_inplace_tensor(int64_t, bool*, bool*)
{
    _vk_strat_stub("strat_mask_or_inplace_tensor");
}

void strat_mask_and_inplace_tensor(int64_t, bool*, bool*)
{
    _vk_strat_stub("strat_mask_and_inplace_tensor");
}

void strat_mask_not_inplace_tensor(int64_t, bool*)
{
    _vk_strat_stub("strat_mask_not_inplace_tensor");
}

void strat_count_nonzero_tensor(int64_t, DeviceVector<float>, DeviceVector<int64_t>)
{
    _vk_strat_stub("strat_count_nonzero_tensor");
}

void strat_sum_tensor(int64_t, DeviceVector<float>, DeviceVector<float>)
{
    _vk_strat_stub("strat_sum_tensor");
}

void strat_mask_count_tensor(int64_t, bool*, DeviceVector<int64_t>)
{
    _vk_strat_stub("strat_mask_count_tensor");
}

void strat_extract_indices_tensor(
    int64_t, bool*, DeviceVector<int32_t>, DeviceVector<int64_t>)
{
    _vk_strat_stub("strat_extract_indices_tensor");
}

void strat_scatter_zero_rows_tensor(
    int64_t, DeviceVector<int32_t>, int64_t, DeviceVector<float>)
{
    _vk_strat_stub("strat_scatter_zero_rows_tensor");
}

void strat_scatter_set_rows_tensor(
    int64_t, DeviceVector<int32_t>, int64_t, float, DeviceVector<float>)
{
    _vk_strat_stub("strat_scatter_set_rows_tensor");
}

void strat_opacity_reset_tensor(
    int64_t, DeviceVector<float>, float, bool*)
{
    _vk_strat_stub("strat_opacity_reset_tensor");
}

void strat_far_mask_tensor(
    int64_t, DeviceVector<float3>, float, float, float, float, bool*)
{
    _vk_strat_stub("strat_far_mask_tensor");
}

void strat_las_split_into_slots_tensor(
    int64_t, float,
    DeviceVector<int32_t>, DeviceVector<int32_t>,
    DeviceVector<float3>, DeviceVector<float4>, DeviceVector<float3>,
    DeviceVector<float>, DeviceVector<float3>, DeviceVector<float3>, int,
    DeviceVector<float3>, DeviceVector<float3>,
    DeviceVector<float4>, DeviceVector<float4>,
    DeviceVector<float3>, DeviceVector<float3>,
    DeviceVector<float>, DeviceVector<float>,
    DeviceVector<float3>, DeviceVector<float3>,
    DeviceVector<float3>, DeviceVector<float3>,
    DeviceVector<int32_t>)
{
    _vk_strat_stub("strat_las_split_into_slots_tensor");
}

void strat_accumulate_edge_score_tensor(
    int64_t, int32_t, int32_t, int32_t, int32_t,
    DeviceVector<float4>, DeviceVector<float4>, DeviceVector<float3>,
    DeviceTensor3D<float3>, DeviceTensor3D<float>, DeviceVector<float>)
{
    _vk_strat_stub("strat_accumulate_edge_score_tensor");
}
