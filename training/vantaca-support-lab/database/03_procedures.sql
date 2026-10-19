-- Stored procedures used by the CommunityLedger app.
-- Several of these contain bugs on purpose. The tickets in /tickets lead you to them.
-- Don't read ahead: work each ticket like a real escalation.
USE CommunityLab;
GO

-- Account balance for one unit: everything billed minus everything paid.
CREATE OR ALTER PROCEDURE dbo.usp_GetUnitBalance
    @UnitId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.UnitId,
        u.UnitNumber,
        SUM(c.Amount)                 AS TotalCharged,
        SUM(p.Amount)                 AS TotalPaid,
        SUM(c.Amount) - SUM(p.Amount) AS Balance
    FROM dbo.Units u
    JOIN dbo.Charges c       ON c.UnitId = u.UnitId
    LEFT JOIN dbo.Payments p ON p.UnitId = u.UnitId
    WHERE u.UnitId = @UnitId
    GROUP BY u.UnitId, u.UnitNumber;
END
GO

-- Charges that are still (partly) unpaid and more than @MinDaysPastDue days past due as of @AsOfDate.
CREATE OR ALTER PROCEDURE dbo.usp_GetDelinquencyReport
    @AssociationId  INT,
    @AsOfDate       DATE,
    @MinDaysPastDue INT = 30
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.UnitNumber,
        c.ChargeId,
        c.Description,
        c.DueDate,
        DATEDIFF(DAY, c.DueDate, @AsOfDate)        AS DaysPastDue,
        c.Amount - ISNULL(pa.Applied, 0)           AS AmountOutstanding
    FROM dbo.Charges c
    JOIN dbo.Units u ON u.UnitId = c.UnitId
    OUTER APPLY (
        SELECT SUM(x.AmountApplied) AS Applied
        FROM dbo.PaymentApplications x
        WHERE x.ChargeId = c.ChargeId
    ) pa
    WHERE u.AssociationId = @AssociationId
      AND c.Amount - ISNULL(pa.Applied, 0) > 0
      AND DATEDIFF(DAY, @AsOfDate, c.DueDate) > @MinDaysPastDue
    ORDER BY u.UnitNumber, c.DueDate;
END
GO

-- Nightly job: charge a late fee on every assessment that is unpaid past the grace period.
CREATE OR ALTER PROCEDURE dbo.usp_ApplyLateFees
    @AssociationId INT,
    @AsOfDate      DATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT dbo.Charges (UnitId, ChargeType, Amount, DueDate, Description, RelatedChargeId)
    SELECT
        c.UnitId,
        'LateFee',
        a.LateFeeAmount,
        @AsOfDate,
        CONCAT(N'Late fee - ', c.Description),
        c.ChargeId
    FROM dbo.Charges c
    JOIN dbo.Units u        ON u.UnitId = c.UnitId
    JOIN dbo.Associations a ON a.AssociationId = u.AssociationId
    WHERE u.AssociationId = @AssociationId
      AND c.ChargeType = 'Assessment'
      AND DATEADD(DAY, a.LateFeeGraceDays, c.DueDate) < @AsOfDate
      AND c.Amount > ISNULL((SELECT SUM(x.AmountApplied)
                             FROM dbo.PaymentApplications x
                             WHERE x.ChargeId = c.ChargeId), 0);

    SELECT @@ROWCOUNT AS LateFeesCreated;
END
GO

-- Owner contact list for an association (boards ask for this as an Excel export).
CREATE OR ALTER PROCEDURE dbo.usp_GetOwnerDirectory
    @AssociationId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.UnitNumber,
        o.FirstName,
        o.LastName,
        o.Email,
        o.Phone
    FROM dbo.Owners o
    JOIN dbo.Units u ON u.UnitId = o.UnitId
    WHERE u.AssociationId = @AssociationId
    ORDER BY u.UnitNumber, o.LastName;
END
GO
