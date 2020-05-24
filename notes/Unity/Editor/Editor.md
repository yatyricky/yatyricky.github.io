```c#
public class SomeEditorWindow
{
    [OnOpenAsset(1)]
    public static bool OpenSomeAsset(int instanceID, int line)
    {
        var selection = EditorUtility.InstanceIDToObject(instanceID);
        if (selection is SomeAsset)
        {
            ShowWindow(selection as SomeAsset);
            return true; // we handled open action
        }
        return false; // unity will handle the open action
    }
}
```
