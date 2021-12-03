using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using ExcelDataReader;
using OfficeOpenXml;

namespace Excel4Unity
{
    public class Workbook
    {
        /// <summary>
        /// Create a workbook instance from target file.
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        /// <exception cref="FileNotFoundException"></exception>
        public static Workbook LoadFrom(string filePath)
        {
            if (filePath == null || !File.Exists(filePath))
            {
                throw new FileNotFoundException($"File not found @ {filePath}");
            }

            return new Workbook(filePath);
        }

        public List<Worksheet> Sheets { get; }
        private readonly DataSet _dataSet;
        private readonly string _filePath;

        public Worksheet FirstSheet => Sheets.Count == 0 ? null : Sheets[0];

        /// <summary>
        /// New workbook, if target path exists, load data from it.
        /// </summary>
        /// <param name="filePath"></param>
        public Workbook(string filePath = null)
        {
            if (filePath != null && File.Exists(filePath))
            {
                var stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                var reader = ExcelReaderFactory.CreateReader(stream);
                _dataSet = reader.AsDataSet();
                reader.Close();
                stream.Close();
            }
            else
            {
                _dataSet = new DataSet();
            }

            _filePath = filePath;
            Sheets = new List<Worksheet>();
            foreach (DataTable dataTable in _dataSet.Tables)
            {
                CreateSheet(dataTable.TableName, dataTable);
            }
        }

        /// <summary>
        /// Create a sheet and insert it to this workbook.
        /// </summary>
        /// <param name="name">Sheet name. If omitted, use SheetN as its name.</param>
        /// <param name="dataTable">Optional</param>
        /// <returns></returns>
        public Worksheet CreateSheet(string name = null, DataTable dataTable = null)
        {
            if (name == null)
            {
                var i = Sheets.Count;
                do
                {
                    i++;
                    name = $"Sheet{i}";
                } while (_dataSet.Tables.Contains(name));
            }

            var sheet = new Worksheet(name, dataTable);
            Sheets.Add(sheet);
            if (dataTable == null)
            {
                _dataSet.Tables.Add(sheet.Table);
            }

            return sheet;
        }

        /// <summary>
        /// Get the first sheet named {name}. Possible null.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public Worksheet GetSheet(string name)
        {
            return Sheets.FirstOrDefault(sheet => sheet.Name == name);
        }

        /// <summary>
        /// Save the workbook at target path.
        /// </summary>
        /// <param name="filePath">Where the file will be saved. If omitted, use the path specified when instantiated.</param>
        /// <exception cref="ArgumentNullException">If filePath not present and this instance was created without a path.</exception>
        public void Save(string filePath = null)
        {
            if (filePath == null && _filePath == null)
            {
                throw new ArgumentNullException(nameof(filePath), "Must specify file path in either constructor or Save method");
            }

            var ep = new ExcelPackage();
            foreach (var sheet in Sheets)
            {
                var epWorksheet = ep.Workbook.Worksheets.Add(sheet.Name);
                for (var row = 1; row <= sheet.RowsCount; row++)
                {
                    for (var column = 1; column <= sheet.ColsCount; column++)
                    {
                        epWorksheet.Cells[row, column].Value = sheet[column, row];
                    }
                }
            }

            ep.SaveAs(new FileInfo(filePath ?? _filePath));
        }
    }
}
