#pragma once

#include "generated/slang.cuh"

struct ColorPPISPParams_0
{
    float2  b_0;
    float2  r_0;
    float2  g_0;
    float2  n_0;
};

inline __device__ ColorPPISPParams_0 ColorPPISPParams_x24_syn_dzero_0()
{
    ColorPPISPParams_0 result_0;
    float2  _S1 = make_float2 (0.0f);
    (&result_0)->b_0 = _S1;
    (&result_0)->r_0 = _S1;
    (&result_0)->g_0 = _S1;
    (&result_0)->n_0 = _S1;
    return result_0;
}

struct PPISPParamsNoCRFNoVig_0
{
    float exposure_0;
    ColorPPISPParams_0 color_params_0;
};

inline __device__ PPISPParamsNoCRFNoVig_0 PPISPParamsNoCRFNoVig_x24_syn_dzero_0()
{
    PPISPParamsNoCRFNoVig_0 result_1;
    (&result_1)->exposure_0 = 0.0f;
    (&result_1)->color_params_0 = ColorPPISPParams_x24_syn_dzero_0();
    return result_1;
}

inline __device__ ColorPPISPParams_0 ColorPPISPParams_x24_syn_dadd_0(ColorPPISPParams_0 * SLANG_anonymous_0_0, ColorPPISPParams_0 * SLANG_anonymous_1_0)
{
    ColorPPISPParams_0 result_2;
    (&result_2)->b_0 = SLANG_anonymous_0_0->b_0 + SLANG_anonymous_1_0->b_0;
    (&result_2)->r_0 = SLANG_anonymous_0_0->r_0 + SLANG_anonymous_1_0->r_0;
    (&result_2)->g_0 = SLANG_anonymous_0_0->g_0 + SLANG_anonymous_1_0->g_0;
    (&result_2)->n_0 = SLANG_anonymous_0_0->n_0 + SLANG_anonymous_1_0->n_0;
    return result_2;
}

inline __device__ PPISPParamsNoCRFNoVig_0 PPISPParamsNoCRFNoVig_x24_syn_dadd_0(PPISPParamsNoCRFNoVig_0 * SLANG_anonymous_0_1, PPISPParamsNoCRFNoVig_0 * SLANG_anonymous_1_1)
{
    PPISPParamsNoCRFNoVig_0 result_3;
    (&result_3)->exposure_0 = SLANG_anonymous_0_1->exposure_0 + SLANG_anonymous_1_1->exposure_0;
    ColorPPISPParams_0 _S2 = ColorPPISPParams_x24_syn_dadd_0(&SLANG_anonymous_0_1->color_params_0, &SLANG_anonymous_1_1->color_params_0);
    (&result_3)->color_params_0 = _S2;
    return result_3;
}

struct VignettingChannelParams_0
{
    float cx_0;
    float cy_0;
    float alpha0_0;
    float alpha1_0;
    float alpha2_0;
};

inline __device__ VignettingChannelParams_0 VignettingChannelParams_x24_syn_dzero_0()
{
    VignettingChannelParams_0 result_4;
    (&result_4)->cx_0 = 0.0f;
    (&result_4)->cy_0 = 0.0f;
    (&result_4)->alpha0_0 = 0.0f;
    (&result_4)->alpha1_0 = 0.0f;
    (&result_4)->alpha2_0 = 0.0f;
    return result_4;
}

struct PPISPParamsNoCRF_0
{
    float exposure_1;
    FixedArray<VignettingChannelParams_0, 3>  vignette_params_0;
    ColorPPISPParams_0 color_params_1;
};

inline __device__ PPISPParamsNoCRF_0 PPISPParamsNoCRF_x24_syn_dzero_0()
{
    PPISPParamsNoCRF_0 result_5;
    (&result_5)->exposure_1 = 0.0f;
    VignettingChannelParams_0 _S3 = VignettingChannelParams_x24_syn_dzero_0();
    (&result_5)->vignette_params_0[int(0)] = _S3;
    (&result_5)->vignette_params_0[int(1)] = _S3;
    (&result_5)->vignette_params_0[int(2)] = _S3;
    (&result_5)->color_params_1 = ColorPPISPParams_x24_syn_dzero_0();
    return result_5;
}

inline __device__ VignettingChannelParams_0 VignettingChannelParams_x24_syn_dadd_0(VignettingChannelParams_0 * SLANG_anonymous_0_2, VignettingChannelParams_0 * SLANG_anonymous_1_2)
{
    VignettingChannelParams_0 result_6;
    (&result_6)->cx_0 = SLANG_anonymous_0_2->cx_0 + SLANG_anonymous_1_2->cx_0;
    (&result_6)->cy_0 = SLANG_anonymous_0_2->cy_0 + SLANG_anonymous_1_2->cy_0;
    (&result_6)->alpha0_0 = SLANG_anonymous_0_2->alpha0_0 + SLANG_anonymous_1_2->alpha0_0;
    (&result_6)->alpha1_0 = SLANG_anonymous_0_2->alpha1_0 + SLANG_anonymous_1_2->alpha1_0;
    (&result_6)->alpha2_0 = SLANG_anonymous_0_2->alpha2_0 + SLANG_anonymous_1_2->alpha2_0;
    return result_6;
}

inline __device__ PPISPParamsNoCRF_0 PPISPParamsNoCRF_x24_syn_dadd_0(PPISPParamsNoCRF_0 * SLANG_anonymous_0_3, PPISPParamsNoCRF_0 * SLANG_anonymous_1_3)
{
    PPISPParamsNoCRF_0 result_7;
    (&result_7)->exposure_1 = SLANG_anonymous_0_3->exposure_1 + SLANG_anonymous_1_3->exposure_1;
    VignettingChannelParams_0 _S4 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_3->vignette_params_0[int(0)], &SLANG_anonymous_1_3->vignette_params_0[int(0)]);
    (&result_7)->vignette_params_0[int(0)] = _S4;
    VignettingChannelParams_0 _S5 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_3->vignette_params_0[int(1)], &SLANG_anonymous_1_3->vignette_params_0[int(1)]);
    (&result_7)->vignette_params_0[int(1)] = _S5;
    VignettingChannelParams_0 _S6 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_3->vignette_params_0[int(2)], &SLANG_anonymous_1_3->vignette_params_0[int(2)]);
    (&result_7)->vignette_params_0[int(2)] = _S6;
    ColorPPISPParams_0 _S7 = ColorPPISPParams_x24_syn_dadd_0(&SLANG_anonymous_0_3->color_params_1, &SLANG_anonymous_1_3->color_params_1);
    (&result_7)->color_params_1 = _S7;
    return result_7;
}

struct RQSCRFPPISPChannelParams_0
{
    float g0_0;
    float g1_0;
    float x0_0;
    float y0_0;
    float gc_0;
};

inline __device__ RQSCRFPPISPChannelParams_0 RQSCRFPPISPChannelParams_x24_syn_dzero_0()
{
    RQSCRFPPISPChannelParams_0 result_8;
    (&result_8)->g0_0 = 0.0f;
    (&result_8)->g1_0 = 0.0f;
    (&result_8)->x0_0 = 0.0f;
    (&result_8)->y0_0 = 0.0f;
    (&result_8)->gc_0 = 0.0f;
    return result_8;
}

struct PPISPParamsRQS_0
{
    float exposure_2;
    FixedArray<VignettingChannelParams_0, 3>  vignette_params_1;
    ColorPPISPParams_0 color_params_2;
    FixedArray<RQSCRFPPISPChannelParams_0, 3>  crf_params_0;
};

inline __device__ PPISPParamsRQS_0 PPISPParamsRQS_x24_syn_dzero_0()
{
    PPISPParamsRQS_0 result_9;
    (&result_9)->exposure_2 = 0.0f;
    VignettingChannelParams_0 _S8 = VignettingChannelParams_x24_syn_dzero_0();
    (&result_9)->vignette_params_1[int(0)] = _S8;
    (&result_9)->vignette_params_1[int(1)] = _S8;
    (&result_9)->vignette_params_1[int(2)] = _S8;
    (&result_9)->color_params_2 = ColorPPISPParams_x24_syn_dzero_0();
    RQSCRFPPISPChannelParams_0 _S9 = RQSCRFPPISPChannelParams_x24_syn_dzero_0();
    (&result_9)->crf_params_0[int(0)] = _S9;
    (&result_9)->crf_params_0[int(1)] = _S9;
    (&result_9)->crf_params_0[int(2)] = _S9;
    return result_9;
}

inline __device__ RQSCRFPPISPChannelParams_0 RQSCRFPPISPChannelParams_x24_syn_dadd_0(RQSCRFPPISPChannelParams_0 * SLANG_anonymous_0_4, RQSCRFPPISPChannelParams_0 * SLANG_anonymous_1_4)
{
    RQSCRFPPISPChannelParams_0 result_10;
    (&result_10)->g0_0 = SLANG_anonymous_0_4->g0_0 + SLANG_anonymous_1_4->g0_0;
    (&result_10)->g1_0 = SLANG_anonymous_0_4->g1_0 + SLANG_anonymous_1_4->g1_0;
    (&result_10)->x0_0 = SLANG_anonymous_0_4->x0_0 + SLANG_anonymous_1_4->x0_0;
    (&result_10)->y0_0 = SLANG_anonymous_0_4->y0_0 + SLANG_anonymous_1_4->y0_0;
    (&result_10)->gc_0 = SLANG_anonymous_0_4->gc_0 + SLANG_anonymous_1_4->gc_0;
    return result_10;
}

inline __device__ PPISPParamsRQS_0 PPISPParamsRQS_x24_syn_dadd_0(PPISPParamsRQS_0 * SLANG_anonymous_0_5, PPISPParamsRQS_0 * SLANG_anonymous_1_5)
{
    PPISPParamsRQS_0 result_11;
    (&result_11)->exposure_2 = SLANG_anonymous_0_5->exposure_2 + SLANG_anonymous_1_5->exposure_2;
    VignettingChannelParams_0 _S10 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->vignette_params_1[int(0)], &SLANG_anonymous_1_5->vignette_params_1[int(0)]);
    (&result_11)->vignette_params_1[int(0)] = _S10;
    VignettingChannelParams_0 _S11 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->vignette_params_1[int(1)], &SLANG_anonymous_1_5->vignette_params_1[int(1)]);
    (&result_11)->vignette_params_1[int(1)] = _S11;
    VignettingChannelParams_0 _S12 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->vignette_params_1[int(2)], &SLANG_anonymous_1_5->vignette_params_1[int(2)]);
    (&result_11)->vignette_params_1[int(2)] = _S12;
    ColorPPISPParams_0 _S13 = ColorPPISPParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->color_params_2, &SLANG_anonymous_1_5->color_params_2);
    (&result_11)->color_params_2 = _S13;
    RQSCRFPPISPChannelParams_0 _S14 = RQSCRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->crf_params_0[int(0)], &SLANG_anonymous_1_5->crf_params_0[int(0)]);
    (&result_11)->crf_params_0[int(0)] = _S14;
    RQSCRFPPISPChannelParams_0 _S15 = RQSCRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->crf_params_0[int(1)], &SLANG_anonymous_1_5->crf_params_0[int(1)]);
    (&result_11)->crf_params_0[int(1)] = _S15;
    RQSCRFPPISPChannelParams_0 _S16 = RQSCRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_5->crf_params_0[int(2)], &SLANG_anonymous_1_5->crf_params_0[int(2)]);
    (&result_11)->crf_params_0[int(2)] = _S16;
    return result_11;
}

struct CRFPPISPChannelParams_0
{
    float toe_0;
    float shoulder_0;
    float gamma_0;
    float center_0;
};

inline __device__ CRFPPISPChannelParams_0 CRFPPISPChannelParams_x24_syn_dzero_0()
{
    CRFPPISPChannelParams_0 result_12;
    (&result_12)->toe_0 = 0.0f;
    (&result_12)->shoulder_0 = 0.0f;
    (&result_12)->gamma_0 = 0.0f;
    (&result_12)->center_0 = 0.0f;
    return result_12;
}

struct PPISPParams_0
{
    float exposure_3;
    FixedArray<VignettingChannelParams_0, 3>  vignette_params_2;
    ColorPPISPParams_0 color_params_3;
    FixedArray<CRFPPISPChannelParams_0, 3>  crf_params_1;
};

inline __device__ PPISPParams_0 PPISPParams_x24_syn_dzero_0()
{
    PPISPParams_0 result_13;
    (&result_13)->exposure_3 = 0.0f;
    VignettingChannelParams_0 _S17 = VignettingChannelParams_x24_syn_dzero_0();
    (&result_13)->vignette_params_2[int(0)] = _S17;
    (&result_13)->vignette_params_2[int(1)] = _S17;
    (&result_13)->vignette_params_2[int(2)] = _S17;
    (&result_13)->color_params_3 = ColorPPISPParams_x24_syn_dzero_0();
    CRFPPISPChannelParams_0 _S18 = CRFPPISPChannelParams_x24_syn_dzero_0();
    (&result_13)->crf_params_1[int(0)] = _S18;
    (&result_13)->crf_params_1[int(1)] = _S18;
    (&result_13)->crf_params_1[int(2)] = _S18;
    return result_13;
}

inline __device__ CRFPPISPChannelParams_0 CRFPPISPChannelParams_x24_syn_dadd_0(CRFPPISPChannelParams_0 * SLANG_anonymous_0_6, CRFPPISPChannelParams_0 * SLANG_anonymous_1_6)
{
    CRFPPISPChannelParams_0 result_14;
    (&result_14)->toe_0 = SLANG_anonymous_0_6->toe_0 + SLANG_anonymous_1_6->toe_0;
    (&result_14)->shoulder_0 = SLANG_anonymous_0_6->shoulder_0 + SLANG_anonymous_1_6->shoulder_0;
    (&result_14)->gamma_0 = SLANG_anonymous_0_6->gamma_0 + SLANG_anonymous_1_6->gamma_0;
    (&result_14)->center_0 = SLANG_anonymous_0_6->center_0 + SLANG_anonymous_1_6->center_0;
    return result_14;
}

inline __device__ PPISPParams_0 PPISPParams_x24_syn_dadd_0(PPISPParams_0 * SLANG_anonymous_0_7, PPISPParams_0 * SLANG_anonymous_1_7)
{
    PPISPParams_0 result_15;
    (&result_15)->exposure_3 = SLANG_anonymous_0_7->exposure_3 + SLANG_anonymous_1_7->exposure_3;
    VignettingChannelParams_0 _S19 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->vignette_params_2[int(0)], &SLANG_anonymous_1_7->vignette_params_2[int(0)]);
    (&result_15)->vignette_params_2[int(0)] = _S19;
    VignettingChannelParams_0 _S20 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->vignette_params_2[int(1)], &SLANG_anonymous_1_7->vignette_params_2[int(1)]);
    (&result_15)->vignette_params_2[int(1)] = _S20;
    VignettingChannelParams_0 _S21 = VignettingChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->vignette_params_2[int(2)], &SLANG_anonymous_1_7->vignette_params_2[int(2)]);
    (&result_15)->vignette_params_2[int(2)] = _S21;
    ColorPPISPParams_0 _S22 = ColorPPISPParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->color_params_3, &SLANG_anonymous_1_7->color_params_3);
    (&result_15)->color_params_3 = _S22;
    CRFPPISPChannelParams_0 _S23 = CRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->crf_params_1[int(0)], &SLANG_anonymous_1_7->crf_params_1[int(0)]);
    (&result_15)->crf_params_1[int(0)] = _S23;
    CRFPPISPChannelParams_0 _S24 = CRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->crf_params_1[int(1)], &SLANG_anonymous_1_7->crf_params_1[int(1)]);
    (&result_15)->crf_params_1[int(1)] = _S24;
    CRFPPISPChannelParams_0 _S25 = CRFPPISPChannelParams_x24_syn_dadd_0(&SLANG_anonymous_0_7->crf_params_1[int(2)], &SLANG_anonymous_1_7->crf_params_1[int(2)]);
    (&result_15)->crf_params_1[int(2)] = _S25;
    return result_15;
}

struct DiffPair_float_0
{
    float primal_0;
    float differential_0;
};

inline __device__ void _d_exp2_0(DiffPair_float_0 * dpx_0, float dOut_0)
{
    float _S26 = (F32_exp2(((*dpx_0).primal_0))) * 0.69314718246459961f * dOut_0;
    dpx_0->primal_0 = (*dpx_0).primal_0;
    dpx_0->differential_0 = _S26;
    return;
}

inline __device__ void _d_max_0(DiffPair_float_0 * dpx_1, DiffPair_float_0 * dpy_0, float dOut_1)
{
    DiffPair_float_0 _S27 = *dpx_1;
    float _S28;
    if(((*dpx_1).primal_0) > ((*dpy_0).primal_0))
    {
        _S28 = dOut_1;
    }
    else
    {
        if(((*dpx_1).primal_0) < ((*dpy_0).primal_0))
        {
            _S28 = 0.0f;
        }
        else
        {
            _S28 = 0.5f * dOut_1;
        }
    }
    dpx_1->primal_0 = _S27.primal_0;
    dpx_1->differential_0 = _S28;
    DiffPair_float_0 _S29 = *dpy_0;
    if(((*dpy_0).primal_0) > (_S27.primal_0))
    {
        _S28 = dOut_1;
    }
    else
    {
        if(((*dpy_0).primal_0) < ((*dpx_1).primal_0))
        {
            _S28 = 0.0f;
        }
        else
        {
            _S28 = 0.5f * dOut_1;
        }
    }
    dpy_0->primal_0 = _S29.primal_0;
    dpy_0->differential_0 = _S28;
    return;
}

inline __device__ void _d_clamp_0(DiffPair_float_0 * dpx_2, DiffPair_float_0 * dpMin_0, DiffPair_float_0 * dpMax_0, float dOut_2)
{
    DiffPair_float_0 _S30 = *dpx_2;
    bool _S31;
    if(((*dpx_2).primal_0) >= ((*dpMin_0).primal_0))
    {
        _S31 = ((*dpx_2).primal_0) <= ((*dpMax_0).primal_0);
    }
    else
    {
        _S31 = false;
    }
    float _S32;
    if(_S31)
    {
        _S32 = dOut_2;
    }
    else
    {
        _S32 = 0.0f;
    }
    dpx_2->primal_0 = _S30.primal_0;
    dpx_2->differential_0 = _S32;
    DiffPair_float_0 _S33 = *dpMin_0;
    if((_S30.primal_0) < ((*dpMin_0).primal_0))
    {
        _S32 = dOut_2;
    }
    else
    {
        _S32 = 0.0f;
    }
    dpMin_0->primal_0 = _S33.primal_0;
    dpMin_0->differential_0 = _S32;
    DiffPair_float_0 _S34 = *dpMax_0;
    if(((*dpx_2).primal_0) > ((*dpMax_0).primal_0))
    {
        _S32 = dOut_2;
    }
    else
    {
        _S32 = 0.0f;
    }
    dpMax_0->primal_0 = _S34.primal_0;
    dpMax_0->differential_0 = _S32;
    return;
}

inline __device__ float clamp_0(float x_0, float minBound_0, float maxBound_0)
{
    return (F32_min(((F32_max((x_0), (minBound_0)))), (maxBound_0)));
}

struct DiffPair_matrixx3Cfloatx2C2x2C2x3E_0
{
    Matrix<float, 2, 2>  primal_0;
    Matrix<float, 2, 2>  differential_0;
};

struct DiffPair_vectorx3Cfloatx2C2x3E_0
{
    float2  primal_0;
    float2  differential_0;
};

inline __device__ void _d_mul_0(DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 * left_0, DiffPair_vectorx3Cfloatx2C2x3E_0 * right_0, float2  dOut_3)
{
    float _S35 = (*left_0).primal_0.rows[int(0)].x * dOut_3.x;
    Matrix<float, 2, 2>  left_d_result_0;
    *&(((&left_d_result_0)->rows + (int(0)))->x) = (*right_0).primal_0.x * dOut_3.x;
    float sum_0 = _S35 + (*left_0).primal_0.rows[int(1)].x * dOut_3.y;
    *&(((&left_d_result_0)->rows + (int(1)))->x) = (*right_0).primal_0.x * dOut_3.y;
    float2  right_d_result_0;
    *&((&right_d_result_0)->x) = sum_0;
    float _S36 = (*left_0).primal_0.rows[int(0)].y * dOut_3.x;
    *&(((&left_d_result_0)->rows + (int(0)))->y) = (*right_0).primal_0.y * dOut_3.x;
    float sum_1 = _S36 + (*left_0).primal_0.rows[int(1)].y * dOut_3.y;
    *&(((&left_d_result_0)->rows + (int(1)))->y) = (*right_0).primal_0.y * dOut_3.y;
    *&((&right_d_result_0)->y) = sum_1;
    left_0->primal_0 = (*left_0).primal_0;
    left_0->differential_0 = left_d_result_0;
    right_0->primal_0 = (*right_0).primal_0;
    right_0->differential_0 = right_d_result_0;
    return;
}

struct DiffPair_matrixx3Cfloatx2C3x2C3x3E_0
{
    Matrix<float, 3, 3>  primal_0;
    Matrix<float, 3, 3>  differential_0;
};

struct DiffPair_vectorx3Cfloatx2C3x3E_0
{
    float3  primal_0;
    float3  differential_0;
};

inline __device__ void _d_mul_1(DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * left_1, DiffPair_vectorx3Cfloatx2C3x3E_0 * right_1, float3  dOut_4)
{
    float _S37 = (*left_1).primal_0.rows[int(0)].x * dOut_4.x;
    Matrix<float, 3, 3>  left_d_result_1;
    *&(((&left_d_result_1)->rows + (int(0)))->x) = (*right_1).primal_0.x * dOut_4.x;
    float sum_2 = _S37 + (*left_1).primal_0.rows[int(1)].x * dOut_4.y;
    *&(((&left_d_result_1)->rows + (int(1)))->x) = (*right_1).primal_0.x * dOut_4.y;
    float sum_3 = sum_2 + (*left_1).primal_0.rows[int(2)].x * dOut_4.z;
    *&(((&left_d_result_1)->rows + (int(2)))->x) = (*right_1).primal_0.x * dOut_4.z;
    float3  right_d_result_1;
    *&((&right_d_result_1)->x) = sum_3;
    float _S38 = (*left_1).primal_0.rows[int(0)].y * dOut_4.x;
    *&(((&left_d_result_1)->rows + (int(0)))->y) = (*right_1).primal_0.y * dOut_4.x;
    float sum_4 = _S38 + (*left_1).primal_0.rows[int(1)].y * dOut_4.y;
    *&(((&left_d_result_1)->rows + (int(1)))->y) = (*right_1).primal_0.y * dOut_4.y;
    float sum_5 = sum_4 + (*left_1).primal_0.rows[int(2)].y * dOut_4.z;
    *&(((&left_d_result_1)->rows + (int(2)))->y) = (*right_1).primal_0.y * dOut_4.z;
    *&((&right_d_result_1)->y) = sum_5;
    float _S39 = (*left_1).primal_0.rows[int(0)].z * dOut_4.x;
    *&(((&left_d_result_1)->rows + (int(0)))->z) = (*right_1).primal_0.z * dOut_4.x;
    float sum_6 = _S39 + (*left_1).primal_0.rows[int(1)].z * dOut_4.y;
    *&(((&left_d_result_1)->rows + (int(1)))->z) = (*right_1).primal_0.z * dOut_4.y;
    float sum_7 = sum_6 + (*left_1).primal_0.rows[int(2)].z * dOut_4.z;
    *&(((&left_d_result_1)->rows + (int(2)))->z) = (*right_1).primal_0.z * dOut_4.z;
    *&((&right_d_result_1)->z) = sum_7;
    left_1->primal_0 = (*left_1).primal_0;
    left_1->differential_0 = left_d_result_1;
    right_1->primal_0 = (*right_1).primal_0;
    right_1->differential_0 = right_d_result_1;
    return;
}

inline __device__ float2  mul_0(Matrix<float, 2, 2>  left_2, float2  right_2)
{
    float2  result_16;
    int i_0 = int(0);
    for(;;)
    {
        if(i_0 < int(2))
        {
        }
        else
        {
            break;
        }
        int j_0 = int(0);
        float sum_8 = 0.0f;
        for(;;)
        {
            if(j_0 < int(2))
            {
            }
            else
            {
                break;
            }
            float sum_9 = sum_8 + _slang_vector_get_element(left_2.rows[i_0], j_0) * _slang_vector_get_element(right_2, j_0);
            j_0 = j_0 + int(1);
            sum_8 = sum_9;
        }
        *_slang_vector_get_element_ptr(&result_16, i_0) = sum_8;
        i_0 = i_0 + int(1);
    }
    return result_16;
}

inline __device__ float3  mul_1(Matrix<float, 3, 3>  left_3, float3  right_3)
{
    float3  result_17;
    int i_1 = int(0);
    for(;;)
    {
        if(i_1 < int(3))
        {
        }
        else
        {
            break;
        }
        int j_1 = int(0);
        float sum_10 = 0.0f;
        for(;;)
        {
            if(j_1 < int(3))
            {
            }
            else
            {
                break;
            }
            float sum_11 = sum_10 + _slang_vector_get_element(left_3.rows[i_1], j_1) * _slang_vector_get_element(right_3, j_1);
            j_1 = j_1 + int(1);
            sum_10 = sum_11;
        }
        *_slang_vector_get_element_ptr(&result_17, i_1) = sum_10;
        i_1 = i_1 + int(1);
    }
    return result_17;
}

inline __device__ void mul_2(DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * left_4, DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * right_4, Matrix<float, 3, 3>  dOut_5)
{
    Matrix<float, 3, 3>  left_d_result_2;
    *&(((&left_d_result_2)->rows + (int(0)))->x) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(0)))->y) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(0)))->z) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(1)))->x) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(1)))->y) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(1)))->z) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(2)))->x) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(2)))->y) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(2)))->z) = 0.0f;
    Matrix<float, 3, 3>  right_d_result_2;
    *&(((&right_d_result_2)->rows + (int(0)))->x) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(0)))->y) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(0)))->z) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(1)))->x) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(1)))->y) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(1)))->z) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(2)))->x) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(2)))->y) = 0.0f;
    *&(((&right_d_result_2)->rows + (int(2)))->z) = 0.0f;
    *&(((&left_d_result_2)->rows + (int(0)))->x) = *&(((&left_d_result_2)->rows + (int(0)))->x) + (*right_4).primal_0.rows[int(0)].x * dOut_5.rows[int(0)].x;
    *&(((&right_d_result_2)->rows + (int(0)))->x) = *&(((&right_d_result_2)->rows + (int(0)))->x) + (*left_4).primal_0.rows[int(0)].x * dOut_5.rows[int(0)].x;
    *&(((&left_d_result_2)->rows + (int(0)))->y) = *&(((&left_d_result_2)->rows + (int(0)))->y) + (*right_4).primal_0.rows[int(1)].x * dOut_5.rows[int(0)].x;
    *&(((&right_d_result_2)->rows + (int(1)))->x) = *&(((&right_d_result_2)->rows + (int(1)))->x) + (*left_4).primal_0.rows[int(0)].y * dOut_5.rows[int(0)].x;
    *&(((&left_d_result_2)->rows + (int(0)))->z) = *&(((&left_d_result_2)->rows + (int(0)))->z) + (*right_4).primal_0.rows[int(2)].x * dOut_5.rows[int(0)].x;
    *&(((&right_d_result_2)->rows + (int(2)))->x) = *&(((&right_d_result_2)->rows + (int(2)))->x) + (*left_4).primal_0.rows[int(0)].z * dOut_5.rows[int(0)].x;
    *&(((&left_d_result_2)->rows + (int(0)))->x) = *&(((&left_d_result_2)->rows + (int(0)))->x) + (*right_4).primal_0.rows[int(0)].y * dOut_5.rows[int(0)].y;
    *&(((&right_d_result_2)->rows + (int(0)))->y) = *&(((&right_d_result_2)->rows + (int(0)))->y) + (*left_4).primal_0.rows[int(0)].x * dOut_5.rows[int(0)].y;
    *&(((&left_d_result_2)->rows + (int(0)))->y) = *&(((&left_d_result_2)->rows + (int(0)))->y) + (*right_4).primal_0.rows[int(1)].y * dOut_5.rows[int(0)].y;
    *&(((&right_d_result_2)->rows + (int(1)))->y) = *&(((&right_d_result_2)->rows + (int(1)))->y) + (*left_4).primal_0.rows[int(0)].y * dOut_5.rows[int(0)].y;
    *&(((&left_d_result_2)->rows + (int(0)))->z) = *&(((&left_d_result_2)->rows + (int(0)))->z) + (*right_4).primal_0.rows[int(2)].y * dOut_5.rows[int(0)].y;
    *&(((&right_d_result_2)->rows + (int(2)))->y) = *&(((&right_d_result_2)->rows + (int(2)))->y) + (*left_4).primal_0.rows[int(0)].z * dOut_5.rows[int(0)].y;
    *&(((&left_d_result_2)->rows + (int(0)))->x) = *&(((&left_d_result_2)->rows + (int(0)))->x) + (*right_4).primal_0.rows[int(0)].z * dOut_5.rows[int(0)].z;
    *&(((&right_d_result_2)->rows + (int(0)))->z) = *&(((&right_d_result_2)->rows + (int(0)))->z) + (*left_4).primal_0.rows[int(0)].x * dOut_5.rows[int(0)].z;
    *&(((&left_d_result_2)->rows + (int(0)))->y) = *&(((&left_d_result_2)->rows + (int(0)))->y) + (*right_4).primal_0.rows[int(1)].z * dOut_5.rows[int(0)].z;
    *&(((&right_d_result_2)->rows + (int(1)))->z) = *&(((&right_d_result_2)->rows + (int(1)))->z) + (*left_4).primal_0.rows[int(0)].y * dOut_5.rows[int(0)].z;
    *&(((&left_d_result_2)->rows + (int(0)))->z) = *&(((&left_d_result_2)->rows + (int(0)))->z) + (*right_4).primal_0.rows[int(2)].z * dOut_5.rows[int(0)].z;
    *&(((&right_d_result_2)->rows + (int(2)))->z) = *&(((&right_d_result_2)->rows + (int(2)))->z) + (*left_4).primal_0.rows[int(0)].z * dOut_5.rows[int(0)].z;
    *&(((&left_d_result_2)->rows + (int(1)))->x) = *&(((&left_d_result_2)->rows + (int(1)))->x) + (*right_4).primal_0.rows[int(0)].x * dOut_5.rows[int(1)].x;
    *&(((&right_d_result_2)->rows + (int(0)))->x) = *&(((&right_d_result_2)->rows + (int(0)))->x) + (*left_4).primal_0.rows[int(1)].x * dOut_5.rows[int(1)].x;
    *&(((&left_d_result_2)->rows + (int(1)))->y) = *&(((&left_d_result_2)->rows + (int(1)))->y) + (*right_4).primal_0.rows[int(1)].x * dOut_5.rows[int(1)].x;
    *&(((&right_d_result_2)->rows + (int(1)))->x) = *&(((&right_d_result_2)->rows + (int(1)))->x) + (*left_4).primal_0.rows[int(1)].y * dOut_5.rows[int(1)].x;
    *&(((&left_d_result_2)->rows + (int(1)))->z) = *&(((&left_d_result_2)->rows + (int(1)))->z) + (*right_4).primal_0.rows[int(2)].x * dOut_5.rows[int(1)].x;
    *&(((&right_d_result_2)->rows + (int(2)))->x) = *&(((&right_d_result_2)->rows + (int(2)))->x) + (*left_4).primal_0.rows[int(1)].z * dOut_5.rows[int(1)].x;
    *&(((&left_d_result_2)->rows + (int(1)))->x) = *&(((&left_d_result_2)->rows + (int(1)))->x) + (*right_4).primal_0.rows[int(0)].y * dOut_5.rows[int(1)].y;
    *&(((&right_d_result_2)->rows + (int(0)))->y) = *&(((&right_d_result_2)->rows + (int(0)))->y) + (*left_4).primal_0.rows[int(1)].x * dOut_5.rows[int(1)].y;
    *&(((&left_d_result_2)->rows + (int(1)))->y) = *&(((&left_d_result_2)->rows + (int(1)))->y) + (*right_4).primal_0.rows[int(1)].y * dOut_5.rows[int(1)].y;
    *&(((&right_d_result_2)->rows + (int(1)))->y) = *&(((&right_d_result_2)->rows + (int(1)))->y) + (*left_4).primal_0.rows[int(1)].y * dOut_5.rows[int(1)].y;
    *&(((&left_d_result_2)->rows + (int(1)))->z) = *&(((&left_d_result_2)->rows + (int(1)))->z) + (*right_4).primal_0.rows[int(2)].y * dOut_5.rows[int(1)].y;
    *&(((&right_d_result_2)->rows + (int(2)))->y) = *&(((&right_d_result_2)->rows + (int(2)))->y) + (*left_4).primal_0.rows[int(1)].z * dOut_5.rows[int(1)].y;
    *&(((&left_d_result_2)->rows + (int(1)))->x) = *&(((&left_d_result_2)->rows + (int(1)))->x) + (*right_4).primal_0.rows[int(0)].z * dOut_5.rows[int(1)].z;
    *&(((&right_d_result_2)->rows + (int(0)))->z) = *&(((&right_d_result_2)->rows + (int(0)))->z) + (*left_4).primal_0.rows[int(1)].x * dOut_5.rows[int(1)].z;
    *&(((&left_d_result_2)->rows + (int(1)))->y) = *&(((&left_d_result_2)->rows + (int(1)))->y) + (*right_4).primal_0.rows[int(1)].z * dOut_5.rows[int(1)].z;
    *&(((&right_d_result_2)->rows + (int(1)))->z) = *&(((&right_d_result_2)->rows + (int(1)))->z) + (*left_4).primal_0.rows[int(1)].y * dOut_5.rows[int(1)].z;
    *&(((&left_d_result_2)->rows + (int(1)))->z) = *&(((&left_d_result_2)->rows + (int(1)))->z) + (*right_4).primal_0.rows[int(2)].z * dOut_5.rows[int(1)].z;
    *&(((&right_d_result_2)->rows + (int(2)))->z) = *&(((&right_d_result_2)->rows + (int(2)))->z) + (*left_4).primal_0.rows[int(1)].z * dOut_5.rows[int(1)].z;
    *&(((&left_d_result_2)->rows + (int(2)))->x) = *&(((&left_d_result_2)->rows + (int(2)))->x) + (*right_4).primal_0.rows[int(0)].x * dOut_5.rows[int(2)].x;
    *&(((&right_d_result_2)->rows + (int(0)))->x) = *&(((&right_d_result_2)->rows + (int(0)))->x) + (*left_4).primal_0.rows[int(2)].x * dOut_5.rows[int(2)].x;
    *&(((&left_d_result_2)->rows + (int(2)))->y) = *&(((&left_d_result_2)->rows + (int(2)))->y) + (*right_4).primal_0.rows[int(1)].x * dOut_5.rows[int(2)].x;
    *&(((&right_d_result_2)->rows + (int(1)))->x) = *&(((&right_d_result_2)->rows + (int(1)))->x) + (*left_4).primal_0.rows[int(2)].y * dOut_5.rows[int(2)].x;
    *&(((&left_d_result_2)->rows + (int(2)))->z) = *&(((&left_d_result_2)->rows + (int(2)))->z) + (*right_4).primal_0.rows[int(2)].x * dOut_5.rows[int(2)].x;
    *&(((&right_d_result_2)->rows + (int(2)))->x) = *&(((&right_d_result_2)->rows + (int(2)))->x) + (*left_4).primal_0.rows[int(2)].z * dOut_5.rows[int(2)].x;
    *&(((&left_d_result_2)->rows + (int(2)))->x) = *&(((&left_d_result_2)->rows + (int(2)))->x) + (*right_4).primal_0.rows[int(0)].y * dOut_5.rows[int(2)].y;
    *&(((&right_d_result_2)->rows + (int(0)))->y) = *&(((&right_d_result_2)->rows + (int(0)))->y) + (*left_4).primal_0.rows[int(2)].x * dOut_5.rows[int(2)].y;
    *&(((&left_d_result_2)->rows + (int(2)))->y) = *&(((&left_d_result_2)->rows + (int(2)))->y) + (*right_4).primal_0.rows[int(1)].y * dOut_5.rows[int(2)].y;
    *&(((&right_d_result_2)->rows + (int(1)))->y) = *&(((&right_d_result_2)->rows + (int(1)))->y) + (*left_4).primal_0.rows[int(2)].y * dOut_5.rows[int(2)].y;
    *&(((&left_d_result_2)->rows + (int(2)))->z) = *&(((&left_d_result_2)->rows + (int(2)))->z) + (*right_4).primal_0.rows[int(2)].y * dOut_5.rows[int(2)].y;
    *&(((&right_d_result_2)->rows + (int(2)))->y) = *&(((&right_d_result_2)->rows + (int(2)))->y) + (*left_4).primal_0.rows[int(2)].z * dOut_5.rows[int(2)].y;
    *&(((&left_d_result_2)->rows + (int(2)))->x) = *&(((&left_d_result_2)->rows + (int(2)))->x) + (*right_4).primal_0.rows[int(0)].z * dOut_5.rows[int(2)].z;
    *&(((&right_d_result_2)->rows + (int(0)))->z) = *&(((&right_d_result_2)->rows + (int(0)))->z) + (*left_4).primal_0.rows[int(2)].x * dOut_5.rows[int(2)].z;
    *&(((&left_d_result_2)->rows + (int(2)))->y) = *&(((&left_d_result_2)->rows + (int(2)))->y) + (*right_4).primal_0.rows[int(1)].z * dOut_5.rows[int(2)].z;
    *&(((&right_d_result_2)->rows + (int(1)))->z) = *&(((&right_d_result_2)->rows + (int(1)))->z) + (*left_4).primal_0.rows[int(2)].y * dOut_5.rows[int(2)].z;
    *&(((&left_d_result_2)->rows + (int(2)))->z) = *&(((&left_d_result_2)->rows + (int(2)))->z) + (*right_4).primal_0.rows[int(2)].z * dOut_5.rows[int(2)].z;
    *&(((&right_d_result_2)->rows + (int(2)))->z) = *&(((&right_d_result_2)->rows + (int(2)))->z) + (*left_4).primal_0.rows[int(2)].z * dOut_5.rows[int(2)].z;
    left_4->primal_0 = (*left_4).primal_0;
    left_4->differential_0 = left_d_result_2;
    right_4->primal_0 = (*right_4).primal_0;
    right_4->differential_0 = right_d_result_2;
    return;
}

inline __device__ Matrix<float, 3, 3>  mul_3(Matrix<float, 3, 3>  left_5, Matrix<float, 3, 3>  right_5)
{
    Matrix<float, 3, 3>  result_18;
    int r_1 = int(0);
    for(;;)
    {
        if(r_1 < int(3))
        {
        }
        else
        {
            break;
        }
        int c_0 = int(0);
        for(;;)
        {
            if(c_0 < int(3))
            {
            }
            else
            {
                break;
            }
            int i_2 = int(0);
            float sum_12 = 0.0f;
            for(;;)
            {
                if(i_2 < int(3))
                {
                }
                else
                {
                    break;
                }
                float sum_13 = sum_12 + _slang_vector_get_element(left_5.rows[r_1], i_2) * _slang_vector_get_element(right_5.rows[i_2], c_0);
                i_2 = i_2 + int(1);
                sum_12 = sum_13;
            }
            *_slang_vector_get_element_ptr(((&result_18)->rows + (r_1)), c_0) = sum_12;
            c_0 = c_0 + int(1);
        }
        r_1 = r_1 + int(1);
    }
    return result_18;
}

inline __device__ void _d_cross_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * a_0, DiffPair_vectorx3Cfloatx2C3x3E_0 * b_1, float3  dOut_6)
{
    float _S40 = dOut_6.y;
    float _S41 = dOut_6.z;
    float _S42 = dOut_6.x;
    float _S43 = (*a_0).primal_0.z * _S40 + - (*a_0).primal_0.y * _S41;
    float _S44 = - (*a_0).primal_0.z * _S42 + (*a_0).primal_0.x * _S41;
    float _S45 = (*a_0).primal_0.y * _S42 + - (*a_0).primal_0.x * _S40;
    float3  _S46 = make_float3 (- (*b_1).primal_0.z * _S40 + (*b_1).primal_0.y * _S41, (*b_1).primal_0.z * _S42 + - (*b_1).primal_0.x * _S41, - (*b_1).primal_0.y * _S42 + (*b_1).primal_0.x * _S40);
    a_0->primal_0 = (*a_0).primal_0;
    a_0->differential_0 = _S46;
    float3  _S47 = make_float3 (_S43, _S44, _S45);
    b_1->primal_0 = (*b_1).primal_0;
    b_1->differential_0 = _S47;
    return;
}

inline __device__ float3  cross_0(float3  left_6, float3  right_6)
{
    float _S48 = left_6.y;
    float _S49 = right_6.z;
    float _S50 = left_6.z;
    float _S51 = right_6.y;
    float _S52 = right_6.x;
    float _S53 = left_6.x;
    return make_float3 (_S48 * _S49 - _S50 * _S51, _S50 * _S52 - _S53 * _S49, _S53 * _S51 - _S48 * _S52);
}

inline __device__ void _d_dot_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dpx_3, DiffPair_vectorx3Cfloatx2C3x3E_0 * dpy_1, float dOut_7)
{
    float3  x_d_result_0;
    *&((&x_d_result_0)->x) = (*dpy_1).primal_0.x * dOut_7;
    float3  y_d_result_0;
    *&((&y_d_result_0)->x) = (*dpx_3).primal_0.x * dOut_7;
    *&((&x_d_result_0)->y) = (*dpy_1).primal_0.y * dOut_7;
    *&((&y_d_result_0)->y) = (*dpx_3).primal_0.y * dOut_7;
    *&((&x_d_result_0)->z) = (*dpy_1).primal_0.z * dOut_7;
    *&((&y_d_result_0)->z) = (*dpx_3).primal_0.z * dOut_7;
    dpx_3->primal_0 = (*dpx_3).primal_0;
    dpx_3->differential_0 = x_d_result_0;
    dpy_1->primal_0 = (*dpy_1).primal_0;
    dpy_1->differential_0 = y_d_result_0;
    return;
}

inline __device__ float dot_0(float3  x_1, float3  y_0)
{
    int i_3 = int(0);
    float result_19 = 0.0f;
    for(;;)
    {
        if(i_3 < int(3))
        {
        }
        else
        {
            break;
        }
        float result_20 = result_19 + _slang_vector_get_element(x_1, i_3) * _slang_vector_get_element(y_0, i_3);
        i_3 = i_3 + int(1);
        result_19 = result_20;
    }
    return result_19;
}

inline __device__ void _d_abs_0(DiffPair_float_0 * dpx_4, float dOut_8)
{
    float _S54 = _slang_select(((*dpx_4).primal_0) > 0.0f, 1.0f,_slang_select(((*dpx_4).primal_0) == 0.0f, 0.0f,-1.0f)) * dOut_8;
    dpx_4->primal_0 = (*dpx_4).primal_0;
    dpx_4->differential_0 = _S54;
    return;
}

inline __device__ float3  min_0(float3  x_2, float3  y_1)
{
    float3  result_21;
    int i_4 = int(0);
    for(;;)
    {
        if(i_4 < int(3))
        {
        }
        else
        {
            break;
        }
        *_slang_vector_get_element_ptr(&result_21, i_4) = (F32_min((_slang_vector_get_element(x_2, i_4)), (_slang_vector_get_element(y_1, i_4))));
        i_4 = i_4 + int(1);
    }
    return result_21;
}

inline __device__ float3  max_0(float3  x_3, float3  y_2)
{
    float3  result_22;
    int i_5 = int(0);
    for(;;)
    {
        if(i_5 < int(3))
        {
        }
        else
        {
            break;
        }
        *_slang_vector_get_element_ptr(&result_22, i_5) = (F32_max((_slang_vector_get_element(x_3, i_5)), (_slang_vector_get_element(y_2, i_5))));
        i_5 = i_5 + int(1);
    }
    return result_22;
}

inline __device__ void _d_clamp_vector_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dpx_5, DiffPair_vectorx3Cfloatx2C3x3E_0 * dpy_2, DiffPair_vectorx3Cfloatx2C3x3E_0 * dpz_0, float3  dOut_9)
{
    DiffPair_float_0 left_dp_0;
    (&left_dp_0)->primal_0 = (*dpx_5).primal_0.x;
    (&left_dp_0)->differential_0 = 0.0f;
    DiffPair_float_0 middle_dp_0;
    (&middle_dp_0)->primal_0 = (*dpy_2).primal_0.x;
    (&middle_dp_0)->differential_0 = 0.0f;
    DiffPair_float_0 right_dp_0;
    (&right_dp_0)->primal_0 = (*dpz_0).primal_0.x;
    (&right_dp_0)->differential_0 = 0.0f;
    _d_clamp_0(&left_dp_0, &middle_dp_0, &right_dp_0, dOut_9.x);
    float3  left_d_result_3;
    *&((&left_d_result_3)->x) = left_dp_0.differential_0;
    float3  middle_d_result_0;
    *&((&middle_d_result_0)->x) = middle_dp_0.differential_0;
    float3  right_d_result_3;
    *&((&right_d_result_3)->x) = right_dp_0.differential_0;
    DiffPair_float_0 left_dp_1;
    (&left_dp_1)->primal_0 = (*dpx_5).primal_0.y;
    (&left_dp_1)->differential_0 = 0.0f;
    DiffPair_float_0 middle_dp_1;
    (&middle_dp_1)->primal_0 = (*dpy_2).primal_0.y;
    (&middle_dp_1)->differential_0 = 0.0f;
    DiffPair_float_0 right_dp_1;
    (&right_dp_1)->primal_0 = (*dpz_0).primal_0.y;
    (&right_dp_1)->differential_0 = 0.0f;
    _d_clamp_0(&left_dp_1, &middle_dp_1, &right_dp_1, dOut_9.y);
    *&((&left_d_result_3)->y) = left_dp_1.differential_0;
    *&((&middle_d_result_0)->y) = middle_dp_1.differential_0;
    *&((&right_d_result_3)->y) = right_dp_1.differential_0;
    DiffPair_float_0 left_dp_2;
    (&left_dp_2)->primal_0 = (*dpx_5).primal_0.z;
    (&left_dp_2)->differential_0 = 0.0f;
    DiffPair_float_0 middle_dp_2;
    (&middle_dp_2)->primal_0 = (*dpy_2).primal_0.z;
    (&middle_dp_2)->differential_0 = 0.0f;
    DiffPair_float_0 right_dp_2;
    (&right_dp_2)->primal_0 = (*dpz_0).primal_0.z;
    (&right_dp_2)->differential_0 = 0.0f;
    _d_clamp_0(&left_dp_2, &middle_dp_2, &right_dp_2, dOut_9.z);
    *&((&left_d_result_3)->z) = left_dp_2.differential_0;
    *&((&middle_d_result_0)->z) = middle_dp_2.differential_0;
    *&((&right_d_result_3)->z) = right_dp_2.differential_0;
    dpx_5->primal_0 = (*dpx_5).primal_0;
    dpx_5->differential_0 = left_d_result_3;
    dpy_2->primal_0 = (*dpy_2).primal_0;
    dpy_2->differential_0 = middle_d_result_0;
    dpz_0->primal_0 = (*dpz_0).primal_0;
    dpz_0->differential_0 = right_d_result_3;
    return;
}

inline __device__ float3  clamp_1(float3  x_4, float3  minBound_1, float3  maxBound_1)
{
    return min_0(max_0(x_4, minBound_1), maxBound_1);
}

inline __device__ void _d_exp_0(DiffPair_float_0 * dpx_6, float dOut_10)
{
    float _S55 = (F32_exp(((*dpx_6).primal_0))) * dOut_10;
    dpx_6->primal_0 = (*dpx_6).primal_0;
    dpx_6->differential_0 = _S55;
    return;
}

inline __device__ void _d_log_0(DiffPair_float_0 * dpx_7, float dOut_11)
{
    float _S56 = 1.0f / (*dpx_7).primal_0 * dOut_11;
    dpx_7->primal_0 = (*dpx_7).primal_0;
    dpx_7->differential_0 = _S56;
    return;
}

inline __device__ void _d_lerp_0(DiffPair_float_0 * dpx_8, DiffPair_float_0 * dpy_3, DiffPair_float_0 * dps_0, float dOut_12)
{
    float _S57 = (1.0f - (*dps_0).primal_0) * dOut_12;
    dpx_8->primal_0 = (*dpx_8).primal_0;
    dpx_8->differential_0 = _S57;
    DiffPair_float_0 _S58 = *dpy_3;
    float _S59 = (*dps_0).primal_0 * dOut_12;
    dpy_3->primal_0 = (*dpy_3).primal_0;
    dpy_3->differential_0 = _S59;
    float _S60 = (_S58.primal_0 - (*dpx_8).primal_0) * dOut_12;
    dps_0->primal_0 = _S58.primal_0;
    dps_0->differential_0 = _S60;
    return;
}

inline __device__ float lerp_0(float x_5, float y_3, float s_0)
{
    return x_5 + (y_3 - x_5) * s_0;
}

inline __device__ void _d_pow_0(DiffPair_float_0 * dpx_9, DiffPair_float_0 * dpy_4, float dOut_13)
{
    if(((*dpx_9).primal_0) < 9.99999997475242708e-07f)
    {
        dpx_9->primal_0 = (*dpx_9).primal_0;
        dpx_9->differential_0 = 0.0f;
        dpy_4->primal_0 = (*dpy_4).primal_0;
        dpy_4->differential_0 = 0.0f;
    }
    else
    {
        float val_0 = (F32_pow(((*dpx_9).primal_0), ((*dpy_4).primal_0)));
        DiffPair_float_0 _S61 = *dpx_9;
        float _S62 = val_0 * (*dpy_4).primal_0 / (*dpx_9).primal_0 * dOut_13;
        dpx_9->primal_0 = (*dpx_9).primal_0;
        dpx_9->differential_0 = _S62;
        float _S63 = val_0 * (F32_log((_S61.primal_0))) * dOut_13;
        dpy_4->primal_0 = (*dpy_4).primal_0;
        dpy_4->differential_0 = _S63;
    }
    return;
}

inline __device__ float3  apply_ppisp(float3  rgb_in_0, float2  pix_coord_0, float2  image_center_0, float2  img_size_0, FixedArray<float, 36>  params_0)
{
    PPISPParams_0 p_0;
    (&p_0)->exposure_3 = params_0[int(0)];
    (&(&p_0)->vignette_params_2[int(0)])->cx_0 = params_0[int(1)];
    (&(&p_0)->vignette_params_2[int(0)])->cy_0 = params_0[int(2)];
    (&(&p_0)->vignette_params_2[int(0)])->alpha0_0 = params_0[int(3)];
    (&(&p_0)->vignette_params_2[int(0)])->alpha1_0 = params_0[int(4)];
    (&(&p_0)->vignette_params_2[int(0)])->alpha2_0 = params_0[int(5)];
    (&(&p_0)->vignette_params_2[int(1)])->cx_0 = params_0[int(6)];
    (&(&p_0)->vignette_params_2[int(1)])->cy_0 = params_0[int(7)];
    (&(&p_0)->vignette_params_2[int(1)])->alpha0_0 = params_0[int(8)];
    (&(&p_0)->vignette_params_2[int(1)])->alpha1_0 = params_0[int(9)];
    (&(&p_0)->vignette_params_2[int(1)])->alpha2_0 = params_0[int(10)];
    (&(&p_0)->vignette_params_2[int(2)])->cx_0 = params_0[int(11)];
    (&(&p_0)->vignette_params_2[int(2)])->cy_0 = params_0[int(12)];
    (&(&p_0)->vignette_params_2[int(2)])->alpha0_0 = params_0[int(13)];
    (&(&p_0)->vignette_params_2[int(2)])->alpha1_0 = params_0[int(14)];
    (&(&p_0)->vignette_params_2[int(2)])->alpha2_0 = params_0[int(15)];
    *&((&(&(&p_0)->color_params_3)->b_0)->x) = params_0[int(16)];
    *&((&(&(&p_0)->color_params_3)->b_0)->y) = params_0[int(17)];
    *&((&(&(&p_0)->color_params_3)->r_0)->x) = params_0[int(18)];
    *&((&(&(&p_0)->color_params_3)->r_0)->y) = params_0[int(19)];
    *&((&(&(&p_0)->color_params_3)->g_0)->x) = params_0[int(20)];
    *&((&(&(&p_0)->color_params_3)->g_0)->y) = params_0[int(21)];
    *&((&(&(&p_0)->color_params_3)->n_0)->x) = params_0[int(22)];
    *&((&(&(&p_0)->color_params_3)->n_0)->y) = params_0[int(23)];
    (&(&p_0)->crf_params_1[int(0)])->toe_0 = params_0[int(24)];
    (&(&p_0)->crf_params_1[int(0)])->shoulder_0 = params_0[int(25)];
    (&(&p_0)->crf_params_1[int(0)])->gamma_0 = params_0[int(26)];
    (&(&p_0)->crf_params_1[int(0)])->center_0 = params_0[int(27)];
    (&(&p_0)->crf_params_1[int(1)])->toe_0 = params_0[int(28)];
    (&(&p_0)->crf_params_1[int(1)])->shoulder_0 = params_0[int(29)];
    (&(&p_0)->crf_params_1[int(1)])->gamma_0 = params_0[int(30)];
    (&(&p_0)->crf_params_1[int(1)])->center_0 = params_0[int(31)];
    (&(&p_0)->crf_params_1[int(2)])->toe_0 = params_0[int(32)];
    (&(&p_0)->crf_params_1[int(2)])->shoulder_0 = params_0[int(33)];
    (&(&p_0)->crf_params_1[int(2)])->gamma_0 = params_0[int(34)];
    (&(&p_0)->crf_params_1[int(2)])->center_0 = params_0[int(35)];
    PPISPParams_0 _S64 = p_0;
    float _S65 = (F32_max((img_size_0.x), (img_size_0.y)));
    float _S66 = (pix_coord_0.x - image_center_0.x) / _S65;
    float _S67 = (pix_coord_0.y - image_center_0.y) / _S65;
    float3  rgb_out_0 = rgb_in_0 * make_float3 ((F32_exp2((p_0.exposure_3))));
    float dx_0 = _S66 - p_0.vignette_params_2[int(0)].cx_0;
    float dy_0 = _S67 - p_0.vignette_params_2[int(0)].cy_0;
    float r2_0 = dx_0 * dx_0 + dy_0 * dy_0;
    float r4_0 = r2_0 * r2_0;
    *&((&rgb_out_0)->x) = *&((&rgb_out_0)->x) * clamp_0(p_0.vignette_params_2[int(0)].alpha2_0 * (r4_0 * r2_0) + p_0.vignette_params_2[int(0)].alpha1_0 * r4_0 + p_0.vignette_params_2[int(0)].alpha0_0 * r2_0 + 1.0f, 0.0f, 1.0f);
    float dx_1 = _S66 - p_0.vignette_params_2[int(1)].cx_0;
    float dy_1 = _S67 - p_0.vignette_params_2[int(1)].cy_0;
    float r2_1 = dx_1 * dx_1 + dy_1 * dy_1;
    float r4_1 = r2_1 * r2_1;
    *&((&rgb_out_0)->y) = *&((&rgb_out_0)->y) * clamp_0(p_0.vignette_params_2[int(1)].alpha2_0 * (r4_1 * r2_1) + p_0.vignette_params_2[int(1)].alpha1_0 * r4_1 + p_0.vignette_params_2[int(1)].alpha0_0 * r2_1 + 1.0f, 0.0f, 1.0f);
    float dx_2 = _S66 - p_0.vignette_params_2[int(2)].cx_0;
    float dy_2 = _S67 - p_0.vignette_params_2[int(2)].cy_0;
    float r2_2 = dx_2 * dx_2 + dy_2 * dy_2;
    float r4_2 = r2_2 * r2_2;
    *&((&rgb_out_0)->z) = *&((&rgb_out_0)->z) * clamp_0(p_0.vignette_params_2[int(2)].alpha2_0 * (r4_2 * r2_2) + p_0.vignette_params_2[int(2)].alpha1_0 * r4_2 + p_0.vignette_params_2[int(2)].alpha0_0 * r2_2 + 1.0f, 0.0f, 1.0f);
    float3  _S68 = rgb_out_0;
    float2  bd_0 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), p_0.color_params_3.b_0);
    float2  rd_0 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), p_0.color_params_3.r_0);
    float2  gd_0 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), p_0.color_params_3.g_0);
    float2  nd_0 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), p_0.color_params_3.n_0);
    float _S69 = 0.3333333432674408f + nd_0.x;
    float _S70 = 0.3333333432674408f + nd_0.y;
    Matrix<float, 3, 3>  T_0 = makeMatrix<float, 3, 3> (bd_0.x, 1.0f + rd_0.x, gd_0.x, bd_0.y, rd_0.y, 1.0f + gd_0.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  M_0 = mul_3(makeMatrix<float, 3, 3> (0.0f, -1.0f, _S70, 1.0f, 0.0f, - _S69, - _S70, _S69, 0.0f), T_0);
    float3  r0_0 = make_float3 (M_0.rows[int(0)].x, M_0.rows[int(0)].y, M_0.rows[int(0)].z);
    float3  r1_0 = make_float3 (M_0.rows[int(1)].x, M_0.rows[int(1)].y, M_0.rows[int(1)].z);
    float3  r2_3 = make_float3 (M_0.rows[int(2)].x, M_0.rows[int(2)].y, M_0.rows[int(2)].z);
    float3  lambda_v_0 = cross_0(r0_0, r1_0);
    float3  lambda_v_1;
    if((dot_0(lambda_v_0, lambda_v_0)) < 9.99999968265522539e-21f)
    {
        float3  lambda_v_2 = cross_0(r0_0, r2_3);
        if((dot_0(lambda_v_2, lambda_v_2)) < 9.99999968265522539e-21f)
        {
            lambda_v_1 = cross_0(r1_0, r2_3);
        }
        else
        {
            lambda_v_1 = lambda_v_2;
        }
    }
    else
    {
        lambda_v_1 = lambda_v_0;
    }
    Matrix<float, 3, 3>  H_0 = mul_3(mul_3(T_0, makeMatrix<float, 3, 3> (lambda_v_1.x, 0.0f, 0.0f, 0.0f, lambda_v_1.y, 0.0f, 0.0f, 0.0f, lambda_v_1.z)), makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f));
    Matrix<float, 3, 3>  H_1;
    if((F32_abs((H_0.rows[int(2)].z))) > 9.99999968265522539e-21f)
    {
        H_1 = H_0 * makeMatrix<float, 3, 3> (1.0f / H_0.rows[int(2)].z);
    }
    else
    {
        H_1 = H_0;
    }
    float _S71 = _S68.x;
    float _S72 = _S68.y;
    float intensity_0 = _S71 + _S72 + _S68.z;
    float3  rgi_out_0 = mul_1(H_1, make_float3 (_S71, _S72, intensity_0));
    float norm_factor_0 = intensity_0 / (F32_max((rgi_out_0.z), (0.00009999999747379f * (F32_abs((intensity_0))) + 9.99999993922529029e-09f)));
    float out_r_0 = rgi_out_0.x * norm_factor_0;
    float out_g_0 = rgi_out_0.y * norm_factor_0;
    float3  _S73 = clamp_1(make_float3 (out_r_0, out_g_0, intensity_0 - out_r_0 - out_g_0), make_float3 (0.0f), make_float3 (1.0f));
    float3  rgb_out_1;
    float _S74 = _S73.x;
    float _S75 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(0)].toe_0))))));
    float _S76 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(0)].shoulder_0))))));
    float _S77 = 0.10000000149011612f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(0)].gamma_0))))));
    float _S78 = 1.0f / (1.0f + (F32_exp((- _S64.crf_params_1[int(0)].center_0))));
    float a_1 = _S76 * _S78 / lerp_0(_S75, _S76, _S78);
    float b_2 = 1.0f - a_1;
    float y_4;
    if(_S74 <= _S78)
    {
        y_4 = a_1 * (F32_pow((_S74 / _S78), (_S75)));
    }
    else
    {
        y_4 = 1.0f - b_2 * (F32_pow(((1.0f - _S74) / (1.0f - _S78)), (_S76)));
    }
    *&((&rgb_out_1)->x) = (F32_pow(((F32_max((0.0f), (y_4)))), (_S77)));
    float _S79 = _S73.y;
    float _S80 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(1)].toe_0))))));
    float _S81 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(1)].shoulder_0))))));
    float _S82 = 0.10000000149011612f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(1)].gamma_0))))));
    float _S83 = 1.0f / (1.0f + (F32_exp((- _S64.crf_params_1[int(1)].center_0))));
    float a_2 = _S81 * _S83 / lerp_0(_S80, _S81, _S83);
    float b_3 = 1.0f - a_2;
    if(_S79 <= _S83)
    {
        y_4 = a_2 * (F32_pow((_S79 / _S83), (_S80)));
    }
    else
    {
        y_4 = 1.0f - b_3 * (F32_pow(((1.0f - _S79) / (1.0f - _S83)), (_S81)));
    }
    *&((&rgb_out_1)->y) = (F32_pow(((F32_max((0.0f), (y_4)))), (_S82)));
    float _S84 = _S73.z;
    float _S85 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(2)].toe_0))))));
    float _S86 = 0.30000001192092896f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(2)].shoulder_0))))));
    float _S87 = 0.10000000149011612f + (F32_log((1.0f + (F32_exp((_S64.crf_params_1[int(2)].gamma_0))))));
    float _S88 = 1.0f / (1.0f + (F32_exp((- _S64.crf_params_1[int(2)].center_0))));
    float a_3 = _S86 * _S88 / lerp_0(_S85, _S86, _S88);
    float b_4 = 1.0f - a_3;
    if(_S84 <= _S88)
    {
        y_4 = a_3 * (F32_pow((_S84 / _S88), (_S85)));
    }
    else
    {
        y_4 = 1.0f - b_4 * (F32_pow(((1.0f - _S84) / (1.0f - _S88)), (_S86)));
    }
    *&((&rgb_out_1)->z) = (F32_pow(((F32_max((0.0f), (y_4)))), (_S87)));
    return rgb_out_1;
}

inline __device__ float3  apply_ppisp_rqs(float3  rgb_in_1, float2  pix_coord_1, float2  image_center_1, float2  img_size_1, FixedArray<float, 39>  params_1)
{
    PPISPParamsRQS_0 p_1;
    (&p_1)->exposure_2 = params_1[int(0)];
    (&(&p_1)->vignette_params_1[int(0)])->cx_0 = params_1[int(1)];
    (&(&p_1)->vignette_params_1[int(0)])->cy_0 = params_1[int(2)];
    (&(&p_1)->vignette_params_1[int(0)])->alpha0_0 = params_1[int(3)];
    (&(&p_1)->vignette_params_1[int(0)])->alpha1_0 = params_1[int(4)];
    (&(&p_1)->vignette_params_1[int(0)])->alpha2_0 = params_1[int(5)];
    (&(&p_1)->vignette_params_1[int(1)])->cx_0 = params_1[int(6)];
    (&(&p_1)->vignette_params_1[int(1)])->cy_0 = params_1[int(7)];
    (&(&p_1)->vignette_params_1[int(1)])->alpha0_0 = params_1[int(8)];
    (&(&p_1)->vignette_params_1[int(1)])->alpha1_0 = params_1[int(9)];
    (&(&p_1)->vignette_params_1[int(1)])->alpha2_0 = params_1[int(10)];
    (&(&p_1)->vignette_params_1[int(2)])->cx_0 = params_1[int(11)];
    (&(&p_1)->vignette_params_1[int(2)])->cy_0 = params_1[int(12)];
    (&(&p_1)->vignette_params_1[int(2)])->alpha0_0 = params_1[int(13)];
    (&(&p_1)->vignette_params_1[int(2)])->alpha1_0 = params_1[int(14)];
    (&(&p_1)->vignette_params_1[int(2)])->alpha2_0 = params_1[int(15)];
    *&((&(&(&p_1)->color_params_2)->b_0)->x) = params_1[int(16)];
    *&((&(&(&p_1)->color_params_2)->b_0)->y) = params_1[int(17)];
    *&((&(&(&p_1)->color_params_2)->r_0)->x) = params_1[int(18)];
    *&((&(&(&p_1)->color_params_2)->r_0)->y) = params_1[int(19)];
    *&((&(&(&p_1)->color_params_2)->g_0)->x) = params_1[int(20)];
    *&((&(&(&p_1)->color_params_2)->g_0)->y) = params_1[int(21)];
    *&((&(&(&p_1)->color_params_2)->n_0)->x) = params_1[int(22)];
    *&((&(&(&p_1)->color_params_2)->n_0)->y) = params_1[int(23)];
    (&(&p_1)->crf_params_0[int(0)])->g0_0 = params_1[int(24)];
    (&(&p_1)->crf_params_0[int(0)])->g1_0 = params_1[int(25)];
    (&(&p_1)->crf_params_0[int(0)])->x0_0 = params_1[int(26)];
    (&(&p_1)->crf_params_0[int(0)])->y0_0 = params_1[int(27)];
    (&(&p_1)->crf_params_0[int(0)])->gc_0 = params_1[int(28)];
    (&(&p_1)->crf_params_0[int(1)])->g0_0 = params_1[int(29)];
    (&(&p_1)->crf_params_0[int(1)])->g1_0 = params_1[int(30)];
    (&(&p_1)->crf_params_0[int(1)])->x0_0 = params_1[int(31)];
    (&(&p_1)->crf_params_0[int(1)])->y0_0 = params_1[int(32)];
    (&(&p_1)->crf_params_0[int(1)])->gc_0 = params_1[int(33)];
    (&(&p_1)->crf_params_0[int(2)])->g0_0 = params_1[int(34)];
    (&(&p_1)->crf_params_0[int(2)])->g1_0 = params_1[int(35)];
    (&(&p_1)->crf_params_0[int(2)])->x0_0 = params_1[int(36)];
    (&(&p_1)->crf_params_0[int(2)])->y0_0 = params_1[int(37)];
    (&(&p_1)->crf_params_0[int(2)])->gc_0 = params_1[int(38)];
    PPISPParamsRQS_0 _S89 = p_1;
    float _S90 = (F32_max((img_size_1.x), (img_size_1.y)));
    float _S91 = (pix_coord_1.x - image_center_1.x) / _S90;
    float _S92 = (pix_coord_1.y - image_center_1.y) / _S90;
    float3  rgb_out_2 = rgb_in_1 * make_float3 ((F32_exp2((p_1.exposure_2))));
    float dx_3 = _S91 - p_1.vignette_params_1[int(0)].cx_0;
    float dy_3 = _S92 - p_1.vignette_params_1[int(0)].cy_0;
    float r2_4 = dx_3 * dx_3 + dy_3 * dy_3;
    float r4_3 = r2_4 * r2_4;
    *&((&rgb_out_2)->x) = *&((&rgb_out_2)->x) * clamp_0(p_1.vignette_params_1[int(0)].alpha2_0 * (r4_3 * r2_4) + p_1.vignette_params_1[int(0)].alpha1_0 * r4_3 + p_1.vignette_params_1[int(0)].alpha0_0 * r2_4 + 1.0f, 0.0f, 1.0f);
    float dx_4 = _S91 - p_1.vignette_params_1[int(1)].cx_0;
    float dy_4 = _S92 - p_1.vignette_params_1[int(1)].cy_0;
    float r2_5 = dx_4 * dx_4 + dy_4 * dy_4;
    float r4_4 = r2_5 * r2_5;
    *&((&rgb_out_2)->y) = *&((&rgb_out_2)->y) * clamp_0(p_1.vignette_params_1[int(1)].alpha2_0 * (r4_4 * r2_5) + p_1.vignette_params_1[int(1)].alpha1_0 * r4_4 + p_1.vignette_params_1[int(1)].alpha0_0 * r2_5 + 1.0f, 0.0f, 1.0f);
    float dx_5 = _S91 - p_1.vignette_params_1[int(2)].cx_0;
    float dy_5 = _S92 - p_1.vignette_params_1[int(2)].cy_0;
    float r2_6 = dx_5 * dx_5 + dy_5 * dy_5;
    float r4_5 = r2_6 * r2_6;
    *&((&rgb_out_2)->z) = *&((&rgb_out_2)->z) * clamp_0(p_1.vignette_params_1[int(2)].alpha2_0 * (r4_5 * r2_6) + p_1.vignette_params_1[int(2)].alpha1_0 * r4_5 + p_1.vignette_params_1[int(2)].alpha0_0 * r2_6 + 1.0f, 0.0f, 1.0f);
    float3  _S93 = rgb_out_2;
    float2  bd_1 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), p_1.color_params_2.b_0);
    float2  rd_1 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), p_1.color_params_2.r_0);
    float2  gd_1 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), p_1.color_params_2.g_0);
    float2  nd_1 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), p_1.color_params_2.n_0);
    float _S94 = 0.3333333432674408f + nd_1.x;
    float _S95 = 0.3333333432674408f + nd_1.y;
    Matrix<float, 3, 3>  T_1 = makeMatrix<float, 3, 3> (bd_1.x, 1.0f + rd_1.x, gd_1.x, bd_1.y, rd_1.y, 1.0f + gd_1.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  M_1 = mul_3(makeMatrix<float, 3, 3> (0.0f, -1.0f, _S95, 1.0f, 0.0f, - _S94, - _S95, _S94, 0.0f), T_1);
    float3  r0_1 = make_float3 (M_1.rows[int(0)].x, M_1.rows[int(0)].y, M_1.rows[int(0)].z);
    float3  r1_1 = make_float3 (M_1.rows[int(1)].x, M_1.rows[int(1)].y, M_1.rows[int(1)].z);
    float3  r2_7 = make_float3 (M_1.rows[int(2)].x, M_1.rows[int(2)].y, M_1.rows[int(2)].z);
    float3  lambda_v_3 = cross_0(r0_1, r1_1);
    float3  lambda_v_4;
    if((dot_0(lambda_v_3, lambda_v_3)) < 9.99999968265522539e-21f)
    {
        float3  lambda_v_5 = cross_0(r0_1, r2_7);
        if((dot_0(lambda_v_5, lambda_v_5)) < 9.99999968265522539e-21f)
        {
            lambda_v_4 = cross_0(r1_1, r2_7);
        }
        else
        {
            lambda_v_4 = lambda_v_5;
        }
    }
    else
    {
        lambda_v_4 = lambda_v_3;
    }
    Matrix<float, 3, 3>  H_2 = mul_3(mul_3(T_1, makeMatrix<float, 3, 3> (lambda_v_4.x, 0.0f, 0.0f, 0.0f, lambda_v_4.y, 0.0f, 0.0f, 0.0f, lambda_v_4.z)), makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f));
    Matrix<float, 3, 3>  H_3;
    if((F32_abs((H_2.rows[int(2)].z))) > 9.99999968265522539e-21f)
    {
        H_3 = H_2 * makeMatrix<float, 3, 3> (1.0f / H_2.rows[int(2)].z);
    }
    else
    {
        H_3 = H_2;
    }
    float _S96 = _S93.x;
    float _S97 = _S93.y;
    float intensity_1 = _S96 + _S97 + _S93.z;
    float3  rgi_out_1 = mul_1(H_3, make_float3 (_S96, _S97, intensity_1));
    float norm_factor_1 = intensity_1 / (F32_max((rgi_out_1.z), (0.00009999999747379f * (F32_abs((intensity_1))) + 9.99999993922529029e-09f)));
    float out_r_1 = rgi_out_1.x * norm_factor_1;
    float out_g_1 = rgi_out_1.y * norm_factor_1;
    float3  _S98 = clamp_1(make_float3 (out_r_1, out_g_1, intensity_1 - out_r_1 - out_g_1), make_float3 (0.0f), make_float3 (1.0f));
    float3  rgb_out_3;
    float _S99 = _S98.x;
    float g0_1 = (F32_exp((_S89.crf_params_0[int(0)].g0_0)));
    float g1_1 = (F32_exp((_S89.crf_params_0[int(0)].g1_0)));
    float x0_1 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(0)].x0_0))));
    float y0_1 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(0)].y0_0))));
    float gc_1 = (F32_exp((_S89.crf_params_0[int(0)].gc_0)));
    float y_5;
    if(_S99 < x0_1)
    {
        float s0_0 = y0_1 / x0_1;
        float t0_0 = _S99 / x0_1;
        float _S100 = 1.0f - t0_0;
        y_5 = y0_1 * (s0_0 * t0_0 * t0_0 + g0_1 * t0_0 * _S100) / (s0_0 + (g0_1 + gc_1 - 2.0f * s0_0) * t0_0 * _S100);
    }
    else
    {
        float _S101 = 1.0f - y0_1;
        float _S102 = 1.0f - x0_1;
        float s1_0 = _S101 / _S102;
        float t1_0 = (_S99 - x0_1) / _S102;
        float _S103 = 1.0f - t1_0;
        y_5 = y0_1 + _S101 * (s1_0 * t1_0 * t1_0 + gc_1 * t1_0 * _S103) / (s1_0 + (gc_1 + g1_1 - 2.0f * s1_0) * t1_0 * _S103);
    }
    *&((&rgb_out_3)->x) = y_5;
    float _S104 = _S98.y;
    float g0_2 = (F32_exp((_S89.crf_params_0[int(1)].g0_0)));
    float g1_2 = (F32_exp((_S89.crf_params_0[int(1)].g1_0)));
    float x0_2 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(1)].x0_0))));
    float y0_2 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(1)].y0_0))));
    float gc_2 = (F32_exp((_S89.crf_params_0[int(1)].gc_0)));
    if(_S104 < x0_2)
    {
        float s0_1 = y0_2 / x0_2;
        float t0_1 = _S104 / x0_2;
        float _S105 = 1.0f - t0_1;
        y_5 = y0_2 * (s0_1 * t0_1 * t0_1 + g0_2 * t0_1 * _S105) / (s0_1 + (g0_2 + gc_2 - 2.0f * s0_1) * t0_1 * _S105);
    }
    else
    {
        float _S106 = 1.0f - y0_2;
        float _S107 = 1.0f - x0_2;
        float s1_1 = _S106 / _S107;
        float t1_1 = (_S104 - x0_2) / _S107;
        float _S108 = 1.0f - t1_1;
        y_5 = y0_2 + _S106 * (s1_1 * t1_1 * t1_1 + gc_2 * t1_1 * _S108) / (s1_1 + (gc_2 + g1_2 - 2.0f * s1_1) * t1_1 * _S108);
    }
    *&((&rgb_out_3)->y) = y_5;
    float _S109 = _S98.z;
    float g0_3 = (F32_exp((_S89.crf_params_0[int(2)].g0_0)));
    float g1_3 = (F32_exp((_S89.crf_params_0[int(2)].g1_0)));
    float x0_3 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(2)].x0_0))));
    float y0_3 = 1.0f / (1.0f + (F32_exp((- _S89.crf_params_0[int(2)].y0_0))));
    float gc_3 = (F32_exp((_S89.crf_params_0[int(2)].gc_0)));
    if(_S109 < x0_3)
    {
        float s0_2 = y0_3 / x0_3;
        float t0_2 = _S109 / x0_3;
        float _S110 = 1.0f - t0_2;
        y_5 = y0_3 * (s0_2 * t0_2 * t0_2 + g0_3 * t0_2 * _S110) / (s0_2 + (g0_3 + gc_3 - 2.0f * s0_2) * t0_2 * _S110);
    }
    else
    {
        float _S111 = 1.0f - y0_3;
        float _S112 = 1.0f - x0_3;
        float s1_2 = _S111 / _S112;
        float t1_2 = (_S109 - x0_3) / _S112;
        float _S113 = 1.0f - t1_2;
        y_5 = y0_3 + _S111 * (s1_2 * t1_2 * t1_2 + gc_3 * t1_2 * _S113) / (s1_2 + (gc_3 + g1_3 - 2.0f * s1_2) * t1_2 * _S113);
    }
    *&((&rgb_out_3)->z) = y_5;
    return rgb_out_3;
}

inline __device__ float3  apply_ppisp_no_crf(float3  rgb_in_2, float2  pix_coord_2, float2  image_center_2, float2  img_size_2, FixedArray<float, 24>  params_2, bool clamp_output_0)
{
    PPISPParamsNoCRF_0 p_2;
    (&p_2)->exposure_1 = params_2[int(0)];
    (&(&p_2)->vignette_params_0[int(0)])->cx_0 = params_2[int(1)];
    (&(&p_2)->vignette_params_0[int(0)])->cy_0 = params_2[int(2)];
    (&(&p_2)->vignette_params_0[int(0)])->alpha0_0 = params_2[int(3)];
    (&(&p_2)->vignette_params_0[int(0)])->alpha1_0 = params_2[int(4)];
    (&(&p_2)->vignette_params_0[int(0)])->alpha2_0 = params_2[int(5)];
    (&(&p_2)->vignette_params_0[int(1)])->cx_0 = params_2[int(6)];
    (&(&p_2)->vignette_params_0[int(1)])->cy_0 = params_2[int(7)];
    (&(&p_2)->vignette_params_0[int(1)])->alpha0_0 = params_2[int(8)];
    (&(&p_2)->vignette_params_0[int(1)])->alpha1_0 = params_2[int(9)];
    (&(&p_2)->vignette_params_0[int(1)])->alpha2_0 = params_2[int(10)];
    (&(&p_2)->vignette_params_0[int(2)])->cx_0 = params_2[int(11)];
    (&(&p_2)->vignette_params_0[int(2)])->cy_0 = params_2[int(12)];
    (&(&p_2)->vignette_params_0[int(2)])->alpha0_0 = params_2[int(13)];
    (&(&p_2)->vignette_params_0[int(2)])->alpha1_0 = params_2[int(14)];
    (&(&p_2)->vignette_params_0[int(2)])->alpha2_0 = params_2[int(15)];
    *&((&(&(&p_2)->color_params_1)->b_0)->x) = params_2[int(16)];
    *&((&(&(&p_2)->color_params_1)->b_0)->y) = params_2[int(17)];
    *&((&(&(&p_2)->color_params_1)->r_0)->x) = params_2[int(18)];
    *&((&(&(&p_2)->color_params_1)->r_0)->y) = params_2[int(19)];
    *&((&(&(&p_2)->color_params_1)->g_0)->x) = params_2[int(20)];
    *&((&(&(&p_2)->color_params_1)->g_0)->y) = params_2[int(21)];
    *&((&(&(&p_2)->color_params_1)->n_0)->x) = params_2[int(22)];
    *&((&(&(&p_2)->color_params_1)->n_0)->y) = params_2[int(23)];
    float _S114 = (F32_max((img_size_2.x), (img_size_2.y)));
    float _S115 = (pix_coord_2.x - image_center_2.x) / _S114;
    float _S116 = (pix_coord_2.y - image_center_2.y) / _S114;
    float3  rgb_out_4 = rgb_in_2 * make_float3 ((F32_exp2((p_2.exposure_1))));
    float dx_6 = _S115 - p_2.vignette_params_0[int(0)].cx_0;
    float dy_6 = _S116 - p_2.vignette_params_0[int(0)].cy_0;
    float r2_8 = dx_6 * dx_6 + dy_6 * dy_6;
    float r4_6 = r2_8 * r2_8;
    *&((&rgb_out_4)->x) = *&((&rgb_out_4)->x) * clamp_0(p_2.vignette_params_0[int(0)].alpha2_0 * (r4_6 * r2_8) + p_2.vignette_params_0[int(0)].alpha1_0 * r4_6 + p_2.vignette_params_0[int(0)].alpha0_0 * r2_8 + 1.0f, 0.0f, 1.0f);
    float dx_7 = _S115 - p_2.vignette_params_0[int(1)].cx_0;
    float dy_7 = _S116 - p_2.vignette_params_0[int(1)].cy_0;
    float r2_9 = dx_7 * dx_7 + dy_7 * dy_7;
    float r4_7 = r2_9 * r2_9;
    *&((&rgb_out_4)->y) = *&((&rgb_out_4)->y) * clamp_0(p_2.vignette_params_0[int(1)].alpha2_0 * (r4_7 * r2_9) + p_2.vignette_params_0[int(1)].alpha1_0 * r4_7 + p_2.vignette_params_0[int(1)].alpha0_0 * r2_9 + 1.0f, 0.0f, 1.0f);
    float dx_8 = _S115 - p_2.vignette_params_0[int(2)].cx_0;
    float dy_8 = _S116 - p_2.vignette_params_0[int(2)].cy_0;
    float r2_10 = dx_8 * dx_8 + dy_8 * dy_8;
    float r4_8 = r2_10 * r2_10;
    *&((&rgb_out_4)->z) = *&((&rgb_out_4)->z) * clamp_0(p_2.vignette_params_0[int(2)].alpha2_0 * (r4_8 * r2_10) + p_2.vignette_params_0[int(2)].alpha1_0 * r4_8 + p_2.vignette_params_0[int(2)].alpha0_0 * r2_10 + 1.0f, 0.0f, 1.0f);
    float3  _S117 = rgb_out_4;
    float2  bd_2 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), p_2.color_params_1.b_0);
    float2  rd_2 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), p_2.color_params_1.r_0);
    float2  gd_2 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), p_2.color_params_1.g_0);
    float2  nd_2 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), p_2.color_params_1.n_0);
    float _S118 = 0.3333333432674408f + nd_2.x;
    float _S119 = 0.3333333432674408f + nd_2.y;
    Matrix<float, 3, 3>  T_2 = makeMatrix<float, 3, 3> (bd_2.x, 1.0f + rd_2.x, gd_2.x, bd_2.y, rd_2.y, 1.0f + gd_2.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  M_2 = mul_3(makeMatrix<float, 3, 3> (0.0f, -1.0f, _S119, 1.0f, 0.0f, - _S118, - _S119, _S118, 0.0f), T_2);
    float3  r0_2 = make_float3 (M_2.rows[int(0)].x, M_2.rows[int(0)].y, M_2.rows[int(0)].z);
    float3  r1_2 = make_float3 (M_2.rows[int(1)].x, M_2.rows[int(1)].y, M_2.rows[int(1)].z);
    float3  r2_11 = make_float3 (M_2.rows[int(2)].x, M_2.rows[int(2)].y, M_2.rows[int(2)].z);
    float3  lambda_v_6 = cross_0(r0_2, r1_2);
    float3  lambda_v_7;
    if((dot_0(lambda_v_6, lambda_v_6)) < 9.99999968265522539e-21f)
    {
        float3  lambda_v_8 = cross_0(r0_2, r2_11);
        if((dot_0(lambda_v_8, lambda_v_8)) < 9.99999968265522539e-21f)
        {
            lambda_v_7 = cross_0(r1_2, r2_11);
        }
        else
        {
            lambda_v_7 = lambda_v_8;
        }
    }
    else
    {
        lambda_v_7 = lambda_v_6;
    }
    Matrix<float, 3, 3>  H_4 = mul_3(mul_3(T_2, makeMatrix<float, 3, 3> (lambda_v_7.x, 0.0f, 0.0f, 0.0f, lambda_v_7.y, 0.0f, 0.0f, 0.0f, lambda_v_7.z)), makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f));
    Matrix<float, 3, 3>  H_5;
    if((F32_abs((H_4.rows[int(2)].z))) > 9.99999968265522539e-21f)
    {
        H_5 = H_4 * makeMatrix<float, 3, 3> (1.0f / H_4.rows[int(2)].z);
    }
    else
    {
        H_5 = H_4;
    }
    float _S120 = _S117.x;
    float _S121 = _S117.y;
    float intensity_2 = _S120 + _S121 + _S117.z;
    float3  rgi_out_2 = mul_1(H_5, make_float3 (_S120, _S121, intensity_2));
    float norm_factor_2 = intensity_2 / (F32_max((rgi_out_2.z), (0.00009999999747379f * (F32_abs((intensity_2))) + 9.99999993922529029e-09f)));
    float out_r_2 = rgi_out_2.x * norm_factor_2;
    float out_g_2 = rgi_out_2.y * norm_factor_2;
    float3  _S122 = make_float3 (out_r_2, out_g_2, intensity_2 - out_r_2 - out_g_2);
    float3  rgb_0;
    if(clamp_output_0)
    {
        rgb_0 = clamp_1(_S122, make_float3 (0.0f), make_float3 (1.0f));
    }
    else
    {
        rgb_0 = _S122;
    }
    return rgb_0;
}

inline __device__ float3  apply_ppisp_no_crf_no_vig(float3  rgb_in_3, float2  pix_coord_3, float2  image_center_3, float2  img_size_3, FixedArray<float, 9>  params_3, bool clamp_output_1)
{
    PPISPParamsNoCRFNoVig_0 p_3;
    (&p_3)->exposure_0 = params_3[int(0)];
    *&((&(&(&p_3)->color_params_0)->b_0)->x) = params_3[int(1)];
    *&((&(&(&p_3)->color_params_0)->b_0)->y) = params_3[int(2)];
    *&((&(&(&p_3)->color_params_0)->r_0)->x) = params_3[int(3)];
    *&((&(&(&p_3)->color_params_0)->r_0)->y) = params_3[int(4)];
    *&((&(&(&p_3)->color_params_0)->g_0)->x) = params_3[int(5)];
    *&((&(&(&p_3)->color_params_0)->g_0)->y) = params_3[int(6)];
    *&((&(&(&p_3)->color_params_0)->n_0)->x) = params_3[int(7)];
    *&((&(&(&p_3)->color_params_0)->n_0)->y) = params_3[int(8)];
    float3  _S123 = rgb_in_3 * make_float3 ((F32_exp2((p_3.exposure_0))));
    float2  bd_3 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), p_3.color_params_0.b_0);
    float2  rd_3 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), p_3.color_params_0.r_0);
    float2  gd_3 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), p_3.color_params_0.g_0);
    float2  nd_3 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), p_3.color_params_0.n_0);
    float _S124 = 0.3333333432674408f + nd_3.x;
    float _S125 = 0.3333333432674408f + nd_3.y;
    Matrix<float, 3, 3>  T_3 = makeMatrix<float, 3, 3> (bd_3.x, 1.0f + rd_3.x, gd_3.x, bd_3.y, rd_3.y, 1.0f + gd_3.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  M_3 = mul_3(makeMatrix<float, 3, 3> (0.0f, -1.0f, _S125, 1.0f, 0.0f, - _S124, - _S125, _S124, 0.0f), T_3);
    float3  r0_3 = make_float3 (M_3.rows[int(0)].x, M_3.rows[int(0)].y, M_3.rows[int(0)].z);
    float3  r1_3 = make_float3 (M_3.rows[int(1)].x, M_3.rows[int(1)].y, M_3.rows[int(1)].z);
    float3  r2_12 = make_float3 (M_3.rows[int(2)].x, M_3.rows[int(2)].y, M_3.rows[int(2)].z);
    float3  lambda_v_9 = cross_0(r0_3, r1_3);
    float3  lambda_v_10;
    if((dot_0(lambda_v_9, lambda_v_9)) < 9.99999968265522539e-21f)
    {
        float3  lambda_v_11 = cross_0(r0_3, r2_12);
        if((dot_0(lambda_v_11, lambda_v_11)) < 9.99999968265522539e-21f)
        {
            lambda_v_10 = cross_0(r1_3, r2_12);
        }
        else
        {
            lambda_v_10 = lambda_v_11;
        }
    }
    else
    {
        lambda_v_10 = lambda_v_9;
    }
    Matrix<float, 3, 3>  H_6 = mul_3(mul_3(T_3, makeMatrix<float, 3, 3> (lambda_v_10.x, 0.0f, 0.0f, 0.0f, lambda_v_10.y, 0.0f, 0.0f, 0.0f, lambda_v_10.z)), makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f));
    Matrix<float, 3, 3>  H_7;
    if((F32_abs((H_6.rows[int(2)].z))) > 9.99999968265522539e-21f)
    {
        H_7 = H_6 * makeMatrix<float, 3, 3> (1.0f / H_6.rows[int(2)].z);
    }
    else
    {
        H_7 = H_6;
    }
    float _S126 = _S123.x;
    float _S127 = _S123.y;
    float intensity_3 = _S126 + _S127 + _S123.z;
    float3  rgi_out_3 = mul_1(H_7, make_float3 (_S126, _S127, intensity_3));
    float norm_factor_3 = intensity_3 / (F32_max((rgi_out_3.z), (0.00009999999747379f * (F32_abs((intensity_3))) + 9.99999993922529029e-09f)));
    float out_r_3 = rgi_out_3.x * norm_factor_3;
    float out_g_3 = rgi_out_3.y * norm_factor_3;
    float3  _S128 = make_float3 (out_r_3, out_g_3, intensity_3 - out_r_3 - out_g_3);
    float3  rgb_1;
    if(clamp_output_1)
    {
        rgb_1 = clamp_1(_S128, make_float3 (0.0f), make_float3 (1.0f));
    }
    else
    {
        rgb_1 = _S128;
    }
    return rgb_1;
}

struct DiffPair_arrayx3Cfloatx2C36x3E_0
{
    FixedArray<float, 36>  primal_0;
    FixedArray<float, 36>  differential_0;
};

inline __device__ float s_primal_ctx_exp2_0(float _S129)
{
    return (F32_exp2((_S129)));
}

inline __device__ float s_primal_ctx_clamp_0(float _S130, float _S131, float _S132)
{
    return clamp_0(_S130, _S131, _S132);
}

inline __device__ float2  s_primal_ctx_mul_0(Matrix<float, 2, 2>  _S133, float2  _S134)
{
    return mul_0(_S133, _S134);
}

inline __device__ Matrix<float, 3, 3>  s_primal_ctx_mul_1(Matrix<float, 3, 3>  _S135, Matrix<float, 3, 3>  _S136)
{
    return mul_3(_S135, _S136);
}

inline __device__ float3  s_primal_ctx_cross_0(float3  _S137, float3  _S138)
{
    return cross_0(_S137, _S138);
}

inline __device__ float s_primal_ctx_dot_0(float3  _S139, float3  _S140)
{
    return dot_0(_S139, _S140);
}

inline __device__ float s_primal_ctx_abs_0(float _S141)
{
    return (F32_abs((_S141)));
}

inline __device__ float3  s_primal_ctx_mul_2(Matrix<float, 3, 3>  _S142, float3  _S143)
{
    return mul_1(_S142, _S143);
}

inline __device__ float3  s_primal_ctx_clamp_1(float3  _S144, float3  _S145, float3  _S146)
{
    return clamp_1(_S144, _S145, _S146);
}

inline __device__ float s_primal_ctx_exp_0(float _S147)
{
    return (F32_exp((_S147)));
}

inline __device__ float s_primal_ctx_log_0(float _S148)
{
    return (F32_log((_S148)));
}

inline __device__ float s_primal_ctx_lerp_0(float _S149, float _S150, float _S151)
{
    return lerp_0(_S149, _S150, _S151);
}

inline __device__ float s_primal_ctx_pow_0(float _S152, float _S153)
{
    return (F32_pow((_S152), (_S153)));
}

inline __device__ void s_bwd_prop_pow_0(DiffPair_float_0 * _S154, DiffPair_float_0 * _S155, float _S156)
{
    _d_pow_0(_S154, _S155, _S156);
    return;
}

inline __device__ void s_bwd_prop_lerp_0(DiffPair_float_0 * _S157, DiffPair_float_0 * _S158, DiffPair_float_0 * _S159, float _S160)
{
    _d_lerp_0(_S157, _S158, _S159, _S160);
    return;
}

inline __device__ void s_bwd_prop_exp_0(DiffPair_float_0 * _S161, float _S162)
{
    _d_exp_0(_S161, _S162);
    return;
}

inline __device__ void s_bwd_prop_log_0(DiffPair_float_0 * _S163, float _S164)
{
    _d_log_0(_S163, _S164);
    return;
}

inline __device__ void s_bwd_prop_clamp_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S165, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S166, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S167, float3  _S168)
{
    _d_clamp_vector_0(_S165, _S166, _S167, _S168);
    return;
}

inline __device__ void s_bwd_prop_abs_0(DiffPair_float_0 * _S169, float _S170)
{
    _d_abs_0(_S169, _S170);
    return;
}

inline __device__ void s_bwd_prop_mul_0(DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * _S171, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S172, float3  _S173)
{
    _d_mul_1(_S171, _S172, _S173);
    return;
}

inline __device__ void s_bwd_prop_mul_1(DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * _S174, DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 * _S175, Matrix<float, 3, 3>  _S176)
{
    mul_2(_S174, _S175, _S176);
    return;
}

inline __device__ void s_bwd_prop_cross_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S177, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S178, float3  _S179)
{
    _d_cross_0(_S177, _S178, _S179);
    return;
}

inline __device__ void s_bwd_prop_dot_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S180, DiffPair_vectorx3Cfloatx2C3x3E_0 * _S181, float _S182)
{
    _d_dot_0(_S180, _S181, _S182);
    return;
}

inline __device__ void s_bwd_prop_mul_2(DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 * _S183, DiffPair_vectorx3Cfloatx2C2x3E_0 * _S184, float2  _S185)
{
    _d_mul_0(_S183, _S184, _S185);
    return;
}

inline __device__ void s_bwd_prop_clamp_1(DiffPair_float_0 * _S186, DiffPair_float_0 * _S187, DiffPair_float_0 * _S188, float _S189)
{
    _d_clamp_0(_S186, _S187, _S188, _S189);
    return;
}

inline __device__ void s_bwd_prop_exp2_0(DiffPair_float_0 * _S190, float _S191)
{
    _d_exp2_0(_S190, _S191);
    return;
}

inline __device__ void s_bwd_prop_apply_ppisp_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dprgb_in_0, float2  pix_coord_4, float2  image_center_4, float2  img_size_4, DiffPair_arrayx3Cfloatx2C36x3E_0 * dpparams_0, float3  _s_dOut_0)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S192 = *dprgb_in_0;
    float3  _S193 = make_float3 (0.0f);
    Matrix<float, 3, 3>  _S194 = makeMatrix<float, 3, 3> (0.0f);
    VignettingChannelParams_0 _S195 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S196 = {
        _S195, _S195, _S195
    };
    float2  _S197 = make_float2 (0.0f);
    ColorPPISPParams_0 _S198 = { _S197, _S197, _S197, _S197 };
    CRFPPISPChannelParams_0 _S199 = { 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<CRFPPISPChannelParams_0, 3>  _S200 = {
        _S199, _S199, _S199
    };
    PPISPParams_0 _S201;
    (&_S201)->exposure_3 = dpparams_0->primal_0[int(0)];
    (&_S201)->vignette_params_2 = _S196;
    (&_S201)->color_params_3 = _S198;
    (&_S201)->crf_params_1 = _S200;
    (&(&_S201)->vignette_params_2[int(0)])->cx_0 = dpparams_0->primal_0[int(1)];
    (&(&_S201)->vignette_params_2[int(0)])->cy_0 = dpparams_0->primal_0[int(2)];
    float _S202 = dpparams_0->primal_0[int(3)];
    (&(&_S201)->vignette_params_2[int(0)])->alpha0_0 = dpparams_0->primal_0[int(3)];
    float _S203 = dpparams_0->primal_0[int(4)];
    (&(&_S201)->vignette_params_2[int(0)])->alpha1_0 = dpparams_0->primal_0[int(4)];
    float _S204 = dpparams_0->primal_0[int(5)];
    (&(&_S201)->vignette_params_2[int(0)])->alpha2_0 = dpparams_0->primal_0[int(5)];
    (&(&_S201)->vignette_params_2[int(1)])->cx_0 = dpparams_0->primal_0[int(6)];
    (&(&_S201)->vignette_params_2[int(1)])->cy_0 = dpparams_0->primal_0[int(7)];
    float _S205 = dpparams_0->primal_0[int(8)];
    (&(&_S201)->vignette_params_2[int(1)])->alpha0_0 = dpparams_0->primal_0[int(8)];
    float _S206 = dpparams_0->primal_0[int(9)];
    (&(&_S201)->vignette_params_2[int(1)])->alpha1_0 = dpparams_0->primal_0[int(9)];
    float _S207 = dpparams_0->primal_0[int(10)];
    (&(&_S201)->vignette_params_2[int(1)])->alpha2_0 = dpparams_0->primal_0[int(10)];
    (&(&_S201)->vignette_params_2[int(2)])->cx_0 = dpparams_0->primal_0[int(11)];
    (&(&_S201)->vignette_params_2[int(2)])->cy_0 = dpparams_0->primal_0[int(12)];
    float _S208 = dpparams_0->primal_0[int(13)];
    (&(&_S201)->vignette_params_2[int(2)])->alpha0_0 = dpparams_0->primal_0[int(13)];
    float _S209 = dpparams_0->primal_0[int(14)];
    (&(&_S201)->vignette_params_2[int(2)])->alpha1_0 = dpparams_0->primal_0[int(14)];
    float _S210 = dpparams_0->primal_0[int(15)];
    (&(&_S201)->vignette_params_2[int(2)])->alpha2_0 = dpparams_0->primal_0[int(15)];
    *&((&(&(&_S201)->color_params_3)->b_0)->x) = dpparams_0->primal_0[int(16)];
    *&((&(&(&_S201)->color_params_3)->b_0)->y) = dpparams_0->primal_0[int(17)];
    *&((&(&(&_S201)->color_params_3)->r_0)->x) = dpparams_0->primal_0[int(18)];
    *&((&(&(&_S201)->color_params_3)->r_0)->y) = dpparams_0->primal_0[int(19)];
    *&((&(&(&_S201)->color_params_3)->g_0)->x) = dpparams_0->primal_0[int(20)];
    *&((&(&(&_S201)->color_params_3)->g_0)->y) = dpparams_0->primal_0[int(21)];
    *&((&(&(&_S201)->color_params_3)->n_0)->x) = dpparams_0->primal_0[int(22)];
    *&((&(&(&_S201)->color_params_3)->n_0)->y) = dpparams_0->primal_0[int(23)];
    float _S211 = dpparams_0->primal_0[int(24)];
    (&(&_S201)->crf_params_1[int(0)])->toe_0 = dpparams_0->primal_0[int(24)];
    float _S212 = dpparams_0->primal_0[int(25)];
    (&(&_S201)->crf_params_1[int(0)])->shoulder_0 = dpparams_0->primal_0[int(25)];
    float _S213 = dpparams_0->primal_0[int(26)];
    (&(&_S201)->crf_params_1[int(0)])->gamma_0 = dpparams_0->primal_0[int(26)];
    float _S214 = dpparams_0->primal_0[int(27)];
    (&(&_S201)->crf_params_1[int(0)])->center_0 = dpparams_0->primal_0[int(27)];
    float _S215 = dpparams_0->primal_0[int(28)];
    (&(&_S201)->crf_params_1[int(1)])->toe_0 = dpparams_0->primal_0[int(28)];
    float _S216 = dpparams_0->primal_0[int(29)];
    (&(&_S201)->crf_params_1[int(1)])->shoulder_0 = dpparams_0->primal_0[int(29)];
    float _S217 = dpparams_0->primal_0[int(30)];
    (&(&_S201)->crf_params_1[int(1)])->gamma_0 = dpparams_0->primal_0[int(30)];
    float _S218 = dpparams_0->primal_0[int(31)];
    (&(&_S201)->crf_params_1[int(1)])->center_0 = dpparams_0->primal_0[int(31)];
    float _S219 = dpparams_0->primal_0[int(32)];
    (&(&_S201)->crf_params_1[int(2)])->toe_0 = dpparams_0->primal_0[int(32)];
    float _S220 = dpparams_0->primal_0[int(33)];
    (&(&_S201)->crf_params_1[int(2)])->shoulder_0 = dpparams_0->primal_0[int(33)];
    float _S221 = dpparams_0->primal_0[int(34)];
    (&(&_S201)->crf_params_1[int(2)])->gamma_0 = dpparams_0->primal_0[int(34)];
    float _S222 = dpparams_0->primal_0[int(35)];
    (&(&_S201)->crf_params_1[int(2)])->center_0 = dpparams_0->primal_0[int(35)];
    PPISPParams_0 _S223 = _S201;
    float _S224 = s_primal_ctx_exp2_0(_S201.exposure_3);
    float3  _S225 = make_float3 (_S224);
    float3  rgb_out_5 = (*dprgb_in_0).primal_0 * make_float3 (_S224);
    float _S226 = (F32_max((img_size_4.x), (img_size_4.y)));
    float _S227 = (pix_coord_4.x - image_center_4.x) / _S226;
    float _S228 = (pix_coord_4.y - image_center_4.y) / _S226;
    float dx_9 = _S227 - dpparams_0->primal_0[int(1)];
    float dy_9 = _S228 - dpparams_0->primal_0[int(2)];
    float r2_13 = dx_9 * dx_9 + dy_9 * dy_9;
    float r4_9 = r2_13 * r2_13;
    float r6_0 = r4_9 * r2_13;
    float falloff_0 = dpparams_0->primal_0[int(5)] * r6_0 + dpparams_0->primal_0[int(4)] * r4_9 + dpparams_0->primal_0[int(3)] * r2_13 + 1.0f;
    float _S229 = s_primal_ctx_clamp_0(falloff_0, 0.0f, 1.0f);
    float _S230 = rgb_out_5.x * _S229;
    float3  _S231 = rgb_out_5;
    *&((&_S231)->x) = _S230;
    float dx_10 = _S227 - dpparams_0->primal_0[int(6)];
    float dy_10 = _S228 - dpparams_0->primal_0[int(7)];
    float r2_14 = dx_10 * dx_10 + dy_10 * dy_10;
    float r4_10 = r2_14 * r2_14;
    float r6_1 = r4_10 * r2_14;
    float falloff_1 = dpparams_0->primal_0[int(10)] * r6_1 + dpparams_0->primal_0[int(9)] * r4_10 + dpparams_0->primal_0[int(8)] * r2_14 + 1.0f;
    float _S232 = s_primal_ctx_clamp_0(falloff_1, 0.0f, 1.0f);
    *&((&_S231)->y) = rgb_out_5.y * _S232;
    float dx_11 = _S227 - dpparams_0->primal_0[int(11)];
    float dy_11 = _S228 - dpparams_0->primal_0[int(12)];
    float r2_15 = dx_11 * dx_11 + dy_11 * dy_11;
    float r4_11 = r2_15 * r2_15;
    float r6_2 = r4_11 * r2_15;
    float falloff_2 = dpparams_0->primal_0[int(15)] * r6_2 + dpparams_0->primal_0[int(14)] * r4_11 + dpparams_0->primal_0[int(13)] * r2_15 + 1.0f;
    float _S233 = s_primal_ctx_clamp_0(falloff_2, 0.0f, 1.0f);
    *&((&_S231)->z) = rgb_out_5.z * _S233;
    PPISPParams_0 _S234 = _S201;
    float2  _S235 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S201.color_params_3.b_0);
    float2  _S236 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S201.color_params_3.r_0);
    float2  _S237 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S201.color_params_3.g_0);
    float2  _S238 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S201.color_params_3.n_0);
    float _S239 = 0.3333333432674408f + _S238.x;
    float _S240 = 0.3333333432674408f + _S238.y;
    Matrix<float, 3, 3>  T_4 = makeMatrix<float, 3, 3> (_S235.x, 1.0f + _S236.x, _S237.x, _S235.y, _S236.y, 1.0f + _S237.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  skew_0 = makeMatrix<float, 3, 3> (0.0f, -1.0f, _S240, 1.0f, 0.0f, - _S239, - _S240, _S239, 0.0f);
    Matrix<float, 3, 3>  _S241 = s_primal_ctx_mul_1(skew_0, T_4);
    float3  r0_4 = make_float3 (_S241.rows[int(0)].x, _S241.rows[int(0)].y, _S241.rows[int(0)].z);
    float3  r1_4 = make_float3 (_S241.rows[int(1)].x, _S241.rows[int(1)].y, _S241.rows[int(1)].z);
    float3  r2_16 = make_float3 (_S241.rows[int(2)].x, _S241.rows[int(2)].y, _S241.rows[int(2)].z);
    float3  _S242 = s_primal_ctx_cross_0(r0_4, r1_4);
    bool _S243 = (s_primal_ctx_dot_0(_S242, _S242)) < 9.99999968265522539e-21f;
    float3  lambda_v_12;
    float3  _S244;
    bool _S245;
    if(_S243)
    {
        float3  _S246 = s_primal_ctx_cross_0(r0_4, r2_16);
        bool _S247 = (s_primal_ctx_dot_0(_S246, _S246)) < 9.99999968265522539e-21f;
        if(_S247)
        {
            lambda_v_12 = s_primal_ctx_cross_0(r1_4, r2_16);
        }
        else
        {
            lambda_v_12 = _S246;
        }
        _S245 = _S247;
        _S244 = _S246;
    }
    else
    {
        lambda_v_12 = _S242;
        _S245 = false;
        _S244 = _S193;
    }
    Matrix<float, 3, 3>  S_inv_0 = makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f);
    Matrix<float, 3, 3>  D_0 = makeMatrix<float, 3, 3> (lambda_v_12.x, 0.0f, 0.0f, 0.0f, lambda_v_12.y, 0.0f, 0.0f, 0.0f, lambda_v_12.z);
    Matrix<float, 3, 3>  _S248 = s_primal_ctx_mul_1(T_4, D_0);
    Matrix<float, 3, 3>  _S249 = s_primal_ctx_mul_1(_S248, S_inv_0);
    bool _S250 = (s_primal_ctx_abs_0(_S249.rows[int(2)].z)) > 9.99999968265522539e-21f;
    Matrix<float, 3, 3>  H_8;
    Matrix<float, 3, 3>  _S251;
    float _S252;
    if(_S250)
    {
        float inv_s_0 = 1.0f / _S249.rows[int(2)].z;
        Matrix<float, 3, 3>  _S253 = makeMatrix<float, 3, 3> (inv_s_0);
        float _S254 = _S249.rows[int(2)].z * _S249.rows[int(2)].z;
        H_8 = _S249 * makeMatrix<float, 3, 3> (inv_s_0);
        _S251 = _S253;
        _S252 = _S254;
    }
    else
    {
        H_8 = _S249;
        _S251 = _S194;
        _S252 = 0.0f;
    }
    float _S255 = _S231.x;
    float _S256 = _S231.y;
    float intensity_4 = _S255 + _S256 + _S231.z;
    float3  rgi_in_0 = make_float3 (_S255, _S256, intensity_4);
    float3  _S257 = s_primal_ctx_mul_2(H_8, rgi_in_0);
    float _S258 = _S257.z;
    float _S259 = 0.00009999999747379f * s_primal_ctx_abs_0(intensity_4) + 9.99999993922529029e-09f;
    float _S260 = (F32_max((_S258), (_S259)));
    float norm_factor_4 = intensity_4 / _S260;
    float _S261 = _S260 * _S260;
    float _S262 = _S257.x;
    float out_r_4 = _S262 * norm_factor_4;
    float _S263 = _S257.y;
    float out_g_4 = _S263 * norm_factor_4;
    float3  _S264 = make_float3 (out_r_4, out_g_4, intensity_4 - out_r_4 - out_g_4);
    float3  _S265 = make_float3 (0.0f);
    float3  _S266 = make_float3 (1.0f);
    float3  _S267 = s_primal_ctx_clamp_1(_S264, _S265, _S266);
    float _S268 = _S267.x;
    float _S269 = 1.0f + s_primal_ctx_exp_0(_S211);
    float _S270 = 0.30000001192092896f + s_primal_ctx_log_0(_S269);
    float _S271 = 1.0f + s_primal_ctx_exp_0(_S212);
    float _S272 = 0.30000001192092896f + s_primal_ctx_log_0(_S271);
    float _S273 = 1.0f + s_primal_ctx_exp_0(_S213);
    float _S274 = 0.10000000149011612f + s_primal_ctx_log_0(_S273);
    float _S275 = - _S214;
    float _S276 = 1.0f + s_primal_ctx_exp_0(_S275);
    float _S277 = 1.0f / _S276;
    float _S278 = _S276 * _S276;
    float _S279 = s_primal_ctx_lerp_0(_S270, _S272, _S277);
    float _S280 = _S272 * _S277;
    float a_4 = _S280 / _S279;
    float _S281 = _S279 * _S279;
    float b_5 = 1.0f - a_4;
    bool _S282 = _S268 <= _S277;
    float y_6;
    float _S283;
    float _S284;
    float _S285;
    float _S286;
    float _S287;
    float _S288;
    float _S289;
    float _S290;
    if(_S282)
    {
        float _S291 = _S268 / _S277;
        float _S292 = _S277 * _S277;
        float _S293 = s_primal_ctx_pow_0(_S291, _S270);
        y_6 = a_4 * _S293;
        _S283 = _S293;
        _S284 = _S291;
        _S285 = _S292;
        _S286 = 0.0f;
        _S287 = 0.0f;
        _S288 = 0.0f;
        _S289 = 0.0f;
        _S290 = 0.0f;
    }
    else
    {
        float _S294 = 1.0f - _S268;
        float _S295 = 1.0f - _S277;
        float _S296 = _S294 / _S295;
        float _S297 = _S295 * _S295;
        float _S298 = s_primal_ctx_pow_0(_S296, _S272);
        y_6 = 1.0f - b_5 * _S298;
        _S283 = 0.0f;
        _S284 = 0.0f;
        _S285 = 0.0f;
        _S286 = _S298;
        _S287 = _S296;
        _S288 = _S297;
        _S289 = _S294;
        _S290 = _S295;
    }
    float _S299 = (F32_max((0.0f), (y_6)));
    float _S300 = _S267.y;
    float _S301 = 1.0f + s_primal_ctx_exp_0(_S215);
    float _S302 = 0.30000001192092896f + s_primal_ctx_log_0(_S301);
    float _S303 = 1.0f + s_primal_ctx_exp_0(_S216);
    float _S304 = 0.30000001192092896f + s_primal_ctx_log_0(_S303);
    float _S305 = 1.0f + s_primal_ctx_exp_0(_S217);
    float _S306 = 0.10000000149011612f + s_primal_ctx_log_0(_S305);
    float _S307 = - _S218;
    float _S308 = 1.0f + s_primal_ctx_exp_0(_S307);
    float _S309 = 1.0f / _S308;
    float _S310 = _S308 * _S308;
    float _S311 = s_primal_ctx_lerp_0(_S302, _S304, _S309);
    float _S312 = _S304 * _S309;
    float a_5 = _S312 / _S311;
    float _S313 = _S311 * _S311;
    float b_6 = 1.0f - a_5;
    bool _S314 = _S300 <= _S309;
    float y_7;
    float _S315;
    float _S316;
    float _S317;
    float _S318;
    float _S319;
    float _S320;
    float _S321;
    float _S322;
    if(_S314)
    {
        float _S323 = _S300 / _S309;
        float _S324 = _S309 * _S309;
        float _S325 = s_primal_ctx_pow_0(_S323, _S302);
        y_7 = a_5 * _S325;
        _S315 = _S325;
        _S316 = _S323;
        _S317 = _S324;
        _S318 = 0.0f;
        _S319 = 0.0f;
        _S320 = 0.0f;
        _S321 = 0.0f;
        _S322 = 0.0f;
    }
    else
    {
        float _S326 = 1.0f - _S300;
        float _S327 = 1.0f - _S309;
        float _S328 = _S326 / _S327;
        float _S329 = _S327 * _S327;
        float _S330 = s_primal_ctx_pow_0(_S328, _S304);
        y_7 = 1.0f - b_6 * _S330;
        _S315 = 0.0f;
        _S316 = 0.0f;
        _S317 = 0.0f;
        _S318 = _S330;
        _S319 = _S328;
        _S320 = _S329;
        _S321 = _S326;
        _S322 = _S327;
    }
    float _S331 = (F32_max((0.0f), (y_7)));
    float _S332 = _S267.z;
    float _S333 = 1.0f + s_primal_ctx_exp_0(_S219);
    float _S334 = 0.30000001192092896f + s_primal_ctx_log_0(_S333);
    float _S335 = 1.0f + s_primal_ctx_exp_0(_S220);
    float _S336 = 0.30000001192092896f + s_primal_ctx_log_0(_S335);
    float _S337 = 1.0f + s_primal_ctx_exp_0(_S221);
    float _S338 = 0.10000000149011612f + s_primal_ctx_log_0(_S337);
    float _S339 = - _S222;
    float _S340 = 1.0f + s_primal_ctx_exp_0(_S339);
    float _S341 = 1.0f / _S340;
    float _S342 = _S340 * _S340;
    float _S343 = s_primal_ctx_lerp_0(_S334, _S336, _S341);
    float _S344 = _S336 * _S341;
    float a_6 = _S344 / _S343;
    float _S345 = _S343 * _S343;
    float b_7 = 1.0f - a_6;
    bool _S346 = _S332 <= _S341;
    float y_8;
    float _S347;
    float _S348;
    float _S349;
    float _S350;
    float _S351;
    float _S352;
    float _S353;
    float _S354;
    if(_S346)
    {
        float _S355 = _S332 / _S341;
        float _S356 = _S341 * _S341;
        float _S357 = s_primal_ctx_pow_0(_S355, _S334);
        y_8 = a_6 * _S357;
        _S347 = _S357;
        _S348 = _S355;
        _S349 = _S356;
        _S350 = 0.0f;
        _S351 = 0.0f;
        _S352 = 0.0f;
        _S353 = 0.0f;
        _S354 = 0.0f;
    }
    else
    {
        float _S358 = 1.0f - _S332;
        float _S359 = 1.0f - _S341;
        float _S360 = _S358 / _S359;
        float _S361 = _S359 * _S359;
        float _S362 = s_primal_ctx_pow_0(_S360, _S336);
        y_8 = 1.0f - b_7 * _S362;
        _S347 = 0.0f;
        _S348 = 0.0f;
        _S349 = 0.0f;
        _S350 = _S362;
        _S351 = _S360;
        _S352 = _S361;
        _S353 = _S358;
        _S354 = _S359;
    }
    float _S363 = (F32_max((0.0f), (y_8)));
    DiffPair_float_0 _S364;
    (&_S364)->primal_0 = _S363;
    (&_S364)->differential_0 = 0.0f;
    DiffPair_float_0 _S365;
    (&_S365)->primal_0 = _S338;
    (&_S365)->differential_0 = 0.0f;
    s_bwd_prop_pow_0(&_S364, &_S365, _s_dOut_0.z);
    DiffPair_float_0 _S366 = _S365;
    DiffPair_float_0 _S367;
    (&_S367)->primal_0 = 0.0f;
    (&_S367)->differential_0 = 0.0f;
    DiffPair_float_0 _S368;
    (&_S368)->primal_0 = y_8;
    (&_S368)->differential_0 = 0.0f;
    _d_max_0(&_S367, &_S368, _S364.differential_0);
    DiffPair_float_0 _S369 = _S368;
    if(_S346)
    {
        float _S370 = a_6 * _S369.differential_0;
        float _S371 = _S347 * _S369.differential_0;
        DiffPair_float_0 _S372;
        (&_S372)->primal_0 = _S348;
        (&_S372)->differential_0 = 0.0f;
        DiffPair_float_0 _S373;
        (&_S373)->primal_0 = _S334;
        (&_S373)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S372, &_S373, _S370);
        float _S374 = _S372.differential_0 / _S349;
        float _S375 = _S332 * - _S374;
        float _S376 = _S341 * _S374;
        y_8 = 0.0f;
        _S347 = _S371;
        _S348 = _S375;
        _S349 = 0.0f;
        _S350 = _S373.differential_0;
        _S351 = _S376;
    }
    else
    {
        float _S377 = - _S369.differential_0;
        float _S378 = b_7 * _S377;
        float _S379 = _S350 * _S377;
        DiffPair_float_0 _S380;
        (&_S380)->primal_0 = _S351;
        (&_S380)->differential_0 = 0.0f;
        DiffPair_float_0 _S381;
        (&_S381)->primal_0 = _S336;
        (&_S381)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S380, &_S381, _S378);
        float _S382 = _S380.differential_0 / _S352;
        float _S383 = - (_S353 * - _S382);
        float _S384 = - (_S354 * _S382);
        y_8 = _S379;
        _S347 = 0.0f;
        _S348 = _S383;
        _S349 = _S381.differential_0;
        _S350 = 0.0f;
        _S351 = _S384;
    }
    float _S385 = (- y_8 + _S347) / _S345;
    float _S386 = _S344 * - _S385;
    float _S387 = _S343 * _S385;
    float _S388 = _S336 * _S387;
    float _S389 = _S341 * _S387;
    DiffPair_float_0 _S390;
    (&_S390)->primal_0 = _S334;
    (&_S390)->differential_0 = 0.0f;
    DiffPair_float_0 _S391;
    (&_S391)->primal_0 = _S336;
    (&_S391)->differential_0 = 0.0f;
    DiffPair_float_0 _S392;
    (&_S392)->primal_0 = _S341;
    (&_S392)->differential_0 = 0.0f;
    s_bwd_prop_lerp_0(&_S390, &_S391, &_S392, _S386);
    float _S393 = - ((_S388 + _S392.differential_0 + _S348) / _S342);
    DiffPair_float_0 _S394;
    (&_S394)->primal_0 = _S339;
    (&_S394)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S394, _S393);
    float _S395 = - _S394.differential_0;
    DiffPair_float_0 _S396;
    (&_S396)->primal_0 = _S337;
    (&_S396)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S396, _S366.differential_0);
    DiffPair_float_0 _S397;
    (&_S397)->primal_0 = _S221;
    (&_S397)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S397, _S396.differential_0);
    DiffPair_float_0 _S398 = _S397;
    float _S399 = _S389 + _S391.differential_0 + _S349;
    DiffPair_float_0 _S400;
    (&_S400)->primal_0 = _S335;
    (&_S400)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S400, _S399);
    DiffPair_float_0 _S401;
    (&_S401)->primal_0 = _S220;
    (&_S401)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S401, _S400.differential_0);
    DiffPair_float_0 _S402 = _S401;
    float _S403 = _S390.differential_0 + _S350;
    DiffPair_float_0 _S404;
    (&_S404)->primal_0 = _S333;
    (&_S404)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S404, _S403);
    DiffPair_float_0 _S405;
    (&_S405)->primal_0 = _S219;
    (&_S405)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S405, _S404.differential_0);
    DiffPair_float_0 _S406 = _S405;
    float3  _S407 = make_float3 (0.0f, 0.0f, _S351);
    DiffPair_float_0 _S408;
    (&_S408)->primal_0 = _S331;
    (&_S408)->differential_0 = 0.0f;
    DiffPair_float_0 _S409;
    (&_S409)->primal_0 = _S306;
    (&_S409)->differential_0 = 0.0f;
    s_bwd_prop_pow_0(&_S408, &_S409, _s_dOut_0.y);
    DiffPair_float_0 _S410 = _S409;
    DiffPair_float_0 _S411;
    (&_S411)->primal_0 = 0.0f;
    (&_S411)->differential_0 = 0.0f;
    DiffPair_float_0 _S412;
    (&_S412)->primal_0 = y_7;
    (&_S412)->differential_0 = 0.0f;
    _d_max_0(&_S411, &_S412, _S408.differential_0);
    DiffPair_float_0 _S413 = _S412;
    if(_S314)
    {
        float _S414 = a_5 * _S413.differential_0;
        float _S415 = _S315 * _S413.differential_0;
        DiffPair_float_0 _S416;
        (&_S416)->primal_0 = _S316;
        (&_S416)->differential_0 = 0.0f;
        DiffPair_float_0 _S417;
        (&_S417)->primal_0 = _S302;
        (&_S417)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S416, &_S417, _S414);
        float _S418 = _S416.differential_0 / _S317;
        float _S419 = _S300 * - _S418;
        float _S420 = _S309 * _S418;
        y_7 = 0.0f;
        _S315 = _S415;
        _S316 = _S419;
        _S317 = 0.0f;
        _S318 = _S417.differential_0;
        _S319 = _S420;
    }
    else
    {
        float _S421 = - _S413.differential_0;
        float _S422 = b_6 * _S421;
        float _S423 = _S318 * _S421;
        DiffPair_float_0 _S424;
        (&_S424)->primal_0 = _S319;
        (&_S424)->differential_0 = 0.0f;
        DiffPair_float_0 _S425;
        (&_S425)->primal_0 = _S304;
        (&_S425)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S424, &_S425, _S422);
        float _S426 = _S424.differential_0 / _S320;
        float _S427 = - (_S321 * - _S426);
        float _S428 = - (_S322 * _S426);
        y_7 = _S423;
        _S315 = 0.0f;
        _S316 = _S427;
        _S317 = _S425.differential_0;
        _S318 = 0.0f;
        _S319 = _S428;
    }
    float _S429 = (- y_7 + _S315) / _S313;
    float _S430 = _S312 * - _S429;
    float _S431 = _S311 * _S429;
    float _S432 = _S304 * _S431;
    float _S433 = _S309 * _S431;
    DiffPair_float_0 _S434;
    (&_S434)->primal_0 = _S302;
    (&_S434)->differential_0 = 0.0f;
    DiffPair_float_0 _S435;
    (&_S435)->primal_0 = _S304;
    (&_S435)->differential_0 = 0.0f;
    DiffPair_float_0 _S436;
    (&_S436)->primal_0 = _S309;
    (&_S436)->differential_0 = 0.0f;
    s_bwd_prop_lerp_0(&_S434, &_S435, &_S436, _S430);
    float _S437 = - ((_S432 + _S436.differential_0 + _S316) / _S310);
    DiffPair_float_0 _S438;
    (&_S438)->primal_0 = _S307;
    (&_S438)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S438, _S437);
    float _S439 = - _S438.differential_0;
    DiffPair_float_0 _S440;
    (&_S440)->primal_0 = _S305;
    (&_S440)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S440, _S410.differential_0);
    DiffPair_float_0 _S441;
    (&_S441)->primal_0 = _S217;
    (&_S441)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S441, _S440.differential_0);
    DiffPair_float_0 _S442 = _S441;
    float _S443 = _S433 + _S435.differential_0 + _S317;
    DiffPair_float_0 _S444;
    (&_S444)->primal_0 = _S303;
    (&_S444)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S444, _S443);
    DiffPair_float_0 _S445;
    (&_S445)->primal_0 = _S216;
    (&_S445)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S445, _S444.differential_0);
    DiffPair_float_0 _S446 = _S445;
    float _S447 = _S434.differential_0 + _S318;
    DiffPair_float_0 _S448;
    (&_S448)->primal_0 = _S301;
    (&_S448)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S448, _S447);
    DiffPair_float_0 _S449;
    (&_S449)->primal_0 = _S215;
    (&_S449)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S449, _S448.differential_0);
    DiffPair_float_0 _S450 = _S449;
    float3  _S451 = _S407 + make_float3 (0.0f, _S319, 0.0f);
    DiffPair_float_0 _S452;
    (&_S452)->primal_0 = _S299;
    (&_S452)->differential_0 = 0.0f;
    DiffPair_float_0 _S453;
    (&_S453)->primal_0 = _S274;
    (&_S453)->differential_0 = 0.0f;
    s_bwd_prop_pow_0(&_S452, &_S453, _s_dOut_0.x);
    DiffPair_float_0 _S454 = _S453;
    DiffPair_float_0 _S455;
    (&_S455)->primal_0 = 0.0f;
    (&_S455)->differential_0 = 0.0f;
    DiffPair_float_0 _S456;
    (&_S456)->primal_0 = y_6;
    (&_S456)->differential_0 = 0.0f;
    _d_max_0(&_S455, &_S456, _S452.differential_0);
    DiffPair_float_0 _S457 = _S456;
    if(_S282)
    {
        float _S458 = a_4 * _S457.differential_0;
        float _S459 = _S283 * _S457.differential_0;
        DiffPair_float_0 _S460;
        (&_S460)->primal_0 = _S284;
        (&_S460)->differential_0 = 0.0f;
        DiffPair_float_0 _S461;
        (&_S461)->primal_0 = _S270;
        (&_S461)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S460, &_S461, _S458);
        float _S462 = _S460.differential_0 / _S285;
        float _S463 = _S268 * - _S462;
        float _S464 = _S277 * _S462;
        y_6 = 0.0f;
        _S283 = _S459;
        _S284 = _S463;
        _S285 = 0.0f;
        _S286 = _S461.differential_0;
        _S287 = _S464;
    }
    else
    {
        float _S465 = - _S457.differential_0;
        float _S466 = b_5 * _S465;
        float _S467 = _S286 * _S465;
        DiffPair_float_0 _S468;
        (&_S468)->primal_0 = _S287;
        (&_S468)->differential_0 = 0.0f;
        DiffPair_float_0 _S469;
        (&_S469)->primal_0 = _S272;
        (&_S469)->differential_0 = 0.0f;
        s_bwd_prop_pow_0(&_S468, &_S469, _S466);
        float _S470 = _S468.differential_0 / _S288;
        float _S471 = - (_S289 * - _S470);
        float _S472 = - (_S290 * _S470);
        y_6 = _S467;
        _S283 = 0.0f;
        _S284 = _S471;
        _S285 = _S469.differential_0;
        _S286 = 0.0f;
        _S287 = _S472;
    }
    float _S473 = (- y_6 + _S283) / _S281;
    float _S474 = _S280 * - _S473;
    float _S475 = _S279 * _S473;
    float _S476 = _S272 * _S475;
    float _S477 = _S277 * _S475;
    DiffPair_float_0 _S478;
    (&_S478)->primal_0 = _S270;
    (&_S478)->differential_0 = 0.0f;
    DiffPair_float_0 _S479;
    (&_S479)->primal_0 = _S272;
    (&_S479)->differential_0 = 0.0f;
    DiffPair_float_0 _S480;
    (&_S480)->primal_0 = _S277;
    (&_S480)->differential_0 = 0.0f;
    s_bwd_prop_lerp_0(&_S478, &_S479, &_S480, _S474);
    float _S481 = - ((_S476 + _S480.differential_0 + _S284) / _S278);
    DiffPair_float_0 _S482;
    (&_S482)->primal_0 = _S275;
    (&_S482)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S482, _S481);
    float _S483 = - _S482.differential_0;
    DiffPair_float_0 _S484;
    (&_S484)->primal_0 = _S273;
    (&_S484)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S484, _S454.differential_0);
    DiffPair_float_0 _S485;
    (&_S485)->primal_0 = _S213;
    (&_S485)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S485, _S484.differential_0);
    DiffPair_float_0 _S486 = _S485;
    float _S487 = _S477 + _S479.differential_0 + _S285;
    DiffPair_float_0 _S488;
    (&_S488)->primal_0 = _S271;
    (&_S488)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S488, _S487);
    DiffPair_float_0 _S489;
    (&_S489)->primal_0 = _S212;
    (&_S489)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S489, _S488.differential_0);
    DiffPair_float_0 _S490 = _S489;
    float _S491 = _S478.differential_0 + _S286;
    DiffPair_float_0 _S492;
    (&_S492)->primal_0 = _S269;
    (&_S492)->differential_0 = 0.0f;
    s_bwd_prop_log_0(&_S492, _S491);
    DiffPair_float_0 _S493;
    (&_S493)->primal_0 = _S211;
    (&_S493)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S493, _S492.differential_0);
    DiffPair_float_0 _S494 = _S493;
    float3  _S495 = _S451 + make_float3 (_S287, 0.0f, 0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S496;
    (&_S496)->primal_0 = _S264;
    (&_S496)->differential_0 = _S193;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S497;
    (&_S497)->primal_0 = _S265;
    (&_S497)->differential_0 = _S193;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S498;
    (&_S498)->primal_0 = _S266;
    (&_S498)->differential_0 = _S193;
    s_bwd_prop_clamp_0(&_S496, &_S497, &_S498, _S495);
    float _S499 = - _S496.differential_0.z;
    float _S500 = _S496.differential_0.y + _S499;
    float _S501 = norm_factor_4 * _S500;
    float _S502 = _S496.differential_0.x + _S499;
    float _S503 = norm_factor_4 * _S502;
    float _S504 = (_S263 * _S500 + _S262 * _S502) / _S261;
    float _S505 = intensity_4 * - _S504;
    float _S506 = _S260 * _S504;
    DiffPair_float_0 _S507;
    (&_S507)->primal_0 = _S258;
    (&_S507)->differential_0 = 0.0f;
    DiffPair_float_0 _S508;
    (&_S508)->primal_0 = _S259;
    (&_S508)->differential_0 = 0.0f;
    _d_max_0(&_S507, &_S508, _S505);
    float _S509 = 0.00009999999747379f * _S508.differential_0;
    DiffPair_float_0 _S510;
    (&_S510)->primal_0 = intensity_4;
    (&_S510)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S510, _S509);
    float3  _S511 = make_float3 (_S503, _S501, _S507.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S512;
    (&_S512)->primal_0 = H_8;
    (&_S512)->differential_0 = _S194;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S513;
    (&_S513)->primal_0 = rgi_in_0;
    (&_S513)->differential_0 = _S193;
    s_bwd_prop_mul_0(&_S512, &_S513, _S511);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S514 = _S512;
    float _S515 = _S496.differential_0.z + _S506 + _S510.differential_0 + _S513.differential_0.z;
    float _S516 = _S513.differential_0.y + _S515;
    float _S517 = _S513.differential_0.x + _S515;
    float3  _S518 = make_float3 (_S517, _S516, _S515);
    if(_S250)
    {
        Matrix<float, 3, 3>  _S519 = _S249 * _S514.differential_0;
        Matrix<float, 3, 3>  _S520 = _S251 * _S514.differential_0;
        _S252 = - ((_S519.rows[int(0)].x + _S519.rows[int(0)].y + _S519.rows[int(0)].z + _S519.rows[int(1)].x + _S519.rows[int(1)].y + _S519.rows[int(1)].z + _S519.rows[int(2)].x + _S519.rows[int(2)].y + _S519.rows[int(2)].z) / _S252);
        H_8 = _S520;
    }
    else
    {
        _S252 = 0.0f;
        H_8 = _S514.differential_0;
    }
    DiffPair_float_0 _S521;
    (&_S521)->primal_0 = _S249.rows[int(2)].z;
    (&_S521)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S521, 0.0f);
    float _S522 = _S521.differential_0 + _S252;
    float3  _S523 = _S193;
    *&((&_S523)->z) = _S522;
    Matrix<float, 3, 3>  _S524 = _S194;
    _S524[int(2)] = _S523;
    Matrix<float, 3, 3>  _S525 = H_8 + _S524;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S526;
    (&_S526)->primal_0 = _S248;
    (&_S526)->differential_0 = _S194;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S527;
    (&_S527)->primal_0 = S_inv_0;
    (&_S527)->differential_0 = _S194;
    s_bwd_prop_mul_1(&_S526, &_S527, _S525);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S528;
    (&_S528)->primal_0 = T_4;
    (&_S528)->differential_0 = _S194;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S529;
    (&_S529)->primal_0 = D_0;
    (&_S529)->differential_0 = _S194;
    s_bwd_prop_mul_1(&_S528, &_S529, _S526.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S530 = _S528;
    float3  _S531 = make_float3 (_S529.differential_0.rows[int(0)].x, _S529.differential_0.rows[int(1)].y, _S529.differential_0.rows[int(2)].z);
    float3  _S532;
    if(_S243)
    {
        if(_S245)
        {
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S533;
            (&_S533)->primal_0 = r1_4;
            (&_S533)->differential_0 = _S193;
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S534;
            (&_S534)->primal_0 = r2_16;
            (&_S534)->differential_0 = _S193;
            s_bwd_prop_cross_0(&_S533, &_S534, _S531);
            _S231 = _S193;
            lambda_v_12 = _S534.differential_0;
            _S532 = _S533.differential_0;
        }
        else
        {
            _S231 = _S531;
            lambda_v_12 = _S193;
            _S532 = _S193;
        }
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S535;
        (&_S535)->primal_0 = _S244;
        (&_S535)->differential_0 = _S193;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S536;
        (&_S536)->primal_0 = _S244;
        (&_S536)->differential_0 = _S193;
        s_bwd_prop_dot_0(&_S535, &_S536, 0.0f);
        float3  _S537 = _S536.differential_0 + _S535.differential_0 + _S231;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S538;
        (&_S538)->primal_0 = r0_4;
        (&_S538)->differential_0 = _S193;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S539;
        (&_S539)->primal_0 = r2_16;
        (&_S539)->differential_0 = _S193;
        s_bwd_prop_cross_0(&_S538, &_S539, _S537);
        float3  _S540 = _S539.differential_0 + lambda_v_12;
        _S231 = _S193;
        lambda_v_12 = _S540;
        _S244 = _S532;
        _S532 = _S538.differential_0;
    }
    else
    {
        _S231 = _S531;
        lambda_v_12 = _S193;
        _S244 = _S193;
        _S532 = _S193;
    }
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S541;
    (&_S541)->primal_0 = _S242;
    (&_S541)->differential_0 = _S193;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S542;
    (&_S542)->primal_0 = _S242;
    (&_S542)->differential_0 = _S193;
    s_bwd_prop_dot_0(&_S541, &_S542, 0.0f);
    float3  _S543 = _S542.differential_0 + _S541.differential_0 + _S231;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S544;
    (&_S544)->primal_0 = r0_4;
    (&_S544)->differential_0 = _S193;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S545;
    (&_S545)->primal_0 = r1_4;
    (&_S545)->differential_0 = _S193;
    s_bwd_prop_cross_0(&_S544, &_S545, _S543);
    float3  _S546 = _S193;
    *&((&_S546)->z) = lambda_v_12.z;
    *&((&_S546)->y) = lambda_v_12.y;
    *&((&_S546)->x) = lambda_v_12.x;
    float3  _S547 = _S545.differential_0 + _S244;
    float3  _S548 = _S193;
    *&((&_S548)->z) = _S547.z;
    *&((&_S548)->y) = _S547.y;
    *&((&_S548)->x) = _S547.x;
    float3  _S549 = _S544.differential_0 + _S532;
    float3  _S550 = _S193;
    *&((&_S550)->z) = _S549.z;
    *&((&_S550)->y) = _S549.y;
    *&((&_S550)->x) = _S549.x;
    Matrix<float, 3, 3>  _S551 = _S194;
    _S551[int(2)] = _S546;
    _S551[int(1)] = _S548;
    _S551[int(0)] = _S550;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S552;
    (&_S552)->primal_0 = skew_0;
    (&_S552)->differential_0 = _S194;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S553;
    (&_S553)->primal_0 = T_4;
    (&_S553)->differential_0 = _S194;
    s_bwd_prop_mul_1(&_S552, &_S553, _S551);
    Matrix<float, 3, 3>  _S554 = _S553.differential_0 + _S530.differential_0;
    float2  _S555 = make_float2 (_S552.differential_0.rows[int(2)].y + - _S552.differential_0.rows[int(1)].z, _S552.differential_0.rows[int(0)].z + - _S552.differential_0.rows[int(2)].x);
    Matrix<float, 2, 2>  _S556 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S557;
    (&_S557)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S557)->differential_0 = _S556;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S558;
    (&_S558)->primal_0 = _S234.color_params_3.n_0;
    (&_S558)->differential_0 = _S197;
    s_bwd_prop_mul_2(&_S557, &_S558, _S555);
    float2  _S559 = make_float2 (_S554.rows[int(0)].z, _S554.rows[int(1)].z);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S560;
    (&_S560)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S560)->differential_0 = _S556;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S561;
    (&_S561)->primal_0 = _S234.color_params_3.g_0;
    (&_S561)->differential_0 = _S197;
    s_bwd_prop_mul_2(&_S560, &_S561, _S559);
    float2  _S562 = make_float2 (_S554.rows[int(0)].y, _S554.rows[int(1)].y);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S563;
    (&_S563)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S563)->differential_0 = _S556;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S564;
    (&_S564)->primal_0 = _S234.color_params_3.r_0;
    (&_S564)->differential_0 = _S197;
    s_bwd_prop_mul_2(&_S563, &_S564, _S562);
    float2  _S565 = make_float2 (_S554.rows[int(0)].x, _S554.rows[int(1)].x);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S566;
    (&_S566)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S566)->differential_0 = _S556;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S567;
    (&_S567)->primal_0 = _S234.color_params_3.b_0;
    (&_S567)->differential_0 = _S197;
    s_bwd_prop_mul_2(&_S566, &_S567, _S565);
    ColorPPISPParams_0 _S568 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S568)->n_0 = _S558.differential_0;
    (&_S568)->g_0 = _S561.differential_0;
    (&_S568)->r_0 = _S564.differential_0;
    (&_S568)->b_0 = _S567.differential_0;
    _S231 = _S518;
    *&((&_S231)->z) = 0.0f;
    float _S569 = rgb_out_5.z * _S515;
    float _S570 = _S233 * _S515;
    DiffPair_float_0 _S571;
    (&_S571)->primal_0 = falloff_2;
    (&_S571)->differential_0 = 0.0f;
    DiffPair_float_0 _S572;
    (&_S572)->primal_0 = 0.0f;
    (&_S572)->differential_0 = 0.0f;
    DiffPair_float_0 _S573;
    (&_S573)->primal_0 = 1.0f;
    (&_S573)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S571, &_S572, &_S573, _S569);
    float _S574 = r2_15 * _S571.differential_0;
    float _S575 = r4_11 * _S571.differential_0;
    float s_diff_r6_T_0 = _S210 * _S571.differential_0;
    float _S576 = r6_2 * _S571.differential_0;
    float _S577 = r2_15 * (_S209 * _S571.differential_0 + r2_15 * s_diff_r6_T_0);
    float _S578 = _S208 * _S571.differential_0 + r4_11 * s_diff_r6_T_0 + _S577 + _S577;
    float _S579 = dy_11 * _S578;
    float _S580 = dx_11 * _S578;
    float _S581 = - (_S579 + _S579);
    float _S582 = - (_S580 + _S580);
    *&((&_S231)->y) = 0.0f;
    float _S583 = rgb_out_5.y * _S516;
    float _S584 = _S232 * _S516;
    DiffPair_float_0 _S585;
    (&_S585)->primal_0 = falloff_1;
    (&_S585)->differential_0 = 0.0f;
    DiffPair_float_0 _S586;
    (&_S586)->primal_0 = 0.0f;
    (&_S586)->differential_0 = 0.0f;
    DiffPair_float_0 _S587;
    (&_S587)->primal_0 = 1.0f;
    (&_S587)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S585, &_S586, &_S587, _S583);
    float _S588 = r2_14 * _S585.differential_0;
    float _S589 = r4_10 * _S585.differential_0;
    float s_diff_r6_T_1 = _S207 * _S585.differential_0;
    float _S590 = r6_1 * _S585.differential_0;
    float _S591 = r2_14 * (_S206 * _S585.differential_0 + r2_14 * s_diff_r6_T_1);
    float _S592 = _S205 * _S585.differential_0 + r4_10 * s_diff_r6_T_1 + _S591 + _S591;
    float _S593 = dy_10 * _S592;
    float _S594 = dx_10 * _S592;
    float _S595 = - (_S593 + _S593);
    float _S596 = - (_S594 + _S594);
    *&((&_S231)->x) = 0.0f;
    float _S597 = rgb_out_5.x * _S517;
    float _S598 = _S229 * _S517;
    DiffPair_float_0 _S599;
    (&_S599)->primal_0 = falloff_0;
    (&_S599)->differential_0 = 0.0f;
    DiffPair_float_0 _S600;
    (&_S600)->primal_0 = 0.0f;
    (&_S600)->differential_0 = 0.0f;
    DiffPair_float_0 _S601;
    (&_S601)->primal_0 = 1.0f;
    (&_S601)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S599, &_S600, &_S601, _S597);
    float _S602 = r2_13 * _S599.differential_0;
    float _S603 = r4_9 * _S599.differential_0;
    float s_diff_r6_T_2 = _S204 * _S599.differential_0;
    float _S604 = r6_0 * _S599.differential_0;
    float _S605 = r2_13 * (_S203 * _S599.differential_0 + r2_13 * s_diff_r6_T_2);
    float _S606 = _S202 * _S599.differential_0 + r4_9 * s_diff_r6_T_2 + _S605 + _S605;
    float _S607 = dy_9 * _S606;
    float _S608 = dx_9 * _S606;
    float _S609 = - (_S607 + _S607);
    float _S610 = - (_S608 + _S608);
    float3  _S611 = _S193;
    *&((&_S611)->z) = _S570;
    *&((&_S611)->y) = _S584;
    *&((&_S611)->x) = _S598;
    float3  _S612 = _S231 + _S611;
    float3  _S613 = _S192.primal_0 * _S612;
    float3  _S614 = _S225 * _S612;
    float _S615 = _S613.x + _S613.y + _S613.z;
    DiffPair_float_0 _S616;
    (&_S616)->primal_0 = _S223.exposure_3;
    (&_S616)->differential_0 = 0.0f;
    s_bwd_prop_exp2_0(&_S616, _S615);
    PPISPParams_0 _S617 = PPISPParams_x24_syn_dzero_0();
    (&_S617)->color_params_3 = _S568;
    (&_S617)->exposure_3 = _S616.differential_0;
    _S201 = _S617;
    (&(&_S201)->crf_params_1[int(2)])->center_0 = 0.0f;
    float _S618 = _S617.crf_params_1[int(2)].center_0 + _S395;
    (&(&_S201)->crf_params_1[int(2)])->gamma_0 = 0.0f;
    float _S619 = _S617.crf_params_1[int(2)].gamma_0 + _S398.differential_0;
    (&(&_S201)->crf_params_1[int(2)])->shoulder_0 = 0.0f;
    float _S620 = _S617.crf_params_1[int(2)].shoulder_0 + _S402.differential_0;
    (&(&_S201)->crf_params_1[int(2)])->toe_0 = 0.0f;
    float _S621 = _S617.crf_params_1[int(2)].toe_0 + _S406.differential_0;
    (&(&_S201)->crf_params_1[int(1)])->center_0 = 0.0f;
    float _S622 = _S617.crf_params_1[int(1)].center_0 + _S439;
    (&(&_S201)->crf_params_1[int(1)])->gamma_0 = 0.0f;
    float _S623 = _S617.crf_params_1[int(1)].gamma_0 + _S442.differential_0;
    (&(&_S201)->crf_params_1[int(1)])->shoulder_0 = 0.0f;
    float _S624 = _S617.crf_params_1[int(1)].shoulder_0 + _S446.differential_0;
    (&(&_S201)->crf_params_1[int(1)])->toe_0 = 0.0f;
    float _S625 = _S617.crf_params_1[int(1)].toe_0 + _S450.differential_0;
    (&(&_S201)->crf_params_1[int(0)])->center_0 = 0.0f;
    float _S626 = _S617.crf_params_1[int(0)].center_0 + _S483;
    (&(&_S201)->crf_params_1[int(0)])->gamma_0 = 0.0f;
    float _S627 = _S617.crf_params_1[int(0)].gamma_0 + _S486.differential_0;
    (&(&_S201)->crf_params_1[int(0)])->shoulder_0 = 0.0f;
    float _S628 = _S617.crf_params_1[int(0)].shoulder_0 + _S490.differential_0;
    (&(&_S201)->crf_params_1[int(0)])->toe_0 = 0.0f;
    float _S629 = _S617.crf_params_1[int(0)].toe_0 + _S494.differential_0;
    *&((&(&(&_S201)->color_params_3)->n_0)->y) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->n_0)->x) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->g_0)->y) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->g_0)->x) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->r_0)->y) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->r_0)->x) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->b_0)->y) = 0.0f;
    *&((&(&(&_S201)->color_params_3)->b_0)->x) = 0.0f;
    (&(&_S201)->vignette_params_2[int(2)])->alpha2_0 = 0.0f;
    float _S630 = _S576 + _S617.vignette_params_2[int(2)].alpha2_0;
    (&(&_S201)->vignette_params_2[int(2)])->alpha1_0 = 0.0f;
    float _S631 = _S575 + _S617.vignette_params_2[int(2)].alpha1_0;
    (&(&_S201)->vignette_params_2[int(2)])->alpha0_0 = 0.0f;
    float _S632 = _S574 + _S617.vignette_params_2[int(2)].alpha0_0;
    (&(&_S201)->vignette_params_2[int(2)])->cy_0 = 0.0f;
    float _S633 = _S581 + _S617.vignette_params_2[int(2)].cy_0;
    (&(&_S201)->vignette_params_2[int(2)])->cx_0 = 0.0f;
    float _S634 = _S582 + _S617.vignette_params_2[int(2)].cx_0;
    (&(&_S201)->vignette_params_2[int(1)])->alpha2_0 = 0.0f;
    float _S635 = _S590 + _S617.vignette_params_2[int(1)].alpha2_0;
    (&(&_S201)->vignette_params_2[int(1)])->alpha1_0 = 0.0f;
    float _S636 = _S589 + _S617.vignette_params_2[int(1)].alpha1_0;
    (&(&_S201)->vignette_params_2[int(1)])->alpha0_0 = 0.0f;
    float _S637 = _S588 + _S617.vignette_params_2[int(1)].alpha0_0;
    (&(&_S201)->vignette_params_2[int(1)])->cy_0 = 0.0f;
    float _S638 = _S595 + _S617.vignette_params_2[int(1)].cy_0;
    (&(&_S201)->vignette_params_2[int(1)])->cx_0 = 0.0f;
    float _S639 = _S596 + _S617.vignette_params_2[int(1)].cx_0;
    (&(&_S201)->vignette_params_2[int(0)])->alpha2_0 = 0.0f;
    float _S640 = _S604 + _S617.vignette_params_2[int(0)].alpha2_0;
    (&(&_S201)->vignette_params_2[int(0)])->alpha1_0 = 0.0f;
    float _S641 = _S603 + _S617.vignette_params_2[int(0)].alpha1_0;
    (&(&_S201)->vignette_params_2[int(0)])->alpha0_0 = 0.0f;
    float _S642 = _S602 + _S617.vignette_params_2[int(0)].alpha0_0;
    (&(&_S201)->vignette_params_2[int(0)])->cy_0 = 0.0f;
    float _S643 = _S609 + _S617.vignette_params_2[int(0)].cy_0;
    (&(&_S201)->vignette_params_2[int(0)])->cx_0 = 0.0f;
    float _S644 = _S610 + _S617.vignette_params_2[int(0)].cx_0;
    FixedArray<float, 36>  _S645;
    _S645[int(0)] = 0.0f;
    _S645[int(1)] = 0.0f;
    _S645[int(2)] = 0.0f;
    _S645[int(3)] = 0.0f;
    _S645[int(4)] = 0.0f;
    _S645[int(5)] = 0.0f;
    _S645[int(6)] = 0.0f;
    _S645[int(7)] = 0.0f;
    _S645[int(8)] = 0.0f;
    _S645[int(9)] = 0.0f;
    _S645[int(10)] = 0.0f;
    _S645[int(11)] = 0.0f;
    _S645[int(12)] = 0.0f;
    _S645[int(13)] = 0.0f;
    _S645[int(14)] = 0.0f;
    _S645[int(15)] = 0.0f;
    _S645[int(16)] = 0.0f;
    _S645[int(17)] = 0.0f;
    _S645[int(18)] = 0.0f;
    _S645[int(19)] = 0.0f;
    _S645[int(20)] = 0.0f;
    _S645[int(21)] = 0.0f;
    _S645[int(22)] = 0.0f;
    _S645[int(23)] = 0.0f;
    _S645[int(24)] = 0.0f;
    _S645[int(25)] = 0.0f;
    _S645[int(26)] = 0.0f;
    _S645[int(27)] = 0.0f;
    _S645[int(28)] = 0.0f;
    _S645[int(29)] = 0.0f;
    _S645[int(30)] = 0.0f;
    _S645[int(31)] = 0.0f;
    _S645[int(32)] = 0.0f;
    _S645[int(33)] = 0.0f;
    _S645[int(34)] = 0.0f;
    _S645[int(35)] = 0.0f;
    _S645[int(8)] = _S637;
    _S645[int(16)] = _S617.color_params_3.b_0.x;
    _S645[int(15)] = _S630;
    _S645[int(14)] = _S631;
    _S645[int(13)] = _S632;
    _S645[int(12)] = _S633;
    _S645[int(11)] = _S634;
    _S645[int(10)] = _S635;
    _S645[int(9)] = _S636;
    _S645[int(17)] = _S617.color_params_3.b_0.y;
    _S645[int(7)] = _S638;
    _S645[int(6)] = _S639;
    _S645[int(5)] = _S640;
    _S645[int(4)] = _S641;
    _S645[int(3)] = _S642;
    _S645[int(2)] = _S643;
    _S645[int(1)] = _S644;
    _S645[int(0)] = _S201.exposure_3;
    _S645[int(26)] = _S627;
    _S645[int(34)] = _S619;
    _S645[int(33)] = _S620;
    _S645[int(32)] = _S621;
    _S645[int(31)] = _S622;
    _S645[int(30)] = _S623;
    _S645[int(29)] = _S624;
    _S645[int(28)] = _S625;
    _S645[int(27)] = _S626;
    _S645[int(35)] = _S618;
    _S645[int(25)] = _S628;
    _S645[int(24)] = _S629;
    _S645[int(23)] = _S617.color_params_3.n_0.y;
    _S645[int(22)] = _S617.color_params_3.n_0.x;
    _S645[int(21)] = _S617.color_params_3.g_0.y;
    _S645[int(20)] = _S617.color_params_3.g_0.x;
    _S645[int(19)] = _S617.color_params_3.r_0.y;
    _S645[int(18)] = _S617.color_params_3.r_0.x;
    dpparams_0->primal_0 = dpparams_0->primal_0;
    dpparams_0->differential_0 = _S645;
    dprgb_in_0->primal_0 = (*dprgb_in_0).primal_0;
    dprgb_in_0->differential_0 = _S614;
    return;
}

inline __device__ void s_bwd_apply_ppisp_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S646, float2  _S647, float2  _S648, float2  _S649, DiffPair_arrayx3Cfloatx2C36x3E_0 * _S650, float3  _S651)
{
    s_bwd_prop_apply_ppisp_0(_S646, _S647, _S648, _S649, _S650, _S651);
    return;
}

inline __device__ void apply_ppisp_vjp(float3  rgb_in_4, float2  pix_coord_5, float2  image_center_5, float2  img_size_5, FixedArray<float, 36>  params_4, float3  grad_out_0, float3  * grad_rgb_in_0, FixedArray<float, 36>  * grad_params_0)
{
    float3  _S652 = make_float3 (0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_rgb_in_0;
    (&dp_rgb_in_0)->primal_0 = rgb_in_4;
    (&dp_rgb_in_0)->differential_0 = _S652;
    FixedArray<float, 36>  _S653 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C36x3E_0 dp_params_0;
    (&dp_params_0)->primal_0 = params_4;
    (&dp_params_0)->differential_0 = _S653;
    s_bwd_apply_ppisp_0(&dp_rgb_in_0, pix_coord_5, image_center_5, img_size_5, &dp_params_0, grad_out_0);
    *grad_rgb_in_0 = dp_rgb_in_0.differential_0;
    *grad_params_0 = (&dp_params_0)->differential_0;
    return;
}

struct DiffPair_arrayx3Cfloatx2C39x3E_0
{
    FixedArray<float, 39>  primal_0;
    FixedArray<float, 39>  differential_0;
};

inline __device__ void s_bwd_prop_apply_ppisp_rqs_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dprgb_in_1, float2  pix_coord_6, float2  image_center_6, float2  img_size_6, DiffPair_arrayx3Cfloatx2C39x3E_0 * dpparams_1, float3  _s_dOut_1)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S654 = *dprgb_in_1;
    float3  _S655 = make_float3 (0.0f);
    Matrix<float, 3, 3>  _S656 = makeMatrix<float, 3, 3> (0.0f);
    VignettingChannelParams_0 _S657 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S658 = {
        _S657, _S657, _S657
    };
    float2  _S659 = make_float2 (0.0f);
    ColorPPISPParams_0 _S660 = { _S659, _S659, _S659, _S659 };
    RQSCRFPPISPChannelParams_0 _S661 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<RQSCRFPPISPChannelParams_0, 3>  _S662 = {
        _S661, _S661, _S661
    };
    PPISPParamsRQS_0 _S663;
    (&_S663)->exposure_2 = dpparams_1->primal_0[int(0)];
    (&_S663)->vignette_params_1 = _S658;
    (&_S663)->color_params_2 = _S660;
    (&_S663)->crf_params_0 = _S662;
    (&(&_S663)->vignette_params_1[int(0)])->cx_0 = dpparams_1->primal_0[int(1)];
    (&(&_S663)->vignette_params_1[int(0)])->cy_0 = dpparams_1->primal_0[int(2)];
    float _S664 = dpparams_1->primal_0[int(3)];
    (&(&_S663)->vignette_params_1[int(0)])->alpha0_0 = dpparams_1->primal_0[int(3)];
    float _S665 = dpparams_1->primal_0[int(4)];
    (&(&_S663)->vignette_params_1[int(0)])->alpha1_0 = dpparams_1->primal_0[int(4)];
    float _S666 = dpparams_1->primal_0[int(5)];
    (&(&_S663)->vignette_params_1[int(0)])->alpha2_0 = dpparams_1->primal_0[int(5)];
    (&(&_S663)->vignette_params_1[int(1)])->cx_0 = dpparams_1->primal_0[int(6)];
    (&(&_S663)->vignette_params_1[int(1)])->cy_0 = dpparams_1->primal_0[int(7)];
    float _S667 = dpparams_1->primal_0[int(8)];
    (&(&_S663)->vignette_params_1[int(1)])->alpha0_0 = dpparams_1->primal_0[int(8)];
    float _S668 = dpparams_1->primal_0[int(9)];
    (&(&_S663)->vignette_params_1[int(1)])->alpha1_0 = dpparams_1->primal_0[int(9)];
    float _S669 = dpparams_1->primal_0[int(10)];
    (&(&_S663)->vignette_params_1[int(1)])->alpha2_0 = dpparams_1->primal_0[int(10)];
    (&(&_S663)->vignette_params_1[int(2)])->cx_0 = dpparams_1->primal_0[int(11)];
    (&(&_S663)->vignette_params_1[int(2)])->cy_0 = dpparams_1->primal_0[int(12)];
    float _S670 = dpparams_1->primal_0[int(13)];
    (&(&_S663)->vignette_params_1[int(2)])->alpha0_0 = dpparams_1->primal_0[int(13)];
    float _S671 = dpparams_1->primal_0[int(14)];
    (&(&_S663)->vignette_params_1[int(2)])->alpha1_0 = dpparams_1->primal_0[int(14)];
    float _S672 = dpparams_1->primal_0[int(15)];
    (&(&_S663)->vignette_params_1[int(2)])->alpha2_0 = dpparams_1->primal_0[int(15)];
    *&((&(&(&_S663)->color_params_2)->b_0)->x) = dpparams_1->primal_0[int(16)];
    *&((&(&(&_S663)->color_params_2)->b_0)->y) = dpparams_1->primal_0[int(17)];
    *&((&(&(&_S663)->color_params_2)->r_0)->x) = dpparams_1->primal_0[int(18)];
    *&((&(&(&_S663)->color_params_2)->r_0)->y) = dpparams_1->primal_0[int(19)];
    *&((&(&(&_S663)->color_params_2)->g_0)->x) = dpparams_1->primal_0[int(20)];
    *&((&(&(&_S663)->color_params_2)->g_0)->y) = dpparams_1->primal_0[int(21)];
    *&((&(&(&_S663)->color_params_2)->n_0)->x) = dpparams_1->primal_0[int(22)];
    *&((&(&(&_S663)->color_params_2)->n_0)->y) = dpparams_1->primal_0[int(23)];
    float _S673 = dpparams_1->primal_0[int(24)];
    (&(&_S663)->crf_params_0[int(0)])->g0_0 = dpparams_1->primal_0[int(24)];
    float _S674 = dpparams_1->primal_0[int(25)];
    (&(&_S663)->crf_params_0[int(0)])->g1_0 = dpparams_1->primal_0[int(25)];
    float _S675 = dpparams_1->primal_0[int(26)];
    (&(&_S663)->crf_params_0[int(0)])->x0_0 = dpparams_1->primal_0[int(26)];
    float _S676 = dpparams_1->primal_0[int(27)];
    (&(&_S663)->crf_params_0[int(0)])->y0_0 = dpparams_1->primal_0[int(27)];
    float _S677 = dpparams_1->primal_0[int(28)];
    (&(&_S663)->crf_params_0[int(0)])->gc_0 = dpparams_1->primal_0[int(28)];
    float _S678 = dpparams_1->primal_0[int(29)];
    (&(&_S663)->crf_params_0[int(1)])->g0_0 = dpparams_1->primal_0[int(29)];
    float _S679 = dpparams_1->primal_0[int(30)];
    (&(&_S663)->crf_params_0[int(1)])->g1_0 = dpparams_1->primal_0[int(30)];
    float _S680 = dpparams_1->primal_0[int(31)];
    (&(&_S663)->crf_params_0[int(1)])->x0_0 = dpparams_1->primal_0[int(31)];
    float _S681 = dpparams_1->primal_0[int(32)];
    (&(&_S663)->crf_params_0[int(1)])->y0_0 = dpparams_1->primal_0[int(32)];
    float _S682 = dpparams_1->primal_0[int(33)];
    (&(&_S663)->crf_params_0[int(1)])->gc_0 = dpparams_1->primal_0[int(33)];
    float _S683 = dpparams_1->primal_0[int(34)];
    (&(&_S663)->crf_params_0[int(2)])->g0_0 = dpparams_1->primal_0[int(34)];
    float _S684 = dpparams_1->primal_0[int(35)];
    (&(&_S663)->crf_params_0[int(2)])->g1_0 = dpparams_1->primal_0[int(35)];
    float _S685 = dpparams_1->primal_0[int(36)];
    (&(&_S663)->crf_params_0[int(2)])->x0_0 = dpparams_1->primal_0[int(36)];
    float _S686 = dpparams_1->primal_0[int(37)];
    (&(&_S663)->crf_params_0[int(2)])->y0_0 = dpparams_1->primal_0[int(37)];
    float _S687 = dpparams_1->primal_0[int(38)];
    (&(&_S663)->crf_params_0[int(2)])->gc_0 = dpparams_1->primal_0[int(38)];
    PPISPParamsRQS_0 _S688 = _S663;
    float _S689 = s_primal_ctx_exp2_0(_S663.exposure_2);
    float3  _S690 = make_float3 (_S689);
    float3  rgb_out_6 = (*dprgb_in_1).primal_0 * make_float3 (_S689);
    float _S691 = (F32_max((img_size_6.x), (img_size_6.y)));
    float _S692 = (pix_coord_6.x - image_center_6.x) / _S691;
    float _S693 = (pix_coord_6.y - image_center_6.y) / _S691;
    float dx_12 = _S692 - dpparams_1->primal_0[int(1)];
    float dy_12 = _S693 - dpparams_1->primal_0[int(2)];
    float r2_17 = dx_12 * dx_12 + dy_12 * dy_12;
    float r4_12 = r2_17 * r2_17;
    float r6_3 = r4_12 * r2_17;
    float falloff_3 = dpparams_1->primal_0[int(5)] * r6_3 + dpparams_1->primal_0[int(4)] * r4_12 + dpparams_1->primal_0[int(3)] * r2_17 + 1.0f;
    float _S694 = s_primal_ctx_clamp_0(falloff_3, 0.0f, 1.0f);
    float _S695 = rgb_out_6.x * _S694;
    float3  _S696 = rgb_out_6;
    *&((&_S696)->x) = _S695;
    float dx_13 = _S692 - dpparams_1->primal_0[int(6)];
    float dy_13 = _S693 - dpparams_1->primal_0[int(7)];
    float r2_18 = dx_13 * dx_13 + dy_13 * dy_13;
    float r4_13 = r2_18 * r2_18;
    float r6_4 = r4_13 * r2_18;
    float falloff_4 = dpparams_1->primal_0[int(10)] * r6_4 + dpparams_1->primal_0[int(9)] * r4_13 + dpparams_1->primal_0[int(8)] * r2_18 + 1.0f;
    float _S697 = s_primal_ctx_clamp_0(falloff_4, 0.0f, 1.0f);
    *&((&_S696)->y) = rgb_out_6.y * _S697;
    float dx_14 = _S692 - dpparams_1->primal_0[int(11)];
    float dy_14 = _S693 - dpparams_1->primal_0[int(12)];
    float r2_19 = dx_14 * dx_14 + dy_14 * dy_14;
    float r4_14 = r2_19 * r2_19;
    float r6_5 = r4_14 * r2_19;
    float falloff_5 = dpparams_1->primal_0[int(15)] * r6_5 + dpparams_1->primal_0[int(14)] * r4_14 + dpparams_1->primal_0[int(13)] * r2_19 + 1.0f;
    float _S698 = s_primal_ctx_clamp_0(falloff_5, 0.0f, 1.0f);
    *&((&_S696)->z) = rgb_out_6.z * _S698;
    PPISPParamsRQS_0 _S699 = _S663;
    float2  _S700 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S663.color_params_2.b_0);
    float2  _S701 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S663.color_params_2.r_0);
    float2  _S702 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S663.color_params_2.g_0);
    float2  _S703 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S663.color_params_2.n_0);
    float _S704 = 0.3333333432674408f + _S703.x;
    float _S705 = 0.3333333432674408f + _S703.y;
    Matrix<float, 3, 3>  T_5 = makeMatrix<float, 3, 3> (_S700.x, 1.0f + _S701.x, _S702.x, _S700.y, _S701.y, 1.0f + _S702.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  skew_1 = makeMatrix<float, 3, 3> (0.0f, -1.0f, _S705, 1.0f, 0.0f, - _S704, - _S705, _S704, 0.0f);
    Matrix<float, 3, 3>  _S706 = s_primal_ctx_mul_1(skew_1, T_5);
    float3  r0_5 = make_float3 (_S706.rows[int(0)].x, _S706.rows[int(0)].y, _S706.rows[int(0)].z);
    float3  r1_5 = make_float3 (_S706.rows[int(1)].x, _S706.rows[int(1)].y, _S706.rows[int(1)].z);
    float3  r2_20 = make_float3 (_S706.rows[int(2)].x, _S706.rows[int(2)].y, _S706.rows[int(2)].z);
    float3  _S707 = s_primal_ctx_cross_0(r0_5, r1_5);
    bool _S708 = (s_primal_ctx_dot_0(_S707, _S707)) < 9.99999968265522539e-21f;
    float3  lambda_v_13;
    float3  _S709;
    bool _S710;
    if(_S708)
    {
        float3  _S711 = s_primal_ctx_cross_0(r0_5, r2_20);
        bool _S712 = (s_primal_ctx_dot_0(_S711, _S711)) < 9.99999968265522539e-21f;
        if(_S712)
        {
            lambda_v_13 = s_primal_ctx_cross_0(r1_5, r2_20);
        }
        else
        {
            lambda_v_13 = _S711;
        }
        _S710 = _S712;
        _S709 = _S711;
    }
    else
    {
        lambda_v_13 = _S707;
        _S710 = false;
        _S709 = _S655;
    }
    Matrix<float, 3, 3>  S_inv_1 = makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f);
    Matrix<float, 3, 3>  D_1 = makeMatrix<float, 3, 3> (lambda_v_13.x, 0.0f, 0.0f, 0.0f, lambda_v_13.y, 0.0f, 0.0f, 0.0f, lambda_v_13.z);
    Matrix<float, 3, 3>  _S713 = s_primal_ctx_mul_1(T_5, D_1);
    Matrix<float, 3, 3>  _S714 = s_primal_ctx_mul_1(_S713, S_inv_1);
    bool _S715 = (s_primal_ctx_abs_0(_S714.rows[int(2)].z)) > 9.99999968265522539e-21f;
    Matrix<float, 3, 3>  H_9;
    Matrix<float, 3, 3>  _S716;
    float _S717;
    if(_S715)
    {
        float inv_s_1 = 1.0f / _S714.rows[int(2)].z;
        Matrix<float, 3, 3>  _S718 = makeMatrix<float, 3, 3> (inv_s_1);
        float _S719 = _S714.rows[int(2)].z * _S714.rows[int(2)].z;
        H_9 = _S714 * makeMatrix<float, 3, 3> (inv_s_1);
        _S716 = _S718;
        _S717 = _S719;
    }
    else
    {
        H_9 = _S714;
        _S716 = _S656;
        _S717 = 0.0f;
    }
    float _S720 = _S696.x;
    float _S721 = _S696.y;
    float intensity_5 = _S720 + _S721 + _S696.z;
    float3  rgi_in_1 = make_float3 (_S720, _S721, intensity_5);
    float3  _S722 = s_primal_ctx_mul_2(H_9, rgi_in_1);
    float _S723 = _S722.z;
    float _S724 = 0.00009999999747379f * s_primal_ctx_abs_0(intensity_5) + 9.99999993922529029e-09f;
    float _S725 = (F32_max((_S723), (_S724)));
    float norm_factor_5 = intensity_5 / _S725;
    float _S726 = _S725 * _S725;
    float _S727 = _S722.x;
    float out_r_5 = _S727 * norm_factor_5;
    float _S728 = _S722.y;
    float out_g_5 = _S728 * norm_factor_5;
    float3  _S729 = make_float3 (out_r_5, out_g_5, intensity_5 - out_r_5 - out_g_5);
    float3  _S730 = make_float3 (0.0f);
    float3  _S731 = make_float3 (1.0f);
    float3  _S732 = s_primal_ctx_clamp_1(_S729, _S730, _S731);
    float _S733 = _S732.x;
    float _S734 = s_primal_ctx_exp_0(_S673);
    float _S735 = s_primal_ctx_exp_0(_S674);
    float _S736 = - _S675;
    float _S737 = 1.0f + s_primal_ctx_exp_0(_S736);
    float x0_4 = 1.0f / _S737;
    float _S738 = _S737 * _S737;
    float _S739 = - _S676;
    float _S740 = 1.0f + s_primal_ctx_exp_0(_S739);
    float y0_4 = 1.0f / _S740;
    float _S741 = _S740 * _S740;
    float _S742 = s_primal_ctx_exp_0(_S677);
    bool _S743 = _S733 < x0_4;
    float _S744;
    float _S745;
    float _S746;
    float _S747;
    float _S748;
    float _S749;
    float _S750;
    float _S751;
    float _S752;
    float _S753;
    float _S754;
    float _S755;
    float _S756;
    float _S757;
    float _S758;
    float _S759;
    float _S760;
    float _S761;
    float _S762;
    float _S763;
    float _S764;
    float _S765;
    float _S766;
    float _S767;
    float _S768;
    float _S769;
    float _S770;
    if(_S743)
    {
        float s0_3 = y0_4 / x0_4;
        float _S771 = x0_4 * x0_4;
        float t0_3 = _S733 / x0_4;
        float _S772 = s0_3 * t0_3;
        float _S773 = _S734 * t0_3;
        float _S774 = 1.0f - t0_3;
        float _S775 = _S772 * t0_3 + _S773 * _S774;
        float _S776 = y0_4 * _S775;
        float _S777 = _S734 + _S742 - 2.0f * s0_3;
        float _S778 = _S777 * t0_3;
        float _S779 = s0_3 + _S778 * _S774;
        _S744 = _S779 * _S779;
        _S745 = _S776;
        _S746 = _S779;
        _S747 = _S778;
        _S748 = _S774;
        _S749 = _S777;
        _S750 = t0_3;
        _S751 = _S775;
        _S752 = _S773;
        _S753 = _S772;
        _S754 = s0_3;
        _S755 = _S771;
        _S756 = 0.0f;
        _S757 = 0.0f;
        _S758 = 0.0f;
        _S759 = 0.0f;
        _S760 = 0.0f;
        _S761 = 0.0f;
        _S762 = 0.0f;
        _S763 = 0.0f;
        _S764 = 0.0f;
        _S765 = 0.0f;
        _S766 = 0.0f;
        _S767 = 0.0f;
        _S768 = 0.0f;
        _S769 = 0.0f;
        _S770 = 0.0f;
    }
    else
    {
        float _S780 = 1.0f - y0_4;
        float _S781 = 1.0f - x0_4;
        float s1_3 = _S780 / _S781;
        float _S782 = _S781 * _S781;
        float _S783 = _S733 - x0_4;
        float t1_3 = _S783 / _S781;
        float _S784 = s1_3 * t1_3;
        float _S785 = _S742 * t1_3;
        float _S786 = 1.0f - t1_3;
        float _S787 = _S784 * t1_3 + _S785 * _S786;
        float _S788 = _S780 * _S787;
        float _S789 = _S742 + _S735 - 2.0f * s1_3;
        float _S790 = _S789 * t1_3;
        float _S791 = s1_3 + _S790 * _S786;
        float _S792 = _S791 * _S791;
        _S744 = 0.0f;
        _S745 = 0.0f;
        _S746 = 0.0f;
        _S747 = 0.0f;
        _S748 = 0.0f;
        _S749 = 0.0f;
        _S750 = 0.0f;
        _S751 = 0.0f;
        _S752 = 0.0f;
        _S753 = 0.0f;
        _S754 = 0.0f;
        _S755 = 0.0f;
        _S756 = _S792;
        _S757 = _S788;
        _S758 = _S791;
        _S759 = _S790;
        _S760 = _S786;
        _S761 = _S789;
        _S762 = t1_3;
        _S763 = _S780;
        _S764 = _S787;
        _S765 = _S785;
        _S766 = _S784;
        _S767 = s1_3;
        _S768 = _S782;
        _S769 = _S783;
        _S770 = _S781;
    }
    float _S793 = _S732.y;
    float _S794 = s_primal_ctx_exp_0(_S678);
    float _S795 = s_primal_ctx_exp_0(_S679);
    float _S796 = - _S680;
    float _S797 = 1.0f + s_primal_ctx_exp_0(_S796);
    float x0_5 = 1.0f / _S797;
    float _S798 = _S797 * _S797;
    float _S799 = - _S681;
    float _S800 = 1.0f + s_primal_ctx_exp_0(_S799);
    float y0_5 = 1.0f / _S800;
    float _S801 = _S800 * _S800;
    float _S802 = s_primal_ctx_exp_0(_S682);
    bool _S803 = _S793 < x0_5;
    float _S804;
    float _S805;
    float _S806;
    float _S807;
    float _S808;
    float _S809;
    float _S810;
    float _S811;
    float _S812;
    float _S813;
    float _S814;
    float _S815;
    float _S816;
    float _S817;
    float _S818;
    float _S819;
    float _S820;
    float _S821;
    float _S822;
    float _S823;
    float _S824;
    float _S825;
    float _S826;
    float _S827;
    float _S828;
    float _S829;
    float _S830;
    if(_S803)
    {
        float s0_4 = y0_5 / x0_5;
        float _S831 = x0_5 * x0_5;
        float t0_4 = _S793 / x0_5;
        float _S832 = s0_4 * t0_4;
        float _S833 = _S794 * t0_4;
        float _S834 = 1.0f - t0_4;
        float _S835 = _S832 * t0_4 + _S833 * _S834;
        float _S836 = y0_5 * _S835;
        float _S837 = _S794 + _S802 - 2.0f * s0_4;
        float _S838 = _S837 * t0_4;
        float _S839 = s0_4 + _S838 * _S834;
        _S804 = _S839 * _S839;
        _S805 = _S836;
        _S806 = _S839;
        _S807 = _S838;
        _S808 = _S834;
        _S809 = _S837;
        _S810 = t0_4;
        _S811 = _S835;
        _S812 = _S833;
        _S813 = _S832;
        _S814 = s0_4;
        _S815 = _S831;
        _S816 = 0.0f;
        _S817 = 0.0f;
        _S818 = 0.0f;
        _S819 = 0.0f;
        _S820 = 0.0f;
        _S821 = 0.0f;
        _S822 = 0.0f;
        _S823 = 0.0f;
        _S824 = 0.0f;
        _S825 = 0.0f;
        _S826 = 0.0f;
        _S827 = 0.0f;
        _S828 = 0.0f;
        _S829 = 0.0f;
        _S830 = 0.0f;
    }
    else
    {
        float _S840 = 1.0f - y0_5;
        float _S841 = 1.0f - x0_5;
        float s1_4 = _S840 / _S841;
        float _S842 = _S841 * _S841;
        float _S843 = _S793 - x0_5;
        float t1_4 = _S843 / _S841;
        float _S844 = s1_4 * t1_4;
        float _S845 = _S802 * t1_4;
        float _S846 = 1.0f - t1_4;
        float _S847 = _S844 * t1_4 + _S845 * _S846;
        float _S848 = _S840 * _S847;
        float _S849 = _S802 + _S795 - 2.0f * s1_4;
        float _S850 = _S849 * t1_4;
        float _S851 = s1_4 + _S850 * _S846;
        float _S852 = _S851 * _S851;
        _S804 = 0.0f;
        _S805 = 0.0f;
        _S806 = 0.0f;
        _S807 = 0.0f;
        _S808 = 0.0f;
        _S809 = 0.0f;
        _S810 = 0.0f;
        _S811 = 0.0f;
        _S812 = 0.0f;
        _S813 = 0.0f;
        _S814 = 0.0f;
        _S815 = 0.0f;
        _S816 = _S852;
        _S817 = _S848;
        _S818 = _S851;
        _S819 = _S850;
        _S820 = _S846;
        _S821 = _S849;
        _S822 = t1_4;
        _S823 = _S840;
        _S824 = _S847;
        _S825 = _S845;
        _S826 = _S844;
        _S827 = s1_4;
        _S828 = _S842;
        _S829 = _S843;
        _S830 = _S841;
    }
    float _S853 = _S732.z;
    float _S854 = s_primal_ctx_exp_0(_S683);
    float _S855 = s_primal_ctx_exp_0(_S684);
    float _S856 = - _S685;
    float _S857 = 1.0f + s_primal_ctx_exp_0(_S856);
    float x0_6 = 1.0f / _S857;
    float _S858 = _S857 * _S857;
    float _S859 = - _S686;
    float _S860 = 1.0f + s_primal_ctx_exp_0(_S859);
    float y0_6 = 1.0f / _S860;
    float _S861 = _S860 * _S860;
    float _S862 = s_primal_ctx_exp_0(_S687);
    bool _S863 = _S853 < x0_6;
    float _S864;
    float _S865;
    float _S866;
    float _S867;
    float _S868;
    float _S869;
    float _S870;
    float _S871;
    float _S872;
    float _S873;
    float _S874;
    float _S875;
    float _S876;
    float _S877;
    float _S878;
    float _S879;
    float _S880;
    float _S881;
    float _S882;
    float _S883;
    float _S884;
    float _S885;
    float _S886;
    float _S887;
    float _S888;
    float _S889;
    float _S890;
    if(_S863)
    {
        float s0_5 = y0_6 / x0_6;
        float _S891 = x0_6 * x0_6;
        float t0_5 = _S853 / x0_6;
        float _S892 = s0_5 * t0_5;
        float _S893 = _S854 * t0_5;
        float _S894 = 1.0f - t0_5;
        float _S895 = _S892 * t0_5 + _S893 * _S894;
        float _S896 = y0_6 * _S895;
        float _S897 = _S854 + _S862 - 2.0f * s0_5;
        float _S898 = _S897 * t0_5;
        float _S899 = s0_5 + _S898 * _S894;
        _S864 = _S899 * _S899;
        _S865 = _S896;
        _S866 = _S899;
        _S867 = _S898;
        _S868 = _S894;
        _S869 = _S897;
        _S870 = t0_5;
        _S871 = _S895;
        _S872 = _S893;
        _S873 = _S892;
        _S874 = s0_5;
        _S875 = _S891;
        _S876 = 0.0f;
        _S877 = 0.0f;
        _S878 = 0.0f;
        _S879 = 0.0f;
        _S880 = 0.0f;
        _S881 = 0.0f;
        _S882 = 0.0f;
        _S883 = 0.0f;
        _S884 = 0.0f;
        _S885 = 0.0f;
        _S886 = 0.0f;
        _S887 = 0.0f;
        _S888 = 0.0f;
        _S889 = 0.0f;
        _S890 = 0.0f;
    }
    else
    {
        float _S900 = 1.0f - y0_6;
        float _S901 = 1.0f - x0_6;
        float s1_5 = _S900 / _S901;
        float _S902 = _S901 * _S901;
        float _S903 = _S853 - x0_6;
        float t1_5 = _S903 / _S901;
        float _S904 = s1_5 * t1_5;
        float _S905 = _S862 * t1_5;
        float _S906 = 1.0f - t1_5;
        float _S907 = _S904 * t1_5 + _S905 * _S906;
        float _S908 = _S900 * _S907;
        float _S909 = _S862 + _S855 - 2.0f * s1_5;
        float _S910 = _S909 * t1_5;
        float _S911 = s1_5 + _S910 * _S906;
        float _S912 = _S911 * _S911;
        _S864 = 0.0f;
        _S865 = 0.0f;
        _S866 = 0.0f;
        _S867 = 0.0f;
        _S868 = 0.0f;
        _S869 = 0.0f;
        _S870 = 0.0f;
        _S871 = 0.0f;
        _S872 = 0.0f;
        _S873 = 0.0f;
        _S874 = 0.0f;
        _S875 = 0.0f;
        _S876 = _S912;
        _S877 = _S908;
        _S878 = _S911;
        _S879 = _S910;
        _S880 = _S906;
        _S881 = _S909;
        _S882 = t1_5;
        _S883 = _S900;
        _S884 = _S907;
        _S885 = _S905;
        _S886 = _S904;
        _S887 = s1_5;
        _S888 = _S902;
        _S889 = _S903;
        _S890 = _S901;
    }
    if(_S863)
    {
        float _S913 = _s_dOut_1.z / _S864;
        float _S914 = _S865 * - _S913;
        float _S915 = _S866 * _S913;
        float _S916 = _S868 * _S914;
        float _S917 = _S870 * _S916;
        float _S918 = y0_6 * _S915;
        float _S919 = _S868 * _S918;
        float _S920 = _S870 * _S918;
        float _S921 = (_S869 * _S916 + - (_S867 * _S914 + _S872 * _S918) + _S854 * _S919 + _S873 * _S918 + _S874 * _S920) / _S875;
        float _S922 = x0_6 * _S921;
        float _S923 = (_S914 + 2.0f * - _S917 + _S870 * _S920) / _S875;
        float _S924 = _S871 * _S915 + x0_6 * _S923;
        float _S925 = _S917 + _S870 * _S919;
        float _S926 = _S853 * - _S921 + y0_6 * - _S923;
        _S864 = _S917;
        _S865 = _S924;
        _S866 = _S926;
        _S867 = 0.0f;
        _S868 = _S925;
        _S869 = _S922;
    }
    else
    {
        float _S927 = _s_dOut_1.z / _S876;
        float _S928 = _S877 * - _S927;
        float _S929 = _S878 * _S927;
        float _S930 = _S880 * _S928;
        float _S931 = _S882 * _S930;
        float _S932 = _S883 * _S929;
        float _S933 = _S880 * _S932;
        float _S934 = _S882 * _S932;
        float _S935 = (_S881 * _S930 + - (_S879 * _S928 + _S885 * _S932) + _S862 * _S933 + _S886 * _S932 + _S887 * _S934) / _S888;
        float _S936 = _S890 * _S935;
        float _S937 = (_S928 + 2.0f * - _S931 + _S882 * _S934) / _S888;
        float _S938 = _s_dOut_1.z + - (_S884 * _S929 + _S890 * _S937);
        float _S939 = - _S936 + - (_S889 * - _S935 + _S883 * - _S937);
        _S864 = _S931 + _S882 * _S933;
        _S865 = _S938;
        _S866 = _S939;
        _S867 = _S931;
        _S868 = 0.0f;
        _S869 = _S936;
    }
    DiffPair_float_0 _S940;
    (&_S940)->primal_0 = _S687;
    (&_S940)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S940, _S864);
    DiffPair_float_0 _S941 = _S940;
    float _S942 = - (_S865 / _S861);
    DiffPair_float_0 _S943;
    (&_S943)->primal_0 = _S859;
    (&_S943)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S943, _S942);
    float _S944 = - _S943.differential_0;
    float _S945 = - (_S866 / _S858);
    DiffPair_float_0 _S946;
    (&_S946)->primal_0 = _S856;
    (&_S946)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S946, _S945);
    float _S947 = - _S946.differential_0;
    DiffPair_float_0 _S948;
    (&_S948)->primal_0 = _S684;
    (&_S948)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S948, _S867);
    DiffPair_float_0 _S949 = _S948;
    DiffPair_float_0 _S950;
    (&_S950)->primal_0 = _S683;
    (&_S950)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S950, _S868);
    DiffPair_float_0 _S951 = _S950;
    float3  _S952 = make_float3 (0.0f, 0.0f, _S869);
    if(_S803)
    {
        float _S953 = _s_dOut_1.y / _S804;
        float _S954 = _S805 * - _S953;
        float _S955 = _S806 * _S953;
        float _S956 = _S808 * _S954;
        float _S957 = _S810 * _S956;
        float _S958 = y0_5 * _S955;
        float _S959 = _S808 * _S958;
        float _S960 = _S810 * _S958;
        float _S961 = (_S809 * _S956 + - (_S807 * _S954 + _S812 * _S958) + _S794 * _S959 + _S813 * _S958 + _S814 * _S960) / _S815;
        float _S962 = x0_5 * _S961;
        float _S963 = (_S954 + 2.0f * - _S957 + _S810 * _S960) / _S815;
        float _S964 = _S811 * _S955 + x0_5 * _S963;
        float _S965 = _S957 + _S810 * _S959;
        float _S966 = _S793 * - _S961 + y0_5 * - _S963;
        _S804 = _S957;
        _S805 = _S964;
        _S806 = _S966;
        _S807 = 0.0f;
        _S808 = _S965;
        _S809 = _S962;
    }
    else
    {
        float _S967 = _s_dOut_1.y / _S816;
        float _S968 = _S817 * - _S967;
        float _S969 = _S818 * _S967;
        float _S970 = _S820 * _S968;
        float _S971 = _S822 * _S970;
        float _S972 = _S823 * _S969;
        float _S973 = _S820 * _S972;
        float _S974 = _S822 * _S972;
        float _S975 = (_S821 * _S970 + - (_S819 * _S968 + _S825 * _S972) + _S802 * _S973 + _S826 * _S972 + _S827 * _S974) / _S828;
        float _S976 = _S830 * _S975;
        float _S977 = (_S968 + 2.0f * - _S971 + _S822 * _S974) / _S828;
        float _S978 = _s_dOut_1.y + - (_S824 * _S969 + _S830 * _S977);
        float _S979 = - _S976 + - (_S829 * - _S975 + _S823 * - _S977);
        _S804 = _S971 + _S822 * _S973;
        _S805 = _S978;
        _S806 = _S979;
        _S807 = _S971;
        _S808 = 0.0f;
        _S809 = _S976;
    }
    DiffPair_float_0 _S980;
    (&_S980)->primal_0 = _S682;
    (&_S980)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S980, _S804);
    DiffPair_float_0 _S981 = _S980;
    float _S982 = - (_S805 / _S801);
    DiffPair_float_0 _S983;
    (&_S983)->primal_0 = _S799;
    (&_S983)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S983, _S982);
    float _S984 = - _S983.differential_0;
    float _S985 = - (_S806 / _S798);
    DiffPair_float_0 _S986;
    (&_S986)->primal_0 = _S796;
    (&_S986)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S986, _S985);
    float _S987 = - _S986.differential_0;
    DiffPair_float_0 _S988;
    (&_S988)->primal_0 = _S679;
    (&_S988)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S988, _S807);
    DiffPair_float_0 _S989 = _S988;
    DiffPair_float_0 _S990;
    (&_S990)->primal_0 = _S678;
    (&_S990)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S990, _S808);
    DiffPair_float_0 _S991 = _S990;
    float3  _S992 = _S952 + make_float3 (0.0f, _S809, 0.0f);
    if(_S743)
    {
        float _S993 = _s_dOut_1.x / _S744;
        float _S994 = _S745 * - _S993;
        float _S995 = _S746 * _S993;
        float _S996 = _S748 * _S994;
        float _S997 = _S750 * _S996;
        float _S998 = y0_4 * _S995;
        float _S999 = _S748 * _S998;
        float _S1000 = _S750 * _S998;
        float _S1001 = (_S749 * _S996 + - (_S747 * _S994 + _S752 * _S998) + _S734 * _S999 + _S753 * _S998 + _S754 * _S1000) / _S755;
        float _S1002 = x0_4 * _S1001;
        float _S1003 = (_S994 + 2.0f * - _S997 + _S750 * _S1000) / _S755;
        float _S1004 = _S751 * _S995 + x0_4 * _S1003;
        float _S1005 = _S997 + _S750 * _S999;
        float _S1006 = _S733 * - _S1001 + y0_4 * - _S1003;
        _S744 = _S997;
        _S745 = _S1004;
        _S746 = _S1006;
        _S747 = 0.0f;
        _S748 = _S1005;
        _S749 = _S1002;
    }
    else
    {
        float _S1007 = _s_dOut_1.x / _S756;
        float _S1008 = _S757 * - _S1007;
        float _S1009 = _S758 * _S1007;
        float _S1010 = _S760 * _S1008;
        float _S1011 = _S762 * _S1010;
        float _S1012 = _S763 * _S1009;
        float _S1013 = _S760 * _S1012;
        float _S1014 = _S762 * _S1012;
        float _S1015 = (_S761 * _S1010 + - (_S759 * _S1008 + _S765 * _S1012) + _S742 * _S1013 + _S766 * _S1012 + _S767 * _S1014) / _S768;
        float _S1016 = _S770 * _S1015;
        float _S1017 = (_S1008 + 2.0f * - _S1011 + _S762 * _S1014) / _S768;
        float _S1018 = _s_dOut_1.x + - (_S764 * _S1009 + _S770 * _S1017);
        float _S1019 = - _S1016 + - (_S769 * - _S1015 + _S763 * - _S1017);
        _S744 = _S1011 + _S762 * _S1013;
        _S745 = _S1018;
        _S746 = _S1019;
        _S747 = _S1011;
        _S748 = 0.0f;
        _S749 = _S1016;
    }
    DiffPair_float_0 _S1020;
    (&_S1020)->primal_0 = _S677;
    (&_S1020)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S1020, _S744);
    DiffPair_float_0 _S1021 = _S1020;
    float _S1022 = - (_S745 / _S741);
    DiffPair_float_0 _S1023;
    (&_S1023)->primal_0 = _S739;
    (&_S1023)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S1023, _S1022);
    float _S1024 = - _S1023.differential_0;
    float _S1025 = - (_S746 / _S738);
    DiffPair_float_0 _S1026;
    (&_S1026)->primal_0 = _S736;
    (&_S1026)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S1026, _S1025);
    float _S1027 = - _S1026.differential_0;
    DiffPair_float_0 _S1028;
    (&_S1028)->primal_0 = _S674;
    (&_S1028)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S1028, _S747);
    DiffPair_float_0 _S1029 = _S1028;
    DiffPair_float_0 _S1030;
    (&_S1030)->primal_0 = _S673;
    (&_S1030)->differential_0 = 0.0f;
    s_bwd_prop_exp_0(&_S1030, _S748);
    DiffPair_float_0 _S1031 = _S1030;
    float3  _S1032 = _S992 + make_float3 (_S749, 0.0f, 0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1033;
    (&_S1033)->primal_0 = _S729;
    (&_S1033)->differential_0 = _S655;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1034;
    (&_S1034)->primal_0 = _S730;
    (&_S1034)->differential_0 = _S655;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1035;
    (&_S1035)->primal_0 = _S731;
    (&_S1035)->differential_0 = _S655;
    s_bwd_prop_clamp_0(&_S1033, &_S1034, &_S1035, _S1032);
    float _S1036 = - _S1033.differential_0.z;
    float _S1037 = _S1033.differential_0.y + _S1036;
    float _S1038 = norm_factor_5 * _S1037;
    float _S1039 = _S1033.differential_0.x + _S1036;
    float _S1040 = norm_factor_5 * _S1039;
    float _S1041 = (_S728 * _S1037 + _S727 * _S1039) / _S726;
    float _S1042 = intensity_5 * - _S1041;
    float _S1043 = _S725 * _S1041;
    DiffPair_float_0 _S1044;
    (&_S1044)->primal_0 = _S723;
    (&_S1044)->differential_0 = 0.0f;
    DiffPair_float_0 _S1045;
    (&_S1045)->primal_0 = _S724;
    (&_S1045)->differential_0 = 0.0f;
    _d_max_0(&_S1044, &_S1045, _S1042);
    float _S1046 = 0.00009999999747379f * _S1045.differential_0;
    DiffPair_float_0 _S1047;
    (&_S1047)->primal_0 = intensity_5;
    (&_S1047)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1047, _S1046);
    float3  _S1048 = make_float3 (_S1040, _S1038, _S1044.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1049;
    (&_S1049)->primal_0 = H_9;
    (&_S1049)->differential_0 = _S656;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1050;
    (&_S1050)->primal_0 = rgi_in_1;
    (&_S1050)->differential_0 = _S655;
    s_bwd_prop_mul_0(&_S1049, &_S1050, _S1048);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1051 = _S1049;
    float _S1052 = _S1033.differential_0.z + _S1043 + _S1047.differential_0 + _S1050.differential_0.z;
    float _S1053 = _S1050.differential_0.y + _S1052;
    float _S1054 = _S1050.differential_0.x + _S1052;
    float3  _S1055 = make_float3 (_S1054, _S1053, _S1052);
    if(_S715)
    {
        Matrix<float, 3, 3>  _S1056 = _S714 * _S1051.differential_0;
        Matrix<float, 3, 3>  _S1057 = _S716 * _S1051.differential_0;
        _S717 = - ((_S1056.rows[int(0)].x + _S1056.rows[int(0)].y + _S1056.rows[int(0)].z + _S1056.rows[int(1)].x + _S1056.rows[int(1)].y + _S1056.rows[int(1)].z + _S1056.rows[int(2)].x + _S1056.rows[int(2)].y + _S1056.rows[int(2)].z) / _S717);
        H_9 = _S1057;
    }
    else
    {
        _S717 = 0.0f;
        H_9 = _S1051.differential_0;
    }
    DiffPair_float_0 _S1058;
    (&_S1058)->primal_0 = _S714.rows[int(2)].z;
    (&_S1058)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1058, 0.0f);
    float _S1059 = _S1058.differential_0 + _S717;
    float3  _S1060 = _S655;
    *&((&_S1060)->z) = _S1059;
    Matrix<float, 3, 3>  _S1061 = _S656;
    _S1061[int(2)] = _S1060;
    Matrix<float, 3, 3>  _S1062 = H_9 + _S1061;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1063;
    (&_S1063)->primal_0 = _S713;
    (&_S1063)->differential_0 = _S656;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1064;
    (&_S1064)->primal_0 = S_inv_1;
    (&_S1064)->differential_0 = _S656;
    s_bwd_prop_mul_1(&_S1063, &_S1064, _S1062);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1065;
    (&_S1065)->primal_0 = T_5;
    (&_S1065)->differential_0 = _S656;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1066;
    (&_S1066)->primal_0 = D_1;
    (&_S1066)->differential_0 = _S656;
    s_bwd_prop_mul_1(&_S1065, &_S1066, _S1063.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1067 = _S1065;
    float3  _S1068 = make_float3 (_S1066.differential_0.rows[int(0)].x, _S1066.differential_0.rows[int(1)].y, _S1066.differential_0.rows[int(2)].z);
    float3  _S1069;
    if(_S708)
    {
        if(_S710)
        {
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1070;
            (&_S1070)->primal_0 = r1_5;
            (&_S1070)->differential_0 = _S655;
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1071;
            (&_S1071)->primal_0 = r2_20;
            (&_S1071)->differential_0 = _S655;
            s_bwd_prop_cross_0(&_S1070, &_S1071, _S1068);
            _S696 = _S655;
            lambda_v_13 = _S1071.differential_0;
            _S1069 = _S1070.differential_0;
        }
        else
        {
            _S696 = _S1068;
            lambda_v_13 = _S655;
            _S1069 = _S655;
        }
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1072;
        (&_S1072)->primal_0 = _S709;
        (&_S1072)->differential_0 = _S655;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1073;
        (&_S1073)->primal_0 = _S709;
        (&_S1073)->differential_0 = _S655;
        s_bwd_prop_dot_0(&_S1072, &_S1073, 0.0f);
        float3  _S1074 = _S1073.differential_0 + _S1072.differential_0 + _S696;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1075;
        (&_S1075)->primal_0 = r0_5;
        (&_S1075)->differential_0 = _S655;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1076;
        (&_S1076)->primal_0 = r2_20;
        (&_S1076)->differential_0 = _S655;
        s_bwd_prop_cross_0(&_S1075, &_S1076, _S1074);
        float3  _S1077 = _S1076.differential_0 + lambda_v_13;
        _S696 = _S655;
        lambda_v_13 = _S1077;
        _S709 = _S1069;
        _S1069 = _S1075.differential_0;
    }
    else
    {
        _S696 = _S1068;
        lambda_v_13 = _S655;
        _S709 = _S655;
        _S1069 = _S655;
    }
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1078;
    (&_S1078)->primal_0 = _S707;
    (&_S1078)->differential_0 = _S655;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1079;
    (&_S1079)->primal_0 = _S707;
    (&_S1079)->differential_0 = _S655;
    s_bwd_prop_dot_0(&_S1078, &_S1079, 0.0f);
    float3  _S1080 = _S1079.differential_0 + _S1078.differential_0 + _S696;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1081;
    (&_S1081)->primal_0 = r0_5;
    (&_S1081)->differential_0 = _S655;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1082;
    (&_S1082)->primal_0 = r1_5;
    (&_S1082)->differential_0 = _S655;
    s_bwd_prop_cross_0(&_S1081, &_S1082, _S1080);
    float3  _S1083 = _S655;
    *&((&_S1083)->z) = lambda_v_13.z;
    *&((&_S1083)->y) = lambda_v_13.y;
    *&((&_S1083)->x) = lambda_v_13.x;
    float3  _S1084 = _S1082.differential_0 + _S709;
    float3  _S1085 = _S655;
    *&((&_S1085)->z) = _S1084.z;
    *&((&_S1085)->y) = _S1084.y;
    *&((&_S1085)->x) = _S1084.x;
    float3  _S1086 = _S1081.differential_0 + _S1069;
    float3  _S1087 = _S655;
    *&((&_S1087)->z) = _S1086.z;
    *&((&_S1087)->y) = _S1086.y;
    *&((&_S1087)->x) = _S1086.x;
    Matrix<float, 3, 3>  _S1088 = _S656;
    _S1088[int(2)] = _S1083;
    _S1088[int(1)] = _S1085;
    _S1088[int(0)] = _S1087;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1089;
    (&_S1089)->primal_0 = skew_1;
    (&_S1089)->differential_0 = _S656;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1090;
    (&_S1090)->primal_0 = T_5;
    (&_S1090)->differential_0 = _S656;
    s_bwd_prop_mul_1(&_S1089, &_S1090, _S1088);
    Matrix<float, 3, 3>  _S1091 = _S1090.differential_0 + _S1067.differential_0;
    float2  _S1092 = make_float2 (_S1089.differential_0.rows[int(2)].y + - _S1089.differential_0.rows[int(1)].z, _S1089.differential_0.rows[int(0)].z + - _S1089.differential_0.rows[int(2)].x);
    Matrix<float, 2, 2>  _S1093 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1094;
    (&_S1094)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S1094)->differential_0 = _S1093;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1095;
    (&_S1095)->primal_0 = _S699.color_params_2.n_0;
    (&_S1095)->differential_0 = _S659;
    s_bwd_prop_mul_2(&_S1094, &_S1095, _S1092);
    float2  _S1096 = make_float2 (_S1091.rows[int(0)].z, _S1091.rows[int(1)].z);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1097;
    (&_S1097)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S1097)->differential_0 = _S1093;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1098;
    (&_S1098)->primal_0 = _S699.color_params_2.g_0;
    (&_S1098)->differential_0 = _S659;
    s_bwd_prop_mul_2(&_S1097, &_S1098, _S1096);
    float2  _S1099 = make_float2 (_S1091.rows[int(0)].y, _S1091.rows[int(1)].y);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1100;
    (&_S1100)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S1100)->differential_0 = _S1093;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1101;
    (&_S1101)->primal_0 = _S699.color_params_2.r_0;
    (&_S1101)->differential_0 = _S659;
    s_bwd_prop_mul_2(&_S1100, &_S1101, _S1099);
    float2  _S1102 = make_float2 (_S1091.rows[int(0)].x, _S1091.rows[int(1)].x);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1103;
    (&_S1103)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S1103)->differential_0 = _S1093;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1104;
    (&_S1104)->primal_0 = _S699.color_params_2.b_0;
    (&_S1104)->differential_0 = _S659;
    s_bwd_prop_mul_2(&_S1103, &_S1104, _S1102);
    ColorPPISPParams_0 _S1105 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S1105)->n_0 = _S1095.differential_0;
    (&_S1105)->g_0 = _S1098.differential_0;
    (&_S1105)->r_0 = _S1101.differential_0;
    (&_S1105)->b_0 = _S1104.differential_0;
    _S696 = _S1055;
    *&((&_S696)->z) = 0.0f;
    float _S1106 = rgb_out_6.z * _S1052;
    float _S1107 = _S698 * _S1052;
    DiffPair_float_0 _S1108;
    (&_S1108)->primal_0 = falloff_5;
    (&_S1108)->differential_0 = 0.0f;
    DiffPair_float_0 _S1109;
    (&_S1109)->primal_0 = 0.0f;
    (&_S1109)->differential_0 = 0.0f;
    DiffPair_float_0 _S1110;
    (&_S1110)->primal_0 = 1.0f;
    (&_S1110)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1108, &_S1109, &_S1110, _S1106);
    float _S1111 = r2_19 * _S1108.differential_0;
    float _S1112 = r4_14 * _S1108.differential_0;
    float s_diff_r6_T_3 = _S672 * _S1108.differential_0;
    float _S1113 = r6_5 * _S1108.differential_0;
    float _S1114 = r2_19 * (_S671 * _S1108.differential_0 + r2_19 * s_diff_r6_T_3);
    float _S1115 = _S670 * _S1108.differential_0 + r4_14 * s_diff_r6_T_3 + _S1114 + _S1114;
    float _S1116 = dy_14 * _S1115;
    float _S1117 = dx_14 * _S1115;
    float _S1118 = - (_S1116 + _S1116);
    float _S1119 = - (_S1117 + _S1117);
    *&((&_S696)->y) = 0.0f;
    float _S1120 = rgb_out_6.y * _S1053;
    float _S1121 = _S697 * _S1053;
    DiffPair_float_0 _S1122;
    (&_S1122)->primal_0 = falloff_4;
    (&_S1122)->differential_0 = 0.0f;
    DiffPair_float_0 _S1123;
    (&_S1123)->primal_0 = 0.0f;
    (&_S1123)->differential_0 = 0.0f;
    DiffPair_float_0 _S1124;
    (&_S1124)->primal_0 = 1.0f;
    (&_S1124)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1122, &_S1123, &_S1124, _S1120);
    float _S1125 = r2_18 * _S1122.differential_0;
    float _S1126 = r4_13 * _S1122.differential_0;
    float s_diff_r6_T_4 = _S669 * _S1122.differential_0;
    float _S1127 = r6_4 * _S1122.differential_0;
    float _S1128 = r2_18 * (_S668 * _S1122.differential_0 + r2_18 * s_diff_r6_T_4);
    float _S1129 = _S667 * _S1122.differential_0 + r4_13 * s_diff_r6_T_4 + _S1128 + _S1128;
    float _S1130 = dy_13 * _S1129;
    float _S1131 = dx_13 * _S1129;
    float _S1132 = - (_S1130 + _S1130);
    float _S1133 = - (_S1131 + _S1131);
    *&((&_S696)->x) = 0.0f;
    float _S1134 = rgb_out_6.x * _S1054;
    float _S1135 = _S694 * _S1054;
    DiffPair_float_0 _S1136;
    (&_S1136)->primal_0 = falloff_3;
    (&_S1136)->differential_0 = 0.0f;
    DiffPair_float_0 _S1137;
    (&_S1137)->primal_0 = 0.0f;
    (&_S1137)->differential_0 = 0.0f;
    DiffPair_float_0 _S1138;
    (&_S1138)->primal_0 = 1.0f;
    (&_S1138)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1136, &_S1137, &_S1138, _S1134);
    float _S1139 = r2_17 * _S1136.differential_0;
    float _S1140 = r4_12 * _S1136.differential_0;
    float s_diff_r6_T_5 = _S666 * _S1136.differential_0;
    float _S1141 = r6_3 * _S1136.differential_0;
    float _S1142 = r2_17 * (_S665 * _S1136.differential_0 + r2_17 * s_diff_r6_T_5);
    float _S1143 = _S664 * _S1136.differential_0 + r4_12 * s_diff_r6_T_5 + _S1142 + _S1142;
    float _S1144 = dy_12 * _S1143;
    float _S1145 = dx_12 * _S1143;
    float _S1146 = - (_S1144 + _S1144);
    float _S1147 = - (_S1145 + _S1145);
    float3  _S1148 = _S655;
    *&((&_S1148)->z) = _S1107;
    *&((&_S1148)->y) = _S1121;
    *&((&_S1148)->x) = _S1135;
    float3  _S1149 = _S696 + _S1148;
    float3  _S1150 = _S654.primal_0 * _S1149;
    float3  _S1151 = _S690 * _S1149;
    float _S1152 = _S1150.x + _S1150.y + _S1150.z;
    DiffPair_float_0 _S1153;
    (&_S1153)->primal_0 = _S688.exposure_2;
    (&_S1153)->differential_0 = 0.0f;
    s_bwd_prop_exp2_0(&_S1153, _S1152);
    PPISPParamsRQS_0 _S1154 = PPISPParamsRQS_x24_syn_dzero_0();
    (&_S1154)->color_params_2 = _S1105;
    (&_S1154)->exposure_2 = _S1153.differential_0;
    _S663 = _S1154;
    (&(&_S663)->crf_params_0[int(2)])->gc_0 = 0.0f;
    float _S1155 = _S1154.crf_params_0[int(2)].gc_0 + _S941.differential_0;
    (&(&_S663)->crf_params_0[int(2)])->y0_0 = 0.0f;
    float _S1156 = _S1154.crf_params_0[int(2)].y0_0 + _S944;
    (&(&_S663)->crf_params_0[int(2)])->x0_0 = 0.0f;
    float _S1157 = _S1154.crf_params_0[int(2)].x0_0 + _S947;
    (&(&_S663)->crf_params_0[int(2)])->g1_0 = 0.0f;
    float _S1158 = _S1154.crf_params_0[int(2)].g1_0 + _S949.differential_0;
    (&(&_S663)->crf_params_0[int(2)])->g0_0 = 0.0f;
    float _S1159 = _S1154.crf_params_0[int(2)].g0_0 + _S951.differential_0;
    (&(&_S663)->crf_params_0[int(1)])->gc_0 = 0.0f;
    float _S1160 = _S1154.crf_params_0[int(1)].gc_0 + _S981.differential_0;
    (&(&_S663)->crf_params_0[int(1)])->y0_0 = 0.0f;
    float _S1161 = _S1154.crf_params_0[int(1)].y0_0 + _S984;
    (&(&_S663)->crf_params_0[int(1)])->x0_0 = 0.0f;
    float _S1162 = _S1154.crf_params_0[int(1)].x0_0 + _S987;
    (&(&_S663)->crf_params_0[int(1)])->g1_0 = 0.0f;
    float _S1163 = _S1154.crf_params_0[int(1)].g1_0 + _S989.differential_0;
    (&(&_S663)->crf_params_0[int(1)])->g0_0 = 0.0f;
    float _S1164 = _S1154.crf_params_0[int(1)].g0_0 + _S991.differential_0;
    (&(&_S663)->crf_params_0[int(0)])->gc_0 = 0.0f;
    float _S1165 = _S1154.crf_params_0[int(0)].gc_0 + _S1021.differential_0;
    (&(&_S663)->crf_params_0[int(0)])->y0_0 = 0.0f;
    float _S1166 = _S1154.crf_params_0[int(0)].y0_0 + _S1024;
    (&(&_S663)->crf_params_0[int(0)])->x0_0 = 0.0f;
    float _S1167 = _S1154.crf_params_0[int(0)].x0_0 + _S1027;
    (&(&_S663)->crf_params_0[int(0)])->g1_0 = 0.0f;
    float _S1168 = _S1154.crf_params_0[int(0)].g1_0 + _S1029.differential_0;
    (&(&_S663)->crf_params_0[int(0)])->g0_0 = 0.0f;
    float _S1169 = _S1154.crf_params_0[int(0)].g0_0 + _S1031.differential_0;
    *&((&(&(&_S663)->color_params_2)->n_0)->y) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->n_0)->x) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->g_0)->y) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->g_0)->x) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->r_0)->y) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->r_0)->x) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->b_0)->y) = 0.0f;
    *&((&(&(&_S663)->color_params_2)->b_0)->x) = 0.0f;
    (&(&_S663)->vignette_params_1[int(2)])->alpha2_0 = 0.0f;
    float _S1170 = _S1113 + _S1154.vignette_params_1[int(2)].alpha2_0;
    (&(&_S663)->vignette_params_1[int(2)])->alpha1_0 = 0.0f;
    float _S1171 = _S1112 + _S1154.vignette_params_1[int(2)].alpha1_0;
    (&(&_S663)->vignette_params_1[int(2)])->alpha0_0 = 0.0f;
    float _S1172 = _S1111 + _S1154.vignette_params_1[int(2)].alpha0_0;
    (&(&_S663)->vignette_params_1[int(2)])->cy_0 = 0.0f;
    float _S1173 = _S1118 + _S1154.vignette_params_1[int(2)].cy_0;
    (&(&_S663)->vignette_params_1[int(2)])->cx_0 = 0.0f;
    float _S1174 = _S1119 + _S1154.vignette_params_1[int(2)].cx_0;
    (&(&_S663)->vignette_params_1[int(1)])->alpha2_0 = 0.0f;
    float _S1175 = _S1127 + _S1154.vignette_params_1[int(1)].alpha2_0;
    (&(&_S663)->vignette_params_1[int(1)])->alpha1_0 = 0.0f;
    float _S1176 = _S1126 + _S1154.vignette_params_1[int(1)].alpha1_0;
    (&(&_S663)->vignette_params_1[int(1)])->alpha0_0 = 0.0f;
    float _S1177 = _S1125 + _S1154.vignette_params_1[int(1)].alpha0_0;
    (&(&_S663)->vignette_params_1[int(1)])->cy_0 = 0.0f;
    float _S1178 = _S1132 + _S1154.vignette_params_1[int(1)].cy_0;
    (&(&_S663)->vignette_params_1[int(1)])->cx_0 = 0.0f;
    float _S1179 = _S1133 + _S1154.vignette_params_1[int(1)].cx_0;
    (&(&_S663)->vignette_params_1[int(0)])->alpha2_0 = 0.0f;
    float _S1180 = _S1141 + _S1154.vignette_params_1[int(0)].alpha2_0;
    (&(&_S663)->vignette_params_1[int(0)])->alpha1_0 = 0.0f;
    float _S1181 = _S1140 + _S1154.vignette_params_1[int(0)].alpha1_0;
    (&(&_S663)->vignette_params_1[int(0)])->alpha0_0 = 0.0f;
    float _S1182 = _S1139 + _S1154.vignette_params_1[int(0)].alpha0_0;
    (&(&_S663)->vignette_params_1[int(0)])->cy_0 = 0.0f;
    float _S1183 = _S1146 + _S1154.vignette_params_1[int(0)].cy_0;
    (&(&_S663)->vignette_params_1[int(0)])->cx_0 = 0.0f;
    float _S1184 = _S1147 + _S1154.vignette_params_1[int(0)].cx_0;
    FixedArray<float, 39>  _S1185;
    _S1185[int(0)] = 0.0f;
    _S1185[int(1)] = 0.0f;
    _S1185[int(2)] = 0.0f;
    _S1185[int(3)] = 0.0f;
    _S1185[int(4)] = 0.0f;
    _S1185[int(5)] = 0.0f;
    _S1185[int(6)] = 0.0f;
    _S1185[int(7)] = 0.0f;
    _S1185[int(8)] = 0.0f;
    _S1185[int(9)] = 0.0f;
    _S1185[int(10)] = 0.0f;
    _S1185[int(11)] = 0.0f;
    _S1185[int(12)] = 0.0f;
    _S1185[int(13)] = 0.0f;
    _S1185[int(14)] = 0.0f;
    _S1185[int(15)] = 0.0f;
    _S1185[int(16)] = 0.0f;
    _S1185[int(17)] = 0.0f;
    _S1185[int(18)] = 0.0f;
    _S1185[int(19)] = 0.0f;
    _S1185[int(20)] = 0.0f;
    _S1185[int(21)] = 0.0f;
    _S1185[int(22)] = 0.0f;
    _S1185[int(23)] = 0.0f;
    _S1185[int(24)] = 0.0f;
    _S1185[int(25)] = 0.0f;
    _S1185[int(26)] = 0.0f;
    _S1185[int(27)] = 0.0f;
    _S1185[int(28)] = 0.0f;
    _S1185[int(29)] = 0.0f;
    _S1185[int(30)] = 0.0f;
    _S1185[int(31)] = 0.0f;
    _S1185[int(32)] = 0.0f;
    _S1185[int(33)] = 0.0f;
    _S1185[int(34)] = 0.0f;
    _S1185[int(35)] = 0.0f;
    _S1185[int(36)] = 0.0f;
    _S1185[int(37)] = 0.0f;
    _S1185[int(38)] = 0.0f;
    _S1185[int(9)] = _S1176;
    _S1185[int(18)] = _S1154.color_params_2.r_0.x;
    _S1185[int(17)] = _S1154.color_params_2.b_0.y;
    _S1185[int(16)] = _S1154.color_params_2.b_0.x;
    _S1185[int(15)] = _S1170;
    _S1185[int(14)] = _S1171;
    _S1185[int(13)] = _S1172;
    _S1185[int(12)] = _S1173;
    _S1185[int(11)] = _S1174;
    _S1185[int(10)] = _S1175;
    _S1185[int(19)] = _S1154.color_params_2.r_0.y;
    _S1185[int(8)] = _S1177;
    _S1185[int(7)] = _S1178;
    _S1185[int(6)] = _S1179;
    _S1185[int(5)] = _S1180;
    _S1185[int(4)] = _S1181;
    _S1185[int(3)] = _S1182;
    _S1185[int(2)] = _S1183;
    _S1185[int(1)] = _S1184;
    _S1185[int(0)] = _S663.exposure_2;
    _S1185[int(28)] = _S1165;
    _S1185[int(37)] = _S1156;
    _S1185[int(36)] = _S1157;
    _S1185[int(35)] = _S1158;
    _S1185[int(34)] = _S1159;
    _S1185[int(33)] = _S1160;
    _S1185[int(32)] = _S1161;
    _S1185[int(31)] = _S1162;
    _S1185[int(30)] = _S1163;
    _S1185[int(29)] = _S1164;
    _S1185[int(38)] = _S1155;
    _S1185[int(27)] = _S1166;
    _S1185[int(26)] = _S1167;
    _S1185[int(25)] = _S1168;
    _S1185[int(24)] = _S1169;
    _S1185[int(23)] = _S1154.color_params_2.n_0.y;
    _S1185[int(22)] = _S1154.color_params_2.n_0.x;
    _S1185[int(21)] = _S1154.color_params_2.g_0.y;
    _S1185[int(20)] = _S1154.color_params_2.g_0.x;
    dpparams_1->primal_0 = dpparams_1->primal_0;
    dpparams_1->differential_0 = _S1185;
    dprgb_in_1->primal_0 = (*dprgb_in_1).primal_0;
    dprgb_in_1->differential_0 = _S1151;
    return;
}

inline __device__ void s_bwd_apply_ppisp_rqs_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S1186, float2  _S1187, float2  _S1188, float2  _S1189, DiffPair_arrayx3Cfloatx2C39x3E_0 * _S1190, float3  _S1191)
{
    s_bwd_prop_apply_ppisp_rqs_0(_S1186, _S1187, _S1188, _S1189, _S1190, _S1191);
    return;
}

inline __device__ void apply_ppisp_rqs_vjp(float3  rgb_in_5, float2  pix_coord_7, float2  image_center_7, float2  img_size_7, FixedArray<float, 39>  params_5, float3  grad_out_1, float3  * grad_rgb_in_1, FixedArray<float, 39>  * grad_params_1)
{
    float3  _S1192 = make_float3 (0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_rgb_in_1;
    (&dp_rgb_in_1)->primal_0 = rgb_in_5;
    (&dp_rgb_in_1)->differential_0 = _S1192;
    FixedArray<float, 39>  _S1193 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C39x3E_0 dp_params_1;
    (&dp_params_1)->primal_0 = params_5;
    (&dp_params_1)->differential_0 = _S1193;
    s_bwd_apply_ppisp_rqs_0(&dp_rgb_in_1, pix_coord_7, image_center_7, img_size_7, &dp_params_1, grad_out_1);
    *grad_rgb_in_1 = dp_rgb_in_1.differential_0;
    *grad_params_1 = (&dp_params_1)->differential_0;
    return;
}

struct DiffPair_arrayx3Cfloatx2C24x3E_0
{
    FixedArray<float, 24>  primal_0;
    FixedArray<float, 24>  differential_0;
};

inline __device__ void s_bwd_prop_apply_ppisp_no_crf_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dprgb_in_2, float2  pix_coord_8, float2  image_center_8, float2  img_size_8, DiffPair_arrayx3Cfloatx2C24x3E_0 * dpparams_2, bool clamp_output_2, float3  _s_dOut_2)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1194 = *dprgb_in_2;
    float3  _S1195 = make_float3 (0.0f);
    Matrix<float, 3, 3>  _S1196 = makeMatrix<float, 3, 3> (0.0f);
    VignettingChannelParams_0 _S1197 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S1198 = {
        _S1197, _S1197, _S1197
    };
    float2  _S1199 = make_float2 (0.0f);
    ColorPPISPParams_0 _S1200 = { _S1199, _S1199, _S1199, _S1199 };
    PPISPParamsNoCRF_0 _S1201;
    (&_S1201)->exposure_1 = dpparams_2->primal_0[int(0)];
    (&_S1201)->vignette_params_0 = _S1198;
    (&_S1201)->color_params_1 = _S1200;
    (&(&_S1201)->vignette_params_0[int(0)])->cx_0 = dpparams_2->primal_0[int(1)];
    (&(&_S1201)->vignette_params_0[int(0)])->cy_0 = dpparams_2->primal_0[int(2)];
    float _S1202 = dpparams_2->primal_0[int(3)];
    (&(&_S1201)->vignette_params_0[int(0)])->alpha0_0 = dpparams_2->primal_0[int(3)];
    float _S1203 = dpparams_2->primal_0[int(4)];
    (&(&_S1201)->vignette_params_0[int(0)])->alpha1_0 = dpparams_2->primal_0[int(4)];
    float _S1204 = dpparams_2->primal_0[int(5)];
    (&(&_S1201)->vignette_params_0[int(0)])->alpha2_0 = dpparams_2->primal_0[int(5)];
    (&(&_S1201)->vignette_params_0[int(1)])->cx_0 = dpparams_2->primal_0[int(6)];
    (&(&_S1201)->vignette_params_0[int(1)])->cy_0 = dpparams_2->primal_0[int(7)];
    float _S1205 = dpparams_2->primal_0[int(8)];
    (&(&_S1201)->vignette_params_0[int(1)])->alpha0_0 = dpparams_2->primal_0[int(8)];
    float _S1206 = dpparams_2->primal_0[int(9)];
    (&(&_S1201)->vignette_params_0[int(1)])->alpha1_0 = dpparams_2->primal_0[int(9)];
    float _S1207 = dpparams_2->primal_0[int(10)];
    (&(&_S1201)->vignette_params_0[int(1)])->alpha2_0 = dpparams_2->primal_0[int(10)];
    (&(&_S1201)->vignette_params_0[int(2)])->cx_0 = dpparams_2->primal_0[int(11)];
    (&(&_S1201)->vignette_params_0[int(2)])->cy_0 = dpparams_2->primal_0[int(12)];
    float _S1208 = dpparams_2->primal_0[int(13)];
    (&(&_S1201)->vignette_params_0[int(2)])->alpha0_0 = dpparams_2->primal_0[int(13)];
    float _S1209 = dpparams_2->primal_0[int(14)];
    (&(&_S1201)->vignette_params_0[int(2)])->alpha1_0 = dpparams_2->primal_0[int(14)];
    float _S1210 = dpparams_2->primal_0[int(15)];
    (&(&_S1201)->vignette_params_0[int(2)])->alpha2_0 = dpparams_2->primal_0[int(15)];
    *&((&(&(&_S1201)->color_params_1)->b_0)->x) = dpparams_2->primal_0[int(16)];
    *&((&(&(&_S1201)->color_params_1)->b_0)->y) = dpparams_2->primal_0[int(17)];
    *&((&(&(&_S1201)->color_params_1)->r_0)->x) = dpparams_2->primal_0[int(18)];
    *&((&(&(&_S1201)->color_params_1)->r_0)->y) = dpparams_2->primal_0[int(19)];
    *&((&(&(&_S1201)->color_params_1)->g_0)->x) = dpparams_2->primal_0[int(20)];
    *&((&(&(&_S1201)->color_params_1)->g_0)->y) = dpparams_2->primal_0[int(21)];
    *&((&(&(&_S1201)->color_params_1)->n_0)->x) = dpparams_2->primal_0[int(22)];
    *&((&(&(&_S1201)->color_params_1)->n_0)->y) = dpparams_2->primal_0[int(23)];
    PPISPParamsNoCRF_0 _S1211 = _S1201;
    float _S1212 = s_primal_ctx_exp2_0(_S1201.exposure_1);
    float3  _S1213 = make_float3 (_S1212);
    float3  rgb_out_7 = (*dprgb_in_2).primal_0 * make_float3 (_S1212);
    float _S1214 = (F32_max((img_size_8.x), (img_size_8.y)));
    float _S1215 = (pix_coord_8.x - image_center_8.x) / _S1214;
    float _S1216 = (pix_coord_8.y - image_center_8.y) / _S1214;
    float dx_15 = _S1215 - dpparams_2->primal_0[int(1)];
    float dy_15 = _S1216 - dpparams_2->primal_0[int(2)];
    float r2_21 = dx_15 * dx_15 + dy_15 * dy_15;
    float r4_15 = r2_21 * r2_21;
    float r6_6 = r4_15 * r2_21;
    float falloff_6 = dpparams_2->primal_0[int(5)] * r6_6 + dpparams_2->primal_0[int(4)] * r4_15 + dpparams_2->primal_0[int(3)] * r2_21 + 1.0f;
    float _S1217 = s_primal_ctx_clamp_0(falloff_6, 0.0f, 1.0f);
    float _S1218 = rgb_out_7.x * _S1217;
    float3  _S1219 = rgb_out_7;
    *&((&_S1219)->x) = _S1218;
    float dx_16 = _S1215 - dpparams_2->primal_0[int(6)];
    float dy_16 = _S1216 - dpparams_2->primal_0[int(7)];
    float r2_22 = dx_16 * dx_16 + dy_16 * dy_16;
    float r4_16 = r2_22 * r2_22;
    float r6_7 = r4_16 * r2_22;
    float falloff_7 = dpparams_2->primal_0[int(10)] * r6_7 + dpparams_2->primal_0[int(9)] * r4_16 + dpparams_2->primal_0[int(8)] * r2_22 + 1.0f;
    float _S1220 = s_primal_ctx_clamp_0(falloff_7, 0.0f, 1.0f);
    *&((&_S1219)->y) = rgb_out_7.y * _S1220;
    float dx_17 = _S1215 - dpparams_2->primal_0[int(11)];
    float dy_17 = _S1216 - dpparams_2->primal_0[int(12)];
    float r2_23 = dx_17 * dx_17 + dy_17 * dy_17;
    float r4_17 = r2_23 * r2_23;
    float r6_8 = r4_17 * r2_23;
    float falloff_8 = dpparams_2->primal_0[int(15)] * r6_8 + dpparams_2->primal_0[int(14)] * r4_17 + dpparams_2->primal_0[int(13)] * r2_23 + 1.0f;
    float _S1221 = s_primal_ctx_clamp_0(falloff_8, 0.0f, 1.0f);
    *&((&_S1219)->z) = rgb_out_7.z * _S1221;
    PPISPParamsNoCRF_0 _S1222 = _S1201;
    float2  _S1223 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S1201.color_params_1.b_0);
    float2  _S1224 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S1201.color_params_1.r_0);
    float2  _S1225 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S1201.color_params_1.g_0);
    float2  _S1226 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S1201.color_params_1.n_0);
    float _S1227 = 0.3333333432674408f + _S1226.x;
    float _S1228 = 0.3333333432674408f + _S1226.y;
    Matrix<float, 3, 3>  T_6 = makeMatrix<float, 3, 3> (_S1223.x, 1.0f + _S1224.x, _S1225.x, _S1223.y, _S1224.y, 1.0f + _S1225.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  skew_2 = makeMatrix<float, 3, 3> (0.0f, -1.0f, _S1228, 1.0f, 0.0f, - _S1227, - _S1228, _S1227, 0.0f);
    Matrix<float, 3, 3>  _S1229 = s_primal_ctx_mul_1(skew_2, T_6);
    float3  r0_6 = make_float3 (_S1229.rows[int(0)].x, _S1229.rows[int(0)].y, _S1229.rows[int(0)].z);
    float3  r1_6 = make_float3 (_S1229.rows[int(1)].x, _S1229.rows[int(1)].y, _S1229.rows[int(1)].z);
    float3  r2_24 = make_float3 (_S1229.rows[int(2)].x, _S1229.rows[int(2)].y, _S1229.rows[int(2)].z);
    float3  _S1230 = s_primal_ctx_cross_0(r0_6, r1_6);
    bool _S1231 = (s_primal_ctx_dot_0(_S1230, _S1230)) < 9.99999968265522539e-21f;
    float3  lambda_v_14;
    float3  _S1232;
    bool _S1233;
    if(_S1231)
    {
        float3  _S1234 = s_primal_ctx_cross_0(r0_6, r2_24);
        bool _S1235 = (s_primal_ctx_dot_0(_S1234, _S1234)) < 9.99999968265522539e-21f;
        if(_S1235)
        {
            lambda_v_14 = s_primal_ctx_cross_0(r1_6, r2_24);
        }
        else
        {
            lambda_v_14 = _S1234;
        }
        _S1233 = _S1235;
        _S1232 = _S1234;
    }
    else
    {
        lambda_v_14 = _S1230;
        _S1233 = false;
        _S1232 = _S1195;
    }
    Matrix<float, 3, 3>  S_inv_2 = makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f);
    Matrix<float, 3, 3>  D_2 = makeMatrix<float, 3, 3> (lambda_v_14.x, 0.0f, 0.0f, 0.0f, lambda_v_14.y, 0.0f, 0.0f, 0.0f, lambda_v_14.z);
    Matrix<float, 3, 3>  _S1236 = s_primal_ctx_mul_1(T_6, D_2);
    Matrix<float, 3, 3>  _S1237 = s_primal_ctx_mul_1(_S1236, S_inv_2);
    bool _S1238 = (s_primal_ctx_abs_0(_S1237.rows[int(2)].z)) > 9.99999968265522539e-21f;
    Matrix<float, 3, 3>  H_10;
    Matrix<float, 3, 3>  _S1239;
    float _S1240;
    if(_S1238)
    {
        float inv_s_2 = 1.0f / _S1237.rows[int(2)].z;
        Matrix<float, 3, 3>  _S1241 = makeMatrix<float, 3, 3> (inv_s_2);
        float _S1242 = _S1237.rows[int(2)].z * _S1237.rows[int(2)].z;
        H_10 = _S1237 * makeMatrix<float, 3, 3> (inv_s_2);
        _S1239 = _S1241;
        _S1240 = _S1242;
    }
    else
    {
        H_10 = _S1237;
        _S1239 = _S1196;
        _S1240 = 0.0f;
    }
    float _S1243 = _S1219.x;
    float _S1244 = _S1219.y;
    float intensity_6 = _S1243 + _S1244 + _S1219.z;
    float3  rgi_in_2 = make_float3 (_S1243, _S1244, intensity_6);
    float3  _S1245 = s_primal_ctx_mul_2(H_10, rgi_in_2);
    float _S1246 = _S1245.z;
    float _S1247 = 0.00009999999747379f * s_primal_ctx_abs_0(intensity_6) + 9.99999993922529029e-09f;
    float _S1248 = (F32_max((_S1246), (_S1247)));
    float norm_factor_6 = intensity_6 / _S1248;
    float _S1249 = _S1248 * _S1248;
    float _S1250 = _S1245.x;
    float out_r_6 = _S1250 * norm_factor_6;
    float _S1251 = _S1245.y;
    float out_g_6 = _S1251 * norm_factor_6;
    float3  _S1252 = make_float3 (out_r_6, out_g_6, intensity_6 - out_r_6 - out_g_6);
    if(clamp_output_2)
    {
        float3  _S1253 = make_float3 (1.0f);
        _S1219 = make_float3 (0.0f);
        lambda_v_14 = _S1253;
    }
    else
    {
        _S1219 = _S1195;
        lambda_v_14 = _S1195;
    }
    if(clamp_output_2)
    {
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1254;
        (&_S1254)->primal_0 = _S1252;
        (&_S1254)->differential_0 = _S1195;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1255;
        (&_S1255)->primal_0 = _S1219;
        (&_S1255)->differential_0 = _S1195;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1256;
        (&_S1256)->primal_0 = lambda_v_14;
        (&_S1256)->differential_0 = _S1195;
        s_bwd_prop_clamp_0(&_S1254, &_S1255, &_S1256, _s_dOut_2);
        _S1219 = _S1254.differential_0;
    }
    else
    {
        _S1219 = _s_dOut_2;
    }
    float _S1257 = - _S1219.z;
    float _S1258 = _S1219.y + _S1257;
    float _S1259 = norm_factor_6 * _S1258;
    float _S1260 = _S1219.x + _S1257;
    float _S1261 = norm_factor_6 * _S1260;
    float _S1262 = (_S1251 * _S1258 + _S1250 * _S1260) / _S1249;
    float _S1263 = intensity_6 * - _S1262;
    float _S1264 = _S1248 * _S1262;
    DiffPair_float_0 _S1265;
    (&_S1265)->primal_0 = _S1246;
    (&_S1265)->differential_0 = 0.0f;
    DiffPair_float_0 _S1266;
    (&_S1266)->primal_0 = _S1247;
    (&_S1266)->differential_0 = 0.0f;
    _d_max_0(&_S1265, &_S1266, _S1263);
    float _S1267 = 0.00009999999747379f * _S1266.differential_0;
    DiffPair_float_0 _S1268;
    (&_S1268)->primal_0 = intensity_6;
    (&_S1268)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1268, _S1267);
    float3  _S1269 = make_float3 (_S1261, _S1259, _S1265.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1270;
    (&_S1270)->primal_0 = H_10;
    (&_S1270)->differential_0 = _S1196;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1271;
    (&_S1271)->primal_0 = rgi_in_2;
    (&_S1271)->differential_0 = _S1195;
    s_bwd_prop_mul_0(&_S1270, &_S1271, _S1269);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1272 = _S1270;
    float _S1273 = _S1219.z + _S1264 + _S1268.differential_0 + _S1271.differential_0.z;
    float _S1274 = _S1271.differential_0.y + _S1273;
    float _S1275 = _S1271.differential_0.x + _S1273;
    float3  _S1276 = make_float3 (_S1275, _S1274, _S1273);
    if(_S1238)
    {
        Matrix<float, 3, 3>  _S1277 = _S1237 * _S1272.differential_0;
        Matrix<float, 3, 3>  _S1278 = _S1239 * _S1272.differential_0;
        _S1240 = - ((_S1277.rows[int(0)].x + _S1277.rows[int(0)].y + _S1277.rows[int(0)].z + _S1277.rows[int(1)].x + _S1277.rows[int(1)].y + _S1277.rows[int(1)].z + _S1277.rows[int(2)].x + _S1277.rows[int(2)].y + _S1277.rows[int(2)].z) / _S1240);
        H_10 = _S1278;
    }
    else
    {
        _S1240 = 0.0f;
        H_10 = _S1272.differential_0;
    }
    DiffPair_float_0 _S1279;
    (&_S1279)->primal_0 = _S1237.rows[int(2)].z;
    (&_S1279)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1279, 0.0f);
    float _S1280 = _S1279.differential_0 + _S1240;
    float3  _S1281 = _S1195;
    *&((&_S1281)->z) = _S1280;
    Matrix<float, 3, 3>  _S1282 = _S1196;
    _S1282[int(2)] = _S1281;
    Matrix<float, 3, 3>  _S1283 = H_10 + _S1282;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1284;
    (&_S1284)->primal_0 = _S1236;
    (&_S1284)->differential_0 = _S1196;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1285;
    (&_S1285)->primal_0 = S_inv_2;
    (&_S1285)->differential_0 = _S1196;
    s_bwd_prop_mul_1(&_S1284, &_S1285, _S1283);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1286;
    (&_S1286)->primal_0 = T_6;
    (&_S1286)->differential_0 = _S1196;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1287;
    (&_S1287)->primal_0 = D_2;
    (&_S1287)->differential_0 = _S1196;
    s_bwd_prop_mul_1(&_S1286, &_S1287, _S1284.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1288 = _S1286;
    float3  _S1289 = make_float3 (_S1287.differential_0.rows[int(0)].x, _S1287.differential_0.rows[int(1)].y, _S1287.differential_0.rows[int(2)].z);
    float3  _S1290;
    if(_S1231)
    {
        if(_S1233)
        {
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1291;
            (&_S1291)->primal_0 = r1_6;
            (&_S1291)->differential_0 = _S1195;
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1292;
            (&_S1292)->primal_0 = r2_24;
            (&_S1292)->differential_0 = _S1195;
            s_bwd_prop_cross_0(&_S1291, &_S1292, _S1289);
            _S1219 = _S1195;
            lambda_v_14 = _S1292.differential_0;
            _S1290 = _S1291.differential_0;
        }
        else
        {
            _S1219 = _S1289;
            lambda_v_14 = _S1195;
            _S1290 = _S1195;
        }
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1293;
        (&_S1293)->primal_0 = _S1232;
        (&_S1293)->differential_0 = _S1195;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1294;
        (&_S1294)->primal_0 = _S1232;
        (&_S1294)->differential_0 = _S1195;
        s_bwd_prop_dot_0(&_S1293, &_S1294, 0.0f);
        float3  _S1295 = _S1294.differential_0 + _S1293.differential_0 + _S1219;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1296;
        (&_S1296)->primal_0 = r0_6;
        (&_S1296)->differential_0 = _S1195;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1297;
        (&_S1297)->primal_0 = r2_24;
        (&_S1297)->differential_0 = _S1195;
        s_bwd_prop_cross_0(&_S1296, &_S1297, _S1295);
        float3  _S1298 = _S1297.differential_0 + lambda_v_14;
        _S1219 = _S1195;
        lambda_v_14 = _S1298;
        _S1232 = _S1290;
        _S1290 = _S1296.differential_0;
    }
    else
    {
        _S1219 = _S1289;
        lambda_v_14 = _S1195;
        _S1232 = _S1195;
        _S1290 = _S1195;
    }
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1299;
    (&_S1299)->primal_0 = _S1230;
    (&_S1299)->differential_0 = _S1195;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1300;
    (&_S1300)->primal_0 = _S1230;
    (&_S1300)->differential_0 = _S1195;
    s_bwd_prop_dot_0(&_S1299, &_S1300, 0.0f);
    float3  _S1301 = _S1300.differential_0 + _S1299.differential_0 + _S1219;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1302;
    (&_S1302)->primal_0 = r0_6;
    (&_S1302)->differential_0 = _S1195;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1303;
    (&_S1303)->primal_0 = r1_6;
    (&_S1303)->differential_0 = _S1195;
    s_bwd_prop_cross_0(&_S1302, &_S1303, _S1301);
    float3  _S1304 = _S1195;
    *&((&_S1304)->z) = lambda_v_14.z;
    *&((&_S1304)->y) = lambda_v_14.y;
    *&((&_S1304)->x) = lambda_v_14.x;
    float3  _S1305 = _S1303.differential_0 + _S1232;
    float3  _S1306 = _S1195;
    *&((&_S1306)->z) = _S1305.z;
    *&((&_S1306)->y) = _S1305.y;
    *&((&_S1306)->x) = _S1305.x;
    float3  _S1307 = _S1302.differential_0 + _S1290;
    float3  _S1308 = _S1195;
    *&((&_S1308)->z) = _S1307.z;
    *&((&_S1308)->y) = _S1307.y;
    *&((&_S1308)->x) = _S1307.x;
    Matrix<float, 3, 3>  _S1309 = _S1196;
    _S1309[int(2)] = _S1304;
    _S1309[int(1)] = _S1306;
    _S1309[int(0)] = _S1308;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1310;
    (&_S1310)->primal_0 = skew_2;
    (&_S1310)->differential_0 = _S1196;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1311;
    (&_S1311)->primal_0 = T_6;
    (&_S1311)->differential_0 = _S1196;
    s_bwd_prop_mul_1(&_S1310, &_S1311, _S1309);
    Matrix<float, 3, 3>  _S1312 = _S1311.differential_0 + _S1288.differential_0;
    float2  _S1313 = make_float2 (_S1310.differential_0.rows[int(2)].y + - _S1310.differential_0.rows[int(1)].z, _S1310.differential_0.rows[int(0)].z + - _S1310.differential_0.rows[int(2)].x);
    Matrix<float, 2, 2>  _S1314 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1315;
    (&_S1315)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S1315)->differential_0 = _S1314;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1316;
    (&_S1316)->primal_0 = _S1222.color_params_1.n_0;
    (&_S1316)->differential_0 = _S1199;
    s_bwd_prop_mul_2(&_S1315, &_S1316, _S1313);
    float2  _S1317 = make_float2 (_S1312.rows[int(0)].z, _S1312.rows[int(1)].z);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1318;
    (&_S1318)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S1318)->differential_0 = _S1314;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1319;
    (&_S1319)->primal_0 = _S1222.color_params_1.g_0;
    (&_S1319)->differential_0 = _S1199;
    s_bwd_prop_mul_2(&_S1318, &_S1319, _S1317);
    float2  _S1320 = make_float2 (_S1312.rows[int(0)].y, _S1312.rows[int(1)].y);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1321;
    (&_S1321)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S1321)->differential_0 = _S1314;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1322;
    (&_S1322)->primal_0 = _S1222.color_params_1.r_0;
    (&_S1322)->differential_0 = _S1199;
    s_bwd_prop_mul_2(&_S1321, &_S1322, _S1320);
    float2  _S1323 = make_float2 (_S1312.rows[int(0)].x, _S1312.rows[int(1)].x);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1324;
    (&_S1324)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S1324)->differential_0 = _S1314;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1325;
    (&_S1325)->primal_0 = _S1222.color_params_1.b_0;
    (&_S1325)->differential_0 = _S1199;
    s_bwd_prop_mul_2(&_S1324, &_S1325, _S1323);
    ColorPPISPParams_0 _S1326 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S1326)->n_0 = _S1316.differential_0;
    (&_S1326)->g_0 = _S1319.differential_0;
    (&_S1326)->r_0 = _S1322.differential_0;
    (&_S1326)->b_0 = _S1325.differential_0;
    _S1219 = _S1276;
    *&((&_S1219)->z) = 0.0f;
    float _S1327 = rgb_out_7.z * _S1273;
    float _S1328 = _S1221 * _S1273;
    DiffPair_float_0 _S1329;
    (&_S1329)->primal_0 = falloff_8;
    (&_S1329)->differential_0 = 0.0f;
    DiffPair_float_0 _S1330;
    (&_S1330)->primal_0 = 0.0f;
    (&_S1330)->differential_0 = 0.0f;
    DiffPair_float_0 _S1331;
    (&_S1331)->primal_0 = 1.0f;
    (&_S1331)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1329, &_S1330, &_S1331, _S1327);
    float _S1332 = r2_23 * _S1329.differential_0;
    float _S1333 = r4_17 * _S1329.differential_0;
    float s_diff_r6_T_6 = _S1210 * _S1329.differential_0;
    float _S1334 = r6_8 * _S1329.differential_0;
    float _S1335 = r2_23 * (_S1209 * _S1329.differential_0 + r2_23 * s_diff_r6_T_6);
    float _S1336 = _S1208 * _S1329.differential_0 + r4_17 * s_diff_r6_T_6 + _S1335 + _S1335;
    float _S1337 = dy_17 * _S1336;
    float _S1338 = dx_17 * _S1336;
    float _S1339 = - (_S1337 + _S1337);
    float _S1340 = - (_S1338 + _S1338);
    *&((&_S1219)->y) = 0.0f;
    float _S1341 = rgb_out_7.y * _S1274;
    float _S1342 = _S1220 * _S1274;
    DiffPair_float_0 _S1343;
    (&_S1343)->primal_0 = falloff_7;
    (&_S1343)->differential_0 = 0.0f;
    DiffPair_float_0 _S1344;
    (&_S1344)->primal_0 = 0.0f;
    (&_S1344)->differential_0 = 0.0f;
    DiffPair_float_0 _S1345;
    (&_S1345)->primal_0 = 1.0f;
    (&_S1345)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1343, &_S1344, &_S1345, _S1341);
    float _S1346 = r2_22 * _S1343.differential_0;
    float _S1347 = r4_16 * _S1343.differential_0;
    float s_diff_r6_T_7 = _S1207 * _S1343.differential_0;
    float _S1348 = r6_7 * _S1343.differential_0;
    float _S1349 = r2_22 * (_S1206 * _S1343.differential_0 + r2_22 * s_diff_r6_T_7);
    float _S1350 = _S1205 * _S1343.differential_0 + r4_16 * s_diff_r6_T_7 + _S1349 + _S1349;
    float _S1351 = dy_16 * _S1350;
    float _S1352 = dx_16 * _S1350;
    float _S1353 = - (_S1351 + _S1351);
    float _S1354 = - (_S1352 + _S1352);
    *&((&_S1219)->x) = 0.0f;
    float _S1355 = rgb_out_7.x * _S1275;
    float _S1356 = _S1217 * _S1275;
    DiffPair_float_0 _S1357;
    (&_S1357)->primal_0 = falloff_6;
    (&_S1357)->differential_0 = 0.0f;
    DiffPair_float_0 _S1358;
    (&_S1358)->primal_0 = 0.0f;
    (&_S1358)->differential_0 = 0.0f;
    DiffPair_float_0 _S1359;
    (&_S1359)->primal_0 = 1.0f;
    (&_S1359)->differential_0 = 0.0f;
    s_bwd_prop_clamp_1(&_S1357, &_S1358, &_S1359, _S1355);
    float _S1360 = r2_21 * _S1357.differential_0;
    float _S1361 = r4_15 * _S1357.differential_0;
    float s_diff_r6_T_8 = _S1204 * _S1357.differential_0;
    float _S1362 = r6_6 * _S1357.differential_0;
    float _S1363 = r2_21 * (_S1203 * _S1357.differential_0 + r2_21 * s_diff_r6_T_8);
    float _S1364 = _S1202 * _S1357.differential_0 + r4_15 * s_diff_r6_T_8 + _S1363 + _S1363;
    float _S1365 = dy_15 * _S1364;
    float _S1366 = dx_15 * _S1364;
    float _S1367 = - (_S1365 + _S1365);
    float _S1368 = - (_S1366 + _S1366);
    float3  _S1369 = _S1195;
    *&((&_S1369)->z) = _S1328;
    *&((&_S1369)->y) = _S1342;
    *&((&_S1369)->x) = _S1356;
    float3  _S1370 = _S1219 + _S1369;
    float3  _S1371 = _S1194.primal_0 * _S1370;
    float3  _S1372 = _S1213 * _S1370;
    float _S1373 = _S1371.x + _S1371.y + _S1371.z;
    DiffPair_float_0 _S1374;
    (&_S1374)->primal_0 = _S1211.exposure_1;
    (&_S1374)->differential_0 = 0.0f;
    s_bwd_prop_exp2_0(&_S1374, _S1373);
    PPISPParamsNoCRF_0 _S1375 = PPISPParamsNoCRF_x24_syn_dzero_0();
    (&_S1375)->color_params_1 = _S1326;
    (&_S1375)->exposure_1 = _S1374.differential_0;
    _S1201 = _S1375;
    *&((&(&(&_S1201)->color_params_1)->n_0)->y) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->n_0)->x) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->g_0)->y) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->g_0)->x) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->r_0)->y) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->r_0)->x) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->b_0)->y) = 0.0f;
    *&((&(&(&_S1201)->color_params_1)->b_0)->x) = 0.0f;
    (&(&_S1201)->vignette_params_0[int(2)])->alpha2_0 = 0.0f;
    float _S1376 = _S1334 + _S1375.vignette_params_0[int(2)].alpha2_0;
    (&(&_S1201)->vignette_params_0[int(2)])->alpha1_0 = 0.0f;
    float _S1377 = _S1333 + _S1375.vignette_params_0[int(2)].alpha1_0;
    (&(&_S1201)->vignette_params_0[int(2)])->alpha0_0 = 0.0f;
    float _S1378 = _S1332 + _S1375.vignette_params_0[int(2)].alpha0_0;
    (&(&_S1201)->vignette_params_0[int(2)])->cy_0 = 0.0f;
    float _S1379 = _S1339 + _S1375.vignette_params_0[int(2)].cy_0;
    (&(&_S1201)->vignette_params_0[int(2)])->cx_0 = 0.0f;
    float _S1380 = _S1340 + _S1375.vignette_params_0[int(2)].cx_0;
    (&(&_S1201)->vignette_params_0[int(1)])->alpha2_0 = 0.0f;
    float _S1381 = _S1348 + _S1375.vignette_params_0[int(1)].alpha2_0;
    (&(&_S1201)->vignette_params_0[int(1)])->alpha1_0 = 0.0f;
    float _S1382 = _S1347 + _S1375.vignette_params_0[int(1)].alpha1_0;
    (&(&_S1201)->vignette_params_0[int(1)])->alpha0_0 = 0.0f;
    float _S1383 = _S1346 + _S1375.vignette_params_0[int(1)].alpha0_0;
    (&(&_S1201)->vignette_params_0[int(1)])->cy_0 = 0.0f;
    float _S1384 = _S1353 + _S1375.vignette_params_0[int(1)].cy_0;
    (&(&_S1201)->vignette_params_0[int(1)])->cx_0 = 0.0f;
    float _S1385 = _S1354 + _S1375.vignette_params_0[int(1)].cx_0;
    (&(&_S1201)->vignette_params_0[int(0)])->alpha2_0 = 0.0f;
    float _S1386 = _S1362 + _S1375.vignette_params_0[int(0)].alpha2_0;
    (&(&_S1201)->vignette_params_0[int(0)])->alpha1_0 = 0.0f;
    float _S1387 = _S1361 + _S1375.vignette_params_0[int(0)].alpha1_0;
    (&(&_S1201)->vignette_params_0[int(0)])->alpha0_0 = 0.0f;
    float _S1388 = _S1360 + _S1375.vignette_params_0[int(0)].alpha0_0;
    (&(&_S1201)->vignette_params_0[int(0)])->cy_0 = 0.0f;
    float _S1389 = _S1367 + _S1375.vignette_params_0[int(0)].cy_0;
    (&(&_S1201)->vignette_params_0[int(0)])->cx_0 = 0.0f;
    float _S1390 = _S1368 + _S1375.vignette_params_0[int(0)].cx_0;
    FixedArray<float, 24>  _S1391;
    _S1391[int(0)] = 0.0f;
    _S1391[int(1)] = 0.0f;
    _S1391[int(2)] = 0.0f;
    _S1391[int(3)] = 0.0f;
    _S1391[int(4)] = 0.0f;
    _S1391[int(5)] = 0.0f;
    _S1391[int(6)] = 0.0f;
    _S1391[int(7)] = 0.0f;
    _S1391[int(8)] = 0.0f;
    _S1391[int(9)] = 0.0f;
    _S1391[int(10)] = 0.0f;
    _S1391[int(11)] = 0.0f;
    _S1391[int(12)] = 0.0f;
    _S1391[int(13)] = 0.0f;
    _S1391[int(14)] = 0.0f;
    _S1391[int(15)] = 0.0f;
    _S1391[int(16)] = 0.0f;
    _S1391[int(17)] = 0.0f;
    _S1391[int(18)] = 0.0f;
    _S1391[int(19)] = 0.0f;
    _S1391[int(20)] = 0.0f;
    _S1391[int(21)] = 0.0f;
    _S1391[int(22)] = 0.0f;
    _S1391[int(23)] = 0.0f;
    _S1391[int(11)] = _S1380;
    _S1391[int(0)] = _S1201.exposure_1;
    _S1391[int(1)] = _S1390;
    _S1391[int(2)] = _S1389;
    _S1391[int(3)] = _S1388;
    _S1391[int(4)] = _S1387;
    _S1391[int(5)] = _S1386;
    _S1391[int(6)] = _S1385;
    _S1391[int(7)] = _S1384;
    _S1391[int(8)] = _S1383;
    _S1391[int(9)] = _S1382;
    _S1391[int(10)] = _S1381;
    _S1391[int(23)] = _S1375.color_params_1.n_0.y;
    _S1391[int(12)] = _S1379;
    _S1391[int(13)] = _S1378;
    _S1391[int(14)] = _S1377;
    _S1391[int(15)] = _S1376;
    _S1391[int(16)] = _S1375.color_params_1.b_0.x;
    _S1391[int(17)] = _S1375.color_params_1.b_0.y;
    _S1391[int(18)] = _S1375.color_params_1.r_0.x;
    _S1391[int(19)] = _S1375.color_params_1.r_0.y;
    _S1391[int(20)] = _S1375.color_params_1.g_0.x;
    _S1391[int(21)] = _S1375.color_params_1.g_0.y;
    _S1391[int(22)] = _S1375.color_params_1.n_0.x;
    dpparams_2->primal_0 = dpparams_2->primal_0;
    dpparams_2->differential_0 = _S1391;
    dprgb_in_2->primal_0 = (*dprgb_in_2).primal_0;
    dprgb_in_2->differential_0 = _S1372;
    return;
}

inline __device__ void s_bwd_apply_ppisp_no_crf_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S1392, float2  _S1393, float2  _S1394, float2  _S1395, DiffPair_arrayx3Cfloatx2C24x3E_0 * _S1396, bool _S1397, float3  _S1398)
{
    s_bwd_prop_apply_ppisp_no_crf_0(_S1392, _S1393, _S1394, _S1395, _S1396, _S1397, _S1398);
    return;
}

inline __device__ void apply_ppisp_no_crf_vjp(float3  rgb_in_6, float2  pix_coord_9, float2  image_center_9, float2  img_size_9, FixedArray<float, 24>  params_6, bool clamp_output_3, float3  grad_out_2, float3  * grad_rgb_in_2, FixedArray<float, 24>  * grad_params_2)
{
    float3  _S1399 = make_float3 (0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_rgb_in_2;
    (&dp_rgb_in_2)->primal_0 = rgb_in_6;
    (&dp_rgb_in_2)->differential_0 = _S1399;
    FixedArray<float, 24>  _S1400 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C24x3E_0 dp_params_2;
    (&dp_params_2)->primal_0 = params_6;
    (&dp_params_2)->differential_0 = _S1400;
    s_bwd_apply_ppisp_no_crf_0(&dp_rgb_in_2, pix_coord_9, image_center_9, img_size_9, &dp_params_2, clamp_output_3, grad_out_2);
    *grad_rgb_in_2 = dp_rgb_in_2.differential_0;
    *grad_params_2 = (&dp_params_2)->differential_0;
    return;
}

struct DiffPair_arrayx3Cfloatx2C9x3E_0
{
    FixedArray<float, 9>  primal_0;
    FixedArray<float, 9>  differential_0;
};

inline __device__ void s_bwd_prop_apply_ppisp_no_crf_no_vig_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * dprgb_in_3, float2  pix_coord_10, float2  image_center_10, float2  img_size_10, DiffPair_arrayx3Cfloatx2C9x3E_0 * dpparams_3, bool clamp_output_4, float3  _s_dOut_3)
{
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1401 = *dprgb_in_3;
    float3  _S1402 = make_float3 (0.0f);
    Matrix<float, 3, 3>  _S1403 = makeMatrix<float, 3, 3> (0.0f);
    float2  _S1404 = make_float2 (0.0f);
    ColorPPISPParams_0 _S1405 = { _S1404, _S1404, _S1404, _S1404 };
    PPISPParamsNoCRFNoVig_0 _S1406;
    (&_S1406)->exposure_0 = dpparams_3->primal_0[int(0)];
    (&_S1406)->color_params_0 = _S1405;
    *&((&(&(&_S1406)->color_params_0)->b_0)->x) = dpparams_3->primal_0[int(1)];
    *&((&(&(&_S1406)->color_params_0)->b_0)->y) = dpparams_3->primal_0[int(2)];
    *&((&(&(&_S1406)->color_params_0)->r_0)->x) = dpparams_3->primal_0[int(3)];
    *&((&(&(&_S1406)->color_params_0)->r_0)->y) = dpparams_3->primal_0[int(4)];
    *&((&(&(&_S1406)->color_params_0)->g_0)->x) = dpparams_3->primal_0[int(5)];
    *&((&(&(&_S1406)->color_params_0)->g_0)->y) = dpparams_3->primal_0[int(6)];
    *&((&(&(&_S1406)->color_params_0)->n_0)->x) = dpparams_3->primal_0[int(7)];
    *&((&(&(&_S1406)->color_params_0)->n_0)->y) = dpparams_3->primal_0[int(8)];
    PPISPParamsNoCRFNoVig_0 _S1407 = _S1406;
    float _S1408 = s_primal_ctx_exp2_0(_S1406.exposure_0);
    float3  _S1409 = make_float3 (_S1408);
    float3  _S1410 = (*dprgb_in_3).primal_0 * make_float3 (_S1408);
    PPISPParamsNoCRFNoVig_0 _S1411 = _S1406;
    float2  _S1412 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S1406.color_params_0.b_0);
    float2  _S1413 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S1406.color_params_0.r_0);
    float2  _S1414 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S1406.color_params_0.g_0);
    float2  _S1415 = s_primal_ctx_mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S1406.color_params_0.n_0);
    float _S1416 = 0.3333333432674408f + _S1415.x;
    float _S1417 = 0.3333333432674408f + _S1415.y;
    Matrix<float, 3, 3>  T_7 = makeMatrix<float, 3, 3> (_S1412.x, 1.0f + _S1413.x, _S1414.x, _S1412.y, _S1413.y, 1.0f + _S1414.y, 1.0f, 1.0f, 1.0f);
    Matrix<float, 3, 3>  skew_3 = makeMatrix<float, 3, 3> (0.0f, -1.0f, _S1417, 1.0f, 0.0f, - _S1416, - _S1417, _S1416, 0.0f);
    Matrix<float, 3, 3>  _S1418 = s_primal_ctx_mul_1(skew_3, T_7);
    float3  r0_7 = make_float3 (_S1418.rows[int(0)].x, _S1418.rows[int(0)].y, _S1418.rows[int(0)].z);
    float3  r1_7 = make_float3 (_S1418.rows[int(1)].x, _S1418.rows[int(1)].y, _S1418.rows[int(1)].z);
    float3  r2_25 = make_float3 (_S1418.rows[int(2)].x, _S1418.rows[int(2)].y, _S1418.rows[int(2)].z);
    float3  _S1419 = s_primal_ctx_cross_0(r0_7, r1_7);
    bool _S1420 = (s_primal_ctx_dot_0(_S1419, _S1419)) < 9.99999968265522539e-21f;
    float3  lambda_v_15;
    float3  _S1421;
    bool _S1422;
    if(_S1420)
    {
        float3  _S1423 = s_primal_ctx_cross_0(r0_7, r2_25);
        bool _S1424 = (s_primal_ctx_dot_0(_S1423, _S1423)) < 9.99999968265522539e-21f;
        if(_S1424)
        {
            lambda_v_15 = s_primal_ctx_cross_0(r1_7, r2_25);
        }
        else
        {
            lambda_v_15 = _S1423;
        }
        _S1422 = _S1424;
        _S1421 = _S1423;
    }
    else
    {
        lambda_v_15 = _S1419;
        _S1422 = false;
        _S1421 = _S1402;
    }
    Matrix<float, 3, 3>  S_inv_3 = makeMatrix<float, 3, 3> (-1.0f, -1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f);
    Matrix<float, 3, 3>  D_3 = makeMatrix<float, 3, 3> (lambda_v_15.x, 0.0f, 0.0f, 0.0f, lambda_v_15.y, 0.0f, 0.0f, 0.0f, lambda_v_15.z);
    Matrix<float, 3, 3>  _S1425 = s_primal_ctx_mul_1(T_7, D_3);
    Matrix<float, 3, 3>  _S1426 = s_primal_ctx_mul_1(_S1425, S_inv_3);
    bool _S1427 = (s_primal_ctx_abs_0(_S1426.rows[int(2)].z)) > 9.99999968265522539e-21f;
    Matrix<float, 3, 3>  H_11;
    Matrix<float, 3, 3>  _S1428;
    float _S1429;
    if(_S1427)
    {
        float inv_s_3 = 1.0f / _S1426.rows[int(2)].z;
        Matrix<float, 3, 3>  _S1430 = makeMatrix<float, 3, 3> (inv_s_3);
        float _S1431 = _S1426.rows[int(2)].z * _S1426.rows[int(2)].z;
        H_11 = _S1426 * makeMatrix<float, 3, 3> (inv_s_3);
        _S1428 = _S1430;
        _S1429 = _S1431;
    }
    else
    {
        H_11 = _S1426;
        _S1428 = _S1403;
        _S1429 = 0.0f;
    }
    float _S1432 = _S1410.x;
    float _S1433 = _S1410.y;
    float intensity_7 = _S1432 + _S1433 + _S1410.z;
    float3  rgi_in_3 = make_float3 (_S1432, _S1433, intensity_7);
    float3  _S1434 = s_primal_ctx_mul_2(H_11, rgi_in_3);
    float _S1435 = _S1434.z;
    float _S1436 = 0.00009999999747379f * s_primal_ctx_abs_0(intensity_7) + 9.99999993922529029e-09f;
    float _S1437 = (F32_max((_S1435), (_S1436)));
    float norm_factor_7 = intensity_7 / _S1437;
    float _S1438 = _S1437 * _S1437;
    float _S1439 = _S1434.x;
    float out_r_7 = _S1439 * norm_factor_7;
    float _S1440 = _S1434.y;
    float out_g_7 = _S1440 * norm_factor_7;
    float3  _S1441 = make_float3 (out_r_7, out_g_7, intensity_7 - out_r_7 - out_g_7);
    float3  _S1442;
    if(clamp_output_4)
    {
        float3  _S1443 = make_float3 (1.0f);
        lambda_v_15 = make_float3 (0.0f);
        _S1442 = _S1443;
    }
    else
    {
        lambda_v_15 = _S1402;
        _S1442 = _S1402;
    }
    if(clamp_output_4)
    {
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1444;
        (&_S1444)->primal_0 = _S1441;
        (&_S1444)->differential_0 = _S1402;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1445;
        (&_S1445)->primal_0 = lambda_v_15;
        (&_S1445)->differential_0 = _S1402;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1446;
        (&_S1446)->primal_0 = _S1442;
        (&_S1446)->differential_0 = _S1402;
        s_bwd_prop_clamp_0(&_S1444, &_S1445, &_S1446, _s_dOut_3);
        lambda_v_15 = _S1444.differential_0;
    }
    else
    {
        lambda_v_15 = _s_dOut_3;
    }
    float _S1447 = - lambda_v_15.z;
    float _S1448 = lambda_v_15.y + _S1447;
    float _S1449 = norm_factor_7 * _S1448;
    float _S1450 = lambda_v_15.x + _S1447;
    float _S1451 = norm_factor_7 * _S1450;
    float _S1452 = (_S1440 * _S1448 + _S1439 * _S1450) / _S1438;
    float _S1453 = intensity_7 * - _S1452;
    float _S1454 = _S1437 * _S1452;
    DiffPair_float_0 _S1455;
    (&_S1455)->primal_0 = _S1435;
    (&_S1455)->differential_0 = 0.0f;
    DiffPair_float_0 _S1456;
    (&_S1456)->primal_0 = _S1436;
    (&_S1456)->differential_0 = 0.0f;
    _d_max_0(&_S1455, &_S1456, _S1453);
    float _S1457 = 0.00009999999747379f * _S1456.differential_0;
    DiffPair_float_0 _S1458;
    (&_S1458)->primal_0 = intensity_7;
    (&_S1458)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1458, _S1457);
    float3  _S1459 = make_float3 (_S1451, _S1449, _S1455.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1460;
    (&_S1460)->primal_0 = H_11;
    (&_S1460)->differential_0 = _S1403;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1461;
    (&_S1461)->primal_0 = rgi_in_3;
    (&_S1461)->differential_0 = _S1402;
    s_bwd_prop_mul_0(&_S1460, &_S1461, _S1459);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1462 = _S1460;
    float _S1463 = lambda_v_15.z + _S1454 + _S1458.differential_0 + _S1461.differential_0.z;
    float3  _S1464 = make_float3 (_S1461.differential_0.x + _S1463, _S1461.differential_0.y + _S1463, _S1463);
    if(_S1427)
    {
        Matrix<float, 3, 3>  _S1465 = _S1426 * _S1462.differential_0;
        Matrix<float, 3, 3>  _S1466 = _S1428 * _S1462.differential_0;
        _S1429 = - ((_S1465.rows[int(0)].x + _S1465.rows[int(0)].y + _S1465.rows[int(0)].z + _S1465.rows[int(1)].x + _S1465.rows[int(1)].y + _S1465.rows[int(1)].z + _S1465.rows[int(2)].x + _S1465.rows[int(2)].y + _S1465.rows[int(2)].z) / _S1429);
        H_11 = _S1466;
    }
    else
    {
        _S1429 = 0.0f;
        H_11 = _S1462.differential_0;
    }
    DiffPair_float_0 _S1467;
    (&_S1467)->primal_0 = _S1426.rows[int(2)].z;
    (&_S1467)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S1467, 0.0f);
    float _S1468 = _S1467.differential_0 + _S1429;
    float3  _S1469 = _S1402;
    *&((&_S1469)->z) = _S1468;
    Matrix<float, 3, 3>  _S1470 = _S1403;
    _S1470[int(2)] = _S1469;
    Matrix<float, 3, 3>  _S1471 = H_11 + _S1470;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1472;
    (&_S1472)->primal_0 = _S1425;
    (&_S1472)->differential_0 = _S1403;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1473;
    (&_S1473)->primal_0 = S_inv_3;
    (&_S1473)->differential_0 = _S1403;
    s_bwd_prop_mul_1(&_S1472, &_S1473, _S1471);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1474;
    (&_S1474)->primal_0 = T_7;
    (&_S1474)->differential_0 = _S1403;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1475;
    (&_S1475)->primal_0 = D_3;
    (&_S1475)->differential_0 = _S1403;
    s_bwd_prop_mul_1(&_S1474, &_S1475, _S1472.differential_0);
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1476 = _S1474;
    float3  _S1477 = make_float3 (_S1475.differential_0.rows[int(0)].x, _S1475.differential_0.rows[int(1)].y, _S1475.differential_0.rows[int(2)].z);
    float3  _S1478;
    if(_S1420)
    {
        if(_S1422)
        {
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1479;
            (&_S1479)->primal_0 = r1_7;
            (&_S1479)->differential_0 = _S1402;
            DiffPair_vectorx3Cfloatx2C3x3E_0 _S1480;
            (&_S1480)->primal_0 = r2_25;
            (&_S1480)->differential_0 = _S1402;
            s_bwd_prop_cross_0(&_S1479, &_S1480, _S1477);
            lambda_v_15 = _S1402;
            _S1442 = _S1480.differential_0;
            _S1478 = _S1479.differential_0;
        }
        else
        {
            lambda_v_15 = _S1477;
            _S1442 = _S1402;
            _S1478 = _S1402;
        }
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1481;
        (&_S1481)->primal_0 = _S1421;
        (&_S1481)->differential_0 = _S1402;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1482;
        (&_S1482)->primal_0 = _S1421;
        (&_S1482)->differential_0 = _S1402;
        s_bwd_prop_dot_0(&_S1481, &_S1482, 0.0f);
        float3  _S1483 = _S1482.differential_0 + _S1481.differential_0 + lambda_v_15;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1484;
        (&_S1484)->primal_0 = r0_7;
        (&_S1484)->differential_0 = _S1402;
        DiffPair_vectorx3Cfloatx2C3x3E_0 _S1485;
        (&_S1485)->primal_0 = r2_25;
        (&_S1485)->differential_0 = _S1402;
        s_bwd_prop_cross_0(&_S1484, &_S1485, _S1483);
        float3  _S1486 = _S1485.differential_0 + _S1442;
        lambda_v_15 = _S1402;
        _S1421 = _S1486;
        _S1442 = _S1478;
        _S1478 = _S1484.differential_0;
    }
    else
    {
        lambda_v_15 = _S1477;
        _S1421 = _S1402;
        _S1442 = _S1402;
        _S1478 = _S1402;
    }
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1487;
    (&_S1487)->primal_0 = _S1419;
    (&_S1487)->differential_0 = _S1402;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1488;
    (&_S1488)->primal_0 = _S1419;
    (&_S1488)->differential_0 = _S1402;
    s_bwd_prop_dot_0(&_S1487, &_S1488, 0.0f);
    float3  _S1489 = _S1488.differential_0 + _S1487.differential_0 + lambda_v_15;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1490;
    (&_S1490)->primal_0 = r0_7;
    (&_S1490)->differential_0 = _S1402;
    DiffPair_vectorx3Cfloatx2C3x3E_0 _S1491;
    (&_S1491)->primal_0 = r1_7;
    (&_S1491)->differential_0 = _S1402;
    s_bwd_prop_cross_0(&_S1490, &_S1491, _S1489);
    float3  _S1492 = _S1402;
    *&((&_S1492)->z) = _S1421.z;
    *&((&_S1492)->y) = _S1421.y;
    *&((&_S1492)->x) = _S1421.x;
    float3  _S1493 = _S1491.differential_0 + _S1442;
    float3  _S1494 = _S1402;
    *&((&_S1494)->z) = _S1493.z;
    *&((&_S1494)->y) = _S1493.y;
    *&((&_S1494)->x) = _S1493.x;
    float3  _S1495 = _S1490.differential_0 + _S1478;
    float3  _S1496 = _S1402;
    *&((&_S1496)->z) = _S1495.z;
    *&((&_S1496)->y) = _S1495.y;
    *&((&_S1496)->x) = _S1495.x;
    Matrix<float, 3, 3>  _S1497 = _S1403;
    _S1497[int(2)] = _S1492;
    _S1497[int(1)] = _S1494;
    _S1497[int(0)] = _S1496;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1498;
    (&_S1498)->primal_0 = skew_3;
    (&_S1498)->differential_0 = _S1403;
    DiffPair_matrixx3Cfloatx2C3x2C3x3E_0 _S1499;
    (&_S1499)->primal_0 = T_7;
    (&_S1499)->differential_0 = _S1403;
    s_bwd_prop_mul_1(&_S1498, &_S1499, _S1497);
    Matrix<float, 3, 3>  _S1500 = _S1499.differential_0 + _S1476.differential_0;
    float2  _S1501 = make_float2 (_S1498.differential_0.rows[int(2)].y + - _S1498.differential_0.rows[int(1)].z, _S1498.differential_0.rows[int(0)].z + - _S1498.differential_0.rows[int(2)].x);
    Matrix<float, 2, 2>  _S1502 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1503;
    (&_S1503)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S1503)->differential_0 = _S1502;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1504;
    (&_S1504)->primal_0 = _S1411.color_params_0.n_0;
    (&_S1504)->differential_0 = _S1404;
    s_bwd_prop_mul_2(&_S1503, &_S1504, _S1501);
    float2  _S1505 = make_float2 (_S1500.rows[int(0)].z, _S1500.rows[int(1)].z);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1506;
    (&_S1506)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S1506)->differential_0 = _S1502;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1507;
    (&_S1507)->primal_0 = _S1411.color_params_0.g_0;
    (&_S1507)->differential_0 = _S1404;
    s_bwd_prop_mul_2(&_S1506, &_S1507, _S1505);
    float2  _S1508 = make_float2 (_S1500.rows[int(0)].y, _S1500.rows[int(1)].y);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1509;
    (&_S1509)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S1509)->differential_0 = _S1502;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1510;
    (&_S1510)->primal_0 = _S1411.color_params_0.r_0;
    (&_S1510)->differential_0 = _S1404;
    s_bwd_prop_mul_2(&_S1509, &_S1510, _S1508);
    float2  _S1511 = make_float2 (_S1500.rows[int(0)].x, _S1500.rows[int(1)].x);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1512;
    (&_S1512)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S1512)->differential_0 = _S1502;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1513;
    (&_S1513)->primal_0 = _S1411.color_params_0.b_0;
    (&_S1513)->differential_0 = _S1404;
    s_bwd_prop_mul_2(&_S1512, &_S1513, _S1511);
    ColorPPISPParams_0 _S1514 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S1514)->n_0 = _S1504.differential_0;
    (&_S1514)->g_0 = _S1507.differential_0;
    (&_S1514)->r_0 = _S1510.differential_0;
    (&_S1514)->b_0 = _S1513.differential_0;
    float3  _S1515 = _S1401.primal_0 * _S1464;
    float3  _S1516 = _S1409 * _S1464;
    float _S1517 = _S1515.x + _S1515.y + _S1515.z;
    DiffPair_float_0 _S1518;
    (&_S1518)->primal_0 = _S1407.exposure_0;
    (&_S1518)->differential_0 = 0.0f;
    s_bwd_prop_exp2_0(&_S1518, _S1517);
    PPISPParamsNoCRFNoVig_0 _S1519 = PPISPParamsNoCRFNoVig_x24_syn_dzero_0();
    (&_S1519)->color_params_0 = _S1514;
    (&_S1519)->exposure_0 = _S1518.differential_0;
    _S1406 = _S1519;
    *&((&(&(&_S1406)->color_params_0)->n_0)->y) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->n_0)->x) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->g_0)->y) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->g_0)->x) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->r_0)->y) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->r_0)->x) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->b_0)->y) = 0.0f;
    *&((&(&(&_S1406)->color_params_0)->b_0)->x) = 0.0f;
    FixedArray<float, 9>  _S1520;
    _S1520[int(0)] = 0.0f;
    _S1520[int(1)] = 0.0f;
    _S1520[int(2)] = 0.0f;
    _S1520[int(3)] = 0.0f;
    _S1520[int(4)] = 0.0f;
    _S1520[int(5)] = 0.0f;
    _S1520[int(6)] = 0.0f;
    _S1520[int(7)] = 0.0f;
    _S1520[int(8)] = 0.0f;
    _S1520[int(8)] = _S1519.color_params_0.n_0.y;
    _S1520[int(7)] = _S1519.color_params_0.n_0.x;
    _S1520[int(6)] = _S1519.color_params_0.g_0.y;
    _S1520[int(5)] = _S1519.color_params_0.g_0.x;
    _S1520[int(4)] = _S1519.color_params_0.r_0.y;
    _S1520[int(3)] = _S1519.color_params_0.r_0.x;
    _S1520[int(2)] = _S1519.color_params_0.b_0.y;
    _S1520[int(1)] = _S1519.color_params_0.b_0.x;
    _S1520[int(0)] = _S1406.exposure_0;
    dpparams_3->primal_0 = dpparams_3->primal_0;
    dpparams_3->differential_0 = _S1520;
    dprgb_in_3->primal_0 = (*dprgb_in_3).primal_0;
    dprgb_in_3->differential_0 = _S1516;
    return;
}

inline __device__ void s_bwd_apply_ppisp_no_crf_no_vig_0(DiffPair_vectorx3Cfloatx2C3x3E_0 * _S1521, float2  _S1522, float2  _S1523, float2  _S1524, DiffPair_arrayx3Cfloatx2C9x3E_0 * _S1525, bool _S1526, float3  _S1527)
{
    s_bwd_prop_apply_ppisp_no_crf_no_vig_0(_S1521, _S1522, _S1523, _S1524, _S1525, _S1526, _S1527);
    return;
}

inline __device__ void apply_ppisp_no_crf_no_vig_vjp(float3  rgb_in_7, float2  pix_coord_11, float2  image_center_11, float2  img_size_11, FixedArray<float, 9>  params_7, bool clamp_output_5, float3  grad_out_3, float3  * grad_rgb_in_3, FixedArray<float, 9>  * grad_params_3)
{
    float3  _S1528 = make_float3 (0.0f);
    DiffPair_vectorx3Cfloatx2C3x3E_0 dp_rgb_in_3;
    (&dp_rgb_in_3)->primal_0 = rgb_in_7;
    (&dp_rgb_in_3)->differential_0 = _S1528;
    FixedArray<float, 9>  _S1529 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C9x3E_0 dp_params_3;
    (&dp_params_3)->primal_0 = params_7;
    (&dp_params_3)->differential_0 = _S1529;
    s_bwd_apply_ppisp_no_crf_no_vig_0(&dp_rgb_in_3, pix_coord_11, image_center_11, img_size_11, &dp_params_3, clamp_output_5, grad_out_3);
    *grad_rgb_in_3 = dp_rgb_in_3.differential_0;
    *grad_params_3 = (&dp_params_3)->differential_0;
    return;
}

inline __device__ void compute_raw_ppisp_regularization_loss(FixedArray<float, 36>  params_8, bool exposure_arithmetic_mean_0, FixedArray<float, 22>  * _S1530)
{
    float _S1531;
    PPISPParams_0 p_4;
    (&p_4)->exposure_3 = params_8[int(0)];
    (&(&p_4)->vignette_params_2[int(0)])->cx_0 = params_8[int(1)];
    (&(&p_4)->vignette_params_2[int(0)])->cy_0 = params_8[int(2)];
    (&(&p_4)->vignette_params_2[int(0)])->alpha0_0 = params_8[int(3)];
    (&(&p_4)->vignette_params_2[int(0)])->alpha1_0 = params_8[int(4)];
    (&(&p_4)->vignette_params_2[int(0)])->alpha2_0 = params_8[int(5)];
    (&(&p_4)->vignette_params_2[int(1)])->cx_0 = params_8[int(6)];
    (&(&p_4)->vignette_params_2[int(1)])->cy_0 = params_8[int(7)];
    (&(&p_4)->vignette_params_2[int(1)])->alpha0_0 = params_8[int(8)];
    (&(&p_4)->vignette_params_2[int(1)])->alpha1_0 = params_8[int(9)];
    (&(&p_4)->vignette_params_2[int(1)])->alpha2_0 = params_8[int(10)];
    (&(&p_4)->vignette_params_2[int(2)])->cx_0 = params_8[int(11)];
    (&(&p_4)->vignette_params_2[int(2)])->cy_0 = params_8[int(12)];
    (&(&p_4)->vignette_params_2[int(2)])->alpha0_0 = params_8[int(13)];
    (&(&p_4)->vignette_params_2[int(2)])->alpha1_0 = params_8[int(14)];
    (&(&p_4)->vignette_params_2[int(2)])->alpha2_0 = params_8[int(15)];
    *&((&(&(&p_4)->color_params_3)->b_0)->x) = params_8[int(16)];
    *&((&(&(&p_4)->color_params_3)->b_0)->y) = params_8[int(17)];
    *&((&(&(&p_4)->color_params_3)->r_0)->x) = params_8[int(18)];
    *&((&(&(&p_4)->color_params_3)->r_0)->y) = params_8[int(19)];
    *&((&(&(&p_4)->color_params_3)->g_0)->x) = params_8[int(20)];
    *&((&(&(&p_4)->color_params_3)->g_0)->y) = params_8[int(21)];
    *&((&(&(&p_4)->color_params_3)->n_0)->x) = params_8[int(22)];
    *&((&(&(&p_4)->color_params_3)->n_0)->y) = params_8[int(23)];
    (&(&p_4)->crf_params_1[int(0)])->toe_0 = params_8[int(24)];
    (&(&p_4)->crf_params_1[int(0)])->shoulder_0 = params_8[int(25)];
    (&(&p_4)->crf_params_1[int(0)])->gamma_0 = params_8[int(26)];
    (&(&p_4)->crf_params_1[int(0)])->center_0 = params_8[int(27)];
    (&(&p_4)->crf_params_1[int(1)])->toe_0 = params_8[int(28)];
    (&(&p_4)->crf_params_1[int(1)])->shoulder_0 = params_8[int(29)];
    (&(&p_4)->crf_params_1[int(1)])->gamma_0 = params_8[int(30)];
    (&(&p_4)->crf_params_1[int(1)])->center_0 = params_8[int(31)];
    (&(&p_4)->crf_params_1[int(2)])->toe_0 = params_8[int(32)];
    (&(&p_4)->crf_params_1[int(2)])->shoulder_0 = params_8[int(33)];
    (&(&p_4)->crf_params_1[int(2)])->gamma_0 = params_8[int(34)];
    (&(&p_4)->crf_params_1[int(2)])->center_0 = params_8[int(35)];
    PPISPParams_0 _S1532 = p_4;
    FixedArray<float, 22>  losses_0;
    losses_0[int(0)] = 0.0f;
    losses_0[int(1)] = 0.0f;
    losses_0[int(2)] = 0.0f;
    losses_0[int(3)] = 0.0f;
    losses_0[int(4)] = 0.0f;
    losses_0[int(5)] = 0.0f;
    losses_0[int(6)] = 0.0f;
    losses_0[int(7)] = 0.0f;
    losses_0[int(8)] = 0.0f;
    losses_0[int(9)] = 0.0f;
    losses_0[int(10)] = 0.0f;
    losses_0[int(11)] = 0.0f;
    losses_0[int(12)] = 0.0f;
    losses_0[int(13)] = 0.0f;
    losses_0[int(14)] = 0.0f;
    losses_0[int(15)] = 0.0f;
    losses_0[int(16)] = 0.0f;
    losses_0[int(17)] = 0.0f;
    losses_0[int(18)] = 0.0f;
    losses_0[int(19)] = 0.0f;
    losses_0[int(20)] = 0.0f;
    losses_0[int(21)] = 0.0f;
    for(;;)
    {
        if(exposure_arithmetic_mean_0)
        {
            _S1531 = (F32_exp2((_S1532.exposure_3)));
            break;
        }
        _S1531 = _S1532.exposure_3;
        break;
    }
    losses_0[int(0)] = _S1531;
    float _S1533 = _S1532.vignette_params_2[int(0)].cx_0;
    float _S1534 = _S1532.vignette_params_2[int(0)].cy_0;
    float _S1535 = _S1532.vignette_params_2[int(1)].cx_0;
    float _S1536 = _S1532.vignette_params_2[int(1)].cy_0;
    float _S1537 = _S1532.vignette_params_2[int(2)].cx_0;
    float _S1538 = _S1532.vignette_params_2[int(2)].cy_0;
    losses_0[int(1)] = _S1533 * _S1533 + _S1534 * _S1534 + _S1535 * _S1535 + _S1536 * _S1536 + _S1537 * _S1537 + _S1538 * _S1538;
    losses_0[int(2)] = (F32_max((0.0f), (_S1532.vignette_params_2[int(0)].alpha0_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(1)].alpha0_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(2)].alpha0_0)));
    losses_0[int(3)] = (F32_max((0.0f), (_S1532.vignette_params_2[int(0)].alpha1_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(1)].alpha1_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(2)].alpha1_0)));
    losses_0[int(4)] = (F32_max((0.0f), (_S1532.vignette_params_2[int(0)].alpha2_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(1)].alpha2_0))) + (F32_max((0.0f), (_S1532.vignette_params_2[int(2)].alpha2_0)));
    float mean_0 = (_S1532.vignette_params_2[int(0)].cx_0 + _S1532.vignette_params_2[int(1)].cx_0 + _S1532.vignette_params_2[int(2)].cx_0) / 3.0f;
    float _S1539 = _S1532.vignette_params_2[int(0)].cx_0 - mean_0;
    float _S1540 = _S1532.vignette_params_2[int(1)].cx_0 - mean_0;
    float _S1541 = _S1532.vignette_params_2[int(2)].cx_0 - mean_0;
    losses_0[int(5)] = (_S1539 * _S1539 + _S1540 * _S1540 + _S1541 * _S1541) / 3.0f;
    float mean_1 = (_S1532.vignette_params_2[int(0)].cy_0 + _S1532.vignette_params_2[int(1)].cy_0 + _S1532.vignette_params_2[int(2)].cy_0) / 3.0f;
    float _S1542 = _S1532.vignette_params_2[int(0)].cy_0 - mean_1;
    float _S1543 = _S1532.vignette_params_2[int(1)].cy_0 - mean_1;
    float _S1544 = _S1532.vignette_params_2[int(2)].cy_0 - mean_1;
    losses_0[int(6)] = (_S1542 * _S1542 + _S1543 * _S1543 + _S1544 * _S1544) / 3.0f;
    float mean_2 = (_S1532.vignette_params_2[int(0)].alpha0_0 + _S1532.vignette_params_2[int(1)].alpha0_0 + _S1532.vignette_params_2[int(2)].alpha0_0) / 3.0f;
    float _S1545 = _S1532.vignette_params_2[int(0)].alpha0_0 - mean_2;
    float _S1546 = _S1532.vignette_params_2[int(1)].alpha0_0 - mean_2;
    float _S1547 = _S1532.vignette_params_2[int(2)].alpha0_0 - mean_2;
    losses_0[int(7)] = (_S1545 * _S1545 + _S1546 * _S1546 + _S1547 * _S1547) / 3.0f;
    float mean_3 = (_S1532.vignette_params_2[int(0)].alpha1_0 + _S1532.vignette_params_2[int(1)].alpha1_0 + _S1532.vignette_params_2[int(2)].alpha1_0) / 3.0f;
    float _S1548 = _S1532.vignette_params_2[int(0)].alpha1_0 - mean_3;
    float _S1549 = _S1532.vignette_params_2[int(1)].alpha1_0 - mean_3;
    float _S1550 = _S1532.vignette_params_2[int(2)].alpha1_0 - mean_3;
    losses_0[int(8)] = (_S1548 * _S1548 + _S1549 * _S1549 + _S1550 * _S1550) / 3.0f;
    float mean_4 = (_S1532.vignette_params_2[int(0)].alpha2_0 + _S1532.vignette_params_2[int(1)].alpha2_0 + _S1532.vignette_params_2[int(2)].alpha2_0) / 3.0f;
    float _S1551 = _S1532.vignette_params_2[int(0)].alpha2_0 - mean_4;
    float _S1552 = _S1532.vignette_params_2[int(1)].alpha2_0 - mean_4;
    float _S1553 = _S1532.vignette_params_2[int(2)].alpha2_0 - mean_4;
    losses_0[int(9)] = (_S1551 * _S1551 + _S1552 * _S1552 + _S1553 * _S1553) / 3.0f;
    float2  bd_4 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S1532.color_params_3.b_0);
    float2  rd_4 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S1532.color_params_3.r_0);
    float2  gd_4 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S1532.color_params_3.g_0);
    float2  nd_4 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S1532.color_params_3.n_0);
    losses_0[int(10)] = bd_4.x;
    losses_0[int(11)] = bd_4.y;
    losses_0[int(12)] = rd_4.x;
    losses_0[int(13)] = rd_4.y;
    losses_0[int(14)] = gd_4.x;
    losses_0[int(15)] = gd_4.y;
    losses_0[int(16)] = nd_4.x;
    losses_0[int(17)] = nd_4.y;
    float mean_5 = (_S1532.crf_params_1[int(0)].toe_0 + _S1532.crf_params_1[int(1)].toe_0 + _S1532.crf_params_1[int(2)].toe_0) / 3.0f;
    float _S1554 = _S1532.crf_params_1[int(0)].toe_0 - mean_5;
    float _S1555 = _S1532.crf_params_1[int(1)].toe_0 - mean_5;
    float _S1556 = _S1532.crf_params_1[int(2)].toe_0 - mean_5;
    losses_0[int(18)] = (_S1554 * _S1554 + _S1555 * _S1555 + _S1556 * _S1556) / 3.0f;
    float mean_6 = (_S1532.crf_params_1[int(0)].shoulder_0 + _S1532.crf_params_1[int(1)].shoulder_0 + _S1532.crf_params_1[int(2)].shoulder_0) / 3.0f;
    float _S1557 = _S1532.crf_params_1[int(0)].shoulder_0 - mean_6;
    float _S1558 = _S1532.crf_params_1[int(1)].shoulder_0 - mean_6;
    float _S1559 = _S1532.crf_params_1[int(2)].shoulder_0 - mean_6;
    losses_0[int(19)] = (_S1557 * _S1557 + _S1558 * _S1558 + _S1559 * _S1559) / 3.0f;
    float mean_7 = (_S1532.crf_params_1[int(0)].gamma_0 + _S1532.crf_params_1[int(1)].gamma_0 + _S1532.crf_params_1[int(2)].gamma_0) / 3.0f;
    float _S1560 = _S1532.crf_params_1[int(0)].gamma_0 - mean_7;
    float _S1561 = _S1532.crf_params_1[int(1)].gamma_0 - mean_7;
    float _S1562 = _S1532.crf_params_1[int(2)].gamma_0 - mean_7;
    losses_0[int(20)] = (_S1560 * _S1560 + _S1561 * _S1561 + _S1562 * _S1562) / 3.0f;
    float mean_8 = (_S1532.crf_params_1[int(0)].center_0 + _S1532.crf_params_1[int(1)].center_0 + _S1532.crf_params_1[int(2)].center_0) / 3.0f;
    float _S1563 = _S1532.crf_params_1[int(0)].center_0 - mean_8;
    float _S1564 = _S1532.crf_params_1[int(1)].center_0 - mean_8;
    float _S1565 = _S1532.crf_params_1[int(2)].center_0 - mean_8;
    losses_0[int(21)] = (_S1563 * _S1563 + _S1564 * _S1564 + _S1565 * _S1565) / 3.0f;
    *_S1530 = losses_0;
    return;
}

inline __device__ void compute_raw_ppisp_rqs_regularization_loss(FixedArray<float, 39>  params_9, bool exposure_arithmetic_mean_1, FixedArray<float, 23>  * _S1566)
{
    float _S1567;
    PPISPParamsRQS_0 p_5;
    (&p_5)->exposure_2 = params_9[int(0)];
    (&(&p_5)->vignette_params_1[int(0)])->cx_0 = params_9[int(1)];
    (&(&p_5)->vignette_params_1[int(0)])->cy_0 = params_9[int(2)];
    (&(&p_5)->vignette_params_1[int(0)])->alpha0_0 = params_9[int(3)];
    (&(&p_5)->vignette_params_1[int(0)])->alpha1_0 = params_9[int(4)];
    (&(&p_5)->vignette_params_1[int(0)])->alpha2_0 = params_9[int(5)];
    (&(&p_5)->vignette_params_1[int(1)])->cx_0 = params_9[int(6)];
    (&(&p_5)->vignette_params_1[int(1)])->cy_0 = params_9[int(7)];
    (&(&p_5)->vignette_params_1[int(1)])->alpha0_0 = params_9[int(8)];
    (&(&p_5)->vignette_params_1[int(1)])->alpha1_0 = params_9[int(9)];
    (&(&p_5)->vignette_params_1[int(1)])->alpha2_0 = params_9[int(10)];
    (&(&p_5)->vignette_params_1[int(2)])->cx_0 = params_9[int(11)];
    (&(&p_5)->vignette_params_1[int(2)])->cy_0 = params_9[int(12)];
    (&(&p_5)->vignette_params_1[int(2)])->alpha0_0 = params_9[int(13)];
    (&(&p_5)->vignette_params_1[int(2)])->alpha1_0 = params_9[int(14)];
    (&(&p_5)->vignette_params_1[int(2)])->alpha2_0 = params_9[int(15)];
    *&((&(&(&p_5)->color_params_2)->b_0)->x) = params_9[int(16)];
    *&((&(&(&p_5)->color_params_2)->b_0)->y) = params_9[int(17)];
    *&((&(&(&p_5)->color_params_2)->r_0)->x) = params_9[int(18)];
    *&((&(&(&p_5)->color_params_2)->r_0)->y) = params_9[int(19)];
    *&((&(&(&p_5)->color_params_2)->g_0)->x) = params_9[int(20)];
    *&((&(&(&p_5)->color_params_2)->g_0)->y) = params_9[int(21)];
    *&((&(&(&p_5)->color_params_2)->n_0)->x) = params_9[int(22)];
    *&((&(&(&p_5)->color_params_2)->n_0)->y) = params_9[int(23)];
    (&(&p_5)->crf_params_0[int(0)])->g0_0 = params_9[int(24)];
    (&(&p_5)->crf_params_0[int(0)])->g1_0 = params_9[int(25)];
    (&(&p_5)->crf_params_0[int(0)])->x0_0 = params_9[int(26)];
    (&(&p_5)->crf_params_0[int(0)])->y0_0 = params_9[int(27)];
    (&(&p_5)->crf_params_0[int(0)])->gc_0 = params_9[int(28)];
    (&(&p_5)->crf_params_0[int(1)])->g0_0 = params_9[int(29)];
    (&(&p_5)->crf_params_0[int(1)])->g1_0 = params_9[int(30)];
    (&(&p_5)->crf_params_0[int(1)])->x0_0 = params_9[int(31)];
    (&(&p_5)->crf_params_0[int(1)])->y0_0 = params_9[int(32)];
    (&(&p_5)->crf_params_0[int(1)])->gc_0 = params_9[int(33)];
    (&(&p_5)->crf_params_0[int(2)])->g0_0 = params_9[int(34)];
    (&(&p_5)->crf_params_0[int(2)])->g1_0 = params_9[int(35)];
    (&(&p_5)->crf_params_0[int(2)])->x0_0 = params_9[int(36)];
    (&(&p_5)->crf_params_0[int(2)])->y0_0 = params_9[int(37)];
    (&(&p_5)->crf_params_0[int(2)])->gc_0 = params_9[int(38)];
    PPISPParamsRQS_0 _S1568 = p_5;
    FixedArray<float, 23>  losses_1;
    losses_1[int(0)] = 0.0f;
    losses_1[int(1)] = 0.0f;
    losses_1[int(2)] = 0.0f;
    losses_1[int(3)] = 0.0f;
    losses_1[int(4)] = 0.0f;
    losses_1[int(5)] = 0.0f;
    losses_1[int(6)] = 0.0f;
    losses_1[int(7)] = 0.0f;
    losses_1[int(8)] = 0.0f;
    losses_1[int(9)] = 0.0f;
    losses_1[int(10)] = 0.0f;
    losses_1[int(11)] = 0.0f;
    losses_1[int(12)] = 0.0f;
    losses_1[int(13)] = 0.0f;
    losses_1[int(14)] = 0.0f;
    losses_1[int(15)] = 0.0f;
    losses_1[int(16)] = 0.0f;
    losses_1[int(17)] = 0.0f;
    losses_1[int(18)] = 0.0f;
    losses_1[int(19)] = 0.0f;
    losses_1[int(20)] = 0.0f;
    losses_1[int(21)] = 0.0f;
    losses_1[int(22)] = 0.0f;
    for(;;)
    {
        if(exposure_arithmetic_mean_1)
        {
            _S1567 = (F32_exp2((_S1568.exposure_2)));
            break;
        }
        _S1567 = _S1568.exposure_2;
        break;
    }
    losses_1[int(0)] = _S1567;
    float _S1569 = _S1568.vignette_params_1[int(0)].cx_0;
    float _S1570 = _S1568.vignette_params_1[int(0)].cy_0;
    float _S1571 = _S1568.vignette_params_1[int(1)].cx_0;
    float _S1572 = _S1568.vignette_params_1[int(1)].cy_0;
    float _S1573 = _S1568.vignette_params_1[int(2)].cx_0;
    float _S1574 = _S1568.vignette_params_1[int(2)].cy_0;
    losses_1[int(1)] = _S1569 * _S1569 + _S1570 * _S1570 + _S1571 * _S1571 + _S1572 * _S1572 + _S1573 * _S1573 + _S1574 * _S1574;
    losses_1[int(2)] = (F32_max((0.0f), (_S1568.vignette_params_1[int(0)].alpha0_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(1)].alpha0_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(2)].alpha0_0)));
    losses_1[int(3)] = (F32_max((0.0f), (_S1568.vignette_params_1[int(0)].alpha1_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(1)].alpha1_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(2)].alpha1_0)));
    losses_1[int(4)] = (F32_max((0.0f), (_S1568.vignette_params_1[int(0)].alpha2_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(1)].alpha2_0))) + (F32_max((0.0f), (_S1568.vignette_params_1[int(2)].alpha2_0)));
    float mean_9 = (_S1568.vignette_params_1[int(0)].cx_0 + _S1568.vignette_params_1[int(1)].cx_0 + _S1568.vignette_params_1[int(2)].cx_0) / 3.0f;
    float _S1575 = _S1568.vignette_params_1[int(0)].cx_0 - mean_9;
    float _S1576 = _S1568.vignette_params_1[int(1)].cx_0 - mean_9;
    float _S1577 = _S1568.vignette_params_1[int(2)].cx_0 - mean_9;
    losses_1[int(5)] = (_S1575 * _S1575 + _S1576 * _S1576 + _S1577 * _S1577) / 3.0f;
    float mean_10 = (_S1568.vignette_params_1[int(0)].cy_0 + _S1568.vignette_params_1[int(1)].cy_0 + _S1568.vignette_params_1[int(2)].cy_0) / 3.0f;
    float _S1578 = _S1568.vignette_params_1[int(0)].cy_0 - mean_10;
    float _S1579 = _S1568.vignette_params_1[int(1)].cy_0 - mean_10;
    float _S1580 = _S1568.vignette_params_1[int(2)].cy_0 - mean_10;
    losses_1[int(6)] = (_S1578 * _S1578 + _S1579 * _S1579 + _S1580 * _S1580) / 3.0f;
    float mean_11 = (_S1568.vignette_params_1[int(0)].alpha0_0 + _S1568.vignette_params_1[int(1)].alpha0_0 + _S1568.vignette_params_1[int(2)].alpha0_0) / 3.0f;
    float _S1581 = _S1568.vignette_params_1[int(0)].alpha0_0 - mean_11;
    float _S1582 = _S1568.vignette_params_1[int(1)].alpha0_0 - mean_11;
    float _S1583 = _S1568.vignette_params_1[int(2)].alpha0_0 - mean_11;
    losses_1[int(7)] = (_S1581 * _S1581 + _S1582 * _S1582 + _S1583 * _S1583) / 3.0f;
    float mean_12 = (_S1568.vignette_params_1[int(0)].alpha1_0 + _S1568.vignette_params_1[int(1)].alpha1_0 + _S1568.vignette_params_1[int(2)].alpha1_0) / 3.0f;
    float _S1584 = _S1568.vignette_params_1[int(0)].alpha1_0 - mean_12;
    float _S1585 = _S1568.vignette_params_1[int(1)].alpha1_0 - mean_12;
    float _S1586 = _S1568.vignette_params_1[int(2)].alpha1_0 - mean_12;
    losses_1[int(8)] = (_S1584 * _S1584 + _S1585 * _S1585 + _S1586 * _S1586) / 3.0f;
    float mean_13 = (_S1568.vignette_params_1[int(0)].alpha2_0 + _S1568.vignette_params_1[int(1)].alpha2_0 + _S1568.vignette_params_1[int(2)].alpha2_0) / 3.0f;
    float _S1587 = _S1568.vignette_params_1[int(0)].alpha2_0 - mean_13;
    float _S1588 = _S1568.vignette_params_1[int(1)].alpha2_0 - mean_13;
    float _S1589 = _S1568.vignette_params_1[int(2)].alpha2_0 - mean_13;
    losses_1[int(9)] = (_S1587 * _S1587 + _S1588 * _S1588 + _S1589 * _S1589) / 3.0f;
    float2  bd_5 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S1568.color_params_2.b_0);
    float2  rd_5 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S1568.color_params_2.r_0);
    float2  gd_5 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S1568.color_params_2.g_0);
    float2  nd_5 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S1568.color_params_2.n_0);
    losses_1[int(10)] = bd_5.x;
    losses_1[int(11)] = bd_5.y;
    losses_1[int(12)] = rd_5.x;
    losses_1[int(13)] = rd_5.y;
    losses_1[int(14)] = gd_5.x;
    losses_1[int(15)] = gd_5.y;
    losses_1[int(16)] = nd_5.x;
    losses_1[int(17)] = nd_5.y;
    float mean_14 = (_S1568.crf_params_0[int(0)].g0_0 + _S1568.crf_params_0[int(1)].g0_0 + _S1568.crf_params_0[int(2)].g0_0) / 3.0f;
    float _S1590 = _S1568.crf_params_0[int(0)].g0_0 - mean_14;
    float _S1591 = _S1568.crf_params_0[int(1)].g0_0 - mean_14;
    float _S1592 = _S1568.crf_params_0[int(2)].g0_0 - mean_14;
    losses_1[int(18)] = (_S1590 * _S1590 + _S1591 * _S1591 + _S1592 * _S1592) / 3.0f;
    float mean_15 = (_S1568.crf_params_0[int(0)].g1_0 + _S1568.crf_params_0[int(1)].g1_0 + _S1568.crf_params_0[int(2)].g1_0) / 3.0f;
    float _S1593 = _S1568.crf_params_0[int(0)].g1_0 - mean_15;
    float _S1594 = _S1568.crf_params_0[int(1)].g1_0 - mean_15;
    float _S1595 = _S1568.crf_params_0[int(2)].g1_0 - mean_15;
    losses_1[int(19)] = (_S1593 * _S1593 + _S1594 * _S1594 + _S1595 * _S1595) / 3.0f;
    float mean_16 = (_S1568.crf_params_0[int(0)].x0_0 + _S1568.crf_params_0[int(1)].x0_0 + _S1568.crf_params_0[int(2)].x0_0) / 3.0f;
    float _S1596 = _S1568.crf_params_0[int(0)].x0_0 - mean_16;
    float _S1597 = _S1568.crf_params_0[int(1)].x0_0 - mean_16;
    float _S1598 = _S1568.crf_params_0[int(2)].x0_0 - mean_16;
    losses_1[int(20)] = (_S1596 * _S1596 + _S1597 * _S1597 + _S1598 * _S1598) / 3.0f;
    float mean_17 = (_S1568.crf_params_0[int(0)].y0_0 + _S1568.crf_params_0[int(1)].y0_0 + _S1568.crf_params_0[int(2)].y0_0) / 3.0f;
    float _S1599 = _S1568.crf_params_0[int(0)].y0_0 - mean_17;
    float _S1600 = _S1568.crf_params_0[int(1)].y0_0 - mean_17;
    float _S1601 = _S1568.crf_params_0[int(2)].y0_0 - mean_17;
    losses_1[int(21)] = (_S1599 * _S1599 + _S1600 * _S1600 + _S1601 * _S1601) / 3.0f;
    float mean_18 = (_S1568.crf_params_0[int(0)].gc_0 + _S1568.crf_params_0[int(1)].gc_0 + _S1568.crf_params_0[int(2)].gc_0) / 3.0f;
    float _S1602 = _S1568.crf_params_0[int(0)].gc_0 - mean_18;
    float _S1603 = _S1568.crf_params_0[int(1)].gc_0 - mean_18;
    float _S1604 = _S1568.crf_params_0[int(2)].gc_0 - mean_18;
    losses_1[int(22)] = (_S1602 * _S1602 + _S1603 * _S1603 + _S1604 * _S1604) / 3.0f;
    *_S1566 = losses_1;
    return;
}

inline __device__ void s_bwd_prop_compute_raw_ppisp_regularization_loss_0(DiffPair_arrayx3Cfloatx2C36x3E_0 * dpparams_4, bool exposure_arithmetic_mean_2, FixedArray<float, 22>  * _s_dOut_4)
{
    VignettingChannelParams_0 _S1605 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S1606 = {
        _S1605, _S1605, _S1605
    };
    float2  _S1607 = make_float2 (0.0f);
    ColorPPISPParams_0 _S1608 = { _S1607, _S1607, _S1607, _S1607 };
    CRFPPISPChannelParams_0 _S1609 = { 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<CRFPPISPChannelParams_0, 3>  _S1610 = {
        _S1609, _S1609, _S1609
    };
    PPISPParams_0 _S1611;
    (&_S1611)->exposure_3 = dpparams_4->primal_0[int(0)];
    (&_S1611)->vignette_params_2 = _S1606;
    (&_S1611)->color_params_3 = _S1608;
    (&_S1611)->crf_params_1 = _S1610;
    (&(&_S1611)->vignette_params_2[int(0)])->cx_0 = dpparams_4->primal_0[int(1)];
    (&(&_S1611)->vignette_params_2[int(0)])->cy_0 = dpparams_4->primal_0[int(2)];
    (&(&_S1611)->vignette_params_2[int(0)])->alpha0_0 = dpparams_4->primal_0[int(3)];
    (&(&_S1611)->vignette_params_2[int(0)])->alpha1_0 = dpparams_4->primal_0[int(4)];
    (&(&_S1611)->vignette_params_2[int(0)])->alpha2_0 = dpparams_4->primal_0[int(5)];
    (&(&_S1611)->vignette_params_2[int(1)])->cx_0 = dpparams_4->primal_0[int(6)];
    (&(&_S1611)->vignette_params_2[int(1)])->cy_0 = dpparams_4->primal_0[int(7)];
    (&(&_S1611)->vignette_params_2[int(1)])->alpha0_0 = dpparams_4->primal_0[int(8)];
    (&(&_S1611)->vignette_params_2[int(1)])->alpha1_0 = dpparams_4->primal_0[int(9)];
    (&(&_S1611)->vignette_params_2[int(1)])->alpha2_0 = dpparams_4->primal_0[int(10)];
    (&(&_S1611)->vignette_params_2[int(2)])->cx_0 = dpparams_4->primal_0[int(11)];
    (&(&_S1611)->vignette_params_2[int(2)])->cy_0 = dpparams_4->primal_0[int(12)];
    (&(&_S1611)->vignette_params_2[int(2)])->alpha0_0 = dpparams_4->primal_0[int(13)];
    (&(&_S1611)->vignette_params_2[int(2)])->alpha1_0 = dpparams_4->primal_0[int(14)];
    (&(&_S1611)->vignette_params_2[int(2)])->alpha2_0 = dpparams_4->primal_0[int(15)];
    *&((&(&(&_S1611)->color_params_3)->b_0)->x) = dpparams_4->primal_0[int(16)];
    *&((&(&(&_S1611)->color_params_3)->b_0)->y) = dpparams_4->primal_0[int(17)];
    *&((&(&(&_S1611)->color_params_3)->r_0)->x) = dpparams_4->primal_0[int(18)];
    *&((&(&(&_S1611)->color_params_3)->r_0)->y) = dpparams_4->primal_0[int(19)];
    *&((&(&(&_S1611)->color_params_3)->g_0)->x) = dpparams_4->primal_0[int(20)];
    *&((&(&(&_S1611)->color_params_3)->g_0)->y) = dpparams_4->primal_0[int(21)];
    *&((&(&(&_S1611)->color_params_3)->n_0)->x) = dpparams_4->primal_0[int(22)];
    *&((&(&(&_S1611)->color_params_3)->n_0)->y) = dpparams_4->primal_0[int(23)];
    (&(&_S1611)->crf_params_1[int(0)])->toe_0 = dpparams_4->primal_0[int(24)];
    (&(&_S1611)->crf_params_1[int(0)])->shoulder_0 = dpparams_4->primal_0[int(25)];
    (&(&_S1611)->crf_params_1[int(0)])->gamma_0 = dpparams_4->primal_0[int(26)];
    (&(&_S1611)->crf_params_1[int(0)])->center_0 = dpparams_4->primal_0[int(27)];
    (&(&_S1611)->crf_params_1[int(1)])->toe_0 = dpparams_4->primal_0[int(28)];
    (&(&_S1611)->crf_params_1[int(1)])->shoulder_0 = dpparams_4->primal_0[int(29)];
    (&(&_S1611)->crf_params_1[int(1)])->gamma_0 = dpparams_4->primal_0[int(30)];
    (&(&_S1611)->crf_params_1[int(1)])->center_0 = dpparams_4->primal_0[int(31)];
    (&(&_S1611)->crf_params_1[int(2)])->toe_0 = dpparams_4->primal_0[int(32)];
    (&(&_S1611)->crf_params_1[int(2)])->shoulder_0 = dpparams_4->primal_0[int(33)];
    (&(&_S1611)->crf_params_1[int(2)])->gamma_0 = dpparams_4->primal_0[int(34)];
    (&(&_S1611)->crf_params_1[int(2)])->center_0 = dpparams_4->primal_0[int(35)];
    PPISPParams_0 _S1612 = _S1611;
    bool _S1613 = !exposure_arithmetic_mean_2;
    float mean_19 = (dpparams_4->primal_0[int(1)] + dpparams_4->primal_0[int(6)] + dpparams_4->primal_0[int(11)]) / 3.0f;
    float _S1614 = dpparams_4->primal_0[int(1)] - mean_19;
    float _S1615 = dpparams_4->primal_0[int(6)] - mean_19;
    float _S1616 = dpparams_4->primal_0[int(11)] - mean_19;
    float mean_20 = (dpparams_4->primal_0[int(2)] + dpparams_4->primal_0[int(7)] + dpparams_4->primal_0[int(12)]) / 3.0f;
    float _S1617 = dpparams_4->primal_0[int(2)] - mean_20;
    float _S1618 = dpparams_4->primal_0[int(7)] - mean_20;
    float _S1619 = dpparams_4->primal_0[int(12)] - mean_20;
    float mean_21 = (dpparams_4->primal_0[int(3)] + dpparams_4->primal_0[int(8)] + dpparams_4->primal_0[int(13)]) / 3.0f;
    float _S1620 = dpparams_4->primal_0[int(3)] - mean_21;
    float _S1621 = dpparams_4->primal_0[int(8)] - mean_21;
    float _S1622 = dpparams_4->primal_0[int(13)] - mean_21;
    float mean_22 = (dpparams_4->primal_0[int(4)] + dpparams_4->primal_0[int(9)] + dpparams_4->primal_0[int(14)]) / 3.0f;
    float _S1623 = dpparams_4->primal_0[int(4)] - mean_22;
    float _S1624 = dpparams_4->primal_0[int(9)] - mean_22;
    float _S1625 = dpparams_4->primal_0[int(14)] - mean_22;
    float mean_23 = (dpparams_4->primal_0[int(5)] + dpparams_4->primal_0[int(10)] + dpparams_4->primal_0[int(15)]) / 3.0f;
    float _S1626 = dpparams_4->primal_0[int(5)] - mean_23;
    float _S1627 = dpparams_4->primal_0[int(10)] - mean_23;
    float _S1628 = dpparams_4->primal_0[int(15)] - mean_23;
    float mean_24 = (dpparams_4->primal_0[int(24)] + dpparams_4->primal_0[int(28)] + dpparams_4->primal_0[int(32)]) / 3.0f;
    float mean_25 = (dpparams_4->primal_0[int(25)] + dpparams_4->primal_0[int(29)] + dpparams_4->primal_0[int(33)]) / 3.0f;
    float mean_26 = (dpparams_4->primal_0[int(26)] + dpparams_4->primal_0[int(30)] + dpparams_4->primal_0[int(34)]) / 3.0f;
    float mean_27 = (dpparams_4->primal_0[int(27)] + dpparams_4->primal_0[int(31)] + dpparams_4->primal_0[int(35)]) / 3.0f;
    PPISPParams_0 _S1629 = PPISPParams_x24_syn_dzero_0();
    float _S1630 = (*_s_dOut_4)[int(0)];
    float _S1631 = 0.3333333432674408f * (*_s_dOut_4)[int(21)];
    float _S1632 = (dpparams_4->primal_0[int(35)] - mean_27) * _S1631;
    float _S1633 = _S1632 + _S1632;
    float _S1634 = (dpparams_4->primal_0[int(31)] - mean_27) * _S1631;
    float _S1635 = _S1634 + _S1634;
    float _S1636 = (dpparams_4->primal_0[int(27)] - mean_27) * _S1631;
    float _S1637 = _S1636 + _S1636;
    float _S1638 = 0.3333333432674408f * (- _S1633 + - _S1635 + - _S1637);
    float _S1639 = 0.3333333432674408f * (*_s_dOut_4)[int(20)];
    float _S1640 = (dpparams_4->primal_0[int(34)] - mean_26) * _S1639;
    float _S1641 = _S1640 + _S1640;
    float _S1642 = (dpparams_4->primal_0[int(30)] - mean_26) * _S1639;
    float _S1643 = _S1642 + _S1642;
    float _S1644 = (dpparams_4->primal_0[int(26)] - mean_26) * _S1639;
    float _S1645 = _S1644 + _S1644;
    float _S1646 = 0.3333333432674408f * (- _S1641 + - _S1643 + - _S1645);
    float _S1647 = 0.3333333432674408f * (*_s_dOut_4)[int(19)];
    float _S1648 = (dpparams_4->primal_0[int(33)] - mean_25) * _S1647;
    float _S1649 = _S1648 + _S1648;
    float _S1650 = (dpparams_4->primal_0[int(29)] - mean_25) * _S1647;
    float _S1651 = _S1650 + _S1650;
    float _S1652 = (dpparams_4->primal_0[int(25)] - mean_25) * _S1647;
    float _S1653 = _S1652 + _S1652;
    float _S1654 = 0.3333333432674408f * (- _S1649 + - _S1651 + - _S1653);
    float _S1655 = 0.3333333432674408f * (*_s_dOut_4)[int(18)];
    float _S1656 = (dpparams_4->primal_0[int(32)] - mean_24) * _S1655;
    float _S1657 = _S1656 + _S1656;
    float _S1658 = (dpparams_4->primal_0[int(28)] - mean_24) * _S1655;
    float _S1659 = _S1658 + _S1658;
    float _S1660 = (dpparams_4->primal_0[int(24)] - mean_24) * _S1655;
    float _S1661 = _S1660 + _S1660;
    float _S1662 = 0.3333333432674408f * (- _S1657 + - _S1659 + - _S1661);
    float2  _S1663 = make_float2 ((*_s_dOut_4)[int(16)], (*_s_dOut_4)[int(17)]);
    Matrix<float, 2, 2>  _S1664 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1665;
    (&_S1665)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S1665)->differential_0 = _S1664;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1666;
    (&_S1666)->primal_0 = _S1611.color_params_3.n_0;
    (&_S1666)->differential_0 = _S1607;
    s_bwd_prop_mul_2(&_S1665, &_S1666, _S1663);
    float2  _S1667 = make_float2 ((*_s_dOut_4)[int(14)], (*_s_dOut_4)[int(15)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1668;
    (&_S1668)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S1668)->differential_0 = _S1664;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1669;
    (&_S1669)->primal_0 = _S1611.color_params_3.g_0;
    (&_S1669)->differential_0 = _S1607;
    s_bwd_prop_mul_2(&_S1668, &_S1669, _S1667);
    float2  _S1670 = make_float2 ((*_s_dOut_4)[int(12)], (*_s_dOut_4)[int(13)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1671;
    (&_S1671)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S1671)->differential_0 = _S1664;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1672;
    (&_S1672)->primal_0 = _S1611.color_params_3.r_0;
    (&_S1672)->differential_0 = _S1607;
    s_bwd_prop_mul_2(&_S1671, &_S1672, _S1670);
    float2  _S1673 = make_float2 ((*_s_dOut_4)[int(10)], (*_s_dOut_4)[int(11)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1674;
    (&_S1674)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S1674)->differential_0 = _S1664;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1675;
    (&_S1675)->primal_0 = _S1611.color_params_3.b_0;
    (&_S1675)->differential_0 = _S1607;
    s_bwd_prop_mul_2(&_S1674, &_S1675, _S1673);
    ColorPPISPParams_0 _S1676 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S1676)->n_0 = _S1666.differential_0;
    (&_S1676)->g_0 = _S1669.differential_0;
    (&_S1676)->r_0 = _S1672.differential_0;
    (&_S1676)->b_0 = _S1675.differential_0;
    float _S1677 = 0.3333333432674408f * (*_s_dOut_4)[int(9)];
    float _S1678 = _S1628 * _S1677;
    float _S1679 = _S1678 + _S1678;
    float _S1680 = _S1627 * _S1677;
    float _S1681 = _S1680 + _S1680;
    float _S1682 = _S1626 * _S1677;
    float _S1683 = _S1682 + _S1682;
    float _S1684 = 0.3333333432674408f * (- _S1679 + - _S1681 + - _S1683);
    float _S1685 = 0.3333333432674408f * (*_s_dOut_4)[int(8)];
    float _S1686 = _S1625 * _S1685;
    float _S1687 = _S1686 + _S1686;
    float _S1688 = _S1624 * _S1685;
    float _S1689 = _S1688 + _S1688;
    float _S1690 = _S1623 * _S1685;
    float _S1691 = _S1690 + _S1690;
    float _S1692 = 0.3333333432674408f * (- _S1687 + - _S1689 + - _S1691);
    float _S1693 = 0.3333333432674408f * (*_s_dOut_4)[int(7)];
    float _S1694 = _S1622 * _S1693;
    float _S1695 = _S1694 + _S1694;
    float _S1696 = _S1621 * _S1693;
    float _S1697 = _S1696 + _S1696;
    float _S1698 = _S1620 * _S1693;
    float _S1699 = _S1698 + _S1698;
    float _S1700 = 0.3333333432674408f * (- _S1695 + - _S1697 + - _S1699);
    float _S1701 = 0.3333333432674408f * (*_s_dOut_4)[int(6)];
    float _S1702 = _S1619 * _S1701;
    float _S1703 = _S1702 + _S1702;
    float _S1704 = _S1618 * _S1701;
    float _S1705 = _S1704 + _S1704;
    float _S1706 = _S1617 * _S1701;
    float _S1707 = _S1706 + _S1706;
    float _S1708 = 0.3333333432674408f * (- _S1703 + - _S1705 + - _S1707);
    float _S1709 = 0.3333333432674408f * (*_s_dOut_4)[int(5)];
    float _S1710 = _S1616 * _S1709;
    float _S1711 = _S1710 + _S1710;
    float _S1712 = _S1615 * _S1709;
    float _S1713 = _S1712 + _S1712;
    float _S1714 = _S1614 * _S1709;
    float _S1715 = _S1714 + _S1714;
    float _S1716 = 0.3333333432674408f * (- _S1711 + - _S1713 + - _S1715);
    DiffPair_float_0 _S1717;
    (&_S1717)->primal_0 = 0.0f;
    (&_S1717)->differential_0 = 0.0f;
    DiffPair_float_0 _S1718;
    (&_S1718)->primal_0 = dpparams_4->primal_0[int(15)];
    (&_S1718)->differential_0 = 0.0f;
    _d_max_0(&_S1717, &_S1718, (*_s_dOut_4)[int(4)]);
    DiffPair_float_0 _S1719;
    (&_S1719)->primal_0 = 0.0f;
    (&_S1719)->differential_0 = 0.0f;
    DiffPair_float_0 _S1720;
    (&_S1720)->primal_0 = dpparams_4->primal_0[int(10)];
    (&_S1720)->differential_0 = 0.0f;
    _d_max_0(&_S1719, &_S1720, (*_s_dOut_4)[int(4)]);
    DiffPair_float_0 _S1721;
    (&_S1721)->primal_0 = 0.0f;
    (&_S1721)->differential_0 = 0.0f;
    DiffPair_float_0 _S1722;
    (&_S1722)->primal_0 = dpparams_4->primal_0[int(5)];
    (&_S1722)->differential_0 = 0.0f;
    _d_max_0(&_S1721, &_S1722, (*_s_dOut_4)[int(4)]);
    DiffPair_float_0 _S1723;
    (&_S1723)->primal_0 = 0.0f;
    (&_S1723)->differential_0 = 0.0f;
    DiffPair_float_0 _S1724;
    (&_S1724)->primal_0 = dpparams_4->primal_0[int(14)];
    (&_S1724)->differential_0 = 0.0f;
    _d_max_0(&_S1723, &_S1724, (*_s_dOut_4)[int(3)]);
    DiffPair_float_0 _S1725;
    (&_S1725)->primal_0 = 0.0f;
    (&_S1725)->differential_0 = 0.0f;
    DiffPair_float_0 _S1726;
    (&_S1726)->primal_0 = dpparams_4->primal_0[int(9)];
    (&_S1726)->differential_0 = 0.0f;
    _d_max_0(&_S1725, &_S1726, (*_s_dOut_4)[int(3)]);
    DiffPair_float_0 _S1727;
    (&_S1727)->primal_0 = 0.0f;
    (&_S1727)->differential_0 = 0.0f;
    DiffPair_float_0 _S1728;
    (&_S1728)->primal_0 = dpparams_4->primal_0[int(4)];
    (&_S1728)->differential_0 = 0.0f;
    _d_max_0(&_S1727, &_S1728, (*_s_dOut_4)[int(3)]);
    DiffPair_float_0 _S1729;
    (&_S1729)->primal_0 = 0.0f;
    (&_S1729)->differential_0 = 0.0f;
    DiffPair_float_0 _S1730;
    (&_S1730)->primal_0 = dpparams_4->primal_0[int(13)];
    (&_S1730)->differential_0 = 0.0f;
    _d_max_0(&_S1729, &_S1730, (*_s_dOut_4)[int(2)]);
    DiffPair_float_0 _S1731;
    (&_S1731)->primal_0 = 0.0f;
    (&_S1731)->differential_0 = 0.0f;
    DiffPair_float_0 _S1732;
    (&_S1732)->primal_0 = dpparams_4->primal_0[int(8)];
    (&_S1732)->differential_0 = 0.0f;
    _d_max_0(&_S1731, &_S1732, (*_s_dOut_4)[int(2)]);
    DiffPair_float_0 _S1733;
    (&_S1733)->primal_0 = 0.0f;
    (&_S1733)->differential_0 = 0.0f;
    DiffPair_float_0 _S1734;
    (&_S1734)->primal_0 = dpparams_4->primal_0[int(3)];
    (&_S1734)->differential_0 = 0.0f;
    _d_max_0(&_S1733, &_S1734, (*_s_dOut_4)[int(2)]);
    float _S1735 = dpparams_4->primal_0[int(12)] * (*_s_dOut_4)[int(1)];
    float _S1736 = dpparams_4->primal_0[int(11)] * (*_s_dOut_4)[int(1)];
    float _S1737 = dpparams_4->primal_0[int(7)] * (*_s_dOut_4)[int(1)];
    float _S1738 = dpparams_4->primal_0[int(6)] * (*_s_dOut_4)[int(1)];
    float _S1739 = dpparams_4->primal_0[int(2)] * (*_s_dOut_4)[int(1)];
    float _S1740 = dpparams_4->primal_0[int(1)] * (*_s_dOut_4)[int(1)];
    float _S1741 = _S1703 + _S1708 + _S1735 + _S1735;
    float _S1742 = _S1715 + _S1716 + _S1740 + _S1740;
    float _S1743 = _S1711 + _S1716 + _S1736 + _S1736;
    float _S1744 = _S1713 + _S1716 + _S1738 + _S1738;
    float _S1745 = _S1705 + _S1708 + _S1737 + _S1737;
    float _S1746 = _S1697 + _S1700 + _S1732.differential_0;
    float _S1747 = _S1689 + _S1692 + _S1726.differential_0;
    float _S1748 = _S1681 + _S1684 + _S1720.differential_0;
    PPISPParams_0 _S1749 = _S1629;
    (&_S1749)->color_params_3 = _S1676;
    PPISPParams_0 _S1750 = _S1629;
    PPISPParams_0 _S1751 = _S1749;
    PPISPParams_0 _S1752 = PPISPParams_x24_syn_dadd_0(&_S1750, &_S1751);
    float _S1753 = _S1645 + _S1646;
    float _S1754 = _S1649 + _S1654;
    float _S1755 = _S1641 + _S1646;
    float _S1756 = _S1661 + _S1662;
    float _S1757 = _S1633 + _S1638;
    float _S1758 = _S1657 + _S1662;
    float _S1759 = _S1653 + _S1654;
    float _S1760 = _S1659 + _S1662;
    float _S1761 = _S1651 + _S1654;
    float _S1762 = _S1643 + _S1646;
    float _S1763 = _S1635 + _S1638;
    float _S1764 = _S1637 + _S1638;
    float _S1765 = _S1683 + _S1684 + _S1722.differential_0;
    float _S1766 = _S1679 + _S1684 + _S1718.differential_0;
    float _S1767 = _S1691 + _S1692 + _S1728.differential_0;
    float _S1768 = _S1687 + _S1692 + _S1724.differential_0;
    float _S1769 = _S1699 + _S1700 + _S1734.differential_0;
    float _S1770 = _S1695 + _S1700 + _S1730.differential_0;
    float _S1771 = _S1707 + _S1708 + _S1739 + _S1739;
    float _S1772;
    float _S1773;
    if(_S1613)
    {
        _S1772 = 0.0f;
        _S1773 = _S1630;
    }
    else
    {
        _S1772 = _S1630;
        _S1773 = 0.0f;
    }
    if(exposure_arithmetic_mean_2)
    {
        DiffPair_float_0 _S1774;
        (&_S1774)->primal_0 = _S1612.exposure_3;
        (&_S1774)->differential_0 = 0.0f;
        s_bwd_prop_exp2_0(&_S1774, _S1772);
        _S1772 = _S1774.differential_0 + _S1773;
    }
    else
    {
        _S1772 = _S1773;
    }
    PPISPParams_0 _S1775 = _S1629;
    (&_S1775)->exposure_3 = _S1772;
    PPISPParams_0 _S1776 = _S1752;
    PPISPParams_0 _S1777 = _S1775;
    PPISPParams_0 _S1778 = PPISPParams_x24_syn_dadd_0(&_S1776, &_S1777);
    _S1611 = _S1778;
    (&(&_S1611)->crf_params_1[int(2)])->center_0 = 0.0f;
    float _S1779 = _S1778.crf_params_1[int(2)].center_0 + _S1757;
    (&(&_S1611)->crf_params_1[int(2)])->gamma_0 = 0.0f;
    float _S1780 = _S1778.crf_params_1[int(2)].gamma_0 + _S1755;
    (&(&_S1611)->crf_params_1[int(2)])->shoulder_0 = 0.0f;
    float _S1781 = _S1778.crf_params_1[int(2)].shoulder_0 + _S1754;
    (&(&_S1611)->crf_params_1[int(2)])->toe_0 = 0.0f;
    float _S1782 = _S1778.crf_params_1[int(2)].toe_0 + _S1758;
    (&(&_S1611)->crf_params_1[int(1)])->center_0 = 0.0f;
    float _S1783 = _S1778.crf_params_1[int(1)].center_0 + _S1763;
    (&(&_S1611)->crf_params_1[int(1)])->gamma_0 = 0.0f;
    float _S1784 = _S1778.crf_params_1[int(1)].gamma_0 + _S1762;
    (&(&_S1611)->crf_params_1[int(1)])->shoulder_0 = 0.0f;
    float _S1785 = _S1778.crf_params_1[int(1)].shoulder_0 + _S1761;
    (&(&_S1611)->crf_params_1[int(1)])->toe_0 = 0.0f;
    float _S1786 = _S1778.crf_params_1[int(1)].toe_0 + _S1760;
    (&(&_S1611)->crf_params_1[int(0)])->center_0 = 0.0f;
    float _S1787 = _S1778.crf_params_1[int(0)].center_0 + _S1764;
    (&(&_S1611)->crf_params_1[int(0)])->gamma_0 = 0.0f;
    float _S1788 = _S1778.crf_params_1[int(0)].gamma_0 + _S1753;
    (&(&_S1611)->crf_params_1[int(0)])->shoulder_0 = 0.0f;
    float _S1789 = _S1778.crf_params_1[int(0)].shoulder_0 + _S1759;
    (&(&_S1611)->crf_params_1[int(0)])->toe_0 = 0.0f;
    float _S1790 = _S1778.crf_params_1[int(0)].toe_0 + _S1756;
    *&((&(&(&_S1611)->color_params_3)->n_0)->y) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->n_0)->x) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->g_0)->y) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->g_0)->x) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->r_0)->y) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->r_0)->x) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->b_0)->y) = 0.0f;
    *&((&(&(&_S1611)->color_params_3)->b_0)->x) = 0.0f;
    (&(&_S1611)->vignette_params_2[int(2)])->alpha2_0 = 0.0f;
    float _S1791 = _S1778.vignette_params_2[int(2)].alpha2_0 + _S1766;
    (&(&_S1611)->vignette_params_2[int(2)])->alpha1_0 = 0.0f;
    float _S1792 = _S1778.vignette_params_2[int(2)].alpha1_0 + _S1768;
    (&(&_S1611)->vignette_params_2[int(2)])->alpha0_0 = 0.0f;
    float _S1793 = _S1778.vignette_params_2[int(2)].alpha0_0 + _S1770;
    (&(&_S1611)->vignette_params_2[int(2)])->cy_0 = 0.0f;
    float _S1794 = _S1778.vignette_params_2[int(2)].cy_0 + _S1741;
    (&(&_S1611)->vignette_params_2[int(2)])->cx_0 = 0.0f;
    float _S1795 = _S1778.vignette_params_2[int(2)].cx_0 + _S1743;
    (&(&_S1611)->vignette_params_2[int(1)])->alpha2_0 = 0.0f;
    float _S1796 = _S1778.vignette_params_2[int(1)].alpha2_0 + _S1748;
    (&(&_S1611)->vignette_params_2[int(1)])->alpha1_0 = 0.0f;
    float _S1797 = _S1778.vignette_params_2[int(1)].alpha1_0 + _S1747;
    (&(&_S1611)->vignette_params_2[int(1)])->alpha0_0 = 0.0f;
    float _S1798 = _S1778.vignette_params_2[int(1)].alpha0_0 + _S1746;
    (&(&_S1611)->vignette_params_2[int(1)])->cy_0 = 0.0f;
    float _S1799 = _S1778.vignette_params_2[int(1)].cy_0 + _S1745;
    (&(&_S1611)->vignette_params_2[int(1)])->cx_0 = 0.0f;
    float _S1800 = _S1778.vignette_params_2[int(1)].cx_0 + _S1744;
    (&(&_S1611)->vignette_params_2[int(0)])->alpha2_0 = 0.0f;
    float _S1801 = _S1778.vignette_params_2[int(0)].alpha2_0 + _S1765;
    (&(&_S1611)->vignette_params_2[int(0)])->alpha1_0 = 0.0f;
    float _S1802 = _S1778.vignette_params_2[int(0)].alpha1_0 + _S1767;
    (&(&_S1611)->vignette_params_2[int(0)])->alpha0_0 = 0.0f;
    float _S1803 = _S1778.vignette_params_2[int(0)].alpha0_0 + _S1769;
    (&(&_S1611)->vignette_params_2[int(0)])->cy_0 = 0.0f;
    float _S1804 = _S1778.vignette_params_2[int(0)].cy_0 + _S1771;
    (&(&_S1611)->vignette_params_2[int(0)])->cx_0 = 0.0f;
    float _S1805 = _S1778.vignette_params_2[int(0)].cx_0 + _S1742;
    FixedArray<float, 36>  _S1806;
    _S1806[int(0)] = 0.0f;
    _S1806[int(1)] = 0.0f;
    _S1806[int(2)] = 0.0f;
    _S1806[int(3)] = 0.0f;
    _S1806[int(4)] = 0.0f;
    _S1806[int(5)] = 0.0f;
    _S1806[int(6)] = 0.0f;
    _S1806[int(7)] = 0.0f;
    _S1806[int(8)] = 0.0f;
    _S1806[int(9)] = 0.0f;
    _S1806[int(10)] = 0.0f;
    _S1806[int(11)] = 0.0f;
    _S1806[int(12)] = 0.0f;
    _S1806[int(13)] = 0.0f;
    _S1806[int(14)] = 0.0f;
    _S1806[int(15)] = 0.0f;
    _S1806[int(16)] = 0.0f;
    _S1806[int(17)] = 0.0f;
    _S1806[int(18)] = 0.0f;
    _S1806[int(19)] = 0.0f;
    _S1806[int(20)] = 0.0f;
    _S1806[int(21)] = 0.0f;
    _S1806[int(22)] = 0.0f;
    _S1806[int(23)] = 0.0f;
    _S1806[int(24)] = 0.0f;
    _S1806[int(25)] = 0.0f;
    _S1806[int(26)] = 0.0f;
    _S1806[int(27)] = 0.0f;
    _S1806[int(28)] = 0.0f;
    _S1806[int(29)] = 0.0f;
    _S1806[int(30)] = 0.0f;
    _S1806[int(31)] = 0.0f;
    _S1806[int(32)] = 0.0f;
    _S1806[int(33)] = 0.0f;
    _S1806[int(34)] = 0.0f;
    _S1806[int(35)] = 0.0f;
    _S1806[int(8)] = _S1798;
    _S1806[int(16)] = _S1778.color_params_3.b_0.x;
    _S1806[int(15)] = _S1791;
    _S1806[int(14)] = _S1792;
    _S1806[int(13)] = _S1793;
    _S1806[int(12)] = _S1794;
    _S1806[int(11)] = _S1795;
    _S1806[int(10)] = _S1796;
    _S1806[int(9)] = _S1797;
    _S1806[int(17)] = _S1778.color_params_3.b_0.y;
    _S1806[int(7)] = _S1799;
    _S1806[int(6)] = _S1800;
    _S1806[int(5)] = _S1801;
    _S1806[int(4)] = _S1802;
    _S1806[int(3)] = _S1803;
    _S1806[int(2)] = _S1804;
    _S1806[int(1)] = _S1805;
    _S1806[int(0)] = _S1611.exposure_3;
    _S1806[int(26)] = _S1788;
    _S1806[int(34)] = _S1780;
    _S1806[int(33)] = _S1781;
    _S1806[int(32)] = _S1782;
    _S1806[int(31)] = _S1783;
    _S1806[int(30)] = _S1784;
    _S1806[int(29)] = _S1785;
    _S1806[int(28)] = _S1786;
    _S1806[int(27)] = _S1787;
    _S1806[int(35)] = _S1779;
    _S1806[int(25)] = _S1789;
    _S1806[int(24)] = _S1790;
    _S1806[int(23)] = _S1778.color_params_3.n_0.y;
    _S1806[int(22)] = _S1778.color_params_3.n_0.x;
    _S1806[int(21)] = _S1778.color_params_3.g_0.y;
    _S1806[int(20)] = _S1778.color_params_3.g_0.x;
    _S1806[int(19)] = _S1778.color_params_3.r_0.y;
    _S1806[int(18)] = _S1778.color_params_3.r_0.x;
    dpparams_4->primal_0 = dpparams_4->primal_0;
    dpparams_4->differential_0 = _S1806;
    return;
}

inline __device__ void s_bwd_compute_raw_ppisp_regularization_loss_0(DiffPair_arrayx3Cfloatx2C36x3E_0 * _S1807, bool _S1808, FixedArray<float, 22>  * _S1809)
{
    s_bwd_prop_compute_raw_ppisp_regularization_loss_0(_S1807, _S1808, _S1809);
    return;
}

inline __device__ void compute_raw_ppisp_regularization_loss_vjp(FixedArray<float, 36>  params_10, bool exposure_arithmetic_mean_3, FixedArray<float, 22>  grad_out_4, FixedArray<float, 36>  * _S1810)
{
    FixedArray<float, 36>  _S1811 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C36x3E_0 dp_params_4;
    (&dp_params_4)->primal_0 = params_10;
    (&dp_params_4)->differential_0 = _S1811;
    FixedArray<float, 22>  _S1812 = grad_out_4;
    s_bwd_compute_raw_ppisp_regularization_loss_0(&dp_params_4, exposure_arithmetic_mean_3, &_S1812);
    *_S1810 = (&dp_params_4)->differential_0;
    return;
}

inline __device__ void s_bwd_prop_compute_raw_ppisp_rqs_regularization_loss_0(DiffPair_arrayx3Cfloatx2C39x3E_0 * dpparams_5, bool exposure_arithmetic_mean_4, FixedArray<float, 23>  * _s_dOut_5)
{
    VignettingChannelParams_0 _S1813 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S1814 = {
        _S1813, _S1813, _S1813
    };
    float2  _S1815 = make_float2 (0.0f);
    ColorPPISPParams_0 _S1816 = { _S1815, _S1815, _S1815, _S1815 };
    RQSCRFPPISPChannelParams_0 _S1817 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<RQSCRFPPISPChannelParams_0, 3>  _S1818 = {
        _S1817, _S1817, _S1817
    };
    PPISPParamsRQS_0 _S1819;
    (&_S1819)->exposure_2 = dpparams_5->primal_0[int(0)];
    (&_S1819)->vignette_params_1 = _S1814;
    (&_S1819)->color_params_2 = _S1816;
    (&_S1819)->crf_params_0 = _S1818;
    (&(&_S1819)->vignette_params_1[int(0)])->cx_0 = dpparams_5->primal_0[int(1)];
    (&(&_S1819)->vignette_params_1[int(0)])->cy_0 = dpparams_5->primal_0[int(2)];
    (&(&_S1819)->vignette_params_1[int(0)])->alpha0_0 = dpparams_5->primal_0[int(3)];
    (&(&_S1819)->vignette_params_1[int(0)])->alpha1_0 = dpparams_5->primal_0[int(4)];
    (&(&_S1819)->vignette_params_1[int(0)])->alpha2_0 = dpparams_5->primal_0[int(5)];
    (&(&_S1819)->vignette_params_1[int(1)])->cx_0 = dpparams_5->primal_0[int(6)];
    (&(&_S1819)->vignette_params_1[int(1)])->cy_0 = dpparams_5->primal_0[int(7)];
    (&(&_S1819)->vignette_params_1[int(1)])->alpha0_0 = dpparams_5->primal_0[int(8)];
    (&(&_S1819)->vignette_params_1[int(1)])->alpha1_0 = dpparams_5->primal_0[int(9)];
    (&(&_S1819)->vignette_params_1[int(1)])->alpha2_0 = dpparams_5->primal_0[int(10)];
    (&(&_S1819)->vignette_params_1[int(2)])->cx_0 = dpparams_5->primal_0[int(11)];
    (&(&_S1819)->vignette_params_1[int(2)])->cy_0 = dpparams_5->primal_0[int(12)];
    (&(&_S1819)->vignette_params_1[int(2)])->alpha0_0 = dpparams_5->primal_0[int(13)];
    (&(&_S1819)->vignette_params_1[int(2)])->alpha1_0 = dpparams_5->primal_0[int(14)];
    (&(&_S1819)->vignette_params_1[int(2)])->alpha2_0 = dpparams_5->primal_0[int(15)];
    *&((&(&(&_S1819)->color_params_2)->b_0)->x) = dpparams_5->primal_0[int(16)];
    *&((&(&(&_S1819)->color_params_2)->b_0)->y) = dpparams_5->primal_0[int(17)];
    *&((&(&(&_S1819)->color_params_2)->r_0)->x) = dpparams_5->primal_0[int(18)];
    *&((&(&(&_S1819)->color_params_2)->r_0)->y) = dpparams_5->primal_0[int(19)];
    *&((&(&(&_S1819)->color_params_2)->g_0)->x) = dpparams_5->primal_0[int(20)];
    *&((&(&(&_S1819)->color_params_2)->g_0)->y) = dpparams_5->primal_0[int(21)];
    *&((&(&(&_S1819)->color_params_2)->n_0)->x) = dpparams_5->primal_0[int(22)];
    *&((&(&(&_S1819)->color_params_2)->n_0)->y) = dpparams_5->primal_0[int(23)];
    (&(&_S1819)->crf_params_0[int(0)])->g0_0 = dpparams_5->primal_0[int(24)];
    (&(&_S1819)->crf_params_0[int(0)])->g1_0 = dpparams_5->primal_0[int(25)];
    (&(&_S1819)->crf_params_0[int(0)])->x0_0 = dpparams_5->primal_0[int(26)];
    (&(&_S1819)->crf_params_0[int(0)])->y0_0 = dpparams_5->primal_0[int(27)];
    (&(&_S1819)->crf_params_0[int(0)])->gc_0 = dpparams_5->primal_0[int(28)];
    (&(&_S1819)->crf_params_0[int(1)])->g0_0 = dpparams_5->primal_0[int(29)];
    (&(&_S1819)->crf_params_0[int(1)])->g1_0 = dpparams_5->primal_0[int(30)];
    (&(&_S1819)->crf_params_0[int(1)])->x0_0 = dpparams_5->primal_0[int(31)];
    (&(&_S1819)->crf_params_0[int(1)])->y0_0 = dpparams_5->primal_0[int(32)];
    (&(&_S1819)->crf_params_0[int(1)])->gc_0 = dpparams_5->primal_0[int(33)];
    (&(&_S1819)->crf_params_0[int(2)])->g0_0 = dpparams_5->primal_0[int(34)];
    (&(&_S1819)->crf_params_0[int(2)])->g1_0 = dpparams_5->primal_0[int(35)];
    (&(&_S1819)->crf_params_0[int(2)])->x0_0 = dpparams_5->primal_0[int(36)];
    (&(&_S1819)->crf_params_0[int(2)])->y0_0 = dpparams_5->primal_0[int(37)];
    (&(&_S1819)->crf_params_0[int(2)])->gc_0 = dpparams_5->primal_0[int(38)];
    PPISPParamsRQS_0 _S1820 = _S1819;
    bool _S1821 = !exposure_arithmetic_mean_4;
    float mean_28 = (dpparams_5->primal_0[int(1)] + dpparams_5->primal_0[int(6)] + dpparams_5->primal_0[int(11)]) / 3.0f;
    float _S1822 = dpparams_5->primal_0[int(1)] - mean_28;
    float _S1823 = dpparams_5->primal_0[int(6)] - mean_28;
    float _S1824 = dpparams_5->primal_0[int(11)] - mean_28;
    float mean_29 = (dpparams_5->primal_0[int(2)] + dpparams_5->primal_0[int(7)] + dpparams_5->primal_0[int(12)]) / 3.0f;
    float _S1825 = dpparams_5->primal_0[int(2)] - mean_29;
    float _S1826 = dpparams_5->primal_0[int(7)] - mean_29;
    float _S1827 = dpparams_5->primal_0[int(12)] - mean_29;
    float mean_30 = (dpparams_5->primal_0[int(3)] + dpparams_5->primal_0[int(8)] + dpparams_5->primal_0[int(13)]) / 3.0f;
    float _S1828 = dpparams_5->primal_0[int(3)] - mean_30;
    float _S1829 = dpparams_5->primal_0[int(8)] - mean_30;
    float _S1830 = dpparams_5->primal_0[int(13)] - mean_30;
    float mean_31 = (dpparams_5->primal_0[int(4)] + dpparams_5->primal_0[int(9)] + dpparams_5->primal_0[int(14)]) / 3.0f;
    float _S1831 = dpparams_5->primal_0[int(4)] - mean_31;
    float _S1832 = dpparams_5->primal_0[int(9)] - mean_31;
    float _S1833 = dpparams_5->primal_0[int(14)] - mean_31;
    float mean_32 = (dpparams_5->primal_0[int(5)] + dpparams_5->primal_0[int(10)] + dpparams_5->primal_0[int(15)]) / 3.0f;
    float _S1834 = dpparams_5->primal_0[int(5)] - mean_32;
    float _S1835 = dpparams_5->primal_0[int(10)] - mean_32;
    float _S1836 = dpparams_5->primal_0[int(15)] - mean_32;
    float mean_33 = (dpparams_5->primal_0[int(24)] + dpparams_5->primal_0[int(29)] + dpparams_5->primal_0[int(34)]) / 3.0f;
    float mean_34 = (dpparams_5->primal_0[int(25)] + dpparams_5->primal_0[int(30)] + dpparams_5->primal_0[int(35)]) / 3.0f;
    float mean_35 = (dpparams_5->primal_0[int(26)] + dpparams_5->primal_0[int(31)] + dpparams_5->primal_0[int(36)]) / 3.0f;
    float mean_36 = (dpparams_5->primal_0[int(27)] + dpparams_5->primal_0[int(32)] + dpparams_5->primal_0[int(37)]) / 3.0f;
    float mean_37 = (dpparams_5->primal_0[int(28)] + dpparams_5->primal_0[int(33)] + dpparams_5->primal_0[int(38)]) / 3.0f;
    PPISPParamsRQS_0 _S1837 = PPISPParamsRQS_x24_syn_dzero_0();
    float _S1838 = (*_s_dOut_5)[int(0)];
    float _S1839 = 0.3333333432674408f * (*_s_dOut_5)[int(22)];
    float _S1840 = (dpparams_5->primal_0[int(38)] - mean_37) * _S1839;
    float _S1841 = _S1840 + _S1840;
    float _S1842 = (dpparams_5->primal_0[int(33)] - mean_37) * _S1839;
    float _S1843 = _S1842 + _S1842;
    float _S1844 = (dpparams_5->primal_0[int(28)] - mean_37) * _S1839;
    float _S1845 = _S1844 + _S1844;
    float _S1846 = 0.3333333432674408f * (- _S1841 + - _S1843 + - _S1845);
    float _S1847 = 0.3333333432674408f * (*_s_dOut_5)[int(21)];
    float _S1848 = (dpparams_5->primal_0[int(37)] - mean_36) * _S1847;
    float _S1849 = _S1848 + _S1848;
    float _S1850 = (dpparams_5->primal_0[int(32)] - mean_36) * _S1847;
    float _S1851 = _S1850 + _S1850;
    float _S1852 = (dpparams_5->primal_0[int(27)] - mean_36) * _S1847;
    float _S1853 = _S1852 + _S1852;
    float _S1854 = 0.3333333432674408f * (- _S1849 + - _S1851 + - _S1853);
    float _S1855 = 0.3333333432674408f * (*_s_dOut_5)[int(20)];
    float _S1856 = (dpparams_5->primal_0[int(36)] - mean_35) * _S1855;
    float _S1857 = _S1856 + _S1856;
    float _S1858 = (dpparams_5->primal_0[int(31)] - mean_35) * _S1855;
    float _S1859 = _S1858 + _S1858;
    float _S1860 = (dpparams_5->primal_0[int(26)] - mean_35) * _S1855;
    float _S1861 = _S1860 + _S1860;
    float _S1862 = 0.3333333432674408f * (- _S1857 + - _S1859 + - _S1861);
    float _S1863 = 0.3333333432674408f * (*_s_dOut_5)[int(19)];
    float _S1864 = (dpparams_5->primal_0[int(35)] - mean_34) * _S1863;
    float _S1865 = _S1864 + _S1864;
    float _S1866 = (dpparams_5->primal_0[int(30)] - mean_34) * _S1863;
    float _S1867 = _S1866 + _S1866;
    float _S1868 = (dpparams_5->primal_0[int(25)] - mean_34) * _S1863;
    float _S1869 = _S1868 + _S1868;
    float _S1870 = 0.3333333432674408f * (- _S1865 + - _S1867 + - _S1869);
    float _S1871 = 0.3333333432674408f * (*_s_dOut_5)[int(18)];
    float _S1872 = (dpparams_5->primal_0[int(34)] - mean_33) * _S1871;
    float _S1873 = _S1872 + _S1872;
    float _S1874 = (dpparams_5->primal_0[int(29)] - mean_33) * _S1871;
    float _S1875 = _S1874 + _S1874;
    float _S1876 = (dpparams_5->primal_0[int(24)] - mean_33) * _S1871;
    float _S1877 = _S1876 + _S1876;
    float _S1878 = 0.3333333432674408f * (- _S1873 + - _S1875 + - _S1877);
    float2  _S1879 = make_float2 ((*_s_dOut_5)[int(16)], (*_s_dOut_5)[int(17)]);
    Matrix<float, 2, 2>  _S1880 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1881;
    (&_S1881)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S1881)->differential_0 = _S1880;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1882;
    (&_S1882)->primal_0 = _S1819.color_params_2.n_0;
    (&_S1882)->differential_0 = _S1815;
    s_bwd_prop_mul_2(&_S1881, &_S1882, _S1879);
    float2  _S1883 = make_float2 ((*_s_dOut_5)[int(14)], (*_s_dOut_5)[int(15)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1884;
    (&_S1884)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S1884)->differential_0 = _S1880;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1885;
    (&_S1885)->primal_0 = _S1819.color_params_2.g_0;
    (&_S1885)->differential_0 = _S1815;
    s_bwd_prop_mul_2(&_S1884, &_S1885, _S1883);
    float2  _S1886 = make_float2 ((*_s_dOut_5)[int(12)], (*_s_dOut_5)[int(13)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1887;
    (&_S1887)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S1887)->differential_0 = _S1880;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1888;
    (&_S1888)->primal_0 = _S1819.color_params_2.r_0;
    (&_S1888)->differential_0 = _S1815;
    s_bwd_prop_mul_2(&_S1887, &_S1888, _S1886);
    float2  _S1889 = make_float2 ((*_s_dOut_5)[int(10)], (*_s_dOut_5)[int(11)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S1890;
    (&_S1890)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S1890)->differential_0 = _S1880;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S1891;
    (&_S1891)->primal_0 = _S1819.color_params_2.b_0;
    (&_S1891)->differential_0 = _S1815;
    s_bwd_prop_mul_2(&_S1890, &_S1891, _S1889);
    ColorPPISPParams_0 _S1892 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S1892)->n_0 = _S1882.differential_0;
    (&_S1892)->g_0 = _S1885.differential_0;
    (&_S1892)->r_0 = _S1888.differential_0;
    (&_S1892)->b_0 = _S1891.differential_0;
    float _S1893 = 0.3333333432674408f * (*_s_dOut_5)[int(9)];
    float _S1894 = _S1836 * _S1893;
    float _S1895 = _S1894 + _S1894;
    float _S1896 = _S1835 * _S1893;
    float _S1897 = _S1896 + _S1896;
    float _S1898 = _S1834 * _S1893;
    float _S1899 = _S1898 + _S1898;
    float _S1900 = 0.3333333432674408f * (- _S1895 + - _S1897 + - _S1899);
    float _S1901 = 0.3333333432674408f * (*_s_dOut_5)[int(8)];
    float _S1902 = _S1833 * _S1901;
    float _S1903 = _S1902 + _S1902;
    float _S1904 = _S1832 * _S1901;
    float _S1905 = _S1904 + _S1904;
    float _S1906 = _S1831 * _S1901;
    float _S1907 = _S1906 + _S1906;
    float _S1908 = 0.3333333432674408f * (- _S1903 + - _S1905 + - _S1907);
    float _S1909 = 0.3333333432674408f * (*_s_dOut_5)[int(7)];
    float _S1910 = _S1830 * _S1909;
    float _S1911 = _S1910 + _S1910;
    float _S1912 = _S1829 * _S1909;
    float _S1913 = _S1912 + _S1912;
    float _S1914 = _S1828 * _S1909;
    float _S1915 = _S1914 + _S1914;
    float _S1916 = 0.3333333432674408f * (- _S1911 + - _S1913 + - _S1915);
    float _S1917 = 0.3333333432674408f * (*_s_dOut_5)[int(6)];
    float _S1918 = _S1827 * _S1917;
    float _S1919 = _S1918 + _S1918;
    float _S1920 = _S1826 * _S1917;
    float _S1921 = _S1920 + _S1920;
    float _S1922 = _S1825 * _S1917;
    float _S1923 = _S1922 + _S1922;
    float _S1924 = 0.3333333432674408f * (- _S1919 + - _S1921 + - _S1923);
    float _S1925 = 0.3333333432674408f * (*_s_dOut_5)[int(5)];
    float _S1926 = _S1824 * _S1925;
    float _S1927 = _S1926 + _S1926;
    float _S1928 = _S1823 * _S1925;
    float _S1929 = _S1928 + _S1928;
    float _S1930 = _S1822 * _S1925;
    float _S1931 = _S1930 + _S1930;
    float _S1932 = 0.3333333432674408f * (- _S1927 + - _S1929 + - _S1931);
    DiffPair_float_0 _S1933;
    (&_S1933)->primal_0 = 0.0f;
    (&_S1933)->differential_0 = 0.0f;
    DiffPair_float_0 _S1934;
    (&_S1934)->primal_0 = dpparams_5->primal_0[int(15)];
    (&_S1934)->differential_0 = 0.0f;
    _d_max_0(&_S1933, &_S1934, (*_s_dOut_5)[int(4)]);
    DiffPair_float_0 _S1935;
    (&_S1935)->primal_0 = 0.0f;
    (&_S1935)->differential_0 = 0.0f;
    DiffPair_float_0 _S1936;
    (&_S1936)->primal_0 = dpparams_5->primal_0[int(10)];
    (&_S1936)->differential_0 = 0.0f;
    _d_max_0(&_S1935, &_S1936, (*_s_dOut_5)[int(4)]);
    DiffPair_float_0 _S1937;
    (&_S1937)->primal_0 = 0.0f;
    (&_S1937)->differential_0 = 0.0f;
    DiffPair_float_0 _S1938;
    (&_S1938)->primal_0 = dpparams_5->primal_0[int(5)];
    (&_S1938)->differential_0 = 0.0f;
    _d_max_0(&_S1937, &_S1938, (*_s_dOut_5)[int(4)]);
    DiffPair_float_0 _S1939;
    (&_S1939)->primal_0 = 0.0f;
    (&_S1939)->differential_0 = 0.0f;
    DiffPair_float_0 _S1940;
    (&_S1940)->primal_0 = dpparams_5->primal_0[int(14)];
    (&_S1940)->differential_0 = 0.0f;
    _d_max_0(&_S1939, &_S1940, (*_s_dOut_5)[int(3)]);
    DiffPair_float_0 _S1941;
    (&_S1941)->primal_0 = 0.0f;
    (&_S1941)->differential_0 = 0.0f;
    DiffPair_float_0 _S1942;
    (&_S1942)->primal_0 = dpparams_5->primal_0[int(9)];
    (&_S1942)->differential_0 = 0.0f;
    _d_max_0(&_S1941, &_S1942, (*_s_dOut_5)[int(3)]);
    DiffPair_float_0 _S1943;
    (&_S1943)->primal_0 = 0.0f;
    (&_S1943)->differential_0 = 0.0f;
    DiffPair_float_0 _S1944;
    (&_S1944)->primal_0 = dpparams_5->primal_0[int(4)];
    (&_S1944)->differential_0 = 0.0f;
    _d_max_0(&_S1943, &_S1944, (*_s_dOut_5)[int(3)]);
    DiffPair_float_0 _S1945;
    (&_S1945)->primal_0 = 0.0f;
    (&_S1945)->differential_0 = 0.0f;
    DiffPair_float_0 _S1946;
    (&_S1946)->primal_0 = dpparams_5->primal_0[int(13)];
    (&_S1946)->differential_0 = 0.0f;
    _d_max_0(&_S1945, &_S1946, (*_s_dOut_5)[int(2)]);
    DiffPair_float_0 _S1947;
    (&_S1947)->primal_0 = 0.0f;
    (&_S1947)->differential_0 = 0.0f;
    DiffPair_float_0 _S1948;
    (&_S1948)->primal_0 = dpparams_5->primal_0[int(8)];
    (&_S1948)->differential_0 = 0.0f;
    _d_max_0(&_S1947, &_S1948, (*_s_dOut_5)[int(2)]);
    DiffPair_float_0 _S1949;
    (&_S1949)->primal_0 = 0.0f;
    (&_S1949)->differential_0 = 0.0f;
    DiffPair_float_0 _S1950;
    (&_S1950)->primal_0 = dpparams_5->primal_0[int(3)];
    (&_S1950)->differential_0 = 0.0f;
    _d_max_0(&_S1949, &_S1950, (*_s_dOut_5)[int(2)]);
    float _S1951 = dpparams_5->primal_0[int(12)] * (*_s_dOut_5)[int(1)];
    float _S1952 = dpparams_5->primal_0[int(11)] * (*_s_dOut_5)[int(1)];
    float _S1953 = dpparams_5->primal_0[int(7)] * (*_s_dOut_5)[int(1)];
    float _S1954 = dpparams_5->primal_0[int(6)] * (*_s_dOut_5)[int(1)];
    float _S1955 = dpparams_5->primal_0[int(2)] * (*_s_dOut_5)[int(1)];
    float _S1956 = dpparams_5->primal_0[int(1)] * (*_s_dOut_5)[int(1)];
    float _S1957 = _S1919 + _S1924 + _S1951 + _S1951;
    float _S1958 = _S1931 + _S1932 + _S1956 + _S1956;
    float _S1959 = _S1927 + _S1932 + _S1952 + _S1952;
    float _S1960 = _S1929 + _S1932 + _S1954 + _S1954;
    float _S1961 = _S1921 + _S1924 + _S1953 + _S1953;
    float _S1962 = _S1913 + _S1916 + _S1948.differential_0;
    float _S1963 = _S1905 + _S1908 + _S1942.differential_0;
    float _S1964 = _S1897 + _S1900 + _S1936.differential_0;
    PPISPParamsRQS_0 _S1965 = _S1837;
    (&_S1965)->color_params_2 = _S1892;
    PPISPParamsRQS_0 _S1966 = _S1837;
    PPISPParamsRQS_0 _S1967 = _S1965;
    PPISPParamsRQS_0 _S1968 = PPISPParamsRQS_x24_syn_dadd_0(&_S1966, &_S1967);
    float _S1969 = _S1861 + _S1862;
    float _S1970 = _S1865 + _S1870;
    float _S1971 = _S1857 + _S1862;
    float _S1972 = _S1877 + _S1878;
    float _S1973 = _S1849 + _S1854;
    float _S1974 = _S1873 + _S1878;
    float _S1975 = _S1869 + _S1870;
    float _S1976 = _S1875 + _S1878;
    float _S1977 = _S1867 + _S1870;
    float _S1978 = _S1859 + _S1862;
    float _S1979 = _S1851 + _S1854;
    float _S1980 = _S1843 + _S1846;
    float _S1981 = _S1845 + _S1846;
    float _S1982 = _S1841 + _S1846;
    float _S1983 = _S1853 + _S1854;
    float _S1984 = _S1899 + _S1900 + _S1938.differential_0;
    float _S1985 = _S1895 + _S1900 + _S1934.differential_0;
    float _S1986 = _S1907 + _S1908 + _S1944.differential_0;
    float _S1987 = _S1903 + _S1908 + _S1940.differential_0;
    float _S1988 = _S1915 + _S1916 + _S1950.differential_0;
    float _S1989 = _S1911 + _S1916 + _S1946.differential_0;
    float _S1990 = _S1923 + _S1924 + _S1955 + _S1955;
    float _S1991;
    float _S1992;
    if(_S1821)
    {
        _S1991 = 0.0f;
        _S1992 = _S1838;
    }
    else
    {
        _S1991 = _S1838;
        _S1992 = 0.0f;
    }
    if(exposure_arithmetic_mean_4)
    {
        DiffPair_float_0 _S1993;
        (&_S1993)->primal_0 = _S1820.exposure_2;
        (&_S1993)->differential_0 = 0.0f;
        s_bwd_prop_exp2_0(&_S1993, _S1991);
        _S1991 = _S1993.differential_0 + _S1992;
    }
    else
    {
        _S1991 = _S1992;
    }
    PPISPParamsRQS_0 _S1994 = _S1837;
    (&_S1994)->exposure_2 = _S1991;
    PPISPParamsRQS_0 _S1995 = _S1968;
    PPISPParamsRQS_0 _S1996 = _S1994;
    PPISPParamsRQS_0 _S1997 = PPISPParamsRQS_x24_syn_dadd_0(&_S1995, &_S1996);
    _S1819 = _S1997;
    (&(&_S1819)->crf_params_0[int(2)])->gc_0 = 0.0f;
    float _S1998 = _S1997.crf_params_0[int(2)].gc_0 + _S1982;
    (&(&_S1819)->crf_params_0[int(2)])->y0_0 = 0.0f;
    float _S1999 = _S1997.crf_params_0[int(2)].y0_0 + _S1973;
    (&(&_S1819)->crf_params_0[int(2)])->x0_0 = 0.0f;
    float _S2000 = _S1997.crf_params_0[int(2)].x0_0 + _S1971;
    (&(&_S1819)->crf_params_0[int(2)])->g1_0 = 0.0f;
    float _S2001 = _S1997.crf_params_0[int(2)].g1_0 + _S1970;
    (&(&_S1819)->crf_params_0[int(2)])->g0_0 = 0.0f;
    float _S2002 = _S1997.crf_params_0[int(2)].g0_0 + _S1974;
    (&(&_S1819)->crf_params_0[int(1)])->gc_0 = 0.0f;
    float _S2003 = _S1997.crf_params_0[int(1)].gc_0 + _S1980;
    (&(&_S1819)->crf_params_0[int(1)])->y0_0 = 0.0f;
    float _S2004 = _S1997.crf_params_0[int(1)].y0_0 + _S1979;
    (&(&_S1819)->crf_params_0[int(1)])->x0_0 = 0.0f;
    float _S2005 = _S1997.crf_params_0[int(1)].x0_0 + _S1978;
    (&(&_S1819)->crf_params_0[int(1)])->g1_0 = 0.0f;
    float _S2006 = _S1997.crf_params_0[int(1)].g1_0 + _S1977;
    (&(&_S1819)->crf_params_0[int(1)])->g0_0 = 0.0f;
    float _S2007 = _S1997.crf_params_0[int(1)].g0_0 + _S1976;
    (&(&_S1819)->crf_params_0[int(0)])->gc_0 = 0.0f;
    float _S2008 = _S1997.crf_params_0[int(0)].gc_0 + _S1981;
    (&(&_S1819)->crf_params_0[int(0)])->y0_0 = 0.0f;
    float _S2009 = _S1997.crf_params_0[int(0)].y0_0 + _S1983;
    (&(&_S1819)->crf_params_0[int(0)])->x0_0 = 0.0f;
    float _S2010 = _S1997.crf_params_0[int(0)].x0_0 + _S1969;
    (&(&_S1819)->crf_params_0[int(0)])->g1_0 = 0.0f;
    float _S2011 = _S1997.crf_params_0[int(0)].g1_0 + _S1975;
    (&(&_S1819)->crf_params_0[int(0)])->g0_0 = 0.0f;
    float _S2012 = _S1997.crf_params_0[int(0)].g0_0 + _S1972;
    *&((&(&(&_S1819)->color_params_2)->n_0)->y) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->n_0)->x) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->g_0)->y) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->g_0)->x) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->r_0)->y) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->r_0)->x) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->b_0)->y) = 0.0f;
    *&((&(&(&_S1819)->color_params_2)->b_0)->x) = 0.0f;
    (&(&_S1819)->vignette_params_1[int(2)])->alpha2_0 = 0.0f;
    float _S2013 = _S1997.vignette_params_1[int(2)].alpha2_0 + _S1985;
    (&(&_S1819)->vignette_params_1[int(2)])->alpha1_0 = 0.0f;
    float _S2014 = _S1997.vignette_params_1[int(2)].alpha1_0 + _S1987;
    (&(&_S1819)->vignette_params_1[int(2)])->alpha0_0 = 0.0f;
    float _S2015 = _S1997.vignette_params_1[int(2)].alpha0_0 + _S1989;
    (&(&_S1819)->vignette_params_1[int(2)])->cy_0 = 0.0f;
    float _S2016 = _S1997.vignette_params_1[int(2)].cy_0 + _S1957;
    (&(&_S1819)->vignette_params_1[int(2)])->cx_0 = 0.0f;
    float _S2017 = _S1997.vignette_params_1[int(2)].cx_0 + _S1959;
    (&(&_S1819)->vignette_params_1[int(1)])->alpha2_0 = 0.0f;
    float _S2018 = _S1997.vignette_params_1[int(1)].alpha2_0 + _S1964;
    (&(&_S1819)->vignette_params_1[int(1)])->alpha1_0 = 0.0f;
    float _S2019 = _S1997.vignette_params_1[int(1)].alpha1_0 + _S1963;
    (&(&_S1819)->vignette_params_1[int(1)])->alpha0_0 = 0.0f;
    float _S2020 = _S1997.vignette_params_1[int(1)].alpha0_0 + _S1962;
    (&(&_S1819)->vignette_params_1[int(1)])->cy_0 = 0.0f;
    float _S2021 = _S1997.vignette_params_1[int(1)].cy_0 + _S1961;
    (&(&_S1819)->vignette_params_1[int(1)])->cx_0 = 0.0f;
    float _S2022 = _S1997.vignette_params_1[int(1)].cx_0 + _S1960;
    (&(&_S1819)->vignette_params_1[int(0)])->alpha2_0 = 0.0f;
    float _S2023 = _S1997.vignette_params_1[int(0)].alpha2_0 + _S1984;
    (&(&_S1819)->vignette_params_1[int(0)])->alpha1_0 = 0.0f;
    float _S2024 = _S1997.vignette_params_1[int(0)].alpha1_0 + _S1986;
    (&(&_S1819)->vignette_params_1[int(0)])->alpha0_0 = 0.0f;
    float _S2025 = _S1997.vignette_params_1[int(0)].alpha0_0 + _S1988;
    (&(&_S1819)->vignette_params_1[int(0)])->cy_0 = 0.0f;
    float _S2026 = _S1997.vignette_params_1[int(0)].cy_0 + _S1990;
    (&(&_S1819)->vignette_params_1[int(0)])->cx_0 = 0.0f;
    float _S2027 = _S1997.vignette_params_1[int(0)].cx_0 + _S1958;
    FixedArray<float, 39>  _S2028;
    _S2028[int(0)] = 0.0f;
    _S2028[int(1)] = 0.0f;
    _S2028[int(2)] = 0.0f;
    _S2028[int(3)] = 0.0f;
    _S2028[int(4)] = 0.0f;
    _S2028[int(5)] = 0.0f;
    _S2028[int(6)] = 0.0f;
    _S2028[int(7)] = 0.0f;
    _S2028[int(8)] = 0.0f;
    _S2028[int(9)] = 0.0f;
    _S2028[int(10)] = 0.0f;
    _S2028[int(11)] = 0.0f;
    _S2028[int(12)] = 0.0f;
    _S2028[int(13)] = 0.0f;
    _S2028[int(14)] = 0.0f;
    _S2028[int(15)] = 0.0f;
    _S2028[int(16)] = 0.0f;
    _S2028[int(17)] = 0.0f;
    _S2028[int(18)] = 0.0f;
    _S2028[int(19)] = 0.0f;
    _S2028[int(20)] = 0.0f;
    _S2028[int(21)] = 0.0f;
    _S2028[int(22)] = 0.0f;
    _S2028[int(23)] = 0.0f;
    _S2028[int(24)] = 0.0f;
    _S2028[int(25)] = 0.0f;
    _S2028[int(26)] = 0.0f;
    _S2028[int(27)] = 0.0f;
    _S2028[int(28)] = 0.0f;
    _S2028[int(29)] = 0.0f;
    _S2028[int(30)] = 0.0f;
    _S2028[int(31)] = 0.0f;
    _S2028[int(32)] = 0.0f;
    _S2028[int(33)] = 0.0f;
    _S2028[int(34)] = 0.0f;
    _S2028[int(35)] = 0.0f;
    _S2028[int(36)] = 0.0f;
    _S2028[int(37)] = 0.0f;
    _S2028[int(38)] = 0.0f;
    _S2028[int(9)] = _S2019;
    _S2028[int(18)] = _S1997.color_params_2.r_0.x;
    _S2028[int(17)] = _S1997.color_params_2.b_0.y;
    _S2028[int(16)] = _S1997.color_params_2.b_0.x;
    _S2028[int(15)] = _S2013;
    _S2028[int(14)] = _S2014;
    _S2028[int(13)] = _S2015;
    _S2028[int(12)] = _S2016;
    _S2028[int(11)] = _S2017;
    _S2028[int(10)] = _S2018;
    _S2028[int(19)] = _S1997.color_params_2.r_0.y;
    _S2028[int(8)] = _S2020;
    _S2028[int(7)] = _S2021;
    _S2028[int(6)] = _S2022;
    _S2028[int(5)] = _S2023;
    _S2028[int(4)] = _S2024;
    _S2028[int(3)] = _S2025;
    _S2028[int(2)] = _S2026;
    _S2028[int(1)] = _S2027;
    _S2028[int(0)] = _S1819.exposure_2;
    _S2028[int(28)] = _S2008;
    _S2028[int(37)] = _S1999;
    _S2028[int(36)] = _S2000;
    _S2028[int(35)] = _S2001;
    _S2028[int(34)] = _S2002;
    _S2028[int(33)] = _S2003;
    _S2028[int(32)] = _S2004;
    _S2028[int(31)] = _S2005;
    _S2028[int(30)] = _S2006;
    _S2028[int(29)] = _S2007;
    _S2028[int(38)] = _S1998;
    _S2028[int(27)] = _S2009;
    _S2028[int(26)] = _S2010;
    _S2028[int(25)] = _S2011;
    _S2028[int(24)] = _S2012;
    _S2028[int(23)] = _S1997.color_params_2.n_0.y;
    _S2028[int(22)] = _S1997.color_params_2.n_0.x;
    _S2028[int(21)] = _S1997.color_params_2.g_0.y;
    _S2028[int(20)] = _S1997.color_params_2.g_0.x;
    dpparams_5->primal_0 = dpparams_5->primal_0;
    dpparams_5->differential_0 = _S2028;
    return;
}

inline __device__ void s_bwd_compute_raw_ppisp_rqs_regularization_loss_0(DiffPair_arrayx3Cfloatx2C39x3E_0 * _S2029, bool _S2030, FixedArray<float, 23>  * _S2031)
{
    s_bwd_prop_compute_raw_ppisp_rqs_regularization_loss_0(_S2029, _S2030, _S2031);
    return;
}

inline __device__ void compute_raw_ppisp_rqs_regularization_loss_vjp(FixedArray<float, 39>  params_11, bool exposure_arithmetic_mean_5, FixedArray<float, 23>  grad_out_5, FixedArray<float, 39>  * _S2032)
{
    FixedArray<float, 39>  _S2033 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C39x3E_0 dp_params_5;
    (&dp_params_5)->primal_0 = params_11;
    (&dp_params_5)->differential_0 = _S2033;
    FixedArray<float, 23>  _S2034 = grad_out_5;
    s_bwd_compute_raw_ppisp_rqs_regularization_loss_0(&dp_params_5, exposure_arithmetic_mean_5, &_S2034);
    *_S2032 = (&dp_params_5)->differential_0;
    return;
}

inline __device__ void compute_raw_ppisp_no_crf_regularization_loss(FixedArray<float, 24>  params_12, bool exposure_arithmetic_mean_6, FixedArray<float, 18>  * _S2035)
{
    float _S2036;
    PPISPParamsNoCRF_0 p_6;
    (&p_6)->exposure_1 = params_12[int(0)];
    (&(&p_6)->vignette_params_0[int(0)])->cx_0 = params_12[int(1)];
    (&(&p_6)->vignette_params_0[int(0)])->cy_0 = params_12[int(2)];
    (&(&p_6)->vignette_params_0[int(0)])->alpha0_0 = params_12[int(3)];
    (&(&p_6)->vignette_params_0[int(0)])->alpha1_0 = params_12[int(4)];
    (&(&p_6)->vignette_params_0[int(0)])->alpha2_0 = params_12[int(5)];
    (&(&p_6)->vignette_params_0[int(1)])->cx_0 = params_12[int(6)];
    (&(&p_6)->vignette_params_0[int(1)])->cy_0 = params_12[int(7)];
    (&(&p_6)->vignette_params_0[int(1)])->alpha0_0 = params_12[int(8)];
    (&(&p_6)->vignette_params_0[int(1)])->alpha1_0 = params_12[int(9)];
    (&(&p_6)->vignette_params_0[int(1)])->alpha2_0 = params_12[int(10)];
    (&(&p_6)->vignette_params_0[int(2)])->cx_0 = params_12[int(11)];
    (&(&p_6)->vignette_params_0[int(2)])->cy_0 = params_12[int(12)];
    (&(&p_6)->vignette_params_0[int(2)])->alpha0_0 = params_12[int(13)];
    (&(&p_6)->vignette_params_0[int(2)])->alpha1_0 = params_12[int(14)];
    (&(&p_6)->vignette_params_0[int(2)])->alpha2_0 = params_12[int(15)];
    *&((&(&(&p_6)->color_params_1)->b_0)->x) = params_12[int(16)];
    *&((&(&(&p_6)->color_params_1)->b_0)->y) = params_12[int(17)];
    *&((&(&(&p_6)->color_params_1)->r_0)->x) = params_12[int(18)];
    *&((&(&(&p_6)->color_params_1)->r_0)->y) = params_12[int(19)];
    *&((&(&(&p_6)->color_params_1)->g_0)->x) = params_12[int(20)];
    *&((&(&(&p_6)->color_params_1)->g_0)->y) = params_12[int(21)];
    *&((&(&(&p_6)->color_params_1)->n_0)->x) = params_12[int(22)];
    *&((&(&(&p_6)->color_params_1)->n_0)->y) = params_12[int(23)];
    PPISPParamsNoCRF_0 _S2037 = p_6;
    FixedArray<float, 18>  losses_2;
    losses_2[int(0)] = 0.0f;
    losses_2[int(1)] = 0.0f;
    losses_2[int(2)] = 0.0f;
    losses_2[int(3)] = 0.0f;
    losses_2[int(4)] = 0.0f;
    losses_2[int(5)] = 0.0f;
    losses_2[int(6)] = 0.0f;
    losses_2[int(7)] = 0.0f;
    losses_2[int(8)] = 0.0f;
    losses_2[int(9)] = 0.0f;
    losses_2[int(10)] = 0.0f;
    losses_2[int(11)] = 0.0f;
    losses_2[int(12)] = 0.0f;
    losses_2[int(13)] = 0.0f;
    losses_2[int(14)] = 0.0f;
    losses_2[int(15)] = 0.0f;
    losses_2[int(16)] = 0.0f;
    losses_2[int(17)] = 0.0f;
    for(;;)
    {
        if(exposure_arithmetic_mean_6)
        {
            _S2036 = (F32_exp2((_S2037.exposure_1)));
            break;
        }
        _S2036 = _S2037.exposure_1;
        break;
    }
    losses_2[int(0)] = _S2036;
    float _S2038 = _S2037.vignette_params_0[int(0)].cx_0;
    float _S2039 = _S2037.vignette_params_0[int(0)].cy_0;
    float _S2040 = _S2037.vignette_params_0[int(1)].cx_0;
    float _S2041 = _S2037.vignette_params_0[int(1)].cy_0;
    float _S2042 = _S2037.vignette_params_0[int(2)].cx_0;
    float _S2043 = _S2037.vignette_params_0[int(2)].cy_0;
    losses_2[int(1)] = _S2038 * _S2038 + _S2039 * _S2039 + _S2040 * _S2040 + _S2041 * _S2041 + _S2042 * _S2042 + _S2043 * _S2043;
    losses_2[int(2)] = (F32_max((0.0f), (_S2037.vignette_params_0[int(0)].alpha0_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(1)].alpha0_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(2)].alpha0_0)));
    losses_2[int(3)] = (F32_max((0.0f), (_S2037.vignette_params_0[int(0)].alpha1_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(1)].alpha1_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(2)].alpha1_0)));
    losses_2[int(4)] = (F32_max((0.0f), (_S2037.vignette_params_0[int(0)].alpha2_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(1)].alpha2_0))) + (F32_max((0.0f), (_S2037.vignette_params_0[int(2)].alpha2_0)));
    float mean_38 = (_S2037.vignette_params_0[int(0)].cx_0 + _S2037.vignette_params_0[int(1)].cx_0 + _S2037.vignette_params_0[int(2)].cx_0) / 3.0f;
    float _S2044 = _S2037.vignette_params_0[int(0)].cx_0 - mean_38;
    float _S2045 = _S2037.vignette_params_0[int(1)].cx_0 - mean_38;
    float _S2046 = _S2037.vignette_params_0[int(2)].cx_0 - mean_38;
    losses_2[int(5)] = (_S2044 * _S2044 + _S2045 * _S2045 + _S2046 * _S2046) / 3.0f;
    float mean_39 = (_S2037.vignette_params_0[int(0)].cy_0 + _S2037.vignette_params_0[int(1)].cy_0 + _S2037.vignette_params_0[int(2)].cy_0) / 3.0f;
    float _S2047 = _S2037.vignette_params_0[int(0)].cy_0 - mean_39;
    float _S2048 = _S2037.vignette_params_0[int(1)].cy_0 - mean_39;
    float _S2049 = _S2037.vignette_params_0[int(2)].cy_0 - mean_39;
    losses_2[int(6)] = (_S2047 * _S2047 + _S2048 * _S2048 + _S2049 * _S2049) / 3.0f;
    float mean_40 = (_S2037.vignette_params_0[int(0)].alpha0_0 + _S2037.vignette_params_0[int(1)].alpha0_0 + _S2037.vignette_params_0[int(2)].alpha0_0) / 3.0f;
    float _S2050 = _S2037.vignette_params_0[int(0)].alpha0_0 - mean_40;
    float _S2051 = _S2037.vignette_params_0[int(1)].alpha0_0 - mean_40;
    float _S2052 = _S2037.vignette_params_0[int(2)].alpha0_0 - mean_40;
    losses_2[int(7)] = (_S2050 * _S2050 + _S2051 * _S2051 + _S2052 * _S2052) / 3.0f;
    float mean_41 = (_S2037.vignette_params_0[int(0)].alpha1_0 + _S2037.vignette_params_0[int(1)].alpha1_0 + _S2037.vignette_params_0[int(2)].alpha1_0) / 3.0f;
    float _S2053 = _S2037.vignette_params_0[int(0)].alpha1_0 - mean_41;
    float _S2054 = _S2037.vignette_params_0[int(1)].alpha1_0 - mean_41;
    float _S2055 = _S2037.vignette_params_0[int(2)].alpha1_0 - mean_41;
    losses_2[int(8)] = (_S2053 * _S2053 + _S2054 * _S2054 + _S2055 * _S2055) / 3.0f;
    float mean_42 = (_S2037.vignette_params_0[int(0)].alpha2_0 + _S2037.vignette_params_0[int(1)].alpha2_0 + _S2037.vignette_params_0[int(2)].alpha2_0) / 3.0f;
    float _S2056 = _S2037.vignette_params_0[int(0)].alpha2_0 - mean_42;
    float _S2057 = _S2037.vignette_params_0[int(1)].alpha2_0 - mean_42;
    float _S2058 = _S2037.vignette_params_0[int(2)].alpha2_0 - mean_42;
    losses_2[int(9)] = (_S2056 * _S2056 + _S2057 * _S2057 + _S2058 * _S2058) / 3.0f;
    float2  bd_6 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S2037.color_params_1.b_0);
    float2  rd_6 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S2037.color_params_1.r_0);
    float2  gd_6 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S2037.color_params_1.g_0);
    float2  nd_6 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S2037.color_params_1.n_0);
    losses_2[int(10)] = bd_6.x;
    losses_2[int(11)] = bd_6.y;
    losses_2[int(12)] = rd_6.x;
    losses_2[int(13)] = rd_6.y;
    losses_2[int(14)] = gd_6.x;
    losses_2[int(15)] = gd_6.y;
    losses_2[int(16)] = nd_6.x;
    losses_2[int(17)] = nd_6.y;
    *_S2035 = losses_2;
    return;
}

inline __device__ void s_bwd_prop_compute_raw_ppisp_no_crf_regularization_loss_0(DiffPair_arrayx3Cfloatx2C24x3E_0 * dpparams_6, bool exposure_arithmetic_mean_7, FixedArray<float, 18>  * _s_dOut_6)
{
    VignettingChannelParams_0 _S2059 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    FixedArray<VignettingChannelParams_0, 3>  _S2060 = {
        _S2059, _S2059, _S2059
    };
    float2  _S2061 = make_float2 (0.0f);
    ColorPPISPParams_0 _S2062 = { _S2061, _S2061, _S2061, _S2061 };
    PPISPParamsNoCRF_0 _S2063;
    (&_S2063)->exposure_1 = dpparams_6->primal_0[int(0)];
    (&_S2063)->vignette_params_0 = _S2060;
    (&_S2063)->color_params_1 = _S2062;
    (&(&_S2063)->vignette_params_0[int(0)])->cx_0 = dpparams_6->primal_0[int(1)];
    (&(&_S2063)->vignette_params_0[int(0)])->cy_0 = dpparams_6->primal_0[int(2)];
    (&(&_S2063)->vignette_params_0[int(0)])->alpha0_0 = dpparams_6->primal_0[int(3)];
    (&(&_S2063)->vignette_params_0[int(0)])->alpha1_0 = dpparams_6->primal_0[int(4)];
    (&(&_S2063)->vignette_params_0[int(0)])->alpha2_0 = dpparams_6->primal_0[int(5)];
    (&(&_S2063)->vignette_params_0[int(1)])->cx_0 = dpparams_6->primal_0[int(6)];
    (&(&_S2063)->vignette_params_0[int(1)])->cy_0 = dpparams_6->primal_0[int(7)];
    (&(&_S2063)->vignette_params_0[int(1)])->alpha0_0 = dpparams_6->primal_0[int(8)];
    (&(&_S2063)->vignette_params_0[int(1)])->alpha1_0 = dpparams_6->primal_0[int(9)];
    (&(&_S2063)->vignette_params_0[int(1)])->alpha2_0 = dpparams_6->primal_0[int(10)];
    (&(&_S2063)->vignette_params_0[int(2)])->cx_0 = dpparams_6->primal_0[int(11)];
    (&(&_S2063)->vignette_params_0[int(2)])->cy_0 = dpparams_6->primal_0[int(12)];
    (&(&_S2063)->vignette_params_0[int(2)])->alpha0_0 = dpparams_6->primal_0[int(13)];
    (&(&_S2063)->vignette_params_0[int(2)])->alpha1_0 = dpparams_6->primal_0[int(14)];
    (&(&_S2063)->vignette_params_0[int(2)])->alpha2_0 = dpparams_6->primal_0[int(15)];
    *&((&(&(&_S2063)->color_params_1)->b_0)->x) = dpparams_6->primal_0[int(16)];
    *&((&(&(&_S2063)->color_params_1)->b_0)->y) = dpparams_6->primal_0[int(17)];
    *&((&(&(&_S2063)->color_params_1)->r_0)->x) = dpparams_6->primal_0[int(18)];
    *&((&(&(&_S2063)->color_params_1)->r_0)->y) = dpparams_6->primal_0[int(19)];
    *&((&(&(&_S2063)->color_params_1)->g_0)->x) = dpparams_6->primal_0[int(20)];
    *&((&(&(&_S2063)->color_params_1)->g_0)->y) = dpparams_6->primal_0[int(21)];
    *&((&(&(&_S2063)->color_params_1)->n_0)->x) = dpparams_6->primal_0[int(22)];
    *&((&(&(&_S2063)->color_params_1)->n_0)->y) = dpparams_6->primal_0[int(23)];
    PPISPParamsNoCRF_0 _S2064 = _S2063;
    bool _S2065 = !exposure_arithmetic_mean_7;
    float mean_43 = (dpparams_6->primal_0[int(1)] + dpparams_6->primal_0[int(6)] + dpparams_6->primal_0[int(11)]) / 3.0f;
    float _S2066 = dpparams_6->primal_0[int(1)] - mean_43;
    float _S2067 = dpparams_6->primal_0[int(6)] - mean_43;
    float _S2068 = dpparams_6->primal_0[int(11)] - mean_43;
    float mean_44 = (dpparams_6->primal_0[int(2)] + dpparams_6->primal_0[int(7)] + dpparams_6->primal_0[int(12)]) / 3.0f;
    float _S2069 = dpparams_6->primal_0[int(2)] - mean_44;
    float _S2070 = dpparams_6->primal_0[int(7)] - mean_44;
    float _S2071 = dpparams_6->primal_0[int(12)] - mean_44;
    float mean_45 = (dpparams_6->primal_0[int(3)] + dpparams_6->primal_0[int(8)] + dpparams_6->primal_0[int(13)]) / 3.0f;
    float _S2072 = dpparams_6->primal_0[int(3)] - mean_45;
    float _S2073 = dpparams_6->primal_0[int(8)] - mean_45;
    float _S2074 = dpparams_6->primal_0[int(13)] - mean_45;
    float mean_46 = (dpparams_6->primal_0[int(4)] + dpparams_6->primal_0[int(9)] + dpparams_6->primal_0[int(14)]) / 3.0f;
    float _S2075 = dpparams_6->primal_0[int(4)] - mean_46;
    float _S2076 = dpparams_6->primal_0[int(9)] - mean_46;
    float _S2077 = dpparams_6->primal_0[int(14)] - mean_46;
    float mean_47 = (dpparams_6->primal_0[int(5)] + dpparams_6->primal_0[int(10)] + dpparams_6->primal_0[int(15)]) / 3.0f;
    float _S2078 = dpparams_6->primal_0[int(5)] - mean_47;
    float _S2079 = dpparams_6->primal_0[int(10)] - mean_47;
    float _S2080 = dpparams_6->primal_0[int(15)] - mean_47;
    PPISPParamsNoCRF_0 _S2081 = PPISPParamsNoCRF_x24_syn_dzero_0();
    float _S2082 = (*_s_dOut_6)[int(0)];
    float2  _S2083 = make_float2 ((*_s_dOut_6)[int(16)], (*_s_dOut_6)[int(17)]);
    Matrix<float, 2, 2>  _S2084 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2085;
    (&_S2085)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S2085)->differential_0 = _S2084;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2086;
    (&_S2086)->primal_0 = _S2063.color_params_1.n_0;
    (&_S2086)->differential_0 = _S2061;
    s_bwd_prop_mul_2(&_S2085, &_S2086, _S2083);
    float2  _S2087 = make_float2 ((*_s_dOut_6)[int(14)], (*_s_dOut_6)[int(15)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2088;
    (&_S2088)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S2088)->differential_0 = _S2084;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2089;
    (&_S2089)->primal_0 = _S2063.color_params_1.g_0;
    (&_S2089)->differential_0 = _S2061;
    s_bwd_prop_mul_2(&_S2088, &_S2089, _S2087);
    float2  _S2090 = make_float2 ((*_s_dOut_6)[int(12)], (*_s_dOut_6)[int(13)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2091;
    (&_S2091)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S2091)->differential_0 = _S2084;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2092;
    (&_S2092)->primal_0 = _S2063.color_params_1.r_0;
    (&_S2092)->differential_0 = _S2061;
    s_bwd_prop_mul_2(&_S2091, &_S2092, _S2090);
    float2  _S2093 = make_float2 ((*_s_dOut_6)[int(10)], (*_s_dOut_6)[int(11)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2094;
    (&_S2094)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S2094)->differential_0 = _S2084;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2095;
    (&_S2095)->primal_0 = _S2063.color_params_1.b_0;
    (&_S2095)->differential_0 = _S2061;
    s_bwd_prop_mul_2(&_S2094, &_S2095, _S2093);
    ColorPPISPParams_0 _S2096 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S2096)->n_0 = _S2086.differential_0;
    (&_S2096)->g_0 = _S2089.differential_0;
    (&_S2096)->r_0 = _S2092.differential_0;
    (&_S2096)->b_0 = _S2095.differential_0;
    float _S2097 = 0.3333333432674408f * (*_s_dOut_6)[int(9)];
    float _S2098 = _S2080 * _S2097;
    float _S2099 = _S2098 + _S2098;
    float _S2100 = _S2079 * _S2097;
    float _S2101 = _S2100 + _S2100;
    float _S2102 = _S2078 * _S2097;
    float _S2103 = _S2102 + _S2102;
    float _S2104 = 0.3333333432674408f * (- _S2099 + - _S2101 + - _S2103);
    float _S2105 = 0.3333333432674408f * (*_s_dOut_6)[int(8)];
    float _S2106 = _S2077 * _S2105;
    float _S2107 = _S2106 + _S2106;
    float _S2108 = _S2076 * _S2105;
    float _S2109 = _S2108 + _S2108;
    float _S2110 = _S2075 * _S2105;
    float _S2111 = _S2110 + _S2110;
    float _S2112 = 0.3333333432674408f * (- _S2107 + - _S2109 + - _S2111);
    float _S2113 = 0.3333333432674408f * (*_s_dOut_6)[int(7)];
    float _S2114 = _S2074 * _S2113;
    float _S2115 = _S2114 + _S2114;
    float _S2116 = _S2073 * _S2113;
    float _S2117 = _S2116 + _S2116;
    float _S2118 = _S2072 * _S2113;
    float _S2119 = _S2118 + _S2118;
    float _S2120 = 0.3333333432674408f * (- _S2115 + - _S2117 + - _S2119);
    float _S2121 = 0.3333333432674408f * (*_s_dOut_6)[int(6)];
    float _S2122 = _S2071 * _S2121;
    float _S2123 = _S2122 + _S2122;
    float _S2124 = _S2070 * _S2121;
    float _S2125 = _S2124 + _S2124;
    float _S2126 = _S2069 * _S2121;
    float _S2127 = _S2126 + _S2126;
    float _S2128 = 0.3333333432674408f * (- _S2123 + - _S2125 + - _S2127);
    float _S2129 = 0.3333333432674408f * (*_s_dOut_6)[int(5)];
    float _S2130 = _S2068 * _S2129;
    float _S2131 = _S2130 + _S2130;
    float _S2132 = _S2067 * _S2129;
    float _S2133 = _S2132 + _S2132;
    float _S2134 = _S2066 * _S2129;
    float _S2135 = _S2134 + _S2134;
    float _S2136 = 0.3333333432674408f * (- _S2131 + - _S2133 + - _S2135);
    DiffPair_float_0 _S2137;
    (&_S2137)->primal_0 = 0.0f;
    (&_S2137)->differential_0 = 0.0f;
    DiffPair_float_0 _S2138;
    (&_S2138)->primal_0 = dpparams_6->primal_0[int(15)];
    (&_S2138)->differential_0 = 0.0f;
    _d_max_0(&_S2137, &_S2138, (*_s_dOut_6)[int(4)]);
    DiffPair_float_0 _S2139;
    (&_S2139)->primal_0 = 0.0f;
    (&_S2139)->differential_0 = 0.0f;
    DiffPair_float_0 _S2140;
    (&_S2140)->primal_0 = dpparams_6->primal_0[int(10)];
    (&_S2140)->differential_0 = 0.0f;
    _d_max_0(&_S2139, &_S2140, (*_s_dOut_6)[int(4)]);
    DiffPair_float_0 _S2141;
    (&_S2141)->primal_0 = 0.0f;
    (&_S2141)->differential_0 = 0.0f;
    DiffPair_float_0 _S2142;
    (&_S2142)->primal_0 = dpparams_6->primal_0[int(5)];
    (&_S2142)->differential_0 = 0.0f;
    _d_max_0(&_S2141, &_S2142, (*_s_dOut_6)[int(4)]);
    DiffPair_float_0 _S2143;
    (&_S2143)->primal_0 = 0.0f;
    (&_S2143)->differential_0 = 0.0f;
    DiffPair_float_0 _S2144;
    (&_S2144)->primal_0 = dpparams_6->primal_0[int(14)];
    (&_S2144)->differential_0 = 0.0f;
    _d_max_0(&_S2143, &_S2144, (*_s_dOut_6)[int(3)]);
    DiffPair_float_0 _S2145;
    (&_S2145)->primal_0 = 0.0f;
    (&_S2145)->differential_0 = 0.0f;
    DiffPair_float_0 _S2146;
    (&_S2146)->primal_0 = dpparams_6->primal_0[int(9)];
    (&_S2146)->differential_0 = 0.0f;
    _d_max_0(&_S2145, &_S2146, (*_s_dOut_6)[int(3)]);
    DiffPair_float_0 _S2147;
    (&_S2147)->primal_0 = 0.0f;
    (&_S2147)->differential_0 = 0.0f;
    DiffPair_float_0 _S2148;
    (&_S2148)->primal_0 = dpparams_6->primal_0[int(4)];
    (&_S2148)->differential_0 = 0.0f;
    _d_max_0(&_S2147, &_S2148, (*_s_dOut_6)[int(3)]);
    DiffPair_float_0 _S2149;
    (&_S2149)->primal_0 = 0.0f;
    (&_S2149)->differential_0 = 0.0f;
    DiffPair_float_0 _S2150;
    (&_S2150)->primal_0 = dpparams_6->primal_0[int(13)];
    (&_S2150)->differential_0 = 0.0f;
    _d_max_0(&_S2149, &_S2150, (*_s_dOut_6)[int(2)]);
    DiffPair_float_0 _S2151;
    (&_S2151)->primal_0 = 0.0f;
    (&_S2151)->differential_0 = 0.0f;
    DiffPair_float_0 _S2152;
    (&_S2152)->primal_0 = dpparams_6->primal_0[int(8)];
    (&_S2152)->differential_0 = 0.0f;
    _d_max_0(&_S2151, &_S2152, (*_s_dOut_6)[int(2)]);
    DiffPair_float_0 _S2153;
    (&_S2153)->primal_0 = 0.0f;
    (&_S2153)->differential_0 = 0.0f;
    DiffPair_float_0 _S2154;
    (&_S2154)->primal_0 = dpparams_6->primal_0[int(3)];
    (&_S2154)->differential_0 = 0.0f;
    _d_max_0(&_S2153, &_S2154, (*_s_dOut_6)[int(2)]);
    float _S2155 = dpparams_6->primal_0[int(12)] * (*_s_dOut_6)[int(1)];
    float _S2156 = dpparams_6->primal_0[int(11)] * (*_s_dOut_6)[int(1)];
    float _S2157 = dpparams_6->primal_0[int(7)] * (*_s_dOut_6)[int(1)];
    float _S2158 = dpparams_6->primal_0[int(6)] * (*_s_dOut_6)[int(1)];
    float _S2159 = dpparams_6->primal_0[int(2)] * (*_s_dOut_6)[int(1)];
    float _S2160 = dpparams_6->primal_0[int(1)] * (*_s_dOut_6)[int(1)];
    float _S2161 = _S2123 + _S2128 + _S2155 + _S2155;
    float _S2162 = _S2135 + _S2136 + _S2160 + _S2160;
    float _S2163 = _S2131 + _S2136 + _S2156 + _S2156;
    float _S2164 = _S2133 + _S2136 + _S2158 + _S2158;
    float _S2165 = _S2125 + _S2128 + _S2157 + _S2157;
    float _S2166 = _S2117 + _S2120 + _S2152.differential_0;
    float _S2167 = _S2109 + _S2112 + _S2146.differential_0;
    float _S2168 = _S2101 + _S2104 + _S2140.differential_0;
    PPISPParamsNoCRF_0 _S2169 = _S2081;
    (&_S2169)->color_params_1 = _S2096;
    PPISPParamsNoCRF_0 _S2170 = _S2081;
    PPISPParamsNoCRF_0 _S2171 = _S2169;
    PPISPParamsNoCRF_0 _S2172 = PPISPParamsNoCRF_x24_syn_dadd_0(&_S2170, &_S2171);
    float _S2173 = _S2103 + _S2104 + _S2142.differential_0;
    float _S2174 = _S2099 + _S2104 + _S2138.differential_0;
    float _S2175 = _S2111 + _S2112 + _S2148.differential_0;
    float _S2176 = _S2107 + _S2112 + _S2144.differential_0;
    float _S2177 = _S2119 + _S2120 + _S2154.differential_0;
    float _S2178 = _S2115 + _S2120 + _S2150.differential_0;
    float _S2179 = _S2127 + _S2128 + _S2159 + _S2159;
    float _S2180;
    float _S2181;
    if(_S2065)
    {
        _S2180 = 0.0f;
        _S2181 = _S2082;
    }
    else
    {
        _S2180 = _S2082;
        _S2181 = 0.0f;
    }
    if(exposure_arithmetic_mean_7)
    {
        DiffPair_float_0 _S2182;
        (&_S2182)->primal_0 = _S2064.exposure_1;
        (&_S2182)->differential_0 = 0.0f;
        s_bwd_prop_exp2_0(&_S2182, _S2180);
        _S2180 = _S2182.differential_0 + _S2181;
    }
    else
    {
        _S2180 = _S2181;
    }
    PPISPParamsNoCRF_0 _S2183 = _S2081;
    (&_S2183)->exposure_1 = _S2180;
    PPISPParamsNoCRF_0 _S2184 = _S2172;
    PPISPParamsNoCRF_0 _S2185 = _S2183;
    PPISPParamsNoCRF_0 _S2186 = PPISPParamsNoCRF_x24_syn_dadd_0(&_S2184, &_S2185);
    _S2063 = _S2186;
    *&((&(&(&_S2063)->color_params_1)->n_0)->y) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->n_0)->x) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->g_0)->y) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->g_0)->x) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->r_0)->y) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->r_0)->x) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->b_0)->y) = 0.0f;
    *&((&(&(&_S2063)->color_params_1)->b_0)->x) = 0.0f;
    (&(&_S2063)->vignette_params_0[int(2)])->alpha2_0 = 0.0f;
    float _S2187 = _S2186.vignette_params_0[int(2)].alpha2_0 + _S2174;
    (&(&_S2063)->vignette_params_0[int(2)])->alpha1_0 = 0.0f;
    float _S2188 = _S2186.vignette_params_0[int(2)].alpha1_0 + _S2176;
    (&(&_S2063)->vignette_params_0[int(2)])->alpha0_0 = 0.0f;
    float _S2189 = _S2186.vignette_params_0[int(2)].alpha0_0 + _S2178;
    (&(&_S2063)->vignette_params_0[int(2)])->cy_0 = 0.0f;
    float _S2190 = _S2186.vignette_params_0[int(2)].cy_0 + _S2161;
    (&(&_S2063)->vignette_params_0[int(2)])->cx_0 = 0.0f;
    float _S2191 = _S2186.vignette_params_0[int(2)].cx_0 + _S2163;
    (&(&_S2063)->vignette_params_0[int(1)])->alpha2_0 = 0.0f;
    float _S2192 = _S2186.vignette_params_0[int(1)].alpha2_0 + _S2168;
    (&(&_S2063)->vignette_params_0[int(1)])->alpha1_0 = 0.0f;
    float _S2193 = _S2186.vignette_params_0[int(1)].alpha1_0 + _S2167;
    (&(&_S2063)->vignette_params_0[int(1)])->alpha0_0 = 0.0f;
    float _S2194 = _S2186.vignette_params_0[int(1)].alpha0_0 + _S2166;
    (&(&_S2063)->vignette_params_0[int(1)])->cy_0 = 0.0f;
    float _S2195 = _S2186.vignette_params_0[int(1)].cy_0 + _S2165;
    (&(&_S2063)->vignette_params_0[int(1)])->cx_0 = 0.0f;
    float _S2196 = _S2186.vignette_params_0[int(1)].cx_0 + _S2164;
    (&(&_S2063)->vignette_params_0[int(0)])->alpha2_0 = 0.0f;
    float _S2197 = _S2186.vignette_params_0[int(0)].alpha2_0 + _S2173;
    (&(&_S2063)->vignette_params_0[int(0)])->alpha1_0 = 0.0f;
    float _S2198 = _S2186.vignette_params_0[int(0)].alpha1_0 + _S2175;
    (&(&_S2063)->vignette_params_0[int(0)])->alpha0_0 = 0.0f;
    float _S2199 = _S2186.vignette_params_0[int(0)].alpha0_0 + _S2177;
    (&(&_S2063)->vignette_params_0[int(0)])->cy_0 = 0.0f;
    float _S2200 = _S2186.vignette_params_0[int(0)].cy_0 + _S2179;
    (&(&_S2063)->vignette_params_0[int(0)])->cx_0 = 0.0f;
    float _S2201 = _S2186.vignette_params_0[int(0)].cx_0 + _S2162;
    FixedArray<float, 24>  _S2202;
    _S2202[int(0)] = 0.0f;
    _S2202[int(1)] = 0.0f;
    _S2202[int(2)] = 0.0f;
    _S2202[int(3)] = 0.0f;
    _S2202[int(4)] = 0.0f;
    _S2202[int(5)] = 0.0f;
    _S2202[int(6)] = 0.0f;
    _S2202[int(7)] = 0.0f;
    _S2202[int(8)] = 0.0f;
    _S2202[int(9)] = 0.0f;
    _S2202[int(10)] = 0.0f;
    _S2202[int(11)] = 0.0f;
    _S2202[int(12)] = 0.0f;
    _S2202[int(13)] = 0.0f;
    _S2202[int(14)] = 0.0f;
    _S2202[int(15)] = 0.0f;
    _S2202[int(16)] = 0.0f;
    _S2202[int(17)] = 0.0f;
    _S2202[int(18)] = 0.0f;
    _S2202[int(19)] = 0.0f;
    _S2202[int(20)] = 0.0f;
    _S2202[int(21)] = 0.0f;
    _S2202[int(22)] = 0.0f;
    _S2202[int(23)] = 0.0f;
    _S2202[int(11)] = _S2191;
    _S2202[int(0)] = _S2063.exposure_1;
    _S2202[int(1)] = _S2201;
    _S2202[int(2)] = _S2200;
    _S2202[int(3)] = _S2199;
    _S2202[int(4)] = _S2198;
    _S2202[int(5)] = _S2197;
    _S2202[int(6)] = _S2196;
    _S2202[int(7)] = _S2195;
    _S2202[int(8)] = _S2194;
    _S2202[int(9)] = _S2193;
    _S2202[int(10)] = _S2192;
    _S2202[int(23)] = _S2186.color_params_1.n_0.y;
    _S2202[int(12)] = _S2190;
    _S2202[int(13)] = _S2189;
    _S2202[int(14)] = _S2188;
    _S2202[int(15)] = _S2187;
    _S2202[int(16)] = _S2186.color_params_1.b_0.x;
    _S2202[int(17)] = _S2186.color_params_1.b_0.y;
    _S2202[int(18)] = _S2186.color_params_1.r_0.x;
    _S2202[int(19)] = _S2186.color_params_1.r_0.y;
    _S2202[int(20)] = _S2186.color_params_1.g_0.x;
    _S2202[int(21)] = _S2186.color_params_1.g_0.y;
    _S2202[int(22)] = _S2186.color_params_1.n_0.x;
    dpparams_6->primal_0 = dpparams_6->primal_0;
    dpparams_6->differential_0 = _S2202;
    return;
}

inline __device__ void s_bwd_compute_raw_ppisp_no_crf_regularization_loss_0(DiffPair_arrayx3Cfloatx2C24x3E_0 * _S2203, bool _S2204, FixedArray<float, 18>  * _S2205)
{
    s_bwd_prop_compute_raw_ppisp_no_crf_regularization_loss_0(_S2203, _S2204, _S2205);
    return;
}

inline __device__ void compute_raw_ppisp_no_crf_regularization_loss_vjp(FixedArray<float, 24>  params_13, bool exposure_arithmetic_mean_8, FixedArray<float, 18>  grad_out_6, FixedArray<float, 24>  * _S2206)
{
    FixedArray<float, 24>  _S2207 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C24x3E_0 dp_params_6;
    (&dp_params_6)->primal_0 = params_13;
    (&dp_params_6)->differential_0 = _S2207;
    FixedArray<float, 18>  _S2208 = grad_out_6;
    s_bwd_compute_raw_ppisp_no_crf_regularization_loss_0(&dp_params_6, exposure_arithmetic_mean_8, &_S2208);
    *_S2206 = (&dp_params_6)->differential_0;
    return;
}

inline __device__ void compute_raw_ppisp_no_crf_no_vig_regularization_loss(FixedArray<float, 9>  params_14, bool exposure_arithmetic_mean_9, FixedArray<float, 9>  * _S2209)
{
    float _S2210;
    PPISPParamsNoCRFNoVig_0 p_7;
    (&p_7)->exposure_0 = params_14[int(0)];
    *&((&(&(&p_7)->color_params_0)->b_0)->x) = params_14[int(1)];
    *&((&(&(&p_7)->color_params_0)->b_0)->y) = params_14[int(2)];
    *&((&(&(&p_7)->color_params_0)->r_0)->x) = params_14[int(3)];
    *&((&(&(&p_7)->color_params_0)->r_0)->y) = params_14[int(4)];
    *&((&(&(&p_7)->color_params_0)->g_0)->x) = params_14[int(5)];
    *&((&(&(&p_7)->color_params_0)->g_0)->y) = params_14[int(6)];
    *&((&(&(&p_7)->color_params_0)->n_0)->x) = params_14[int(7)];
    *&((&(&(&p_7)->color_params_0)->n_0)->y) = params_14[int(8)];
    PPISPParamsNoCRFNoVig_0 _S2211 = p_7;
    FixedArray<float, 9>  losses_3;
    losses_3[int(0)] = 0.0f;
    losses_3[int(1)] = 0.0f;
    losses_3[int(2)] = 0.0f;
    losses_3[int(3)] = 0.0f;
    losses_3[int(4)] = 0.0f;
    losses_3[int(5)] = 0.0f;
    losses_3[int(6)] = 0.0f;
    losses_3[int(7)] = 0.0f;
    losses_3[int(8)] = 0.0f;
    for(;;)
    {
        if(exposure_arithmetic_mean_9)
        {
            _S2210 = (F32_exp2((_S2211.exposure_0)));
            break;
        }
        _S2210 = _S2211.exposure_0;
        break;
    }
    losses_3[int(0)] = _S2210;
    float2  bd_7 = mul_0(makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f), _S2211.color_params_0.b_0);
    float2  rd_7 = mul_0(makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f), _S2211.color_params_0.r_0);
    float2  gd_7 = mul_0(makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f), _S2211.color_params_0.g_0);
    float2  nd_7 = mul_0(makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f), _S2211.color_params_0.n_0);
    losses_3[int(1)] = bd_7.x;
    losses_3[int(2)] = bd_7.y;
    losses_3[int(3)] = rd_7.x;
    losses_3[int(4)] = rd_7.y;
    losses_3[int(5)] = gd_7.x;
    losses_3[int(6)] = gd_7.y;
    losses_3[int(7)] = nd_7.x;
    losses_3[int(8)] = nd_7.y;
    *_S2209 = losses_3;
    return;
}

inline __device__ void s_bwd_prop_compute_raw_ppisp_no_crf_no_vig_regularization_loss_0(DiffPair_arrayx3Cfloatx2C9x3E_0 * dpparams_7, bool exposure_arithmetic_mean_10, FixedArray<float, 9>  * _s_dOut_7)
{
    float2  _S2212 = make_float2 (0.0f);
    ColorPPISPParams_0 _S2213 = { _S2212, _S2212, _S2212, _S2212 };
    PPISPParamsNoCRFNoVig_0 _S2214;
    (&_S2214)->exposure_0 = dpparams_7->primal_0[int(0)];
    (&_S2214)->color_params_0 = _S2213;
    *&((&(&(&_S2214)->color_params_0)->b_0)->x) = dpparams_7->primal_0[int(1)];
    *&((&(&(&_S2214)->color_params_0)->b_0)->y) = dpparams_7->primal_0[int(2)];
    *&((&(&(&_S2214)->color_params_0)->r_0)->x) = dpparams_7->primal_0[int(3)];
    *&((&(&(&_S2214)->color_params_0)->r_0)->y) = dpparams_7->primal_0[int(4)];
    *&((&(&(&_S2214)->color_params_0)->g_0)->x) = dpparams_7->primal_0[int(5)];
    *&((&(&(&_S2214)->color_params_0)->g_0)->y) = dpparams_7->primal_0[int(6)];
    *&((&(&(&_S2214)->color_params_0)->n_0)->x) = dpparams_7->primal_0[int(7)];
    *&((&(&(&_S2214)->color_params_0)->n_0)->y) = dpparams_7->primal_0[int(8)];
    PPISPParamsNoCRFNoVig_0 _S2215 = _S2214;
    bool _S2216 = !exposure_arithmetic_mean_10;
    PPISPParamsNoCRFNoVig_0 _S2217 = PPISPParamsNoCRFNoVig_x24_syn_dzero_0();
    float _S2218 = (*_s_dOut_7)[int(0)];
    float2  _S2219 = make_float2 ((*_s_dOut_7)[int(7)], (*_s_dOut_7)[int(8)]);
    Matrix<float, 2, 2>  _S2220 = makeMatrix<float, 2, 2> (0.0f);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2221;
    (&_S2221)->primal_0 = makeMatrix<float, 2, 2> (0.01283689960837364f, -0.00346540007740259f, -0.00346540007740259f, 0.01281579956412315f);
    (&_S2221)->differential_0 = _S2220;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2222;
    (&_S2222)->primal_0 = _S2214.color_params_0.n_0;
    (&_S2222)->differential_0 = _S2212;
    s_bwd_prop_mul_2(&_S2221, &_S2222, _S2219);
    float2  _S2223 = make_float2 ((*_s_dOut_7)[int(5)], (*_s_dOut_7)[int(6)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2224;
    (&_S2224)->primal_0 = makeMatrix<float, 2, 2> (0.04333360120654106f, -0.01805369928479195f, -0.01805369928479195f, 0.0580499991774559f);
    (&_S2224)->differential_0 = _S2220;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2225;
    (&_S2225)->primal_0 = _S2214.color_params_0.g_0;
    (&_S2225)->differential_0 = _S2212;
    s_bwd_prop_mul_2(&_S2224, &_S2225, _S2223);
    float2  _S2226 = make_float2 ((*_s_dOut_7)[int(3)], (*_s_dOut_7)[int(4)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2227;
    (&_S2227)->primal_0 = makeMatrix<float, 2, 2> (0.05805699899792671f, -0.0179871991276741f, -0.0179871991276741f, 0.04310610145330429f);
    (&_S2227)->differential_0 = _S2220;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2228;
    (&_S2228)->primal_0 = _S2214.color_params_0.r_0;
    (&_S2228)->differential_0 = _S2212;
    s_bwd_prop_mul_2(&_S2227, &_S2228, _S2226);
    float2  _S2229 = make_float2 ((*_s_dOut_7)[int(1)], (*_s_dOut_7)[int(2)]);
    DiffPair_matrixx3Cfloatx2C2x2C2x3E_0 _S2230;
    (&_S2230)->primal_0 = makeMatrix<float, 2, 2> (0.04805419966578484f, -0.0043631000444293f, -0.0043631000444293f, 0.04812829941511154f);
    (&_S2230)->differential_0 = _S2220;
    DiffPair_vectorx3Cfloatx2C2x3E_0 _S2231;
    (&_S2231)->primal_0 = _S2214.color_params_0.b_0;
    (&_S2231)->differential_0 = _S2212;
    s_bwd_prop_mul_2(&_S2230, &_S2231, _S2229);
    ColorPPISPParams_0 _S2232 = ColorPPISPParams_x24_syn_dzero_0();
    (&_S2232)->n_0 = _S2222.differential_0;
    (&_S2232)->g_0 = _S2225.differential_0;
    (&_S2232)->r_0 = _S2228.differential_0;
    (&_S2232)->b_0 = _S2231.differential_0;
    PPISPParamsNoCRFNoVig_0 _S2233 = _S2217;
    (&_S2233)->color_params_0 = _S2232;
    PPISPParamsNoCRFNoVig_0 _S2234 = _S2217;
    PPISPParamsNoCRFNoVig_0 _S2235 = _S2233;
    PPISPParamsNoCRFNoVig_0 _S2236 = PPISPParamsNoCRFNoVig_x24_syn_dadd_0(&_S2234, &_S2235);
    float _S2237;
    float _S2238;
    if(_S2216)
    {
        _S2237 = 0.0f;
        _S2238 = _S2218;
    }
    else
    {
        _S2237 = _S2218;
        _S2238 = 0.0f;
    }
    if(exposure_arithmetic_mean_10)
    {
        DiffPair_float_0 _S2239;
        (&_S2239)->primal_0 = _S2215.exposure_0;
        (&_S2239)->differential_0 = 0.0f;
        s_bwd_prop_exp2_0(&_S2239, _S2237);
        _S2237 = _S2239.differential_0 + _S2238;
    }
    else
    {
        _S2237 = _S2238;
    }
    PPISPParamsNoCRFNoVig_0 _S2240 = _S2217;
    (&_S2240)->exposure_0 = _S2237;
    PPISPParamsNoCRFNoVig_0 _S2241 = _S2236;
    PPISPParamsNoCRFNoVig_0 _S2242 = _S2240;
    PPISPParamsNoCRFNoVig_0 _S2243 = PPISPParamsNoCRFNoVig_x24_syn_dadd_0(&_S2241, &_S2242);
    _S2214 = _S2243;
    *&((&(&(&_S2214)->color_params_0)->n_0)->y) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->n_0)->x) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->g_0)->y) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->g_0)->x) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->r_0)->y) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->r_0)->x) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->b_0)->y) = 0.0f;
    *&((&(&(&_S2214)->color_params_0)->b_0)->x) = 0.0f;
    FixedArray<float, 9>  _S2244;
    _S2244[int(0)] = 0.0f;
    _S2244[int(1)] = 0.0f;
    _S2244[int(2)] = 0.0f;
    _S2244[int(3)] = 0.0f;
    _S2244[int(4)] = 0.0f;
    _S2244[int(5)] = 0.0f;
    _S2244[int(6)] = 0.0f;
    _S2244[int(7)] = 0.0f;
    _S2244[int(8)] = 0.0f;
    _S2244[int(8)] = _S2243.color_params_0.n_0.y;
    _S2244[int(7)] = _S2243.color_params_0.n_0.x;
    _S2244[int(6)] = _S2243.color_params_0.g_0.y;
    _S2244[int(5)] = _S2243.color_params_0.g_0.x;
    _S2244[int(4)] = _S2243.color_params_0.r_0.y;
    _S2244[int(3)] = _S2243.color_params_0.r_0.x;
    _S2244[int(2)] = _S2243.color_params_0.b_0.y;
    _S2244[int(1)] = _S2243.color_params_0.b_0.x;
    _S2244[int(0)] = _S2214.exposure_0;
    dpparams_7->primal_0 = dpparams_7->primal_0;
    dpparams_7->differential_0 = _S2244;
    return;
}

inline __device__ void s_bwd_compute_raw_ppisp_no_crf_no_vig_regularization_loss_0(DiffPair_arrayx3Cfloatx2C9x3E_0 * _S2245, bool _S2246, FixedArray<float, 9>  * _S2247)
{
    s_bwd_prop_compute_raw_ppisp_no_crf_no_vig_regularization_loss_0(_S2245, _S2246, _S2247);
    return;
}

inline __device__ void compute_raw_ppisp_no_crf_no_vig_regularization_loss_vjp(FixedArray<float, 9>  params_15, bool exposure_arithmetic_mean_11, FixedArray<float, 9>  grad_out_7, FixedArray<float, 9>  * _S2248)
{
    FixedArray<float, 9>  _S2249 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C9x3E_0 dp_params_7;
    (&dp_params_7)->primal_0 = params_15;
    (&dp_params_7)->differential_0 = _S2249;
    FixedArray<float, 9>  _S2250 = grad_out_7;
    s_bwd_compute_raw_ppisp_no_crf_no_vig_regularization_loss_0(&dp_params_7, exposure_arithmetic_mean_11, &_S2250);
    *_S2248 = (&dp_params_7)->differential_0;
    return;
}

inline __device__ void _d_log2_0(DiffPair_float_0 * dpx_10, float dOut_14)
{
    float _S2251 = 1.0f / ((*dpx_10).primal_0 * 0.69314718246459961f) * dOut_14;
    dpx_10->primal_0 = (*dpx_10).primal_0;
    dpx_10->differential_0 = _S2251;
    return;
}

inline __device__ void compute_ppisp_regularization_loss(FixedArray<float, 22>  raw_losses_0, int num_cameras_0, bool exposure_arithmetic_mean_12, FixedArray<float, 6>  loss_weights_0, FixedArray<float, 6>  * _S2252)
{
    float mean_48;
    float _S2253;
    FixedArray<float, 6>  losses_4;
    for(;;)
    {
        float _S2254 = float(num_cameras_0);
        _S2253 = _S2254;
        float mean_49 = raw_losses_0[int(0)] / _S2254;
        if(exposure_arithmetic_mean_12)
        {
            mean_48 = (F32_log2((mean_49)));
        }
        else
        {
            mean_48 = mean_49;
        }
        for(;;)
        {
            float _S2255 = (F32_abs((mean_48)));
            if(_S2255 < 0.10000000149011612f)
            {
                mean_48 = 0.5f * mean_48 * mean_48 / 0.10000000149011612f;
                break;
            }
            else
            {
                mean_48 = _S2255 - 0.05000000074505806f;
                break;
            }
        }
        break;
    }
    losses_4[int(0)] = mean_48;
    losses_4[int(1)] = raw_losses_0[int(1)] / (3.0f * _S2253);
    losses_4[int(2)] = (raw_losses_0[int(2)] + raw_losses_0[int(3)] + raw_losses_0[int(4)]) / (9.0f * _S2253);
    losses_4[int(3)] = (raw_losses_0[int(5)] + raw_losses_0[int(6)] + raw_losses_0[int(7)] + raw_losses_0[int(8)] + raw_losses_0[int(9)]) / (5.0f * _S2253);
    float _S2256 = raw_losses_0[int(10)] / _S2253;
    for(;;)
    {
        float _S2257 = (F32_abs((_S2256)));
        if(_S2257 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2256 * _S2256 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2257 - 0.00249999994412065f;
            break;
        }
    }
    float _S2258;
    float _S2259 = raw_losses_0[int(11)] / _S2253;
    for(;;)
    {
        float _S2260 = (F32_abs((_S2259)));
        if(_S2260 < 0.00499999988824129f)
        {
            _S2258 = 0.5f * _S2259 * _S2259 / 0.00499999988824129f;
            break;
        }
        else
        {
            _S2258 = _S2260 - 0.00249999994412065f;
            break;
        }
    }
    float _S2261 = mean_48 + _S2258;
    float _S2262 = raw_losses_0[int(12)] / _S2253;
    for(;;)
    {
        float _S2263 = (F32_abs((_S2262)));
        if(_S2263 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2262 * _S2262 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2263 - 0.00249999994412065f;
            break;
        }
    }
    float _S2264 = _S2261 + mean_48;
    float _S2265 = raw_losses_0[int(13)] / _S2253;
    for(;;)
    {
        float _S2266 = (F32_abs((_S2265)));
        if(_S2266 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2265 * _S2265 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2266 - 0.00249999994412065f;
            break;
        }
    }
    float _S2267 = _S2264 + mean_48;
    float _S2268 = raw_losses_0[int(14)] / _S2253;
    for(;;)
    {
        float _S2269 = (F32_abs((_S2268)));
        if(_S2269 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2268 * _S2268 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2269 - 0.00249999994412065f;
            break;
        }
    }
    float _S2270 = _S2267 + mean_48;
    float _S2271 = raw_losses_0[int(15)] / _S2253;
    for(;;)
    {
        float _S2272 = (F32_abs((_S2271)));
        if(_S2272 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2271 * _S2271 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2272 - 0.00249999994412065f;
            break;
        }
    }
    float _S2273 = _S2270 + mean_48;
    float _S2274 = raw_losses_0[int(16)] / _S2253;
    for(;;)
    {
        float _S2275 = (F32_abs((_S2274)));
        if(_S2275 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2274 * _S2274 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2275 - 0.00249999994412065f;
            break;
        }
    }
    float _S2276 = _S2273 + mean_48;
    float _S2277 = raw_losses_0[int(17)] / _S2253;
    for(;;)
    {
        float _S2278 = (F32_abs((_S2277)));
        if(_S2278 < 0.00499999988824129f)
        {
            mean_48 = 0.5f * _S2277 * _S2277 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_48 = _S2278 - 0.00249999994412065f;
            break;
        }
    }
    float _S2279 = (_S2276 + mean_48) / 8.0f;
    float _S2280 = (raw_losses_0[int(18)] + raw_losses_0[int(19)] + raw_losses_0[int(20)] + raw_losses_0[int(21)]) / (4.0f * _S2253);
    losses_4[int(0)] = losses_4[int(0)] * loss_weights_0[int(0)];
    losses_4[int(1)] = losses_4[int(1)] * loss_weights_0[int(1)];
    losses_4[int(2)] = losses_4[int(2)] * loss_weights_0[int(2)];
    losses_4[int(3)] = losses_4[int(3)] * loss_weights_0[int(3)];
    losses_4[int(4)] = _S2279 * loss_weights_0[int(4)];
    losses_4[int(5)] = _S2280 * loss_weights_0[int(5)];
    *_S2252 = losses_4;
    return;
}

inline __device__ void compute_ppisp_rqs_regularization_loss(FixedArray<float, 23>  raw_losses_1, int num_cameras_1, bool exposure_arithmetic_mean_13, FixedArray<float, 6>  loss_weights_1, FixedArray<float, 6>  * _S2281)
{
    float mean_50;
    float _S2282;
    FixedArray<float, 6>  losses_5;
    for(;;)
    {
        float _S2283 = float(num_cameras_1);
        _S2282 = _S2283;
        float mean_51 = raw_losses_1[int(0)] / _S2283;
        if(exposure_arithmetic_mean_13)
        {
            mean_50 = (F32_log2((mean_51)));
        }
        else
        {
            mean_50 = mean_51;
        }
        for(;;)
        {
            float _S2284 = (F32_abs((mean_50)));
            if(_S2284 < 0.10000000149011612f)
            {
                mean_50 = 0.5f * mean_50 * mean_50 / 0.10000000149011612f;
                break;
            }
            else
            {
                mean_50 = _S2284 - 0.05000000074505806f;
                break;
            }
        }
        break;
    }
    losses_5[int(0)] = mean_50;
    losses_5[int(1)] = raw_losses_1[int(1)] / (3.0f * _S2282);
    losses_5[int(2)] = (raw_losses_1[int(2)] + raw_losses_1[int(3)] + raw_losses_1[int(4)]) / (9.0f * _S2282);
    float _S2285 = 5.0f * _S2282;
    losses_5[int(3)] = (raw_losses_1[int(5)] + raw_losses_1[int(6)] + raw_losses_1[int(7)] + raw_losses_1[int(8)] + raw_losses_1[int(9)]) / _S2285;
    float _S2286 = raw_losses_1[int(10)] / _S2282;
    for(;;)
    {
        float _S2287 = (F32_abs((_S2286)));
        if(_S2287 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2286 * _S2286 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2287 - 0.00249999994412065f;
            break;
        }
    }
    float _S2288;
    float _S2289 = raw_losses_1[int(11)] / _S2282;
    for(;;)
    {
        float _S2290 = (F32_abs((_S2289)));
        if(_S2290 < 0.00499999988824129f)
        {
            _S2288 = 0.5f * _S2289 * _S2289 / 0.00499999988824129f;
            break;
        }
        else
        {
            _S2288 = _S2290 - 0.00249999994412065f;
            break;
        }
    }
    float _S2291 = mean_50 + _S2288;
    float _S2292 = raw_losses_1[int(12)] / _S2282;
    for(;;)
    {
        float _S2293 = (F32_abs((_S2292)));
        if(_S2293 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2292 * _S2292 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2293 - 0.00249999994412065f;
            break;
        }
    }
    float _S2294 = _S2291 + mean_50;
    float _S2295 = raw_losses_1[int(13)] / _S2282;
    for(;;)
    {
        float _S2296 = (F32_abs((_S2295)));
        if(_S2296 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2295 * _S2295 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2296 - 0.00249999994412065f;
            break;
        }
    }
    float _S2297 = _S2294 + mean_50;
    float _S2298 = raw_losses_1[int(14)] / _S2282;
    for(;;)
    {
        float _S2299 = (F32_abs((_S2298)));
        if(_S2299 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2298 * _S2298 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2299 - 0.00249999994412065f;
            break;
        }
    }
    float _S2300 = _S2297 + mean_50;
    float _S2301 = raw_losses_1[int(15)] / _S2282;
    for(;;)
    {
        float _S2302 = (F32_abs((_S2301)));
        if(_S2302 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2301 * _S2301 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2302 - 0.00249999994412065f;
            break;
        }
    }
    float _S2303 = _S2300 + mean_50;
    float _S2304 = raw_losses_1[int(16)] / _S2282;
    for(;;)
    {
        float _S2305 = (F32_abs((_S2304)));
        if(_S2305 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2304 * _S2304 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2305 - 0.00249999994412065f;
            break;
        }
    }
    float _S2306 = _S2303 + mean_50;
    float _S2307 = raw_losses_1[int(17)] / _S2282;
    for(;;)
    {
        float _S2308 = (F32_abs((_S2307)));
        if(_S2308 < 0.00499999988824129f)
        {
            mean_50 = 0.5f * _S2307 * _S2307 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_50 = _S2308 - 0.00249999994412065f;
            break;
        }
    }
    float _S2309 = (_S2306 + mean_50) / 8.0f;
    float _S2310 = (raw_losses_1[int(18)] + raw_losses_1[int(19)] + raw_losses_1[int(20)] + raw_losses_1[int(21)] + raw_losses_1[int(22)]) / _S2285;
    losses_5[int(0)] = losses_5[int(0)] * loss_weights_1[int(0)];
    losses_5[int(1)] = losses_5[int(1)] * loss_weights_1[int(1)];
    losses_5[int(2)] = losses_5[int(2)] * loss_weights_1[int(2)];
    losses_5[int(3)] = losses_5[int(3)] * loss_weights_1[int(3)];
    losses_5[int(4)] = _S2309 * loss_weights_1[int(4)];
    losses_5[int(5)] = _S2310 * loss_weights_1[int(5)];
    *_S2281 = losses_5;
    return;
}

struct DiffPair_arrayx3Cfloatx2C22x3E_0
{
    FixedArray<float, 22>  primal_0;
    FixedArray<float, 22>  differential_0;
};

inline __device__ float s_primal_ctx_log2_0(float _S2311)
{
    return (F32_log2((_S2311)));
}

inline __device__ void s_bwd_prop_log2_0(DiffPair_float_0 * _S2312, float _S2313)
{
    _d_log2_0(_S2312, _S2313);
    return;
}

inline __device__ void s_bwd_prop_compute_ppisp_regularization_loss_0(DiffPair_arrayx3Cfloatx2C22x3E_0 * dpraw_losses_0, int num_cameras_2, bool exposure_arithmetic_mean_14, FixedArray<float, 6>  * loss_weights_2, FixedArray<float, 6>  * _s_dOut_8)
{
    FixedArray<float, 22>  _S2314 = dpraw_losses_0->primal_0;
    float _S2315 = float(num_cameras_2);
    float mean_52 = dpraw_losses_0->primal_0[int(0)] / _S2315;
    float mean_53;
    if(exposure_arithmetic_mean_14)
    {
        mean_53 = s_primal_ctx_log2_0(mean_52);
    }
    else
    {
        mean_53 = mean_52;
    }
    bool _S2316 = (s_primal_ctx_abs_0(mean_53)) < 0.10000000149011612f;
    float _S2317;
    if(_S2316)
    {
        _S2317 = 0.5f * mean_53;
    }
    else
    {
        _S2317 = 0.0f;
    }
    float _S2318 = 3.0f * _S2315;
    float _S2319 = 9.0f * _S2315;
    float _S2320 = 5.0f * _S2315;
    float _S2321 = _S2314[int(10)] / _S2315;
    bool _S2322 = (s_primal_ctx_abs_0(_S2321)) < 0.00499999988824129f;
    float _S2323;
    if(_S2322)
    {
        _S2323 = 0.5f * _S2321;
    }
    else
    {
        _S2323 = 0.0f;
    }
    float _S2324 = _S2314[int(11)] / _S2315;
    bool _S2325 = (s_primal_ctx_abs_0(_S2324)) < 0.00499999988824129f;
    float _S2326;
    if(_S2325)
    {
        _S2326 = 0.5f * _S2324;
    }
    else
    {
        _S2326 = 0.0f;
    }
    float _S2327 = _S2314[int(12)] / _S2315;
    bool _S2328 = (s_primal_ctx_abs_0(_S2327)) < 0.00499999988824129f;
    float _S2329;
    if(_S2328)
    {
        _S2329 = 0.5f * _S2327;
    }
    else
    {
        _S2329 = 0.0f;
    }
    float _S2330 = _S2314[int(13)] / _S2315;
    bool _S2331 = (s_primal_ctx_abs_0(_S2330)) < 0.00499999988824129f;
    float _S2332;
    if(_S2331)
    {
        _S2332 = 0.5f * _S2330;
    }
    else
    {
        _S2332 = 0.0f;
    }
    float _S2333 = _S2314[int(14)] / _S2315;
    bool _S2334 = (s_primal_ctx_abs_0(_S2333)) < 0.00499999988824129f;
    float _S2335;
    if(_S2334)
    {
        _S2335 = 0.5f * _S2333;
    }
    else
    {
        _S2335 = 0.0f;
    }
    float _S2336 = _S2314[int(15)] / _S2315;
    bool _S2337 = (s_primal_ctx_abs_0(_S2336)) < 0.00499999988824129f;
    float _S2338;
    if(_S2337)
    {
        _S2338 = 0.5f * _S2336;
    }
    else
    {
        _S2338 = 0.0f;
    }
    float _S2339 = _S2314[int(16)] / _S2315;
    bool _S2340 = (s_primal_ctx_abs_0(_S2339)) < 0.00499999988824129f;
    float _S2341;
    if(_S2340)
    {
        _S2341 = 0.5f * _S2339;
    }
    else
    {
        _S2341 = 0.0f;
    }
    float _S2342 = _S2314[int(17)] / _S2315;
    bool _S2343 = (s_primal_ctx_abs_0(_S2342)) < 0.00499999988824129f;
    float _S2344;
    if(_S2343)
    {
        _S2344 = 0.5f * _S2342;
    }
    else
    {
        _S2344 = 0.0f;
    }
    float _S2345 = (*loss_weights_2)[int(3)] * (*_s_dOut_8)[int(3)];
    float _S2346 = (*loss_weights_2)[int(2)] * (*_s_dOut_8)[int(2)];
    float _S2347 = (*loss_weights_2)[int(1)] * (*_s_dOut_8)[int(1)];
    float _S2348 = (*loss_weights_2)[int(0)] * (*_s_dOut_8)[int(0)];
    float _S2349 = (*loss_weights_2)[int(5)] * (*_s_dOut_8)[int(5)] / (4.0f * _S2315);
    float _S2350 = 0.125f * ((*loss_weights_2)[int(4)] * (*_s_dOut_8)[int(4)]);
    FixedArray<float, 22>  _S2351;
    _S2351[int(0)] = 0.0f;
    _S2351[int(1)] = 0.0f;
    _S2351[int(2)] = 0.0f;
    _S2351[int(3)] = 0.0f;
    _S2351[int(4)] = 0.0f;
    _S2351[int(5)] = 0.0f;
    _S2351[int(6)] = 0.0f;
    _S2351[int(7)] = 0.0f;
    _S2351[int(8)] = 0.0f;
    _S2351[int(9)] = 0.0f;
    _S2351[int(10)] = 0.0f;
    _S2351[int(11)] = 0.0f;
    _S2351[int(12)] = 0.0f;
    _S2351[int(13)] = 0.0f;
    _S2351[int(14)] = 0.0f;
    _S2351[int(15)] = 0.0f;
    _S2351[int(16)] = 0.0f;
    _S2351[int(17)] = 0.0f;
    _S2351[int(18)] = 0.0f;
    _S2351[int(19)] = 0.0f;
    _S2351[int(20)] = 0.0f;
    _S2351[int(21)] = 0.0f;
    _S2351[int(21)] = _S2349;
    _S2351[int(20)] = _S2349;
    _S2351[int(19)] = _S2349;
    _S2351[int(18)] = _S2349;
    float _S2352 = _S2351[int(0)];
    float _S2353 = _S2351[int(1)];
    float _S2354 = _S2351[int(2)];
    float _S2355 = _S2351[int(3)];
    float _S2356 = _S2351[int(4)];
    float _S2357 = _S2351[int(5)];
    float _S2358 = _S2351[int(6)];
    float _S2359 = _S2351[int(7)];
    float _S2360 = _S2351[int(8)];
    float _S2361 = _S2351[int(9)];
    float _S2362 = _S2351[int(10)];
    float _S2363 = _S2351[int(11)];
    float _S2364 = _S2351[int(12)];
    float _S2365 = _S2351[int(13)];
    float _S2366 = _S2351[int(14)];
    float _S2367 = _S2351[int(15)];
    float _S2368 = _S2351[int(16)];
    float _S2369 = _S2351[int(17)];
    float _S2370 = _S2351[int(18)];
    float _S2371 = _S2351[int(19)];
    float _S2372 = _S2351[int(20)];
    float _S2373 = _S2351[int(21)];
    float _S2374;
    if(_S2343)
    {
        float _S2375 = 200.0f * _S2350;
        float _S2376 = _S2344 * _S2375 + 0.5f * (_S2342 * _S2375);
        _S2344 = 0.0f;
        _S2374 = _S2376;
    }
    else
    {
        _S2344 = _S2350;
        _S2374 = 0.0f;
    }
    DiffPair_float_0 _S2377;
    (&_S2377)->primal_0 = _S2342;
    (&_S2377)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2377, _S2344);
    float _S2378 = (_S2377.differential_0 + _S2374) / _S2315;
    FixedArray<float, 22>  _S2379;
    _S2379[int(0)] = 0.0f;
    _S2379[int(1)] = 0.0f;
    _S2379[int(2)] = 0.0f;
    _S2379[int(3)] = 0.0f;
    _S2379[int(4)] = 0.0f;
    _S2379[int(5)] = 0.0f;
    _S2379[int(6)] = 0.0f;
    _S2379[int(7)] = 0.0f;
    _S2379[int(8)] = 0.0f;
    _S2379[int(9)] = 0.0f;
    _S2379[int(10)] = 0.0f;
    _S2379[int(11)] = 0.0f;
    _S2379[int(12)] = 0.0f;
    _S2379[int(13)] = 0.0f;
    _S2379[int(14)] = 0.0f;
    _S2379[int(15)] = 0.0f;
    _S2379[int(16)] = 0.0f;
    _S2379[int(17)] = 0.0f;
    _S2379[int(18)] = 0.0f;
    _S2379[int(19)] = 0.0f;
    _S2379[int(20)] = 0.0f;
    _S2379[int(21)] = 0.0f;
    _S2379[int(17)] = _S2378;
    float _S2380 = _S2352 + _S2379[int(0)];
    float _S2381 = _S2353 + _S2379[int(1)];
    float _S2382 = _S2354 + _S2379[int(2)];
    float _S2383 = _S2355 + _S2379[int(3)];
    float _S2384 = _S2356 + _S2379[int(4)];
    float _S2385 = _S2357 + _S2379[int(5)];
    float _S2386 = _S2358 + _S2379[int(6)];
    float _S2387 = _S2359 + _S2379[int(7)];
    float _S2388 = _S2360 + _S2379[int(8)];
    float _S2389 = _S2361 + _S2379[int(9)];
    float _S2390 = _S2362 + _S2379[int(10)];
    float _S2391 = _S2363 + _S2379[int(11)];
    float _S2392 = _S2364 + _S2379[int(12)];
    float _S2393 = _S2365 + _S2379[int(13)];
    float _S2394 = _S2366 + _S2379[int(14)];
    float _S2395 = _S2367 + _S2379[int(15)];
    float _S2396 = _S2368 + _S2379[int(16)];
    float _S2397 = _S2369 + _S2379[int(17)];
    float _S2398 = _S2370 + _S2379[int(18)];
    float _S2399 = _S2371 + _S2379[int(19)];
    float _S2400 = _S2372 + _S2379[int(20)];
    float _S2401 = _S2373 + _S2379[int(21)];
    if(_S2340)
    {
        float _S2402 = 200.0f * _S2350;
        float _S2403 = _S2341 * _S2402 + 0.5f * (_S2339 * _S2402);
        _S2341 = 0.0f;
        _S2344 = _S2403;
    }
    else
    {
        _S2341 = _S2350;
        _S2344 = 0.0f;
    }
    DiffPair_float_0 _S2404;
    (&_S2404)->primal_0 = _S2339;
    (&_S2404)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2404, _S2341);
    float _S2405 = (_S2404.differential_0 + _S2344) / _S2315;
    FixedArray<float, 22>  _S2406;
    _S2406[int(0)] = 0.0f;
    _S2406[int(1)] = 0.0f;
    _S2406[int(2)] = 0.0f;
    _S2406[int(3)] = 0.0f;
    _S2406[int(4)] = 0.0f;
    _S2406[int(5)] = 0.0f;
    _S2406[int(6)] = 0.0f;
    _S2406[int(7)] = 0.0f;
    _S2406[int(8)] = 0.0f;
    _S2406[int(9)] = 0.0f;
    _S2406[int(10)] = 0.0f;
    _S2406[int(11)] = 0.0f;
    _S2406[int(12)] = 0.0f;
    _S2406[int(13)] = 0.0f;
    _S2406[int(14)] = 0.0f;
    _S2406[int(15)] = 0.0f;
    _S2406[int(16)] = 0.0f;
    _S2406[int(17)] = 0.0f;
    _S2406[int(18)] = 0.0f;
    _S2406[int(19)] = 0.0f;
    _S2406[int(20)] = 0.0f;
    _S2406[int(21)] = 0.0f;
    _S2406[int(16)] = _S2405;
    float _S2407 = _S2380 + _S2406[int(0)];
    float _S2408 = _S2381 + _S2406[int(1)];
    float _S2409 = _S2382 + _S2406[int(2)];
    float _S2410 = _S2383 + _S2406[int(3)];
    float _S2411 = _S2384 + _S2406[int(4)];
    float _S2412 = _S2385 + _S2406[int(5)];
    float _S2413 = _S2386 + _S2406[int(6)];
    float _S2414 = _S2387 + _S2406[int(7)];
    float _S2415 = _S2388 + _S2406[int(8)];
    float _S2416 = _S2389 + _S2406[int(9)];
    float _S2417 = _S2390 + _S2406[int(10)];
    float _S2418 = _S2391 + _S2406[int(11)];
    float _S2419 = _S2392 + _S2406[int(12)];
    float _S2420 = _S2393 + _S2406[int(13)];
    float _S2421 = _S2394 + _S2406[int(14)];
    float _S2422 = _S2395 + _S2406[int(15)];
    float _S2423 = _S2396 + _S2406[int(16)];
    float _S2424 = _S2397 + _S2406[int(17)];
    float _S2425 = _S2398 + _S2406[int(18)];
    float _S2426 = _S2399 + _S2406[int(19)];
    float _S2427 = _S2400 + _S2406[int(20)];
    float _S2428 = _S2401 + _S2406[int(21)];
    if(_S2337)
    {
        float _S2429 = 200.0f * _S2350;
        float _S2430 = _S2338 * _S2429 + 0.5f * (_S2336 * _S2429);
        _S2338 = 0.0f;
        _S2341 = _S2430;
    }
    else
    {
        _S2338 = _S2350;
        _S2341 = 0.0f;
    }
    DiffPair_float_0 _S2431;
    (&_S2431)->primal_0 = _S2336;
    (&_S2431)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2431, _S2338);
    float _S2432 = (_S2431.differential_0 + _S2341) / _S2315;
    FixedArray<float, 22>  _S2433;
    _S2433[int(0)] = 0.0f;
    _S2433[int(1)] = 0.0f;
    _S2433[int(2)] = 0.0f;
    _S2433[int(3)] = 0.0f;
    _S2433[int(4)] = 0.0f;
    _S2433[int(5)] = 0.0f;
    _S2433[int(6)] = 0.0f;
    _S2433[int(7)] = 0.0f;
    _S2433[int(8)] = 0.0f;
    _S2433[int(9)] = 0.0f;
    _S2433[int(10)] = 0.0f;
    _S2433[int(11)] = 0.0f;
    _S2433[int(12)] = 0.0f;
    _S2433[int(13)] = 0.0f;
    _S2433[int(14)] = 0.0f;
    _S2433[int(15)] = 0.0f;
    _S2433[int(16)] = 0.0f;
    _S2433[int(17)] = 0.0f;
    _S2433[int(18)] = 0.0f;
    _S2433[int(19)] = 0.0f;
    _S2433[int(20)] = 0.0f;
    _S2433[int(21)] = 0.0f;
    _S2433[int(15)] = _S2432;
    float _S2434 = _S2407 + _S2433[int(0)];
    float _S2435 = _S2408 + _S2433[int(1)];
    float _S2436 = _S2409 + _S2433[int(2)];
    float _S2437 = _S2410 + _S2433[int(3)];
    float _S2438 = _S2411 + _S2433[int(4)];
    float _S2439 = _S2412 + _S2433[int(5)];
    float _S2440 = _S2413 + _S2433[int(6)];
    float _S2441 = _S2414 + _S2433[int(7)];
    float _S2442 = _S2415 + _S2433[int(8)];
    float _S2443 = _S2416 + _S2433[int(9)];
    float _S2444 = _S2417 + _S2433[int(10)];
    float _S2445 = _S2418 + _S2433[int(11)];
    float _S2446 = _S2419 + _S2433[int(12)];
    float _S2447 = _S2420 + _S2433[int(13)];
    float _S2448 = _S2421 + _S2433[int(14)];
    float _S2449 = _S2422 + _S2433[int(15)];
    float _S2450 = _S2423 + _S2433[int(16)];
    float _S2451 = _S2424 + _S2433[int(17)];
    float _S2452 = _S2425 + _S2433[int(18)];
    float _S2453 = _S2426 + _S2433[int(19)];
    float _S2454 = _S2427 + _S2433[int(20)];
    float _S2455 = _S2428 + _S2433[int(21)];
    if(_S2334)
    {
        float _S2456 = 200.0f * _S2350;
        float _S2457 = _S2335 * _S2456 + 0.5f * (_S2333 * _S2456);
        _S2335 = 0.0f;
        _S2338 = _S2457;
    }
    else
    {
        _S2335 = _S2350;
        _S2338 = 0.0f;
    }
    DiffPair_float_0 _S2458;
    (&_S2458)->primal_0 = _S2333;
    (&_S2458)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2458, _S2335);
    float _S2459 = (_S2458.differential_0 + _S2338) / _S2315;
    FixedArray<float, 22>  _S2460;
    _S2460[int(0)] = 0.0f;
    _S2460[int(1)] = 0.0f;
    _S2460[int(2)] = 0.0f;
    _S2460[int(3)] = 0.0f;
    _S2460[int(4)] = 0.0f;
    _S2460[int(5)] = 0.0f;
    _S2460[int(6)] = 0.0f;
    _S2460[int(7)] = 0.0f;
    _S2460[int(8)] = 0.0f;
    _S2460[int(9)] = 0.0f;
    _S2460[int(10)] = 0.0f;
    _S2460[int(11)] = 0.0f;
    _S2460[int(12)] = 0.0f;
    _S2460[int(13)] = 0.0f;
    _S2460[int(14)] = 0.0f;
    _S2460[int(15)] = 0.0f;
    _S2460[int(16)] = 0.0f;
    _S2460[int(17)] = 0.0f;
    _S2460[int(18)] = 0.0f;
    _S2460[int(19)] = 0.0f;
    _S2460[int(20)] = 0.0f;
    _S2460[int(21)] = 0.0f;
    _S2460[int(14)] = _S2459;
    float _S2461 = _S2434 + _S2460[int(0)];
    float _S2462 = _S2435 + _S2460[int(1)];
    float _S2463 = _S2436 + _S2460[int(2)];
    float _S2464 = _S2437 + _S2460[int(3)];
    float _S2465 = _S2438 + _S2460[int(4)];
    float _S2466 = _S2439 + _S2460[int(5)];
    float _S2467 = _S2440 + _S2460[int(6)];
    float _S2468 = _S2441 + _S2460[int(7)];
    float _S2469 = _S2442 + _S2460[int(8)];
    float _S2470 = _S2443 + _S2460[int(9)];
    float _S2471 = _S2444 + _S2460[int(10)];
    float _S2472 = _S2445 + _S2460[int(11)];
    float _S2473 = _S2446 + _S2460[int(12)];
    float _S2474 = _S2447 + _S2460[int(13)];
    float _S2475 = _S2448 + _S2460[int(14)];
    float _S2476 = _S2449 + _S2460[int(15)];
    float _S2477 = _S2450 + _S2460[int(16)];
    float _S2478 = _S2451 + _S2460[int(17)];
    float _S2479 = _S2452 + _S2460[int(18)];
    float _S2480 = _S2453 + _S2460[int(19)];
    float _S2481 = _S2454 + _S2460[int(20)];
    float _S2482 = _S2455 + _S2460[int(21)];
    if(_S2331)
    {
        float _S2483 = 200.0f * _S2350;
        float _S2484 = _S2332 * _S2483 + 0.5f * (_S2330 * _S2483);
        _S2332 = 0.0f;
        _S2335 = _S2484;
    }
    else
    {
        _S2332 = _S2350;
        _S2335 = 0.0f;
    }
    DiffPair_float_0 _S2485;
    (&_S2485)->primal_0 = _S2330;
    (&_S2485)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2485, _S2332);
    float _S2486 = (_S2485.differential_0 + _S2335) / _S2315;
    FixedArray<float, 22>  _S2487;
    _S2487[int(0)] = 0.0f;
    _S2487[int(1)] = 0.0f;
    _S2487[int(2)] = 0.0f;
    _S2487[int(3)] = 0.0f;
    _S2487[int(4)] = 0.0f;
    _S2487[int(5)] = 0.0f;
    _S2487[int(6)] = 0.0f;
    _S2487[int(7)] = 0.0f;
    _S2487[int(8)] = 0.0f;
    _S2487[int(9)] = 0.0f;
    _S2487[int(10)] = 0.0f;
    _S2487[int(11)] = 0.0f;
    _S2487[int(12)] = 0.0f;
    _S2487[int(13)] = 0.0f;
    _S2487[int(14)] = 0.0f;
    _S2487[int(15)] = 0.0f;
    _S2487[int(16)] = 0.0f;
    _S2487[int(17)] = 0.0f;
    _S2487[int(18)] = 0.0f;
    _S2487[int(19)] = 0.0f;
    _S2487[int(20)] = 0.0f;
    _S2487[int(21)] = 0.0f;
    _S2487[int(13)] = _S2486;
    float _S2488 = _S2461 + _S2487[int(0)];
    float _S2489 = _S2462 + _S2487[int(1)];
    float _S2490 = _S2463 + _S2487[int(2)];
    float _S2491 = _S2464 + _S2487[int(3)];
    float _S2492 = _S2465 + _S2487[int(4)];
    float _S2493 = _S2466 + _S2487[int(5)];
    float _S2494 = _S2467 + _S2487[int(6)];
    float _S2495 = _S2468 + _S2487[int(7)];
    float _S2496 = _S2469 + _S2487[int(8)];
    float _S2497 = _S2470 + _S2487[int(9)];
    float _S2498 = _S2471 + _S2487[int(10)];
    float _S2499 = _S2472 + _S2487[int(11)];
    float _S2500 = _S2473 + _S2487[int(12)];
    float _S2501 = _S2474 + _S2487[int(13)];
    float _S2502 = _S2475 + _S2487[int(14)];
    float _S2503 = _S2476 + _S2487[int(15)];
    float _S2504 = _S2477 + _S2487[int(16)];
    float _S2505 = _S2478 + _S2487[int(17)];
    float _S2506 = _S2479 + _S2487[int(18)];
    float _S2507 = _S2480 + _S2487[int(19)];
    float _S2508 = _S2481 + _S2487[int(20)];
    float _S2509 = _S2482 + _S2487[int(21)];
    if(_S2328)
    {
        float _S2510 = 200.0f * _S2350;
        float _S2511 = _S2329 * _S2510 + 0.5f * (_S2327 * _S2510);
        _S2329 = 0.0f;
        _S2332 = _S2511;
    }
    else
    {
        _S2329 = _S2350;
        _S2332 = 0.0f;
    }
    DiffPair_float_0 _S2512;
    (&_S2512)->primal_0 = _S2327;
    (&_S2512)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2512, _S2329);
    float _S2513 = (_S2512.differential_0 + _S2332) / _S2315;
    FixedArray<float, 22>  _S2514;
    _S2514[int(0)] = 0.0f;
    _S2514[int(1)] = 0.0f;
    _S2514[int(2)] = 0.0f;
    _S2514[int(3)] = 0.0f;
    _S2514[int(4)] = 0.0f;
    _S2514[int(5)] = 0.0f;
    _S2514[int(6)] = 0.0f;
    _S2514[int(7)] = 0.0f;
    _S2514[int(8)] = 0.0f;
    _S2514[int(9)] = 0.0f;
    _S2514[int(10)] = 0.0f;
    _S2514[int(11)] = 0.0f;
    _S2514[int(12)] = 0.0f;
    _S2514[int(13)] = 0.0f;
    _S2514[int(14)] = 0.0f;
    _S2514[int(15)] = 0.0f;
    _S2514[int(16)] = 0.0f;
    _S2514[int(17)] = 0.0f;
    _S2514[int(18)] = 0.0f;
    _S2514[int(19)] = 0.0f;
    _S2514[int(20)] = 0.0f;
    _S2514[int(21)] = 0.0f;
    _S2514[int(12)] = _S2513;
    float _S2515 = _S2488 + _S2514[int(0)];
    float _S2516 = _S2489 + _S2514[int(1)];
    float _S2517 = _S2490 + _S2514[int(2)];
    float _S2518 = _S2491 + _S2514[int(3)];
    float _S2519 = _S2492 + _S2514[int(4)];
    float _S2520 = _S2493 + _S2514[int(5)];
    float _S2521 = _S2494 + _S2514[int(6)];
    float _S2522 = _S2495 + _S2514[int(7)];
    float _S2523 = _S2496 + _S2514[int(8)];
    float _S2524 = _S2497 + _S2514[int(9)];
    float _S2525 = _S2498 + _S2514[int(10)];
    float _S2526 = _S2499 + _S2514[int(11)];
    float _S2527 = _S2500 + _S2514[int(12)];
    float _S2528 = _S2501 + _S2514[int(13)];
    float _S2529 = _S2502 + _S2514[int(14)];
    float _S2530 = _S2503 + _S2514[int(15)];
    float _S2531 = _S2504 + _S2514[int(16)];
    float _S2532 = _S2505 + _S2514[int(17)];
    float _S2533 = _S2506 + _S2514[int(18)];
    float _S2534 = _S2507 + _S2514[int(19)];
    float _S2535 = _S2508 + _S2514[int(20)];
    float _S2536 = _S2509 + _S2514[int(21)];
    if(_S2325)
    {
        float _S2537 = 200.0f * _S2350;
        float _S2538 = _S2326 * _S2537 + 0.5f * (_S2324 * _S2537);
        _S2326 = 0.0f;
        _S2329 = _S2538;
    }
    else
    {
        _S2326 = _S2350;
        _S2329 = 0.0f;
    }
    DiffPair_float_0 _S2539;
    (&_S2539)->primal_0 = _S2324;
    (&_S2539)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2539, _S2326);
    float _S2540 = (_S2539.differential_0 + _S2329) / _S2315;
    FixedArray<float, 22>  _S2541;
    _S2541[int(0)] = 0.0f;
    _S2541[int(1)] = 0.0f;
    _S2541[int(2)] = 0.0f;
    _S2541[int(3)] = 0.0f;
    _S2541[int(4)] = 0.0f;
    _S2541[int(5)] = 0.0f;
    _S2541[int(6)] = 0.0f;
    _S2541[int(7)] = 0.0f;
    _S2541[int(8)] = 0.0f;
    _S2541[int(9)] = 0.0f;
    _S2541[int(10)] = 0.0f;
    _S2541[int(11)] = 0.0f;
    _S2541[int(12)] = 0.0f;
    _S2541[int(13)] = 0.0f;
    _S2541[int(14)] = 0.0f;
    _S2541[int(15)] = 0.0f;
    _S2541[int(16)] = 0.0f;
    _S2541[int(17)] = 0.0f;
    _S2541[int(18)] = 0.0f;
    _S2541[int(19)] = 0.0f;
    _S2541[int(20)] = 0.0f;
    _S2541[int(21)] = 0.0f;
    _S2541[int(11)] = _S2540;
    float _S2542 = _S2515 + _S2541[int(0)];
    float _S2543 = _S2516 + _S2541[int(1)];
    float _S2544 = _S2517 + _S2541[int(2)];
    float _S2545 = _S2518 + _S2541[int(3)];
    float _S2546 = _S2519 + _S2541[int(4)];
    float _S2547 = _S2520 + _S2541[int(5)];
    float _S2548 = _S2521 + _S2541[int(6)];
    float _S2549 = _S2522 + _S2541[int(7)];
    float _S2550 = _S2523 + _S2541[int(8)];
    float _S2551 = _S2524 + _S2541[int(9)];
    float _S2552 = _S2525 + _S2541[int(10)];
    float _S2553 = _S2526 + _S2541[int(11)];
    float _S2554 = _S2527 + _S2541[int(12)];
    float _S2555 = _S2528 + _S2541[int(13)];
    float _S2556 = _S2529 + _S2541[int(14)];
    float _S2557 = _S2530 + _S2541[int(15)];
    float _S2558 = _S2531 + _S2541[int(16)];
    float _S2559 = _S2532 + _S2541[int(17)];
    float _S2560 = _S2533 + _S2541[int(18)];
    float _S2561 = _S2534 + _S2541[int(19)];
    float _S2562 = _S2535 + _S2541[int(20)];
    float _S2563 = _S2536 + _S2541[int(21)];
    if(_S2322)
    {
        float _S2564 = 200.0f * _S2350;
        float _S2565 = _S2323 * _S2564 + 0.5f * (_S2321 * _S2564);
        _S2323 = 0.0f;
        _S2326 = _S2565;
    }
    else
    {
        _S2323 = _S2350;
        _S2326 = 0.0f;
    }
    DiffPair_float_0 _S2566;
    (&_S2566)->primal_0 = _S2321;
    (&_S2566)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2566, _S2323);
    float _S2567 = (_S2566.differential_0 + _S2326) / _S2315;
    float _S2568 = _S2345 / _S2320;
    float _S2569 = _S2346 / _S2319;
    float _S2570 = _S2347 / _S2318;
    FixedArray<float, 22>  _S2571;
    _S2571[int(0)] = 0.0f;
    _S2571[int(1)] = 0.0f;
    _S2571[int(2)] = 0.0f;
    _S2571[int(3)] = 0.0f;
    _S2571[int(4)] = 0.0f;
    _S2571[int(5)] = 0.0f;
    _S2571[int(6)] = 0.0f;
    _S2571[int(7)] = 0.0f;
    _S2571[int(8)] = 0.0f;
    _S2571[int(9)] = 0.0f;
    _S2571[int(10)] = 0.0f;
    _S2571[int(11)] = 0.0f;
    _S2571[int(12)] = 0.0f;
    _S2571[int(13)] = 0.0f;
    _S2571[int(14)] = 0.0f;
    _S2571[int(15)] = 0.0f;
    _S2571[int(16)] = 0.0f;
    _S2571[int(17)] = 0.0f;
    _S2571[int(18)] = 0.0f;
    _S2571[int(19)] = 0.0f;
    _S2571[int(20)] = 0.0f;
    _S2571[int(21)] = 0.0f;
    _S2571[int(10)] = _S2567;
    _S2571[int(9)] = _S2568;
    _S2571[int(8)] = _S2568;
    _S2571[int(7)] = _S2568;
    _S2571[int(6)] = _S2568;
    _S2571[int(5)] = _S2568;
    _S2571[int(4)] = _S2569;
    _S2571[int(3)] = _S2569;
    _S2571[int(2)] = _S2569;
    _S2571[int(1)] = _S2570;
    float _S2572 = _S2542 + _S2571[int(0)];
    float _S2573 = _S2543 + _S2571[int(1)];
    float _S2574 = _S2544 + _S2571[int(2)];
    float _S2575 = _S2545 + _S2571[int(3)];
    float _S2576 = _S2546 + _S2571[int(4)];
    float _S2577 = _S2547 + _S2571[int(5)];
    float _S2578 = _S2548 + _S2571[int(6)];
    float _S2579 = _S2549 + _S2571[int(7)];
    float _S2580 = _S2550 + _S2571[int(8)];
    float _S2581 = _S2551 + _S2571[int(9)];
    float _S2582 = _S2552 + _S2571[int(10)];
    float _S2583 = _S2553 + _S2571[int(11)];
    float _S2584 = _S2554 + _S2571[int(12)];
    float _S2585 = _S2555 + _S2571[int(13)];
    float _S2586 = _S2556 + _S2571[int(14)];
    float _S2587 = _S2557 + _S2571[int(15)];
    float _S2588 = _S2558 + _S2571[int(16)];
    float _S2589 = _S2559 + _S2571[int(17)];
    float _S2590 = _S2560 + _S2571[int(18)];
    float _S2591 = _S2561 + _S2571[int(19)];
    float _S2592 = _S2562 + _S2571[int(20)];
    float _S2593 = _S2563 + _S2571[int(21)];
    if(_S2316)
    {
        float _S2594 = 10.0f * _S2348;
        float _S2595 = _S2317 * _S2594 + 0.5f * (mean_53 * _S2594);
        _S2317 = 0.0f;
        _S2323 = _S2595;
    }
    else
    {
        _S2317 = _S2348;
        _S2323 = 0.0f;
    }
    DiffPair_float_0 _S2596;
    (&_S2596)->primal_0 = mean_53;
    (&_S2596)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2596, _S2317);
    float _S2597 = _S2596.differential_0 + _S2323;
    if(exposure_arithmetic_mean_14)
    {
        DiffPair_float_0 _S2598;
        (&_S2598)->primal_0 = mean_52;
        (&_S2598)->differential_0 = 0.0f;
        s_bwd_prop_log2_0(&_S2598, _S2597);
        mean_53 = _S2598.differential_0;
    }
    else
    {
        mean_53 = _S2597;
    }
    float _S2599 = mean_53 / _S2315;
    FixedArray<float, 22>  _S2600;
    _S2600[int(0)] = 0.0f;
    _S2600[int(1)] = 0.0f;
    _S2600[int(2)] = 0.0f;
    _S2600[int(3)] = 0.0f;
    _S2600[int(4)] = 0.0f;
    _S2600[int(5)] = 0.0f;
    _S2600[int(6)] = 0.0f;
    _S2600[int(7)] = 0.0f;
    _S2600[int(8)] = 0.0f;
    _S2600[int(9)] = 0.0f;
    _S2600[int(10)] = 0.0f;
    _S2600[int(11)] = 0.0f;
    _S2600[int(12)] = 0.0f;
    _S2600[int(13)] = 0.0f;
    _S2600[int(14)] = 0.0f;
    _S2600[int(15)] = 0.0f;
    _S2600[int(16)] = 0.0f;
    _S2600[int(17)] = 0.0f;
    _S2600[int(18)] = 0.0f;
    _S2600[int(19)] = 0.0f;
    _S2600[int(20)] = 0.0f;
    _S2600[int(21)] = 0.0f;
    _S2600[int(0)] = _S2599;
    FixedArray<float, 22>  _S2601 = {
        _S2572 + _S2600[int(0)], _S2573 + _S2600[int(1)], _S2574 + _S2600[int(2)], _S2575 + _S2600[int(3)], _S2576 + _S2600[int(4)], _S2577 + _S2600[int(5)], _S2578 + _S2600[int(6)], _S2579 + _S2600[int(7)], _S2580 + _S2600[int(8)], _S2581 + _S2600[int(9)], _S2582 + _S2600[int(10)], _S2583 + _S2600[int(11)], _S2584 + _S2600[int(12)], _S2585 + _S2600[int(13)], _S2586 + _S2600[int(14)], _S2587 + _S2600[int(15)], _S2588 + _S2600[int(16)], _S2589 + _S2600[int(17)], _S2590 + _S2600[int(18)], _S2591 + _S2600[int(19)], _S2592 + _S2600[int(20)], _S2593 + _S2600[int(21)]
    };
    dpraw_losses_0->primal_0 = dpraw_losses_0->primal_0;
    dpraw_losses_0->differential_0 = _S2601;
    return;
}

inline __device__ void s_bwd_compute_ppisp_regularization_loss_0(DiffPair_arrayx3Cfloatx2C22x3E_0 * _S2602, int _S2603, bool _S2604, FixedArray<float, 6>  * _S2605, FixedArray<float, 6>  * _S2606)
{
    s_bwd_prop_compute_ppisp_regularization_loss_0(_S2602, _S2603, _S2604, _S2605, _S2606);
    return;
}

inline __device__ void compute_ppisp_regularization_loss_vjp(FixedArray<float, 22>  raw_losses_2, int num_cameras_3, bool exposure_arithmetic_mean_15, FixedArray<float, 6>  loss_weights_3, FixedArray<float, 6>  grad_out_8, FixedArray<float, 22>  * _S2607)
{
    FixedArray<float, 22>  _S2608 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C22x3E_0 dp_raw_losses_0;
    (&dp_raw_losses_0)->primal_0 = raw_losses_2;
    (&dp_raw_losses_0)->differential_0 = _S2608;
    FixedArray<float, 6>  _S2609 = loss_weights_3;
    FixedArray<float, 6>  _S2610 = grad_out_8;
    s_bwd_compute_ppisp_regularization_loss_0(&dp_raw_losses_0, num_cameras_3, exposure_arithmetic_mean_15, &_S2609, &_S2610);
    *_S2607 = (&dp_raw_losses_0)->differential_0;
    return;
}

struct DiffPair_arrayx3Cfloatx2C23x3E_0
{
    FixedArray<float, 23>  primal_0;
    FixedArray<float, 23>  differential_0;
};

inline __device__ void s_bwd_prop_compute_ppisp_rqs_regularization_loss_0(DiffPair_arrayx3Cfloatx2C23x3E_0 * dpraw_losses_1, int num_cameras_4, bool exposure_arithmetic_mean_16, FixedArray<float, 6>  * loss_weights_4, FixedArray<float, 6>  * _s_dOut_9)
{
    FixedArray<float, 23>  _S2611 = dpraw_losses_1->primal_0;
    float _S2612 = float(num_cameras_4);
    float mean_54 = dpraw_losses_1->primal_0[int(0)] / _S2612;
    float mean_55;
    if(exposure_arithmetic_mean_16)
    {
        mean_55 = s_primal_ctx_log2_0(mean_54);
    }
    else
    {
        mean_55 = mean_54;
    }
    bool _S2613 = (s_primal_ctx_abs_0(mean_55)) < 0.10000000149011612f;
    float _S2614;
    if(_S2613)
    {
        _S2614 = 0.5f * mean_55;
    }
    else
    {
        _S2614 = 0.0f;
    }
    float _S2615 = 3.0f * _S2612;
    float _S2616 = 9.0f * _S2612;
    float _S2617 = 5.0f * _S2612;
    float _S2618 = _S2611[int(10)] / _S2612;
    bool _S2619 = (s_primal_ctx_abs_0(_S2618)) < 0.00499999988824129f;
    float _S2620;
    if(_S2619)
    {
        _S2620 = 0.5f * _S2618;
    }
    else
    {
        _S2620 = 0.0f;
    }
    float _S2621 = _S2611[int(11)] / _S2612;
    bool _S2622 = (s_primal_ctx_abs_0(_S2621)) < 0.00499999988824129f;
    float _S2623;
    if(_S2622)
    {
        _S2623 = 0.5f * _S2621;
    }
    else
    {
        _S2623 = 0.0f;
    }
    float _S2624 = _S2611[int(12)] / _S2612;
    bool _S2625 = (s_primal_ctx_abs_0(_S2624)) < 0.00499999988824129f;
    float _S2626;
    if(_S2625)
    {
        _S2626 = 0.5f * _S2624;
    }
    else
    {
        _S2626 = 0.0f;
    }
    float _S2627 = _S2611[int(13)] / _S2612;
    bool _S2628 = (s_primal_ctx_abs_0(_S2627)) < 0.00499999988824129f;
    float _S2629;
    if(_S2628)
    {
        _S2629 = 0.5f * _S2627;
    }
    else
    {
        _S2629 = 0.0f;
    }
    float _S2630 = _S2611[int(14)] / _S2612;
    bool _S2631 = (s_primal_ctx_abs_0(_S2630)) < 0.00499999988824129f;
    float _S2632;
    if(_S2631)
    {
        _S2632 = 0.5f * _S2630;
    }
    else
    {
        _S2632 = 0.0f;
    }
    float _S2633 = _S2611[int(15)] / _S2612;
    bool _S2634 = (s_primal_ctx_abs_0(_S2633)) < 0.00499999988824129f;
    float _S2635;
    if(_S2634)
    {
        _S2635 = 0.5f * _S2633;
    }
    else
    {
        _S2635 = 0.0f;
    }
    float _S2636 = _S2611[int(16)] / _S2612;
    bool _S2637 = (s_primal_ctx_abs_0(_S2636)) < 0.00499999988824129f;
    float _S2638;
    if(_S2637)
    {
        _S2638 = 0.5f * _S2636;
    }
    else
    {
        _S2638 = 0.0f;
    }
    float _S2639 = _S2611[int(17)] / _S2612;
    bool _S2640 = (s_primal_ctx_abs_0(_S2639)) < 0.00499999988824129f;
    float _S2641;
    if(_S2640)
    {
        _S2641 = 0.5f * _S2639;
    }
    else
    {
        _S2641 = 0.0f;
    }
    float _S2642 = (*loss_weights_4)[int(3)] * (*_s_dOut_9)[int(3)];
    float _S2643 = (*loss_weights_4)[int(2)] * (*_s_dOut_9)[int(2)];
    float _S2644 = (*loss_weights_4)[int(1)] * (*_s_dOut_9)[int(1)];
    float _S2645 = (*loss_weights_4)[int(0)] * (*_s_dOut_9)[int(0)];
    float _S2646 = (*loss_weights_4)[int(5)] * (*_s_dOut_9)[int(5)] / _S2617;
    float _S2647 = 0.125f * ((*loss_weights_4)[int(4)] * (*_s_dOut_9)[int(4)]);
    FixedArray<float, 23>  _S2648;
    _S2648[int(0)] = 0.0f;
    _S2648[int(1)] = 0.0f;
    _S2648[int(2)] = 0.0f;
    _S2648[int(3)] = 0.0f;
    _S2648[int(4)] = 0.0f;
    _S2648[int(5)] = 0.0f;
    _S2648[int(6)] = 0.0f;
    _S2648[int(7)] = 0.0f;
    _S2648[int(8)] = 0.0f;
    _S2648[int(9)] = 0.0f;
    _S2648[int(10)] = 0.0f;
    _S2648[int(11)] = 0.0f;
    _S2648[int(12)] = 0.0f;
    _S2648[int(13)] = 0.0f;
    _S2648[int(14)] = 0.0f;
    _S2648[int(15)] = 0.0f;
    _S2648[int(16)] = 0.0f;
    _S2648[int(17)] = 0.0f;
    _S2648[int(18)] = 0.0f;
    _S2648[int(19)] = 0.0f;
    _S2648[int(20)] = 0.0f;
    _S2648[int(21)] = 0.0f;
    _S2648[int(22)] = 0.0f;
    _S2648[int(22)] = _S2646;
    _S2648[int(21)] = _S2646;
    _S2648[int(20)] = _S2646;
    _S2648[int(19)] = _S2646;
    _S2648[int(18)] = _S2646;
    float _S2649 = _S2648[int(0)];
    float _S2650 = _S2648[int(1)];
    float _S2651 = _S2648[int(2)];
    float _S2652 = _S2648[int(3)];
    float _S2653 = _S2648[int(4)];
    float _S2654 = _S2648[int(5)];
    float _S2655 = _S2648[int(6)];
    float _S2656 = _S2648[int(7)];
    float _S2657 = _S2648[int(8)];
    float _S2658 = _S2648[int(9)];
    float _S2659 = _S2648[int(10)];
    float _S2660 = _S2648[int(11)];
    float _S2661 = _S2648[int(12)];
    float _S2662 = _S2648[int(13)];
    float _S2663 = _S2648[int(14)];
    float _S2664 = _S2648[int(15)];
    float _S2665 = _S2648[int(16)];
    float _S2666 = _S2648[int(17)];
    float _S2667 = _S2648[int(18)];
    float _S2668 = _S2648[int(19)];
    float _S2669 = _S2648[int(20)];
    float _S2670 = _S2648[int(21)];
    float _S2671 = _S2648[int(22)];
    float _S2672;
    if(_S2640)
    {
        float _S2673 = 200.0f * _S2647;
        float _S2674 = _S2641 * _S2673 + 0.5f * (_S2639 * _S2673);
        _S2641 = 0.0f;
        _S2672 = _S2674;
    }
    else
    {
        _S2641 = _S2647;
        _S2672 = 0.0f;
    }
    DiffPair_float_0 _S2675;
    (&_S2675)->primal_0 = _S2639;
    (&_S2675)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2675, _S2641);
    float _S2676 = (_S2675.differential_0 + _S2672) / _S2612;
    FixedArray<float, 23>  _S2677;
    _S2677[int(0)] = 0.0f;
    _S2677[int(1)] = 0.0f;
    _S2677[int(2)] = 0.0f;
    _S2677[int(3)] = 0.0f;
    _S2677[int(4)] = 0.0f;
    _S2677[int(5)] = 0.0f;
    _S2677[int(6)] = 0.0f;
    _S2677[int(7)] = 0.0f;
    _S2677[int(8)] = 0.0f;
    _S2677[int(9)] = 0.0f;
    _S2677[int(10)] = 0.0f;
    _S2677[int(11)] = 0.0f;
    _S2677[int(12)] = 0.0f;
    _S2677[int(13)] = 0.0f;
    _S2677[int(14)] = 0.0f;
    _S2677[int(15)] = 0.0f;
    _S2677[int(16)] = 0.0f;
    _S2677[int(17)] = 0.0f;
    _S2677[int(18)] = 0.0f;
    _S2677[int(19)] = 0.0f;
    _S2677[int(20)] = 0.0f;
    _S2677[int(21)] = 0.0f;
    _S2677[int(22)] = 0.0f;
    _S2677[int(17)] = _S2676;
    float _S2678 = _S2649 + _S2677[int(0)];
    float _S2679 = _S2650 + _S2677[int(1)];
    float _S2680 = _S2651 + _S2677[int(2)];
    float _S2681 = _S2652 + _S2677[int(3)];
    float _S2682 = _S2653 + _S2677[int(4)];
    float _S2683 = _S2654 + _S2677[int(5)];
    float _S2684 = _S2655 + _S2677[int(6)];
    float _S2685 = _S2656 + _S2677[int(7)];
    float _S2686 = _S2657 + _S2677[int(8)];
    float _S2687 = _S2658 + _S2677[int(9)];
    float _S2688 = _S2659 + _S2677[int(10)];
    float _S2689 = _S2660 + _S2677[int(11)];
    float _S2690 = _S2661 + _S2677[int(12)];
    float _S2691 = _S2662 + _S2677[int(13)];
    float _S2692 = _S2663 + _S2677[int(14)];
    float _S2693 = _S2664 + _S2677[int(15)];
    float _S2694 = _S2665 + _S2677[int(16)];
    float _S2695 = _S2666 + _S2677[int(17)];
    float _S2696 = _S2667 + _S2677[int(18)];
    float _S2697 = _S2668 + _S2677[int(19)];
    float _S2698 = _S2669 + _S2677[int(20)];
    float _S2699 = _S2670 + _S2677[int(21)];
    float _S2700 = _S2671 + _S2677[int(22)];
    if(_S2637)
    {
        float _S2701 = 200.0f * _S2647;
        float _S2702 = _S2638 * _S2701 + 0.5f * (_S2636 * _S2701);
        _S2638 = 0.0f;
        _S2641 = _S2702;
    }
    else
    {
        _S2638 = _S2647;
        _S2641 = 0.0f;
    }
    DiffPair_float_0 _S2703;
    (&_S2703)->primal_0 = _S2636;
    (&_S2703)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2703, _S2638);
    float _S2704 = (_S2703.differential_0 + _S2641) / _S2612;
    FixedArray<float, 23>  _S2705;
    _S2705[int(0)] = 0.0f;
    _S2705[int(1)] = 0.0f;
    _S2705[int(2)] = 0.0f;
    _S2705[int(3)] = 0.0f;
    _S2705[int(4)] = 0.0f;
    _S2705[int(5)] = 0.0f;
    _S2705[int(6)] = 0.0f;
    _S2705[int(7)] = 0.0f;
    _S2705[int(8)] = 0.0f;
    _S2705[int(9)] = 0.0f;
    _S2705[int(10)] = 0.0f;
    _S2705[int(11)] = 0.0f;
    _S2705[int(12)] = 0.0f;
    _S2705[int(13)] = 0.0f;
    _S2705[int(14)] = 0.0f;
    _S2705[int(15)] = 0.0f;
    _S2705[int(16)] = 0.0f;
    _S2705[int(17)] = 0.0f;
    _S2705[int(18)] = 0.0f;
    _S2705[int(19)] = 0.0f;
    _S2705[int(20)] = 0.0f;
    _S2705[int(21)] = 0.0f;
    _S2705[int(22)] = 0.0f;
    _S2705[int(16)] = _S2704;
    float _S2706 = _S2678 + _S2705[int(0)];
    float _S2707 = _S2679 + _S2705[int(1)];
    float _S2708 = _S2680 + _S2705[int(2)];
    float _S2709 = _S2681 + _S2705[int(3)];
    float _S2710 = _S2682 + _S2705[int(4)];
    float _S2711 = _S2683 + _S2705[int(5)];
    float _S2712 = _S2684 + _S2705[int(6)];
    float _S2713 = _S2685 + _S2705[int(7)];
    float _S2714 = _S2686 + _S2705[int(8)];
    float _S2715 = _S2687 + _S2705[int(9)];
    float _S2716 = _S2688 + _S2705[int(10)];
    float _S2717 = _S2689 + _S2705[int(11)];
    float _S2718 = _S2690 + _S2705[int(12)];
    float _S2719 = _S2691 + _S2705[int(13)];
    float _S2720 = _S2692 + _S2705[int(14)];
    float _S2721 = _S2693 + _S2705[int(15)];
    float _S2722 = _S2694 + _S2705[int(16)];
    float _S2723 = _S2695 + _S2705[int(17)];
    float _S2724 = _S2696 + _S2705[int(18)];
    float _S2725 = _S2697 + _S2705[int(19)];
    float _S2726 = _S2698 + _S2705[int(20)];
    float _S2727 = _S2699 + _S2705[int(21)];
    float _S2728 = _S2700 + _S2705[int(22)];
    if(_S2634)
    {
        float _S2729 = 200.0f * _S2647;
        float _S2730 = _S2635 * _S2729 + 0.5f * (_S2633 * _S2729);
        _S2635 = 0.0f;
        _S2638 = _S2730;
    }
    else
    {
        _S2635 = _S2647;
        _S2638 = 0.0f;
    }
    DiffPair_float_0 _S2731;
    (&_S2731)->primal_0 = _S2633;
    (&_S2731)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2731, _S2635);
    float _S2732 = (_S2731.differential_0 + _S2638) / _S2612;
    FixedArray<float, 23>  _S2733;
    _S2733[int(0)] = 0.0f;
    _S2733[int(1)] = 0.0f;
    _S2733[int(2)] = 0.0f;
    _S2733[int(3)] = 0.0f;
    _S2733[int(4)] = 0.0f;
    _S2733[int(5)] = 0.0f;
    _S2733[int(6)] = 0.0f;
    _S2733[int(7)] = 0.0f;
    _S2733[int(8)] = 0.0f;
    _S2733[int(9)] = 0.0f;
    _S2733[int(10)] = 0.0f;
    _S2733[int(11)] = 0.0f;
    _S2733[int(12)] = 0.0f;
    _S2733[int(13)] = 0.0f;
    _S2733[int(14)] = 0.0f;
    _S2733[int(15)] = 0.0f;
    _S2733[int(16)] = 0.0f;
    _S2733[int(17)] = 0.0f;
    _S2733[int(18)] = 0.0f;
    _S2733[int(19)] = 0.0f;
    _S2733[int(20)] = 0.0f;
    _S2733[int(21)] = 0.0f;
    _S2733[int(22)] = 0.0f;
    _S2733[int(15)] = _S2732;
    float _S2734 = _S2706 + _S2733[int(0)];
    float _S2735 = _S2707 + _S2733[int(1)];
    float _S2736 = _S2708 + _S2733[int(2)];
    float _S2737 = _S2709 + _S2733[int(3)];
    float _S2738 = _S2710 + _S2733[int(4)];
    float _S2739 = _S2711 + _S2733[int(5)];
    float _S2740 = _S2712 + _S2733[int(6)];
    float _S2741 = _S2713 + _S2733[int(7)];
    float _S2742 = _S2714 + _S2733[int(8)];
    float _S2743 = _S2715 + _S2733[int(9)];
    float _S2744 = _S2716 + _S2733[int(10)];
    float _S2745 = _S2717 + _S2733[int(11)];
    float _S2746 = _S2718 + _S2733[int(12)];
    float _S2747 = _S2719 + _S2733[int(13)];
    float _S2748 = _S2720 + _S2733[int(14)];
    float _S2749 = _S2721 + _S2733[int(15)];
    float _S2750 = _S2722 + _S2733[int(16)];
    float _S2751 = _S2723 + _S2733[int(17)];
    float _S2752 = _S2724 + _S2733[int(18)];
    float _S2753 = _S2725 + _S2733[int(19)];
    float _S2754 = _S2726 + _S2733[int(20)];
    float _S2755 = _S2727 + _S2733[int(21)];
    float _S2756 = _S2728 + _S2733[int(22)];
    if(_S2631)
    {
        float _S2757 = 200.0f * _S2647;
        float _S2758 = _S2632 * _S2757 + 0.5f * (_S2630 * _S2757);
        _S2632 = 0.0f;
        _S2635 = _S2758;
    }
    else
    {
        _S2632 = _S2647;
        _S2635 = 0.0f;
    }
    DiffPair_float_0 _S2759;
    (&_S2759)->primal_0 = _S2630;
    (&_S2759)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2759, _S2632);
    float _S2760 = (_S2759.differential_0 + _S2635) / _S2612;
    FixedArray<float, 23>  _S2761;
    _S2761[int(0)] = 0.0f;
    _S2761[int(1)] = 0.0f;
    _S2761[int(2)] = 0.0f;
    _S2761[int(3)] = 0.0f;
    _S2761[int(4)] = 0.0f;
    _S2761[int(5)] = 0.0f;
    _S2761[int(6)] = 0.0f;
    _S2761[int(7)] = 0.0f;
    _S2761[int(8)] = 0.0f;
    _S2761[int(9)] = 0.0f;
    _S2761[int(10)] = 0.0f;
    _S2761[int(11)] = 0.0f;
    _S2761[int(12)] = 0.0f;
    _S2761[int(13)] = 0.0f;
    _S2761[int(14)] = 0.0f;
    _S2761[int(15)] = 0.0f;
    _S2761[int(16)] = 0.0f;
    _S2761[int(17)] = 0.0f;
    _S2761[int(18)] = 0.0f;
    _S2761[int(19)] = 0.0f;
    _S2761[int(20)] = 0.0f;
    _S2761[int(21)] = 0.0f;
    _S2761[int(22)] = 0.0f;
    _S2761[int(14)] = _S2760;
    float _S2762 = _S2734 + _S2761[int(0)];
    float _S2763 = _S2735 + _S2761[int(1)];
    float _S2764 = _S2736 + _S2761[int(2)];
    float _S2765 = _S2737 + _S2761[int(3)];
    float _S2766 = _S2738 + _S2761[int(4)];
    float _S2767 = _S2739 + _S2761[int(5)];
    float _S2768 = _S2740 + _S2761[int(6)];
    float _S2769 = _S2741 + _S2761[int(7)];
    float _S2770 = _S2742 + _S2761[int(8)];
    float _S2771 = _S2743 + _S2761[int(9)];
    float _S2772 = _S2744 + _S2761[int(10)];
    float _S2773 = _S2745 + _S2761[int(11)];
    float _S2774 = _S2746 + _S2761[int(12)];
    float _S2775 = _S2747 + _S2761[int(13)];
    float _S2776 = _S2748 + _S2761[int(14)];
    float _S2777 = _S2749 + _S2761[int(15)];
    float _S2778 = _S2750 + _S2761[int(16)];
    float _S2779 = _S2751 + _S2761[int(17)];
    float _S2780 = _S2752 + _S2761[int(18)];
    float _S2781 = _S2753 + _S2761[int(19)];
    float _S2782 = _S2754 + _S2761[int(20)];
    float _S2783 = _S2755 + _S2761[int(21)];
    float _S2784 = _S2756 + _S2761[int(22)];
    if(_S2628)
    {
        float _S2785 = 200.0f * _S2647;
        float _S2786 = _S2629 * _S2785 + 0.5f * (_S2627 * _S2785);
        _S2629 = 0.0f;
        _S2632 = _S2786;
    }
    else
    {
        _S2629 = _S2647;
        _S2632 = 0.0f;
    }
    DiffPair_float_0 _S2787;
    (&_S2787)->primal_0 = _S2627;
    (&_S2787)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2787, _S2629);
    float _S2788 = (_S2787.differential_0 + _S2632) / _S2612;
    FixedArray<float, 23>  _S2789;
    _S2789[int(0)] = 0.0f;
    _S2789[int(1)] = 0.0f;
    _S2789[int(2)] = 0.0f;
    _S2789[int(3)] = 0.0f;
    _S2789[int(4)] = 0.0f;
    _S2789[int(5)] = 0.0f;
    _S2789[int(6)] = 0.0f;
    _S2789[int(7)] = 0.0f;
    _S2789[int(8)] = 0.0f;
    _S2789[int(9)] = 0.0f;
    _S2789[int(10)] = 0.0f;
    _S2789[int(11)] = 0.0f;
    _S2789[int(12)] = 0.0f;
    _S2789[int(13)] = 0.0f;
    _S2789[int(14)] = 0.0f;
    _S2789[int(15)] = 0.0f;
    _S2789[int(16)] = 0.0f;
    _S2789[int(17)] = 0.0f;
    _S2789[int(18)] = 0.0f;
    _S2789[int(19)] = 0.0f;
    _S2789[int(20)] = 0.0f;
    _S2789[int(21)] = 0.0f;
    _S2789[int(22)] = 0.0f;
    _S2789[int(13)] = _S2788;
    float _S2790 = _S2762 + _S2789[int(0)];
    float _S2791 = _S2763 + _S2789[int(1)];
    float _S2792 = _S2764 + _S2789[int(2)];
    float _S2793 = _S2765 + _S2789[int(3)];
    float _S2794 = _S2766 + _S2789[int(4)];
    float _S2795 = _S2767 + _S2789[int(5)];
    float _S2796 = _S2768 + _S2789[int(6)];
    float _S2797 = _S2769 + _S2789[int(7)];
    float _S2798 = _S2770 + _S2789[int(8)];
    float _S2799 = _S2771 + _S2789[int(9)];
    float _S2800 = _S2772 + _S2789[int(10)];
    float _S2801 = _S2773 + _S2789[int(11)];
    float _S2802 = _S2774 + _S2789[int(12)];
    float _S2803 = _S2775 + _S2789[int(13)];
    float _S2804 = _S2776 + _S2789[int(14)];
    float _S2805 = _S2777 + _S2789[int(15)];
    float _S2806 = _S2778 + _S2789[int(16)];
    float _S2807 = _S2779 + _S2789[int(17)];
    float _S2808 = _S2780 + _S2789[int(18)];
    float _S2809 = _S2781 + _S2789[int(19)];
    float _S2810 = _S2782 + _S2789[int(20)];
    float _S2811 = _S2783 + _S2789[int(21)];
    float _S2812 = _S2784 + _S2789[int(22)];
    if(_S2625)
    {
        float _S2813 = 200.0f * _S2647;
        float _S2814 = _S2626 * _S2813 + 0.5f * (_S2624 * _S2813);
        _S2626 = 0.0f;
        _S2629 = _S2814;
    }
    else
    {
        _S2626 = _S2647;
        _S2629 = 0.0f;
    }
    DiffPair_float_0 _S2815;
    (&_S2815)->primal_0 = _S2624;
    (&_S2815)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2815, _S2626);
    float _S2816 = (_S2815.differential_0 + _S2629) / _S2612;
    FixedArray<float, 23>  _S2817;
    _S2817[int(0)] = 0.0f;
    _S2817[int(1)] = 0.0f;
    _S2817[int(2)] = 0.0f;
    _S2817[int(3)] = 0.0f;
    _S2817[int(4)] = 0.0f;
    _S2817[int(5)] = 0.0f;
    _S2817[int(6)] = 0.0f;
    _S2817[int(7)] = 0.0f;
    _S2817[int(8)] = 0.0f;
    _S2817[int(9)] = 0.0f;
    _S2817[int(10)] = 0.0f;
    _S2817[int(11)] = 0.0f;
    _S2817[int(12)] = 0.0f;
    _S2817[int(13)] = 0.0f;
    _S2817[int(14)] = 0.0f;
    _S2817[int(15)] = 0.0f;
    _S2817[int(16)] = 0.0f;
    _S2817[int(17)] = 0.0f;
    _S2817[int(18)] = 0.0f;
    _S2817[int(19)] = 0.0f;
    _S2817[int(20)] = 0.0f;
    _S2817[int(21)] = 0.0f;
    _S2817[int(22)] = 0.0f;
    _S2817[int(12)] = _S2816;
    float _S2818 = _S2790 + _S2817[int(0)];
    float _S2819 = _S2791 + _S2817[int(1)];
    float _S2820 = _S2792 + _S2817[int(2)];
    float _S2821 = _S2793 + _S2817[int(3)];
    float _S2822 = _S2794 + _S2817[int(4)];
    float _S2823 = _S2795 + _S2817[int(5)];
    float _S2824 = _S2796 + _S2817[int(6)];
    float _S2825 = _S2797 + _S2817[int(7)];
    float _S2826 = _S2798 + _S2817[int(8)];
    float _S2827 = _S2799 + _S2817[int(9)];
    float _S2828 = _S2800 + _S2817[int(10)];
    float _S2829 = _S2801 + _S2817[int(11)];
    float _S2830 = _S2802 + _S2817[int(12)];
    float _S2831 = _S2803 + _S2817[int(13)];
    float _S2832 = _S2804 + _S2817[int(14)];
    float _S2833 = _S2805 + _S2817[int(15)];
    float _S2834 = _S2806 + _S2817[int(16)];
    float _S2835 = _S2807 + _S2817[int(17)];
    float _S2836 = _S2808 + _S2817[int(18)];
    float _S2837 = _S2809 + _S2817[int(19)];
    float _S2838 = _S2810 + _S2817[int(20)];
    float _S2839 = _S2811 + _S2817[int(21)];
    float _S2840 = _S2812 + _S2817[int(22)];
    if(_S2622)
    {
        float _S2841 = 200.0f * _S2647;
        float _S2842 = _S2623 * _S2841 + 0.5f * (_S2621 * _S2841);
        _S2623 = 0.0f;
        _S2626 = _S2842;
    }
    else
    {
        _S2623 = _S2647;
        _S2626 = 0.0f;
    }
    DiffPair_float_0 _S2843;
    (&_S2843)->primal_0 = _S2621;
    (&_S2843)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2843, _S2623);
    float _S2844 = (_S2843.differential_0 + _S2626) / _S2612;
    FixedArray<float, 23>  _S2845;
    _S2845[int(0)] = 0.0f;
    _S2845[int(1)] = 0.0f;
    _S2845[int(2)] = 0.0f;
    _S2845[int(3)] = 0.0f;
    _S2845[int(4)] = 0.0f;
    _S2845[int(5)] = 0.0f;
    _S2845[int(6)] = 0.0f;
    _S2845[int(7)] = 0.0f;
    _S2845[int(8)] = 0.0f;
    _S2845[int(9)] = 0.0f;
    _S2845[int(10)] = 0.0f;
    _S2845[int(11)] = 0.0f;
    _S2845[int(12)] = 0.0f;
    _S2845[int(13)] = 0.0f;
    _S2845[int(14)] = 0.0f;
    _S2845[int(15)] = 0.0f;
    _S2845[int(16)] = 0.0f;
    _S2845[int(17)] = 0.0f;
    _S2845[int(18)] = 0.0f;
    _S2845[int(19)] = 0.0f;
    _S2845[int(20)] = 0.0f;
    _S2845[int(21)] = 0.0f;
    _S2845[int(22)] = 0.0f;
    _S2845[int(11)] = _S2844;
    float _S2846 = _S2818 + _S2845[int(0)];
    float _S2847 = _S2819 + _S2845[int(1)];
    float _S2848 = _S2820 + _S2845[int(2)];
    float _S2849 = _S2821 + _S2845[int(3)];
    float _S2850 = _S2822 + _S2845[int(4)];
    float _S2851 = _S2823 + _S2845[int(5)];
    float _S2852 = _S2824 + _S2845[int(6)];
    float _S2853 = _S2825 + _S2845[int(7)];
    float _S2854 = _S2826 + _S2845[int(8)];
    float _S2855 = _S2827 + _S2845[int(9)];
    float _S2856 = _S2828 + _S2845[int(10)];
    float _S2857 = _S2829 + _S2845[int(11)];
    float _S2858 = _S2830 + _S2845[int(12)];
    float _S2859 = _S2831 + _S2845[int(13)];
    float _S2860 = _S2832 + _S2845[int(14)];
    float _S2861 = _S2833 + _S2845[int(15)];
    float _S2862 = _S2834 + _S2845[int(16)];
    float _S2863 = _S2835 + _S2845[int(17)];
    float _S2864 = _S2836 + _S2845[int(18)];
    float _S2865 = _S2837 + _S2845[int(19)];
    float _S2866 = _S2838 + _S2845[int(20)];
    float _S2867 = _S2839 + _S2845[int(21)];
    float _S2868 = _S2840 + _S2845[int(22)];
    if(_S2619)
    {
        float _S2869 = 200.0f * _S2647;
        float _S2870 = _S2620 * _S2869 + 0.5f * (_S2618 * _S2869);
        _S2620 = 0.0f;
        _S2623 = _S2870;
    }
    else
    {
        _S2620 = _S2647;
        _S2623 = 0.0f;
    }
    DiffPair_float_0 _S2871;
    (&_S2871)->primal_0 = _S2618;
    (&_S2871)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2871, _S2620);
    float _S2872 = (_S2871.differential_0 + _S2623) / _S2612;
    float _S2873 = _S2642 / _S2617;
    float _S2874 = _S2643 / _S2616;
    float _S2875 = _S2644 / _S2615;
    FixedArray<float, 23>  _S2876;
    _S2876[int(0)] = 0.0f;
    _S2876[int(1)] = 0.0f;
    _S2876[int(2)] = 0.0f;
    _S2876[int(3)] = 0.0f;
    _S2876[int(4)] = 0.0f;
    _S2876[int(5)] = 0.0f;
    _S2876[int(6)] = 0.0f;
    _S2876[int(7)] = 0.0f;
    _S2876[int(8)] = 0.0f;
    _S2876[int(9)] = 0.0f;
    _S2876[int(10)] = 0.0f;
    _S2876[int(11)] = 0.0f;
    _S2876[int(12)] = 0.0f;
    _S2876[int(13)] = 0.0f;
    _S2876[int(14)] = 0.0f;
    _S2876[int(15)] = 0.0f;
    _S2876[int(16)] = 0.0f;
    _S2876[int(17)] = 0.0f;
    _S2876[int(18)] = 0.0f;
    _S2876[int(19)] = 0.0f;
    _S2876[int(20)] = 0.0f;
    _S2876[int(21)] = 0.0f;
    _S2876[int(22)] = 0.0f;
    _S2876[int(10)] = _S2872;
    _S2876[int(9)] = _S2873;
    _S2876[int(8)] = _S2873;
    _S2876[int(7)] = _S2873;
    _S2876[int(6)] = _S2873;
    _S2876[int(5)] = _S2873;
    _S2876[int(4)] = _S2874;
    _S2876[int(3)] = _S2874;
    _S2876[int(2)] = _S2874;
    _S2876[int(1)] = _S2875;
    float _S2877 = _S2846 + _S2876[int(0)];
    float _S2878 = _S2847 + _S2876[int(1)];
    float _S2879 = _S2848 + _S2876[int(2)];
    float _S2880 = _S2849 + _S2876[int(3)];
    float _S2881 = _S2850 + _S2876[int(4)];
    float _S2882 = _S2851 + _S2876[int(5)];
    float _S2883 = _S2852 + _S2876[int(6)];
    float _S2884 = _S2853 + _S2876[int(7)];
    float _S2885 = _S2854 + _S2876[int(8)];
    float _S2886 = _S2855 + _S2876[int(9)];
    float _S2887 = _S2856 + _S2876[int(10)];
    float _S2888 = _S2857 + _S2876[int(11)];
    float _S2889 = _S2858 + _S2876[int(12)];
    float _S2890 = _S2859 + _S2876[int(13)];
    float _S2891 = _S2860 + _S2876[int(14)];
    float _S2892 = _S2861 + _S2876[int(15)];
    float _S2893 = _S2862 + _S2876[int(16)];
    float _S2894 = _S2863 + _S2876[int(17)];
    float _S2895 = _S2864 + _S2876[int(18)];
    float _S2896 = _S2865 + _S2876[int(19)];
    float _S2897 = _S2866 + _S2876[int(20)];
    float _S2898 = _S2867 + _S2876[int(21)];
    float _S2899 = _S2868 + _S2876[int(22)];
    if(_S2613)
    {
        float _S2900 = 10.0f * _S2645;
        float _S2901 = _S2614 * _S2900 + 0.5f * (mean_55 * _S2900);
        _S2614 = 0.0f;
        _S2620 = _S2901;
    }
    else
    {
        _S2614 = _S2645;
        _S2620 = 0.0f;
    }
    DiffPair_float_0 _S2902;
    (&_S2902)->primal_0 = mean_55;
    (&_S2902)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2902, _S2614);
    float _S2903 = _S2902.differential_0 + _S2620;
    if(exposure_arithmetic_mean_16)
    {
        DiffPair_float_0 _S2904;
        (&_S2904)->primal_0 = mean_54;
        (&_S2904)->differential_0 = 0.0f;
        s_bwd_prop_log2_0(&_S2904, _S2903);
        mean_55 = _S2904.differential_0;
    }
    else
    {
        mean_55 = _S2903;
    }
    float _S2905 = mean_55 / _S2612;
    FixedArray<float, 23>  _S2906;
    _S2906[int(0)] = 0.0f;
    _S2906[int(1)] = 0.0f;
    _S2906[int(2)] = 0.0f;
    _S2906[int(3)] = 0.0f;
    _S2906[int(4)] = 0.0f;
    _S2906[int(5)] = 0.0f;
    _S2906[int(6)] = 0.0f;
    _S2906[int(7)] = 0.0f;
    _S2906[int(8)] = 0.0f;
    _S2906[int(9)] = 0.0f;
    _S2906[int(10)] = 0.0f;
    _S2906[int(11)] = 0.0f;
    _S2906[int(12)] = 0.0f;
    _S2906[int(13)] = 0.0f;
    _S2906[int(14)] = 0.0f;
    _S2906[int(15)] = 0.0f;
    _S2906[int(16)] = 0.0f;
    _S2906[int(17)] = 0.0f;
    _S2906[int(18)] = 0.0f;
    _S2906[int(19)] = 0.0f;
    _S2906[int(20)] = 0.0f;
    _S2906[int(21)] = 0.0f;
    _S2906[int(22)] = 0.0f;
    _S2906[int(0)] = _S2905;
    FixedArray<float, 23>  _S2907 = {
        _S2877 + _S2906[int(0)], _S2878 + _S2906[int(1)], _S2879 + _S2906[int(2)], _S2880 + _S2906[int(3)], _S2881 + _S2906[int(4)], _S2882 + _S2906[int(5)], _S2883 + _S2906[int(6)], _S2884 + _S2906[int(7)], _S2885 + _S2906[int(8)], _S2886 + _S2906[int(9)], _S2887 + _S2906[int(10)], _S2888 + _S2906[int(11)], _S2889 + _S2906[int(12)], _S2890 + _S2906[int(13)], _S2891 + _S2906[int(14)], _S2892 + _S2906[int(15)], _S2893 + _S2906[int(16)], _S2894 + _S2906[int(17)], _S2895 + _S2906[int(18)], _S2896 + _S2906[int(19)], _S2897 + _S2906[int(20)], _S2898 + _S2906[int(21)], _S2899 + _S2906[int(22)]
    };
    dpraw_losses_1->primal_0 = dpraw_losses_1->primal_0;
    dpraw_losses_1->differential_0 = _S2907;
    return;
}

inline __device__ void s_bwd_compute_ppisp_rqs_regularization_loss_0(DiffPair_arrayx3Cfloatx2C23x3E_0 * _S2908, int _S2909, bool _S2910, FixedArray<float, 6>  * _S2911, FixedArray<float, 6>  * _S2912)
{
    s_bwd_prop_compute_ppisp_rqs_regularization_loss_0(_S2908, _S2909, _S2910, _S2911, _S2912);
    return;
}

inline __device__ void compute_ppisp_rqs_regularization_loss_vjp(FixedArray<float, 23>  raw_losses_3, int num_cameras_5, bool exposure_arithmetic_mean_17, FixedArray<float, 6>  loss_weights_5, FixedArray<float, 6>  grad_out_9, FixedArray<float, 23>  * _S2913)
{
    FixedArray<float, 23>  _S2914 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C23x3E_0 dp_raw_losses_1;
    (&dp_raw_losses_1)->primal_0 = raw_losses_3;
    (&dp_raw_losses_1)->differential_0 = _S2914;
    FixedArray<float, 6>  _S2915 = loss_weights_5;
    FixedArray<float, 6>  _S2916 = grad_out_9;
    s_bwd_compute_ppisp_rqs_regularization_loss_0(&dp_raw_losses_1, num_cameras_5, exposure_arithmetic_mean_17, &_S2915, &_S2916);
    *_S2913 = (&dp_raw_losses_1)->differential_0;
    return;
}

inline __device__ void compute_ppisp_no_crf_regularization_loss(FixedArray<float, 18>  raw_losses_4, int num_cameras_6, bool exposure_arithmetic_mean_18, FixedArray<float, 6>  loss_weights_6, FixedArray<float, 6>  * _S2917)
{
    float mean_56;
    float _S2918;
    FixedArray<float, 6>  losses_6;
    for(;;)
    {
        float _S2919 = float(num_cameras_6);
        _S2918 = _S2919;
        float mean_57 = raw_losses_4[int(0)] / _S2919;
        if(exposure_arithmetic_mean_18)
        {
            mean_56 = (F32_log2((mean_57)));
        }
        else
        {
            mean_56 = mean_57;
        }
        for(;;)
        {
            float _S2920 = (F32_abs((mean_56)));
            if(_S2920 < 0.10000000149011612f)
            {
                mean_56 = 0.5f * mean_56 * mean_56 / 0.10000000149011612f;
                break;
            }
            else
            {
                mean_56 = _S2920 - 0.05000000074505806f;
                break;
            }
        }
        break;
    }
    losses_6[int(0)] = mean_56;
    losses_6[int(1)] = raw_losses_4[int(1)] / (3.0f * _S2918);
    losses_6[int(2)] = (raw_losses_4[int(2)] + raw_losses_4[int(3)] + raw_losses_4[int(4)]) / (9.0f * _S2918);
    losses_6[int(3)] = (raw_losses_4[int(5)] + raw_losses_4[int(6)] + raw_losses_4[int(7)] + raw_losses_4[int(8)] + raw_losses_4[int(9)]) / (5.0f * _S2918);
    float _S2921 = raw_losses_4[int(10)] / _S2918;
    for(;;)
    {
        float _S2922 = (F32_abs((_S2921)));
        if(_S2922 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2921 * _S2921 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2922 - 0.00249999994412065f;
            break;
        }
    }
    float _S2923;
    float _S2924 = raw_losses_4[int(11)] / _S2918;
    for(;;)
    {
        float _S2925 = (F32_abs((_S2924)));
        if(_S2925 < 0.00499999988824129f)
        {
            _S2923 = 0.5f * _S2924 * _S2924 / 0.00499999988824129f;
            break;
        }
        else
        {
            _S2923 = _S2925 - 0.00249999994412065f;
            break;
        }
    }
    float _S2926 = mean_56 + _S2923;
    float _S2927 = raw_losses_4[int(12)] / _S2918;
    for(;;)
    {
        float _S2928 = (F32_abs((_S2927)));
        if(_S2928 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2927 * _S2927 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2928 - 0.00249999994412065f;
            break;
        }
    }
    float _S2929 = _S2926 + mean_56;
    float _S2930 = raw_losses_4[int(13)] / _S2918;
    for(;;)
    {
        float _S2931 = (F32_abs((_S2930)));
        if(_S2931 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2930 * _S2930 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2931 - 0.00249999994412065f;
            break;
        }
    }
    float _S2932 = _S2929 + mean_56;
    float _S2933 = raw_losses_4[int(14)] / _S2918;
    for(;;)
    {
        float _S2934 = (F32_abs((_S2933)));
        if(_S2934 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2933 * _S2933 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2934 - 0.00249999994412065f;
            break;
        }
    }
    float _S2935 = _S2932 + mean_56;
    float _S2936 = raw_losses_4[int(15)] / _S2918;
    for(;;)
    {
        float _S2937 = (F32_abs((_S2936)));
        if(_S2937 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2936 * _S2936 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2937 - 0.00249999994412065f;
            break;
        }
    }
    float _S2938 = _S2935 + mean_56;
    float _S2939 = raw_losses_4[int(16)] / _S2918;
    for(;;)
    {
        float _S2940 = (F32_abs((_S2939)));
        if(_S2940 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2939 * _S2939 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2940 - 0.00249999994412065f;
            break;
        }
    }
    float _S2941 = _S2938 + mean_56;
    float _S2942 = raw_losses_4[int(17)] / _S2918;
    for(;;)
    {
        float _S2943 = (F32_abs((_S2942)));
        if(_S2943 < 0.00499999988824129f)
        {
            mean_56 = 0.5f * _S2942 * _S2942 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_56 = _S2943 - 0.00249999994412065f;
            break;
        }
    }
    float _S2944 = (_S2941 + mean_56) / 8.0f;
    losses_6[int(5)] = 0.0f;
    losses_6[int(0)] = losses_6[int(0)] * loss_weights_6[int(0)];
    losses_6[int(1)] = losses_6[int(1)] * loss_weights_6[int(1)];
    losses_6[int(2)] = losses_6[int(2)] * loss_weights_6[int(2)];
    losses_6[int(3)] = losses_6[int(3)] * loss_weights_6[int(3)];
    losses_6[int(4)] = _S2944 * loss_weights_6[int(4)];
    *_S2917 = losses_6;
    return;
}

struct DiffPair_arrayx3Cfloatx2C18x3E_0
{
    FixedArray<float, 18>  primal_0;
    FixedArray<float, 18>  differential_0;
};

inline __device__ void s_bwd_prop_compute_ppisp_no_crf_regularization_loss_0(DiffPair_arrayx3Cfloatx2C18x3E_0 * dpraw_losses_2, int num_cameras_7, bool exposure_arithmetic_mean_19, FixedArray<float, 6>  * loss_weights_7, FixedArray<float, 6>  * _s_dOut_10)
{
    FixedArray<float, 18>  _S2945 = dpraw_losses_2->primal_0;
    float _S2946 = float(num_cameras_7);
    float mean_58 = dpraw_losses_2->primal_0[int(0)] / _S2946;
    float mean_59;
    if(exposure_arithmetic_mean_19)
    {
        mean_59 = s_primal_ctx_log2_0(mean_58);
    }
    else
    {
        mean_59 = mean_58;
    }
    bool _S2947 = (s_primal_ctx_abs_0(mean_59)) < 0.10000000149011612f;
    float _S2948;
    if(_S2947)
    {
        _S2948 = 0.5f * mean_59;
    }
    else
    {
        _S2948 = 0.0f;
    }
    float _S2949 = 3.0f * _S2946;
    float _S2950 = 9.0f * _S2946;
    float _S2951 = 5.0f * _S2946;
    float _S2952 = _S2945[int(10)] / _S2946;
    bool _S2953 = (s_primal_ctx_abs_0(_S2952)) < 0.00499999988824129f;
    float _S2954;
    if(_S2953)
    {
        _S2954 = 0.5f * _S2952;
    }
    else
    {
        _S2954 = 0.0f;
    }
    float _S2955 = _S2945[int(11)] / _S2946;
    bool _S2956 = (s_primal_ctx_abs_0(_S2955)) < 0.00499999988824129f;
    float _S2957;
    if(_S2956)
    {
        _S2957 = 0.5f * _S2955;
    }
    else
    {
        _S2957 = 0.0f;
    }
    float _S2958 = _S2945[int(12)] / _S2946;
    bool _S2959 = (s_primal_ctx_abs_0(_S2958)) < 0.00499999988824129f;
    float _S2960;
    if(_S2959)
    {
        _S2960 = 0.5f * _S2958;
    }
    else
    {
        _S2960 = 0.0f;
    }
    float _S2961 = _S2945[int(13)] / _S2946;
    bool _S2962 = (s_primal_ctx_abs_0(_S2961)) < 0.00499999988824129f;
    float _S2963;
    if(_S2962)
    {
        _S2963 = 0.5f * _S2961;
    }
    else
    {
        _S2963 = 0.0f;
    }
    float _S2964 = _S2945[int(14)] / _S2946;
    bool _S2965 = (s_primal_ctx_abs_0(_S2964)) < 0.00499999988824129f;
    float _S2966;
    if(_S2965)
    {
        _S2966 = 0.5f * _S2964;
    }
    else
    {
        _S2966 = 0.0f;
    }
    float _S2967 = _S2945[int(15)] / _S2946;
    bool _S2968 = (s_primal_ctx_abs_0(_S2967)) < 0.00499999988824129f;
    float _S2969;
    if(_S2968)
    {
        _S2969 = 0.5f * _S2967;
    }
    else
    {
        _S2969 = 0.0f;
    }
    float _S2970 = _S2945[int(16)] / _S2946;
    bool _S2971 = (s_primal_ctx_abs_0(_S2970)) < 0.00499999988824129f;
    float _S2972;
    if(_S2971)
    {
        _S2972 = 0.5f * _S2970;
    }
    else
    {
        _S2972 = 0.0f;
    }
    float _S2973 = _S2945[int(17)] / _S2946;
    bool _S2974 = (s_primal_ctx_abs_0(_S2973)) < 0.00499999988824129f;
    float _S2975;
    if(_S2974)
    {
        _S2975 = 0.5f * _S2973;
    }
    else
    {
        _S2975 = 0.0f;
    }
    float _S2976 = (*loss_weights_7)[int(3)] * (*_s_dOut_10)[int(3)];
    float _S2977 = (*loss_weights_7)[int(2)] * (*_s_dOut_10)[int(2)];
    float _S2978 = (*loss_weights_7)[int(1)] * (*_s_dOut_10)[int(1)];
    float _S2979 = (*loss_weights_7)[int(0)] * (*_s_dOut_10)[int(0)];
    float _S2980 = 0.125f * ((*loss_weights_7)[int(4)] * (*_s_dOut_10)[int(4)]);
    float _S2981;
    if(_S2974)
    {
        float _S2982 = 200.0f * _S2980;
        float _S2983 = _S2975 * _S2982 + 0.5f * (_S2973 * _S2982);
        _S2975 = 0.0f;
        _S2981 = _S2983;
    }
    else
    {
        _S2975 = _S2980;
        _S2981 = 0.0f;
    }
    DiffPair_float_0 _S2984;
    (&_S2984)->primal_0 = _S2973;
    (&_S2984)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S2984, _S2975);
    float _S2985 = (_S2984.differential_0 + _S2981) / _S2946;
    FixedArray<float, 18>  _S2986;
    _S2986[int(0)] = 0.0f;
    _S2986[int(1)] = 0.0f;
    _S2986[int(2)] = 0.0f;
    _S2986[int(3)] = 0.0f;
    _S2986[int(4)] = 0.0f;
    _S2986[int(5)] = 0.0f;
    _S2986[int(6)] = 0.0f;
    _S2986[int(7)] = 0.0f;
    _S2986[int(8)] = 0.0f;
    _S2986[int(9)] = 0.0f;
    _S2986[int(10)] = 0.0f;
    _S2986[int(11)] = 0.0f;
    _S2986[int(12)] = 0.0f;
    _S2986[int(13)] = 0.0f;
    _S2986[int(14)] = 0.0f;
    _S2986[int(15)] = 0.0f;
    _S2986[int(16)] = 0.0f;
    _S2986[int(17)] = 0.0f;
    _S2986[int(17)] = _S2985;
    float _S2987 = _S2986[int(0)];
    float _S2988 = _S2986[int(1)];
    float _S2989 = _S2986[int(2)];
    float _S2990 = _S2986[int(3)];
    float _S2991 = _S2986[int(4)];
    float _S2992 = _S2986[int(5)];
    float _S2993 = _S2986[int(6)];
    float _S2994 = _S2986[int(7)];
    float _S2995 = _S2986[int(8)];
    float _S2996 = _S2986[int(9)];
    float _S2997 = _S2986[int(10)];
    float _S2998 = _S2986[int(11)];
    float _S2999 = _S2986[int(12)];
    float _S3000 = _S2986[int(13)];
    float _S3001 = _S2986[int(14)];
    float _S3002 = _S2986[int(15)];
    float _S3003 = _S2986[int(16)];
    float _S3004 = _S2986[int(17)];
    if(_S2971)
    {
        float _S3005 = 200.0f * _S2980;
        float _S3006 = _S2972 * _S3005 + 0.5f * (_S2970 * _S3005);
        _S2972 = 0.0f;
        _S2975 = _S3006;
    }
    else
    {
        _S2972 = _S2980;
        _S2975 = 0.0f;
    }
    DiffPair_float_0 _S3007;
    (&_S3007)->primal_0 = _S2970;
    (&_S3007)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3007, _S2972);
    float _S3008 = (_S3007.differential_0 + _S2975) / _S2946;
    FixedArray<float, 18>  _S3009;
    _S3009[int(0)] = 0.0f;
    _S3009[int(1)] = 0.0f;
    _S3009[int(2)] = 0.0f;
    _S3009[int(3)] = 0.0f;
    _S3009[int(4)] = 0.0f;
    _S3009[int(5)] = 0.0f;
    _S3009[int(6)] = 0.0f;
    _S3009[int(7)] = 0.0f;
    _S3009[int(8)] = 0.0f;
    _S3009[int(9)] = 0.0f;
    _S3009[int(10)] = 0.0f;
    _S3009[int(11)] = 0.0f;
    _S3009[int(12)] = 0.0f;
    _S3009[int(13)] = 0.0f;
    _S3009[int(14)] = 0.0f;
    _S3009[int(15)] = 0.0f;
    _S3009[int(16)] = 0.0f;
    _S3009[int(17)] = 0.0f;
    _S3009[int(16)] = _S3008;
    float _S3010 = _S2987 + _S3009[int(0)];
    float _S3011 = _S2988 + _S3009[int(1)];
    float _S3012 = _S2989 + _S3009[int(2)];
    float _S3013 = _S2990 + _S3009[int(3)];
    float _S3014 = _S2991 + _S3009[int(4)];
    float _S3015 = _S2992 + _S3009[int(5)];
    float _S3016 = _S2993 + _S3009[int(6)];
    float _S3017 = _S2994 + _S3009[int(7)];
    float _S3018 = _S2995 + _S3009[int(8)];
    float _S3019 = _S2996 + _S3009[int(9)];
    float _S3020 = _S2997 + _S3009[int(10)];
    float _S3021 = _S2998 + _S3009[int(11)];
    float _S3022 = _S2999 + _S3009[int(12)];
    float _S3023 = _S3000 + _S3009[int(13)];
    float _S3024 = _S3001 + _S3009[int(14)];
    float _S3025 = _S3002 + _S3009[int(15)];
    float _S3026 = _S3003 + _S3009[int(16)];
    float _S3027 = _S3004 + _S3009[int(17)];
    if(_S2968)
    {
        float _S3028 = 200.0f * _S2980;
        float _S3029 = _S2969 * _S3028 + 0.5f * (_S2967 * _S3028);
        _S2969 = 0.0f;
        _S2972 = _S3029;
    }
    else
    {
        _S2969 = _S2980;
        _S2972 = 0.0f;
    }
    DiffPair_float_0 _S3030;
    (&_S3030)->primal_0 = _S2967;
    (&_S3030)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3030, _S2969);
    float _S3031 = (_S3030.differential_0 + _S2972) / _S2946;
    FixedArray<float, 18>  _S3032;
    _S3032[int(0)] = 0.0f;
    _S3032[int(1)] = 0.0f;
    _S3032[int(2)] = 0.0f;
    _S3032[int(3)] = 0.0f;
    _S3032[int(4)] = 0.0f;
    _S3032[int(5)] = 0.0f;
    _S3032[int(6)] = 0.0f;
    _S3032[int(7)] = 0.0f;
    _S3032[int(8)] = 0.0f;
    _S3032[int(9)] = 0.0f;
    _S3032[int(10)] = 0.0f;
    _S3032[int(11)] = 0.0f;
    _S3032[int(12)] = 0.0f;
    _S3032[int(13)] = 0.0f;
    _S3032[int(14)] = 0.0f;
    _S3032[int(15)] = 0.0f;
    _S3032[int(16)] = 0.0f;
    _S3032[int(17)] = 0.0f;
    _S3032[int(15)] = _S3031;
    float _S3033 = _S3010 + _S3032[int(0)];
    float _S3034 = _S3011 + _S3032[int(1)];
    float _S3035 = _S3012 + _S3032[int(2)];
    float _S3036 = _S3013 + _S3032[int(3)];
    float _S3037 = _S3014 + _S3032[int(4)];
    float _S3038 = _S3015 + _S3032[int(5)];
    float _S3039 = _S3016 + _S3032[int(6)];
    float _S3040 = _S3017 + _S3032[int(7)];
    float _S3041 = _S3018 + _S3032[int(8)];
    float _S3042 = _S3019 + _S3032[int(9)];
    float _S3043 = _S3020 + _S3032[int(10)];
    float _S3044 = _S3021 + _S3032[int(11)];
    float _S3045 = _S3022 + _S3032[int(12)];
    float _S3046 = _S3023 + _S3032[int(13)];
    float _S3047 = _S3024 + _S3032[int(14)];
    float _S3048 = _S3025 + _S3032[int(15)];
    float _S3049 = _S3026 + _S3032[int(16)];
    float _S3050 = _S3027 + _S3032[int(17)];
    if(_S2965)
    {
        float _S3051 = 200.0f * _S2980;
        float _S3052 = _S2966 * _S3051 + 0.5f * (_S2964 * _S3051);
        _S2966 = 0.0f;
        _S2969 = _S3052;
    }
    else
    {
        _S2966 = _S2980;
        _S2969 = 0.0f;
    }
    DiffPair_float_0 _S3053;
    (&_S3053)->primal_0 = _S2964;
    (&_S3053)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3053, _S2966);
    float _S3054 = (_S3053.differential_0 + _S2969) / _S2946;
    FixedArray<float, 18>  _S3055;
    _S3055[int(0)] = 0.0f;
    _S3055[int(1)] = 0.0f;
    _S3055[int(2)] = 0.0f;
    _S3055[int(3)] = 0.0f;
    _S3055[int(4)] = 0.0f;
    _S3055[int(5)] = 0.0f;
    _S3055[int(6)] = 0.0f;
    _S3055[int(7)] = 0.0f;
    _S3055[int(8)] = 0.0f;
    _S3055[int(9)] = 0.0f;
    _S3055[int(10)] = 0.0f;
    _S3055[int(11)] = 0.0f;
    _S3055[int(12)] = 0.0f;
    _S3055[int(13)] = 0.0f;
    _S3055[int(14)] = 0.0f;
    _S3055[int(15)] = 0.0f;
    _S3055[int(16)] = 0.0f;
    _S3055[int(17)] = 0.0f;
    _S3055[int(14)] = _S3054;
    float _S3056 = _S3033 + _S3055[int(0)];
    float _S3057 = _S3034 + _S3055[int(1)];
    float _S3058 = _S3035 + _S3055[int(2)];
    float _S3059 = _S3036 + _S3055[int(3)];
    float _S3060 = _S3037 + _S3055[int(4)];
    float _S3061 = _S3038 + _S3055[int(5)];
    float _S3062 = _S3039 + _S3055[int(6)];
    float _S3063 = _S3040 + _S3055[int(7)];
    float _S3064 = _S3041 + _S3055[int(8)];
    float _S3065 = _S3042 + _S3055[int(9)];
    float _S3066 = _S3043 + _S3055[int(10)];
    float _S3067 = _S3044 + _S3055[int(11)];
    float _S3068 = _S3045 + _S3055[int(12)];
    float _S3069 = _S3046 + _S3055[int(13)];
    float _S3070 = _S3047 + _S3055[int(14)];
    float _S3071 = _S3048 + _S3055[int(15)];
    float _S3072 = _S3049 + _S3055[int(16)];
    float _S3073 = _S3050 + _S3055[int(17)];
    if(_S2962)
    {
        float _S3074 = 200.0f * _S2980;
        float _S3075 = _S2963 * _S3074 + 0.5f * (_S2961 * _S3074);
        _S2963 = 0.0f;
        _S2966 = _S3075;
    }
    else
    {
        _S2963 = _S2980;
        _S2966 = 0.0f;
    }
    DiffPair_float_0 _S3076;
    (&_S3076)->primal_0 = _S2961;
    (&_S3076)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3076, _S2963);
    float _S3077 = (_S3076.differential_0 + _S2966) / _S2946;
    FixedArray<float, 18>  _S3078;
    _S3078[int(0)] = 0.0f;
    _S3078[int(1)] = 0.0f;
    _S3078[int(2)] = 0.0f;
    _S3078[int(3)] = 0.0f;
    _S3078[int(4)] = 0.0f;
    _S3078[int(5)] = 0.0f;
    _S3078[int(6)] = 0.0f;
    _S3078[int(7)] = 0.0f;
    _S3078[int(8)] = 0.0f;
    _S3078[int(9)] = 0.0f;
    _S3078[int(10)] = 0.0f;
    _S3078[int(11)] = 0.0f;
    _S3078[int(12)] = 0.0f;
    _S3078[int(13)] = 0.0f;
    _S3078[int(14)] = 0.0f;
    _S3078[int(15)] = 0.0f;
    _S3078[int(16)] = 0.0f;
    _S3078[int(17)] = 0.0f;
    _S3078[int(13)] = _S3077;
    float _S3079 = _S3056 + _S3078[int(0)];
    float _S3080 = _S3057 + _S3078[int(1)];
    float _S3081 = _S3058 + _S3078[int(2)];
    float _S3082 = _S3059 + _S3078[int(3)];
    float _S3083 = _S3060 + _S3078[int(4)];
    float _S3084 = _S3061 + _S3078[int(5)];
    float _S3085 = _S3062 + _S3078[int(6)];
    float _S3086 = _S3063 + _S3078[int(7)];
    float _S3087 = _S3064 + _S3078[int(8)];
    float _S3088 = _S3065 + _S3078[int(9)];
    float _S3089 = _S3066 + _S3078[int(10)];
    float _S3090 = _S3067 + _S3078[int(11)];
    float _S3091 = _S3068 + _S3078[int(12)];
    float _S3092 = _S3069 + _S3078[int(13)];
    float _S3093 = _S3070 + _S3078[int(14)];
    float _S3094 = _S3071 + _S3078[int(15)];
    float _S3095 = _S3072 + _S3078[int(16)];
    float _S3096 = _S3073 + _S3078[int(17)];
    if(_S2959)
    {
        float _S3097 = 200.0f * _S2980;
        float _S3098 = _S2960 * _S3097 + 0.5f * (_S2958 * _S3097);
        _S2960 = 0.0f;
        _S2963 = _S3098;
    }
    else
    {
        _S2960 = _S2980;
        _S2963 = 0.0f;
    }
    DiffPair_float_0 _S3099;
    (&_S3099)->primal_0 = _S2958;
    (&_S3099)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3099, _S2960);
    float _S3100 = (_S3099.differential_0 + _S2963) / _S2946;
    FixedArray<float, 18>  _S3101;
    _S3101[int(0)] = 0.0f;
    _S3101[int(1)] = 0.0f;
    _S3101[int(2)] = 0.0f;
    _S3101[int(3)] = 0.0f;
    _S3101[int(4)] = 0.0f;
    _S3101[int(5)] = 0.0f;
    _S3101[int(6)] = 0.0f;
    _S3101[int(7)] = 0.0f;
    _S3101[int(8)] = 0.0f;
    _S3101[int(9)] = 0.0f;
    _S3101[int(10)] = 0.0f;
    _S3101[int(11)] = 0.0f;
    _S3101[int(12)] = 0.0f;
    _S3101[int(13)] = 0.0f;
    _S3101[int(14)] = 0.0f;
    _S3101[int(15)] = 0.0f;
    _S3101[int(16)] = 0.0f;
    _S3101[int(17)] = 0.0f;
    _S3101[int(12)] = _S3100;
    float _S3102 = _S3079 + _S3101[int(0)];
    float _S3103 = _S3080 + _S3101[int(1)];
    float _S3104 = _S3081 + _S3101[int(2)];
    float _S3105 = _S3082 + _S3101[int(3)];
    float _S3106 = _S3083 + _S3101[int(4)];
    float _S3107 = _S3084 + _S3101[int(5)];
    float _S3108 = _S3085 + _S3101[int(6)];
    float _S3109 = _S3086 + _S3101[int(7)];
    float _S3110 = _S3087 + _S3101[int(8)];
    float _S3111 = _S3088 + _S3101[int(9)];
    float _S3112 = _S3089 + _S3101[int(10)];
    float _S3113 = _S3090 + _S3101[int(11)];
    float _S3114 = _S3091 + _S3101[int(12)];
    float _S3115 = _S3092 + _S3101[int(13)];
    float _S3116 = _S3093 + _S3101[int(14)];
    float _S3117 = _S3094 + _S3101[int(15)];
    float _S3118 = _S3095 + _S3101[int(16)];
    float _S3119 = _S3096 + _S3101[int(17)];
    if(_S2956)
    {
        float _S3120 = 200.0f * _S2980;
        float _S3121 = _S2957 * _S3120 + 0.5f * (_S2955 * _S3120);
        _S2957 = 0.0f;
        _S2960 = _S3121;
    }
    else
    {
        _S2957 = _S2980;
        _S2960 = 0.0f;
    }
    DiffPair_float_0 _S3122;
    (&_S3122)->primal_0 = _S2955;
    (&_S3122)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3122, _S2957);
    float _S3123 = (_S3122.differential_0 + _S2960) / _S2946;
    FixedArray<float, 18>  _S3124;
    _S3124[int(0)] = 0.0f;
    _S3124[int(1)] = 0.0f;
    _S3124[int(2)] = 0.0f;
    _S3124[int(3)] = 0.0f;
    _S3124[int(4)] = 0.0f;
    _S3124[int(5)] = 0.0f;
    _S3124[int(6)] = 0.0f;
    _S3124[int(7)] = 0.0f;
    _S3124[int(8)] = 0.0f;
    _S3124[int(9)] = 0.0f;
    _S3124[int(10)] = 0.0f;
    _S3124[int(11)] = 0.0f;
    _S3124[int(12)] = 0.0f;
    _S3124[int(13)] = 0.0f;
    _S3124[int(14)] = 0.0f;
    _S3124[int(15)] = 0.0f;
    _S3124[int(16)] = 0.0f;
    _S3124[int(17)] = 0.0f;
    _S3124[int(11)] = _S3123;
    float _S3125 = _S3102 + _S3124[int(0)];
    float _S3126 = _S3103 + _S3124[int(1)];
    float _S3127 = _S3104 + _S3124[int(2)];
    float _S3128 = _S3105 + _S3124[int(3)];
    float _S3129 = _S3106 + _S3124[int(4)];
    float _S3130 = _S3107 + _S3124[int(5)];
    float _S3131 = _S3108 + _S3124[int(6)];
    float _S3132 = _S3109 + _S3124[int(7)];
    float _S3133 = _S3110 + _S3124[int(8)];
    float _S3134 = _S3111 + _S3124[int(9)];
    float _S3135 = _S3112 + _S3124[int(10)];
    float _S3136 = _S3113 + _S3124[int(11)];
    float _S3137 = _S3114 + _S3124[int(12)];
    float _S3138 = _S3115 + _S3124[int(13)];
    float _S3139 = _S3116 + _S3124[int(14)];
    float _S3140 = _S3117 + _S3124[int(15)];
    float _S3141 = _S3118 + _S3124[int(16)];
    float _S3142 = _S3119 + _S3124[int(17)];
    if(_S2953)
    {
        float _S3143 = 200.0f * _S2980;
        float _S3144 = _S2954 * _S3143 + 0.5f * (_S2952 * _S3143);
        _S2954 = 0.0f;
        _S2957 = _S3144;
    }
    else
    {
        _S2954 = _S2980;
        _S2957 = 0.0f;
    }
    DiffPair_float_0 _S3145;
    (&_S3145)->primal_0 = _S2952;
    (&_S3145)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3145, _S2954);
    float _S3146 = (_S3145.differential_0 + _S2957) / _S2946;
    float _S3147 = _S2976 / _S2951;
    float _S3148 = _S2977 / _S2950;
    float _S3149 = _S2978 / _S2949;
    FixedArray<float, 18>  _S3150;
    _S3150[int(0)] = 0.0f;
    _S3150[int(1)] = 0.0f;
    _S3150[int(2)] = 0.0f;
    _S3150[int(3)] = 0.0f;
    _S3150[int(4)] = 0.0f;
    _S3150[int(5)] = 0.0f;
    _S3150[int(6)] = 0.0f;
    _S3150[int(7)] = 0.0f;
    _S3150[int(8)] = 0.0f;
    _S3150[int(9)] = 0.0f;
    _S3150[int(10)] = 0.0f;
    _S3150[int(11)] = 0.0f;
    _S3150[int(12)] = 0.0f;
    _S3150[int(13)] = 0.0f;
    _S3150[int(14)] = 0.0f;
    _S3150[int(15)] = 0.0f;
    _S3150[int(16)] = 0.0f;
    _S3150[int(17)] = 0.0f;
    _S3150[int(10)] = _S3146;
    _S3150[int(9)] = _S3147;
    _S3150[int(8)] = _S3147;
    _S3150[int(7)] = _S3147;
    _S3150[int(6)] = _S3147;
    _S3150[int(5)] = _S3147;
    _S3150[int(4)] = _S3148;
    _S3150[int(3)] = _S3148;
    _S3150[int(2)] = _S3148;
    _S3150[int(1)] = _S3149;
    float _S3151 = _S3125 + _S3150[int(0)];
    float _S3152 = _S3126 + _S3150[int(1)];
    float _S3153 = _S3127 + _S3150[int(2)];
    float _S3154 = _S3128 + _S3150[int(3)];
    float _S3155 = _S3129 + _S3150[int(4)];
    float _S3156 = _S3130 + _S3150[int(5)];
    float _S3157 = _S3131 + _S3150[int(6)];
    float _S3158 = _S3132 + _S3150[int(7)];
    float _S3159 = _S3133 + _S3150[int(8)];
    float _S3160 = _S3134 + _S3150[int(9)];
    float _S3161 = _S3135 + _S3150[int(10)];
    float _S3162 = _S3136 + _S3150[int(11)];
    float _S3163 = _S3137 + _S3150[int(12)];
    float _S3164 = _S3138 + _S3150[int(13)];
    float _S3165 = _S3139 + _S3150[int(14)];
    float _S3166 = _S3140 + _S3150[int(15)];
    float _S3167 = _S3141 + _S3150[int(16)];
    float _S3168 = _S3142 + _S3150[int(17)];
    if(_S2947)
    {
        float _S3169 = 10.0f * _S2979;
        float _S3170 = _S2948 * _S3169 + 0.5f * (mean_59 * _S3169);
        _S2948 = 0.0f;
        _S2954 = _S3170;
    }
    else
    {
        _S2948 = _S2979;
        _S2954 = 0.0f;
    }
    DiffPair_float_0 _S3171;
    (&_S3171)->primal_0 = mean_59;
    (&_S3171)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3171, _S2948);
    float _S3172 = _S3171.differential_0 + _S2954;
    if(exposure_arithmetic_mean_19)
    {
        DiffPair_float_0 _S3173;
        (&_S3173)->primal_0 = mean_58;
        (&_S3173)->differential_0 = 0.0f;
        s_bwd_prop_log2_0(&_S3173, _S3172);
        mean_59 = _S3173.differential_0;
    }
    else
    {
        mean_59 = _S3172;
    }
    float _S3174 = mean_59 / _S2946;
    FixedArray<float, 18>  _S3175;
    _S3175[int(0)] = 0.0f;
    _S3175[int(1)] = 0.0f;
    _S3175[int(2)] = 0.0f;
    _S3175[int(3)] = 0.0f;
    _S3175[int(4)] = 0.0f;
    _S3175[int(5)] = 0.0f;
    _S3175[int(6)] = 0.0f;
    _S3175[int(7)] = 0.0f;
    _S3175[int(8)] = 0.0f;
    _S3175[int(9)] = 0.0f;
    _S3175[int(10)] = 0.0f;
    _S3175[int(11)] = 0.0f;
    _S3175[int(12)] = 0.0f;
    _S3175[int(13)] = 0.0f;
    _S3175[int(14)] = 0.0f;
    _S3175[int(15)] = 0.0f;
    _S3175[int(16)] = 0.0f;
    _S3175[int(17)] = 0.0f;
    _S3175[int(0)] = _S3174;
    FixedArray<float, 18>  _S3176 = {
        _S3151 + _S3175[int(0)], _S3152 + _S3175[int(1)], _S3153 + _S3175[int(2)], _S3154 + _S3175[int(3)], _S3155 + _S3175[int(4)], _S3156 + _S3175[int(5)], _S3157 + _S3175[int(6)], _S3158 + _S3175[int(7)], _S3159 + _S3175[int(8)], _S3160 + _S3175[int(9)], _S3161 + _S3175[int(10)], _S3162 + _S3175[int(11)], _S3163 + _S3175[int(12)], _S3164 + _S3175[int(13)], _S3165 + _S3175[int(14)], _S3166 + _S3175[int(15)], _S3167 + _S3175[int(16)], _S3168 + _S3175[int(17)]
    };
    dpraw_losses_2->primal_0 = dpraw_losses_2->primal_0;
    dpraw_losses_2->differential_0 = _S3176;
    return;
}

inline __device__ void s_bwd_compute_ppisp_no_crf_regularization_loss_0(DiffPair_arrayx3Cfloatx2C18x3E_0 * _S3177, int _S3178, bool _S3179, FixedArray<float, 6>  * _S3180, FixedArray<float, 6>  * _S3181)
{
    s_bwd_prop_compute_ppisp_no_crf_regularization_loss_0(_S3177, _S3178, _S3179, _S3180, _S3181);
    return;
}

inline __device__ void compute_ppisp_no_crf_regularization_loss_vjp(FixedArray<float, 18>  raw_losses_5, int num_cameras_8, bool exposure_arithmetic_mean_20, FixedArray<float, 6>  loss_weights_8, FixedArray<float, 6>  grad_out_10, FixedArray<float, 18>  * _S3182)
{
    FixedArray<float, 18>  _S3183 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C18x3E_0 dp_raw_losses_2;
    (&dp_raw_losses_2)->primal_0 = raw_losses_5;
    (&dp_raw_losses_2)->differential_0 = _S3183;
    FixedArray<float, 6>  _S3184 = loss_weights_8;
    FixedArray<float, 6>  _S3185 = grad_out_10;
    s_bwd_compute_ppisp_no_crf_regularization_loss_0(&dp_raw_losses_2, num_cameras_8, exposure_arithmetic_mean_20, &_S3184, &_S3185);
    *_S3182 = (&dp_raw_losses_2)->differential_0;
    return;
}

inline __device__ void compute_ppisp_no_crf_no_vig_regularization_loss(FixedArray<float, 9>  raw_losses_6, int num_cameras_9, bool exposure_arithmetic_mean_21, FixedArray<float, 6>  loss_weights_9, FixedArray<float, 6>  * _S3186)
{
    float mean_60;
    float _S3187;
    FixedArray<float, 6>  losses_7;
    for(;;)
    {
        float _S3188 = float(num_cameras_9);
        _S3187 = _S3188;
        float mean_61 = raw_losses_6[int(0)] / _S3188;
        if(exposure_arithmetic_mean_21)
        {
            mean_60 = (F32_log2((mean_61)));
        }
        else
        {
            mean_60 = mean_61;
        }
        for(;;)
        {
            float _S3189 = (F32_abs((mean_60)));
            if(_S3189 < 0.10000000149011612f)
            {
                mean_60 = 0.5f * mean_60 * mean_60 / 0.10000000149011612f;
                break;
            }
            else
            {
                mean_60 = _S3189 - 0.05000000074505806f;
                break;
            }
        }
        break;
    }
    losses_7[int(0)] = mean_60;
    float _S3190 = raw_losses_6[int(1)] / _S3187;
    for(;;)
    {
        float _S3191 = (F32_abs((_S3190)));
        if(_S3191 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3190 * _S3190 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3191 - 0.00249999994412065f;
            break;
        }
    }
    float _S3192;
    float _S3193 = raw_losses_6[int(2)] / _S3187;
    for(;;)
    {
        float _S3194 = (F32_abs((_S3193)));
        if(_S3194 < 0.00499999988824129f)
        {
            _S3192 = 0.5f * _S3193 * _S3193 / 0.00499999988824129f;
            break;
        }
        else
        {
            _S3192 = _S3194 - 0.00249999994412065f;
            break;
        }
    }
    float _S3195 = mean_60 + _S3192;
    float _S3196 = raw_losses_6[int(3)] / _S3187;
    for(;;)
    {
        float _S3197 = (F32_abs((_S3196)));
        if(_S3197 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3196 * _S3196 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3197 - 0.00249999994412065f;
            break;
        }
    }
    float _S3198 = _S3195 + mean_60;
    float _S3199 = raw_losses_6[int(4)] / _S3187;
    for(;;)
    {
        float _S3200 = (F32_abs((_S3199)));
        if(_S3200 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3199 * _S3199 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3200 - 0.00249999994412065f;
            break;
        }
    }
    float _S3201 = _S3198 + mean_60;
    float _S3202 = raw_losses_6[int(5)] / _S3187;
    for(;;)
    {
        float _S3203 = (F32_abs((_S3202)));
        if(_S3203 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3202 * _S3202 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3203 - 0.00249999994412065f;
            break;
        }
    }
    float _S3204 = _S3201 + mean_60;
    float _S3205 = raw_losses_6[int(6)] / _S3187;
    for(;;)
    {
        float _S3206 = (F32_abs((_S3205)));
        if(_S3206 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3205 * _S3205 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3206 - 0.00249999994412065f;
            break;
        }
    }
    float _S3207 = _S3204 + mean_60;
    float _S3208 = raw_losses_6[int(7)] / _S3187;
    for(;;)
    {
        float _S3209 = (F32_abs((_S3208)));
        if(_S3209 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3208 * _S3208 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3209 - 0.00249999994412065f;
            break;
        }
    }
    float _S3210 = _S3207 + mean_60;
    float _S3211 = raw_losses_6[int(8)] / _S3187;
    for(;;)
    {
        float _S3212 = (F32_abs((_S3211)));
        if(_S3212 < 0.00499999988824129f)
        {
            mean_60 = 0.5f * _S3211 * _S3211 / 0.00499999988824129f;
            break;
        }
        else
        {
            mean_60 = _S3212 - 0.00249999994412065f;
            break;
        }
    }
    float _S3213 = (_S3210 + mean_60) / 8.0f;
    losses_7[int(1)] = 0.0f;
    losses_7[int(2)] = 0.0f;
    losses_7[int(3)] = 0.0f;
    losses_7[int(5)] = 0.0f;
    losses_7[int(0)] = losses_7[int(0)] * loss_weights_9[int(0)];
    losses_7[int(4)] = _S3213 * loss_weights_9[int(4)];
    *_S3186 = losses_7;
    return;
}

inline __device__ void s_bwd_prop_compute_ppisp_no_crf_no_vig_regularization_loss_0(DiffPair_arrayx3Cfloatx2C9x3E_0 * dpraw_losses_3, int num_cameras_10, bool exposure_arithmetic_mean_22, FixedArray<float, 6>  * loss_weights_10, FixedArray<float, 6>  * _s_dOut_11)
{
    FixedArray<float, 9>  _S3214 = dpraw_losses_3->primal_0;
    float _S3215 = float(num_cameras_10);
    float mean_62 = dpraw_losses_3->primal_0[int(0)] / _S3215;
    float mean_63;
    if(exposure_arithmetic_mean_22)
    {
        mean_63 = s_primal_ctx_log2_0(mean_62);
    }
    else
    {
        mean_63 = mean_62;
    }
    bool _S3216 = (s_primal_ctx_abs_0(mean_63)) < 0.10000000149011612f;
    float _S3217;
    if(_S3216)
    {
        _S3217 = 0.5f * mean_63;
    }
    else
    {
        _S3217 = 0.0f;
    }
    float _S3218 = _S3214[int(1)] / _S3215;
    bool _S3219 = (s_primal_ctx_abs_0(_S3218)) < 0.00499999988824129f;
    float _S3220;
    if(_S3219)
    {
        _S3220 = 0.5f * _S3218;
    }
    else
    {
        _S3220 = 0.0f;
    }
    float _S3221 = _S3214[int(2)] / _S3215;
    bool _S3222 = (s_primal_ctx_abs_0(_S3221)) < 0.00499999988824129f;
    float _S3223;
    if(_S3222)
    {
        _S3223 = 0.5f * _S3221;
    }
    else
    {
        _S3223 = 0.0f;
    }
    float _S3224 = _S3214[int(3)] / _S3215;
    bool _S3225 = (s_primal_ctx_abs_0(_S3224)) < 0.00499999988824129f;
    float _S3226;
    if(_S3225)
    {
        _S3226 = 0.5f * _S3224;
    }
    else
    {
        _S3226 = 0.0f;
    }
    float _S3227 = _S3214[int(4)] / _S3215;
    bool _S3228 = (s_primal_ctx_abs_0(_S3227)) < 0.00499999988824129f;
    float _S3229;
    if(_S3228)
    {
        _S3229 = 0.5f * _S3227;
    }
    else
    {
        _S3229 = 0.0f;
    }
    float _S3230 = _S3214[int(5)] / _S3215;
    bool _S3231 = (s_primal_ctx_abs_0(_S3230)) < 0.00499999988824129f;
    float _S3232;
    if(_S3231)
    {
        _S3232 = 0.5f * _S3230;
    }
    else
    {
        _S3232 = 0.0f;
    }
    float _S3233 = _S3214[int(6)] / _S3215;
    bool _S3234 = (s_primal_ctx_abs_0(_S3233)) < 0.00499999988824129f;
    float _S3235;
    if(_S3234)
    {
        _S3235 = 0.5f * _S3233;
    }
    else
    {
        _S3235 = 0.0f;
    }
    float _S3236 = _S3214[int(7)] / _S3215;
    bool _S3237 = (s_primal_ctx_abs_0(_S3236)) < 0.00499999988824129f;
    float _S3238;
    if(_S3237)
    {
        _S3238 = 0.5f * _S3236;
    }
    else
    {
        _S3238 = 0.0f;
    }
    float _S3239 = _S3214[int(8)] / _S3215;
    bool _S3240 = (s_primal_ctx_abs_0(_S3239)) < 0.00499999988824129f;
    float _S3241;
    if(_S3240)
    {
        _S3241 = 0.5f * _S3239;
    }
    else
    {
        _S3241 = 0.0f;
    }
    float _S3242 = (*loss_weights_10)[int(0)] * (*_s_dOut_11)[int(0)];
    float _S3243 = 0.125f * ((*loss_weights_10)[int(4)] * (*_s_dOut_11)[int(4)]);
    float _S3244;
    if(_S3240)
    {
        float _S3245 = 200.0f * _S3243;
        float _S3246 = _S3241 * _S3245 + 0.5f * (_S3239 * _S3245);
        _S3241 = 0.0f;
        _S3244 = _S3246;
    }
    else
    {
        _S3241 = _S3243;
        _S3244 = 0.0f;
    }
    DiffPair_float_0 _S3247;
    (&_S3247)->primal_0 = _S3239;
    (&_S3247)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3247, _S3241);
    float _S3248 = (_S3247.differential_0 + _S3244) / _S3215;
    FixedArray<float, 9>  _S3249;
    _S3249[int(0)] = 0.0f;
    _S3249[int(1)] = 0.0f;
    _S3249[int(2)] = 0.0f;
    _S3249[int(3)] = 0.0f;
    _S3249[int(4)] = 0.0f;
    _S3249[int(5)] = 0.0f;
    _S3249[int(6)] = 0.0f;
    _S3249[int(7)] = 0.0f;
    _S3249[int(8)] = 0.0f;
    _S3249[int(8)] = _S3248;
    float _S3250 = _S3249[int(0)];
    float _S3251 = _S3249[int(1)];
    float _S3252 = _S3249[int(2)];
    float _S3253 = _S3249[int(3)];
    float _S3254 = _S3249[int(4)];
    float _S3255 = _S3249[int(5)];
    float _S3256 = _S3249[int(6)];
    float _S3257 = _S3249[int(7)];
    float _S3258 = _S3249[int(8)];
    if(_S3237)
    {
        float _S3259 = 200.0f * _S3243;
        float _S3260 = _S3238 * _S3259 + 0.5f * (_S3236 * _S3259);
        _S3238 = 0.0f;
        _S3241 = _S3260;
    }
    else
    {
        _S3238 = _S3243;
        _S3241 = 0.0f;
    }
    DiffPair_float_0 _S3261;
    (&_S3261)->primal_0 = _S3236;
    (&_S3261)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3261, _S3238);
    float _S3262 = (_S3261.differential_0 + _S3241) / _S3215;
    FixedArray<float, 9>  _S3263;
    _S3263[int(0)] = 0.0f;
    _S3263[int(1)] = 0.0f;
    _S3263[int(2)] = 0.0f;
    _S3263[int(3)] = 0.0f;
    _S3263[int(4)] = 0.0f;
    _S3263[int(5)] = 0.0f;
    _S3263[int(6)] = 0.0f;
    _S3263[int(7)] = 0.0f;
    _S3263[int(8)] = 0.0f;
    _S3263[int(7)] = _S3262;
    float _S3264 = _S3250 + _S3263[int(0)];
    float _S3265 = _S3251 + _S3263[int(1)];
    float _S3266 = _S3252 + _S3263[int(2)];
    float _S3267 = _S3253 + _S3263[int(3)];
    float _S3268 = _S3254 + _S3263[int(4)];
    float _S3269 = _S3255 + _S3263[int(5)];
    float _S3270 = _S3256 + _S3263[int(6)];
    float _S3271 = _S3257 + _S3263[int(7)];
    float _S3272 = _S3258 + _S3263[int(8)];
    if(_S3234)
    {
        float _S3273 = 200.0f * _S3243;
        float _S3274 = _S3235 * _S3273 + 0.5f * (_S3233 * _S3273);
        _S3235 = 0.0f;
        _S3238 = _S3274;
    }
    else
    {
        _S3235 = _S3243;
        _S3238 = 0.0f;
    }
    DiffPair_float_0 _S3275;
    (&_S3275)->primal_0 = _S3233;
    (&_S3275)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3275, _S3235);
    float _S3276 = (_S3275.differential_0 + _S3238) / _S3215;
    FixedArray<float, 9>  _S3277;
    _S3277[int(0)] = 0.0f;
    _S3277[int(1)] = 0.0f;
    _S3277[int(2)] = 0.0f;
    _S3277[int(3)] = 0.0f;
    _S3277[int(4)] = 0.0f;
    _S3277[int(5)] = 0.0f;
    _S3277[int(6)] = 0.0f;
    _S3277[int(7)] = 0.0f;
    _S3277[int(8)] = 0.0f;
    _S3277[int(6)] = _S3276;
    float _S3278 = _S3264 + _S3277[int(0)];
    float _S3279 = _S3265 + _S3277[int(1)];
    float _S3280 = _S3266 + _S3277[int(2)];
    float _S3281 = _S3267 + _S3277[int(3)];
    float _S3282 = _S3268 + _S3277[int(4)];
    float _S3283 = _S3269 + _S3277[int(5)];
    float _S3284 = _S3270 + _S3277[int(6)];
    float _S3285 = _S3271 + _S3277[int(7)];
    float _S3286 = _S3272 + _S3277[int(8)];
    if(_S3231)
    {
        float _S3287 = 200.0f * _S3243;
        float _S3288 = _S3232 * _S3287 + 0.5f * (_S3230 * _S3287);
        _S3232 = 0.0f;
        _S3235 = _S3288;
    }
    else
    {
        _S3232 = _S3243;
        _S3235 = 0.0f;
    }
    DiffPair_float_0 _S3289;
    (&_S3289)->primal_0 = _S3230;
    (&_S3289)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3289, _S3232);
    float _S3290 = (_S3289.differential_0 + _S3235) / _S3215;
    FixedArray<float, 9>  _S3291;
    _S3291[int(0)] = 0.0f;
    _S3291[int(1)] = 0.0f;
    _S3291[int(2)] = 0.0f;
    _S3291[int(3)] = 0.0f;
    _S3291[int(4)] = 0.0f;
    _S3291[int(5)] = 0.0f;
    _S3291[int(6)] = 0.0f;
    _S3291[int(7)] = 0.0f;
    _S3291[int(8)] = 0.0f;
    _S3291[int(5)] = _S3290;
    float _S3292 = _S3278 + _S3291[int(0)];
    float _S3293 = _S3279 + _S3291[int(1)];
    float _S3294 = _S3280 + _S3291[int(2)];
    float _S3295 = _S3281 + _S3291[int(3)];
    float _S3296 = _S3282 + _S3291[int(4)];
    float _S3297 = _S3283 + _S3291[int(5)];
    float _S3298 = _S3284 + _S3291[int(6)];
    float _S3299 = _S3285 + _S3291[int(7)];
    float _S3300 = _S3286 + _S3291[int(8)];
    if(_S3228)
    {
        float _S3301 = 200.0f * _S3243;
        float _S3302 = _S3229 * _S3301 + 0.5f * (_S3227 * _S3301);
        _S3229 = 0.0f;
        _S3232 = _S3302;
    }
    else
    {
        _S3229 = _S3243;
        _S3232 = 0.0f;
    }
    DiffPair_float_0 _S3303;
    (&_S3303)->primal_0 = _S3227;
    (&_S3303)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3303, _S3229);
    float _S3304 = (_S3303.differential_0 + _S3232) / _S3215;
    FixedArray<float, 9>  _S3305;
    _S3305[int(0)] = 0.0f;
    _S3305[int(1)] = 0.0f;
    _S3305[int(2)] = 0.0f;
    _S3305[int(3)] = 0.0f;
    _S3305[int(4)] = 0.0f;
    _S3305[int(5)] = 0.0f;
    _S3305[int(6)] = 0.0f;
    _S3305[int(7)] = 0.0f;
    _S3305[int(8)] = 0.0f;
    _S3305[int(4)] = _S3304;
    float _S3306 = _S3292 + _S3305[int(0)];
    float _S3307 = _S3293 + _S3305[int(1)];
    float _S3308 = _S3294 + _S3305[int(2)];
    float _S3309 = _S3295 + _S3305[int(3)];
    float _S3310 = _S3296 + _S3305[int(4)];
    float _S3311 = _S3297 + _S3305[int(5)];
    float _S3312 = _S3298 + _S3305[int(6)];
    float _S3313 = _S3299 + _S3305[int(7)];
    float _S3314 = _S3300 + _S3305[int(8)];
    if(_S3225)
    {
        float _S3315 = 200.0f * _S3243;
        float _S3316 = _S3226 * _S3315 + 0.5f * (_S3224 * _S3315);
        _S3226 = 0.0f;
        _S3229 = _S3316;
    }
    else
    {
        _S3226 = _S3243;
        _S3229 = 0.0f;
    }
    DiffPair_float_0 _S3317;
    (&_S3317)->primal_0 = _S3224;
    (&_S3317)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3317, _S3226);
    float _S3318 = (_S3317.differential_0 + _S3229) / _S3215;
    FixedArray<float, 9>  _S3319;
    _S3319[int(0)] = 0.0f;
    _S3319[int(1)] = 0.0f;
    _S3319[int(2)] = 0.0f;
    _S3319[int(3)] = 0.0f;
    _S3319[int(4)] = 0.0f;
    _S3319[int(5)] = 0.0f;
    _S3319[int(6)] = 0.0f;
    _S3319[int(7)] = 0.0f;
    _S3319[int(8)] = 0.0f;
    _S3319[int(3)] = _S3318;
    float _S3320 = _S3306 + _S3319[int(0)];
    float _S3321 = _S3307 + _S3319[int(1)];
    float _S3322 = _S3308 + _S3319[int(2)];
    float _S3323 = _S3309 + _S3319[int(3)];
    float _S3324 = _S3310 + _S3319[int(4)];
    float _S3325 = _S3311 + _S3319[int(5)];
    float _S3326 = _S3312 + _S3319[int(6)];
    float _S3327 = _S3313 + _S3319[int(7)];
    float _S3328 = _S3314 + _S3319[int(8)];
    if(_S3222)
    {
        float _S3329 = 200.0f * _S3243;
        float _S3330 = _S3223 * _S3329 + 0.5f * (_S3221 * _S3329);
        _S3223 = 0.0f;
        _S3226 = _S3330;
    }
    else
    {
        _S3223 = _S3243;
        _S3226 = 0.0f;
    }
    DiffPair_float_0 _S3331;
    (&_S3331)->primal_0 = _S3221;
    (&_S3331)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3331, _S3223);
    float _S3332 = (_S3331.differential_0 + _S3226) / _S3215;
    FixedArray<float, 9>  _S3333;
    _S3333[int(0)] = 0.0f;
    _S3333[int(1)] = 0.0f;
    _S3333[int(2)] = 0.0f;
    _S3333[int(3)] = 0.0f;
    _S3333[int(4)] = 0.0f;
    _S3333[int(5)] = 0.0f;
    _S3333[int(6)] = 0.0f;
    _S3333[int(7)] = 0.0f;
    _S3333[int(8)] = 0.0f;
    _S3333[int(2)] = _S3332;
    float _S3334 = _S3320 + _S3333[int(0)];
    float _S3335 = _S3321 + _S3333[int(1)];
    float _S3336 = _S3322 + _S3333[int(2)];
    float _S3337 = _S3323 + _S3333[int(3)];
    float _S3338 = _S3324 + _S3333[int(4)];
    float _S3339 = _S3325 + _S3333[int(5)];
    float _S3340 = _S3326 + _S3333[int(6)];
    float _S3341 = _S3327 + _S3333[int(7)];
    float _S3342 = _S3328 + _S3333[int(8)];
    if(_S3219)
    {
        float _S3343 = 200.0f * _S3243;
        float _S3344 = _S3220 * _S3343 + 0.5f * (_S3218 * _S3343);
        _S3220 = 0.0f;
        _S3223 = _S3344;
    }
    else
    {
        _S3220 = _S3243;
        _S3223 = 0.0f;
    }
    DiffPair_float_0 _S3345;
    (&_S3345)->primal_0 = _S3218;
    (&_S3345)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3345, _S3220);
    float _S3346 = (_S3345.differential_0 + _S3223) / _S3215;
    FixedArray<float, 9>  _S3347;
    _S3347[int(0)] = 0.0f;
    _S3347[int(1)] = 0.0f;
    _S3347[int(2)] = 0.0f;
    _S3347[int(3)] = 0.0f;
    _S3347[int(4)] = 0.0f;
    _S3347[int(5)] = 0.0f;
    _S3347[int(6)] = 0.0f;
    _S3347[int(7)] = 0.0f;
    _S3347[int(8)] = 0.0f;
    _S3347[int(1)] = _S3346;
    float _S3348 = _S3334 + _S3347[int(0)];
    float _S3349 = _S3335 + _S3347[int(1)];
    float _S3350 = _S3336 + _S3347[int(2)];
    float _S3351 = _S3337 + _S3347[int(3)];
    float _S3352 = _S3338 + _S3347[int(4)];
    float _S3353 = _S3339 + _S3347[int(5)];
    float _S3354 = _S3340 + _S3347[int(6)];
    float _S3355 = _S3341 + _S3347[int(7)];
    float _S3356 = _S3342 + _S3347[int(8)];
    if(_S3216)
    {
        float _S3357 = 10.0f * _S3242;
        float _S3358 = _S3217 * _S3357 + 0.5f * (mean_63 * _S3357);
        _S3217 = 0.0f;
        _S3220 = _S3358;
    }
    else
    {
        _S3217 = _S3242;
        _S3220 = 0.0f;
    }
    DiffPair_float_0 _S3359;
    (&_S3359)->primal_0 = mean_63;
    (&_S3359)->differential_0 = 0.0f;
    s_bwd_prop_abs_0(&_S3359, _S3217);
    float _S3360 = _S3359.differential_0 + _S3220;
    if(exposure_arithmetic_mean_22)
    {
        DiffPair_float_0 _S3361;
        (&_S3361)->primal_0 = mean_62;
        (&_S3361)->differential_0 = 0.0f;
        s_bwd_prop_log2_0(&_S3361, _S3360);
        mean_63 = _S3361.differential_0;
    }
    else
    {
        mean_63 = _S3360;
    }
    float _S3362 = mean_63 / _S3215;
    FixedArray<float, 9>  _S3363;
    _S3363[int(0)] = 0.0f;
    _S3363[int(1)] = 0.0f;
    _S3363[int(2)] = 0.0f;
    _S3363[int(3)] = 0.0f;
    _S3363[int(4)] = 0.0f;
    _S3363[int(5)] = 0.0f;
    _S3363[int(6)] = 0.0f;
    _S3363[int(7)] = 0.0f;
    _S3363[int(8)] = 0.0f;
    _S3363[int(0)] = _S3362;
    FixedArray<float, 9>  _S3364 = {
        _S3348 + _S3363[int(0)], _S3349 + _S3363[int(1)], _S3350 + _S3363[int(2)], _S3351 + _S3363[int(3)], _S3352 + _S3363[int(4)], _S3353 + _S3363[int(5)], _S3354 + _S3363[int(6)], _S3355 + _S3363[int(7)], _S3356 + _S3363[int(8)]
    };
    dpraw_losses_3->primal_0 = dpraw_losses_3->primal_0;
    dpraw_losses_3->differential_0 = _S3364;
    return;
}

inline __device__ void s_bwd_compute_ppisp_no_crf_no_vig_regularization_loss_0(DiffPair_arrayx3Cfloatx2C9x3E_0 * _S3365, int _S3366, bool _S3367, FixedArray<float, 6>  * _S3368, FixedArray<float, 6>  * _S3369)
{
    s_bwd_prop_compute_ppisp_no_crf_no_vig_regularization_loss_0(_S3365, _S3366, _S3367, _S3368, _S3369);
    return;
}

inline __device__ void compute_ppisp_no_crf_no_vig_regularization_loss_vjp(FixedArray<float, 9>  raw_losses_7, int num_cameras_11, bool exposure_arithmetic_mean_23, FixedArray<float, 6>  loss_weights_11, FixedArray<float, 6>  grad_out_11, FixedArray<float, 9>  * _S3370)
{
    FixedArray<float, 9>  _S3371 = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
    DiffPair_arrayx3Cfloatx2C9x3E_0 dp_raw_losses_3;
    (&dp_raw_losses_3)->primal_0 = raw_losses_7;
    (&dp_raw_losses_3)->differential_0 = _S3371;
    FixedArray<float, 6>  _S3372 = loss_weights_11;
    FixedArray<float, 6>  _S3373 = grad_out_11;
    s_bwd_compute_ppisp_no_crf_no_vig_regularization_loss_0(&dp_raw_losses_3, num_cameras_11, exposure_arithmetic_mean_23, &_S3372, &_S3373);
    *_S3370 = (&dp_raw_losses_3)->differential_0;
    return;
}

