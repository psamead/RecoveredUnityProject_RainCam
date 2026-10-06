# RainCam Unity recovery notes

Recovered from the Windows player in `RainCam_GPU9`.

## Project version

- Unity editor version recorded by the player: `2020.3.15f2`
- Scripting backend: Mono
- Original managed assembly: `RainDropCam_CSParticle_Data/Managed/Assembly-CSharp.dll`

## C# recovery

The 11 first-party scripts are in `Assets/Scripts/Assembly-CSharp`.

They were decompiled from the Mono assembly with ILSpy. Method bodies, fields,
attributes, and type names are present. Original comments, source formatting,
some local-variable names, and any code removed by the compiler cannot be
recovered from the executable.

## Shader recovery

The active recovered shaders are in `Assets/Shader`. The existing `.meta`
files were retained so recovered materials continue to reference the same
shader GUIDs.

The three rain shaders were reconstructed from the shipped Direct3D 11 DXBC
programs. Their vertex/pixel signatures were recompiled and matched against
the shipped bytecode. The code is a machine reconstruction: it preserves the
compiled operations but not the original helper function names, comments, or
formatting.

`Assets/Shader/MyCSShader_BBP_Quad.shader` is a cleaned reconstruction of the
procedural particle draw shader, based on the shipped vertex/pixel bytecode
and the recovered `BBP_Quad.cs` buffer layout.

`Assets/ComputeShader/BBP_Quad.compute` is a cleaned reconstruction of the
`CSParticle` compute kernel. Its thread-group size, constant layout, buffer
layout, particle update math, reset behavior, and six generated quad vertices
were recovered from DXBC and cross-checked against `BBP_Quad.cs`.

Raw decompiler output, DXBC, and the original serialized compute asset are
preserved under `RecoveredSources` for auditing.

## Validation completed

- The decompiled C# project builds with 0 errors against the player DLLs.
- The shader decompiler's parser specification tests passed.
- All four recovered vertex/pixel shader passes compile and match the input
  and output signatures shipped in the player.
- The cleaned compute shader compiles as shader model 5.0 with `fxc`.

This is a source recovery, not a byte-for-byte restoration of the lost Unity
project. Open a copy with Unity `2020.3.15f2`, allow it to import, then inspect
the Console and scene behavior before making this your new primary project.
