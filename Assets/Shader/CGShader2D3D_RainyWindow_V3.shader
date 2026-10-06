Shader "CGShader2D3D/RainyWindow_V3"
{
    // Recovered shader; force Unity to refresh this asset.
    Properties
    {
        _Size ("Density", Float) = 1
        _T ("Time", Float) = 1
        _Distortion ("Distortion", Range(-5, 5)) = 1
        _DropSize ("Drop Size", Range(0, 2)) = 1
        _Blur ("Blur", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "QUEUE"="Transparent" "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            #pragma target 4.5
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[5];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[21];
            };
            SamplerState sampler_linear_clamp;
            Texture2D t0;
            struct program0Input
            {
                float2 texcoord0 : TEXCOORD0;
                float4 position0 : POSITION0;
            };
            struct program0Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };
            struct program1Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };
            struct program1Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program0Output vert(program0Input i)
            {
                program0Output o = (program0Output)0;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb0_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb0_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb0_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb0_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_4.yyyy * cb1_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb1_values[17].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb1_values[19].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_5 = mad(cb1_values[20].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb1_values[17], cb1_values[18], cb1_values[19], cb1_values[20]), worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float3 r1_xyz_4 = ((clipPos_xyzw_5.xwyx * float4(0.5, 0.5, -0.5, 0))).xyz;
                o.texcoord1.zw = (clipPos_xyzw_5.zzzw).zw;
                o.texcoord1.xy = ((r1_xyz_4.yyyy + r1_xyz_4.xzxx)).xy;
                return o;
            }
            #pragma fragment frag
            program1Output frag(program1Input i)
            {
                program1Output o = (program1Output)0;
                float r0_x_2 = ((cb0_values[3].y + cb1_values[0].y) * 0.00013888889);
                float r0_y_1 = (r0_x_2 >= -r0_x_2);
                float r0_x_3 = frac(abs(r0_x_2));
                float r0_x_4 = (r0_y_1 ? r0_x_3 : -r0_x_3);
                float4 r0_xyzw_2 = (i.texcoord0.xxyx * cb0_values[3].xxxx);
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_1 = r0_xyzw_2.z;
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_2, r0_x_4, r0_x_4) * float4(7200, 2, 0, 1800));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_w_1 = r0_xyzw_5.w;
                float r0_z_2 = mad(r0_z_1, 1, r0_w_1);
                float3 r1_xyz_2 = (((frac(float4(r0_y_3, r0_z_2, r0_z_2, r0_y_3))).xyzx + float4(-0.5, -0.5, -1, 0))).xyz;
                float4 r0_xyzw_4 = ((floor(float4(r0_y_3, r0_z_2, r0_y_3, r0_y_3))).xxyx * float4(0, 123.34, 345.45, 0));
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                float r0_y_5 = (frac(float4(r0_y_4, r0_y_4, r0_z_3, r0_y_4))).y;
                float r0_z_4 = (frac(float4(r0_y_4, r0_y_4, r0_z_3, r0_y_4))).z;
                float r1_w_1 = dot(float4(r0_y_5, r0_z_4, r0_y_5, r0_y_5), ((float4(r0_y_5, r0_z_4, r0_y_5, r0_y_5) + float4(34.345, 34.345, 0, 0))).xyxx);
                float4 r0_xyzw_6 = (float4(r0_y_5, r0_y_5, r0_z_4, r0_y_5) + r1_w_1.xxxx);
                float r0_y_6 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                float r0_y_7 = (r0_z_5 * r0_y_6);
                float r0_y_8 = frac(r0_y_7);
                float r0_z_6 = mad(r0_y_8, 6.2831, r0_x_5);
                float r0_y_9 = (r0_y_8 + -0.5);
                float r0_y_10 = (r0_y_9 * 0.8);
                float r1_w_2 = (-abs(r0_y_10) + 0.4);
                float2 r2_xy_4 = (sin(((i.texcoord0.yyyy * float4(10, 30, 0, 0))).yxyy)).xy;
                float r1_w_3 = (r1_w_2 * r2_xy_4.x);
                float r2_x_5 = (r2_xy_4.y * r2_xy_4.y);
                float r2_y_5 = (r2_x_5 * r2_x_5);
                float r1_w_4 = (r1_w_3 * (r2_y_5 * r2_x_5));
                float r2_x_7 = mad(r1_w_4, 0.45, r0_y_10);
                float r0_y_11 = sin(r0_z_6);
                float r0_y_12 = mad(r0_y_11, 0.5, r0_z_6);
                float r0_y_13 = sin(r0_y_12);
                float r0_y_14 = (r0_y_13 + r0_z_6);
                float r0_y_15 = sin(-r0_y_14);
                float r1_w_5 = (r1_xyz_2.x + -r2_x_7);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r2_y_6 = mad(r0_y_15, 0.45, -r1_w_6);
                float2 r3_xy_1 = ((r1_xyz_2.xyxx + -float4(r2_x_7, r2_y_6, r2_x_7, r2_x_7))).xy;
                float4 r3_xyzw_2 = (r3_xy_1.xxyx * float4(0.5, 0, 1, 0));
                float r3_x_2 = r3_xyzw_2.x;
                float r3_z_1 = r3_xyzw_2.z;
                float r0_y_16 = dot(float4(r3_x_2, r3_z_1, r3_x_2, r3_x_2), float4(r3_x_2, r3_z_1, r3_x_2, r3_x_2));
                float r0_y_17 = sqrt(r0_y_16);
                float r0_y_18 = (r0_y_17 + -0.05);
                float r0_y_19 = saturate((r0_y_18 * -49.999996));
                float r1_w_7 = mad(r0_y_19, -2, 3);
                float r0_y_20 = (r0_y_19 * r0_y_19);
                float r0_y_21 = (r0_y_20 * r1_w_7);
                float r0_y_22 = (r0_y_21 * cb0_values[3].w);
                float r2_z_1 = (r0_z_6 * 0.25);
                float2 r4_xy_1 = ((((r1_xyz_2.xyxx + -float4(r2_x_7, r2_z_1, r2_x_7, r2_x_7))).xyxx * float4(0.5, 8, 0, 0))).xy;
                float r0_z_7 = frac(r4_xy_1.y);
                float r0_z_8 = (r0_z_7 + -0.5);
                float r4_z_1 = (r0_z_8 * 0.125);
                float r0_z_9 = dot(float4(r4_xy_1.x, r4_z_1, r4_xy_1.x, r4_xy_1.x), float4(r4_xy_1.x, r4_z_1, r4_xy_1.x, r4_xy_1.x));
                float r0_z_10 = sqrt(r0_z_9);
                float r0_z_11 = (r0_z_10 + -0.03);
                float r0_z_12 = saturate((r0_z_11 * -50));
                float r0_z_13 = (r0_z_12 * r0_z_12);
                float r0_z_14 = (r0_z_13 * mad(r0_z_12, -2, 3));
                float r1_x_6 = saturate((mad(r3_xy_1.y, 1, 0.05) * 10));
                float r1_y_4 = mad(r1_x_6, -2, 3);
                float r1_y_5 = (r2_y_6 + -0.5);
                float r1_y_6 = ((float4(1, 1, 1, 1) / r1_y_5)).y;
                float r1_y_7 = (r1_y_6 * r1_xyz_2.z);
                float r1_y_8 = min(r1_y_7, 1);
                float r1_z_3 = mad(r1_y_8, -2, 3);
                float r1_y_9 = (r1_y_8 * r1_y_8);
                float r1_y_10 = (r1_y_9 * r1_z_3);
                float r1_x_9 = (r1_y_10 * ((r1_x_6 * r1_x_6) * r1_y_4));
                float r0_z_15 = (r0_z_14 * r1_x_9);
                float r1_y_11 = (abs(r3_x_2) + -0.05);
                float r1_y_12 = saturate((r1_y_11 * -99.999985));
                float r1_z_4 = mad(r1_y_12, -2, 3);
                float r1_y_13 = (r1_y_12 * r1_y_12);
                float r1_y_14 = (r1_y_13 * r1_z_4);
                float r1_z_5 = (r1_y_14 * r1_x_9);
                float4 r2_xyzw_8 = (float4(r4_xy_1.x, r4_z_1, r4_xy_1.x, r4_xy_1.x) * r0_z_15.xxxx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_7 = r2_xyzw_8.y;
                float4 r1_xyzw_10 = mad(r0_y_22.xxxx, float4(r3_x_2, r3_z_1, r3_x_2, r3_x_2), float4(r2_x_8, r2_y_7, r2_x_8, r2_x_8));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_15 = r1_xyzw_10.y;
                float4 r0_xyzw_23 = mad(i.texcoord0.xxyx, float4(0, 1.23, 1.23, 0), float4(0, 7.54, 7.54, 0));
                float r0_y_23 = r0_xyzw_23.y;
                float r0_z_16 = r0_xyzw_23.z;
                float4 r2_xyzw_9 = (float4(r0_y_23, r0_z_16, r0_y_23, r0_y_23) * cb0_values[3].xxxx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_8 = r2_xyzw_9.y;
                float r0_y_24 = (r2_x_9 + r2_x_9);
                float r1_w_8 = mad(r2_y_8, 1, r0_w_1);
                float r2_x_10 = frac(r0_y_24);
                float r2_y_9 = (frac(r1_w_8.xxxx)).y;
                float r2_z_2 = (frac(r1_w_8.xxxx)).z;
                float4 r2_xyzw_11 = (float4(r2_x_10, r2_y_9, r2_z_2, r2_x_10) + float4(-0.5, -0.5, -1, 0));
                float r2_x_11 = r2_xyzw_11.x;
                float r2_y_10 = r2_xyzw_11.y;
                float r2_z_3 = r2_xyzw_11.z;
                float r3_x_3 = floor(r0_y_24);
                float r3_y_2 = floor(r1_w_8);
                float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3) * float4(123.34, 345.45, 0, 0));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float4 r3_xyzw_5 = frac(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                float r3_x_5 = r3_xyzw_5.x;
                float r3_y_4 = r3_xyzw_5.y;
                float r3_z_2 = ((float4(r3_x_5, r3_x_5, r3_x_5, r3_y_4) + float4(0, 0, 34.345, 34.345))).z;
                float r3_w_1 = ((float4(r3_x_5, r3_x_5, r3_x_5, r3_y_4) + float4(0, 0, 34.345, 34.345))).w;
                float r0_y_25 = dot(float4(r3_x_5, r3_y_4, r3_x_5, r3_x_5), float4(r3_z_2, r3_w_1, r3_z_2, r3_z_2));
                float4 r3_xyzw_6 = (r0_y_25.xxxx + float4(r3_x_5, r3_y_4, r3_x_5, r3_x_5));
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_5 = r3_xyzw_6.y;
                float r0_y_26 = (r3_y_5 * r3_x_6);
                float r0_y_27 = frac(r0_y_26);
                float r1_w_9 = mad(r0_y_27, 6.2831, r0_x_5);
                float r0_y_28 = (r0_y_27 + -0.5);
                float r0_y_29 = (r0_y_28 * 0.8);
                float r2_w_1 = (-abs(r0_y_29) + 0.4);
                float4 r3_xyzw_7 = (r0_z_16.xxxx * float4(30, 10, 0, 0));
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_6 = r3_xyzw_7.y;
                float4 r3_xyzw_8 = sin(float4(r3_x_7, r3_y_6, r3_x_7, r3_x_7));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_7 = r3_xyzw_8.y;
                float r0_z_17 = (r2_w_1 * r3_x_8);
                float r2_w_2 = (r3_y_7 * r3_y_7);
                float r2_w_3 = (r2_w_2 * (r2_w_2 * r2_w_2));
                float r0_z_18 = (r0_z_17 * r2_w_3);
                float r3_x_10 = mad(r0_z_18, 0.45, r0_y_29);
                float r0_y_30 = sin(r1_w_9);
                float r0_y_31 = mad(r0_y_30, 0.5, r1_w_9);
                float r0_y_32 = sin(r0_y_31);
                float r0_y_33 = (r0_y_32 + r1_w_9);
                float r0_y_34 = sin(-r0_y_33);
                float r0_z_19 = (r2_x_11 + -r3_x_10);
                float r0_z_20 = (r0_z_19 * r0_z_19);
                float r3_y_8 = mad(r0_y_34, 0.45, -r0_z_20);
                float4 r0_xyzw_35 = (float4(r2_x_11, r2_x_11, r2_y_10, r2_x_11) + -float4(r3_x_10, r3_x_10, r3_y_8, r3_x_10));
                float r0_y_35 = r0_xyzw_35.y;
                float r0_z_21 = r0_xyzw_35.z;
                float2 r4_xy_2 = ((float4(r0_y_35, r0_z_21, r0_y_35, r0_y_35) * float4(0.5, 1, 0, 0))).xy;
                float r0_y_36 = dot(r4_xy_2.xyxx, r4_xy_2.xyxx);
                float r0_y_37 = sqrt(r0_y_36);
                float r0_y_38 = (r0_y_37 + -0.05);
                float r0_y_39 = saturate((r0_y_38 * -49.999996));
                float r2_w_4 = mad(r0_y_39, -2, 3);
                float r0_y_40 = (r0_y_39 * r0_y_39);
                float r0_y_41 = (r0_y_40 * r2_w_4);
                float r0_y_42 = (r0_y_41 * cb0_values[3].w);
                float r3_z_3 = (r1_w_9 * 0.25);
                float4 r2_xyzw_12 = (float4(r2_x_11, r2_y_10, r2_x_11, r2_x_11) + -float4(r3_x_10, r3_z_3, r3_x_10, r3_x_10));
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_11 = r2_xyzw_12.y;
                float2 r5_xy_1 = ((float4(r2_x_12, r2_y_11, r2_x_12, r2_x_12) * float4(0.5, 8, 0, 0))).xy;
                float r1_w_10 = frac(r5_xy_1.y);
                float r1_w_11 = (r1_w_10 + -0.5);
                float r5_z_1 = (r1_w_11 * 0.125);
                float r1_w_12 = dot(float4(r5_xy_1.x, r5_z_1, r5_xy_1.x, r5_xy_1.x), float4(r5_xy_1.x, r5_z_1, r5_xy_1.x, r5_xy_1.x));
                float r1_w_13 = sqrt(r1_w_12);
                float r1_w_14 = (r1_w_13 + -0.03);
                float r1_w_15 = saturate((r1_w_14 * -50));
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float r1_w_17 = (r1_w_16 * mad(r1_w_15, -2, 3));
                float r0_z_22 = mad(r0_z_21, 1, 0.05);
                float r0_z_23 = saturate((r0_z_22 * 10));
                float r0_z_24 = (r0_z_23 * r0_z_23);
                float r0_z_25 = (r0_z_24 * mad(r0_z_23, -2, 3));
                float r2_x_18 = (min(((float4(1, 1, 1, 1) / (r3_y_8 + -0.5)) * r2_z_3), 1)).x;
                float r2_y_12 = mad(r2_x_18, -2, 3);
                float r0_z_26 = (r0_z_25 * ((r2_x_18 * r2_x_18) * r2_y_12));
                float r1_w_18 = (r0_z_26 * r1_w_17);
                float r2_x_22 = saturate(((abs(r4_xy_2.x) + -0.05) * -99.999985));
                float r2_y_13 = mad(r2_x_22, -2, 3);
                float r2_z_4 = (r0_z_26 * ((r2_x_22 * r2_x_22) * r2_y_13));
                float4 r3_xyzw_11 = (float4(r5_xy_1.x, r5_z_1, r5_xy_1.x, r5_xy_1.x) * r1_w_18.xxxx);
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_9 = r3_xyzw_11.y;
                float4 r2_xyzw_25 = mad(r0_y_42.xxxx, r4_xy_2.xyxx, float4(r3_x_11, r3_y_9, r3_x_11, r3_x_11));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_14 = r2_xyzw_25.y;
                float4 r1_xyzw_11 = (float4(r1_x_10, r1_y_15, r1_z_5, r1_x_10) + float4(r2_x_25, r2_y_14, r2_z_4, r2_x_25));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_16 = r1_xyzw_11.y;
                float r1_z_6 = r1_xyzw_11.z;
                float4 r2_xyzw_26 = mad(i.texcoord0.xyxy, float4(1.35, 1.35, 1.57, 1.57), float4(1.54, 1.54, -7.54, -7.54));
                float4 r3_xyzw_12 = (r2_xyzw_26 * cb0_values[3].xxxx);
                float4 r0_xyzw_43 = (r3_xyzw_12.xxzx * float4(0, 2, 2, 0));
                float r0_y_43 = r0_xyzw_43.y;
                float r0_z_27 = r0_xyzw_43.z;
                float4 r2_xyzw_27 = mad(r3_xyzw_12.yywy, float4(1, 0, 1, 0), r0_w_1.xxxx);
                float r2_x_27 = r2_xyzw_27.x;
                float r2_z_6 = r2_xyzw_27.z;
                float r3_x_13 = frac(r0_y_43);
                float r3_y_11 = (frac(r2_x_27.xxxx)).y;
                float r3_z_5 = (frac(r2_x_27.xxxx)).z;
                float4 r3_xyzw_14 = (float4(r3_x_13, r3_y_11, r3_z_5, r3_x_13) + float4(-0.5, -0.5, -1, 0));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_12 = r3_xyzw_14.y;
                float r3_z_6 = r3_xyzw_14.z;
                float4 r4_xyzw_3 = floor(float4(r0_y_43, r0_y_43, r0_z_27, r0_y_43));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_z_2 = r4_xyzw_3.z;
                float r4_y_3 = (floor(float4(r2_x_27, r2_x_27, r2_x_27, r2_z_6))).y;
                float r4_w_1 = (floor(float4(r2_x_27, r2_x_27, r2_x_27, r2_z_6))).w;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_3, r4_z_2, r4_w_1) * float4(123.34, 345.45, 123.34, 345.45));
                float4 r4_xyzw_5 = frac(r4_xyzw_4);
                float4 r5_xyzw_2 = (r4_xyzw_5 + float4(34.345, 34.345, 34.345, 34.345));
                float r0_y_44 = dot(r4_xyzw_5.xyxx, r5_xyzw_2.xyxx);
                float4 r0_xyzw_45 = (r0_y_44.xxxx + r4_xyzw_5.xxxy);
                float r0_y_45 = r0_xyzw_45.y;
                float r0_w_2 = r0_xyzw_45.w;
                float r0_y_46 = (r0_w_2 * r0_y_45);
                float r0_y_47 = frac(r0_y_46);
                float r0_w_3 = mad(r0_y_47, 6.2831, r0_x_5);
                float r0_y_48 = (r0_y_47 + -0.5);
                float r0_y_49 = (r0_y_48 * 0.8);
                float r1_w_19 = (-abs(r0_y_49) + 0.4);
                float4 r6_xyzw_2 = sin((r2_xyzw_26.yyww * float4(30, 10, 30, 10)));
                float r1_w_20 = (r1_w_19 * r6_xyzw_2.x);
                float4 r2_xyzw_28 = (r6_xyzw_2.ywyy * r6_xyzw_2.ywyy);
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_16 = r2_xyzw_28.y;
                float4 r2_xyzw_29 = (float4(r2_x_28, r2_y_16, r2_x_28, r2_x_28) * ((float4(r2_x_28, r2_y_16, r2_x_28, r2_x_28) * float4(r2_x_28, r2_y_16, r2_x_28, r2_x_28))).xyxx);
                float r2_x_29 = r2_xyzw_29.x;
                float r2_y_17 = r2_xyzw_29.y;
                float r1_w_21 = (r1_w_20 * r2_x_29);
                float r7_x_1 = mad(r1_w_21, 0.45, r0_y_49);
                float r0_y_50 = sin(r0_w_3);
                float r0_y_51 = mad(r0_y_50, 0.5, r0_w_3);
                float r0_y_52 = sin(r0_y_51);
                float r0_y_53 = (r0_y_52 + r0_w_3);
                float r0_y_54 = sin(-r0_y_53);
                float r1_w_22 = (r3_x_14 + -r7_x_1);
                float r1_w_23 = (r1_w_22 * r1_w_22);
                float r7_y_1 = mad(r0_y_54, 0.45, -r1_w_23);
                float4 r2_xyzw_30 = (float4(r3_x_14, r3_x_14, r3_x_14, r3_y_12) + -float4(r7_x_1, r7_x_1, r7_x_1, r7_y_1));
                float r2_x_30 = r2_xyzw_30.x;
                float r2_w_6 = r2_xyzw_30.w;
                float2 r4_xy_7 = ((float4(r2_x_30, r2_w_6, r2_x_30, r2_x_30) * float4(0.5, 1, 0, 0))).xy;
                float r0_y_55 = dot(r4_xy_7.xyxx, r4_xy_7.xyxx);
                float r0_y_56 = sqrt(r0_y_55);
                float r0_y_57 = (r0_y_56 + -0.05);
                float r0_y_58 = saturate((r0_y_57 * -49.999996));
                float r1_w_24 = mad(r0_y_58, -2, 3);
                float r0_y_59 = (r0_y_58 * r0_y_58);
                float r0_y_60 = (r0_y_59 * r1_w_24);
                float r0_y_61 = (r0_y_60 * cb0_values[3].w);
                float r7_z_1 = (r0_w_3 * 0.25);
                float4 r3_xyzw_15 = (float4(r3_x_14, r3_y_12, r3_x_14, r3_x_14) + -float4(r7_x_1, r7_z_1, r7_x_1, r7_x_1));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_13 = r3_xyzw_15.y;
                float2 r8_xy_1 = ((float4(r3_x_15, r3_y_13, r3_x_15, r3_x_15) * float4(0.5, 8, 0, 0))).xy;
                float r0_w_4 = frac(r8_xy_1.y);
                float r0_w_5 = (r0_w_4 + -0.5);
                float r8_z_1 = (r0_w_5 * 0.125);
                float r0_w_6 = dot(float4(r8_xy_1.x, r8_z_1, r8_xy_1.x, r8_xy_1.x), float4(r8_xy_1.x, r8_z_1, r8_xy_1.x, r8_xy_1.x));
                float r0_w_7 = sqrt(r0_w_6);
                float r0_w_8 = (r0_w_7 + -0.03);
                float r0_w_9 = saturate((r0_w_8 * -50));
                float r1_w_25 = mad(r0_w_9, -2, 3);
                float r0_w_10 = (r0_w_9 * r0_w_9);
                float r0_w_11 = (r0_w_10 * r1_w_25);
                float r1_w_26 = mad(r2_w_6, 1, 0.05);
                float r1_w_27 = saturate((r1_w_26 * 10));
                float r1_w_28 = (r1_w_27 * r1_w_27);
                float r1_w_29 = (r1_w_28 * mad(r1_w_27, -2, 3));
                float r2_x_35 = (min(((float4(1, 1, 1, 1) / (r7_y_1 + -0.5)) * r3_z_6), 1)).x;
                float r2_w_7 = mad(r2_x_35, -2, 3);
                float r1_w_30 = (r1_w_29 * ((r2_x_35 * r2_x_35) * r2_w_7));
                float r0_w_12 = (r0_w_11 * r1_w_30);
                float r2_x_39 = saturate(((abs(r4_xy_7.x) + -0.05) * -99.999985));
                float r2_w_8 = mad(r2_x_39, -2, 3);
                float r3_z_7 = (r1_w_30 * ((r2_x_39 * r2_x_39) * r2_w_8));
                float4 r2_xyzw_42 = (float4(r8_xy_1.x, r8_xy_1.x, r8_xy_1.x, r8_z_1) * r0_w_12.xxxx);
                float r2_x_42 = r2_xyzw_42.x;
                float r2_w_9 = r2_xyzw_42.w;
                float4 r3_xyzw_16 = mad(r0_y_61.xxxx, r4_xy_7.xyxx, float4(r2_x_42, r2_w_9, r2_x_42, r2_x_42));
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_14 = r3_xyzw_16.y;
                float4 r1_xyzw_12 = (float4(r1_x_11, r1_y_16, r1_z_6, r1_x_11) + float4(r3_x_16, r3_y_14, r3_z_7, r3_x_16));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_17 = r1_xyzw_12.y;
                float r1_z_7 = r1_xyzw_12.z;
                float r3_x_17 = frac(r0_z_27);
                float r3_y_15 = (frac(r2_z_6.xxxx)).y;
                float r3_z_8 = (frac(r2_z_6.xxxx)).z;
                float4 r0_xyzw_62 = (float4(r3_x_17, r3_x_17, r3_y_15, r3_z_8) + float4(0, -0.5, -0.5, -1));
                float r0_y_62 = r0_xyzw_62.y;
                float r0_z_28 = r0_xyzw_62.z;
                float r0_w_13 = r0_xyzw_62.w;
                float r1_w_31 = dot(r4_xyzw_5.zwzz, r5_xyzw_2.zwzz);
                float4 r2_xyzw_43 = (r1_w_31.xxxx + r4_xyzw_5.zzwz);
                float r2_x_43 = r2_xyzw_43.x;
                float r2_z_7 = r2_xyzw_43.z;
                float r1_w_32 = (r2_z_7 * r2_x_43);
                float r1_w_33 = frac(r1_w_32);
                float r0_x_6 = mad(r1_w_33, 6.2831, r0_x_5);
                float r1_w_34 = (r1_w_33 + -0.5);
                float r1_w_35 = (r1_w_34 * 0.8);
                float r2_x_47 = mad((r2_y_17 * (r6_xyzw_2.z * (-abs(r1_w_35) + 0.4))), 0.45, r1_w_35);
                float r1_w_36 = sin(r0_x_6);
                float r1_w_37 = mad(r1_w_36, 0.5, r0_x_6);
                float r1_w_38 = sin(r1_w_37);
                float r1_w_39 = (r0_x_6 + r1_w_38);
                float r1_w_40 = sin(-r1_w_39);
                float r2_w_10 = (r0_y_62 + -r2_x_47);
                float r2_w_11 = (r2_w_10 * r2_w_10);
                float r2_y_18 = mad(r1_w_40, 0.45, -r2_w_11);
                float4 r3_xyzw_18 = (float4(r0_y_62, r0_z_28, r0_y_62, r0_y_62) + -float4(r2_x_47, r2_y_18, r2_x_47, r2_x_47));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_16 = r3_xyzw_18.y;
                float4 r3_xyzw_19 = (float4(r3_x_18, r3_x_18, r3_y_16, r3_x_18) * float4(0.5, 0, 1, 0));
                float r3_x_19 = r3_xyzw_19.x;
                float r3_z_9 = r3_xyzw_19.z;
                float r1_w_41 = dot(float4(r3_x_19, r3_z_9, r3_x_19, r3_x_19), float4(r3_x_19, r3_z_9, r3_x_19, r3_x_19));
                float r1_w_42 = sqrt(r1_w_41);
                float r1_w_43 = (r1_w_42 + -0.05);
                float r1_w_44 = saturate((r1_w_43 * -49.999996));
                float r2_w_12 = mad(r1_w_44, -2, 3);
                float r1_w_45 = (r1_w_44 * r1_w_44);
                float r1_w_46 = (r1_w_45 * r2_w_12);
                float r1_w_47 = (r1_w_46 * cb0_values[3].w);
                float r2_z_8 = (r0_x_6 * 0.25);
                float4 r0_xyzw_7 = (float4(r0_y_62, r0_z_28, r0_y_62, r0_y_62) + -float4(r2_x_47, r2_z_8, r2_x_47, r2_x_47));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_63 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_63, r0_x_7, r0_x_7) * float4(0.5, 8, 0, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_64 = r0_xyzw_8.y;
                float r0_y_65 = frac(r0_y_64);
                float r0_y_66 = (r0_y_65 + -0.5);
                float r0_z_29 = (r0_y_66 * 0.125);
                float r0_y_67 = dot(float4(r0_x_8, r0_z_29, r0_x_8, r0_x_8), float4(r0_x_8, r0_z_29, r0_x_8, r0_x_8));
                float r0_y_68 = sqrt(r0_y_67);
                float r0_y_69 = (r0_y_68 + -0.03);
                float r0_y_70 = saturate((r0_y_69 * -50));
                float r0_y_71 = (r0_y_70 * r0_y_70);
                float r0_y_72 = (r0_y_71 * mad(r0_y_70, -2, 3));
                float r2_x_50 = saturate((mad(r3_y_16, 1, 0.05) * 10));
                float r2_z_9 = mad(r2_x_50, -2, 3);
                float r2_y_19 = (r2_y_18 + -0.5);
                float r2_y_20 = ((float4(1, 1, 1, 1) / r2_y_19)).y;
                float r0_w_14 = (r0_w_13 * r2_y_20);
                float r0_w_15 = min(r0_w_14, 1);
                float r2_y_21 = mad(r0_w_15, -2, 3);
                float r0_w_16 = (r0_w_15 * r0_w_15);
                float r0_w_17 = (r0_w_16 * r2_y_21);
                float r0_w_18 = (r0_w_17 * ((r2_x_50 * r2_x_50) * r2_z_9));
                float r0_y_73 = (r0_w_18 * r0_y_72);
                float r2_x_54 = saturate(((abs(r3_x_19) + -0.05) * -99.999985));
                float r2_y_22 = mad(r2_x_54, -2, 3);
                float r2_z_10 = (r0_w_18 * ((r2_x_54 * r2_x_54) * r2_y_22));
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_z_29, r0_x_8, r0_x_8) * r0_y_73.xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_74 = r0_xyzw_9.y;
                float4 r2_xyzw_57 = mad(r1_w_47.xxxx, float4(r3_x_19, r3_z_9, r3_x_19, r3_x_19), float4(r0_x_9, r0_y_74, r0_x_9, r0_x_9));
                float r2_x_57 = r2_xyzw_57.x;
                float r2_y_23 = r2_xyzw_57.y;
                float4 r0_xyzw_10 = (float4(r1_x_12, r1_y_17, r1_z_7, r1_x_12) + float4(r2_x_57, r2_y_23, r2_z_10, r2_x_57));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_75 = r0_xyzw_10.y;
                float r0_z_30 = r0_xyzw_10.z;
                float r0_w_19 = ddx(i.texcoord0.x);
                float r0_w_20 = (abs(r0_w_19) + ddy(i.texcoord0.x));
                float r0_w_21 = (r0_w_20 * 60);
                float r0_w_22 = min(r0_w_21, 1);
                float r0_w_23 = (-r0_w_22 + 1);
                float r0_z_31 = mad(-r0_z_30, r0_w_23, 1);
                float r0_z_32 = (r0_z_31 * (cb0_values[4].x * 7));
                float4 r1_xyzw_15 = (i.texcoord1.xyxx / i.texcoord1.wwww);
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_18 = r1_xyzw_15.y;
                float4 r0_xyzw_11 = (float4(r0_x_10, r0_y_75, r0_x_10, r0_x_10) * cb0_values[3].zzzz);
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_76 = r0_xyzw_11.y;
                float4 r0_xyzw_12 = mad(float4(r0_x_11, r0_y_76, r0_x_11, r0_x_11), r0_w_23.xxxx, float4(r1_x_15, r1_y_18, r1_x_15, r1_x_15));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_77 = r0_xyzw_12.y;
                float4 r1_xyzw_16 = (i.texcoord0.xyxx * float4(123.34, 345.45, 0, 0));
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_19 = r1_xyzw_16.y;
                float4 r1_xyzw_17 = frac(float4(r1_x_16, r1_y_19, r1_x_16, r1_x_16));
                float r1_x_17 = r1_xyzw_17.x;
                float r1_y_20 = r1_xyzw_17.y;
                float4 r1_xyzw_8 = (float4(r1_x_17, r1_x_17, r1_x_17, r1_y_20) + float4(0, 0, 34.345, 34.345));
                float r1_z_8 = r1_xyzw_8.z;
                float r1_w_48 = r1_xyzw_8.w;
                float r0_w_24 = dot(float4(r1_x_17, r1_y_20, r1_x_17, r1_x_17), float4(r1_z_8, r1_w_48, r1_z_8, r1_z_8));
                float4 r1_xyzw_18 = (r0_w_24.xxxx + float4(r1_x_17, r1_y_20, r1_x_17, r1_x_17));
                float r1_x_18 = r1_xyzw_18.x;
                float r1_y_21 = r1_xyzw_18.y;
                float r0_w_25 = (r1_y_21 * r1_x_18);
                float r0_w_26 = frac(r0_w_25);
                float4 r0_xyzw_33 = (float4(r0_z_32, r0_z_32, r0_z_32, r0_w_26) * float4(0, 0, 0.01, 6.2831));
                float r0_z_33 = r0_xyzw_33.z;
                float r0_w_27 = r0_xyzw_33.w;
                float4 r1_xyzw_19 = float4(0, 0, 0, 0);
                float r2_x_58 = r0_w_27;
                float r2_y_24 = 0;
                float r1_w_50 = r1_xyzw_19.w;
                float r2_x_59 = r2_x_58;
                float r2_y_25 = r2_y_24;
                float r1_x_20 = r1_xyzw_19.x;
                float r1_y_23 = r1_xyzw_19.y;
                float r1_z_10 = r1_xyzw_19.z;
                float r2_z_12;
                float r3_x_21;
                float r3_y_18;
                float r2_z_13;
                float r2_w_14;
                float r2_x_60;
                float r2_y_26;
                float r2_z_14;
                float r2_w_15;
                float r3_x_27;
                float r3_y_19;
                float r3_z_11;
                float r3_w_4;
                float r1_x_21;
                float r1_y_24;
                float r1_z_11;
                float r1_w_51;
                [loop]
                while (true)
                {
                    r2_z_12 = (r2_y_25 >= 32);
                    if (r2_z_12) break;
                    r3_x_21 = sin(r2_x_59);
                    r3_y_18 = cos(r2_x_59);
                    float4 r2_xyzw_13 = (r0_z_33.xxxx * float4(r3_x_21, r3_x_21, r3_x_21, r3_y_18));
                    r2_z_13 = r2_xyzw_13.z;
                    r2_w_14 = r2_xyzw_13.w;
                    float4 r2_xyzw_60 = (float4(r2_x_59, r2_y_25, r2_x_59, r2_x_59) + float4(1, 1, 0, 0));
                    r2_x_60 = r2_xyzw_60.x;
                    r2_y_26 = r2_xyzw_60.y;
                    float4 r2_xyzw_14 = mad(float4(r2_z_13, r2_z_13, r2_z_13, r2_w_14), (sqrt(frac((sin((r2_y_26 * 546)) * 5424)))).xxxx, float4(r0_x_12, r0_x_12, r0_x_12, r0_y_77));
                    r2_z_14 = r2_xyzw_14.z;
                    r2_w_15 = r2_xyzw_14.w;
                    float4 r3_xyzw_27 = t0.Sample(sampler_linear_clamp, (float4(r2_z_14, r2_w_15, r2_z_14, r2_z_14)).xy);
                    r3_x_27 = r3_xyzw_27.x;
                    r3_y_19 = r3_xyzw_27.y;
                    r3_z_11 = r3_xyzw_27.z;
                    r3_w_4 = r3_xyzw_27.w;
                    float4 r1_xyzw_21 = (float4(r1_x_20, r1_y_23, r1_z_10, r1_w_50) + float4(r3_x_27, r3_y_19, r3_z_11, r3_w_4));
                    r1_x_21 = r1_xyzw_21.x;
                    r1_y_24 = r1_xyzw_21.y;
                    r1_z_11 = r1_xyzw_21.z;
                    r1_w_51 = r1_xyzw_21.w;
                    r1_w_50 = r1_w_51;
                    r2_x_59 = r2_x_60;
                    r2_y_25 = r2_y_26;
                    r1_x_20 = r1_x_21;
                    r1_y_23 = r1_y_24;
                    r1_z_10 = r1_z_11;
                }
                o.sv_Target0.xyzw = (float4(r1_x_20, r1_y_23, r1_z_10, r1_w_50) * float4(0.030625, 0.030625, 0.030625, 0.030625));
                return o;
            }
            ENDHLSL
        }
    }
}
