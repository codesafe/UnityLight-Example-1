using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObj : MonoBehaviour
{
    float r = 0;

    // Update is called once per frame
    void Update()
    {
        r += Time.deltaTime * 50;
        transform.eulerAngles = new Vector3(0,r,0);
    }
}
