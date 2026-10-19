using System.Data;
using System.Text;
using CommunityLedger.Data;

namespace CommunityLedger.Services;

/// <summary>Thin wrappers around the reporting stored procedures.</summary>
public static class ReportService
{
    public static void PrintBalance(int unitId) =>
        Print(Db.ExecProc("dbo.usp_GetUnitBalance", ("@UnitId", unitId)));

    public static void PrintDelinquency(int associationId, DateTime asOf, int minDays) =>
        Print(Db.ExecProc("dbo.usp_GetDelinquencyReport", ("@AssociationId", associationId), ("@AsOfDate", asOf), ("@MinDaysPastDue", minDays)));

    public static void ApplyLateFees(int associationId, DateTime asOf) =>
        Print(Db.ExecProc("dbo.usp_ApplyLateFees", ("@AssociationId", associationId), ("@AsOfDate", asOf)));

    public static void ExportDirectory(int associationId, string path)
    {
        var table = Db.ExecProc("dbo.usp_GetOwnerDirectory", ("@AssociationId", associationId));
        var csv = new StringBuilder();
        csv.AppendLine(string.Join(",", table.Columns.Cast<DataColumn>().Select(c => c.ColumnName)));
        foreach (DataRow row in table.Rows)
            csv.AppendLine(string.Join(",", row.ItemArray.Select(v => Csv(v?.ToString() ?? ""))));
        File.WriteAllText(path, csv.ToString());
        Console.WriteLine($"Wrote {table.Rows.Count} owners to {Path.GetFullPath(path)} (opens in Excel).");
    }

    private static string Csv(string value) =>
        value.Contains(',') || value.Contains('"') ? $"\"{value.Replace("\"", "\"\"")}\"" : value;

    private static void Print(DataTable table)
    {
        var cols = table.Columns.Cast<DataColumn>().ToList();
        Console.WriteLine(string.Join(" | ", cols.Select(c => c.ColumnName)));
        foreach (DataRow row in table.Rows)
            Console.WriteLine(string.Join(" | ", cols.Select(c => row.IsNull(c) ? "NULL" : row[c].ToString())));
        if (table.Rows.Count == 0) Console.WriteLine("(no rows)");
    }
}
