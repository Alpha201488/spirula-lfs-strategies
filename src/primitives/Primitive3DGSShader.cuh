// GaussianShader (CVPR 2024) reflective primitive.
//
// Shader3DGS keeps the base 3DGS layout (mean/quat/scale/opacity/dc/SH) and
// adds three shading attributes per splat:
//   slot 6: features_tint        float3  -- specular tint s (colour domain)
//   slot 7: features_roughness   float   -- roughness (0..1, colour domain)
//   slot 8: features_normal_res  float3  -- normal residual dn1 (dn2 staged)
//
// When an environment cube map is supplied the per-splat colour is the
// GaussianShader shading function (Sec. 3.1 of the paper):
//   c(w_o) = c_d + s .* L_s(w_o, n, rho) + c_r(w_o)
// with c_d the SH-DC diffuse colour, c_r the high-order SH residual and L_s a
// (pre-filtered) environment map sample along the reflection direction of the
// shortest-axis normal. Without an envmap the primitive degrades to the base
// SH colour (identical output to _Base3DGS).
//
// Backward: gradients flow through the SH VJP exactly as the base primitive
// (an approximation: the specular term's analytic gradients w.r.t. geometry /
// roughness / normal residual are staged in a later phase). The new shading
// attributes are read in forward only; if their gradient slots are null the
// atomic guards skip the write, so training leaves tint/roughness/normal_res
// at their initial values.

#pragma once

#ifdef __CUDACC__
#include "generated/slang.cuh"
namespace Slang3DGS {
#include "generated/set_namespace.cuh"
#include "generated/primitive_3dgs.cuh"
}
namespace SlangHarmonics {
#include "generated/set_namespace.cuh"
#include "generated/harmonics.cuh"
}
#endif

#include "primitives/Primitive.cuh"
#include "primitives/Primitive3DGS.cuh"

// ---------------------------------------------------------------------------
// Environment cube-map helpers (shared by forward / backward).
//
// Layout: 6 faces of env_size x env_size x 3 floats, faces ordered
// +X, -X, +Y, -Y, +Z, -Z (Vulkan/GL convention), row-major per face.
// Sampling is bilinear in the face's own UV space.
// ---------------------------------------------------------------------------
namespace ShaderEnv {

__device__ __forceinline__ float3 env_face_uv(const float3& d, int& face, float& u, float& v) {
    // Returns the dominant axis magnitude; picks face + UV for direction d.
    const float ax = fabsf(d.x), ay = fabsf(d.y), az = fabsf(d.z);
    float ma;
    if (ax >= ay && ax >= az) {
        face = (d.x >= 0.0f) ? 0 : 1;        // +X / -X
        ma = ax;
        u = (d.x >= 0.0f) ? -d.z : d.z;      // +X: u=-z ; -X: u=+z
        v = -d.y;
    } else if (ay >= az) {
        face = (d.y >= 0.0f) ? 2 : 3;        // +Y / -Y
        ma = ay;
        u = d.x;
        v = (d.y >= 0.0f) ? d.z : -d.z;      // +Y: v=+z ; -Y: v=-z
    } else {
        face = (d.z >= 0.0f) ? 4 : 5;        // +Z / -Z
        ma = az;
        u = (d.z >= 0.0f) ? d.x : -d.x;      // +Z: u=+x ; -Z: u=-x
        v = -d.y;
    }
    // Normalised to [-1,1] then mapped to [0,1].
    u = 0.5f * (u / ma + 1.0f);
    v = 0.5f * (v / ma + 1.0f);
    return make_float3(ma, u, v);
}

// Bilinear sample of one face row. Clamps at the face border (no cross-face
// filtering -- fine for a first-order envmap).
__device__ __forceinline__ float3 sample_face(const float* __restrict__ env,
                                                     int env_size, int face,
                                                     float u, float v) {
    const float px = u * (float)env_size - 0.5f;
    const float py = v * (float)env_size - 0.5f;
    int x0 = (int)floorf(px), y0 = (int)floorf(py);
    const float fx = px - (float)x0, fy = py - (float)y0;
    x0 = min(max(x0, 0), env_size - 2);
    y0 = min(max(y0, 0), env_size - 2);
    const int x1 = x0 + 1, y1 = y0 + 1;
    const float* base = env + ((int64_t)face * env_size * env_size) * 3;
    auto tex = [&](int x, int y) {
        const float* t = base + ((int64_t)y * env_size + x) * 3;
        return make_float3(t[0], t[1], t[2]);
    };
    const float3 c00 = tex(x0, y0), c10 = tex(x1, y0);
    const float3 c01 = tex(x0, y1), c11 = tex(x1, y1);
    float3 top = c00 + (c10 - c00) * fx;
    float3 bot = c01 + (c11 - c01) * fx;
    return top + (bot - top) * fy;
}

// Directional sample: picks the face, bilinear-samples, and applies a
// first-order roughness attenuation (rough surfaces spread the highlight, so
// the peak value drops). A full GGX pre-filtered mip chain is staged later.
__device__ __forceinline__ float3 sample_envmap(const float* __restrict__ env,
                                                       int env_size,
                                                       const float3& r,
                                                       float roughness) {
    int face;
    float u, v;
    env_face_uv(r, face, u, v);
    float3 Ls = sample_face(env, env_size, face, u, v);
    const float rho = fminf(fmaxf(roughness, 0.0f), 1.0f);
    Ls = Ls * (1.0f - 0.85f * rho);   // 1.0 (mirror) .. 0.15 (fully rough)
    return Ls;
}

// Shortest-axis normal of a Gaussian: the local axis with the smallest log
// scale, rotated into world space by the quat. quat layout wxyz.
__device__ __forceinline__ float3 shortest_axis_normal(float3 scale_log,
                                                              float4 quat) {
    int axis = 0;
    if (scale_log.y < scale_log.x) axis = 1;
    if (scale_log.z < (axis == 0 ? scale_log.x : scale_log.y)) axis = 2;
    // Local basis axis e_{axis} rotated by quat (column of the rotmat).
    const float x = quat.y, y = quat.z, z = quat.w, w = quat.x;
    const float x2 = x * x, y2 = y * y, z2 = z * z;
    switch (axis) {
        case 0:
            return make_float3(1.0f - 2.0f * (y2 + z2),
                               2.0f * (x * y + w * z),
                               2.0f * (x * z - w * y));
        case 1:
            return make_float3(2.0f * (x * y - w * z),
                               1.0f - 2.0f * (x2 + z2),
                               2.0f * (y * z + w * x));
        default:
            return make_float3(2.0f * (x * z + w * y),
                               2.0f * (y * z - w * x),
                               1.0f - 2.0f * (x2 + y2));
    }
}

}  // namespace ShaderEnv


template<int sh_degree, bool antialiased>
struct _Base3DGSShader : public _Base3DGS<sh_degree, antialiased> {
    static constexpr RenderOutputType pixelType = RenderOutputType::RGB_D;

    using ScreenBuffer = typename _Base3DGS<sh_degree, antialiased>::ScreenBuffer;

    class WorldBuffer : public TensorArray<9> {
    public:
        using TensorArray<9>::TensorArray;
    #ifdef __CUDACC__
        // Base slots (0-5) mirror _BasePrimitive3DGS::WorldBuffer.
        __forceinline__ __device__ float3& means(int64_t i)
            { return *reinterpret_cast<float3*>(&_data[0][3*i]); }
        __forceinline__ __device__ float4& quats(int64_t i)
            { return *reinterpret_cast<float4*>(&_data[1][4*i]); }
        __forceinline__ __device__ float3& scales(int64_t i)
            { return *reinterpret_cast<float3*>(&_data[2][3*i]); }
        __forceinline__ __device__ float& opacities(int64_t i)
            { return *reinterpret_cast<float*>(&_data[3][i]); }
        __forceinline__ __device__ float3& features_dc(int64_t i)
            { return *reinterpret_cast<float3*>(&_data[4][3*i]); }
        __forceinline__ __device__ float* features_sh(int64_t i)
            { return &_data[5][_strides[5]*i]; }
        // Shader slots.
        __forceinline__ __device__ float3& features_tint(int64_t i)
            { return *reinterpret_cast<float3*>(&_data[6][3*i]); }
        __forceinline__ __device__ float& features_roughness(int64_t i)
            { return *reinterpret_cast<float*>(&_data[7][i]); }
        __forceinline__ __device__ float3& features_normal_res(int64_t i)
            { return *reinterpret_cast<float3*>(&_data[8][3*i]); }

        __forceinline__ __device__ float3 means(int64_t i) const
            { return *reinterpret_cast<float3*>(&_data[0][3*i]); }
        __forceinline__ __device__ float4 quats(int64_t i) const
            { return *reinterpret_cast<float4*>(&_data[1][4*i]); }
        __forceinline__ __device__ float3 scales(int64_t i) const
            { return *reinterpret_cast<float3*>(&_data[2][3*i]); }
        __forceinline__ __device__ float opacities(int64_t i) const
            { return *reinterpret_cast<float*>(&_data[3][i]); }
        __forceinline__ __device__ float3 features_dc(int64_t i) const
            { return *reinterpret_cast<float3*>(&_data[4][3*i]); }
        __forceinline__ __device__ const float* features_sh(int64_t i) const
            { return &_data[5][_strides[5]*i]; }
        __forceinline__ __device__ float3 features_tint(int64_t i) const
            { return *reinterpret_cast<float3*>(&_data[6][3*i]); }
        __forceinline__ __device__ float features_roughness(int64_t i) const
            { return *reinterpret_cast<float*>(&_data[7][i]); }
        __forceinline__ __device__ float3 features_normal_res(int64_t i) const
            { return *reinterpret_cast<float3*>(&_data[8][3*i]); }
    #endif  // __CUDACC__

        // (name avoids the enclosing template parameter `sh_degree`:
        // nvcc rejects a member function sharing the template parameter name)
        int sh_deg() {
            int num_sh = _strides[5] / 3;
            return (
                num_sh == 3 ? 1 :
                num_sh == 8 ? 2 :
                num_sh == 15 ? 3 :
                num_sh == 24 ? 4 :
                0
            );
        }
        static std::vector<DeviceTensorFloatND> empty_pool(int64_t size, int num_sh, PoolSlot key_prefix) {
            return TensorArray<9>::empty_pool(
                size, {3, 4, 3, 1, 3, (int32_t)(3*num_sh), 3, 1, 3}, key_prefix);
        }
        static std::vector<DeviceTensorFloatND> zeros_pool(
            int64_t size, int num_sh, PoolSlot key_prefix) {
            return TensorArray<9>::zeros_pool(
                size, {3, 4, 3, 1, 3, (int32_t)(3*num_sh), 3, 1, 3}, key_prefix);
        }
        static std::vector<DeviceTensorFloatND> zeros_pool(
            const std::vector<DeviceTensorFloatND>& tmpl, PoolSlot key_prefix) {
            return TensorArray<9>::zeros_pool(tmpl, key_prefix);
        }
    };

#ifdef __CUDACC__
    struct World : public _Base3DGS<sh_degree, antialiased>::World {
        float3 features_tint;        // specular tint, colour domain (init 1)
        float  features_roughness;   // 0..1 (init 0.5)
        float3 features_normal_res;  // normal residual dn1 (init 0)

        World() = default;
        __device__ World(const typename _Base3DGS<sh_degree, antialiased>::World& other) {
            _Base3DGS<sh_degree, antialiased>::World::operator=(other);
            features_tint = make_float3(1.0f, 1.0f, 1.0f);
            features_roughness = 0.5f;
            features_normal_res = make_float3(0.0f, 0.0f, 0.0f);
        }
        __device__ World& operator=(const typename _Base3DGS<sh_degree, antialiased>::World& other) {
            _Base3DGS<sh_degree, antialiased>::World::operator=(other);
            features_tint = make_float3(1.0f, 1.0f, 1.0f);
            features_roughness = 0.5f;
            features_normal_res = make_float3(0.0f, 0.0f, 0.0f);
            return *this;
        }

        static __device__ __forceinline__ World zero() {
            World w;
            // base zero() returns a temporary: bind through the const-ref
            // World::operator=(const base::World&), not a cast to a non-const
            // reference (nvcc: "expression must be an lvalue").
            w = _Base3DGS<sh_degree, antialiased>::World::zero();
            w.features_tint = make_float3(1.0f, 1.0f, 1.0f);
            w.features_roughness = 0.5f;
            w.features_normal_res = make_float3(0.0f, 0.0f, 0.0f);
            return w;
        }

        static __device__ __forceinline__ World zero(WorldBuffer &buffer, int64_t i) {
            World w = zero();
            // base zero(buffer, i) sets features_sh pointer; mirror it here.
            w.features_sh = buffer.features_sh(i);
            return w;
        }

        __device__ __forceinline__ void load(WorldBuffer &buffer, int64_t i) {
            // WorldBuffer is a layout-mirror of the base's (TensorArray<9> vs
            // TensorArray<6>, slots 0-5 identical); rebind through the base
            // reference type so the inherited loader can read the shared slots.
            _Base3DGS<sh_degree, antialiased>::World::load(
                reinterpret_cast<typename _Base3DGS<sh_degree, antialiased>::WorldBuffer&>(buffer), i);
            features_tint = buffer.features_tint(i);
            features_roughness = buffer.features_roughness(i);
            features_normal_res = buffer.features_normal_res(i);
        }

        __device__ __forceinline__ void atomicLoad(WorldBuffer &buffer, int64_t i) {
            _Base3DGS<sh_degree, antialiased>::World::atomicLoad(
                reinterpret_cast<typename _Base3DGS<sh_degree, antialiased>::WorldBuffer&>(buffer), i);
            if (&buffer.features_tint(0)) features_tint += buffer.features_tint(i);
            if (&buffer.features_roughness(0)) features_roughness += buffer.features_roughness(i);
            if (&buffer.features_normal_res(0)) features_normal_res += buffer.features_normal_res(i);
        }

        __device__ __forceinline__ void atomicStore(WorldBuffer &buffer, int64_t i) const {
            _Base3DGS<sh_degree, antialiased>::World::atomicStore(
                reinterpret_cast<typename _Base3DGS<sh_degree, antialiased>::WorldBuffer&>(buffer), i);
            if (&buffer.features_tint(0)) atomicAddFVec(&buffer.features_tint(i), features_tint);
            if (&buffer.features_roughness(0)) atomicAdd(&buffer.features_roughness(i), features_roughness);
            if (&buffer.features_normal_res(0)) atomicAddFVec(&buffer.features_normal_res(i), features_normal_res);
        }

        // The shading colour for this splat; fallback to base SH colour when
        // envmap is null. `R`/`t` are the world->camera transform of the view.
        template<int VALUE_BITS>
        __device__ __forceinline__ float3 eval_shading_color(
            const float3& mean, const float3x3& R, const float3& t,
            const float* __restrict__ envmap, int env_size
        ) {
            // Base SH colour (dc + high-order + bias).
            float3 sh_full = make_float3(0.0f);
            if constexpr (VALUE_BITS == 32) {
                if constexpr (sh_degree == 0) sh_full = SlangHarmonics::sh0_to_color
                    (mean, R, t, this->features_dc, (float3*)this->features_sh);
                else if constexpr (sh_degree == 1) sh_full = SlangHarmonics::sh1_to_color
                    (mean, R, t, this->features_dc, (float3*)this->features_sh);
                else if constexpr (sh_degree == 2) sh_full = SlangHarmonics::sh2_to_color
                    (mean, R, t, this->features_dc, (float3*)this->features_sh);
                else if constexpr (sh_degree == 3) sh_full = SlangHarmonics::sh3_to_color
                    (mean, R, t, this->features_dc, (float3*)this->features_sh);
                else if constexpr (sh_degree == 4) sh_full = SlangHarmonics::sh4_to_color
                    (mean, R, t, this->features_dc, (float3*)this->features_sh);
            }
            if (envmap == nullptr || env_size <= 0) return sh_full;

            // GaussianShader shading: c = c_d + s .* L_s + c_r, where c_d is the
            // SH-DC diffuse colour and c_r the high-order SH residual
            // (sh_full - c_d).
            const float3 c_d = make_float3(
                fmaxf(0.2820948f * this->features_dc.x + 0.5f, 0.0f),
                fmaxf(0.2820948f * this->features_dc.y + 0.5f, 0.0f),
                fmaxf(0.2820948f * this->features_dc.z + 0.5f, 0.0f));
            const float3 c_r = sh_full - c_d;

            // Shortest-axis normal (world) + residual (staged: zero for now).
            float3 n = ShaderEnv::shortest_axis_normal(this->scale, this->quat);
            n = n + this->features_normal_res;
            {
                const float inv_n = F32_rsqrt(SlangHarmonics::dot_0(n, n));
                n = n * inv_n;
            }

            // View direction splat -> camera, world space: -(mean + R^T t).
            // R is row-major: (R^T t)_i = sum_j R[j][i] * t[j].
            const float Rt_x = R.rows[0].x * t.x + R.rows[1].x * t.y + R.rows[2].x * t.z;
            const float Rt_y = R.rows[0].y * t.x + R.rows[1].y * t.y + R.rows[2].y * t.z;
            const float Rt_z = R.rows[0].z * t.x + R.rows[1].z * t.y + R.rows[2].z * t.z;
            float3 dir = mean + make_float3(Rt_x, Rt_y, Rt_z);
            const float inv = F32_rsqrt(SlangHarmonics::dot_0(dir, dir));
            float3 wo = -dir * inv;

            // Reflection direction.
            const float ndot = SlangHarmonics::dot_0(wo, n);
            float3 r = 2.0f * ndot * n - wo;
            {
                const float inv_r = F32_rsqrt(SlangHarmonics::dot_0(r, r));
                r = r * inv_r;
            }

            // Environment specular light.
            float3 Ls = ShaderEnv::sample_envmap(envmap, env_size, r,
                                                 this->features_roughness);
            return c_d + this->features_tint * Ls + c_r;
        }

        template<CameraModelType camera_model, CameraDistortionType distortion,
                 int VALUE_BITS = 32>
        inline __device__ void project(
            ProjCameraT<distortion> cam,
            typename _Base3DGS<sh_degree, antialiased>::Screen& screen, float4& aabb, float& sorting_depth, float& radius,
            uint8_t* sh_packed = nullptr,
            float2*  sh_bounds = nullptr,
            int64_t  sh_base   = 0,
            int64_t  sh_bounds_stride = 256,
            int64_t  sh_pair_pitch = 0,
            const float* __restrict__ envmap = nullptr,
            int env_size = 0
        ) {
            Slang3DGSProj<camera_model, distortion>::fwd_2d(
                antialiased,
                this->mean, this->quat, this->scale, this->opacity,
                cam.R, cam.t, cam.fx, cam.fy, cam.cx, cam.cy,
                cam.dist_coeffs.v,
                cam.width, cam.height,
                &aabb, &sorting_depth, &radius,
                &screen.xy, &screen.depth, &screen.conic, &screen.opac
            );
            if (aabb.z > aabb.x && aabb.w > aabb.y) {
                // Shading path is only wired for fp32 SH coefficients.
                if (envmap != nullptr && env_size > 0 && VALUE_BITS == 32) {
                    screen.rgb = eval_shading_color<VALUE_BITS>(
                        this->mean, cam.R, cam.t, envmap, env_size);
                } else if constexpr (VALUE_BITS == 32) {
                    if constexpr (sh_degree == 0) screen.rgb = SlangHarmonics::sh0_to_color
                        (this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh);
                    else if constexpr (sh_degree == 1) screen.rgb = SlangHarmonics::sh1_to_color
                        (this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh);
                    else if constexpr (sh_degree == 2) screen.rgb = SlangHarmonics::sh2_to_color
                        (this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh);
                    else if constexpr (sh_degree == 3) screen.rgb = SlangHarmonics::sh3_to_color
                        (this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh);
                    else if constexpr (sh_degree == 4) screen.rgb = SlangHarmonics::sh4_to_color
                        (this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh);
                } else {
                    // Quantized SH: not supported in shading mode; leave rgb 0
                    // (caller is expected to keep quantisation off).
                    screen.rgb = make_float3(0.0f);
                }
            }
        }

        // Backward: identical VJP chain to the base primitive (v_rgb flows into
        // dc / SH / geometry). The specular analytic gradients and the shading
        // attribute gradients are staged; their gradient slots are left null so
        // the atomic guards skip them.
        template<CameraModelType camera_model, CameraDistortionType distortion,
                 bool atomic=true, int VALUE_BITS = 32>
        inline __device__ void project_vjp(
            ProjCameraT<distortion> cam,
            typename _Base3DGS<sh_degree, antialiased>::Screen v_screen,
            typename _Base3DGS<sh_degree, antialiased>::World& v_world, float3x3 &v_R, float3 &v_t,
            uint8_t* sh_packed = nullptr,
            float2*  sh_bounds = nullptr,
            int64_t  sh_base   = 0,
            int64_t  sh_bounds_stride = 256,
            int64_t  sh_pair_pitch = 0,
            const float* __restrict__ envmap = nullptr,
            int env_size = 0
        ) {
            Slang3DGSProj<camera_model, distortion>::vjp_2d(
                antialiased,
                this->mean, this->quat, this->scale, this->opacity,
                cam.R, cam.t, cam.fx, cam.fy, cam.cx, cam.cy,
                cam.dist_coeffs.v,
                cam.width, cam.height,
                v_screen.xy, v_screen.depth, v_screen.conic, v_screen.opac,
                &v_world.mean, &v_world.quat, &v_world.scale, &v_world.opacity,
                &v_R, &v_t
            );
            #define _ARGS_F32 ( \
                this->mean, cam.R, cam.t, this->features_dc, (float3*)this->features_sh, \
                v_screen.rgb, &v_world.features_dc, (float3*)v_world.features_sh, \
                &v_world.mean, &v_R, &v_t \
            );
            if constexpr (atomic) {
                // Shading mode keeps VALUE_BITS == 32; quantized VJP variants
                // (q8/q16) take differently-typed coefficient buffers, so they
                // are never called here even if a VALUE_BITS<32 World is
                // instantiated by a downstream caller.
                if constexpr (sh_degree == 0) SlangHarmonics::sh0_to_color_vjp_atomic _ARGS_F32
                else if constexpr (sh_degree == 1) SlangHarmonics::sh1_to_color_vjp_atomic _ARGS_F32
                else if constexpr (sh_degree == 2) SlangHarmonics::sh2_to_color_vjp_atomic _ARGS_F32
                else if constexpr (sh_degree == 3) SlangHarmonics::sh3_to_color_vjp_atomic _ARGS_F32
                else if constexpr (sh_degree == 4) SlangHarmonics::sh4_to_color_vjp_atomic _ARGS_F32
            }
            else {
                if constexpr (sh_degree == 0) SlangHarmonics::sh0_to_color_vjp_inplace _ARGS_F32
                else if constexpr (sh_degree == 1) SlangHarmonics::sh1_to_color_vjp_inplace _ARGS_F32
                else if constexpr (sh_degree == 2) SlangHarmonics::sh2_to_color_vjp_inplace _ARGS_F32
                else if constexpr (sh_degree == 3) SlangHarmonics::sh3_to_color_vjp_inplace _ARGS_F32
                else if constexpr (sh_degree == 4) SlangHarmonics::sh4_to_color_vjp_inplace _ARGS_F32
            }
            #undef _ARGS_F32
        }
    };
#endif  // __CUDACC__

    struct Screen : public _Base3DGS<sh_degree, antialiased>::Screen {
        Screen() = default;
        __device__ Screen(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
        }
        __device__ Screen& operator=(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
            return *this;
        }
    };

    struct FragmentFwd : public _Base3DGS<sh_degree, antialiased>::Screen {
        FragmentFwd() = default;
        __device__ FragmentFwd(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
        }
        __device__ FragmentFwd& operator=(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
            return *this;
        }

        __device__ __forceinline__ void load(
            const WorldBuffer &wbuffer,
            const ScreenBuffer &sbuffer,
            int64_t wi, int64_t si
        ) {
            _Base3DGS<sh_degree, antialiased>::Screen::load(sbuffer, si);
        }

        __device__ __forceinline__ void store(
            WorldBuffer &wbuffer,
            ScreenBuffer &sbuffer,
            int64_t wi, int64_t si
        ) const {
            _Base3DGS<sh_degree, antialiased>::Screen::store(sbuffer, si);
        }

        __device__ __forceinline__ void atomicStore(
            WorldBuffer &wbuffer,
            ScreenBuffer &sbuffer,
            int64_t wi, int64_t si
        ) const {
            _Base3DGS<sh_degree, antialiased>::Screen::atomicStore(sbuffer, si);
        }

        __device__ __forceinline__ float evaluate_alpha(
            float px, float py
        ) const {
            float2 delta = {this->xy.x - px, this->xy.y - py};
            float sigma = 0.5f * (this->conic.x * delta.x * delta.x +
                                    this->conic.z * delta.y * delta.y) +
                            this->conic.y * delta.x * delta.y;
            float vis = __expf(-sigma);
            float alpha = min(0.999f, this->opac * vis);
            return sigma < 0.f ? 0.f : alpha;
        }

        __device__ __forceinline__ void evaluate_alpha_vjp(
            float px, float py, float v_alpha,
            FragmentFwd& v_frag
        ) const {
            float2 delta = {this->xy.x - px, this->xy.y - py};
            float sigma = 0.5f * (this->conic.x * delta.x * delta.x +
                                    this->conic.z * delta.y * delta.y) +
                            this->conic.y * delta.x * delta.y;
            float vis = __expf(-sigma);
            float alpha = min(0.999f, this->opac * vis);

            if (sigma >= 0.f && this->opac * vis <= 0.999f) {
                const float v_sigma = -this->opac * vis * v_alpha;
                v_frag.conic += float3{
                    0.5f * v_sigma * delta.x * delta.x,
                    v_sigma * delta.x * delta.y,
                    0.5f * v_sigma * delta.y * delta.y
                };
                v_frag.xy += float2{
                    v_sigma * (this->conic.x * delta.x + this->conic.y * delta.y),
                    v_sigma * (this->conic.y * delta.x + this->conic.z * delta.y)
                };
                v_frag.opac += vis * v_alpha;
            }
        }

        __device__ __forceinline__ RenderOutput evaluate_color(
            float px, float py
        ) const {
            return { this->rgb, this->depth, make_float3(0.0f) };
        }

        __device__ __forceinline__ void evaluate_color_vjp(
            float px, float py, RenderOutput v_render,
            FragmentFwd& v_frag
        ) const {
            v_frag.rgb += v_render.rgb;
            v_frag.depth += v_render.depth;
        }

        __device__ __forceinline__ void store_local(
            ScreenBuffer &sbuffer,
            int64_t si
        ) const {
            _Base3DGS<sh_degree, antialiased>::Screen::store_local(sbuffer, si);
        }
    };

    struct FragmentBwd : public FragmentFwd {
        FragmentBwd() = default;
        __device__ FragmentBwd(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
        }
        __device__ FragmentBwd& operator=(const typename _Base3DGS<sh_degree, antialiased>::Screen& other) {
            _Base3DGS<sh_degree, antialiased>::Screen::operator=(other);
            return *this;
        }

        static __device__ __forceinline__ FragmentBwd zero(const FragmentBwd& bwd) {
            return _Base3DGS<sh_degree, antialiased>::Screen::zero();
        }
    };
};

template<int sh_degree>
using Shader3DGS = _Base3DGSShader<sh_degree, false>;
