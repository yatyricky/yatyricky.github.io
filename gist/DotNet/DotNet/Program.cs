using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Text;

namespace DotNet
{
    internal struct CustomType
    {
        public int Age;
        public string Name;
    }

    internal class CustomTypeComparer : IComparer<CustomType>
    {
        public int Compare(CustomType x, CustomType y)
        {
            return x.Age.CompareTo(y.Age);
        }
    }

    internal class Int
    {
        public int Value;

        public Int(int val)
        {
            Value = val;
        }

        public override string ToString()
        {
            return "s" + Value;
        }

        public static explicit operator int(Int obj) => obj.Value;
    }

    internal class Program
    {
        private static void TestSortedSet()
        {
            Console.WriteLine("Hello World!");

            var sorted = new SortedSet<CustomType>(new CustomTypeComparer());
            sorted.Add(new CustomType {Age = 15, Name = "Alice",});
            sorted.Add(new CustomType {Age = 7, Name = "Bob",});
            sorted.Add(new CustomType {Age = 33, Name = "Chris",});
            sorted.Add(new CustomType {Age = 5, Name = "David",});
            foreach (var item in sorted)
            {
                Console.WriteLine(item.Name);
            }
        }

        private static void PrintTable(ConditionalWeakTable<Int, object> tab)
        {
            foreach (var item in tab)
            {
                Console.WriteLine($"[{(int) item.Key}]={item.Value}");
            }
        }

        private static void PrintObject(object o)
        {
            if (o == null)
            {
                Console.WriteLine("[NULL]");
            }
            else
            {
                Console.WriteLine(o.ToString());
            }
        }

        private static void ConditionalWeakTable()
        {
            var tab = new ConditionalWeakTable<Int, object>();
            var k = new Int(12);
            var v = new Int(100);
            tab.Add(k, v);
            PrintTable(tab);
            v = null;
            GC.Collect();
            PrintTable(tab);
            PrintObject(k);
            PrintObject(v);
        }

        private static void PrintWeakArray(WeakReference[] wa)
        {
            for (int i = 0; i < wa.Length; i++)
            {
                var item = wa[i];
                if (item != null && item.Target != null)
                {
                    Console.WriteLine($"[{i}]={item.Target}");
                }
                else
                {
                    Console.WriteLine($"[{i}]=NULL");
                }
            }
        }

        private static void WeakArray()
        {
            //var arr = new WeakReference[10];
            var any = new Int(12);
            var item = new WeakReference(any);
            PrintObject(item.Target);
            any = null;
            GC.Collect(0);
            PrintObject(item.Target);
            //arr[1] = item;
            //PrintWeakArray(arr);
            //any = null;
            //item = null;
            //PrintWeakArray(arr);
        }


        private static readonly int IndexInitSize = 128;
        private static readonly int IndexGrow = 128;
        private static int IndexFreed = -1;
        private static int IndexCount = 0;
        private static int[] IndexTable = new int[IndexInitSize];

        private static int AllocateIndex()
        {
            var index = IndexFreed;
            if (index != -1)
            {
                IndexFreed = IndexTable[index];
            }
            else
            {
                index = IndexCount++;
            }

            if (index >= IndexTable.Length)
            {
                Array.Resize(ref IndexTable, IndexTable.Length + IndexGrow);
            }

            IndexTable[index] = -2;
            return index;
        }

        private static void FreeIndex(int index)
        {
            if (index < 0 || index >= IndexTable.Length)
            {
                Console.WriteLine("NativeBridgeIndex: free null index");
                return;
            }
            else if (IndexTable[index] != -2)
            {
                Console.WriteLine("NativeBridgeIndex: double free index or undefined index");
                return;
            }

            IndexTable[index] = IndexFreed;
            IndexFreed = index;
        }

        private static void TestManualAllocFree()
        {
            Console.WriteLine("0-199");
            for (int i = 0; i < 200; i++)
            {
                Console.WriteLine(AllocateIndex());
            }

            Console.WriteLine("free even");
            for (int i = 0; i < 300; i += 2)
            {
                FreeIndex(i);
            }

            Console.WriteLine("alloc even");
            for (int i = 0; i < 120; i++)
            {
                Console.WriteLine(AllocateIndex());
            }

            Console.WriteLine("free all");
            for (int i = 0; i < 220; i++)
            {
                FreeIndex(i);
            }

            Console.WriteLine("alloc 10");
            for (int i = 0; i < 10; i++)
            {
                Console.WriteLine(AllocateIndex());
            }
        }

        public static string GetTypeName(Type type)
        {
            return $"{type.FullName},{type.Assembly.GetName().Name}";
        }

        private static string NoScientific(double v, int precision)
        {
            var p = Math.Pow(10, -precision);
            var sign = "";
            if (v < 0f)
            {
                sign += "-";
                v = -v;
            }

            var d = v - Math.Floor(v);
            v -= d;
            var tens = "";
            while (v > p)
            {
                var n = Math.Floor(v / 10);
                var digit = (int) (v - n * 10);
                v = n;
                tens = digit + tens;
            }

            if (tens.Length == 0)
            {
                tens = "0";
            }

            var pts = "";
            while (d > p)
            {
                var n = d * 10;
                var digit = (int) Math.Floor(n);
                pts += digit;
                d = (n - digit) / 10f;
            }

            pts = pts.TrimEnd('0');
            if (pts.Length == 0)
            {
                return sign + tens;
            }
            else
            {
                return sign + tens + "." + pts;
            }
        }

        public static void TestSF()
        {
            Console.WriteLine(NoScientific(0.00001f, 5));
            Console.WriteLine(NoScientific(0.00001f, 4));
            Console.WriteLine(NoScientific(0, 4));
            Console.WriteLine(NoScientific(99999999, 4));
            Console.WriteLine(NoScientific(10000001, 4));
            Console.WriteLine(NoScientific(10000002, 4));
            Console.WriteLine(NoScientific(10000003.123456, 4));
        }

        private static void Main(string[] args)
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            //ConditionalWeakTable();
            //WeakArray();
            //TestManualAllocFree();
            //JavaParser.Start(); 
            //Console.WriteLine(GetTypeName(typeof(DateTime)));
            //var keys = new List<string>
            //{
            //    "1",
            //    "10",
            //    "2",
            //};
            //keys.Sort((a, b) =>
            //{
            //    for (int i = 0, n = Math.Min(a.Length, b.Length); i < n; i++)
            //    {
            //        var cdiff = a[i] - b[i];
            //        if (cdiff != 0)
            //        {
            //            return cdiff;
            //        }
            //    }
            //    return a.Length - b.Length;
            //});
            //foreach (var item in keys)
            //{
            //    Console.WriteLine(item);
            //}

            // NPPATest.Start();
            // TestEndOfLine();

            // TestMiniJson();

            // EPPlusHelper.Workbook.Test2();

            //ProtoLang.Parser.Tokenize();
            //ProtoLang.Helper.Detect();
            //ProtoLang.Formatter.FormatAllProtoFiles();
            EditorTools.ExportThinkingAnalytics.LuaCodeGen();
        }

        private static void TestMiniJson()
        {
            var nil = MiniJSON.Json.DeserializeObject(null);
            Console.WriteLine($"nil: {nil.IsNull} {nil}");
            
            var emptyString = MiniJSON.Json.DeserializeObject("");
            Console.WriteLine($"emptyString: {emptyString.IsNull} {emptyString}");
            
            var whiteSpaces = MiniJSON.Json.DeserializeObject("  ");
            Console.WriteLine($"whiteSpaces: {whiteSpaces.IsNull} {whiteSpaces}");
            
            var invalidJson = MiniJSON.Json.DeserializeObject("{xxx");
            Console.WriteLine($"invalidJson: {invalidJson.IsNull} {invalidJson}");
            
            var singleData = MiniJSON.Json.DeserializeObject("15");
            Console.WriteLine($"singleData: {singleData.IsNull} {singleData}");
            
            var simpleObject = MiniJSON.Json.DeserializeObject("{\"a\":15,\"b\":\"hello\",\"c\":{\"d\":-77}}");
            Console.WriteLine($"simpleObject: {simpleObject.IsNull} {simpleObject}");
            Console.WriteLine($"simpleObject.get a: {simpleObject.GetString("a")}");
            Console.WriteLine($"simpleObject.get b: {simpleObject.GetString("b")}");
            Console.WriteLine($"simpleObject.get c: {simpleObject.GetString("c")}");
            Console.WriteLine($"simpleObject.get d: {simpleObject.GetString("d")}");
            
            var array = MiniJSON.Json.DeserializeObject("[15,27,\"abc\"]");
            Console.WriteLine($"array: {array.IsNull} {array}");
        }

        private static void TestEndOfLine()
        {
            int counter = 0;
            string line;

            // Read the file and display it line by line.  
            System.IO.StreamReader file = new System.IO.StreamReader(@"D:\workspace\yatyricky.github.io\gist\DotNet\DotNet\mixed_eol.txt");
            while ((line = file.ReadLine()) != null)
            {
                System.Console.WriteLine($"[{line.Length}] : {BitConverter.ToString(Encoding.ASCII.GetBytes(line))}");
                counter++;
            }

            file.Close();
            System.Console.WriteLine("There were {0} lines.", counter);
        }
    }
}
