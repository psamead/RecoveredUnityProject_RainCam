using UnityEngine;

public class MouseInterct : MonoBehaviour
{
	private Vector2 cursorPos;

	private Material material;

	private GameObject go;

	private void Start()
	{
		go = GameObject.Find("Cam");
		Renderer component = go.GetComponent<Renderer>();
		material = component.material;
	}

	private void Update()
	{
		Vector4 value = new Vector4(cursorPos.x, cursorPos.y, 0f, 0f);
		material.SetVector("_Position", value);
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
	}
}
