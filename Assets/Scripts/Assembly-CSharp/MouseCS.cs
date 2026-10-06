using UnityEngine;

public class MouseCS : MonoBehaviour
{
	private Vector2 cursorPos;

	private Material material;

	private GameObject go;

	public RenderTexture[] splatmap = new RenderTexture[2];

	private Material drawMaterial;

	public Shader drawShader;

	private Texture2D clearTexture;

	public ComputeShader calculationEngine;

	private int textureIndex;

	private int physicsSimulationId;

	public Texture getTexture => splatmap[textureIndex];

	public Texture getBuffer => splatmap[(textureIndex + 1) % 2];

	private void Start()
	{
		go = GameObject.Find("Cam");
		Renderer component = go.GetComponent<Renderer>();
		material = component.material;
		drawMaterial = new Material(drawShader);
		drawMaterial.SetVector("_Color", Color.red);
		physicsSimulationId = calculationEngine.FindKernel("PhysicsUpdate");
		int kernelIndex = calculationEngine.FindKernel("FlashInput");
		for (int i = 0; i < splatmap.Length; i++)
		{
			splatmap[i] = new RenderTexture(800, 600, 0, RenderTextureFormat.ARGBFloat);
			splatmap[i].wrapMode = TextureWrapMode.Repeat;
			splatmap[i].filterMode = FilterMode.Point;
			splatmap[i].enableRandomWrite = true;
			splatmap[i].Create();
		}
		clearTexture = new Texture2D(800, 600, TextureFormat.Alpha8, mipChain: false);
		clearTexture.SetPixel(0, 0, new Color(0f, 0f, 0f, 0.05f));
		clearTexture.Apply();
		calculationEngine.SetTexture(kernelIndex, "Input", clearTexture);
		calculationEngine.SetTexture(kernelIndex, "PreviousState", getTexture);
		calculationEngine.SetTexture(kernelIndex, "Result", getBuffer);
		calculationEngine.Dispatch(kernelIndex, getTexture.width / 8, getTexture.height / 8, 1);
		calculationEngine.SetFloat("Width", getTexture.width);
		calculationEngine.SetFloat("Height", getTexture.height);
		calculationEngine.SetTexture(physicsSimulationId, "Input", clearTexture);
	}

	private void Update()
	{
		Vector4 value = new Vector4(cursorPos.x, cursorPos.y, 0f, 0f);
		drawMaterial.SetVector("_Position", value);
		RenderTexture temporary = RenderTexture.GetTemporary(getTexture.width, getTexture.height, 0, RenderTextureFormat.ARGBFloat);
		Graphics.Blit(getTexture, temporary);
		Graphics.Blit(temporary, (RenderTexture)getTexture, drawMaterial);
		RenderTexture.ReleaseTemporary(temporary);
	}

	private void FixedUpdate()
	{
		calculationEngine.SetFloat("ElapsedTime", Time.fixedDeltaTime);
		calculationEngine.SetTexture(physicsSimulationId, "PreviousState", getBuffer);
		calculationEngine.SetTexture(physicsSimulationId, "Result", getTexture);
		calculationEngine.Dispatch(physicsSimulationId, getTexture.width / 8, getTexture.height / 8, 1);
		material.SetTexture("_SplatTex", getTexture);
		textureIndex = (textureIndex + 1) % 2;
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
		GUI.DrawTexture(new Rect(0f, 0f, 256f, 256f), getTexture, ScaleMode.ScaleToFit, alphaBlend: false, 1f);
	}
}
