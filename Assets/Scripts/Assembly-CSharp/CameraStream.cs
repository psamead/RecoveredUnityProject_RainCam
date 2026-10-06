using UnityEngine;

public class CameraStream : MonoBehaviour
{
	public int currentCamIndex;

	public int requestedWidth = 1280;

	public int requestedHeight = 720;

	public int requestedFPS = 30;

	private static WebCamTexture CurrentCam;

	private WebCamDevice[] devices;

	private WebCamDevice currentDevice;

	private float ratio;

	private float width;

	private float height;

	private void OnEnable()
	{
		devices = WebCamTexture.devices;
		if (devices != null && devices.Length > 0)
		{
			currentCamIndex = ((currentCamIndex % devices.Length) + devices.Length) % devices.Length;
			InitCam(currentCamIndex);
			width = CurrentCam.width;
			height = CurrentCam.height;
			ratio = width / height;
			Debug.Log(width);
			Debug.Log(height);
			Debug.Log(ratio);
		}
		else
		{
			Debug.LogWarning("No camera devices detected");
		}
	}

	private void Start()
	{
		Material material = GetComponent<Renderer>().material;
		material.SetTexture("_MainTex", CurrentCam);
		material.SetFloat("_Ratio", ratio);
		material.SetFloat("_PlaneAspect", transform.lossyScale.x / Mathf.Max(transform.lossyScale.y, 0.0001f));
	}

	private void InitCam(int index)
	{
		currentDevice = devices[index];
		CurrentCam = new WebCamTexture(currentDevice.name, requestedWidth, requestedHeight, requestedFPS);
		CurrentCam.Play();
	}

	private void NextCam()
	{
		if (Input.GetKeyDown(KeyCode.C))
		{
			if (CurrentCam != null)
			{
				CurrentCam.Stop();
				CurrentCam = null;
			}
			if (devices != null && devices.Length > 0)
			{
				currentCamIndex = (currentCamIndex + 1) % devices.Length;
				InitCam(currentCamIndex);
				Material material = GetComponent<Renderer>().material;
				material.SetTexture("_MainTex", CurrentCam);
				material.SetFloat("_Ratio", ratio);
			}
		}
	}

	private void Update()
	{
		NextCam();
	}
}
