-- Seed data. The lab's "today" is 2026-10-15. IDs are fixed so tickets can reference them.
-- Some of this data was created by the bugs you'll be fixing (duplicate late fees, a misapplied payment).
USE CommunityLab;
GO
SET NOCOUNT ON;

SET IDENTITY_INSERT dbo.Associations ON;
INSERT dbo.Associations (AssociationId, Name, MonthlyAssessment, LateFeeAmount, LateFeeGraceDays) VALUES
(1, N'Pine Ridge HOA', 300.00, 25.00, 15),
(2, N'Lakeview Condominiums', 450.00, 50.00, 10);
SET IDENTITY_INSERT dbo.Associations OFF;

SET IDENTITY_INSERT dbo.Units ON;
INSERT dbo.Units (UnitId, AssociationId, UnitNumber, Address) VALUES
(1, 1, N'101', N'101 Pine Ridge Dr'),
(2, 1, N'102', N'102 Pine Ridge Dr'),
(3, 1, N'103', N'103 Pine Ridge Dr'),
(4, 1, N'104', N'104 Pine Ridge Dr'),
(5, 1, N'105', N'105 Pine Ridge Dr'),
(6, 1, N'112', N'112 Pine Ridge Dr'),
(7, 2, N'A1', N'500 Lakeview Blvd #A1'),
(8, 2, N'A2', N'500 Lakeview Blvd #A2'),
(9, 2, N'A3', N'500 Lakeview Blvd #A3'),
(10, 2, N'B1', N'500 Lakeview Blvd #B1');
SET IDENTITY_INSERT dbo.Units OFF;

SET IDENTITY_INSERT dbo.Owners ON;
INSERT dbo.Owners (OwnerId, UnitId, FirstName, LastName, Email, Phone, IsCurrentOwner, StartDate, EndDate) VALUES
(1, 1, N'Angela', N'Reyes', N'angela.reyes@example.com', N'555-0101', 1, '2019-04-01', NULL),
(2, 2, N'Tom', N'Becker', N'tom.becker@example.com', N'555-0102', 1, '2021-08-15', NULL),
(3, 3, N'Dana', N'Whitfield', N'dana.whitfield@example.com', N'555-0103', 0, '2015-02-01', '2026-07-15'),
(4, 3, N'Marcus', N'Lee', N'marcus.lee@example.com', N'555-0113', 1, '2026-07-16', NULL),
(5, 4, N'Priya', N'Nair', N'priya.nair@example.com', N'555-0104', 1, '2022-03-01', NULL),
(6, 5, N'Gloria', N'Santos', N'gloria.santos@example.com', N'555-0105', 1, '2018-06-10', NULL),
(7, 6, N'Kevin', N'Ortiz', N'kevin.ortiz@example.com', N'555-0112', 0, '2016-09-01', '2026-06-30'),
(8, 7, N'Hannah', N'Brooks', N'hannah.brooks@example.com', N'555-0201', 1, '2020-01-10', NULL),
(9, 8, N'Luis', N'Moreno', N'luis.moreno@example.com', N'555-0202', 1, '2023-05-20', NULL),
(10, 9, N'Ruth', N'Kaplan', N'ruth.kaplan@example.com', N'555-0203', 0, '2012-11-01', '2026-05-31'),
(11, 9, N'Jordan', N'Ellis', N'jordan.ellis@example.com', N'555-0213', 1, '2026-06-01', NULL),
(12, 10, N'Mei', N'Chen', N'mei.chen@example.com', N'555-0204', 1, '2017-07-07', NULL);
SET IDENTITY_INSERT dbo.Owners OFF;

SET IDENTITY_INSERT dbo.Charges ON;
INSERT dbo.Charges (ChargeId, UnitId, ChargeType, Amount, DueDate, Description, RelatedChargeId, CreatedAt) VALUES
(1, 1, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(2, 1, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(3, 1, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(4, 2, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(5, 2, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(6, 2, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(7, 3, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(8, 3, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(9, 3, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(10, 4, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(11, 4, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(12, 4, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(13, 5, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(14, 5, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(15, 5, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(16, 6, N'Assessment', 300.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(17, 6, N'Assessment', 300.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(18, 6, N'Assessment', 300.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(19, 7, N'Assessment', 450.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(20, 7, N'Assessment', 450.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(21, 7, N'Assessment', 450.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(22, 8, N'Assessment', 450.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(23, 8, N'Assessment', 450.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(24, 8, N'Assessment', 450.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(25, 9, N'Assessment', 450.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(26, 9, N'Assessment', 450.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(27, 9, N'Assessment', 450.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(28, 10, N'Assessment', 450.00, '2026-08-01', N'August 2026 assessment', NULL, '2026-07-25 06:00:00'),
(29, 10, N'Assessment', 450.00, '2026-09-01', N'September 2026 assessment', NULL, '2026-08-25 06:00:00'),
(30, 10, N'Assessment', 450.00, '2026-10-01', N'October 2026 assessment', NULL, '2026-09-25 06:00:00'),
(31, 8, N'LateFee', 50.00, '2026-09-12', N'Late fee - September 2026 assessment', 23, '2026-09-12 02:00:00'),
(32, 10, N'LateFee', 50.00, '2026-09-12', N'Late fee - September 2026 assessment', 29, '2026-09-12 02:00:00'),
(33, 8, N'LateFee', 50.00, '2026-10-12', N'Late fee - September 2026 assessment', 23, '2026-10-12 02:00:00'),
(34, 8, N'LateFee', 50.00, '2026-10-12', N'Late fee - October 2026 assessment', 24, '2026-10-12 02:00:00'),
(35, 10, N'LateFee', 50.00, '2026-10-12', N'Late fee - September 2026 assessment', 29, '2026-10-12 02:00:00'),
(36, 10, N'LateFee', 50.00, '2026-10-12', N'Late fee - October 2026 assessment', 30, '2026-10-12 02:00:00');
SET IDENTITY_INSERT dbo.Charges OFF;

SET IDENTITY_INSERT dbo.Payments ON;
INSERT dbo.Payments (PaymentId, UnitId, Amount, PaymentDate, Method, Reference) VALUES
(1, 1, 300.00, '2026-08-01', N'ACH', NULL),
(2, 1, 300.00, '2026-09-01', N'ACH', NULL),
(3, 1, 300.00, '2026-10-01', N'ACH', NULL),
(4, 3, 300.00, '2026-08-01', N'ACH', NULL),
(5, 3, 300.00, '2026-09-01', N'ACH', NULL),
(6, 3, 300.00, '2026-10-01', N'ACH', NULL),
(7, 2, 300.00, '2026-08-03', N'Check', N'CHK 1184'),
(8, 2, 300.00, '2026-09-02', N'Check', N'CHK 1201'),
(9, 5, 300.00, '2026-08-05', N'Card', NULL),
(10, 5, 300.00, '2026-10-10', N'Card', NULL),
(11, 7, 450.00, '2026-08-01', N'ACH', NULL),
(12, 7, 450.00, '2026-09-01', N'ACH', NULL),
(13, 7, 450.00, '2026-10-01', N'ACH', NULL),
(14, 9, 450.00, '2026-08-01', N'ACH', NULL),
(15, 9, 450.00, '2026-09-01', N'ACH', NULL),
(16, 9, 450.00, '2026-10-01', N'ACH', NULL),
(17, 8, 450.00, '2026-08-01', N'ACH', NULL),
(18, 10, 450.00, '2026-08-01', N'ACH', NULL);
SET IDENTITY_INSERT dbo.Payments OFF;

SET IDENTITY_INSERT dbo.PaymentApplications ON;
INSERT dbo.PaymentApplications (PaymentApplicationId, PaymentId, ChargeId, AmountApplied) VALUES
(1, 1, 1, 300.00),
(2, 2, 2, 300.00),
(3, 3, 3, 300.00),
(4, 4, 7, 300.00),
(5, 5, 8, 300.00),
(6, 6, 9, 300.00),
(7, 7, 4, 300.00),
(8, 8, 5, 300.00),
(9, 9, 13, 300.00),
(10, 10, 15, 300.00),
(11, 11, 19, 450.00),
(12, 12, 20, 450.00),
(13, 13, 21, 450.00),
(14, 14, 25, 450.00),
(15, 15, 26, 450.00),
(16, 16, 27, 450.00),
(17, 17, 22, 450.00),
(18, 18, 28, 450.00);
SET IDENTITY_INSERT dbo.PaymentApplications OFF;
GO
