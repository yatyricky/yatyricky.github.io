using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace DotNet
{
    class JavaParser
    {
        private class NBArgument
        {
            public Type type;
            public string name;
            public string comment;
            public Dictionary<int, List<NBArgument>> callbackArgs;
        }

        private class NBMethod
        {
            public Type type;
            public string name;
            public string comment;
            public List<NBArgument> args;
        }

        private class NBAPI
        {
            public Dictionary<string, NBMethod> messages;
            public Dictionary<string, NBMethod> baseClass;
            public Dictionary<string, Dictionary<string, NBMethod>> otherClasses;
        }

        private static string[] ExcludeFiles = new string[] {
            "MessageNames",
            "Messenger",
            "SDKBase",
            "SDKManager",
            "Utils",
        };

        private static NBAPI javaAPI;

        private static Type ParseJavaType(string str)
        {
            switch (str)
            {
                case "void": return typeof(void);
                case "String": return typeof(string);
                case "boolean": return typeof(bool);
                case "double": return typeof(double);
                default: throw new NotImplementedException($"unknown java type {str} {Environment.StackTrace}");
            }
        }

        private static Dictionary<string, NBMethod> ParseJavaToClass(string source)
        {
            var cls = new Dictionary<string, NBMethod>();

            var regex = new Regex(@"^    public (?<returnType>String|void|boolean|double) (?<methodName>[a-zA-Z_0-9]+)\((?<args>[a-zA-Z0-9_\, ]*)\)");

            foreach (var line in source.Split('\n'))
            {
                var match = regex.Match(line);
                if (!match.Success)
                {
                    continue;
                }
                var method = new NBMethod();
                method.type = ParseJavaType(match.Groups["returnType"].Value);
                method.name = match.Groups["methodName"].Value;
                method.comment = "todo not parsed method comment";

                var args = match.Groups["args"].Value;
                method.args = new List<NBArgument>();
                foreach (var _argRaw in args.Split(','))
                {
                    var argRaw = _argRaw.Trim();
                    if (argRaw.Length == 0)
                    {
                        continue;
                    }
                    var kv = argRaw.Split(' ');
                    if (kv.Length != 2)
                    {
                        throw new Exception($"args list is wrong {args}");
                    }
                    var arg = new NBArgument();
                    var _k = kv[0].Trim();
                    if (_k.Equals("Context"))
                    {
                        goto argFail;
                    }
                    arg.type = ParseJavaType(_k);
                    arg.name = kv[1].Trim();
                    arg.comment = "todo not parsed argument comment";
                    if (arg.name.Equals("callback"))
                    {
                        arg.callbackArgs = new Dictionary<int, List<NBArgument>>();
                    }
                    method.args.Add(arg);
                }

                if (cls.ContainsKey(method.name))
                {
                    throw new Exception($"found {method.name} twice in {source}");
                }
                cls.Add(method.name, method);

            argFail:
                continue;
            }
            return cls;
        }

        private static void ParseJavaAPI(string path)
        {
            javaAPI = new NBAPI
            {
                otherClasses = new Dictionary<string, Dictionary<string, NBMethod>>(),
            };
            var baseJava = Path.Combine(path, "SDKBase.java");
            if (!File.Exists(baseJava))
            {
                Console.WriteLine($"no SDKBase.java");
            }
            else
            {
                javaAPI.baseClass = ParseJavaToClass(File.ReadAllText(baseJava));
            }
            foreach (var file in Directory.GetFiles(path))
            {
                var fn = Path.GetFileNameWithoutExtension(file);
                if (ExcludeFiles.Contains(fn))
                {
                    continue;
                }
                if (javaAPI.otherClasses.ContainsKey(fn))
                {
                    throw new Exception($"same file in dir??? {fn}");
                }
                javaAPI.otherClasses.Add(fn, ParseJavaToClass(File.ReadAllText(file)));
            }
            Console.WriteLine("stop");
        }

        internal static void Start()
        {
            ParseJavaAPI(@"D:\Projects\barrett-client\androidBuildProject\googlePlay\src\main\java\com\sagi\sdk");
        }
    }
}
