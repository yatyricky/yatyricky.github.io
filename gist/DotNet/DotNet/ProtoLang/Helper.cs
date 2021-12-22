using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ProtoLang
{
    public class Helper
    {
        private struct Entry
        {
            public string Name;
            public string Type;
            public int Value;
            public bool Reserved;
        }

        private static readonly Dictionary<string, string> MessageNameConversion = new Dictionary<string, string>
        {
            {"FTNNLoginReq", "M4399LoginReq"},
            {"FTNNOrderReq", "PayM4399OrderReq"},
            {"VIVOLoginReq", "VivoLoginReq"},
        };

        private static Dictionary<string, Entry[]> ConvertProto(Node root)
        {
            var dict = new Dictionary<string, Entry[]>();
            var messages = root.Find("Messages").FindAll("Message");
            foreach (var message in messages)
            {
                var body = message.Find("MessageBody");
                var entries = new List<Entry>();
                foreach (var field in body.Children)
                {
                    if (field.Name == "ActiveField")
                    {
                        entries.Add(new Entry
                        {
                            Reserved = false,
                            Name = field.Find("FieldName").Content,
                            Type = Formatter.FieldTypeToString(field),
                            Value = int.Parse(field.Find("FieldNumber").Content)
                        });
                    }
                    else if (field.Name == "ReservedField")
                    {
                        entries.Add(new Entry
                        {
                            Reserved = true,
                            Value = int.Parse(field.Find("FieldNumber").Content)
                        });
                    }
                    else if (field.Name == "LineComment")
                    {
                        // ignore
                    }
                    else
                    {
                        throw new Exception($"unhandled {field}");
                    }
                }

                entries.Sort((a, b) => a.Value < b.Value ? -1 : 1);

                var messageName = message.Find("MessageName").Content;
                if (MessageNameConversion.ContainsKey(messageName))
                {
                    messageName = MessageNameConversion[messageName];
                }

                dict.Add(messageName, entries.ToArray());
            }

            return dict;
        }

        public static List<string> SmoothUpgrade(string f1, string f2, bool checkName = false)
        {
            var errs = new List<string>();
            var d1 = ConvertProto(new Parser(f1).ParseProto());
            var d2 = ConvertProto(new Parser(f2).ParseProto());
            foreach (var kv in d1)
            {
                if (d2.ContainsKey(kv.Key))
                {
                    var leftArr = kv.Value;
                    var rightArr = d2[kv.Key];

                    for (int i = 0; i < Math.Min(leftArr.Length, rightArr.Length); i++)
                    {
                        var left = leftArr[i];
                        var right = rightArr[i];
                        if (right.Reserved)
                        {
                            // good
                        }
                        else
                        {
                            if (left.Type != right.Type)
                            {
                                errs.Add($"message {kv.Key} field {i + 1} type changed from {left.Type} to {right.Type}");
                            }

                            if (checkName)
                            {
                                if (left.Name != right.Name)
                                {
                                    errs.Add($"message {kv.Key} field {i + 1} name changed from {left.Name} to {right.Name}");
                                }
                            }
                        }
                    }

                    if (leftArr.Length > rightArr.Length)
                    {
                        errs.Add($"message {kv.Key} had {leftArr.Length} fields, but now have only {rightArr.Length} fields");
                    }
                }
                else
                {
                    errs.Add($"new ver does not have message {kv.Key} any more");
                }
            }

            return errs;
        }

        public static void Detect()
        {
            var dir = @"C:\Users\yatyr\workspace\barrett-client\exportfolder\";
            var files = Directory.GetFiles(dir).ToList();
            files.Sort((a, b) =>
            {
                var ca = File.GetCreationTime(a);
                var cb = File.GetCreationTime(b);
                return ca < cb ? -1 : 1;
            });
            for (int i = 0; i < files.Count - 1; i++)
            {
                var left = files[i];
                var right = files[i + 1];
                Console.WriteLine($"Comparing {left} with {right}");
                var res = SmoothUpgrade(left, right);
                foreach (var item in res)
                {
                    Console.WriteLine(item);
                }
            }
        }
    }
}
