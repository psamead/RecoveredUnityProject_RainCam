using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class RenderWithoutCamera : MonoBehaviour
{
	public float val;

	private RenderTexture rt;

	public GameObject go;

	public GameObject part;

	private Camera camera;

	private CommandBuffer cb;

	private Mesh bakedMesh;

	private void OnEnable()
	{
		RenderTextureFormat format = RenderTextureFormat.Default;
		rt = new RenderTexture(300, 300, 0, format);
		rt.name = "TVE Colors Tex";
		cb = new CommandBuffer();
		cb.name = "The Vegetatioon Engine Motion";
		cb.ClearRenderTarget(clearDepth: true, clearColor: true, Color.blue);
		cb.DrawRenderer(go.GetComponent<Renderer>(), go.GetComponent<Renderer>().sharedMaterial, 0, 0);
		bakedMesh = new Mesh();
		cb.DrawMesh(bakedMesh, Matrix4x4.identity, part.GetComponent<Renderer>().sharedMaterial);
		Shader.SetGlobalTexture("_GlowMap", rt);
	}

	private void LateUpdate()
	{
		part.GetComponent<ParticleSystemRenderer>().BakeMesh(bakedMesh, useTransform: true);
		Graphics.SetRenderTarget(rt);
		GL.LoadProjectionMatrix(GL.GetGPUProjectionMatrix(Matrix4x4.Ortho(-10f, 10f, -10f, 10f, -10000f, 10000f), renderIntoTexture: true));
		GL.modelview = new Matrix4x4(new Vector4(1f, 0f, 0f, 0f), new Vector4(0f, 0f, -1f, 0f), new Vector4(0f, -1f, 0f, 0f), new Vector4(0f, 0f, 0f, 1f));
		Graphics.ExecuteCommandBuffer(cb);
	}
}
