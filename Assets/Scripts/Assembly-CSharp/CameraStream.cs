using UnityEngine;

public class CameraStream : MonoBehaviour
{
	public int currentCamIndex;

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
			// Recovery note: the shipped scene serializes currentCamIndex = 1. On a machine with a single
			// webcam the original threw IndexOutOfRange here; fall back to camera 0 only in that case.
			if (currentCamIndex >= devices.Length) currentCamIndex = 0;
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
			Debug.Log("No Camera Detected");
		}
	}

	private void Start()
	{
		GetComponent<Renderer>().material.SetTexture("_MainTex", CurrentCam);
		GetComponent<Renderer>().material.SetFloat("_Ratio", ratio);
	}

	private void InitCam(int index)
	{
		currentDevice = devices[index];
		CurrentCam = new WebCamTexture(currentDevice.name);
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
			if (devices.Length != 0)
			{
				currentCamIndex++;
				int index = currentCamIndex % 2;
				if (index >= devices.Length) index = 0; // recovery guard, see OnEnable
				InitCam(index);
				GetComponent<Renderer>().material.SetTexture("_MainTex", CurrentCam);
			}
		}
	}

	private void Update()
	{
		NextCam();
	}
}
