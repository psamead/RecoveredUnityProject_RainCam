using UnityEngine;

public class MouseParticle : MonoBehaviour
{
	private Vector2 cursorPos;

	private Material material;

	private GameObject go;

	public GameObject interactor;

	private Vector3 worldPosition;

	private Vector3 moveDirection;

	public float moveSpeed = 5f;

	private Rigidbody rb;

	public RenderTexture rt;

	private void Start()
	{
		go = GameObject.Find("Cam");
		Renderer component = go.GetComponent<Renderer>();
		material = component.material;
		material.SetTexture("_SplatTex", rt);
		interactor = GameObject.Find("Interactor");
		rb = interactor.GetComponent<Rigidbody>();
	}

	private void Update()
	{
		moveDirection = Vector3.zero;
		Vector3 mousePosition = Input.mousePosition;
		mousePosition.z = Camera.main.nearClipPlane;
		worldPosition = Camera.main.ScreenToWorldPoint(mousePosition);
		moveDirection = new Vector3(worldPosition.normalized.x, worldPosition.normalized.y, 0f);
		RenderTexture temporary = RenderTexture.GetTemporary(rt.width, rt.height, 0, RenderTextureFormat.ARGBFloat);
		Graphics.Blit(rt, temporary);
		Graphics.Blit(temporary, rt);
	}

	private void FixedUpdate()
	{
		rb.velocity = moveDirection * moveSpeed;
	}

	private void OnGUI()
	{
	}
}
