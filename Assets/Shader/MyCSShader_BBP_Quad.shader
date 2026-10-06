Shader "MyCSShader/BBP_Quad"
{
    Properties { _MainTex ("Particle Stamp", 2D) = "white" {} }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off
            HLSLPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct Vertex { float3 position; float2 uv; float life; };
            StructuredBuffer<Vertex> vertexBuffer;
            sampler2D _MainTex;
            struct v2f { float4 position:SV_POSITION; float4 color:COLOR; float2 uv:TEXCOORD0; };
            v2f vert(uint vertexID:SV_VertexID, uint instanceID:SV_InstanceID)
            {
                Vertex p = vertexBuffer[instanceID * 6 + vertexID];
                v2f o; o.position = UnityWorldToClipPos(float4(p.position, 1));
                float alpha = saturate(p.life * 0.25); o.color = float4(0.80, 0.95, 1.0, alpha); o.uv = p.uv; return o;
            }
            fixed4 frag(v2f i):SV_Target { return tex2D(_MainTex, i.uv) * i.color; }
            ENDHLSL
        }
    }
    FallBack Off
}
