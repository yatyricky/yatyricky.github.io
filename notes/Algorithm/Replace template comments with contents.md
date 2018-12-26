``` csharp
using System.Text.RegularExpressions;
using System.Text;

public class PrecompileScripts
{

    public string ReplaceTemplateComment(string text, string template, string[] lines)
    {
        string[] ctxs = Regex.Split(text, @"\r?\n|\r");
        bool inTemplateBody = false;
        string indent = "";
        StringBuilder sb = new StringBuilder();
        Regex regex = new Regex(@"(\s*)\/\/ template:([a-zA-Z0-9_]+)");
        for (int i = 0; i < ctxs.Length; i++)
        {
            Match match = regex.Match(ctxs[i]);
            if (match.Success)
            {
                string directive = match.Groups[2].ToString();
                if (directive.Equals("end"))
                {
                    if (inTemplateBody)
                    {
                        inTemplateBody = false;
                        for (int j = 0; j < lines.Length; j++)
                        {
                            sb.Append(indent).Append(lines[j]).Append('\n');
                        }
                    }
                }
                else if (directive.Equals(template))
                {
                    inTemplateBody = true;
                    indent = match.Groups[1].ToString();
                }
                sb.Append(ctxs[i]);
                if (i < ctxs.Length - 1)
                {
                    sb.Append('\n');
                }
            }
            else if (!inTemplateBody)
            {
                sb.Append(ctxs[i]);
                if (i < ctxs.Length - 1)
                {
                    sb.Append('\n');
                }
            }
        }
        return sb.ToString();
    }

}
```
