using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class BeatDetection : MonoBehaviour
{
    public float[] samples;
    public float max = float.NegativeInfinity;
    public float min = float.PositiveInfinity;

    private AudioSource _audioSource;

    // Start is called before the first frame update
    void Start()
    {
        samples = new float[1024];
        _audioSource = GetComponent<AudioSource>();
        var trs = transform;
        for (int i = 0; i < 1024; i++)
        {
            var obj = GameObject.CreatePrimitive(PrimitiveType.Cube);
            obj.transform.SetParent(trs);
        }
    }

    // Update is called once per frame
    void Update()
    {
        var trs = transform;
        _audioSource.GetOutputData(samples, 0);
        max = Mathf.Max(samples.Max(), max);
        min = Mathf.Min(samples.Min(), min);
        for (int i = 0; i < 1024; i++)
        {
            var s = samples[i];
            var x = (float) i; // i % 32;
            var y = 0f; //i / 32;
            var obj = trs.GetChild(i);
            var h = (1f - (s + 1) / 2f) * 500f;
            obj.localScale = new Vector3(1, h, 1);
            obj.localPosition = new Vector3(x, h / 2, y);
        }
    }
}
