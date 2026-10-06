using UnityEngine;

public class PTexSwap : MonoBehaviour
{
	public Texture2D[] PImages;

	public Material PMat;

	private int index;

	private void NextClicked()
	{
		if (Input.GetKeyDown(KeyCode.Space))
		{
			index++;
			int num = index % 2;
			PMat.SetTexture("_MainTex", PImages[num]);
		}
	}

	private void Start()
	{
		if (PImages.Length != 0)
		{
			PMat.SetTexture("_MainTex", PImages[index]);
		}
	}

	private void Update()
	{
		NextClicked();
	}
}
