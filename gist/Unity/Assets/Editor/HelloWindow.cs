using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;


public class HelloWindow : EditorWindow
{
    public static List<string> header = new List<string>();
    public static List<List<string>> data = new List<List<string>>();
    public static List<float> prevColSize = new List<float>();
    public static List<float> colSize = new List<float>();
    public static List<Rect> resizeAreas = new List<Rect>();

    private static void NewData(int cols, int rows)
    {
        header = new List<string>();
        colSize = new List<float>();
        for (int c = 0; c < cols; c++)
        {
            header.Add($"Head{c}");
            colSize.Add(100f);
        }
        data = new List<List<string>>();
        for (int r = 0; r < rows; r++)
        {
            var row = new List<string>();
            for (int c = 0; c < cols; c++)
            {
                row.Add($"I-{r}-{c}");
            }
            data.Add(row);
        }
    }

    [MenuItem("Window/HelloWindow #e")]
    public static void ShowExample()
    {
        NewData(3, 5);
        HelloWindow wnd = CreateWindow<HelloWindow>();
        wnd.RefreshResizeAreas();
        wnd.titleContent = new GUIContent("HelloWindow");
    }

    private StyleSheet _css;
    private VisualElement _thead;
    private ListView _listView;
    private Rect? _mouseResizeRect;
    private Vector2? _resizeStartPos;
    private int _resizingIndex;

    private Button _change;

    private VisualElement MakeItem()
    {
        var ve = new VisualElement();
        ve.AddToClassList("tr");
        ve.styleSheets.Add(_css);
        return ve;
    }

    private void FeedData(VisualElement e, List<string> pData)
    {
        var currChildren = e.Children().ToList();
        for (int i = 0; i < e.childCount && i < pData.Count; i++)
        {
            var label = (Label) currChildren[i];
            label.style.width = colSize[i];
            label.text = pData[i];
        }

        for (int i = e.childCount; i < pData.Count; i++)
        {
            var label = new Label();
            label.AddToClassList("td");
            label.styleSheets.Add(_css);
            label.text = pData[i];
            label.style.width = colSize[i];
            e.Add(label);
        }

        for (int i = e.childCount - 1; i >= pData.Count; i--)
        {
            e.RemoveAt(i);
        }
    }

    private void BindItem(VisualElement e, int index)
    {
        var rowData = data[index];
        FeedData(e, rowData);
    }

    public void CreateGUI()
    {
        // // Each editor window contains a root VisualElement object
        VisualElement root = rootVisualElement;
        //
        // // VisualElements objects can contain other VisualElement following a tree hierarchy.
        // VisualElement label = new Label("Hello World! From C#");
        // root.Add(label);
        //
        // // Import UXML
        var visualTree = AssetDatabase.LoadAssetAtPath<VisualTreeAsset>("Assets/Editor/HelloWindow.uxml");
        VisualElement labelFromUXML = visualTree.CloneTree();
        root.Add(labelFromUXML);

        // A stylesheet can be added to a VisualElement.
        // The style will be applied to the VisualElement and all of its children.
        _css = AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Editor/HelloWindow.uss");
        labelFromUXML.styleSheets.Add(_css);
        // VisualElement labelWithStyle = new Label("Hello World! With Style");
        // labelWithStyle.styleSheets.Add(styleSheet);
        // root.Add(labelWithStyle);

        _thead = root.Q<VisualElement>("THead");
        FeedData(_thead, header);
        _thead.RegisterCallback<MouseMoveEvent>(THeadMouseMove);
        _thead.RegisterCallback<MouseDownEvent>(THeadMouseDown);
        _thead.RegisterCallback<MouseUpEvent>(THeadMouseUp);
        _thead.RegisterCallback<MouseOutEvent>(THeadMouseOut);

        _listView = root.Q<ListView>("TBody");
        _listView.makeItem = MakeItem;
        _listView.bindItem = BindItem;
        _listView.itemsSource = data;
        _listView.selectionType = SelectionType.Multiple;
        
        _change = root.Q<Button>("Change");
        _change.clickable.clicked += ChangeValue;
    }
    
    private void ChangeValue()
    {
        NewData(4, 6);
        FeedData(_thead, header);
        _listView.itemsSource = data;
    }

    private void RefreshResizeAreas()
    {
        var left = 0f;
        for (int i = 0; i < resizeAreas.Count && i < colSize.Count; i++)
        {
            left += colSize[i];
            resizeAreas[i] = new Rect(left - 5f, 0f, 10f, 16f);
        }

        for (int i = resizeAreas.Count; i < colSize.Count; i++)
        {
            left += colSize[i];
            resizeAreas.Add(new Rect(left - 5f, 0f, 10f, 16f));
        }
    }

    private void THeadMouseMove(MouseMoveEvent e)
    {
        if (_resizeStartPos == null)
        {
            var parentPos = _thead.worldBound.position;
            var pos = e.mousePosition - parentPos;
            int controlId = GUIUtility.GetControlID(FocusType.Passive);
            for (var i = 0; i < resizeAreas.Count; i++)
            {
                var resizeArea = resizeAreas[i];
                if (resizeArea.Contains(pos))
                {
                    _mouseResizeRect = resizeArea;
                    _resizingIndex = i;
                    return;
                }
            }

            _mouseResizeRect = null;
        }
        else
        {
            var delta = e.mousePosition - _resizeStartPos.Value;
            var tar = Mathf.Max(prevColSize[_resizingIndex] +delta.x,30f);
            colSize[_resizingIndex] = prevColSize[_resizingIndex] +delta.x;
            RefreshResizeAreas();
            _listView.Rebuild();
            FeedData(_thead, header);
            if (tar<=30f)
            {
                Debug.Log("Mouse end too small");
                MouseEnd();
            }
        }
    }

    private void THeadMouseDown(MouseDownEvent e)
    {
        if (_mouseResizeRect != null)
        {
            _resizeStartPos = e.mousePosition;
            prevColSize = new List<float>();
            foreach (var f in colSize)
            {
                prevColSize.Add(f);
            }
        }
    }

    private void MouseEnd()
    {
        _resizeStartPos = null;
    }

    private void THeadMouseUp(MouseUpEvent e)
    {
        Debug.Log("Mouse end up");
        MouseEnd();
    }

    private void THeadMouseOut(MouseOutEvent e)
    {
        if (!_thead.worldBound.Contains(e.mousePosition))
        {
         
            Debug.Log("Mouse end out");
            MouseEnd();   
        }
    }

    private void Update()
    {
        Repaint();
        _listView.Rebuild();
    }
}
