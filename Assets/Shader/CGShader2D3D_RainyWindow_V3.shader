// RainyWindow_V3 - recovered.
// Base: Psamead's follow-along of BigWings / The Art of Code "Make it Rain" tutorials
//   (Documents\UnityProject\RainyWindow_transparent\Assets\Shader\Window.shader).
// Differences restored from the shipped bytecode (RainDropCam_CSParticle, Unity 2020.3.15f2):
//   + _DropSize property, drop *= _DropSize
//   + trail edge smoothstep(0.03, 0.01) (tutorial copy had 0.05, 0.01)
//   + blur hash constant 546 (tutorial copy had 564), angle * 6.2831
//   + output = average * 0.98 (tutorial copy returned col * 0.9)
//   + no _MainTex: uses the mesh uv directly; background comes only from the GrabPass
Shader "CGShader2D3D/RainyWindow_V3"
{
    Properties
    {
        _Size("Density", float) = 1.0
        _T("Time", float) = 1.0
        _Distortion("Distortion", Range(-5, 5)) = 1
        _DropSize("Drop Size", Range(0, 2)) = 1
        _Blur("Blur", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent" }
        LOD 100

        GrabPass { "_GrabTexture" }  // grabpass does not generate mipmap

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
                float4 grabUv : TEXCOORD1;  // open a uv channel to store the grab-pass screen uv
                float4 vertex : SV_POSITION;
            };

            sampler2D _GrabTexture;
            float _Size, _T, _Distortion, _DropSize, _Blur;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.grabUv = UNITY_PROJ_COORD(ComputeGrabScreenPos(o.vertex));  // get the correct uv map from vertex space
                return o;
            }

            // output a pseudo random value
            float N21(float2 p)
            {
                p = frac(p * float2(123.34, 345.45));
                p += dot(p, p + 34.345);
                return frac(p.x * p.y);
            }

            float3 Layer(float2 UV, float t)
            {
                float2 aspect = float2(2, 1);  // aspect ratio of the box grid, to squish
                float2 uv = UV * _Size * aspect;
                uv.y += t * 0.25;
                float2 gv = frac(uv) - 0.5;  // move the origin to the center of each grid box

                float2 id = floor(uv);  // give each grid box an id

                float n = N21(id); // random value from id, between 0 and 1
                t += n * 6.2831; // the phase of sin is 2 pi

                float w = UV.y * 10;
                float x = (n - 0.5) * 0.8; // keep drops and trails inside the box, x from -0.4 to 0.4
                x += (0.4 - abs(x)) * sin(3 * w) * pow(sin(w), 6) * 0.45;  // wiggle
                float y = -sin(t + sin(t + sin(t) * 0.5)) * 0.45; // controlling the dropping speed
                y -= (gv.x - x) * (gv.x - x); // shaping the drop to parabola shape

                float2 dropPos = (gv - float2(x, y)) / aspect;  // moving raindrop
                float drop = S(0.05, 0.03, length(dropPos)) * _DropSize; // raindrop circle, scaled by Drop Size

                float2 trailPos = (gv - float2(x, t * 0.25)) / aspect;  // drawing trail
                trailPos.y = (frac(trailPos.y * 8) - 0.5) / 8;  // split the box into 8 slices, origin at each slice centre
                float trail = S(0.03, 0.01, length(trailPos)); // trail droplets
                float fogTrail = S(-0.05, 0.05, dropPos.y);  // mask out the trail underneath the drop
                fogTrail *= S(0.5, y, gv.y);  // fade the trail from the bottom of the box to the top
                trail *= fogTrail;
                fogTrail *= S(0.05, 0.04, abs(dropPos.x)); // narrow the fog trail

                float2 offs = drop * dropPos + trail * trailPos;

                return float3(offs, fogTrail);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = fmod(_Time.y + _T, 7200);  // avoid the float getting too big and losing precision

                float4 col = 0.0;

                float3 drops = Layer(i.uv, t);
                drops += Layer(i.uv * 1.23 + 7.54, t);
                drops += Layer(i.uv * 1.35 + 1.54, t);
                drops += Layer(i.uv * 1.57 - 7.54, t);

                float fade = 1 - saturate(fwidth(i.uv) * 60);  // fade the effect out where the window gets small/far

                float blur = _Blur * 7 * (1 - drops.z * fade);

                // grabpass does not generate mipmap so blur it the expensive way
                float2 projUv = i.grabUv.xy / i.grabUv.w;
                projUv += drops.xy * _Distortion * fade;
                blur *= 0.01;

                const float numSamples = 32;
                float a = N21(i.uv) * 6.2831;

                for (float s = 0; s < numSamples; s++)
                {
                    float2 offs = float2(sin(a), cos(a)) * blur;
                    float d = frac(sin((s + 1) * 546) * 5424);
                    d = sqrt(d);
                    offs *= d;
                    col += tex2D(_GrabTexture, projUv + offs);
                    a++;
                }
                col /= numSamples;

                return col * 0.98;
            }
            ENDCG
        }
    }
}
