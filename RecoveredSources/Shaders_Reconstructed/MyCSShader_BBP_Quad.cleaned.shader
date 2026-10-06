Shader "MyCSShader/BBP_Quad"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" "IgnoreProjector"="True" }
        Cull Back
        ZTest LEqual
        ZWrite Off
        Blend SrcAlpha OneMinusSrcColor

        Pass
        {
            HLSLPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            struct Vertex
            {
                float3 position;
                float2 uv;
                float life;
            };

            StructuredBuffer<Vertex> vertexBuffer;
            Texture2D _MainTex;
            SamplerState sampler_MainTex;
            float4x4 unity_ObjectToWorld;
            float4x4 unity_MatrixVP;

            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR0;
                float life : LIFE0;
                float2 uv : TEXCOORD0;
            };

            v2f vert(uint vertexID : SV_VertexID, uint instanceID : SV_InstanceID)
            {
                Vertex input = vertexBuffer[instanceID * 6 + vertexID];

                v2f output;
                float4 worldPosition = mul(unity_ObjectToWorld, float4(input.position, 1.0));
                output.position = mul(unity_MatrixVP, worldPosition);
                output.color = float4(0.0, 1.0, 1.0, input.life);
                output.life = 1.0;
                output.uv = input.uv;
                return output;
            }

            float4 frag(v2f input) : SV_Target
            {
                return saturate(_MainTex.Sample(sampler_MainTex, input.uv) * input.color);
            }
            ENDHLSL
        }
    }
}
