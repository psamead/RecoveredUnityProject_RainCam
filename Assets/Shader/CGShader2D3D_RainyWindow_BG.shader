Shader "CGShader2D3D/RainyWindow_BG"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "" {}
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
                float4 cb0_values[3];
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
            Texture2D _MainTex;
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
                o.sv_Target0.xyzw = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                return o;
            }
            ENDHLSL
        }
    }
}
