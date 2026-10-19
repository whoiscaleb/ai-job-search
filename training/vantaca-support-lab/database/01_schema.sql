-- CommunityLab schema: a simplified HOA / community-association accounting model.
USE CommunityLab;
GO

CREATE TABLE dbo.Associations (
    AssociationId     INT IDENTITY(1,1) PRIMARY KEY,
    Name              NVARCHAR(100) NOT NULL,
    MonthlyAssessment DECIMAL(10,2) NOT NULL,   -- regular dues charged to every unit
    LateFeeAmount     DECIMAL(10,2) NOT NULL,
    LateFeeGraceDays  INT           NOT NULL    -- days after DueDate before a late fee applies
);

CREATE TABLE dbo.Units (
    UnitId        INT IDENTITY(1,1) PRIMARY KEY,
    AssociationId INT NOT NULL REFERENCES dbo.Associations(AssociationId),
    UnitNumber    NVARCHAR(20)  NOT NULL,
    Address       NVARCHAR(200) NOT NULL
);

-- A unit can have many owners over time; at most one should be current.
CREATE TABLE dbo.Owners (
    OwnerId        INT IDENTITY(1,1) PRIMARY KEY,
    UnitId         INT NOT NULL REFERENCES dbo.Units(UnitId),
    FirstName      NVARCHAR(50)  NOT NULL,
    LastName       NVARCHAR(50)  NOT NULL,
    Email          NVARCHAR(200) NULL,
    Phone          NVARCHAR(20)  NULL,
    IsCurrentOwner BIT  NOT NULL,
    StartDate      DATE NOT NULL,
    EndDate        DATE NULL
);

-- Everything an owner is billed: assessments, late fees, fines.
CREATE TABLE dbo.Charges (
    ChargeId        INT IDENTITY(1,1) PRIMARY KEY,
    UnitId          INT NOT NULL REFERENCES dbo.Units(UnitId),
    ChargeType      NVARCHAR(20)  NOT NULL CHECK (ChargeType IN ('Assessment','LateFee','Fine')),
    Amount          DECIMAL(10,2) NOT NULL,
    DueDate         DATE NOT NULL,
    Description     NVARCHAR(200) NOT NULL,
    RelatedChargeId INT NULL REFERENCES dbo.Charges(ChargeId),  -- for a LateFee: the assessment it penalizes
    CreatedAt       DATETIME2(0) NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Payments (
    PaymentId   INT IDENTITY(1,1) PRIMARY KEY,
    UnitId      INT NOT NULL REFERENCES dbo.Units(UnitId),
    Amount      DECIMAL(10,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    Method      NVARCHAR(20) NOT NULL,  -- ACH, Check, Card
    Reference   NVARCHAR(50) NULL
);

-- How each payment was split across charges. Business rule: oldest open charge is paid first.
CREATE TABLE dbo.PaymentApplications (
    PaymentApplicationId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentId     INT NOT NULL REFERENCES dbo.Payments(PaymentId),
    ChargeId      INT NOT NULL REFERENCES dbo.Charges(ChargeId),
    AmountApplied DECIMAL(10,2) NOT NULL
);
GO
