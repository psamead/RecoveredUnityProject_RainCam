// Recovered from the shipped build. Based on the hand-written BBP_Quad.shader in
// "UnityComputeShaders - learn", with the shipped changes read from the bytecode:
// vertex colour is (1, 0, 0, life) - red, so the splat RT's red channel drives the rain shader's
// clear-window mask - and the fragment output is saturated. Render state from the shipped pass:
// Blend SrcAlpha OneMinusSrcAlpha, ZWrite Off, Cull Back, Queue=Transparent.
Shader "MyCSShader/BBP_Quad"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white"{}
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "Queue" = "Transparent"
                "RenderType"="Opaque"
                "IgnoreProjector" = "True"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            LOD 200
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0

            sampler2D _MainTex;

            #include "UnityCG.cginc"

            struct Vertex
            {
                float3 position;
                float2 uv;
                float life;
            };
            StructuredBuffer<Vertex> vertexBuffer;

            struct v2f
            {
                float4 position : SV_POSITION;
                float4 color : COLOR;
                float life : LIFE;
                float2 uv : TEXCOORD0;
            };

            v2f vert (uint vertex_id : SV_VERTEXID, uint instance_id : SV_INSTANCEID)
            {
                v2f o = (v2f)0;
                int index = instance_id * 6 + vertex_id;
                o.color = fixed4(1, 0, 0, vertexBuffer[index].life);
                o.position = UnityObjectToClipPos(float4(vertexBuffer[index].position, 1));
                o.uv = vertexBuffer[index].uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return saturate(tex2D(_MainTex, i.uv) * i.color);
            }
            ENDCG
        }
    }
    Fallback Off
}
