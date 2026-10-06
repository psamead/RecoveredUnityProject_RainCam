Shader "CGShader2D3D/RainyWindow_V3-8_Cam_Mouse"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "" {}
        _Size ("Density", Float) = 1
        _T ("Time", Float) = 1
        _Distortion ("Distortion", Range(-5, 5)) = 1
        _DropSize ("Drop Size", Range(0, 2)) = 1
        _Blur ("Blur", Range(0, 1)) = 1
        _Ratio ("Ratio", Float) = 1
        _Radius ("Radius", Range(0, 0.5)) = 0.2
        _EdgeSoftness ("Edge Softness", Range(0, 0.3)) = 0.1
        _SplatTex ("Splat Texture", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            Tags { "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            #pragma target 4.5
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[7];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[4];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_SplatTex;
            Texture2D _MainTex;
            Texture2D _SplatTex;
            struct program0Input
            {
                float2 texcoord0 : TEXCOORD0;
                float4 position0 : POSITION0;
            };
            struct program0Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program0Output vert(program0Input i)
            {
                program0Output o = (program0Output)0;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb1_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_4);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[2].xyxx, cb0_values[2].zwzz)).xy;
                return o;
            }
            #pragma fragment frag
            program1Output frag(program1Input i)
            {
                program1Output o = (program1Output)0;
                float2 r0_xy_1 = (mad(i.texcoord0.xyxx, float4(-1, 1, 0, 0), float4(1, 0, 0, 0))).xy;
                float r0_x_2 = (r0_xy_1.x / cb0_values[6].z);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (float4(r0_x_2, r0_xy_1.y, r0_x_2, r0_x_2)).xy);
                float4 r2_xyzw_1 = _SplatTex.Sample(sampler_SplatTex, (float4(r0_x_2, r0_xy_1.y, r0_x_2, r0_x_2)).xy);
                float r0_z_1 = (cb0_values[3].y + cb1_values[0].y);
                float r0_z_2 = (r0_z_1 * 0.00013888889);
                float r0_w_1 = (r0_z_2 >= -r0_z_2);
                float r0_z_3 = frac(abs(r0_z_2));
                float r0_z_4 = (r0_w_1 ? r0_z_3 : -r0_z_3);
                float2 r2_yz_2 = ((float4(r0_x_2, r0_x_2, r0_xy_1.y, r0_x_2) * cb0_values[3].xxxx)).yz;
                float r0_w_2 = (r2_yz_2.x + r2_yz_2.x);
                float4 r2_xyzw_3 = (r0_z_4.xxxx * float4(0, 7200, 0, 1800));
                float r2_y_3 = r2_xyzw_3.y;
                float r2_w_2 = r2_xyzw_3.w;
                float r0_z_5 = mad(r2_yz_2.y, 1, r2_w_2);
                float3 r3_xyz_2 = (((frac(float4(r0_w_2, r0_z_5, r0_z_5, r0_w_2))).xyzx + float4(-0.5, -0.5, -1, 0))).xyz;
                float4 r0_xyzw_6 = ((floor(float4(r0_w_2, r0_z_5, r0_w_2, r0_w_2))).xxxy * float4(0, 0, 123.34, 345.45));
                float r0_z_6 = r0_xyzw_6.z;
                float r0_w_3 = r0_xyzw_6.w;
                float4 r0_xyzw_7 = frac(float4(r0_z_6, r0_z_6, r0_z_6, r0_w_3));
                float r0_z_7 = r0_xyzw_7.z;
                float r0_w_4 = r0_xyzw_7.w;
                float r2_z_3 = dot(float4(r0_z_7, r0_w_4, r0_z_7, r0_z_7), ((float4(r0_z_7, r0_w_4, r0_z_7, r0_z_7) + float4(34.345, 34.345, 0, 0))).xyxx);
                float4 r0_xyzw_8 = (float4(r0_z_7, r0_z_7, r0_z_7, r0_w_4) + r2_z_3.xxxx);
                float r0_z_8 = r0_xyzw_8.z;
                float r0_w_5 = r0_xyzw_8.w;
                float r0_z_9 = (r0_w_5 * r0_z_8);
                float r0_z_10 = frac(r0_z_9);
                float r0_w_6 = mad(r0_z_10, 6.2831, r2_y_3);
                float r0_z_11 = (r0_z_10 + -0.5);
                float r0_z_12 = (r0_z_11 * 0.8);
                float r2_z_4 = (-abs(r0_z_12) + 0.4);
                float4 r4_xyzw_3 = (float4(r0_xy_1.y, r0_xy_1.y, r0_w_6, r0_xy_1.y) * float4(10, 30, 0.25, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_3 = r4_xyzw_3.y;
                float r4_z_1 = r4_xyzw_3.z;
                float2 r4_xy_4 = (sin(float4(r4_y_3, r4_x_3, r4_y_3, r4_y_3))).xy;
                float r2_z_5 = (r2_z_4 * r4_xy_4.x);
                float r3_w_1 = (r4_xy_4.y * r4_xy_4.y);
                float r3_w_2 = (r3_w_1 * (r3_w_1 * r3_w_1));
                float r2_z_6 = (r2_z_5 * r3_w_2);
                float r4_x_6 = mad(r2_z_6, 0.45, r0_z_12);
                float r0_z_13 = sin(r0_w_6);
                float r0_z_14 = mad(r0_z_13, 0.5, r0_w_6);
                float r0_z_15 = sin(r0_z_14);
                float r0_z_16 = (r0_z_15 + r0_w_6);
                float r0_z_17 = sin(-r0_z_16);
                float r2_z_7 = (r3_xyz_2.x + -r4_x_6);
                float r2_z_8 = (r2_z_7 * r2_z_7);
                float r4_y_5 = mad(r0_z_17, 0.45, -r2_z_8);
                float2 r5_xy_1 = ((r3_xyz_2.xyxx + -float4(r4_x_6, r4_y_5, r4_x_6, r4_x_6))).xy;
                float4 r5_xyzw_2 = (r5_xy_1.xxyx * float4(0.5, 0, 1, 0));
                float r5_x_2 = r5_xyzw_2.x;
                float r5_z_1 = r5_xyzw_2.z;
                float r0_z_18 = dot(float4(r5_x_2, r5_z_1, r5_x_2, r5_x_2), float4(r5_x_2, r5_z_1, r5_x_2, r5_x_2));
                float r0_z_19 = sqrt(r0_z_18);
                float r0_z_20 = (r0_z_19 + -0.05);
                float r0_z_21 = saturate((r0_z_20 * -49.999996));
                float r2_z_9 = mad(r0_z_21, -2, 3);
                float r0_z_22 = (r0_z_21 * r0_z_21);
                float r0_z_23 = (r0_z_22 * r2_z_9);
                float r0_z_24 = (r0_z_23 * cb0_values[3].w);
                float2 r6_xy_1 = ((((r3_xyz_2.xyxx + -float4(r4_x_6, r4_z_1, r4_x_6, r4_x_6))).xyxx * float4(0.5, 8, 0, 0))).xy;
                float r0_w_7 = frac(r6_xy_1.y);
                float r0_w_8 = (r0_w_7 + -0.5);
                float r6_z_1 = (r0_w_8 * 0.125);
                float r0_w_9 = dot(float4(r6_xy_1.x, r6_z_1, r6_xy_1.x, r6_xy_1.x), float4(r6_xy_1.x, r6_z_1, r6_xy_1.x, r6_xy_1.x));
                float r0_w_10 = sqrt(r0_w_9);
                float r0_w_11 = (r0_w_10 + -0.03);
                float r0_w_12 = saturate((r0_w_11 * -50));
                float r2_z_10 = mad(r0_w_12, -2, 3);
                float r0_w_13 = (r0_w_12 * r0_w_12);
                float r0_w_14 = (r0_w_13 * r2_z_10);
                float r2_z_11 = mad(r5_xy_1.y, 1, 0.05);
                float r2_z_12 = saturate((r2_z_11 * 10));
                float r2_z_13 = (r2_z_12 * r2_z_12);
                float r2_z_14 = (r2_z_13 * mad(r2_z_12, -2, 3));
                float r3_x_8 = (min(((float4(1, 1, 1, 1) / (r4_y_5 + -0.5)) * r3_xyz_2.z), 1)).x;
                float r3_y_4 = mad(r3_x_8, -2, 3);
                float r2_z_15 = (r2_z_14 * ((r3_x_8 * r3_x_8) * r3_y_4));
                float r0_w_15 = (r0_w_14 * r2_z_15);
                float r3_x_12 = saturate(((abs(r5_x_2) + -0.05) * -99.999985));
                float r3_y_5 = mad(r3_x_12, -2, 3);
                float r3_z_3 = (r2_z_15 * ((r3_x_12 * r3_x_12) * r3_y_5));
                float4 r4_xyzw_7 = (float4(r6_xy_1.x, r6_z_1, r6_xy_1.x, r6_xy_1.x) * r0_w_15.xxxx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float4 r3_xyzw_15 = mad(r0_z_24.xxxx, float4(r5_x_2, r5_z_1, r5_x_2, r5_x_2), float4(r4_x_7, r4_y_6, r4_x_7, r4_x_7));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_6 = r3_xyzw_15.y;
                float4 r0_xyzw_25 = mad(float4(r0_x_2, r0_x_2, r0_x_2, r0_xy_1.y), float4(0, 0, 1.23, 1.23), float4(0, 0, 7.54, 7.54));
                float r0_z_25 = r0_xyzw_25.z;
                float r0_w_16 = r0_xyzw_25.w;
                float4 r4_xyzw_8 = (float4(r0_z_25, r0_w_16, r0_z_25, r0_z_25) * cb0_values[3].xxxx);
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_7 = r4_xyzw_8.y;
                float r0_z_26 = (r4_x_8 + r4_x_8);
                float r2_z_16 = mad(r4_y_7, 1, r2_w_2);
                float r4_x_9 = frac(r0_z_26);
                float r4_y_8 = (frac(r2_z_16.xxxx)).y;
                float r4_z_2 = (frac(r2_z_16.xxxx)).z;
                float4 r4_xyzw_10 = (float4(r4_x_9, r4_y_8, r4_z_2, r4_x_9) + float4(-0.5, -0.5, -1, 0));
                float r4_x_10 = r4_xyzw_10.x;
                float r4_y_9 = r4_xyzw_10.y;
                float r4_z_3 = r4_xyzw_10.z;
                float r5_x_3 = floor(r0_z_26);
                float r5_y_2 = floor(r2_z_16);
                float4 r5_xyzw_4 = (float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3) * float4(123.34, 345.45, 0, 0));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float4 r5_xyzw_5 = frac(float4(r5_x_4, r5_y_3, r5_x_4, r5_x_4));
                float r5_x_5 = r5_xyzw_5.x;
                float r5_y_4 = r5_xyzw_5.y;
                float r5_z_2 = ((float4(r5_x_5, r5_x_5, r5_x_5, r5_y_4) + float4(0, 0, 34.345, 34.345))).z;
                float r5_w_1 = ((float4(r5_x_5, r5_x_5, r5_x_5, r5_y_4) + float4(0, 0, 34.345, 34.345))).w;
                float r0_z_27 = dot(float4(r5_x_5, r5_y_4, r5_x_5, r5_x_5), float4(r5_z_2, r5_w_1, r5_z_2, r5_z_2));
                float4 r5_xyzw_6 = (r0_z_27.xxxx + float4(r5_x_5, r5_y_4, r5_x_5, r5_x_5));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_5 = r5_xyzw_6.y;
                float r0_z_28 = (r5_y_5 * r5_x_6);
                float r0_z_29 = frac(r0_z_28);
                float r2_z_17 = mad(r0_z_29, 6.2831, r2_y_3);
                float r0_z_30 = (r0_z_29 + -0.5);
                float r0_z_31 = (r0_z_30 * 0.8);
                float r3_w_3 = (-abs(r0_z_31) + 0.4);
                float4 r5_xyzw_7 = (r0_w_16.xxxx * float4(30, 10, 0, 0));
                float r5_x_7 = r5_xyzw_7.x;
                float r5_y_6 = r5_xyzw_7.y;
                float4 r5_xyzw_8 = sin(float4(r5_x_7, r5_y_6, r5_x_7, r5_x_7));
                float r5_x_8 = r5_xyzw_8.x;
                float r5_y_7 = r5_xyzw_8.y;
                float r0_w_17 = (r3_w_3 * r5_x_8);
                float r3_w_4 = (r5_y_7 * r5_y_7);
                float r4_w_1 = (r3_w_4 * r3_w_4);
                float r3_w_5 = (r3_w_4 * r4_w_1);
                float r0_w_18 = (r0_w_17 * r3_w_5);
                float r5_x_9 = mad(r0_w_18, 0.45, r0_z_31);
                float r0_z_32 = sin(r2_z_17);
                float r0_z_33 = mad(r0_z_32, 0.5, r2_z_17);
                float r0_z_34 = sin(r0_z_33);
                float r0_z_35 = (r0_z_34 + r2_z_17);
                float r0_z_36 = sin(-r0_z_35);
                float r0_w_19 = (r4_x_10 + -r5_x_9);
                float r0_w_20 = (r0_w_19 * r0_w_19);
                float r5_y_8 = mad(r0_z_36, 0.45, -r0_w_20);
                float4 r0_xyzw_37 = (float4(r4_x_10, r4_x_10, r4_x_10, r4_y_9) + -float4(r5_x_9, r5_x_9, r5_x_9, r5_y_8));
                float r0_z_37 = r0_xyzw_37.z;
                float r0_w_21 = r0_xyzw_37.w;
                float2 r6_xy_2 = ((float4(r0_z_37, r0_w_21, r0_z_37, r0_z_37) * float4(0.5, 1, 0, 0))).xy;
                float r0_z_38 = dot(r6_xy_2.xyxx, r6_xy_2.xyxx);
                float r0_z_39 = sqrt(r0_z_38);
                float r0_z_40 = (r0_z_39 + -0.05);
                float r0_z_41 = saturate((r0_z_40 * -49.999996));
                float r3_w_6 = mad(r0_z_41, -2, 3);
                float r0_z_42 = (r0_z_41 * r0_z_41);
                float r0_z_43 = (r0_z_42 * r3_w_6);
                float r0_z_44 = (r0_z_43 * cb0_values[3].w);
                float r5_z_3 = (r2_z_17 * 0.25);
                float4 r4_xyzw_11 = (float4(r4_x_10, r4_y_9, r4_x_10, r4_x_10) + -float4(r5_x_9, r5_z_3, r5_x_9, r5_x_9));
                float r4_x_11 = r4_xyzw_11.x;
                float r4_y_10 = r4_xyzw_11.y;
                float2 r7_xy_1 = ((float4(r4_x_11, r4_y_10, r4_x_11, r4_x_11) * float4(0.5, 8, 0, 0))).xy;
                float r2_z_18 = frac(r7_xy_1.y);
                float r2_z_19 = (r2_z_18 + -0.5);
                float r7_z_1 = (r2_z_19 * 0.125);
                float r2_z_20 = dot(float4(r7_xy_1.x, r7_z_1, r7_xy_1.x, r7_xy_1.x), float4(r7_xy_1.x, r7_z_1, r7_xy_1.x, r7_xy_1.x));
                float r2_z_21 = sqrt(r2_z_20);
                float r2_z_22 = (r2_z_21 + -0.03);
                float r2_z_23 = saturate((r2_z_22 * -50));
                float r3_w_7 = mad(r2_z_23, -2, 3);
                float r2_z_24 = (r2_z_23 * r2_z_23);
                float r2_z_25 = (r2_z_24 * r3_w_7);
                float r0_w_22 = mad(r0_w_21, 1, 0.05);
                float r0_w_23 = saturate((r0_w_22 * 10));
                float r3_w_8 = mad(r0_w_23, -2, 3);
                float r0_w_24 = (r0_w_23 * r0_w_23);
                float r0_w_25 = (r0_w_24 * r3_w_8);
                float r3_w_9 = (r5_y_8 + -0.5);
                float r3_w_10 = ((float4(1, 1, 1, 1) / r3_w_9)).w;
                float r3_w_11 = (r3_w_10 * r4_z_3);
                float r3_w_12 = min(r3_w_11, 1);
                float r3_w_13 = (r3_w_12 * r3_w_12);
                float r3_w_14 = (r3_w_13 * mad(r3_w_12, -2, 3));
                float r0_w_26 = (r0_w_25 * r3_w_14);
                float r2_z_26 = (r0_w_26 * r2_z_25);
                float r3_w_15 = (abs(r6_xy_2.x) + -0.05);
                float r3_w_16 = saturate((r3_w_15 * -99.999985));
                float r3_w_17 = (r3_w_16 * r3_w_16);
                float r3_w_18 = (r3_w_17 * mad(r3_w_16, -2, 3));
                float r4_z_4 = (r0_w_26 * r3_w_18);
                float4 r5_xyzw_10 = (float4(r7_xy_1.x, r7_z_1, r7_xy_1.x, r7_xy_1.x) * r2_z_26.xxxx);
                float r5_x_10 = r5_xyzw_10.x;
                float r5_y_9 = r5_xyzw_10.y;
                float4 r4_xyzw_14 = mad(r0_z_44.xxxx, r6_xy_2.xyxx, float4(r5_x_10, r5_y_9, r5_x_10, r5_x_10));
                float r4_x_14 = r4_xyzw_14.x;
                float r4_y_11 = r4_xyzw_14.y;
                float4 r3_xyzw_16 = (float4(r3_x_15, r3_y_6, r3_z_3, r3_x_15) + float4(r4_x_14, r4_y_11, r4_z_4, r4_x_14));
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_7 = r3_xyzw_16.y;
                float r3_z_4 = r3_xyzw_16.z;
                float4 r4_xyzw_15 = mad(float4(r0_x_2, r0_xy_1.y, r0_x_2, r0_xy_1.y), float4(1.35, 1.35, 1.57, 1.57), float4(1.54, 1.54, -7.54, -7.54));
                float4 r5_xyzw_11 = (r4_xyzw_15 * cb0_values[3].xxxx);
                float4 r0_xyzw_45 = (r5_xyzw_11.xxxz * float4(0, 0, 2, 2));
                float r0_z_45 = r0_xyzw_45.z;
                float r0_w_27 = r0_xyzw_45.w;
                float4 r2_xyzw_27 = mad(r5_xyzw_11.yyyw, float4(0, 0, 1, 1), r2_w_2.xxxx);
                float r2_z_27 = r2_xyzw_27.z;
                float r2_w_3 = r2_xyzw_27.w;
                float r5_x_12 = frac(r0_z_45);
                float r5_y_11 = (frac(r2_z_27.xxxx)).y;
                float r5_z_5 = (frac(r2_z_27.xxxx)).z;
                float4 r5_xyzw_13 = (float4(r5_x_12, r5_y_11, r5_z_5, r5_x_12) + float4(-0.5, -0.5, -1, 0));
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_12 = r5_xyzw_13.y;
                float r5_z_6 = r5_xyzw_13.z;
                float4 r6_xyzw_3 = floor(float4(r0_z_45, r0_z_45, r0_w_27, r0_z_45));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_z_2 = r6_xyzw_3.z;
                float r6_y_3 = (floor(float4(r2_z_27, r2_z_27, r2_z_27, r2_w_3))).y;
                float r6_w_1 = (floor(float4(r2_z_27, r2_z_27, r2_z_27, r2_w_3))).w;
                float4 r6_xyzw_4 = (float4(r6_x_3, r6_y_3, r6_z_2, r6_w_1) * float4(123.34, 345.45, 123.34, 345.45));
                float4 r6_xyzw_5 = frac(r6_xyzw_4);
                float4 r7_xyzw_2 = (r6_xyzw_5 + float4(34.345, 34.345, 34.345, 34.345));
                float r0_z_46 = dot(r6_xyzw_5.xyxx, r7_xyzw_2.xyxx);
                float4 r4_xyzw_16 = (r0_z_46.xxxx + r6_xyzw_5.xxyx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_z_6 = r4_xyzw_16.z;
                float r0_z_47 = (r4_z_6 * r4_x_16);
                float r0_z_48 = frac(r0_z_47);
                float r2_z_28 = mad(r0_z_48, 6.2831, r2_y_3);
                float r0_z_49 = (r0_z_48 + -0.5);
                float r0_z_50 = (r0_z_49 * 0.8);
                float r3_w_19 = (-abs(r0_z_50) + 0.4);
                float4 r4_xyzw_17 = (r4_xyzw_15.yyww * float4(30, 10, 30, 10));
                float4 r4_xyzw_18 = sin(r4_xyzw_17);
                float r3_w_20 = (r3_w_19 * r4_xyzw_18.x);
                float4 r4_xyzw_19 = (r4_xyzw_18.ywyy * r4_xyzw_18.ywyy);
                float r4_x_19 = r4_xyzw_19.x;
                float r4_y_15 = r4_xyzw_19.y;
                float4 r4_xyzw_20 = (float4(r4_x_19, r4_y_15, r4_x_19, r4_x_19) * ((float4(r4_x_19, r4_y_15, r4_x_19, r4_x_19) * float4(r4_x_19, r4_y_15, r4_x_19, r4_x_19))).xyxx);
                float r4_x_20 = r4_xyzw_20.x;
                float r4_y_16 = r4_xyzw_20.y;
                float r3_w_21 = (r3_w_20 * r4_x_20);
                float r8_x_1 = mad(r3_w_21, 0.45, r0_z_50);
                float r0_z_51 = sin(r2_z_28);
                float r0_z_52 = mad(r0_z_51, 0.5, r2_z_28);
                float r0_z_53 = sin(r0_z_52);
                float r0_z_54 = (r0_z_53 + r2_z_28);
                float r0_z_55 = sin(-r0_z_54);
                float r3_w_22 = (r5_x_13 + -r8_x_1);
                float r3_w_23 = (r3_w_22 * r3_w_22);
                float r8_y_1 = mad(r0_z_55, 0.45, -r3_w_23);
                float4 r4_xyzw_21 = (float4(r5_x_13, r5_x_13, r5_x_13, r5_y_12) + -float4(r8_x_1, r8_x_1, r8_x_1, r8_y_1));
                float r4_x_21 = r4_xyzw_21.x;
                float r4_w_5 = r4_xyzw_21.w;
                float2 r6_xy_7 = ((float4(r4_x_21, r4_w_5, r4_x_21, r4_x_21) * float4(0.5, 1, 0, 0))).xy;
                float r0_z_56 = dot(r6_xy_7.xyxx, r6_xy_7.xyxx);
                float r0_z_57 = sqrt(r0_z_56);
                float r0_z_58 = (r0_z_57 + -0.05);
                float r0_z_59 = saturate((r0_z_58 * -49.999996));
                float r3_w_24 = mad(r0_z_59, -2, 3);
                float r0_z_60 = (r0_z_59 * r0_z_59);
                float r0_z_61 = (r0_z_60 * r3_w_24);
                float r0_z_62 = (r0_z_61 * cb0_values[3].w);
                float r8_z_1 = (r2_z_28 * 0.25);
                float4 r5_xyzw_14 = (float4(r5_x_13, r5_y_12, r5_x_13, r5_x_13) + -float4(r8_x_1, r8_z_1, r8_x_1, r8_x_1));
                float r5_x_14 = r5_xyzw_14.x;
                float r5_y_13 = r5_xyzw_14.y;
                float2 r9_xy_1 = ((float4(r5_x_14, r5_y_13, r5_x_14, r5_x_14) * float4(0.5, 8, 0, 0))).xy;
                float r2_z_29 = frac(r9_xy_1.y);
                float r2_z_30 = (r2_z_29 + -0.5);
                float r9_z_1 = (r2_z_30 * 0.125);
                float r2_z_31 = dot(float4(r9_xy_1.x, r9_z_1, r9_xy_1.x, r9_xy_1.x), float4(r9_xy_1.x, r9_z_1, r9_xy_1.x, r9_xy_1.x));
                float r2_z_32 = sqrt(r2_z_31);
                float r2_z_33 = (r2_z_32 + -0.03);
                float r2_z_34 = saturate((r2_z_33 * -50));
                float r3_w_25 = mad(r2_z_34, -2, 3);
                float r2_z_35 = (r2_z_34 * r2_z_34);
                float r2_z_36 = (r2_z_35 * r3_w_25);
                float r3_w_26 = mad(r4_w_5, 1, 0.05);
                float r3_w_27 = saturate((r3_w_26 * 10));
                float r3_w_28 = (r3_w_27 * r3_w_27);
                float r3_w_29 = (r3_w_28 * mad(r3_w_27, -2, 3));
                float r4_x_26 = (min(((float4(1, 1, 1, 1) / (r8_y_1 + -0.5)) * r5_z_6), 1)).x;
                float r4_w_6 = mad(r4_x_26, -2, 3);
                float r3_w_30 = (r3_w_29 * ((r4_x_26 * r4_x_26) * r4_w_6));
                float r2_z_37 = (r2_z_36 * r3_w_30);
                float r4_x_30 = saturate(((abs(r6_xy_7.x) + -0.05) * -99.999985));
                float r4_w_7 = mad(r4_x_30, -2, 3);
                float r5_z_7 = (r3_w_30 * ((r4_x_30 * r4_x_30) * r4_w_7));
                float4 r4_xyzw_33 = (float4(r9_xy_1.x, r9_xy_1.x, r9_xy_1.x, r9_z_1) * r2_z_37.xxxx);
                float r4_x_33 = r4_xyzw_33.x;
                float r4_w_8 = r4_xyzw_33.w;
                float4 r5_xyzw_15 = mad(r0_z_62.xxxx, r6_xy_7.xyxx, float4(r4_x_33, r4_w_8, r4_x_33, r4_x_33));
                float r5_x_15 = r5_xyzw_15.x;
                float r5_y_14 = r5_xyzw_15.y;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_7, r3_z_4, r3_x_16) + float4(r5_x_15, r5_y_14, r5_z_7, r5_x_15));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_8 = r3_xyzw_17.y;
                float r3_z_5 = r3_xyzw_17.z;
                float r5_x_16 = frac(r0_w_27);
                float r5_y_15 = (frac(r2_w_3.xxxx)).y;
                float r5_z_8 = (frac(r2_w_3.xxxx)).z;
                float4 r5_xyzw_17 = (float4(r5_x_16, r5_y_15, r5_z_8, r5_x_16) + float4(-0.5, -0.5, -1, 0));
                float r5_x_17 = r5_xyzw_17.x;
                float r5_y_16 = r5_xyzw_17.y;
                float r5_z_9 = r5_xyzw_17.z;
                float r0_z_63 = dot(r6_xyzw_5.zwzz, r7_xyzw_2.zwzz);
                float4 r0_xyzw_64 = (r0_z_63.xxxx + r6_xyzw_5.zzzw);
                float r0_z_64 = r0_xyzw_64.z;
                float r0_w_28 = r0_xyzw_64.w;
                float r0_z_65 = (r0_w_28 * r0_z_64);
                float r0_z_66 = frac(r0_z_65);
                float r0_w_29 = mad(r0_z_66, 6.2831, r2_y_3);
                float r0_z_67 = (r0_z_66 + -0.5);
                float r0_z_68 = (r0_z_67 * 0.8);
                float r2_y_4 = (-abs(r0_z_68) + 0.4);
                float r2_y_5 = (r4_xyzw_18.z * r2_y_4);
                float r2_y_6 = (r4_y_16 * r2_y_5);
                float r4_x_34 = mad(r2_y_6, 0.45, r0_z_68);
                float r0_z_69 = sin(r0_w_29);
                float r0_z_70 = mad(r0_z_69, 0.5, r0_w_29);
                float r0_z_71 = sin(r0_z_70);
                float r0_z_72 = (r0_z_71 + r0_w_29);
                float r0_z_73 = sin(-r0_z_72);
                float r2_y_7 = (-r4_x_34 + r5_x_17);
                float r2_y_8 = (r2_y_7 * r2_y_7);
                float r4_y_17 = mad(r0_z_73, 0.45, -r2_y_8);
                float4 r2_xyzw_9 = (-float4(r4_x_34, r4_x_34, r4_y_17, r4_x_34) + float4(r5_x_17, r5_x_17, r5_y_16, r5_x_17));
                float r2_y_9 = r2_xyzw_9.y;
                float r2_z_38 = r2_xyzw_9.z;
                float4 r2_xyzw_10 = (float4(r2_y_9, r2_y_9, r2_y_9, r2_z_38) * float4(0, 0.5, 0, 1));
                float r2_y_10 = r2_xyzw_10.y;
                float r2_w_4 = r2_xyzw_10.w;
                float r0_z_74 = dot(float4(r2_y_10, r2_w_4, r2_y_10, r2_y_10), float4(r2_y_10, r2_w_4, r2_y_10, r2_y_10));
                float r0_z_75 = sqrt(r0_z_74);
                float r0_z_76 = (r0_z_75 + -0.05);
                float r0_z_77 = saturate((r0_z_76 * -49.999996));
                float r3_w_31 = mad(r0_z_77, -2, 3);
                float r0_z_78 = (r0_z_77 * r0_z_77);
                float r0_z_79 = (r0_z_78 * r3_w_31);
                float r0_z_80 = (r0_z_79 * cb0_values[3].w);
                float r4_z_9 = (r0_w_29 * 0.25);
                float4 r4_xyzw_35 = (-float4(r4_x_34, r4_x_34, r4_z_9, r4_x_34) + float4(r5_x_17, r5_x_17, r5_y_16, r5_x_17));
                float r4_x_35 = r4_xyzw_35.x;
                float r4_z_10 = r4_xyzw_35.z;
                float2 r6_xy_8 = ((float4(r4_x_35, r4_z_10, r4_x_35, r4_x_35) * float4(0.5, 8, 0, 0))).xy;
                float r0_w_30 = frac(r6_xy_8.y);
                float r0_w_31 = (r0_w_30 + -0.5);
                float r6_z_5 = (r0_w_31 * 0.125);
                float r0_w_32 = dot(float4(r6_xy_8.x, r6_z_5, r6_xy_8.x, r6_xy_8.x), float4(r6_xy_8.x, r6_z_5, r6_xy_8.x, r6_xy_8.x));
                float r0_w_33 = sqrt(r0_w_32);
                float r0_w_34 = (r0_w_33 + -0.03);
                float r0_w_35 = saturate((r0_w_34 * -50));
                float r3_w_32 = mad(r0_w_35, -2, 3);
                float r0_w_36 = (r0_w_35 * r0_w_35);
                float r0_w_37 = (r0_w_36 * r3_w_32);
                float r2_z_39 = mad(r2_z_38, 1, 0.05);
                float r2_z_40 = saturate((r2_z_39 * 10));
                float r3_w_33 = mad(r2_z_40, -2, 3);
                float r2_z_41 = (r2_z_40 * r2_z_40);
                float r2_z_42 = (r2_z_41 * r3_w_33);
                float r3_w_34 = (r4_y_17 + -0.5);
                float r3_w_35 = ((float4(1, 1, 1, 1) / r3_w_34)).w;
                float r3_w_36 = (r3_w_35 * r5_z_9);
                float r3_w_37 = min(r3_w_36, 1);
                float r3_w_38 = (r3_w_37 * r3_w_37);
                float r3_w_39 = (r3_w_38 * mad(r3_w_37, -2, 3));
                float r2_z_43 = (r2_z_42 * r3_w_39);
                float r0_w_38 = (r0_w_37 * r2_z_43);
                float r3_w_40 = (abs(r2_y_10) + -0.05);
                float r3_w_41 = saturate((r3_w_40 * -99.999985));
                float r3_w_42 = (r3_w_41 * r3_w_41);
                float r3_w_43 = (r3_w_42 * mad(r3_w_41, -2, 3));
                float r4_z_11 = (r2_z_43 * r3_w_43);
                float4 r5_xyzw_18 = (float4(r6_xy_8.x, r6_z_5, r6_xy_8.x, r6_xy_8.x) * r0_w_38.xxxx);
                float r5_x_18 = r5_xyzw_18.x;
                float r5_y_17 = r5_xyzw_18.y;
                float4 r4_xyzw_38 = mad(r0_z_80.xxxx, float4(r2_y_10, r2_w_4, r2_y_10, r2_y_10), float4(r5_x_18, r5_y_17, r5_x_18, r5_x_18));
                float r4_x_38 = r4_xyzw_38.x;
                float r4_y_18 = r4_xyzw_38.y;
                float4 r2_xyzw_11 = (float4(r3_x_17, r3_x_17, r3_y_8, r3_z_5) + float4(r4_x_38, r4_x_38, r4_y_18, r4_z_11));
                float r2_y_11 = r2_xyzw_11.y;
                float r2_z_44 = r2_xyzw_11.z;
                float r2_w_5 = r2_xyzw_11.w;
                float r0_z_81 = ddx(r0_x_2);
                float r0_w_39 = ddy(r0_x_2);
                float r0_z_82 = (abs(r0_w_39) + abs(r0_z_81));
                float r0_z_83 = (r0_z_82 * 60);
                float r0_z_84 = min(r0_z_83, 1);
                float r0_z_85 = (-r0_z_84 + 1);
                float r0_w_40 = (cb0_values[4].x * 7);
                float r2_w_6 = mad(-r2_w_5, r0_z_85, 1);
                float r0_w_41 = (r0_w_40 * r2_w_6);
                float4 r2_xyzw_12 = (float4(r2_y_11, r2_y_11, r2_z_44, r2_y_11) * cb0_values[3].zzzz);
                float r2_y_12 = r2_xyzw_12.y;
                float r2_z_45 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = mad(float4(r2_y_12, r2_y_12, r2_z_45, r2_y_12), r0_z_85.xxxx, float4(r0_x_2, r0_x_2, r0_xy_1.y, r0_x_2));
                float r2_y_13 = r2_xyzw_13.y;
                float r2_z_46 = r2_xyzw_13.z;
                float4 r0_xyzw_3 = (float4(r0_x_2, r0_xy_1.y, r0_w_41, r0_x_2) * float4(123.34, 345.45, 0.01, 0));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_86 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = frac(float4(r0_x_3, r0_y_2, r0_x_3, r0_x_3));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float4 r3_xyzw_18 = (float4(r0_x_4, r0_y_3, r0_x_4, r0_x_4) + float4(34.345, 34.345, 0, 0));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_9 = r3_xyzw_18.y;
                float r0_w_42 = dot(float4(r0_x_4, r0_y_3, r0_x_4, r0_x_4), float4(r3_x_18, r3_y_9, r3_x_18, r3_x_18));
                float4 r0_xyzw_5 = (r0_w_42.xxxx + float4(r0_x_4, r0_y_3, r0_x_4, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float4 r3_xyzw_19 = float4(0, 0, 0, 0);
                float r0_y_5 = (frac((r0_y_4 * r0_x_5)) * 6.2831);
                float r0_w_43 = 0;
                float r0_y_6 = r0_y_5;
                float r0_w_44 = r0_w_43;
                float r2_w_8;
                float r4_x_40;
                float r4_y_20;
                float r4_x_41;
                float r4_y_21;
                float r0_y_8;
                float r0_w_46;
                float r2_w_9;
                float r2_w_10;
                float r2_w_11;
                float r2_w_12;
                float r2_w_13;
                float r4_x_42;
                float r4_y_22;
                float r4_x_43;
                float r4_y_23;
                float r4_z_13;
                float r4_w_10;
                float r3_x_21;
                float r3_y_12;
                float r3_z_8;
                float r3_w_46;
                [loop]
                while (true)
                {
                    r2_w_8 = (r0_w_44 >= 32);
                    if (r2_w_8) break;
                    r4_x_40 = sin(r0_y_6);
                    r4_y_20 = cos(r0_y_6);
                    float4 r4_xyzw_41 = (r0_z_86.xxxx * float4(r4_x_40, r4_y_20, r4_x_40, r4_x_40));
                    r4_x_41 = r4_xyzw_41.x;
                    r4_y_21 = r4_xyzw_41.y;
                    r0_y_8 = ((float4(r0_y_6, r0_y_6, r0_y_6, r0_w_44) + float4(0, 1, 0, 1))).y;
                    r0_w_46 = ((float4(r0_y_6, r0_y_6, r0_y_6, r0_w_44) + float4(0, 1, 0, 1))).w;
                    r2_w_9 = (r0_w_46 * 546);
                    r2_w_10 = sin(r2_w_9);
                    r2_w_11 = (r2_w_10 * 5424);
                    r2_w_12 = frac(r2_w_11);
                    r2_w_13 = sqrt(r2_w_12);
                    float4 r4_xyzw_42 = mad(float4(r4_x_41, r4_y_21, r4_x_41, r4_x_41), r2_w_13.xxxx, float4(r2_y_13, r2_z_46, r2_y_13, r2_y_13));
                    r4_x_42 = r4_xyzw_42.x;
                    r4_y_22 = r4_xyzw_42.y;
                    float4 r4_xyzw_43 = _MainTex.Sample(sampler_MainTex, (float4(r4_x_42, r4_y_22, r4_x_42, r4_x_42)).xy);
                    r4_x_43 = r4_xyzw_43.x;
                    r4_y_23 = r4_xyzw_43.y;
                    r4_z_13 = r4_xyzw_43.z;
                    r4_w_10 = r4_xyzw_43.w;
                    float4 r3_xyzw_21 = (r3_xyzw_19 + float4(r4_x_43, r4_y_23, r4_z_13, r4_w_10));
                    r3_x_21 = r3_xyzw_21.x;
                    r3_y_12 = r3_xyzw_21.y;
                    r3_z_8 = r3_xyzw_21.z;
                    r3_w_46 = r3_xyzw_21.w;
                    r3_xyzw_19.x = r3_x_21;
                    r3_xyzw_19.y = r3_y_12;
                    r3_xyzw_19.z = r3_z_8;
                    r3_xyzw_19.w = r3_w_46;
                    r0_y_6 = r0_y_8;
                    r0_w_44 = r0_w_46;
                }
                float4 r0_xyzw_9 = (r3_xyzw_19 * float4(0.030625, 0.030625, 0.030625, 0.030625));
                o.sv_Target0.xyzw = mad(r2_xyzw_1.xxxx, mad(-r3_xyzw_19, float4(0.030625, 0.030625, 0.030625, 0.030625), r1_xyzw_1), r0_xyzw_9);
                return o;
            }
            ENDHLSL
        }
    }
}
