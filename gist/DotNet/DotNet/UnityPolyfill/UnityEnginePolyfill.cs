using System;
using System.Collections.Generic;
using System.Text;

namespace UnityEngine
{
    public class Debug
    {
        public static void Log(string msg)
        {
            Console.WriteLine(msg);
        }

        public static void Log(object obj)
        {
            if (null == obj)
            {
                Console.WriteLine();
            }
            else
            {
                Console.WriteLine(obj.ToString());
            }
        }
    }
}
