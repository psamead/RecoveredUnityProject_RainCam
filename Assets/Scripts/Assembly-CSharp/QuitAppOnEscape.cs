using UnityEngine;

public class QuitAppOnEscape : MonoBehaviour
{
	[Tooltip("If true, Quit works in built apps outside editor too.")]
	public bool Standalone;

	private void Awake()
	{
	}

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			QuitGame();
		}
	}

	private void QuitGame()
	{
		Application.Quit();
	}
}
