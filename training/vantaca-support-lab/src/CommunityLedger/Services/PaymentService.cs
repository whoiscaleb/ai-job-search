using CommunityLedger.Data;
using Microsoft.Data.SqlClient;

namespace CommunityLedger.Services;

/// <summary>
/// Records an owner payment and applies it to open charges.
/// Business rule (from the accounting team): a payment pays the OLDEST open charge first,
/// so owners stop accruing late fees on old balances.
/// </summary>
public static class PaymentService
{
    public static int RecordPayment(int unitId, decimal amount, DateTime paymentDate, string method)
    {
        if (amount <= 0) throw new ArgumentException("Payment amount must be positive.");

        using var conn = Db.Open();
        using var tx = conn.BeginTransaction();

        int paymentId;
        using (var cmd = new SqlCommand(@"
            INSERT dbo.Payments (UnitId, Amount, PaymentDate, Method)
            OUTPUT INSERTED.PaymentId
            VALUES (@UnitId, @Amount, @PaymentDate, @Method)", conn, tx))
        {
            cmd.Parameters.AddWithValue("@UnitId", unitId);
            cmd.Parameters.AddWithValue("@Amount", amount);
            cmd.Parameters.AddWithValue("@PaymentDate", paymentDate);
            cmd.Parameters.AddWithValue("@Method", method);
            paymentId = (int)cmd.ExecuteScalar();
        }

        var openCharges = LedgerRepository.GetCharges(conn, unitId, tx)
            .Where(c => c.AmountOpen > 0)
            .OrderByDescending(c => c.DueDate)
            .ToList();

        decimal remaining = amount;
        foreach (var charge in openCharges)
        {
            if (remaining <= 0) break;
            decimal toApply = Math.Min(remaining, charge.AmountOpen);

            using var apply = new SqlCommand(
                "INSERT dbo.PaymentApplications (PaymentId, ChargeId, AmountApplied) VALUES (@PaymentId, @ChargeId, @Amount)", conn, tx);
            apply.Parameters.AddWithValue("@PaymentId", paymentId);
            apply.Parameters.AddWithValue("@ChargeId", charge.ChargeId);
            apply.Parameters.AddWithValue("@Amount", toApply);
            apply.ExecuteNonQuery();

            Console.WriteLine($"  Applied {toApply:C} to charge {charge.ChargeId} ({charge.Description})");
            remaining -= toApply;
        }

        if (remaining > 0)
            Console.WriteLine($"  {remaining:C} left over as a credit on the account.");

        tx.Commit();
        return paymentId;
    }
}
