namespace CommunityLedger;

public record Owner(int OwnerId, string FirstName, string LastName, string? Email, bool IsCurrentOwner)
{
    public string FullName => $"{FirstName} {LastName}";
}

public record Charge(int ChargeId, string ChargeType, decimal Amount, DateTime DueDate, string Description, decimal AmountApplied)
{
    public decimal AmountOpen => Amount - AmountApplied;
}

public record Payment(int PaymentId, decimal Amount, DateTime PaymentDate, string Method);

public record StatementLine(DateTime Date, string Description, decimal Debit, decimal Credit, decimal RunningBalance);
