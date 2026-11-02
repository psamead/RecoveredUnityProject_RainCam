// Builds RainDropCam_Snowtracks.unity: a copy of the shipped scene with BBP_Quad switched off and the
// earlier mouse-trail experiments (Mouse, Mouse_blur, MouseCS) attached to "Cam" with their rebuilt
// shaders. The shipped scene RainDropCam.unity is never modified.
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class RainCamExperimentSceneBuilder
{
    const string SourceScene = "Assets/RainDropCam/Scenes/RainDropCam.unity";
    const string TargetScene = "Assets/RainDropCam/Scenes/RainDropCam_Snowtracks.unity";
    const string ShaderDir = "Assets/Shader/Experiments/";

    [MenuItem("RainCam/Build Snowtracks Experiment Scene")]
    public static void Build()
    {
        if (!EditorSceneManager.SaveCurrentModifiedScenesIfUserWantsTo()) return;

        Shader draw = AssetDatabase.LoadAssetAtPath<Shader>(ShaderDir + "RainCam_DrawTracks.shader");
        Shader blur = AssetDatabase.LoadAssetAtPath<Shader>(ShaderDir + "RainCam_BlurTracks.shader");
        ComputeShader physics = AssetDatabase.LoadAssetAtPath<ComputeShader>(ShaderDir + "RainCam_TracksPhysics.compute");
        if (draw == null || blur == null || physics == null)
        {
            Debug.LogError("RainCam: experiment shaders not found in " + ShaderDir);
            return;
        }

        if (AssetDatabase.LoadAssetAtPath<SceneAsset>(TargetScene) != null)
            AssetDatabase.DeleteAsset(TargetScene);
        if (!AssetDatabase.CopyAsset(SourceScene, TargetScene))
        {
            Debug.LogError("RainCam: could not copy " + SourceScene);
            return;
        }

        var scene = EditorSceneManager.OpenScene(TargetScene, OpenSceneMode.Single);
        GameObject cam = GameObject.Find("Cam");
        if (cam == null)
        {
            Debug.LogError("RainCam: no 'Cam' object in the scene");
            return;
        }

        BBP_Quad bbp = cam.GetComponent<BBP_Quad>();
        if (bbp != null) bbp.enabled = false;

        Mouse mouse = cam.GetComponent<Mouse>();
        if (mouse == null) mouse = cam.AddComponent<Mouse>();
        mouse.drawShader = draw;
        mouse.enabled = true;

        Mouse_blur mouseBlur = cam.GetComponent<Mouse_blur>();
        if (mouseBlur == null) mouseBlur = cam.AddComponent<Mouse_blur>();
        mouseBlur.drawShader = draw;
        mouseBlur.blurShader = blur;
        mouseBlur.enabled = false;

        MouseCS mouseCS = cam.GetComponent<MouseCS>();
        if (mouseCS == null) mouseCS = cam.AddComponent<MouseCS>();
        mouseCS.drawShader = draw;
        mouseCS.calculationEngine = physics;
        mouseCS.enabled = false;

        EditorSceneManager.MarkSceneDirty(scene);
        EditorSceneManager.SaveScene(scene);
        Debug.Log("RainCam: built " + TargetScene + " - enable exactly one of BBP_Quad / Mouse / Mouse_blur / MouseCS on 'Cam' before Play.");
    }
}
