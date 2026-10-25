// Engine setup entrypoints: copy splat/camera/GT inputs to device-resident pool.

#include "engine/Engine.h"
#include "engine/EngineCommon.h"
#include "engine/EngineInternal.h"
#include "engine/EngineState.h"

#include <stdexcept>


void set_data_3dgs(
    int64_t num_splats,
    TorchTensorView means,
    TorchTensorView quats,
    TorchTensorView scales,
    TorchTensorView opacities,
    TorchTensorView features_dc,
    TorchTensorView features_sh,
    int sb_lobes
) {
    int64_t max_num_splats = std::get<2>(means)[0];
    if (std::get<2>(quats)[0] != max_num_splats ||
        std::get<2>(scales)[0] != max_num_splats ||
        std::get<2>(opacities)[0] != max_num_splats ||
        std::get<2>(features_dc)[0] != max_num_splats ||
        std::get<2>(features_sh)[0] != max_num_splats)
        throw std::runtime_error("setData3DGS: max_num_splats mismatch across splat tensors");
    if (max_num_splats < num_splats)
        throw std::runtime_error("setData3DGS: tensor size smaller than num_splats");

    engine().cur_num_splats = num_splats;
    engine().max_num_splats = max_num_splats;
    DevicePool::global().set_splat_counts(engine().cur_num_splats, engine().max_num_splats);

    auto sh_shape = std::get<2>(features_sh);
    engine().num_sh = (sh_shape.size() >= 2) ? (int)sh_shape[1] : 0;
    if (sb_lobes < 0 || 2 * sb_lobes > engine().num_sh)
        throw std::runtime_error("setData3DGS: a features_sh row of " +
                                 std::to_string(engine().num_sh) +
                                 " coefficients cannot hold " +
                                 std::to_string(sb_lobes) + " lobes");
    engine().sb_lobes = sb_lobes;

    // Splats are set once and persist on device; subsequent calls are no-ops.
    if (engine().world.initialized) return;

    engine().world.means       = _hv_to_dv<float3>(PoolSlot::WorldMeans, means);
    engine().world.quats       = _hv_to_dv<float4>(PoolSlot::WorldQuats, quats);
    engine().world.scales      = _hv_to_dv<float3>(PoolSlot::WorldScales, scales);
    engine().world.opacities   = _hv_to_dv<float>(PoolSlot::WorldOpacities, opacities);
    engine().world.features_dc = _hv_to_dv<float3>(PoolSlot::WorldFeaturesDc, features_dc);
    engine().world.features_sh = _hv_to_dt2d<float3>(PoolSlot::WorldFeaturesSh, features_sh);
    engine().world.features_sh_seeded = false;
    if (const float* h = (const float*)std::get<0>(features_sh);
        h && !backend::is_device_pointer(h)) {
        const int64_t n = max_num_splats * 3 * (int64_t)engine().num_sh;
        for (int64_t i = 0; i < n && !engine().world.features_sh_seeded; i++)
            engine().world.features_sh_seeded = h[i] != 0.0f;
    }

    engine().world.initialized = true;
}


void engine_set_region(TorchTensorView program, TorchTensorView field_bvh,
                       TorchTensorView field_seeds, TorchTensorView camera_bvh,
                       TorchTensorView camera_seeds, TorchTensorView pattern,
                       float outside_weight, float outside_opacity_decay) {
    auto& r = engine().region;
    r = EngineState::Region{};
    if (std::get<0>(program) == 0) return;
    // [n, 6, 4] floats arrive as float4 rows.
    auto as_float4 = [](TorchTensorView tv) {
        if (std::get<0>(tv) == 0) return tv;
        int64_t n = 1;
        for (int64_t d : std::get<2>(tv)) n *= d;
        return TorchTensorView(std::get<0>(tv), 4, {n / 4, 4});
    };
    r.program = _hv_to_dv<float4>(PoolSlot::EngRegionProgram, as_float4(program));
    r.field_bvh = _hv_to_dv<float4>(PoolSlot::EngRegionFieldBvh, as_float4(field_bvh));
    r.field_seeds = _hv_to_dv<float4>(PoolSlot::EngRegionFieldSeeds, as_float4(field_seeds));
    r.camera_bvh = _hv_to_dv<float4>(PoolSlot::EngRegionCameraBvh, as_float4(camera_bvh));
    r.camera_seeds = _hv_to_dv<float4>(PoolSlot::EngRegionCameraSeeds, as_float4(camera_seeds));
    r.pattern = _hv_to_dv<float4>(PoolSlot::EngRegionPattern, as_float4(pattern));
    r.outside = outside_weight;
    r.opacity_decay = outside_opacity_decay;
}

void set_camera_params(
    int width,
    int height,
    std::string camera_model,
    std::string distortion,
    TorchTensorView viewmats,
    TorchTensorView intrins,
    TorchTensorView dist_coeffs
) {
    engine().camera.width = width;
    engine().camera.height = height;
    engine().camera.model = cmt(camera_model);
    engine().camera.model_str = camera_model;
    engine().camera.distortion = cdt(distortion);
    engine().camera.distortion_str = distortion;
    engine().camera.num = std::get<2>(viewmats)[0];

    if (std::get<2>(intrins)[0] != engine().camera.num ||
        std::get<2>(dist_coeffs)[0] != engine().camera.num)
        throw std::runtime_error("setCameraParams: num_cameras mismatch");

    // viewmats: PyTorch shape [C, 4, 4] -> treat as DeviceTensor2D<float4> [C, 4]
    int64_t C = std::get<2>(viewmats)[0];
    {
        uint64_t src_ptr = std::get<0>(viewmats);
        float4* ptr;
        if (_is_device_ptr((void*)src_ptr)) {
            ptr = (float4*)src_ptr;
        } else {
            ptr = DevicePool::global().acquire<float4>(PoolSlot::CamViewmats, (size_t)(C * 4));
            backend::memcpy_sync(ptr, (void*)src_ptr, C * 4 * sizeof(float4), backend::MemcpyKind::HostToDevice);
        }
        TorchTensorView dv_tv((uint64_t)ptr, 4, {C, 4LL, 4LL});
        engine().camera.viewmats = DeviceTensor2D<float4>(dv_tv);
    }
    engine().camera.intrins     = _hv_to_dv<float4>(PoolSlot::CamIntrins, intrins);
    engine().camera.dist_coeffs = _hv_to_dt2d<float>(PoolSlot::CamDistCoeffs, dist_coeffs);
}


// An 8-bit image the loss can read as it is stays 8-bit on the device, a
// quarter of the float copy. A device source is copied too: the data
// manager may reuse its buffer for the next batch while this one trains.
static TorchTensorView _upload_gt_rgb(const TorchTensorView& src) {
    const uint64_t ptr = std::get<0>(src);
    if (ptr == 0) return TorchTensorView();
    if (std::get<1>(src) != 1 || engine().color_space.image_enabled)
        return _dt3d_tv(_hv_to_dt3d_gt<float3>(src, PoolSlot::GtRgb, "rgb"));
    size_t n = 1;
    for (int64_t d : std::get<2>(src)) n *= (size_t)d;
    uint8_t* dst = DevicePool::global().acquire<uint8_t>(PoolSlot::GtRgb, n);
    backend::memcpy_sync(dst, (const void*)ptr, n, backend::MemcpyKind::Auto);
    return TorchTensorView((uint64_t)dst, 1, std::get<2>(src));
}

void set_training_data(
    TorchTensorView gt_rgb,
    TorchTensorView gt_depth,
    TorchTensorView gt_normal,
    TorchTensorView gt_alpha,
    bool input_depth_is_ray_depth
) {
    engine().gt.rgb    = _upload_gt_rgb(gt_rgb);
    engine().gt.depth  = _hv_to_dt3d_gt<float>(gt_depth,   PoolSlot::GtDepth,  "depth");
    engine().gt.normal = _hv_to_dt3d_gt<float3>(gt_normal, PoolSlot::GtNormal, "normal");
    // gt_alpha: small bool/uint8 buffer (the external mask). No conversion;
    // the slang kernel reads bool per pixel. Drives engine().gt.has_mask.
    engine().gt.alpha  = _hv_to_dt3d<bool>(PoolSlot::GtAlpha, gt_alpha);
    engine().gt.has_gt    = (std::get<0>(gt_rgb) != 0);
    engine().gt.has_mask  = (std::get<0>(gt_alpha) != 0);

    // Linear (z) depth -> ray depth, in place on the GPU buffer, before the
    // depth bilateral grid / loss consume it. The rasterizer renders ray
    // depth, so linear supervision depth must be converted to match. Uses the
    // current camera intrinsics (set by set_camera_params just before this),
    // rescaled inside the kernel to the depth map resolution.
    if (!input_depth_is_ray_depth && engine().gt.depth.data_ptr() != nullptr) {
        linear_depth_to_ray_depth_inplace(
            engine().camera.model_str,
        engine().camera.distortion_str,
            _dv_tv(engine().camera.intrins),
            _dt2d_tv(engine().camera.dist_coeffs),
            engine().camera.width, engine().camera.height,
            engine().gt.depth
        );
    }

    // Apply image-side color space conversion (linear / wide-gamut -> sRGB)
    // in place on the freshly uploaded GT. No-op when no image color space
    // was configured.
    _engine_color_space_apply_to_gt();
}


// GaussianShader reflective model setup. Allocates + initialises the shading
// attributes and the environment cube map; idempotent per engine_reset cycle.
// The envmap starts as a dim neutral environment so the specular term is
// visible but does not wash out the diffuse base (full envmap learning /
// importing is staged).
void engine_set_shader(bool use_shader, int env_size) {
    engine().envmap_size = (use_shader && env_size > 0) ? env_size : 0;
    if (engine().envmap_size == 0) return;

    const int64_t N = engine().max_num_splats;
    if (N <= 0) throw std::runtime_error("engine_set_shader: splat pool not allocated");

    // Host->device TV helper: elements are 4-byte units (float / float3).
    auto htv = [](const void* p, int64_t n, int64_t d) -> TorchTensorView {
        return {(uint64_t)(uintptr_t)p, 4, {n, d}};
    };

    // tint = 1, roughness = 0.5, normal_res = 0.
    {
        std::vector<float3> tint((size_t)N, make_float3(1.0f, 1.0f, 1.0f));
        engine().world.features_tint = _hv_to_dv<float3>(
            PoolSlot::WorldFeaturesTint, htv(tint.data(), N, 3));
        std::vector<float> rough((size_t)N, 0.5f);
        engine().world.features_roughness = _hv_to_dv<float>(
            PoolSlot::WorldFeaturesRoughness, htv(rough.data(), N, 1));
        std::vector<float3> nres((size_t)N, make_float3(0.0f, 0.0f, 0.0f));
        engine().world.features_normal_res = _hv_to_dv<float3>(
            PoolSlot::WorldFeaturesNormalRes, htv(nres.data(), N, 3));
    }

    // Environment cube map: dim neutral grey with a gentle +Y (up) bias.
    const int s = env_size;
    const int64_t face_texels = (int64_t)s * s;
    std::vector<float3> env((size_t)(6 * face_texels));
    for (int f = 0; f < 6; ++f) {
        for (int64_t i = 0; i < face_texels; ++i) {
            float lum = 0.15f;
            if (f == 2) lum = 0.30f;   // +Y (up) face brighter
            if (f == 3) lum = 0.08f;   // -Y (down) face dimmer
            env[(size_t)(f * face_texels + i)] = make_float3(lum, lum, lum);
        }
    }
    engine().envmap = _hv_to_dv<float3>(PoolSlot::WorldEnvmap,
        htv(env.data(), 6 * face_texels, 3));
}
