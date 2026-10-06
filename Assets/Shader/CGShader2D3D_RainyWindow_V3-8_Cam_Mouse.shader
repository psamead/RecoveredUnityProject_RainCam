Shader "CGShader2D3D/RainyWindow_V3-8_Cam_Mouse"
{
    Properties
    {
        _MainTex ("Camera", 2D) = "black" {}
        _SplatTex ("BBP Mouse Trail", 2D) = "black" {}
        _Size ("Rain Density", Float) = 7.14
        _T ("Rain Speed", Float) = 1
        _Distortion ("Distortion", Range(-5, 5)) = -1.5
        _DropSize ("Drop Size", Range(0, 2)) = 1
        _Blur ("Haze Blur", Range(0, 1)) = 0.83
        _HazeStrength ("Haze Strength", Range(0, 2)) = 1
        _Ratio ("Stream Aspect Ratio", Float) = 1.777778
        [HideInInspector] _PlaneAspect ("Plane Aspect", Float) = 1
        _Radius ("Trail Radius", Range(0, 0.5)) = 0.1
        _EdgeSoftness ("Trail Softness", Range(0, 0.3)) = 0.1
        _InnerDistorsion ("Trail Distortion", Range(-5, 5)) = -5
        _InnerDropSize ("Trail Drop Size", Float) = 1
        _InnerSize ("Trail Density", Float) = 8
        _TrailClearStrength ("Trail Clear Strength", Range(0, 1)) = 0.65
        _TrailSoftness ("Trail Softness", Range(0.01, 0.5)) = 0.18
        _TrailRecovery ("Trail Recovery", Range(0, 1)) = 0.35
        _Position ("Mouse Position", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Opaque" }
        Cull Off
        ZTest Always
        ZWrite Off
        Pass
        {
            HLSLPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            sampler2D _SplatTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float4 _SplatTex_TexelSize;
            float _Size, _T, _Distortion, _DropSize, _Blur, _HazeStrength, _Ratio, _PlaneAspect;
            float _Radius, _EdgeSoftness, _InnerDistorsion, _InnerDropSize, _InnerSize;
            float _TrailClearStrength, _TrailSoftness, _TrailRecovery;
            float4 _Position;
            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float4 vertex : SV_POSITION; float2 uv : TEXCOORD0; };
            v2f vert(appdata v) { v2f o; o.vertex = UnityObjectToClipPos(v.vertex); o.uv = TRANSFORM_TEX(v.uv, _MainTex); return o; }
            float2 CameraUV(float2 uv)
            {
                float screenAspect = _ScreenParams.x / max(_ScreenParams.y, 1.0);
                float sourceAspect = max(_Ratio, 0.01);
                float2 scale = (screenAspect > sourceAspect) ? float2(1.0, sourceAspect / screenAspect) : float2(screenAspect / sourceAspect, 1.0);
                return (uv - 0.5) / scale + 0.5;
            }
            #define S(a,b,t) smoothstep(a,b,t)
            float hash21(float2 p) { p = frac(p * float2(123.34, 345.45)); p += dot(p, p + 34.345); return frac(p.x * p.y); }
            float3 RainLayer(float2 uv, float time)
            {
                float2 aspect = float2(2.0, 1.0);
                float2 grid = uv * max(_Size, 1.0) * aspect;
                grid.y += time * 0.25;
                float2 cell = frac(grid) - 0.5;
                float2 id = floor(grid);
                float n = hash21(id);
                float phase = time + n * 6.2831;
                float w = uv.y * 10.0;
                float x = (n - 0.5) * 0.8;
                x += (0.4 - abs(x)) * sin(3.0 * w) * pow(sin(w), 6.0) * 0.45;
                float y = -sin(phase + sin(phase + sin(phase) * 0.5)) * 0.45;
                y -= (cell.x - x) * (cell.x - x);
                float2 dropPos = (cell - float2(x, y)) / aspect;
                float drop = S(0.05, 0.03, length(dropPos));
                float2 trailPos = (cell - float2(x, phase * 0.25)) / aspect;
                trailPos.y = (frac(trailPos.y * 8.0) - 0.5) / 8.0;
                float trail = S(0.05, 0.01, length(trailPos));
                float fog = S(-0.05, 0.05, dropPos.y) * S(0.5, y, cell.y);
                trail *= fog;
                fog *= S(0.05, 0.04, abs(dropPos.x));
                return float3(drop * dropPos + trail * trailPos, fog);
            }
            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = CameraUV(i.uv); uv.x = 1.0 - uv.x;
                float2 trailTexel = _SplatTex_TexelSize.xy * 2.0;
                float4 splat = tex2D(_SplatTex, i.uv);
                splat = max(splat, tex2D(_SplatTex, i.uv + float2(trailTexel.x, 0)));
                splat = max(splat, tex2D(_SplatTex, i.uv - float2(trailTexel.x, 0)));
                splat = max(splat, tex2D(_SplatTex, i.uv + float2(0, trailTexel.y)));
                splat = max(splat, tex2D(_SplatTex, i.uv - float2(0, trailTexel.y)));
                // BBP particles are an opaque stamp in the trail buffer. Use every
                // channel so the stamp fully removes both drops and haze.
                float stamp = saturate(max(max(splat.r, splat.g), splat.a));
                float clear = smoothstep(0.01, max(_TrailSoftness, 0.011), stamp) * _TrailClearStrength;
                float time = fmod(_Time.y + _T, 7200.0);
                // Rain coordinates follow the webcam stream aspect, not the plane or Game view.
                float2 rainUV = uv;
                float3 drops = RainLayer(rainUV, time);
                drops += RainLayer(rainUV * 1.23 + 7.54, time);
                drops += RainLayer(rainUV * 1.35 + 1.54, time);
                drops += RainLayer(rainUV * 1.57 - 7.54, time);
                // Checkpoint behavior: the BBP stamp fully clears the local
                // rain, distortion, highlights, and haze instead of allowing
                // the effect to recover underneath the cursor.
                float effectiveClear = clear;
                drops.xy *= (1.0 - effectiveClear);
                drops.z *= (1.0 - effectiveClear);
                float2 distortedUV = saturate(uv + drops.xy * (_Distortion * 0.25));
                fixed4 camera = tex2D(_MainTex, distortedUV);
                float hazeAmount = saturate(_Blur * _HazeStrength * (1.0 - effectiveClear));
                float2 hazeStep = _MainTex_TexelSize.xy * (2.0 + hazeAmount * 8.0);
                fixed4 haze = (tex2D(_MainTex, saturate(distortedUV + hazeStep)) + tex2D(_MainTex, saturate(distortedUV - hazeStep)) + tex2D(_MainTex, saturate(distortedUV + hazeStep.yx)) + tex2D(_MainTex, saturate(distortedUV - hazeStep.yx))) * 0.25;
                camera.rgb = lerp(camera.rgb, haze.rgb, hazeAmount * 0.85);
                float3 rainTint = float3(0.80, 0.92, 1.0) * saturate(length(drops.xy) * 18.0);
                camera.rgb += rainTint * (1.0 - effectiveClear) * 0.12;
                return fixed4(camera.rgb, 1.0);
            }
            ENDHLSL
        }
    }
}
