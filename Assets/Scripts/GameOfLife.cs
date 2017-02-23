using UnityEngine;

public class GameOfLife : MonoBehaviour {

	[SerializeField] int TextureWidth  = 100;
	[SerializeField] int TextureHeight = 100;
	[SerializeField] Material GameOfLifeMaterial;

	MeshRenderer meshRenderer;
	RenderTexture[] renderTargets;
	int src = 0;
	int dst = 1;

	// Use this for initialization
	void Start ()
	{
		renderTargets = new []
		{
			new RenderTexture(TextureWidth, TextureHeight, 0),
			new RenderTexture(TextureWidth, TextureHeight, 0)
		};

		foreach (var rt in renderTargets)
		{
			// rt.antiAliasing = 1;
			rt.wrapMode = TextureWrapMode.Repeat;
			rt.filterMode = FilterMode.Point;
		}

		Graphics.Blit(null, renderTargets[0], GameOfLifeMaterial, 0);

		GameOfLifeMaterial.mainTexture = renderTargets[0];
		meshRenderer = GetComponent<MeshRenderer>();
		meshRenderer.sharedMaterial = GameOfLifeMaterial;
	}
	
	// Update is called once per frame
	void Update ()
	{
		Graphics.Blit(renderTargets[src], renderTargets[dst], GameOfLifeMaterial, 1);
		Swap(ref dst, ref src);
	}

	void Swap<T>(ref T lhs, ref T rhs)
	{
		T tmp = lhs;
		lhs = rhs;
		rhs = tmp;
	}

	void OnDestroy()
	{
		foreach (var rt in renderTargets)
		{
			rt.Release();
		}
	}
}
