# RainCam — faithful recovery (2026-11-02)

Source of truth: `..\RainCam_GPU9\RainDropCam_CSParticle.exe` (Unity 2020.3.15f2 player, built 2021-07-29).
Goal of this pass: reproduce the **shipped** look exactly, not improve it. The October recovery
(`Documents\UnityProject\RecoveredUnityProject_RainCam`) was used only as scaffolding
(ProjectSettings, textures, .meta GUIDs, scene); every value below was re-read from the exe.

Open with Unity 2020.3.x (project file says 2020.3.49f1; 2020.3.15f2 is the exact shipped version).
Scene: `Assets/RainDropCam/Scenes/RainDropCam.unity`.

## What was wrong in the October project (why it never looked like the exe)

| Area | October project | Shipped exe (now restored) |
|---|---|---|
| Rain shader `RainyWindow_V3-8_Cam_Mouse` | 122-line hand rewrite, invented haze/trail props, 5-tap dilation | Rebuilt line-by-line from bytecode: Art-of-Code rain, 4 layers, fwidth fade, 32-tap disc blur ×0.98, `lerp(blur, cam, splat.r)` |
| Particle shader colour | `(0.8, 0.95, 1, life*0.25)` | **`(1, 0, 0, life)`** — red; the splat RT's red channel is the "wipe" mask |
| `BBP_Quad.cs` | restores render target, reads unmirrored `Input.mousePosition` in Update | original: no RT restore, mirrored cursor from `OnGUI` (`pixelWidth - x`) to match mirrored webcam |
| `CameraStream.cs` | requests 1280×720@30, uses real aspect | original: default resolution; `_Ratio` = width/height read right after `Play()`. Corrected 2026-11-02: on Psamead's webcam this reports the real size at once (640×480 → **1.333**), so the exe ran with 1.333 there; the material's `_Ratio = 1` is only the fallback |
| `particleCount` | 250 | **500** (quadSize 0.2) |
| `CameraRT` object | active | **inactive** (only `RTC` camera clears/feeds the splat RT) |
| `RainyWindow_Cam.mat` | DropSize 0.25, Blur 1, Ratio 1.7, +5 invented props | DropSize **2**, Blur **0.83**, Ratio 1, Size 7.14, T 1, Distortion −4.5 |
| `RainyWindow.mat` (inactive Quad) | pointed at BG shader | points at `RainyWindow_V3` |

Unchanged / verified equal: compute shader `BBP_Quad.compute` (matches bytecode), ProjectSettings
(Gamma, 1024×768 fullscreen-window, Ultra, vSync 1, 2×MSAA), scene transforms/cameras/culling masks,
PTexSwap (Space toggles particle stamp particles-single/Ripple), QuitAppOnEscape.

## Only intentional deviation
`CameraStream` serialized `currentCamIndex = 1`. On a machine with a single webcam the original
throws `IndexOutOfRange`; a guard falls back to camera 0 **only** in that case.

## How the effect works (shipped)
Main Camera (ortho 0.5) renders the 1×1 `Cam` quad. `RTC` camera (layer 6 only) clears a 256² ARGBFloat RT
each frame; `BBP_Quad.OnRenderObject` draws 500 compute particles chasing the mirrored mouse into it in red.
The rain shader blurs + distorts the mirrored webcam, and wherever the RT is red shows the sharp camera.
Keys: `C` next webcam, `Space` swap particle stamp, `Esc` quit.

## Evidence locations
- cbuffer layout & bytecode decompile: `..\..\RainCam_reverse\RecoveredShaderIntermediate\CGShader2D3D_RainyWindow_V3-8_Cam_Mouse\`
- raw decompiled C#: `..\..\RainCam_reverse\RecoveredProject\Assets\Scripts\`
- original hand-written BBP base: `D:\UnityProject_present\UnityComputeShaders - learn\Assets\MyComputeShader\ParticleCS\BufferBased_Quad\`
- rain shader ancestor: `Documents\UnityProject\RainyWindow_blur\Assets\Shader\Window.shader`

## Update — V3 and BG shaders rewritten as readable source
All four shaders are now normal hand-readable CG (no machine IR left). The rain code comes from
Psamead's follow-alongs of BigWings / The Art of Code "Make it Rain" (Part 1 https://youtu.be/EBrAdahFtuo,
Part 2 https://youtu.be/0flY11lVCwY): `Documents\UnityProject\RainyWindow_droplet`, `_blur`, `_transparent`.
- `RainyWindow_V3` = `RainyWindow_transparent` Window.shader (GrabPass + 32-tap blur) plus, from the bytecode:
  `_DropSize`, trail edge `S(0.03,0.01)`, hash `546` (tutorial copy: 564), angle `6.2831`, output `×0.98` (tutorial: ×0.9), no `_MainTex`.
- `RainyWindow_V3-8_Cam_Mouse` = V3's rain with the webcam as source (mirrored, `/ _Ratio`) and `lerp(blur, cam, splat.r)`.
- `RainyWindow_BG` = plain unlit texture.

## Update — mouse / particle lineage
- `BBP_Quad` (compute + C# + draw shader) comes from the compute-shader course "QuadParticles" lesson:
  reference `Documents\UnityProject\UnityComputeShaders - complete\Assets\Scripts\QuadParticles.cs` + `Shaders\QuadParticles.compute`,
  practice copy `UnityComputeShaders - learn\...\ParticleCS\BufferBased_Quad\`. The practice copy's slips (`vu` typo in the
  Vertex struct, reordered structs) are cosmetic; the shipped compute was verified directly against the exe's bytecode.
  RainCam changes vs the course: respawn exactly at the cursor (no random sphere), z = 0 instead of 3, velocity step ×0.01,
  red particle colour, drawing into a 256² RT for `_SplatTex`, mirrored cursor.
- `Mouse.cs`, `Mouse_blur.cs`, `MouseCS.cs`, `MouseInterct.cs`, `MouseParticle.cs`, `RenderWithoutCamera.cs` are earlier
  trail experiments (red `_Position`/`_Radius`/`_EdgeSoftness` splat blits; `MouseCS` = ping-pong RT compute in the style of
  `CCA\Assets\Workshop`). They are compiled into the exe but not attached in the shipped scene; their draw/blur shaders and
  compute were not included in the build, so they can't be recovered from the exe. The leftover `_Radius`/`_EdgeSoftness`/
  `_Position` on the Cam material come from this stage.

## Update — full lineage (see also ..\RainCam_Lineage.xlsx)
1. BigWings / The Art of Code "Make it Rain" Pt1 https://youtu.be/EBrAdahFtuo, Pt2 https://youtu.be/0flY11lVCwY
   → RainyWindow_droplet / _blur / _transparent → RainyWindow_V3 → RainyWindow_V3-8_Cam_Mouse.
2. Peer Play "Snowtracks Shader Tutorial" https://youtube.com/playlist?list=PL3POsQzaCw53KM74XVRXv2xyesLjngfbG
   → red splat map + Blit brush (`Mouse`, `Mouse_blur`, `MouseInterct`; leftover name `fadeSnow`);
   the core idea `lerp(blurredRain, sharpCam, splat.r)` mirrors the snow shader's `lerp(snow, ground, splat.r)`.
3. Compute-shader course, QuadParticles lesson (UnityComputeShaders - complete / - learn) → `BBP_Quad` particles paint the splat RT.
4. CCA workshop Trail Agents (CCA\Assets\Workshop\02_TrailAgents) → ping-pong RT experiment `MouseCS`.
Mouse tracking first learned via raycast-to-UV (`TrackMouse` in Shaders-complete/-learn, CCA); RainCam switched to
`ScreenToWorldPoint` in `OnGUI`, mirrored in the final `BBP_Quad`.

## Improve — Snowtracks experiment scene (NOT part of the shipped exe)
This copy (and `RainCam_reverse2\RainCam_Recovered_Improve`) adds the missing pieces for the earlier mouse-trail experiments.
`RainCam_reverse2\RainCam_Recovered` stays the exe-faithful baseline.
- `Assets/Shader/Experiments/RainCam_DrawTracks.shader` — Peer Play Snowtracks-style brush (`_Color`, `_Position`, `_Radius`, `_EdgeSoftness`), mirrored to match the mirrored webcam. Used by Mouse / Mouse_blur / MouseCS.
- `Assets/Shader/Experiments/RainCam_BlurTracks.shader` — 2-pass blur with slow decay, for Mouse_blur.
- `Assets/Shader/Experiments/RainCam_TracksPhysics.compute` — kernels `FlashInput` / `PhysicsUpdate` (CCA-style diffuse + decay) for MouseCS. Works around the original MouseCS bug where the physics step overwrote the brush stamp.
- `Assets/Editor/RainCamExperimentSceneBuilder.cs` — menu **RainCam > Build Snowtracks Experiment Scene** creates `RainDropCam_Snowtracks.unity`
  (copy of the shipped scene, BBP_Quad off, Mouse on, Mouse_blur and MouseCS added but off). Enable exactly one of BBP_Quad / Mouse / Mouse_blur / MouseCS on `Cam`.
Scripts are unchanged from the exe. Note: Mouse.cs's original `fadeSnow` resets the whole splat every `fillTime` (1 s); untick `fadeSnow` for persistent wipes.
