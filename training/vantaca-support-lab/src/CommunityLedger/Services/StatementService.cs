using CommunityLedger.Data;

namespace CommunityLedger.Services;

/// <summary>Builds an owner account statement: every charge and payment in date order with a running balance.</summary>
public static class StatementService
{
    public static void PrintStatement(int unitId)
    {
        using var conn = Db.Open();

        var unitLabel = LedgerRepository.GetUnitLabel(conn, unitId);
        var owners    = LedgerRepository.GetOwners(conn, unitId);
        var charges   = LedgerRepository.GetCharges(conn, unitId);
        var payments  = LedgerRepository.GetPayments(conn, unitId);

        var currentOwner = owners.FirstOrDefault(o => o.IsCurrentOwner);

        Console.WriteLine($"ACCOUNT STATEMENT - {unitLabel}");
        Console.WriteLine($"Owner: {currentOwner.FullName}  <{currentOwner.Email}>");
        Console.WriteLine(new string('-', 92));
        Console.WriteLine($"{"Date",-12}{"Description",-44}{"Charges",12}{"Payments",12}{"Balance",12}");

        foreach (var line in BuildLines(charges, payments))
            Console.WriteLine($"{line.Date:yyyy-MM-dd}  {line.Description,-44}{Fmt(line.Debit),12}{Fmt(line.Credit),12}{line.RunningBalance,12:C}");
    }

    public static List<StatementLine> BuildLines(List<Charge> charges, List<Payment> payments)
    {
        var entries = charges.Select(c => (Date: c.DueDate, Description: c.Description, Debit: c.Amount, Credit: 0m))
            .Concat(payments.Select(p => (Date: p.PaymentDate, Description: $"Payment - {p.Method}", Debit: 0m, Credit: p.Amount)))
            .OrderBy(e => e.Date);

        var lines = new List<StatementLine>();
        decimal balance = 0;
        foreach (var e in entries)
        {
            balance += e.Debit - e.Credit;
            lines.Add(new StatementLine(e.Date, e.Description, e.Debit, e.Credit, balance));
        }
        return lines;
    }

    private static string Fmt(decimal amount) => amount == 0 ? "" : amount.ToString("C");
}
