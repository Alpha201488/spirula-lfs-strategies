#pragma once

// The 3D transitions (Dust ... Ripple): where each point, splat or vertex of a
// model goes, how opaque it is and how large, part way through the change.
// Two copies of one set of formulas -- C++ for splats, rewritten on the host
// per frame, and GLSL for points and meshes, in their vertex shaders -- kept
// side by side here so they stay one set. docs/notes/render-video.md.

#include <cmath>
#include <cstdint>

namespace gui::render {

// Quantiles every 1/32 of the elements, least to most.
constexpr int kFxQuantiles = 33;

// The frame a transition moves in -- a centre, an orthonormal (up, e1, e2),
// the 90th-percentile distance -- and the quantiles, from c, of the height
// along up, the distance along e1 and from the up axis, which it orders by.
struct FxGeo {
    float c[3] = {0, 0, 0};
    float up[3] = {0, 0, 1}, e1[3] = {1, 0, 0}, e2[3] = {0, 1, 0};
    float radius = 1.0f;
    float qh[kFxQuantiles], qa[kFxQuantiles], qr[kFxQuantiles];
    FxGeo() {
        for (int i = 0; i < kFxQuantiles; i++) {
            const float f = (float)i / (kFxQuantiles - 1);
            qh[i] = qa[i] = 2.0f * f - 1.0f;
            qr[i] = f;
        }
    }
};

// Two uniform numbers in [0, 1) of an element's own.
inline void fx_random(uint32_t i, float& r1, float& r2) {
    auto h = [](uint32_t x) {
        x = x * 747796405u + 2891336453u;
        x = ((x >> ((x >> 28u) + 4u)) ^ x) * 277803737u;
        return (float)((x >> 22u) ^ x) * (1.0f / 4294967296.0f);
    };
    r1 = h(i);
    r2 = h(i ^ 0x9E3779B9u);
}

// The share of elements below `v`, from their quantiles `q`.
inline float fx_cdf(const float* q, float v) {
    constexpr int n = kFxQuantiles - 1;
    if (!(v > q[0])) return 0.0f;
    if (v >= q[n]) return 1.0f;
    int lo = 0, hi = n;
    while (hi - lo > 1) {
        const int m = (lo + hi) / 2;
        if (v < q[m]) hi = m;
        else lo = m;
    }
    const float span = q[hi] - q[lo];
    return ((float)lo + (span > 0.0f ? (v - q[lo]) / span : 0.5f)) / (float)n;
}

// Where a share `f` of the elements lies, the other way.
inline float fx_quantile(const float* q, float f) {
    constexpr int n = kFxQuantiles - 1;
    const float x = f <= 0.0f ? 0.0f : f >= 1.0f ? (float)n : f * (float)n;
    const int i = x >= (float)n ? n - 1 : (int)x;
    return q[i] + (q[i + 1] - q[i]) * (x - (float)i);
}

namespace fxd {
inline float sat(float x) { return x < 0.0f ? 0.0f : x > 1.0f ? 1.0f : x; }
inline float smooth(float a, float b, float x) {
    const float t = sat((x - a) / (b - a));
    return t * t * (3.0f - 2.0f * t);
}
// Through a window `w` of the change that opens at `s0` of the rest.
inline float local(float t, float s0, float w) { return sat((t - s0 * (1.0f - w)) / w); }
inline float phase(float t, float a, float b) { return sat((t - a) / (b - a)); }
}  // namespace fxd

// A transition with nothing on its other side has the whole change to
// itself: arriving it starts where its half would, leaving it ends where
// its half would. `t` of the change into the `t` fx_apply takes.
inline float fx_solo_time(int kind, bool in, float t, const float prm[2]) {
    float a = 0.0f, b = 1.0f;
    switch (kind) {
        case 8: a = 0.25f; b = 0.8f; break;
        case 9: a = 0.3f; b = 0.7f; break;
        case 10: a = 0.35f; b = 0.65f; break;
        case 11: a = 0.1f; b = 0.6f; break;
        case 13: {
            // The front a width short of the nearest, past the furthest.
            const float w = std::fmax(prm[1], 0.02f);
            a = w / (1.0f + 4.0f * w);
            b = (1.0f + 3.0f * w) / (1.0f + 4.0f * w);
            break;
        }
        default: break;
    }
    return in ? a + t * (1.0f - a) : t * b;
}

// `kind` is a Transition; `in` the model arriving. `d` is the displacement,
// in the positions' units.
inline void fx_apply(int kind, bool in, float t, const float prm[2], const FxGeo& g,
                     const float pos[3], float r1, float r2, float d[3], float& alpha,
                     float& size) {
    using namespace fxd;
    constexpr float kTau = 6.2831853f;
    d[0] = d[1] = d[2] = 0.0f;
    alpha = 1.0f;
    size = 1.0f;
    const float q[3] = {pos[0] - g.c[0], pos[1] - g.c[1], pos[2] - g.c[2]};
    auto dot = [&](const float* v) { return q[0] * v[0] + q[1] * v[1] + q[2] * v[2]; };
    const float h = dot(g.up), x1 = dot(g.e1), x2 = dot(g.e2);
    const float R = g.radius;
    // A direction of the element's own, uniform on the sphere.
    const float za = 2.0f * r1 - 1.0f, sa = std::sqrt(std::fmax(0.0f, 1.0f - za * za));
    const float ca = std::cos(kTau * r2) * sa, cb = std::sin(kTau * r2) * sa;
    float rv[3];
    for (int k = 0; k < 3; k++) rv[k] = ca * g.e1[k] + cb * g.e2[k] + za * g.up[k];
    auto add = [&](const float* v, float s) {
        for (int k = 0; k < 3; k++) d[k] += v[k] * s;
    };
    switch (kind) {
        case 8: {                                   // Dust: fall, rise, blow away
            const int mode = (int)(prm[0] + 0.5f);
            const float order = mode == 2 ? fx_cdf(g.qa, x1)
                                : mode == 1 ? fx_cdf(g.qh, h) : 1.0f - fx_cdf(g.qh, h);
            const float s0 = order * 0.85f + r1 * 0.15f;
            float dir[3];
            for (int k = 0; k < 3; k++)
                dir[k] = mode == 0 ? -g.up[k] : mode == 1 ? g.up[k] : g.e1[k] + 0.3f * g.up[k];
            if (!in) {
                const float tau = local(phase(t, 0.0f, 0.8f), s0, 0.35f);
                add(dir, 1.3f * R * tau * tau);
                add(rv, prm[1] * 0.45f * R * tau);
                alpha = 1.0f - smooth(0.3f, 1.0f, tau);
                size = 1.0f - 0.7f * tau;
            } else {
                const float tau = local(phase(t, 0.25f, 1.0f), s0, 0.4f), u = 1.0f - tau;
                add(dir, -0.8f * R * u * u);
                add(rv, prm[1] * 0.45f * R * u);
                alpha = smooth(0.0f, 0.6f, tau);
                size = 0.3f + 0.7f * tau;
            }
            break;
        }
        case 9: {                                   // Spiral: turns, spread
            const float hn = fx_cdf(g.qh, h);
            float tau, u, turn;
            if (in) {
                tau = local(phase(t, 0.3f, 1.0f), hn * 0.6f + r1 * 0.25f, 0.45f);
                u = (1.0f - tau) * (1.0f - tau);
                turn = prm[0] * kTau * u;
                alpha = smooth(0.0f, 0.35f, tau);
                size = 0.4f + 0.6f * tau;
            } else {
                tau = local(phase(t, 0.0f, 0.7f), (1.0f - hn) * 0.6f + r1 * 0.25f, 0.45f);
                u = tau * tau;
                turn = -0.7f * prm[0] * kTau * u;
                alpha = 1.0f - smooth(0.4f, 1.0f, tau);
                size = 1.0f - 0.6f * tau;
            }
            const float k = 1.0f + prm[1] * u, cs = std::cos(turn), sn = std::sin(turn);
            add(g.e1, (x1 * cs - x2 * sn) * k - x1);
            add(g.e2, (x1 * sn + x2 * cs) * k - x2);
            add(g.up, (in ? 0.6f : 0.8f) * R * u);
            break;
        }
        case 10: {                                  // Scatter: distance, randomness
            const float qn = std::sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2]);
            float dir[3], n = 0.0f;
            for (int k = 0; k < 3; k++) {
                dir[k] = (qn > 1e-6f * R ? q[k] / qn : rv[k]) + rv[k] * prm[1] * 0.8f;
                n += dir[k] * dir[k];
            }
            n = 1.0f / std::sqrt(std::fmax(n, 1e-12f));
            for (float& v : dir) v *= n;
            const float w = 1.0f - 0.6f * prm[1];
            if (!in) {
                const float tau = local(phase(t, 0.0f, 0.65f), r1, w);
                add(dir, R * prm[0] * (1.5f * tau * tau + 0.2f * tau));
                alpha = 1.0f - smooth(0.3f, 1.0f, tau);
                size = 1.0f - 0.5f * tau;
            } else {
                const float tau = local(phase(t, 0.35f, 1.0f), r2, w), u = 1.0f - tau;
                add(dir, 1.5f * R * prm[0] * u * u);
                alpha = smooth(0.0f, 0.5f, tau);
                size = 0.5f + 0.5f * tau;
            }
            break;
        }
        case 11: {                                  // Rain: height, stagger
            if (in) {
                const float tau = local(phase(t, 0.1f, 1.0f), r1, 1.0f - 0.8f * prm[1]);
                // Down to rest by 80%, then one small hop.
                const float v = tau < 0.8f ? 1.0f - tau / 0.8f : (tau - 0.8f) / 0.2f;
                const float above = tau < 0.8f ? v * v : 0.06f * std::sin(3.14159265f * v) * (1.0f - v);
                add(g.up, R * prm[0] * above);
                alpha = smooth(0.0f, 0.12f, tau);
            } else {
                const float tau = local(phase(t, 0.0f, 0.6f), r2, 0.35f);
                add(g.up, -0.08f * R * tau);
                alpha = 1.0f - tau;
                size = 1.0f - 0.4f * tau;
            }
            break;
        }
        case 12: {                                  // Dissolve: sparkle
            const float tau = local(t, in ? r2 : r1, 0.15f);
            const float pop = prm[0] * 1.2f * std::sin(3.14159265f * tau);
            alpha = in ? tau : 1.0f - tau;
            size = (in ? 0.3f + 0.7f * tau : 1.0f) + pop;
            break;
        }
        case 13: {                                  // Ripple: height, width
            // The front runs through the elements' quantiles, clear of them
            // at either end.
            const float rn = fx_cdf(g.qr, std::sqrt(x1 * x1 + x2 * x2));
            const float w = std::fmax(prm[1], 0.02f);
            const float front = -2.0f * w + t * (1.0f + 4.0f * w);
            const float phi = (front - rn) / w;
            add(g.up, R * prm[0] * std::exp(-2.5f * phi * phi));
            const float passed = smooth(-0.15f, 0.15f, phi);
            alpha = in ? passed : 1.0f - passed;
            break;
        }
        default:
            break;
    }
}

// The same, for the vertex shaders: uniforms u_fx* carry the kind, the side,
// the time, the settings and an FxGeo in the model's normalized frame.
inline const char* fx_glsl() {
    return R"(
uniform int u_fx;
uniform int u_fx_in;
uniform float u_fx_t;
uniform vec2 u_fx_p;
uniform vec3 u_fx_c;
uniform vec3 u_fx_up;
uniform vec3 u_fx_e1;
uniform vec3 u_fx_e2;
uniform float u_fx_radius;
uniform float u_fx_qh[33];
uniform float u_fx_qa[33];
uniform float u_fx_qr[33];
float fx_sat(float x) { return clamp(x, 0.0, 1.0); }
float fx_smooth(float a, float b, float x) { return smoothstep(a, b, x); }
float fx_local(float t, float s0, float w) { return fx_sat((t - s0 * (1.0 - w)) / w); }
float fx_phase(float t, float a, float b) { return fx_sat((t - a) / (b - a)); }
float fx_hashu(uint x) {
    x = x * 747796405u + 2891336453u;
    x = ((x >> ((x >> 28u) + 4u)) ^ x) * 277803737u;
    return float((x >> 22u) ^ x) * (1.0 / 4294967296.0);
}
// fx_cdf, once per table: GLSL 1.50 passes no uniform array by reference.
float fx_cdf_h(float v) {
    if (!(v > u_fx_qh[0])) return 0.0;
    if (v >= u_fx_qh[32]) return 1.0;
    int lo = 0, hi = 32;
    for (int k = 0; k < 6 && hi - lo > 1; k++) {
        int m = (lo + hi) / 2;
        if (v < u_fx_qh[m]) hi = m; else lo = m;
    }
    float span = u_fx_qh[hi] - u_fx_qh[lo];
    return (float(lo) + (span > 0.0 ? (v - u_fx_qh[lo]) / span : 0.5)) / 32.0;
}
float fx_cdf_a(float v) {
    if (!(v > u_fx_qa[0])) return 0.0;
    if (v >= u_fx_qa[32]) return 1.0;
    int lo = 0, hi = 32;
    for (int k = 0; k < 6 && hi - lo > 1; k++) {
        int m = (lo + hi) / 2;
        if (v < u_fx_qa[m]) hi = m; else lo = m;
    }
    float span = u_fx_qa[hi] - u_fx_qa[lo];
    return (float(lo) + (span > 0.0 ? (v - u_fx_qa[lo]) / span : 0.5)) / 32.0;
}
float fx_cdf_r(float v) {
    if (!(v > u_fx_qr[0])) return 0.0;
    if (v >= u_fx_qr[32]) return 1.0;
    int lo = 0, hi = 32;
    for (int k = 0; k < 6 && hi - lo > 1; k++) {
        int m = (lo + hi) / 2;
        if (v < u_fx_qr[m]) hi = m; else lo = m;
    }
    float span = u_fx_qr[hi] - u_fx_qr[lo];
    return (float(lo) + (span > 0.0 ? (v - u_fx_qr[lo]) / span : 0.5)) / 32.0;
}
float fx_h3(vec3 c) { return fract(sin(dot(c, vec3(127.1, 311.7, 74.7))) * 43758.5453); }
// Smooth over space, for a mesh, whose shared vertices must move together.
float fx_noise(vec3 x) {
    vec3 i = floor(x), f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(fx_h3(i), fx_h3(i + vec3(1, 0, 0)), f.x),
                   mix(fx_h3(i + vec3(0, 1, 0)), fx_h3(i + vec3(1, 1, 0)), f.x), f.y),
               mix(mix(fx_h3(i + vec3(0, 0, 1)), fx_h3(i + vec3(1, 0, 1)), f.x),
                   mix(fx_h3(i + vec3(0, 1, 1)), fx_h3(i + vec3(1, 1, 1)), f.x), f.y), f.z);
}
void fx_apply(vec3 pos, float r1, float r2, out vec3 d, out float alpha, out float size) {
    const float kTau = 6.2831853;
    d = vec3(0.0);
    alpha = 1.0;
    size = 1.0;
    bool inn = u_fx_in == 1;
    float t = u_fx_t;
    vec2 prm = u_fx_p;
    vec3 q = pos - u_fx_c;
    float h = dot(q, u_fx_up), x1 = dot(q, u_fx_e1), x2 = dot(q, u_fx_e2);
    float R = u_fx_radius;
    float za = 2.0 * r1 - 1.0, sa = sqrt(max(0.0, 1.0 - za * za));
    vec3 rv = cos(kTau * r2) * sa * u_fx_e1 + sin(kTau * r2) * sa * u_fx_e2 + za * u_fx_up;
    if (u_fx == 8) {
        int mode = int(prm.x + 0.5);
        float order = mode == 2 ? fx_cdf_a(x1) : mode == 1 ? fx_cdf_h(h) : 1.0 - fx_cdf_h(h);
        float s0 = order * 0.85 + r1 * 0.15;
        vec3 dir = mode == 0 ? -u_fx_up : mode == 1 ? u_fx_up : u_fx_e1 + 0.3 * u_fx_up;
        if (!inn) {
            float tau = fx_local(fx_phase(t, 0.0, 0.8), s0, 0.35);
            d = dir * (1.3 * R * tau * tau) + rv * (prm.y * 0.45 * R * tau);
            alpha = 1.0 - fx_smooth(0.3, 1.0, tau);
            size = 1.0 - 0.7 * tau;
        } else {
            float tau = fx_local(fx_phase(t, 0.25, 1.0), s0, 0.4), u = 1.0 - tau;
            d = dir * (-0.8 * R * u * u) + rv * (prm.y * 0.45 * R * u);
            alpha = fx_smooth(0.0, 0.6, tau);
            size = 0.3 + 0.7 * tau;
        }
    } else if (u_fx == 9) {
        float hn = fx_cdf_h(h);
        float tau, u, turn;
        if (inn) {
            tau = fx_local(fx_phase(t, 0.3, 1.0), hn * 0.6 + r1 * 0.25, 0.45);
            u = (1.0 - tau) * (1.0 - tau);
            turn = prm.x * kTau * u;
            alpha = fx_smooth(0.0, 0.35, tau);
            size = 0.4 + 0.6 * tau;
        } else {
            tau = fx_local(fx_phase(t, 0.0, 0.7), (1.0 - hn) * 0.6 + r1 * 0.25, 0.45);
            u = tau * tau;
            turn = -0.7 * prm.x * kTau * u;
            alpha = 1.0 - fx_smooth(0.4, 1.0, tau);
            size = 1.0 - 0.6 * tau;
        }
        float k = 1.0 + prm.y * u, cs = cos(turn), sn = sin(turn);
        d = u_fx_e1 * ((x1 * cs - x2 * sn) * k - x1) + u_fx_e2 * ((x1 * sn + x2 * cs) * k - x2) +
            u_fx_up * ((inn ? 0.6 : 0.8) * R * u);
    } else if (u_fx == 10) {
        float qn = length(q);
        vec3 dir = normalize((qn > 1e-6 * R ? q / qn : rv) + rv * prm.y * 0.8);
        float w = 1.0 - 0.6 * prm.y;
        if (!inn) {
            float tau = fx_local(fx_phase(t, 0.0, 0.65), r1, w);
            d = dir * (R * prm.x * (1.5 * tau * tau + 0.2 * tau));
            alpha = 1.0 - fx_smooth(0.3, 1.0, tau);
            size = 1.0 - 0.5 * tau;
        } else {
            float tau = fx_local(fx_phase(t, 0.35, 1.0), r2, w), u = 1.0 - tau;
            d = dir * (1.5 * R * prm.x * u * u);
            alpha = fx_smooth(0.0, 0.5, tau);
            size = 0.5 + 0.5 * tau;
        }
    } else if (u_fx == 11) {
        if (inn) {
            float tau = fx_local(fx_phase(t, 0.1, 1.0), r1, 1.0 - 0.8 * prm.y);
            float v = tau < 0.8 ? 1.0 - tau / 0.8 : (tau - 0.8) / 0.2;
            float above = tau < 0.8 ? v * v : 0.06 * sin(3.14159265 * v) * (1.0 - v);
            d = u_fx_up * (R * prm.x * above);
            alpha = fx_smooth(0.0, 0.12, tau);
        } else {
            float tau = fx_local(fx_phase(t, 0.0, 0.6), r2, 0.35);
            d = u_fx_up * (-0.08 * R * tau);
            alpha = 1.0 - tau;
            size = 1.0 - 0.4 * tau;
        }
    } else if (u_fx == 12) {
        float tau = fx_local(t, inn ? r2 : r1, 0.15);
        float pop = prm.x * 1.2 * sin(3.14159265 * tau);
        alpha = inn ? tau : 1.0 - tau;
        size = (inn ? 0.3 + 0.7 * tau : 1.0) + pop;
    } else if (u_fx == 13) {
        float rn = fx_cdf_r(sqrt(x1 * x1 + x2 * x2));
        float w = max(prm.y, 0.02);
        float front = -2.0 * w + t * (1.0 + 4.0 * w);
        float phi = (front - rn) / w;
        d = u_fx_up * (R * prm.x * exp(-2.5 * phi * phi));
        float passed = fx_smooth(-0.15, 0.15, phi);
        alpha = inn ? passed : 1.0 - passed;
    }
}
)";
}

}  // namespace gui::render
