# Safe data fixes (production SQL)

As a T2 engineer you'll change customer data directly. One missing `WHERE` can damage thousands of records. Follow this every time, even for "one quick update".

## The pattern
```sql
-- 1. SELECT exactly the rows you intend to change, using the SAME WHERE you'll use in the UPDATE/DELETE.
SELECT * FROM dbo.PaymentApplications WHERE PaymentId = 10 AND ChargeId = 15;   -- note the count: 1

-- 2. Check dependencies: does anything reference these rows? (payments, foreign keys, audit tables)

-- 3. Change it inside a transaction
BEGIN TRAN;

UPDATE dbo.PaymentApplications
SET ChargeId = 14
WHERE PaymentId = 10 AND ChargeId = 15;

SELECT @@ROWCOUNT AS RowsChanged;      -- 4. Does it match step 1? (read this BEFORE committing)

SELECT * FROM dbo.PaymentApplications WHERE PaymentId = 10;   -- 5. Look at the result

-- 6. Only then:
COMMIT;
-- or, if anything is off:
-- ROLLBACK;
```

## Rules
- **Never run UPDATE or DELETE without a WHERE.** Write the WHERE first, then the rest of the statement.
- **Use primary keys** (`ChargeId = 33`) in the WHERE when you can, instead of descriptions or names.
- **Expected row count before you start.** If you expect 2 and get 200, ROLLBACK.
- **Don't leave a transaction open.** It locks rows and blocks the app for every user. COMMIT or ROLLBACK promptly.
- **Prefer reversing over deleting financial records** (credit entries keep an audit trail). Follow your team's standard.
- **Save every script** you run against production in the ticket, so anyone can see exactly what changed.
- **Get a second pair of eyes** on anything touching many rows or money, until you know the team's norms.
- **Fix the cause too.** A data fix without a code fix means the same ticket comes back next month.
