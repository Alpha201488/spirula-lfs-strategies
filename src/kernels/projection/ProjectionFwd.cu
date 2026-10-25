#include "kernels/projection/ProjectionFwd.cuh"

#include "kernels/projection/CameraVariants.cuh"

#include <core/Common.cuh>

// Shader3DGS (GaussianShader) projection: CUDA-only path.
#include "primitives/Primitive3DGSShader.cuh"

#include <cooperative_groups.h>
namespace cg = cooperative_groups;


template<typename SplatPrimitive, CameraModelType camera_model,
         CameraDistortionType distortion>
void projection_fused_fwd_kernel_wrapper(
    cudaStream_t stream,
    const uint32_t C,
    const uint32_t N,
    typename SplatPrimitive::WorldBuffer splats_world,
    const float *__restrict__ viewmats, // [C, 4, 4]
    const float4 *__restrict__ intrins,  // [C, 4], fx, fy, cx, cy
    const CameraDistortionCoeffsBuffer dist_coeffs_buffer,
    const uint32_t image_width,
    const uint32_t image_height,
    // outputs
    uint2 *__restrict__ aabbs,          // [C, N] packed
    float *__restrict__ sorting_depths,  // [C, N, 1]
    float *__restrict__ radii,  // [N, 1]
    typename SplatPrimitive::ScreenBuffer splats_screen,
    const uint8_t* __restrict__ sh_value_packed,
    const float2* __restrict__ sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    // sh_bounds_stride: cells per value-quant bound. 0 (default) = per-splat
    // block (256 * 3 * num_sh_buffer cells/bound, matching FPBO allocation).
    // 256 = per-cell block (non-FPBO value-quant allocation).
    const int64_t sh_bounds_stride,
    // GaussianShader envmap (null disables the shading path). Must mirror the
    // definition in ProjectionFwd_kernel.cuh (the explicit instantiations in
    // src/instantiations/PF_P3GPF*.cu are generated from this declaration).
    const float* __restrict__ envmap,
    const int env_size
);



template<typename SplatPrimitive>
inline std::tuple<
    DeviceTensor2D<uint2>,   // aabb [C, N] packed, core/AabbQuant.cuh
    DeviceTensor2D<float>,   // sorting_depths [C, N]
    std::vector<DeviceTensorFloatND>  // out splats
> launch_projection_fused_fwd_kernel(
    const int64_t N,
    const std::vector<DeviceTensorFloatND> &in_splats,
    const float* viewmats_ptr,  // [C, 4, 4]
    const float4* intrins_ptr,  // [C, 4]
    const uint32_t C,
    const uint32_t image_width,
    const uint32_t image_height,
    const CameraModelType camera_model,
    const CameraDistortionType distortion,
    const TorchTensorView dist_coeffs,
    DeviceVector<float> radii,
    // SH VALUE-quant: packed bytes + per-cell-block bounds. When sh_value_bits
    // == 32 these are nullptr and the kernel takes its existing fp32 path.
    const uint8_t* sh_value_packed,
    const float2* sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    const int64_t sh_bounds_stride,
    // GaussianShader envmap (null disables the shading path).
    const float* envmap,
    const int env_size
) {
    typename SplatPrimitive::WorldBuffer splats_world(in_splats);

    DeviceTensor2D<uint2> aabb;
    aabb.resize(PoolSlot::ProjAabb, C, N);
    DeviceTensor2D<float> sorting_depths;
    sorting_depths.resize(PoolSlot::ProjDepths, C, N);

    std::vector<DeviceTensorFloatND> splats_screen = SplatPrimitive::ScreenBuffer::empty_pool(C*splats_world.size(), PoolSlot::ProjScreen);

    #define _LAUNCH_ARGS ( \
            (cudaStream_t)0, C, N, \
            splats_world, viewmats_ptr, intrins_ptr, dist_coeffs, \
            image_width, image_height, \
            aabb.data_ptr(), sorting_depths.data_ptr(), radii.data_ptr(), \
            splats_screen, \
            sh_value_packed, sh_value_bounds, num_sh_buffer, sh_value_bits, \
            sh_bounds_stride, envmap, env_size \
        )

    #define _DISPATCH(M, D) \
        if (camera_model == CameraModelType::M && distortion == CameraDistortionType::D) \
            projection_fused_fwd_kernel_wrapper<SplatPrimitive, \
                CameraModelType::M, CameraDistortionType::D> _LAUNCH_ARGS; else
    SS_FOR_EACH_CAMERA_VARIANT(_DISPATCH)
        throw std::runtime_error("Unsupported camera model / distortion tier");
    #undef _DISPATCH
    CHECK_DEVICE_ERROR(cudaGetLastError());

    #undef _LAUNCH_ARGS

    return std::make_tuple(aabb, sorting_depths, splats_screen);
}


// ================
// Vanilla3DGS
// ================

/*[AutoHeaderGeneratorExport]*/
std::tuple<
    DeviceTensor2D<uint2>, DeviceTensor2D<float>, std::vector<DeviceTensorFloatND>
> projection_3dgs_forward(
    const int64_t num_splats, const ColorBasis color,
    const std::vector<DeviceTensorFloatND> &in_splats,
    TorchTensorView viewmats, TorchTensorView intrins,
    const uint32_t image_width, const uint32_t image_height,
    const std::string camera_model, const std::string distortion,
    const TorchTensorView dist_coeffs,
    DeviceVector<float> radii,
    const std::optional<TorchTensorView> sh_value_packed,
    const std::optional<TorchTensorView> sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    // SH value-bounds cell stride. 0 = FPBO per-splat-block layout
    // (256 * 3 * num_sh_buffer cells/bound). 256 = non-FPBO per-cell-block
    // layout. Plumbed unchanged from EngineForward.cpp.
    const int64_t sh_bounds_stride
) {
    const int max_sh_degree = sh_only_degree(color, "projection_3dgs_forward");
    int sh_degree = Vanilla3DGS<0>::WorldBuffer(in_splats).sh_degree();
    sh_degree = min(sh_degree, max_sh_degree);
    uint32_t C = (uint32_t)std::get<2>(viewmats)[0];
    const float* vm = (const float*)std::get<0>(viewmats);
    const float4* intr = (const float4*)std::get<0>(intrins);
    const uint8_t* vp = sh_value_packed.has_value()
        ? (const uint8_t*)std::get<0>(sh_value_packed.value()) : nullptr;
    const float2* vb = sh_value_bounds.has_value()
        ? (const float2*)std::get<0>(sh_value_bounds.value()) : nullptr;
    #define LAUNCH(n) if (sh_degree == (n)) \
        return launch_projection_fused_fwd_kernel<Vanilla3DGS<n>>( \
            num_splats, in_splats, vm, intr, C, image_width, image_height, cmt(camera_model), cdt(distortion), dist_coeffs, radii, \
            vp, vb, num_sh_buffer, sh_value_bits, sh_bounds_stride, \
            nullptr, 0);
    LAUNCH(3) LAUNCH(2) LAUNCH(1) LAUNCH(0) LAUNCH(4)
    #undef LAUNCH
    return {};
}


// ================
// Shader3DGS (GaussianShader, CVPR 2024)
// ================

/*[AutoHeaderGeneratorExport]*/
std::tuple<
    DeviceTensor2D<uint2>, DeviceTensor2D<float>, std::vector<DeviceTensorFloatND>
> projection_3dgs_shader_forward(
    const int64_t num_splats, const int max_sh_degree,
    const std::vector<DeviceTensorFloatND> &in_splats,
    TorchTensorView viewmats, TorchTensorView intrins,
    const uint32_t image_width, const uint32_t image_height,
    const std::string camera_model, const std::string distortion,
    const TorchTensorView dist_coeffs,
    DeviceVector<float> radii,
    const std::optional<TorchTensorView> sh_value_packed,
    const std::optional<TorchTensorView> sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    // SH value-bounds cell stride (see projection_3dgs_forward).
    const int64_t sh_bounds_stride,
    // GaussianShader environment cube map. Layout: 6 faces x env_size x
    // env_size x 3, row-major per face (+X -X +Y -Y +Z -Z). Null disables the
    // shading path (output equals the base SH colour).
    const std::optional<TorchTensorView> envmap,
    const int env_size
) {
    int sh_degree = Shader3DGS<0>::WorldBuffer(in_splats).sh_deg();
    sh_degree = min(sh_degree, max_sh_degree);
    uint32_t C = (uint32_t)std::get<2>(viewmats)[0];
    const float* vm = (const float*)std::get<0>(viewmats);
    const float4* intr = (const float4*)std::get<0>(intrins);
    const uint8_t* vp = sh_value_packed.has_value()
        ? (const uint8_t*)std::get<0>(sh_value_packed.value()) : nullptr;
    const float2* vb = sh_value_bounds.has_value()
        ? (const float2*)std::get<0>(sh_value_bounds.value()) : nullptr;
    const float* em = envmap.has_value()
        ? (const float*)std::get<0>(envmap.value()) : nullptr;
    #define LAUNCH(n) if (sh_degree == (n)) \
        return launch_projection_fused_fwd_kernel<Shader3DGS<n>>( \
            num_splats, in_splats, vm, intr, C, image_width, image_height, cmt(camera_model), cdt(distortion), dist_coeffs, radii, \
            vp, vb, num_sh_buffer, sh_value_bits, sh_bounds_stride, \
            em, env_size);
    LAUNCH(3) LAUNCH(2) LAUNCH(1) LAUNCH(0) LAUNCH(4)
    #undef LAUNCH
    return {};
}


// ================
// MipSplatting
// ================

/*[AutoHeaderGeneratorExport]*/
std::tuple<
    DeviceTensor2D<uint2>, DeviceTensor2D<float>, std::vector<DeviceTensorFloatND>
> projection_mip_forward(
    const int64_t num_splats, const ColorBasis color,
    const std::vector<DeviceTensorFloatND> &in_splats,
    TorchTensorView viewmats, TorchTensorView intrins,
    const uint32_t image_width, const uint32_t image_height,
    const std::string camera_model, const std::string distortion,
    const TorchTensorView dist_coeffs,
    DeviceVector<float> radii,
    const std::optional<TorchTensorView> sh_value_packed,
    const std::optional<TorchTensorView> sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    // SH value-bounds cell stride. 0 = FPBO per-splat-block layout
    // (256 * 3 * num_sh_buffer cells/bound). 256 = non-FPBO per-cell-block
    // layout. Plumbed unchanged from EngineForward.cpp.
    const int64_t sh_bounds_stride
) {
    const int max_sh_degree = sh_only_degree(color, "projection_mip_forward");
    int sh_degree = MipSplatting<0>::WorldBuffer(in_splats).sh_degree();
    sh_degree = min(sh_degree, max_sh_degree);
    uint32_t C = (uint32_t)std::get<2>(viewmats)[0];
    const float* vm = (const float*)std::get<0>(viewmats);
    const float4* intr = (const float4*)std::get<0>(intrins);
    const uint8_t* vp = sh_value_packed.has_value()
        ? (const uint8_t*)std::get<0>(sh_value_packed.value()) : nullptr;
    const float2* vb = sh_value_bounds.has_value()
        ? (const float2*)std::get<0>(sh_value_bounds.value()) : nullptr;
    #define LAUNCH(n) if (sh_degree == (n)) \
        return launch_projection_fused_fwd_kernel<MipSplatting<n>>( \
            num_splats, in_splats, vm, intr, C, image_width, image_height, cmt(camera_model), cdt(distortion), dist_coeffs, radii, \
            vp, vb, num_sh_buffer, sh_value_bits, sh_bounds_stride, \
            nullptr, 0);
    LAUNCH(3) LAUNCH(2) LAUNCH(1) LAUNCH(0) LAUNCH(4)
    #undef LAUNCH
    return {};
}



// ================
// Vanilla3DGUT
// ================

/*[AutoHeaderGeneratorExport]*/
std::tuple<
    DeviceTensor2D<uint2>, DeviceTensor2D<float>, std::vector<DeviceTensorFloatND>
> projection_3dgut_forward(
    const int64_t num_splats, const ColorBasis color,
    const std::vector<DeviceTensorFloatND> &in_splats,
    TorchTensorView viewmats, TorchTensorView intrins,
    const uint32_t image_width, const uint32_t image_height,
    const std::string camera_model, const std::string distortion,
    const TorchTensorView dist_coeffs,
    DeviceVector<float> radii,
    const std::optional<TorchTensorView> sh_value_packed,
    const std::optional<TorchTensorView> sh_value_bounds,
    const uint32_t num_sh_buffer,
    const int sh_value_bits,
    // SH value-bounds cell stride. 0 = FPBO per-splat-block layout
    // (256 * 3 * num_sh_buffer cells/bound). 256 = non-FPBO per-cell-block
    // layout. Plumbed unchanged from EngineForward.cpp.
    const int64_t sh_bounds_stride
) {
    const int max_sh_degree = sh_only_degree(color, "projection_3dgut_forward");
    int sh_degree = Vanilla3DGUT<0>::WorldBuffer(in_splats).sh_degree();
    sh_degree = min(sh_degree, max_sh_degree);
    uint32_t C = (uint32_t)std::get<2>(viewmats)[0];
    const float* vm = (const float*)std::get<0>(viewmats);
    const float4* intr = (const float4*)std::get<0>(intrins);
    const uint8_t* vp = sh_value_packed.has_value()
        ? (const uint8_t*)std::get<0>(sh_value_packed.value()) : nullptr;
    const float2* vb = sh_value_bounds.has_value()
        ? (const float2*)std::get<0>(sh_value_bounds.value()) : nullptr;
    #define LAUNCH(n) if (sh_degree == (n)) \
        return launch_projection_fused_fwd_kernel<Vanilla3DGUT<n>>( \
            num_splats, in_splats, vm, intr, C, image_width, image_height, cmt(camera_model), cdt(distortion), dist_coeffs, radii, \
            vp, vb, num_sh_buffer, sh_value_bits, sh_bounds_stride, \
            nullptr, 0);
    LAUNCH(3) LAUNCH(2) LAUNCH(1) LAUNCH(0) LAUNCH(4)
    #undef LAUNCH
    return {};
}
