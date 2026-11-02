# RainCam — agent handoff (2026-11-02)

## Status
- Recovery is **done**. Psamead confirmed the rebuilt project "basically is what it was".
- `..\RainCam_Recovered` = exe-faithful baseline. This folder = baseline + experiment tools, and is the
  starting point for the next project. Working copy in Unity: `Documents\UnityProject\RecoveredUnityProject_RainCam2`
  (kept identical to this folder; resync with a folder diff before trusting either).
- Unity: open with 2020.3.x (project file 2020.3.49f1; exe was 2020.3.15f2). Gamma colour space, Built-in RP.
- Main scene `Assets/RainDropCam/Scenes/RainDropCam.unity` matches the exe value-for-value. Keep it that way;
  experiment in other scenes.

## How the shipped effect works (one paragraph)
`CameraStream` puts the webcam on the 1×1 `Cam` quad (material `RainyWindow_Cam`, shader
`CGShader2D3D/RainyWindow_V3-8_Cam_Mouse`). `BBP_Quad` runs 500 compute particles that chase the
(mirrored) mouse and draws them in **red** into a 256² ARGBFloat RT, which the `RTC` camera clears every frame;
that RT is `_SplatTex`. The rain shader blurs/distorts the mirrored webcam (Art of Code rain, 4 layers,
32-tap blur) and returns `lerp(blurredRain, sharpCam, _SplatTex.r)`. Keys: C next webcam, Space particle
stamp, Esc quit.

## Lineage (details in ..\RainCam_Lineage.xlsx)
1. BigWings / The Art of Code "Make it Rain" Pt1/Pt2 → rain shaders (`Documents\UnityProject\RainyWindow_droplet/_blur/_transparent`).
2. Peer Play "Snowtracks Shader Tutorial" → red splat map + Blit brush (`Mouse*.cs`, leftover name `fadeSnow`).
3. Compute-shader course "QuadParticles" (`UnityComputeShaders - complete` / `- learn`) → `BBP_Quad`.
4. CCA workshop Trail Agents (`Documents\UnityProject\CCA`) → ping-pong RT experiment `MouseCS`.

## Experiment tools in this folder (not in the exe)
- `Assets/Shader/Experiments/` — `RainCam_DrawTracks` (brush), `RainCam_BlurTracks`, `RainCam_TracksPhysics.compute`.
- Menu **RainCam > Build Snowtracks Experiment Scene** (`Assets/Editor/RainCamExperimentSceneBuilder.cs`)
  → `RainDropCam_Snowtracks.unity`. Enable exactly one of BBP_Quad / Mouse / Mouse_blur / MouseCS on `Cam`.
- Psamead: the mouse-track experiments were steps toward the final wipe; keep them as reference.

## Known issues / gotchas (original code, intentionally not fixed in the baseline)
- `BBP_Quad.OnDestroy` never releases `vertexBuffer` → "GarbageCollector disposing of ComputeBuffer" warning on stop.
- `BBP_Quad.DebugMode = true` draws particles to screen instead of the RT → no wipe. Must be off.
- `CameraStream.currentCamIndex = 1` in the scene; only guard added: falls back to camera 0 with one webcam.
- `_Ratio` = webcam width/height at startup (1.333 on Psamead's 640×480 webcam); material value 1 is a fallback.
- `Mouse.cs` `fadeSnow` wipes the whole splat every `fillTime` seconds. `MouseCS` original overwrote its brush each
  physics step (worked around in `RainCam_TracksPhysics.compute`).
- Unity 2020.3 shows harmless `PreviewRenderUtility` / `MaterialEditor:OnDisable` console errors.
- `_Radius`, `_EdgeSoftness`, `_Position`, `_Inner*` on the Cam material are leftovers; the shader ignores them.
- The Unity MCP bridge on this machine connects to the Unity 6 editor (e.g. TheFairyHill2D), **not** the 2020.3
  RainCam editor. The agent's device shell is a Linux VM: it cannot run unity.exe / Unity CLI. Ask Psamead to
  click menus or run CLI commands; Unity CLI live control needs Unity 6 + com.unity.pipeline anyway.

## Next project (Psamead's plan)
Start a new project from this folder to make the wipe look like a real wiped-off window, using shader code
Psamead found on codepen.com. Suggested direction for the next agent (not decided yet — confirm with Psamead):
- Make the splat **persistent** (accumulate instead of RTC clearing every frame) and let it fog back over time
  (decay in a small blit/compute pass) — the Snowtracks `fillTime` idea done gradually.
- Wiped areas should keep water: streaks/droplets running down from the wipe edge, sharper edges,
  less blur inside the wipe, re-condensation from the edges inward.
- Port codepen GLSL to Unity HLSL: `vec→float`, `mix→lerp`, `fract→frac`, `mod→fmod` (sign differs for negatives),
  `texture→tex2D`, `iTime→_Time.y`, `iResolution→_ScreenParams`, `fragCoord→i.uv * _ScreenParams.xy`, matrices `m*v→mul(m,v)`.
- Keep the baseline `..\RainCam_Recovered` untouched for A/B comparison against the exe.

## Where evidence lives
- Shader bytecode decompiles + cbuffer layouts: `..\..\RainCam_reverse\RecoveredShaderIntermediate\<shader>\`
- Raw decompiled C# (verbatim from Assembly-CSharp.dll): `..\..\RainCam_reverse\RecoveredProject\Assets\Scripts\`
- Scene/material values were dumped with UnityPy (pip `UnityPy`, needs `attrs>=22`) from `..\RainCam_GPU9\RainDropCam_CSParticle_Data`.
