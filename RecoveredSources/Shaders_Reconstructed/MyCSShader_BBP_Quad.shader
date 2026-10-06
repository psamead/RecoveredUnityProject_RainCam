Shader "MyCSShader/BBP_Quad"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
    }
    SubShader
    {
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[4];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[21];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program0Input
            {
                uint sv_Vertexid0 : SV_VERTEXID;
                uint sv_Instanceid0 : SV_INSTANCEID;
            };
            struct program0Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float life0 : LIFE0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float life0 : LIFE0;
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
                float r0_x_1 = mad(i.sv_Instanceid0.x, 6, i.sv_Vertexid0.x);
                float4 r1_xyzw_1 = _MainTex.Load(r0_x_1);
                float4 r0_xyzw_2 = _MainTex.Load((r0_x_1 + 16));
                float r0_x_2 = r0_xyzw_2.x;
                float r0_y_1 = r0_xyzw_2.y;
                o.texcoord0.x = r1_xyzw_1.w;
                float4 r1_xyzw_2 = (mad(cb0_values[2].xyzw, r1_xyzw_1.zzzz, mad(cb0_values[0].xyzw, r1_xyzw_1.xxxx, (r1_xyzw_1.yyyy * cb0_values[1].xyzw))) + cb0_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb1_values[17], cb1_values[18], cb1_values[19], cb1_values[20]), r1_xyzw_2);
                float2 r0_zw_1 = (float4(0, 0, 1, 0)).zw;
                o.color0.xyzw = float4(r0_zw_1.x, r0_zw_1.y, r0_zw_1.y, r0_y_1);
                o.life0.x = (float4(r0_zw_1.y, r0_zw_1.y, r0_x_2, r0_zw_1.y)).x;
                o.texcoord0.y = (float4(r0_zw_1.y, r0_zw_1.y, r0_x_2, r0_zw_1.y)).z;
                return o;
            }
            #pragma fragment frag
            program1Output frag(program1Input i)
            {
                program1Output o = (program1Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyzw = saturate((r0_xyzw_1 * i.color0.xyzw));
                return o;
            }
            ENDHLSL
        }
    }
}
