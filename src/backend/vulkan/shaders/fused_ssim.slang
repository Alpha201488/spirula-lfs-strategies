// Fused SSIM and S-CIELAB forward+backward (Vulkan backend), mirroring
// kernels/loss/FusedSSIM.cu's memory_efficient_ssim_backward_kernel<true> and
// fused_scielab_kernel.
//
// Both run logical tiles as flat 256-wide workgroups (VUID-02757: workgroup X
// must be a multiple of the pinned 32-wide subgroup). Every per-pixel output is
// a pure function of the input, so the tile edge only regroups the atomic
// scalar (loose parity channel). Masked pixels -- and, with `sat` positive,
// ones both images clip above -- drop out of the window sums, divided back out
// through the window's coverage of what is kept.

#include "int8_compat.slang"
#include "atomic_float.slang"
#include "rgb_format.slang"

// The double halo makes the tile edge expensive: 16 loads 36x36 per 256
// pixels, 24 (the CUDA block) 44x44 per 576. 24 needs 47712 B of groupshared,
// so the 32 KB floor keeps llvmpipe at 16 -- PerPixelLoss.cpp picks.
[SpecializationConstant]
const int kSsimTile = 16;
// img1's format | img2's << 2 (core/PixelFormat.h), fixed per pipeline: read
// per load from the params instead, the formats cost ssim_bwd_inplace ~55%.
[SpecializationConstant]
const int kSsimFmts = 0;

static const int BX = kSsimTile;
static const int BY = kSsimTile;
static const int HALO = 5;
static const int SX = BX + 2 * HALO;    // 26
static const int SY = BY + 2 * HALO;    // 26
static const int CX = BX;               // 16
static const int CY = SY;               // 26
static const int LX = BX + 4 * HALO;    // 36
static const int LY = BY + 4 * HALO;    // 36

static const float kGauss[HALO + 1] = {
    0.001028380123898387f, 0.0075987582094967365f, 0.036000773310661316f,
    0.10936068743467331f,  0.21300552785396576f,   0.26601171493530273f,
};

static const float kC1 = 0.01f * 0.01f;
static const float kC2 = 0.03f * 0.03f;

// flags bits
static const uint kSsimHasMask = 1u << 0;
static const uint kSsimHasVal = 1u << 1;
static const uint kSsimWriteGrad = 1u << 2;
static const uint kSsimHasLossMap = 1u << 3;
static const uint kSsimHasCov = 1u << 4;
// The images' core/PixelFormat.h formats, two bits each.

struct SsimParams {
    uint* img1;       // [B,H,W,3], read as the flags' formats
    uint* img2;       // [B,H,W,3]
    uint* masks;      // [Bm,Hm,Wm] bool bytes
    float* mask_w;    // [B,H,W] gaussian window coverage, or fallback
    float* dL_dimg1;  // [B,H,W,3], accumulated (+=)
    float* ssim_val;  // scalar accumulator
    float* loss_map;  // [B,H,W,1], accumulated (+=)
    int B, H, W;
    int Bm, Hm, Wm;
    float dL_dmap;
    float map_weight;
    float sat;        // clip threshold, or <= 0 to disable
    int mode;         // SsimLossMapMode: 0 skip, 1 LCS, 2 CS, 3 structure
    uint flags;
};

[ForceInline]
float _fs_pix(uint* img, uint fmt, int b, int y, int x, int ci, int H, int W) {
    if (uint(x) >= uint(W) || uint(y) >= uint(H)) return 0.0f;
    return rgb_load1(img, (((b * H) + y) * W + x) * 3 + ci, fmt);
}

// Nearest-sample the mask at ITS resolution, as core/Interpolation.cuh's
// nearest_sample_b does: a mask is stored at the file's size, which is not the
// render's whenever the run is downscaled.
[ForceInline]
bool _fs_mask_at(uint* masks, int Bm, int Hm, int Wm, int H, int W,
                 int b, int y, int x) {
    if (uint(b) >= uint(Bm)) return true;
    if (uint(x) >= uint(W) || uint(y) >= uint(H)) return true;
    int xs = x, ys = y;
    if (Wm != W || Hm != H) {
        float u = (float(x) + 0.5f) * float(Wm) / float(W) - 0.5f;
        float v = (float(y) + 0.5f) * float(Hm) / float(H) - 0.5f;
        xs = max(0, min(Wm - 1, int(floor(u + 0.5f))));
        ys = max(0, min(Hm - 1, int(floor(v + 0.5f))));
    }
    uint idx = (uint(b) * uint(Hm) + uint(ys)) * uint(Wm) + uint(xs);
    return u8_load(masks, idx) != 0u;
}

// A pixel both images clip above carries no recoverable error, so it drops out
// of the window sums the way a masked one does. Out-of-image taps read
// unclipped, matching _fs_mask_at.
[ForceInline]
bool _fs_unclipped(uint* img1, uint* img2, uint fmts, float sat, int H, int W,
                   int b, int y, int x) {
    if (sat <= 0.0f) return true;
    if (uint(x) >= uint(W) || uint(y) >= uint(H)) return true;
    int pix = ((b * H) + y) * W + x;
    float3 a = rgb_load3(img1, pix, fmts & 3u);
    float3 c = rgb_load3(img2, pix, (fmts >> 2) & 3u);
    return min(min(a.x, a.y), a.z) <= sat || min(min(c.x, c.y), c.z) <= sat;
}

[ForceInline]
bool _fs_mask(SsimParams p, int b, int y, int x) {
    if ((p.flags & kSsimHasMask) != 0 &&
            !_fs_mask_at(p.masks, p.Bm, p.Hm, p.Wm, p.H, p.W, b, y, x))
        return false;
    return _fs_unclipped(p.img1, p.img2, uint(kSsimFmts), p.sat, p.H, p.W, b, y, x);
}


// Window coverage of the mask: gaussian weight each 11x11 window puts on an
// unmasked pixel. Taps read out-of-range as unmasked (matching _fs_mask), and
// a row off the image is entirely out of range, hence kGaussSum.
static const float kGaussSum = 0.9999999f;

struct SsimCovParams {
    uint* masks;
    uint* img1;
    uint* img2;
    float* out;
    int B, H, W;
    int Bm, Hm, Wm;
    float sat;
    uint fmts;    // img1's format | img2's << 2
};

// Bm is 0 when there is no mask buffer, which _fs_mask_at reads as unmasked.
[ForceInline]
float _fs_cov_mask(SsimCovParams p, int b, int y, int x) {
    bool keep = _fs_mask_at(p.masks, p.Bm, p.Hm, p.Wm, p.H, p.W, b, y, x) &&
                _fs_unclipped(p.img1, p.img2, p.fmts, p.sat, p.H, p.W, b, y, x);
    return keep ? 1.0f : 0.0f;
}

// One pass: the mask tile and its halo go through groupshared memory, so the
// horizontal sums never reach global memory.
static const int COV_T = 16;
static const int COV_S = COV_T + 2 * HALO;
groupshared float _fs_cov_m[COV_S * COV_S];
groupshared float _fs_cov_x[COV_S * COV_T];

[shader("compute")]
[numthreads(256, 1, 1)]
void ssim_mask_cov(uint3 wg: SV_GroupID, uint tid: SV_GroupThreadID,
                   uniform SsimCovParams p) {
    int b = int(wg.z);
    int x0 = int(wg.x) * COV_T - HALO;
    int y0 = int(wg.y) * COV_T - HALO;
    for (int i = int(tid); i < COV_S * COV_S; i += 256)
        _fs_cov_m[i] = _fs_cov_mask(p, b, y0 + i / COV_S, x0 + i % COV_S);
    GroupMemoryBarrierWithGroupSync();
    for (int i = int(tid); i < COV_S * COV_T; i += 256) {
        int ly = i / COV_T, lx = i % COV_T + HALO;
        float acc = 0.0f;
        [ForceUnroll]
        for (int d = 1; d <= HALO; d++)
            acc += kGauss[HALO - d] * (_fs_cov_m[ly * COV_S + lx - d] +
                                       _fs_cov_m[ly * COV_S + lx + d]);
        acc += kGauss[HALO] * _fs_cov_m[ly * COV_S + lx];
        _fs_cov_x[i] = acc;
    }
    GroupMemoryBarrierWithGroupSync();
    int tx = int(tid % 16u), ty = int(tid / 16u);
    int x = int(wg.x) * COV_T + tx;
    int y = int(wg.y) * COV_T + ty;
    if (x >= p.W || y >= p.H) return;
    float acc = 0.0f;
    [ForceUnroll]
    for (int d = 1; d <= HALO; d++) {
        int lo = y - d, hi = y + d;
        float a = uint(lo) < uint(p.H) ? _fs_cov_x[(ty + HALO - d) * COV_T + tx] : kGaussSum;
        float c = uint(hi) < uint(p.H) ? _fs_cov_x[(ty + HALO + d) * COV_T + tx] : kGaussSum;
        acc += kGauss[HALO - d] * (a + c);
    }
    acc += kGauss[HALO] * _fs_cov_x[(ty + HALO) * COV_T + tx];
    p.out[(b * p.H + y) * p.W + x] = acc;
}

// Shared buffers reused across stages exactly like the CUDA kernel's
// _shared_buffer1/2 overlays.
groupshared float _fs_sb1[LY * LX * 2];             // sTile | sData (2592/2028)
groupshared float _fs_sb2[LY * SX * 5];             // xconv | sScratch (4680/1248)
groupshared float _fs_ssim[BY * BX];                // per-pixel map, then reduce

#define sTile(i, j, k) _fs_sb1[((i) * LX + (j)) * 2 + (k)]
#define xconv(i, j, k) _fs_sb2[((i) * SX + (j)) * 5 + (k)]
#define sData(k, i, j) _fs_sb1[((k) * SY + (i)) * SX + (j)]
#define sScratch(i, j, k) _fs_sb2[((i) * CX + (j)) * 3 + (k)]

[shader("compute")]
[numthreads(256, 1, 1)]
void ssim_bwd_inplace(uint3 wg: SV_GroupID, uint tid: SV_GroupThreadID,
                      uniform SsimParams p) {
    const int bIdx = int(wg.z);
    const int startY = int(wg.y) * BY;
    const int startX = int(wg.x) * BX;
    const int num_pix = p.H * p.W;

    const bool lm_active = p.mode != 0 && (p.flags & kSsimHasLossMap) != 0;
    const bool has_val = (p.flags & kSsimHasVal) != 0;
    const uint fmt1 = uint(kSsimFmts) & 3u;
    const uint fmt2 = (uint(kSsimFmts) >> 2) & 3u;

    const float grad =
        p.dL_dmap / (3.0f * float(p.B) * float(p.W) * float(p.H));

    float ssim_val = 0.0f;

    for (int ci = 0; ci < 3; ci++) {
        if (ci != 0) GroupMemoryBarrierWithGroupSync();

        // (1) Load img1/img2 tile + double halo.
        for (int s = 0; s < (LX * LY + 255) / 256; s++) {
            int t = s * 256 + int(tid);
            if (t < LX * LY) {
                int ly = t / LX;
                int lx = t % LX;
                int gy = startY + ly - 2 * HALO;
                int gx = startX + lx - 2 * HALO;
                float X = _fs_pix(p.img1, fmt1, bIdx, gy, gx, ci, p.H, p.W);
                float Y = _fs_pix(p.img2, fmt2, bIdx, gy, gx, ci, p.H, p.W);
                if (!_fs_mask(p, bIdx, gy, gx)) { X = 0.0f; Y = 0.0f; }
                sTile(ly, lx, 0) = X;
                sTile(ly, lx, 1) = Y;
            }
        }
        GroupMemoryBarrierWithGroupSync();

        // (2) Horizontal 11-tap convolution of the 5 moment sums.
        for (int l = int(tid); l < SX * LY; l += 256) {
            int lx = l % SX + HALO;
            int ly = l / SX;
            float sumX = 0.0f, sumX2 = 0.0f, sumY = 0.0f, sumY2 = 0.0f,
                  sumXY = 0.0f;
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                float w = kGauss[HALO - d];
                float Xl = sTile(ly, lx - d, 0);
                float Yl = sTile(ly, lx - d, 1);
                float Xr = sTile(ly, lx + d, 0);
                float Yr = sTile(ly, lx + d, 1);
                sumX += (Xl + Xr) * w;
                sumX2 += ((Xl * Xl) + (Xr * Xr)) * w;
                sumY += (Yl + Yr) * w;
                sumY2 += ((Yl * Yl) + (Yr * Yr)) * w;
                sumXY += ((Xl * Yl) + (Xr * Yr)) * w;
            }
            {
                float cX = sTile(ly, lx, 0);
                float cY = sTile(ly, lx, 1);
                float wc = kGauss[HALO];
                sumX += cX * wc;
                sumX2 += (cX * cX) * wc;
                sumY += cY * wc;
                sumY2 += (cY * cY) * wc;
                sumXY += (cX * cY) * wc;
            }
            xconv(ly, lx - HALO, 0) = sumX;
            xconv(ly, lx - HALO, 1) = sumX2;
            xconv(ly, lx - HALO, 2) = sumY;
            xconv(ly, lx - HALO, 3) = sumY2;
            xconv(ly, lx - HALO, 4) = sumXY;
        }
        GroupMemoryBarrierWithGroupSync();

        // (3) Vertical pass -> SSIM value + partial derivatives.
        for (int l = int(tid); l < SX * SY; l += 256) {
            int lx = l % SX;
            int ly = l / SX + HALO;
            float out0 = 0.0f, out1 = 0.0f, out2 = 0.0f, out3 = 0.0f,
                  out4 = 0.0f;
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                float w = kGauss[HALO - d];
                out0 += (xconv(ly - d, lx, 0) + xconv(ly + d, lx, 0)) * w;
                out1 += (xconv(ly - d, lx, 1) + xconv(ly + d, lx, 1)) * w;
                out2 += (xconv(ly - d, lx, 2) + xconv(ly + d, lx, 2)) * w;
                out3 += (xconv(ly - d, lx, 3) + xconv(ly + d, lx, 3)) * w;
                out4 += (xconv(ly - d, lx, 4) + xconv(ly + d, lx, 4)) * w;
            }
            {
                float wC = kGauss[HALO];
                out0 += xconv(ly, lx, 0) * wC;
                out1 += xconv(ly, lx, 1) * wC;
                out2 += xconv(ly, lx, 2) * wC;
                out3 += xconv(ly, lx, 3) * wC;
                out4 += xconv(ly, lx, 4) * wC;
            }

            // Window centre: the tile is offset 2*HALO in y, HALO in x.
            int cy = startY + ly - 2 * HALO;
            int cx = startX + lx - HALO;
            float inv_cov = 1.0f;
            if ((p.flags & kSsimHasCov) != 0 && uint(cx) < uint(p.W) &&
                    uint(cy) < uint(p.H))
                inv_cov = 1.0f /
                    max(p.mask_w[(bIdx * p.H + cy) * p.W + cx], 1e-6f);

            float mu1 = out0 * inv_cov;
            float mu2 = out2 * inv_cov;
            float mu1_sq = mu1 * mu1;
            float mu2_sq = mu2 * mu2;
            float sigma1_sq = out1 * inv_cov - mu1_sq;
            float sigma2_sq = out3 * inv_cov - mu2_sq;
            float sigma12 = out4 * inv_cov - mu1 * mu2;

            float A = mu1_sq + mu2_sq + kC1;
            float B_ = sigma1_sq + sigma2_sq + kC2;
            float C_ = 2.0f * mu1 * mu2 + kC1;
            float D_ = 2.0f * sigma12 + kC2;

            // Keyed by the window's OWN centre; indexing by (ly-HALO, lx)
            // put every value HALO pixels down and right of its pixel.
            if ((has_val || lm_active) && lx >= HALO && lx < HALO + BX &&
                    ly >= 2 * HALO && ly < 2 * HALO + BY &&
                    cx < p.W && cy < p.H) {
                bool cmask = _fs_mask(p, bIdx, cy, cx);
                float ssim_v = (C_ * D_) / (A * B_);
                if (lm_active) {
                    float lm_v;
                    if (p.mode == 2) {  // contrast*structure
                        lm_v = D_ / B_;
                    } else if (p.mode == 3) {  // structure only
                        float s1s2 = sqrt(max(sigma1_sq, 0.0f) *
                                          max(sigma2_sq, 0.0f));
                        lm_v = D_ / (2.0f * s1s2 + kC2);
                    } else {  // full SSIM
                        lm_v = ssim_v;
                    }
                    // A masked pixel is not being reconstructed: no error.
                    if (!cmask) lm_v = 1.0f;
                    if (ci == 0)
                        _fs_ssim[(ly - 2 * HALO) * BX + (lx - HALO)] = lm_v;
                    else
                        _fs_ssim[(ly - 2 * HALO) * BX + (lx - HALO)] += lm_v;
                }
                ssim_val += cmask ? ssim_v : 1.0f;
            }

            float d_m_dmu1 = ((mu2 * 2.0f * D_) / (A * B_) -
                              (mu2 * 2.0f * C_) / (A * B_) -
                              (mu1 * 2.0f * C_ * D_) / (A * A * B_) +
                              (mu1 * 2.0f * C_ * D_) / (A * B_ * B_));
            float d_m_dsigma1_sq = (-C_ * D_) / (A * B_ * B_);
            float d_m_dsigma12 = (2.0f * C_) / (A * B_);

            int dpix_y = startY + ly - HALO;
            int dpix_x = startX + lx;
            // A window centred on a masked pixel scores the constant 1 in
            // the scalar above, so it must push no gradient onto the unmasked
            // neighbours it overlaps -- its moments are a divide by ~nothing.
            float masked_grad =
                grad * float(dpix_x >= HALO && dpix_y >= HALO &&
                             dpix_x < p.W + HALO && dpix_y < p.H + HALO &&
                             _fs_mask(p, bIdx, dpix_y - HALO, dpix_x - HALO));

            sData(0, ly - HALO, lx) = d_m_dmu1 * masked_grad * inv_cov;
            sData(1, ly - HALO, lx) = d_m_dsigma1_sq * masked_grad * inv_cov;
            sData(2, ly - HALO, lx) = d_m_dsigma12 * masked_grad * inv_cov;
        }
        GroupMemoryBarrierWithGroupSync();

        // (4) Horizontal pass over the derivative maps.
        for (int l = int(tid); l < CY * BX; l += 256) {
            int yy = l / BX;
            int cx = l % BX;
            int lx = cx + HALO;
            float a0 = 0.0f, a1 = 0.0f, a2 = 0.0f;
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                float w = kGauss[HALO - d];
                a0 += (sData(0, yy, lx - d) + sData(0, yy, lx + d)) * w;
                a1 += (sData(1, yy, lx - d) + sData(1, yy, lx + d)) * w;
                a2 += (sData(2, yy, lx - d) + sData(2, yy, lx + d)) * w;
            }
            {
                float wc = kGauss[HALO];
                a0 += sData(0, yy, lx) * wc;
                a1 += sData(1, yy, lx) * wc;
                a2 += sData(2, yy, lx) * wc;
            }
            sScratch(yy, cx, 0) = a0;
            sScratch(yy, cx, 1) = a1;
            sScratch(yy, cx, 2) = a2;
        }
        GroupMemoryBarrierWithGroupSync();

        // (5) Vertical pass -> dL/d(img1).
        for (int l = int(tid); l < BY * BX; l += 256) {
            int lx = l % BX;
            int ly = l / BX + HALO;
            int pix_x = startX + lx;
            int pix_y = startY + l / BX;
            if (pix_x >= p.W || pix_y >= p.H) continue;
            float sum0 = 0.0f, sum1 = 0.0f, sum2 = 0.0f;
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                float w = kGauss[HALO - d];
                sum0 += (sScratch(ly - d, lx, 0) + sScratch(ly + d, lx, 0)) * w;
                sum1 += (sScratch(ly - d, lx, 1) + sScratch(ly + d, lx, 1)) * w;
                sum2 += (sScratch(ly - d, lx, 2) + sScratch(ly + d, lx, 2)) * w;
            }
            {
                float wc = kGauss[HALO];
                sum0 += sScratch(ly, lx, 0) * wc;
                sum1 += sScratch(ly, lx, 1) * wc;
                sum2 += sScratch(ly, lx, 2) * wc;
            }

            float p1 = _fs_pix(p.img1, fmt1, bIdx, pix_y, pix_x, ci, p.H, p.W);
            float p2 = _fs_pix(p.img2, fmt2, bIdx, pix_y, pix_x, ci, p.H, p.W);
            bool mask = _fs_mask(p, bIdx, pix_y, pix_x);
            float dL_dpix = sum0 + (2.0f * p1) * sum1 + p2 * sum2;
            // The scalar already counted masked pixels as a perfect match,
            // up in the aligned window loop.
            if (!mask) dL_dpix = 0.0f;

            if ((p.flags & kSsimWriteGrad) != 0) {
                int out_idx = bIdx * num_pix + pix_y * p.W + pix_x;
                p.dL_dimg1[out_idx * 3 + ci] += dL_dpix;
            }
        }
    }  // ci

    if (lm_active) {
        for (int l = int(tid); l < BY * BX; l += 256) {
            int pix_x = startX + l % BX;
            int pix_y = startY + l / BX;
            if (pix_x >= p.W || pix_y >= p.H) continue;
            float ssim_v = _fs_ssim[l] / 3.0f;
            int out_idx = bIdx * num_pix + pix_y * p.W + pix_x;
            p.loss_map[out_idx] += p.map_weight * (1.0f - ssim_v);
        }
    }

    if (has_val) {
        // Reuse _fs_ssim as the block-reduce scratch (map reads done above).
        GroupMemoryBarrierWithGroupSync();
        ssim_val /= 3.0f * float(p.B) * float(p.H) * float(p.W);
        _fs_ssim[tid] = ssim_val;
        GroupMemoryBarrierWithGroupSync();
        for (uint s = 128; s > 0; s >>= 1) {
            if (tid < s) _fs_ssim[tid] += _fs_ssim[tid + s];
            GroupMemoryBarrierWithGroupSync();
        }
        if (tid == 0 && _fs_ssim[0] != 0.0f)
            atomic_add_f32(p.ssim_val, _fs_ssim[0]);
    }
}

#undef sTile
#undef xconv
#undef sData
#undef sScratch


// ---------------------------------------------------------------------------
// Fused S-CIELAB (kernels/loss/FusedSSIM.cu's fused_scielab_kernel)
// ---------------------------------------------------------------------------

// Rows of FusedSSIM.cu's cScielabRgbToOpp / cScielabOppToXyzN.
[ForceInline]
float3 _sc_rgb_to_opp(int k) {
    if (k == 0) return float3(0.266131096f, 0.601919772f, 0.000625524f);
    if (k == 1) return float3(-0.125006493f, 0.037664685f, -0.133259103f);
    return float3(-0.080319477f, -0.331473061f, 0.449036729f);
}
static const float3x3 kScOppToXyzN = float3x3(
    0.659204924f, -1.964478203f, -0.161137515f,
    1.369855450f,  0.934755824f,  0.436229005f,
    1.382815274f,  1.305367938f,  2.329124914f);
// cScielabGauss, one channel after another.
static const float kScGauss[3 * (HALO + 1)] = {
#if 0
    0.0f, 0.0f, 1.19794559e-08f, 0.000263865076f, 0.106450769f, 0.786570707f,
    0.001028380123898387f, 0.0075987582094967365f, 0.036000773310661316f,
    0.10936068743467331f, 0.21300552785396576f, 0.26601171493530273f,
    0.00881222929f, 0.0271435771f, 0.0651140566f, 0.121649073f, 0.176998357f,
    0.200565414f,
#else
    0.0010283800844791092f, 0.007598758135239184f, 0.03600077212843082f, 0.1093606895097f, 0.2130055377112537f, 0.2660117248617943f,
    0.06136116169339518f, 0.07663081738142594f, 0.09108916096839265f, 0.10305837835540532f, 0.11098218377453624f, 0.11375659565368933f,
    0.07327261223290525f, 0.083028747203882f, 0.09150641891586254f, 0.0980868750764954f, 0.10226016805075756f, 0.10369035704019461f,
#endif
};
static const float kScEps2 = 1e-4f;

[ForceInline]
float _sc_lin(float c) {
    return c <= 0.04045f ? c * (1.0f / 12.92f)
                         : pow((c + 0.055f) * (1.0f / 1.055f), 2.4f);
}
[ForceInline]
float3 _sc_dlin(float3 c) {
    float3 r;
    [ForceUnroll]
    for (int i = 0; i < 3; i++)
        r[i] = c[i] <= 0.04045f ? 1.0f / 12.92f
                                : (2.4f / 1.055f) * pow((c[i] + 0.055f) * (1.0f / 1.055f), 1.4f);
    return r;
}
[ForceInline]
float _sc_opp(float3 c, int k) {
    return dot(_sc_rgb_to_opp(k), float3(_sc_lin(c.x), _sc_lin(c.y), _sc_lin(c.z)));
}
[ForceInline]
float _sc_f(float t) {
    return t > 216.0f / 24389.0f ? pow(t, 1.0f / 3.0f)
                                 : t * (841.0f / 108.0f) + 4.0f / 29.0f;
}
[ForceInline]
float _sc_df(float t) {
    if (t <= 216.0f / 24389.0f) return 841.0f / 108.0f;
    float r = pow(t, 1.0f / 3.0f);
    return 1.0f / (3.0f * r * r);
}
[ForceInline]
float _sc_cov1d(int k, int x, int W) {
    if (x >= HALO && x < W - HALO) return 1.0f;
    float c = 0.0f;
    for (int d = -HALO; d <= HALO; d++)
        if (uint(x + d) < uint(W)) c += kScGauss[k * (HALO + 1) + HALO - abs(d)];
    return c;
}

struct ScielabParams {
    uint* img1;       // [B,H,W,3], read as kSsimFmts
    uint* img2;
    uint* masks;      // [Bm,Hm,Wm] bool bytes
    float* cov;       // [B,H,W,3] coverage, or fallback
    float* dL_dimg1;  // [B,H,W,3], accumulated (+=)
    float* val;       // mean dE accumulator
    float* loss_map;  // [B,H,W,1], accumulated (+=)
    int B, H, W;
    int Bm, Hm, Wm;
    float dL_dmap;
    float map_weight;
    float sat;
    uint flags;       // kSsim* bits
};

// A tap off the image or dropped by the mask / clip test.
[ForceInline]
bool _sc_keep(uint* img1, uint* img2, uint* masks, uint fmts, float sat,
              bool has_mask, int Bm, int Hm, int Wm, int H, int W,
              int b, int y, int x) {
    if (uint(x) >= uint(W) || uint(y) >= uint(H)) return false;
    if (has_mask && !_fs_mask_at(masks, Bm, Hm, Wm, H, W, b, y, x)) return false;
    return _fs_unclipped(img1, img2, fmts, sat, H, W, b, y, x);
}

// Per-channel kernel weight on kept pixels; off-image taps count as dropped.
groupshared float _sc_cov_m[COV_S * COV_S];
groupshared float _sc_cov_x[3 * COV_S * COV_T];

[shader("compute")]
[numthreads(256, 1, 1)]
void scielab_mask_cov(uint3 wg: SV_GroupID, uint tid: SV_GroupThreadID,
                      uniform SsimCovParams p) {
    int b = int(wg.z);
    int x0 = int(wg.x) * COV_T - HALO;
    int y0 = int(wg.y) * COV_T - HALO;
    for (int i = int(tid); i < COV_S * COV_S; i += 256)
        _sc_cov_m[i] = _sc_keep(p.img1, p.img2, p.masks, p.fmts, p.sat, true,
                                p.Bm, p.Hm, p.Wm, p.H, p.W, b,
                                y0 + i / COV_S, x0 + i % COV_S) ? 1.0f : 0.0f;
    GroupMemoryBarrierWithGroupSync();
    for (int i = int(tid); i < COV_S * COV_T; i += 256) {
        int ly = i / COV_T, lx = i % COV_T + HALO;
        [ForceUnroll]
        for (int k = 0; k < 3; k++) {
            float acc = kScGauss[k * (HALO + 1) + HALO] * _sc_cov_m[ly * COV_S + lx];
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++)
                acc += kScGauss[k * (HALO + 1) + HALO - d] *
                       (_sc_cov_m[ly * COV_S + lx - d] + _sc_cov_m[ly * COV_S + lx + d]);
            _sc_cov_x[k * COV_S * COV_T + i] = acc;
        }
    }
    GroupMemoryBarrierWithGroupSync();
    int tx = int(tid % 16u), ty = int(tid / 16u);
    int x = int(wg.x) * COV_T + tx;
    int y = int(wg.y) * COV_T + ty;
    if (x >= p.W || y >= p.H) return;
    int o = ((b * p.H + y) * p.W + x) * 3;
    [ForceUnroll]
    for (int k = 0; k < 3; k++) {
        float acc = kScGauss[k * (HALO + 1) + HALO] *
                    _sc_cov_x[k * COV_S * COV_T + (ty + HALO) * COV_T + tx];
        [ForceUnroll]
        for (int d = 1; d <= HALO; d++)
            acc += kScGauss[k * (HALO + 1) + HALO - d] *
                   (_sc_cov_x[k * COV_S * COV_T + (ty + HALO - d) * COV_T + tx] +
                    _sc_cov_x[k * COV_S * COV_T + (ty + HALO + d) * COV_T + tx]);
        p.out[o + k] = acc;
    }
}

// The CUDA kernel's 28 KB overlay, in floats: filtered channels 0 and 1, then
// the load tile (channel 2's filtered values once its horizontal pass is done),
// then the horizontal pass.
static const int SC_T = 16;
static const int SC_LX = SC_T + 4 * HALO;
static const int SC_SX = SC_T + 2 * HALO;
static const int SC_FILT = SC_SX * SC_SX * 2;
static const int SC_TILE = SC_LX * SC_LX * 2;
static const int SC_XCONV = SC_LX * SC_SX * 2;
groupshared float _sc_sm[2 * SC_FILT + SC_TILE + SC_XCONV];

#define scFilt(k, sy, sx, i) _sc_sm[(k) * SC_FILT + ((sy) * SC_SX + (sx)) * 2 + (i)]
#define scTile(ly, lx, i) _sc_sm[2 * SC_FILT + ((ly) * SC_LX + (lx)) * 2 + (i)]
#define scXconv(ly, sx, i) _sc_sm[2 * SC_FILT + SC_TILE + ((ly) * SC_SX + (sx)) * 2 + (i)]
#define scGrad(sy, t) _sc_sm[2 * SC_FILT + SC_TILE + (sy) * SC_T + (t)]

[shader("compute")]
[numthreads(256, 1, 1)]
void scielab_bwd_inplace(uint3 wg: SV_GroupID, uint tid: SV_GroupThreadID,
                         uniform ScielabParams p) {
    const int b = int(wg.z);
    const int x0 = int(wg.x) * SC_T, y0 = int(wg.y) * SC_T;
    const int tx = int(tid % 16u), ty = int(tid / 16u);
    const uint fmts = uint(kSsimFmts);
    const uint fmt1 = fmts & 3u, fmt2 = (fmts >> 2) & 3u;
    const bool has_mask = (p.flags & kSsimHasMask) != 0;
    const bool write_grad = (p.flags & kSsimWriteGrad) != 0;
    const bool has_map = (p.flags & kSsimHasLossMap) != 0;

    for (int k = 0; k < 3; k++) {
        if (k != 0) GroupMemoryBarrierWithGroupSync();
        float g[HALO + 1];
        [ForceUnroll]
        for (int j = 0; j <= HALO; j++) g[j] = kScGauss[k * (HALO + 1) + j];
        for (int i = int(tid); i < SC_LX * SC_LX; i += 256) {
            int ly = i / SC_LX, lx = i % SC_LX;
            int gy = y0 + ly - 2 * HALO, gx = x0 + lx - 2 * HALO;
            float a = 0.0f, c = 0.0f;
            if (_sc_keep(p.img1, p.img2, p.masks, fmts, p.sat, has_mask,
                         p.Bm, p.Hm, p.Wm, p.H, p.W, b, gy, gx)) {
                int pix = (b * p.H + gy) * p.W + gx;
                a = _sc_opp(rgb_load3(p.img1, pix, fmt1), k);
                c = _sc_opp(rgb_load3(p.img2, pix, fmt2), k);
            }
            scTile(ly, lx, 0) = a;
            scTile(ly, lx, 1) = c;
        }
        GroupMemoryBarrierWithGroupSync();
        for (int i = int(tid); i < SC_LX * SC_SX; i += 256) {
            int ly = i / SC_SX, sx = i % SC_SX, lx = sx + HALO;
            float s0 = scTile(ly, lx, 0) * g[HALO], s1 = scTile(ly, lx, 1) * g[HALO];
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                s0 += (scTile(ly, lx - d, 0) + scTile(ly, lx + d, 0)) * g[HALO - d];
                s1 += (scTile(ly, lx - d, 1) + scTile(ly, lx + d, 1)) * g[HALO - d];
            }
            scXconv(ly, sx, 0) = s0;
            scXconv(ly, sx, 1) = s1;
        }
        GroupMemoryBarrierWithGroupSync();
        for (int i = int(tid); i < SC_SX * SC_SX; i += 256) {
            int sy = i / SC_SX, sx = i % SC_SX, ly = sy + HALO;
            float s0 = scXconv(ly, sx, 0) * g[HALO], s1 = scXconv(ly, sx, 1) * g[HALO];
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++) {
                s0 += (scXconv(ly - d, sx, 0) + scXconv(ly + d, sx, 0)) * g[HALO - d];
                s1 += (scXconv(ly - d, sx, 1) + scXconv(ly + d, sx, 1)) * g[HALO - d];
            }
            scFilt(k, sy, sx, 0) = s0;
            scFilt(k, sy, sx, 1) = s1;
        }
    }
    GroupMemoryBarrierWithGroupSync();

    const float gscale = p.dL_dmap / (float(p.B) * float(p.H) * float(p.W));
    float val = 0.0f;
    for (int i = int(tid); i < SC_SX * SC_SX; i += 256) {
        int sy = i / SC_SX, sx = i % SC_SX;
        int cy = y0 + sy - HALO, cx = x0 + sx - HALO;
        float3 gk = float3(0.0f);
        if (_sc_keep(p.img1, p.img2, p.masks, fmts, p.sat, has_mask,
                     p.Bm, p.Hm, p.Wm, p.H, p.W, b, cy, cx)) {
            float3 ic;
            if ((p.flags & kSsimHasCov) != 0) {
                int o = ((b * p.H + cy) * p.W + cx) * 3;
                ic = 1.0f / max(float3(p.cov[o], p.cov[o + 1], p.cov[o + 2]), float3(1e-6f));
            } else {
                [ForceUnroll]
                for (int k = 0; k < 3; k++)
                    ic[k] = 1.0f / (_sc_cov1d(k, cx, p.W) * _sc_cov1d(k, cy, p.H));
            }
            float3 tx3 = mul(kScOppToXyzN, float3(scFilt(0, sy, sx, 0), scFilt(1, sy, sx, 0),
                                                  scFilt(2, sy, sx, 0)) * ic);
            float3 ty3 = mul(kScOppToXyzN, float3(scFilt(0, sy, sx, 1), scFilt(1, sy, sx, 1),
                                                  scFilt(2, sy, sx, 1)) * ic);
            float3 fx = float3(_sc_f(tx3.x), _sc_f(tx3.y), _sc_f(tx3.z));
            float3 fy = float3(_sc_f(ty3.x), _sc_f(ty3.y), _sc_f(ty3.z));
            float dL = 116.0f * (fx.y - fy.y);
            float da = 500.0f * ((fx.x - fx.y) - (fy.x - fy.y));
            float db = 200.0f * ((fx.y - fx.z) - (fy.y - fy.z));
            float de2 = dL * dL + da * da + db * db;
            float de = sqrt(de2);
            if (sy >= HALO && sy < HALO + SC_T && sx >= HALO && sx < HALO + SC_T) {
                val += de;
                if (has_map)
                    p.loss_map[(b * p.H + cy) * p.W + cx] += p.map_weight * de;
            }
            if (write_grad) {
                float s = gscale * rsqrt(de2 + kScEps2);
                float3 gt = float3(500.0f * da,
                                   116.0f * dL - 500.0f * da + 200.0f * db,
                                   -200.0f * db) * s *
                            float3(_sc_df(tx3.x), _sc_df(tx3.y), _sc_df(tx3.z));
                gk = mul(gt, kScOppToXyzN) * ic;
            }
        }
        scFilt(0, sy, sx, 0) = gk.x;
        scFilt(1, sy, sx, 0) = gk.y;
        scFilt(2, sy, sx, 0) = gk.z;
    }

    if (write_grad) {
        float3 gl = float3(0.0f);
        for (int k = 0; k < 3; k++) {
            GroupMemoryBarrierWithGroupSync();
            float g[HALO + 1];
            [ForceUnroll]
            for (int j = 0; j <= HALO; j++) g[j] = kScGauss[k * (HALO + 1) + j];
            for (int i = int(tid); i < SC_SX * SC_T; i += 256) {
                int sy = i / SC_T, t = i % SC_T, sx = t + HALO;
                float s = scFilt(k, sy, sx, 0) * g[HALO];
                [ForceUnroll]
                for (int d = 1; d <= HALO; d++)
                    s += (scFilt(k, sy, sx - d, 0) + scFilt(k, sy, sx + d, 0)) * g[HALO - d];
                scGrad(sy, t) = s;
            }
            GroupMemoryBarrierWithGroupSync();
            int sy = ty + HALO;
            float go = scGrad(sy, tx) * g[HALO];
            [ForceUnroll]
            for (int d = 1; d <= HALO; d++)
                go += (scGrad(sy - d, tx) + scGrad(sy + d, tx)) * g[HALO - d];
            gl += _sc_rgb_to_opp(k) * go;
        }
        int px = x0 + tx, py = y0 + ty;
        if (_sc_keep(p.img1, p.img2, p.masks, fmts, p.sat, has_mask,
                     p.Bm, p.Hm, p.Wm, p.H, p.W, b, py, px)) {
            int pix = (b * p.H + py) * p.W + px;
            float3 gr = gl * _sc_dlin(rgb_load3(p.img1, pix, fmt1));
            p.dL_dimg1[pix * 3] += gr.x;
            p.dL_dimg1[pix * 3 + 1] += gr.y;
            p.dL_dimg1[pix * 3 + 2] += gr.z;
        }
    }

    if ((p.flags & kSsimHasVal) != 0) {
        GroupMemoryBarrierWithGroupSync();
        _sc_sm[tid] = val / (float(p.B) * float(p.H) * float(p.W));
        GroupMemoryBarrierWithGroupSync();
        for (uint s = 128; s > 0; s >>= 1) {
            if (tid < s) _sc_sm[tid] += _sc_sm[tid + s];
            GroupMemoryBarrierWithGroupSync();
        }
        if (tid == 0 && _sc_sm[0] != 0.0f)
            atomic_add_f32(p.val, _sc_sm[0]);
    }
}

#undef scFilt
#undef scTile
#undef scXconv
#undef scGrad
