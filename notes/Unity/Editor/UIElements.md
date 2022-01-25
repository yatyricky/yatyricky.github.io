``` xml
<?xml version="1.0" encoding="utf-8"?>
<engine:UXML
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:engine="UnityEngine.UIElements"
        xmlns:editor="UnityEditor.UIElements"
        xsi:noNamespaceSchemaLocation="../../../UIElementsSchema/UIElements.xsd"
>
    <engine:VisualElement name="header">
        <engine:Button name="save" text="保存"/>
        <engine:Button name="load" text="加载"/>
        <engine:Button name="clear" text="清除"/>
        <engine:Label text="选择战斗" class="label"/>
        <editor:ToolbarMenu name="combats" text="All" />
        <engine:Button name="logs" text="Logs"/>
    </engine:VisualElement>
</engine:UXML>
```

``` css
#header {
    width: auto;
    border-bottom-color: #222222;
    border-bottom-width: 1px;
    display: flex;
    flex-direction: row;
    height: 20px;
    min-height: 20px;
}

.label {
    -unity-text-align: middle-center;
    margin-left: 4px;
    margin-right: 4px;
}
```

Basic operation

``` cs
public class SkadaWindow : EditorWindow
{
    _matGUI = new Material(Shader.Find("Hidden/Internal-Colored"));

    private void OnEnable()
    {
        // view
        var root = rootVisualElement;
        var xml = AssetDatabase.LoadAssetAtPath<VisualTreeAsset>("Assets/Editor/Skada/Main.uxml");
        var dom = xml.CloneTree();
        var css = AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Editor/Skada/Skada.uss");
        dom.styleSheets.Add(css);

        root.Add(dom);

        _combats = root.Q<ToolbarMenu>("combats");
        _combats.RegisterCallback<WheelEvent>(MouseScrollCombats);
        _dpsCurve.RegisterCallback<MouseMoveEvent>(CurveMoveCall);
        _dpsCurve.RegisterCallback<MouseOutEvent>(CurveOutCall);

        _dpsCurve.onGUIHandler = CurveOnGUI;
}
```

GL

``` cs
private void CurveOnGUI()
{
    var rect = _dpsCurve.contentRect;
    GUI.BeginClip(rect);
    _matGUI.SetPass(0);
    GL.Begin(GL.LINES);
    GL.Color(color);
    GL.Vertex3(x1, y1, 0);
    GL.Vertex3(x2, y2, 0);
    GL.End();

    GL.Begin(GL.QUADS);
    GL.Color(color);
    GL.Vertex3(x - ex, y - ex, 0);
    GL.Vertex3(x + ex, y - ex, 0);
    GL.Vertex3(x + ex, y + ex, 0);
    GL.Vertex3(x - ex, y + ex, 0);
    GL.End();

    GUI.EndClip();
```

Drag and drop rects

css
``` css
#Body {
}

.Node {
    width: auto;
    min-height: 50px;
    background-color: rgb(43, 60, 100);
    position: absolute;
}

.Title {
    -unity-text-align: middle-center;
}
```

Graph.cs
``` cs
public class Graph : EditorWindow
{
    private List<Node> _nodes;
    private VisualElement _body;

    public void CreateGUI()
    {
        var root = rootVisualElement;
        var xml = AssetDatabase.LoadAssetAtPath<VisualTreeAsset>("Assets/Editor/NodeGraph/Graph.uxml");
        var dom = xml.CloneTree();
        var css = AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Editor/NodeGraph/Graph.uss");
        dom.styleSheets.Add(css);

        root.Add(dom);
        _body = root.Q<VisualElement>("Body");

        _nodes = new List<Node>();

        // init
        InitNodes();
    }

    private void InitNodes()
    {
        var node1 = AddNode("Awesome Node1", new Vector2(100, 100));
        var node2 = AddNode("Some Node2", new Vector2(200, 200));
        var node3 = AddNode("Node3", new Vector2(300, 300));

        node1.AddOutgoing(node2).AddOutgoing(node3);
        node2.AddOutgoing(node3);
    }

    private Node AddNode(string nodeName, Vector2 nodePos)
    {
        var node = new Node(nodeName, nodePos);
        _body.Add(node.VisualElement);
        _nodes.Add(node);
        return node;
    }

    private void OnGUI()
    {
        var root = rootVisualElement;
        foreach (var node in _nodes)
        {
            node.ResetIncomingPorts();
        }

        foreach (var node in _nodes)
        {
            node.Draw();
        }

        // render edges
    }
}

```

Node.cs
``` cs
public class Node : IDisposable
{
    public VisualElement VisualElement { get; private set; }
    private Vector2 _position;
    private bool _dragging;
    private Vector2 _anchor;
    private List<Node> _outgoings;
    private int _incomingPortIndex;
    private string _name;
    private Color _edgeColor;

    private Label _domTitle;

    public Node() : this("Node", new Vector2(0, 0))
    {
    }

    public Node(string name, Vector2 position)
    {
        VisualElement = new VisualElement();
        VisualElement.AddToClassList("Node");
        _domTitle = new Label();
        _domTitle.AddToClassList("Title");
        VisualElement.Add(_domTitle);

        _edgeColor = _palette[_instances++ % _palette.Length];

        _name = name;
        _position = position;
        _dragging = false;
        _outgoings = new List<Node>();
        Update();
        VisualElement.RegisterCallback<MouseDownEvent>(OnMouseDown);
        VisualElement.RegisterCallback<MouseMoveEvent>(OnMouseMove);
        VisualElement.RegisterCallback<MouseUpEvent>(OnMouseUp);
        VisualElement.RegisterCallback<MouseOutEvent>(OnMouseOut);
    }

    public Node AddOutgoing(Node next)
    {
        _outgoings.Add(next);
        return this;
    }

    private void Update()
    {
        VisualElement.style.left = _position.x;
        VisualElement.style.top = _position.y;
    }

    public void ResetIncomingPorts()
    {
        _incomingPortIndex = 0;
    }

    private Vector2 GetIncomingPort()
    {
        return new Vector2(_position.x, _position.y + 24 + _incomingPortIndex++ * 16);
    }

    public void Draw()
    {
        _domTitle.text = _name;

        var width = VisualElement.resolvedStyle.width;
        var outgoingPort = new Vector2(_position.x + width, _position.y + 24);
        Handles.BeginGUI();
        foreach (var vert in _outgoings)
        {
            var start = outgoingPort;
            var end = vert.GetIncomingPort();
            Handles.DrawBezier(start, end, start + new Vector2(100, 0), end - new Vector2(100, 0), _edgeColor, null, 4f);
            outgoingPort += new Vector2(0, 16);
        }

        Handles.EndGUI();
    }

    private void OnMouseDown(MouseDownEvent e)
    {
        if (e.button != 0)
        {
            return;
        }

        if (_dragging)
        {
            e.StopImmediatePropagation();
            return;
        }

        var mousePos = e.mousePosition;
        _anchor = mousePos - _position;
        _dragging = true;
        e.StopPropagation();
    }

    private void OnMouseMove(MouseMoveEvent e)
    {
        if (!_dragging)
            return;

        _position = e.mousePosition - _anchor;
        Update();

        e.StopPropagation();
    }

    private void OnMouseUp(MouseUpEvent e)
    {
        if (!_dragging)
            return;

        _dragging = false;
        e.StopPropagation();
    }

    private void OnMouseOut(MouseOutEvent e)
    {
        if (!_dragging)
            return;

        _position = e.mousePosition - _anchor;
        Update();

        e.StopPropagation();
    }

    public void Dispose()
    {
        VisualElement.UnregisterCallback<MouseDownEvent>(OnMouseDown);
        VisualElement.UnregisterCallback<MouseMoveEvent>(OnMouseMove);
        VisualElement.UnregisterCallback<MouseUpEvent>(OnMouseUp);
        VisualElement.UnregisterCallback<MouseOutEvent>(OnMouseOut);
    }
}
```
