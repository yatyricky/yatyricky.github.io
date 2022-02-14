1. New RenderTexture, new Camera. Camera render target set to render texture
2. Render
3. Read pixels from render texture
4. Release render texture

``` c#
public static Texture2D TakePhoto(GameObject go)
{
    // get camera
    var camObj = GameObject.Find("TakePhotoCamera");
    if (camObj == null)
        camObj = new GameObject("TakePhotoCamera");

    var cam = camObj.GetComponent<Camera>();

    // map object
    var inst = UnityEngine.Object.Instantiate(go, cam.transform);
    const int width = 256;
    const int height = 256;
    inst.transform.position = new Vector3(0f, -0.639f, 1.924f);
    inst.transform.rotation = Quaternion.Euler(new Vector3(17.41f, 146.662f, -10.781f));

    var renderTarget = RenderTexture.GetTemporary(width, height, 24);
    cam.targetTexture = renderTarget;
    cam.clearFlags = CameraClearFlags.Color;
    cam.backgroundColor = new Color(0.192f, 0.302f, 0.475f);
    cam.Render();

    // generate texture
    var previouslyActiveRenderTexture = RenderTexture.active;
    RenderTexture.active = renderTarget;
    var tex = new Texture2D(renderTarget.width, renderTarget.height);
    tex.ReadPixels(new Rect(0, 0, renderTarget.width, renderTarget.height), 0, 0);
    tex.Apply();

    // clean up
    RenderTexture.active = previouslyActiveRenderTexture;
    cam.targetTexture = null;
    RenderTexture.ReleaseTemporary(renderTarget);
    UnityEngine.Object.DestroyImmediate(camObj);

    return tex;
}
```
