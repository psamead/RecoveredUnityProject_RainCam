// Two-pass separable blur for Mouse_blur.cs (rebuilt - not in the shipped exe).
// Pass 0 = horizontal, pass 1 = vertical. _Decay < 1 makes the wiped area slowly fog over again.
Shader "RainCam/BlurTracks"
{
    Properties
    {
        _MainTex ("Splat", 2D) = "black" {}
        _Spread ("Spread (texels)", Range(0.5, 8)) = 2
        _Decay ("Decay per pass", Range(0.9, 1)) = 0.99
    }
    CGINCLUDE
    #include "UnityCG.cginc"
    sampler2D _MainTex;
    float4 _MainTex_TexelSize;
    float _Spread, _Decay;

    fixed4 Blur(float2 uv, float2 dir)
    {
        float2 o = dir * _MainTex_TexelSize.xy * _Spread;
        fixed4 c = tex2D(_MainTex, uv) * 0.227027;
        c += tex2D(_MainTex, uv + o * 1.384615) * 0.316216;
        c += tex2D(_MainTex, uv - o * 1.384615) * 0.316216;
        c += tex2D(_MainTex, uv + o * 3.230769) * 0.070270;
        c += tex2D(_MainTex, uv - o * 3.230769) * 0.070270;
        return c * _Decay;
    }
    fixed4 fragH (v2f_img i) : SV_Target { return Blur(i.uv, float2(1, 0)); }
    fixed4 fragV (v2f_img i) : SV_Target { return Blur(i.uv, float2(0, 1)); }
    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass { CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment fragH
            ENDCG }
        Pass { CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment fragV
            ENDCG }
    }
}
