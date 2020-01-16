Batched grab pass.

https://docs.unity3d.com/Manual/SL-GrabPass.html

``` cpp
GrabPass
{
    "_BackgroundTexture" // Define GrabPass
}

Pass
{
    sampler2D _BackgroundTexture; // Declare the grabbed texture in next Pass

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float4 grabpos : TEXCOORD1; // added to v2f
    }

    v2f vert(appdata_t v)
    {
        v2f o;
        // use UnityObjectToClipPos from UnityCG.cginc to calculate 
        // the clip-space of the vertex
        o.vertex = UnityObjectToClipPos(v.vertex);
        // use ComputeGrabScreenPos function from UnityCG.cginc
        // to get the correct texture coordinate
        o.grabpos = ComputeGrabScreenPos(o.vertex); 
        return o;
    }

    fixed4 frag(v2f i) : SV_Target
    {
        half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabpos);
        return bgcolor * 2;
    }
}
```
