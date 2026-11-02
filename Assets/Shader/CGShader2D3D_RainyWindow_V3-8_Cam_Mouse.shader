// Recovered from the shipped RainDropCam_CSParticle build (Unity 2020.3.15f2, D3D11 bytecode).
// Rebuilt line-by-line from the decompiled fragment program; every constant (123.34, 345.45, 34.345,
// 6.2831, 0.45, 0.8, 546, 5424, 32 taps, 0.98/32 = 0.030625, fwidth*60, layer scales 1.23/1.35/1.57)
// and the $Globals layout (_Size,_T,_Distortion,_DropSize @cb0[3], _Blur @cb0[4].x, _Ratio @cb0[6].z)
// were taken from the binary. _Radius and _EdgeSoftness exist as properties but the shipped
// fragment program never reads them (they were compiled out), so they are kept only for the material.
Shader "CGShader2D3D/RainyWindow_V3-8_Cam_Mouse"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "black" {}
        _Size ("Density", Float) = 1
        _T ("Time", Float) = 1
        _Distortion ("Distortion", Range(-5, 5)) = 1
        _DropSize ("Drop Size", Range(0, 2)) = 1
        _Blur ("Blur", Range(0, 1)) = 1
        _Ratio ("Ratio", Float) = 1
        _Radius ("Radius", Range(0, 0.5)) = 0.2
        _EdgeSoftness ("Edge Softness", Range(0, 0.3)) = 0.1
        _SplatTex ("Splat Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define S(a, b, t) smoothstep(a, b, t)

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SplatTex;
            float _Size, _T, _Distortion, _DropSize, _Blur;
            float _Radius, _EdgeSoftness;
            float _Ratio;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float N21(float2 p)
            {
                p = frac(p * float2(123.34, 345.45));
                p += dot(p, p + 34.345);
                return frac(p.x * p.y);
            }

            float3 Layer(float2 UV, float t)
            {
                float2 aspect = float2(2, 1);
                float2 uv = UV * _Size * aspect;
                uv.y += t * 0.25;
                float2 gv = frac(uv) - 0.5;
                float2 id = floor(uv);

                float n = N21(id);
                t += n * 6.2831;

                float w = UV.y * 10;
                float x = (n - 0.5) * 0.8;
                x += (0.4 - abs(x)) * sin(3 * w) * pow(sin(w), 6) * 0.45;
                float y = -sin(t + sin(t + sin(t) * 0.5)) * 0.45;
                y -= (gv.x - x) * (gv.x - x);

                float2 dropPos = (gv - float2(x, y)) / aspect;
                float drop = S(0.05, 0.03, length(dropPos)) * _DropSize;

                float2 trailPos = (gv - float2(x, t * 0.25)) / aspect;
                trailPos.y = (frac(trailPos.y * 8) - 0.5) / 8;
                float trail = S(0.03, 0.01, length(trailPos));
                float fogTrail = S(-0.05, 0.05, dropPos.y);
                fogTrail *= S(0.5, y, gv.y);
                trail *= fogTrail;
                fogTrail *= S(0.05, 0.04, abs(dropPos.x));

                float2 offs = drop * dropPos + trail * trailPos;
                return float3(offs, fogTrail);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // mirror the webcam horizontally, then squeeze by the stream ratio
                float2 uv = float2(1 - i.uv.x, i.uv.y);
                uv.x /= _Ratio;

                float4 cam   = tex2D(_MainTex, uv);
                float4 splat = tex2D(_SplatTex, uv);

                float t = fmod(_Time.y + _T, 7200);

                float3 drops = Layer(uv, t);
                drops += Layer(uv * 1.23 + 7.54, t);
                drops += Layer(uv * 1.35 + 1.54, t);
                drops += Layer(uv * 1.57 - 7.54, t);

                float fade = 1 - saturate(fwidth(uv.x) * 60);

                float blur = _Blur * 7 * (1 - drops.z * fade);
                float2 duv = uv + drops.xy * _Distortion * fade;

                blur *= 0.01;
                float a = N21(uv) * 6.2831;
                float4 col = 0;
                const float numSamples = 32;
                for (float s = 0; s < numSamples; s++)
                {
                    float2 offs = float2(sin(a), cos(a)) * blur;
                    float d = frac(sin((s + 1) * 546) * 5424);
                    d = sqrt(d);
                    offs *= d;
                    col += tex2D(_MainTex, duv + offs);
                    a++;
                }
                col /= numSamples;
                col *= 0.98;

                // particle splat (red channel) reveals the clear, undistorted camera image
                return lerp(col, cam, splat.r);
            }
            ENDCG
        }
    }
}
