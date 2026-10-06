using UnityEngine;

public class BBP_Quad : MonoBehaviour
{
	private struct Particle
	{
		public Vector3 position;

		public Vector3 velocity;

		public float life;
	}

	private struct Vertex
	{
		public Vector3 position;

		public Vector2 uv;

		public float life;
	}

	private Vector2 cursorPos;

	private const int SIZE_PARTICLE = 28;

	private const int SIZE_VERTEX = 24;

	public int particleCount = 250;

	public Material material;

	public ComputeShader shader;

	[Range(0.01f, 2f)]
	public float quadSize = 0.1f;

	private int numParticles;

	private int numVerticesInMesh;

	private int kernelID;

	private ComputeBuffer particleBuffer;

	private ComputeBuffer vertexBuffer;

	private int groupSizeX;

	private GameObject go;

	private Material streamMat;

	private readonly float[] mousePositionValues = new float[2];

	public Camera camRT;

	private RenderTexture testRT;

	public bool DebugMode;

	private void OnEnable()
	{
		testRT = new RenderTexture(256, 256, 0, RenderTextureFormat.ARGBFloat);
		testRT.Create();
		camRT.targetTexture = testRT;
	}

	private void Start()
	{
		go = GameObject.Find("Cam");
		Renderer component = go.GetComponent<Renderer>();
		streamMat = component.material;
		streamMat.SetTexture("_SplatTex", testRT);
		Init();
	}

	private void Init()
	{
		kernelID = shader.FindKernel("CSParticle");
		shader.GetKernelThreadGroupSizes(kernelID, out var x, out var _, out var _);
		groupSizeX = Mathf.CeilToInt((float)particleCount / (float)x);
		numParticles = groupSizeX * (int)x;
		Particle[] array = new Particle[numParticles];
		int num = numParticles * 6;
		Vertex[] array2 = new Vertex[num];
		Vector3 vector = default;
		for (int i = 0; i < numParticles; i++)
		{
			vector.Set(Random.value * 2f - 1.5f, Random.value * 2f - 1.5f, 0f);
			vector.Normalize();
			vector *= Random.value * 0.5f;
			array[i].position.Set(vector.x, vector.y, 0f);
			array[i].velocity.Set(0f, 0f, 0f);
			array[i].life = Random.value * 5f + 1f;
			int num2 = i * 6;
			array2[num2].uv.Set(0f, 0f);
			array2[num2 + 1].uv.Set(0f, 1f);
			array2[num2 + 2].uv.Set(1f, 1f);
			array2[num2 + 3].uv.Set(0f, 0f);
			array2[num2 + 4].uv.Set(1f, 1f);
			array2[num2 + 5].uv.Set(1f, 0f);
		}
		particleBuffer = new ComputeBuffer(numParticles, 28);
		particleBuffer.SetData(array);
		vertexBuffer = new ComputeBuffer(num, 24);
		vertexBuffer.SetData(array2);
		shader.SetBuffer(kernelID, "particleBuffer", particleBuffer);
		shader.SetBuffer(kernelID, "vertexBuffer", vertexBuffer);
		shader.SetFloat("halfSize", quadSize * 0.5f);
		material.SetBuffer("vertexBuffer", vertexBuffer);
	}

	private void OnRenderObject()
	{
		RenderTexture previous = RenderTexture.active;
		if (!DebugMode)
		{
			Graphics.SetRenderTarget(testRT);
		}
		material.SetPass(0);
		Graphics.DrawProceduralNow(MeshTopology.Triangles, 6, numParticles);
		RenderTexture.active = previous;
	}

	private void OnDestroy()
	{
		if (particleBuffer != null)
		{
			particleBuffer.Release();
			particleBuffer = null;
		}
		if (vertexBuffer != null)
		{
			vertexBuffer.Release();
			vertexBuffer = null;
		}
		if (testRT != null)
		{
			testRT.Release();
			testRT = null;
		}
	}

	private void Update()
	{
		Camera main = Camera.main;
		if (main != null)
		{
			Vector3 screen = Input.mousePosition;
			screen.z = Mathf.Abs(main.transform.position.z - transform.position.z);
			Vector3 world = main.ScreenToWorldPoint(screen);
			cursorPos.Set(world.x, world.y);
		}
		mousePositionValues[0] = cursorPos.x;
		mousePositionValues[1] = cursorPos.y;
		shader.SetFloat("deltaTime", Time.deltaTime);
		shader.SetFloats("mousePosition", mousePositionValues);
		shader.Dispatch(kernelID, groupSizeX, 1, 1);
	}

	private void OnGUI()
	{
		Vector3 vector = default;
		Camera main = Camera.main;
		Event current = Event.current;
		Vector2 vector2 = new Vector2
		{
			x = (float)main.pixelWidth - current.mousePosition.x,
			y = (float)main.pixelHeight - current.mousePosition.y
		};
		vector = main.ScreenToWorldPoint(new Vector3(vector2.x, vector2.y, main.nearClipPlane));
		cursorPos.x = vector.x;
		cursorPos.y = vector.y;
	}
}
