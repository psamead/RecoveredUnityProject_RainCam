// Snowtracks-stage brush (rebuilt - not in the shipped exe).
// Style of Peer Play's "Snowtracks Shader Tutorial" draw shader: stamp _Color around a position
// on top of the existing splat map (Graphics.Blit supplies the previous splat as _MainTex).
// Used by Mouse.cs, Mouse_blur.cs and MouseCS.cs, which pass the cursor as a world position
// (ScreenToWorldPoint) in _Position and set _Color = red.
Shader "RainCam/DrawTracks"
{
    Properties
    {
        _MainTex ("Previous Splat", 2D) = "black" {}
        _Color ("Brush Color", Color) = (1, 0, 0, 1)
        _Position ("Cursor (world xy)", Vector) = (0, 0, 0, 0)
        _Radius ("Radius", Range(0, 0.5)) = 0.08
        _EdgeSoftness ("Edge Softness", Range(0, 0.3)) = 0.05
        _Strength ("Strength", Range(0, 1)) = 1
        [Toggle] _Mirror ("Mirror X (match mirrored webcam)", Float) = 1
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _Color, _Position;
            float _Radius, _EdgeSoftness, _Strength, _Mirror;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // The Cam quad spans world -0.5..0.5, so world xy + 0.5 is its uv.
                float2 p = _Position.xy + 0.5;
                // RainyWindow_V3-8_Cam_Mouse samples _SplatTex at (1 - u, v); mirror the brush to match.
                p.x = lerp(p.x, 1 - p.x, _Mirror);

                float d = distance(i.uv, p);
                float draw = smoothstep(_Radius, _Radius - _EdgeSoftness, d);

                fixed4 drawCol = _Color * (draw * _Strength);
                return saturate(col + drawCol);
            }
            ENDCG
        }
    }
}
