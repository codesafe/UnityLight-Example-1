using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraDepthOn : MonoBehaviour
{
    void OnEnable()
    {
        Camera pCamera = GetComponent<Camera>();
        if (pCamera == null) return;
        Debug.Log("Depth On");
        pCamera.depthTextureMode = DepthTextureMode.DepthNormals;

    }

    void OnDisable()
    {
        Camera pCamera = GetComponent<Camera>();
        if (pCamera == null) return;
        Debug.Log("Depth Off");
        pCamera.depthTextureMode = DepthTextureMode.None;
    }
}