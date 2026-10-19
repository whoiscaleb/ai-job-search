using System.Globalization;
using CommunityLedger.Services;

// CommunityLedger: a tiny stand-in for an HOA management app, used for support-engineering practice.
// Run with no arguments to see the commands. In Visual Studio, set arguments under
// Project > Properties > Debug > "Open debug launch profiles UI" (or edit Properties/launchSettings.json).

CultureInfo.DefaultThreadCurrentCulture = CultureInfo.GetCultureInfo("en-US");
CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("en-US");

if (args.Length == 0)
{
    Console.WriteLine("""
        CommunityLedger commands:
          balance     <unitId>                               Account balance (usp_GetUnitBalance)
          statement   <unitId>                               Full account statement with running balance
          pay         <unitId> <amount> [yyyy-mm-dd] [method] Record a payment and apply it to open charges
          delinquency <associationId> <asOfDate> [minDays]   Past-due report (usp_GetDelinquencyReport)
          latefees    <associationId> <asOfDate>             Run the late-fee job (usp_ApplyLateFees)
          directory   <associationId> [file.csv]             Export owner directory to CSV for Excel
        Associations: 1 = Pine Ridge HOA (units 1-6), 2 = Lakeview Condominiums (units 7-10)
        """);
    return 0;
}

try
{
    switch (args[0].ToLowerInvariant())
    {
        case "balance":
            ReportService.PrintBalance(int.Parse(args[1]));
            break;
        case "statement":
            StatementService.PrintStatement(int.Parse(args[1]));
            break;
        case "pay":
            var date = args.Length > 3 ? DateTime.Parse(args[3]) : DateTime.Today;
            var method = args.Length > 4 ? args[4] : "Card";
            var id = PaymentService.RecordPayment(int.Parse(args[1]), decimal.Parse(args[2]), date, method);
            Console.WriteLine($"Recorded payment {id}.");
            break;
        case "delinquency":
            ReportService.PrintDelinquency(int.Parse(args[1]), DateTime.Parse(args[2]), args.Length > 3 ? int.Parse(args[3]) : 30);
            break;
        case "latefees":
            ReportService.ApplyLateFees(int.Parse(args[1]), DateTime.Parse(args[2]));
            break;
        case "directory":
            ReportService.ExportDirectory(int.Parse(args[1]), args.Length > 2 ? args[2] : $"owner-directory-{args[1]}.csv");
            break;
        default:
            Console.WriteLine($"Unknown command '{args[0]}'. Run with no arguments for help.");
            return 1;
    }
    return 0;
}
catch (Exception ex)
{
    // Real apps log this and show the customer a generic error. Learn to read the stack trace:
    // the top "at ..." line inside CommunityLedger is usually where to put your breakpoint.
    Console.Error.WriteLine("ERROR: something went wrong.");
    Console.Error.WriteLine(ex);
    return 1;
}
