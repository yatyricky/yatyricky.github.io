using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace Excel4Unity
{
    public class Worksheet
    {
        internal readonly DataTable Table;
        public string Name => Table.TableName;
        public int ColsCount => Table.Columns.Count;
        public int RowsCount => Table.Rows.Count;

        internal Worksheet(string name, DataTable dataTable = null)
        {
            Table = dataTable ?? new DataTable(name);
        }

        public void Populate(IEnumerable<IEnumerable<string>> range)
        {
            var r = 1;
            foreach (var row in range)
            {
                var c = 1;
                foreach (var cell in row)
                {
                    this[c++, r] = cell;
                }

                r++;
            }
        }

        public string this[string address]
        {
            get
            {
                var (c, r) = ExcelUtils.ParseAddress(address);
                return this[c, r];
            }
            set
            {
                var (c, r) = ExcelUtils.ParseAddress(address);
                this[c, r] = value;
            }
        }

        public string this[string colName, int rowIndex]
        {
            get => this[ExcelUtils.ColNameToColNumber(colName), rowIndex];
            set => this[ExcelUtils.ColNameToColNumber(colName), rowIndex] = value;
        }

        public string this[string colName, string rowName]
        {
            get => this[ExcelUtils.ColNameToColNumber(colName), int.Parse(rowName)];
            set => this[ExcelUtils.ColNameToColNumber(colName), int.Parse(rowName)] = value;
        }

        public string this[int colIndex, int rowIndex]
        {
            get
            {
                var r = rowIndex - 1;
                if (r < 0 || r >= RowsCount)
                {
                    return "";
                }

                var row = Table.Rows[r];
                var c = colIndex - 1;
                if (c < 0 || c >= ColsCount)
                {
                    return "";
                }

                var cell = row[c];
                switch (cell)
                {
                    case string strVal:
                        return strVal;
                    case double doubleVal:
                        return doubleVal.ToString(CultureInfo.InvariantCulture);
                    case DateTime dateTime:
                        return dateTime.ToString("yyyy-MM-dd HH:mm:ss");
                    case DBNull _:
                        return "";
                    case bool boolVal:
                        return boolVal ? "TRUE" : "FALSE";
                    default:
                        throw new Exception($"uncaught type {cell.GetType()} {cell} @ {colIndex},{rowIndex}");
                }
            }
            set
            {
                var ri = rowIndex - 1;
                var ci = colIndex - 1;
                if (ri < 0 || ci < 0)
                {
                    throw new IndexOutOfRangeException($"row {ri}<0 or col {ci}<0");
                }

                if (ci >= ColsCount)
                {
                    for (int c = ColsCount; c < ci + 1; c++)
                    {
                        Table.Columns.Add("", typeof(string));
                    }
                }

                if (ri >= RowsCount)
                {
                    for (int r = RowsCount; r < ri + 1; r++)
                    {
                        Table.Rows.Add(Table.NewRow());
                    }
                }

                Table.Rows[ri][ci] = value;
            }
        }
    }
}
