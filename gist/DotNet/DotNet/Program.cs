using System;
using System.Collections.Generic;

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

    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            var sorted = new SortedSet<CustomType>(new CustomTypeComparer());
            sorted.Add(new CustomType { Age = 15, Name = "Alice", });
            sorted.Add(new CustomType { Age = 7, Name = "Bob", });
            sorted.Add(new CustomType { Age = 33, Name = "Chris", });
            sorted.Add(new CustomType { Age = 5, Name = "David", });
            foreach (var item in sorted)
            {
                Console.WriteLine(item.Name);
            }
        }
    }
}
