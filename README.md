# RecoveredUnityProject_RainCam

RainCam is a webcam "rainy window": the live camera is shown through procedural rain and fog, and
moving the mouse wipes the glass clear with GPU particles. The original Unity project was lost to an
SSD failure; only the published exe survived. This is the recovered project, rebuilt value-for-value
from that exe.

## Versions
- **`main` (this page) - final recovery (Nov 2026).** Scene, materials and scripts match the shipped
  build; shaders rebuilt from its bytecode. Includes optional Snowtracks experiment tools.
- **[`october-attempt`](../../tree/october-attempt)** - first AI-assisted attempt (Oct 2026). Rewrote shaders
  and changed values, so it does not match the exe. Kept for comparison.

To download a version: pick it in the branch dropdown, then **Code  Download ZIP**.

## Open it
Unity 2020.3.x (project 2020.3.49f1; shipped exe was 2020.3.15f2)  open
`Assets/RainDropCam/Scenes/RainDropCam.unity`  Play and allow webcam access.
Keys: `C` next webcam, `Space` swap particle stamp, `Esc` quit.
Optional: menu **RainCam > Build Snowtracks Experiment Scene** for the earlier mouse-trail experiments.

## Built on these tutorials
- The Art of Code (BigWings) - "Make it Rain" [Part 1](https://youtu.be/EBrAdahFtuo), [Part 2](https://youtu.be/0flY11lVCwY)
- Peer Play - [Snowtracks Shader Tutorial](https://youtube.com/playlist?list=PL3POsQzaCw53KM74XVRXv2xyesLjngfbG)
- Compute-shader course QuadParticles lesson; CCA trail-agents workshop

Details: `RECOVERY_NOTES.md` (every recovered value and its source) and `HANDOFF.md`.
