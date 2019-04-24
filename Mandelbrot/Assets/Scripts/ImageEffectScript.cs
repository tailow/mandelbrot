using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ImageEffectScript : MonoBehaviour
{
    public Material material;

    public float speed;
    public float startDepth;
    public float endDepth;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }

    void Update()
    {
        material.SetFloat("_Zoom", (startDepth - endDepth) / 2 * (Mathf.Sin(Time.time * speed / 10)) + (startDepth + endDepth) / 2);
    }
}
