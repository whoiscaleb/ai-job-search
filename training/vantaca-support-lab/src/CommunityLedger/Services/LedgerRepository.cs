using CommunityLedger.Data;
using Microsoft.Data.SqlClient;

namespace CommunityLedger.Services;

/// <summary>Plain SQL reads used by the services. (Real apps often use an ORM; the SQL is the same idea.)</summary>
public static class LedgerRepository
{
    public static string GetUnitLabel(SqlConnection conn, int unitId)
    {
        using var cmd = new SqlCommand(
            "SELECT a.Name + N' - Unit ' + u.UnitNumber FROM dbo.Units u JOIN dbo.Associations a ON a.AssociationId = u.AssociationId WHERE u.UnitId = @UnitId", conn);
        cmd.Parameters.AddWithValue("@UnitId", unitId);
        return cmd.ExecuteScalar() as string ?? throw new ArgumentException($"Unit {unitId} does not exist.");
    }

    public static List<Owner> GetOwners(SqlConnection conn, int unitId)
    {
        using var cmd = new SqlCommand(
            "SELECT OwnerId, FirstName, LastName, Email, IsCurrentOwner FROM dbo.Owners WHERE UnitId = @UnitId ORDER BY StartDate", conn);
        cmd.Parameters.AddWithValue("@UnitId", unitId);
        var owners = new List<Owner>();
        using var r = cmd.ExecuteReader();
        while (r.Read())
            owners.Add(new Owner(r.GetInt32(0), r.GetString(1), r.GetString(2), r.IsDBNull(3) ? null : r.GetString(3), r.GetBoolean(4)));
        return owners;
    }

    public static List<Charge> GetCharges(SqlConnection conn, int unitId, SqlTransaction? tx = null)
    {
        using var cmd = new SqlCommand(@"
            SELECT c.ChargeId, c.ChargeType, c.Amount, c.DueDate, c.Description,
                   ISNULL((SELECT SUM(pa.AmountApplied) FROM dbo.PaymentApplications pa WHERE pa.ChargeId = c.ChargeId), 0)
            FROM dbo.Charges c
            WHERE c.UnitId = @UnitId", conn, tx);
        cmd.Parameters.AddWithValue("@UnitId", unitId);
        var charges = new List<Charge>();
        using var r = cmd.ExecuteReader();
        while (r.Read())
            charges.Add(new Charge(r.GetInt32(0), r.GetString(1), r.GetDecimal(2), r.GetDateTime(3), r.GetString(4), r.GetDecimal(5)));
        return charges;
    }

    public static List<Payment> GetPayments(SqlConnection conn, int unitId)
    {
        using var cmd = new SqlCommand(
            "SELECT PaymentId, Amount, PaymentDate, Method FROM dbo.Payments WHERE UnitId = @UnitId", conn);
        cmd.Parameters.AddWithValue("@UnitId", unitId);
        var payments = new List<Payment>();
        using var r = cmd.ExecuteReader();
        while (r.Read())
            payments.Add(new Payment(r.GetInt32(0), r.GetDecimal(1), r.GetDateTime(2), r.GetString(3)));
        return payments;
    }
}
