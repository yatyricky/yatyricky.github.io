using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;

namespace ProtoLang
{
    public class Formatter
    {
        public static string JoinNamespace(Node ns)
        {
            return string.Join(".", from e in ns.Children select e.Content);
        }

        internal static string FieldTypeToString(Node field)
        {
            var simple = field.Find("SimpleType");
            if (simple != null)
            {
                return JoinNamespace(simple.Find("Namespace"));
            }

            var repeated = field.Find("RepeatedType");
            if (repeated != null)
            {
                return $"repeated {JoinNamespace(repeated.Find("SimpleType").Find("Namespace"))}";
            }

            var map = field.Find("MapType");
            if (map != null)
            {
                var genericTypes = map.FindAll("SimpleType");
                return $"map<{JoinNamespace(genericTypes[0].Find("Namespace"))}, {JoinNamespace(genericTypes[1].Find("Namespace"))}>";
            }

            throw new Exception();
        }

        private struct MessageField
        {
            public enum Type
            {
                Comment,
                Message,
                Reserved,
                Enum,
                MessageObject,
            }

            public Type FType; // 0 comment 1 message 2 reserved
            public string F1; // type, reserved
            public string F2; // field name
            public string F3; // value
            public string F4; // comment
            public Node obj;
        }

        private static string Padding(string str, int len)
        {
            var sb = new StringBuilder();
            sb.Append(str);
            for (int i = str.Length; i < len; i++)
            {
                sb.Append(' ');
            }

            return sb.ToString();
        }

        private static string FormatMessage(Node node, int indent)
        {
            var sb = new StringBuilder();
            for (int i = 0; i < indent; i++)
            {
                sb.Append("    ");
            }

            var iden = sb.ToString();
            sb.Clear();
            sb.Append($"{iden}message {node.Find("MessageName").Content} {{\n");
            var fields = new List<MessageField>();
            var body = node.Find("MessageBody");
            foreach (var field in body.Children)
            {
                if (field.Name == "ActiveField")
                {
                    fields.Add(new MessageField
                    {
                        FType = MessageField.Type.Message,
                        F1 = FieldTypeToString(field),
                        F2 = field.Find("FieldName").Content,
                        F3 = field.Find("FieldNumber").Content,
                        F4 = field.Find("LineComment")?.Content ?? string.Empty
                    });
                }
                else if (field.Name == "ReservedField")
                {
                    fields.Add(new MessageField
                    {
                        FType = MessageField.Type.Reserved,
                        F1 = string.Empty,
                        F2 = string.Empty,
                        F3 = field.Find("FieldNumber").Content,
                        F4 = field.Find("LineComment")?.Content ?? string.Empty
                    });
                }
                else if (field.Name == "LineComment")
                {
                    fields.Add(new MessageField
                    {
                        FType = MessageField.Type.Comment,
                        F1 = string.Empty,
                        F2 = string.Empty,
                        F3 = string.Empty,
                        F4 = field.Content
                    });
                }
                else if (field.Name == "Message")
                {
                    fields.Add(new MessageField
                    {
                        FType = MessageField.Type.MessageObject,
                        F1 = string.Empty,
                        F2 = string.Empty,
                        F3 = string.Empty,
                        F4 = field.Content,
                        obj = field,
                    });
                }
                else
                {
                    throw new Exception($"Unknown child {field} in {body}");
                }
            }

            if (fields.Count > 0)
            {
                var f1Len = fields.Max(f => f.F1.Length);
                var f2Len = fields.Max(f => f.F2.Length);
                var f3Len = fields.Max(f => f.F3.Length);
                foreach (var field in fields)
                {
                    switch (field.FType)
                    {
                        case MessageField.Type.Comment:
                            sb.Append($"{iden}    // {field.F4.Substring(2).Trim()}\n");
                            break;
                        case MessageField.Type.Message:
                            sb.Append($"{iden}    {Padding(field.F1, f1Len)} {Padding(field.F2, f2Len)} = {field.F3};{(field.F4.Length == 0 ? "" : Padding("", f3Len - field.F3.Length + 1) + "// " + field.F4.Substring(2).Trim())}\n");
                            break;
                        case MessageField.Type.Reserved:
                            sb.Append($"{iden}    reserved {Padding(string.Empty, f1Len + f2Len - 6)} {field.F3};{(field.F4.Length == 0 ? "" : Padding("", f3Len - field.F3.Length + 1) + "// " + field.F4.Substring(2).Trim())}\n");
                            break;
                        case MessageField.Type.MessageObject:
                            sb.Append(FormatMessage(field.obj, indent + 1));
                            break;
                    }
                }
            }

            sb.Append($"{iden}}}\n");
            return sb.ToString();
        }

        /// <summary>
        /// Convert AST to formatted code.
        /// </summary>
        /// <param name="node">AST root</param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public static string Format(Node node)
        {
            var sb = new StringBuilder();
            var headers = node.Find("Headers");

            var prevHeader = "";
            foreach (var header in headers.Children)
            {
                if (!string.IsNullOrEmpty(prevHeader) && prevHeader != header.Name)
                {
                    sb.Append('\n');
                }

                switch (header.Name)
                {
                    case "HeaderSyntax":
                        sb.Append($"syntax = {header.Find("String").Content};\n");
                        break;
                    case "HeaderImport":
                        sb.Append($"import {header.Find("String").Content};\n");
                        break;
                    case "HeaderOption":
                        sb.Append($"option {header.Find("OptionName").Content} = {header.Find("String").Content};\n");
                        break;
                    case "LineComment":
                        sb.Append($"{header.Content}\n");
                        break;
                }

                prevHeader = header.Name;
            }

            var messages = node.Find("Messages");
            foreach (var child in messages.Children)
            {
                if (child.Name == "LineComment")
                {
                    sb.Append('\n');
                    sb.Append("// ");
                    sb.Append(child.Content.Substring(2).Trim());
                }
                else if (child.Name == "BlockComment")
                {
                    sb.Append('\n');
                    sb.Append(child.Content);
                    sb.Append('\n');
                }
                else if (child.Name == "Message")
                {
                    sb.Append('\n');
                    sb.Append(FormatMessage(child, 0));
                }
                else if (child.Name == "Enum")
                {
                    sb.Append('\n');
                    sb.Append($"enum {child.Find("EnumName").Content} {{\n");
                    var fields = new List<MessageField>();
                    var body = child.Find("EnumBody");
                    foreach (var @enum in body.Children)
                    {
                        if (@enum.Name == "EnumField")
                        {
                            //sb.Append($"    {@enum.Find("EnumName").Content} = {@enum.Find("EnumValue").Content};");
                            fields.Add(new MessageField
                            {
                                FType = MessageField.Type.Enum,
                                F1 = @enum.Find("EnumName").Content,
                                F2 = string.Empty,
                                F3 = @enum.Find("EnumValue").Content,
                                F4 = @enum.Find("LineComment")?.Content ?? string.Empty
                            });
                        }
                        else
                        {
                            throw new Exception($"Unknown child {@enum} in {body}");
                        }

                        //var lc = @enum.Find("LineComment");
                        //if (lc != null)
                        //{
                        //    sb.Append($" {lc.Content}");
                        //}
                        //sb.Append('\n');
                    }

                    if (fields.Count > 0)
                    {
                        var f1Len = fields.Max(f => f.F1.Length);
                        var f3Len = fields.Max(f => f.F3.Length);
                        foreach (var field in fields)
                        {
                            sb.Append($"    {Padding(field.F1, f1Len)} = {field.F3};{(field.F4.Length == 0 ? "" : Padding("", f3Len - field.F3.Length + 1) + "// " + field.F4.Substring(2).Trim())}\n");
                        }
                    }

                    sb.Append("}\n");
                }
                else if (child.Name == "Service")
                {
                    sb.Append('\n');
                    sb.Append($"service {child.Find("ServiceName").Content} {{\n");
                    var body = child.Find("ServiceBody");
                    Node prev = null;
                    foreach (var serviceChild in body.Children)
                    {
                        if (serviceChild.Name == "LineComment")
                        {
                            if (prev != null && prev.Name == "RPC")
                            {
                                sb.Append('\n');
                            }

                            sb.Append($"    {serviceChild.Content}\n");
                        }
                        else if (serviceChild.Name == "RPC")
                        {
                            var signature = serviceChild.Find("RPCSignature");
                            sb.Append($"    rpc {signature.Find("RPCName").Content}({signature.Find("RPCTakes").Content}) returns ({signature.Find("RPCReturns").Content})");
                            var rpcBody = serviceChild.Find("RPCBody");
                            if (rpcBody != null)
                            {
                                sb.Append(" {\n");
                                foreach (var option in rpcBody.FindAll("RPCOption"))
                                {
                                    sb.Append($"        option({JoinNamespace(option.Find("Namespace"))}) = ");
                                    sb.Append('{');
                                    var define = option.Find("RPCOptionDefine");
                                    var kvs = define.FindAll("KVPair");
                                    if (kvs.Count > 0)
                                        sb.Append(' ');
                                    sb.Append(string.Join(", ", from e in kvs select $"{e.Find("Key").Content}: {e.Find("Value").Content}"));
                                    if (kvs.Count > 0)
                                        sb.Append(' ');
                                    sb.Append("}\n");
                                }

                                sb.Append("    }");
                            }
                            else
                            {
                                sb.Append(';');
                            }

                            sb.Append('\n');
                        }

                        prev = serviceChild;
                    }

                    sb.Append("}\n");
                }
            }

            return sb.ToString();
        }

        private static void FormatFile(string path)
        {
            var node = new Parser(path).ParseProto();
            var code = Format(node);

            //File.WriteAllText(path + ".ast", node.ToString());
            File.WriteAllText(path, code);
        }

        [MenuItem("Tools/Proto/Format All Proto")]
        public static void FormatAllProtoFiles()
        {
            foreach (var file in Directory.GetFiles("../protos"))
            {
                if (file.EndsWith(".proto"))
                {
                    FormatFile(file);
                }
            }
        }
    }
}
