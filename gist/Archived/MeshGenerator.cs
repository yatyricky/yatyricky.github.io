using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshGenerator : MonoBehaviour
{
    public Material WallMat;
    private int Height = 5;
    private int Width = 5;
    public int[,] Markers = new int[,]
        {
            { 0,1,1,1,0 },
            { 1,1,1,1,1 },
            { 1,1,1,1,1 },
            { 1,1,1,1,1 },
            { 0,1,1,1,0 },
        };

    // Start is called before the first frame update
    void Start()
    {
        var vertsMap = new List<Vector3>();
        var uvMap = new List<Vector2>();
        var trigs = new List<int>();
        void addVert(int x, int y, int z, int u, int v)
        {
            vertsMap.Add(new Vector3(x, y, z));
            uvMap.Add(new Vector2(u, v));
        }
        for (int h = 0; h < Height; h++)
        {
            for (int w = 0; w < Width; w++)
            {
                if (Markers[h, w] == 0)
                {
                    continue;
                }
                var idx = vertsMap.Count;
                addVert(w, 0, h, 0, 0);
                addVert(w + 1, 0, h, 1, 0);
                addVert(w, 0, h + 1, 0, 1);
                addVert(w + 1, 0, h + 1, 1, 1);
                trigs.Add(idx);
                trigs.Add(idx + 2);
                trigs.Add(idx + 3);
                trigs.Add(idx + 3);
                trigs.Add(idx + 1);
                trigs.Add(idx);

                if (h == 0 || Markers[h - 1, w] == 0)
                {
                    idx = vertsMap.Count;
                    addVert(w, -1, h, 0, 0);
                    addVert(w + 1, -1, h, 1, 0);
                    addVert(w, 0, h, 0, 1);
                    addVert(w + 1, 0, h, 1, 1);
                    trigs.Add(idx);
                    trigs.Add(idx + 2);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 1);
                    trigs.Add(idx);
                }

                if (h == Height - 1 || Markers[h + 1, w] == 0)
                {
                    idx = vertsMap.Count;
                    addVert(w    , -1, h + 1, 0, 0);
                    addVert(w + 1, -1, h + 1, 1, 0);
                    addVert(w    , 0 , h + 1, 0, 1);
                    addVert(w + 1, 0 , h + 1, 1, 1);
                    trigs.Add(idx);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 2);
                    trigs.Add(idx + 3);
                    trigs.Add(idx);
                    trigs.Add(idx + 1);
                }

                if (w == 0 || Markers[h, w - 1] == 0)
                {
                    idx = vertsMap.Count;
                    addVert(w, -1, h + 1, 0, 0);
                    addVert(w, -1, h, 1, 0);
                    addVert(w, 0, h + 1, 0, 1);
                    addVert(w, 0, h, 1, 1);
                    trigs.Add(idx);
                    trigs.Add(idx + 2);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 1);
                    trigs.Add(idx);
                }

                if (w == Width - 1 || Markers[h, w + 1] == 0)
                {
                    idx = vertsMap.Count;
                    addVert(w + 1, -1, h, 0, 0);
                    addVert(w + 1, -1, h + 1, 1, 0);
                    addVert(w + 1, 0 , h, 0, 1);
                    addVert(w + 1, 0 , h + 1, 1, 1);
                    trigs.Add(idx);
                    trigs.Add(idx + 2);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 3);
                    trigs.Add(idx + 1);
                    trigs.Add(idx);
                }
            }
        }

        var mesh = new Mesh();
        mesh.vertices = vertsMap.ToArray();
        mesh.uv = uvMap.ToArray();
        mesh.triangles = trigs.ToArray();

        var go = new GameObject("mesh", typeof(MeshFilter), typeof(MeshRenderer));
        go.transform.localPosition = new Vector3(0, 1, 0);

        go.GetComponent<MeshFilter>().mesh = mesh;
        go.GetComponent<MeshRenderer>().material = WallMat;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
