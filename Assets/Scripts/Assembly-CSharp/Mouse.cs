using UnityEngine;

public class Mouse : MonoBehaviour
{
	private Vector2 cursorPos;

	private Material material;

	private GameObject go;

	private RenderTexture splatmap;

	private Material drawMaterial;

	public Shader drawShader;

	public bool fadeSnow = true;

	public float fillTime = 1f;

	private float timer;

	private Texture2D clearTexture;

	private void Start()
	{
		go = GameObject.Find("Cam");
		Renderer component = go.GetComponent<Renderer>();
		material = component.material;
		drawMaterial = new Material(drawShader);
		drawMaterial.SetVector("_Color", Color.red);
		splatmap = new RenderTexture(800, 600, 0, RenderTextureFormat.ARGBFloat);
		splatmap.Create();
		material.SetTexture("_SplatTex", splatmap);
		clearTexture = new Texture2D(splatmap.width, splatmap.height, TextureFormat.Alpha8, mipChain: false);
		clearTexture.SetPixel(0, 0, new Color(0f, 0f, 0f, 0.05f));
		clearTexture.Apply();
	}

	private void Update()
	{
		Vector4 value = new Vector4(cursorPos.x, cursorPos.y, 0f, 0f);
		drawMaterial.SetVector("_Position", value);
		RenderTexture temporary = RenderTexture.GetTemporary(splatmap.width, splatmap.height, 0, RenderTextureFormat.ARGBFloat);
		Graphics.Blit(splatmap, temporary);
		Graphics.Blit(temporary, splatmap, drawMaterial);
		RenderTexture temporary2 = RenderTexture.GetTemporary(splatmap.width, splatmap.height, 0, RenderTextureFormat.ARGBFloat);
		if (fadeSnow && Time.time > timer)
		{
			timer = Time.time + fillTime;
			Graphics.Blit(clearTexture, temporary2);
			Graphics.Blit(temporary2, splatmap, drawMaterial);
		}
		RenderTexture.ReleaseTemporary(temporary);
		RenderTexture.ReleaseTemporary(temporary2);
	}

	private void OnGUI()
	{
		Vector3 vector = default;
		Camera main = Camera.main;
		Event current = Event.current;
		Vector2 vector2 = new Vector2
		{
			x = current.mousePosition.x,
			y = (float)main.pixelHeight - current.mousePosition.y
		};
		vector = main.ScreenToWorldPoint(new Vector3(vector2.x, vector2.y, main.nearClipPlane + 1f));
		cursorPos.x = vector.x;
		cursorPos.y = vector.y;
		GUI.DrawTexture(new Rect(0f, 0f, 256f, 256f), splatmap, ScaleMode.ScaleToFit, alphaBlend: false, 1f);
	}
}
