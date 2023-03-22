``` cs

using (var editingScope = new PrefabUtility.EditPrefabContentsScope(assetPath))
{
    var prefabRoot = editingScope.prefabContentsRoot;

    // Removing GameObjects is supported
    Object.DestroyImmediate(prefabRoot.transform.GetChild(2).gameObject);

    // Reordering and reparenting are supported
    prefabRoot.transform.GetChild(1).parent = prefabRoot.transform.GetChild(0);

    // Adding GameObjects is supported
    var cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
    cube.transform.parent = prefabRoot.transform;
    cube.name = "D";

    // Adding and removing components are supported
    prefabRoot.AddComponent<AudioSource>();
}

public static GameObject ConnectPrefab(string parentAssetPath, string childAssetPath, string hierarchyPath = null)
{
    var root = PrefabUtility.LoadPrefabContents(parentAssetPath);
    var parent = hierarchyPath == null ? root.transform : root.transform.Find(hierarchyPath);
    var newObj = (GameObject)PrefabUtility.InstantiatePrefab((GameObject)AssetDatabase.LoadMainAssetAtPath(childAssetPath));
    newObj.transform.parent = parent;
    PrefabUtility.RecordPrefabInstancePropertyModifications(newObj.transform);
    PrefabUtility.SaveAsPrefabAsset(root, parentAssetPath);
    PrefabUtility.UnloadPrefabContents(root);
    return newObj;
}

var rootObj = PrefabUtility.LoadPrefabContents(assetPath);
var walls = rootObj.transform.Find("---");
for (var j = walls.childCount - 1; j >= 0; j--)
{
    var child = walls.GetChild(j);
    var outerMost = PrefabUtility.GetOutermostPrefabInstanceRoot(child); // Get prefab
    var prefabPath = PrefabUtility.GetPrefabAssetPathOfNearestInstanceRoot(outerMost);
    if (prefabPath == "---")
    {
        Object.DestroyImmediate(child.gameObject);
    }
}

PrefabUtility.SaveAsPrefabAsset(rootObj, assetPath);
PrefabUtility.UnloadPrefabContents(rootObj);
```
