using System;
using System.Text.RegularExpressions;

namespace Excel4Unity
{
    public class ExcelUtils
    {
        private static readonly Regex RegexAddress = new Regex(@"([A-Z]+)([0-9]+)", RegexOptions.Compiled);

        internal static string ColNumberToColName(int columnNumber)
        {
            if (columnNumber < 1)
            {
                throw new ArgumentException("Column index must start from 1");
            }

            var columnName = "";

            while (columnNumber > 0)
            {
                var modulo = (columnNumber - 1) % 26;
                columnName = Convert.ToChar('A' + modulo) + columnName;
                columnNumber = (columnNumber - modulo) / 26;
            }

            return columnName;
        }

        internal static int ColNameToColNumber(string columnName)
        {
            columnName = columnName.ToUpper();
            var digits = new int[columnName.Length];
            for (var i = 0; i < columnName.Length; ++i)
            {
                digits[i] = Convert.ToInt32(columnName[i]) - 64;
            }

            var mul = 1;
            var res = 0;
            for (var pos = digits.Length - 1; pos >= 0; --pos)
            {
                res += digits[pos] * mul;
                mul *= 26;
            }

            return res;
        }

        internal static (int, int) ParseAddress(string address)
        {
            var match = RegexAddress.Match(address);
            if (match.Success)
                return (ColNameToColNumber(match.Groups[1].Value), int.Parse(match.Groups[2].Value));

            throw new ArgumentException("sheet key malformed");
        }
        
        public static bool AreSheetsTextuallyEqual(Worksheet left, Worksheet right, int refCols = 10)
        {
            var cols = Math.Max(left.ColsCount, right.ColsCount);
            var rows = Math.Max(left.RowsCount, right.RowsCount);
            for (var c = 1; c <= cols; c++)
            {
                for (var r = 1; r <= rows; r++)
                {
                    var leftVal = left[c, r];
                    var rightVal = right[c, r];
                    // UnityEngine.Debug.Log($"compare {c}-{r} {leftVal} {rightVal}");
                    if (leftVal != rightVal)
                    {
                        return false;
                    }
                }
            }

            return true;
        }
    }
}
