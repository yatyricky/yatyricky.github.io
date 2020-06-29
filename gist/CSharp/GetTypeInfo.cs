[MenuItem("Map/Export Types")]
public static void ExportTypes()
{
    var alias = new Dictionary<string, string>
    {
        ["Int32"] = "number",
        ["Single"] = "number",
        ["UInt16"] = "number",
        ["Boolean"] = "boolean",
        ["String"] = "string",
        ["Type"] = "{}",
        ["Void"] = "void",
    };

    var usingAlias = new Dictionary<string, string>();

    void checkAlias(string name)
    {
        if (alias.ContainsKey(name) && !usingAlias.ContainsKey(name))
        {
            usingAlias.Add(name, alias[name]);
        }
    }

    string escapeParameter(ParameterInfo pi)
    {
        if (pi.ParameterType.IsByRef)
        {
            return $"{{ ref: {pi.ParameterType.Name.Substring(0, pi.ParameterType.Name.Length - 1)} }}";
        }
        else
        {
            return pi.ParameterType.Name;
        }
    }

    var t = typeof(Vector2);

    var sb = new StringBuilder();

    sb.Append($"export default class {t.Name} {{\n");

    foreach (var fiel in t.GetFields(BindingFlags.Public | BindingFlags.Static))
    {
        sb.Append($"    public static {fiel.Name}: {fiel.FieldType.Name};\n");
        checkAlias(fiel.FieldType.Name);
    }

    foreach (var prop in t.GetProperties(BindingFlags.Public | BindingFlags.Static))
    {
        sb.Append("\n");
        sb.Append($"    public static get {prop.Name}(): {prop.PropertyType.Name} {{\n");
        sb.Append($"        throw new Error(\"Not Implemented\");\n");
        sb.Append($"    }}\n");
        checkAlias(prop.PropertyType.Name);
    }

    Dictionary<string, List<MethodInfo>> methods = new Dictionary<string, List<MethodInfo>>();
    foreach (var meth in t.GetMethods(BindingFlags.Public | BindingFlags.Static))
    {
        if (meth.IsPropertyAccessor())
        {
            continue;
        }
        if (!methods.ContainsKey(meth.Name))
        {
            methods.Add(meth.Name, new List<MethodInfo>());
        }
        var list = methods[meth.Name];
        list.Add(meth);
    }
    foreach (var item in methods)
    {
        sb.Append("\n");
        var list = item.Value;
        if (list.Count > 1)
        {
            for (int i = 0; i < list.Count - 1; i++)
            {
                var meth0 = list[i];
                var texts0 = from e in meth0.GetParameters() select $"{e.Name}: {escapeParameter(e)}";
                sb.Append($"    public static {meth0.Name}({string.Join(", ", texts0)}): {meth0.ReturnType.Name};\n");
                checkAlias(meth0.ReturnType.Name);
                foreach (var para in meth0.GetParameters())
                {
                    checkAlias(para.ParameterType.Name);
                }
            }
        }
        var meth = list.Last();
        var texts = from e in meth.GetParameters() select $"{e.Name}: {escapeParameter(e)}";
        sb.Append($"    public static {meth.Name}({string.Join(", ", texts)}): {meth.ReturnType.Name} {{\n");
        sb.Append($"        throw new Error(\"Not Implemented\");\n");
        sb.Append($"    }}\n");
        checkAlias(meth.ReturnType.Name);
        foreach (var para in meth.GetParameters())
        {
            checkAlias(para.ParameterType.Name);
        }
    }

    //foreach (var prop in t.GetProperties(BindingFlags.Public))
    //{
    //    sb.Append("\n");
    //    sb.Append($"    public get {prop.Name}(): {prop.PropertyType.Name} {{\n");
    //    sb.Append($"    }}\n");
    //}

    foreach (var fiel in t.GetFields(BindingFlags.Public | BindingFlags.Instance))
    {
        sb.Append($"    public {fiel.Name}: {fiel.FieldType.Name};\n");
        checkAlias(fiel.FieldType.Name);
    }

    foreach (var prop in t.GetProperties(BindingFlags.Public | BindingFlags.Instance))
    {
        sb.Append("\n");
        sb.Append($"    public get {prop.Name}(): {prop.PropertyType.Name} {{\n");
        sb.Append($"        throw new Error(\"Not Implemented\");\n");
        sb.Append($"    }}\n");
        checkAlias(prop.PropertyType.Name);
    }

    foreach (var ctor in t.GetConstructors())
    {
        sb.Append("\n");
        var texts = from e in ctor.GetParameters() select $"{e.Name}: {e.ParameterType.Name}";
        sb.Append($"    constructor({string.Join(", ", texts)}) {{\n");
        sb.Append($"        throw new Error(\"Not Implemented\");\n");
        sb.Append($"    }}\n");
        foreach (var para in ctor.GetParameters())
        {
            checkAlias(para.ParameterType.Name);
        }
    }

    methods.Clear();
    foreach (var meth in t.GetMethods(BindingFlags.Public | BindingFlags.Instance))
    {
        if (meth.IsPropertyAccessor())
        {
            continue;
        }
        if (!methods.ContainsKey(meth.Name))
        {
            methods.Add(meth.Name, new List<MethodInfo>());
        }
        var list = methods[meth.Name];
        list.Add(meth);
    }
    foreach (var item in methods)
    {
        sb.Append("\n");
        var list = item.Value;
        if (list.Count > 1)
        {
            for (int i = 0; i < list.Count - 1; i++)
            {
                var meth0 = list[i];
                var texts0 = from e in meth0.GetParameters() select $"{e.Name}: {escapeParameter(e)}";
                sb.Append($"    public {meth0.Name}({string.Join(", ", texts0)}): {meth0.ReturnType.Name};\n");
                foreach (var para in meth0.GetParameters())
                {
                    checkAlias(para.ParameterType.Name);
                }
                checkAlias(meth0.ReturnType.Name);
            }
        }
        var meth = list.Last();
        var texts = from e in meth.GetParameters() select $"{e.Name}: {escapeParameter(e)}";
        sb.Append($"    public {meth.Name}({string.Join(", ", texts)}): {meth.ReturnType.Name} {{\n");
        sb.Append($"        throw new Error(\"Not Implemented\");\n");
        sb.Append($"    }}\n");
        checkAlias(meth.ReturnType.Name);
        foreach (var para in meth.GetParameters())
        {
            checkAlias(para.ParameterType.Name);
        }
    }

    sb.Append("}");

    var finalsb = new StringBuilder();
    foreach (var item in usingAlias)
    {
        finalsb.Append($"type {item.Key} = {item.Value};\n");
    }
    if (usingAlias.Count > 0)
    {
        finalsb.Append("\n");
    }
    finalsb.Append(sb.ToString());

    StreamWriter sw = File.CreateText($"d:\\{t.Name}.ts");
    sw.Write(finalsb.ToString());
    sw.Close();
}