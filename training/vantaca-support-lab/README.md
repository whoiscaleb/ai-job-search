# Vantaca T2 Support Engineer: Practice Lab

A hands-on lab built around the actual job description: **debug C# in Visual Studio, troubleshoot SQL Server stored procedures in SSMS, run SQL to export or fix customer data, and write it up for the customer.**

You get a small HOA accounting app (**CommunityLedger**, fictional, not Vantaca's code) with a SQL Server database and **7 support tickets**. Each ticket hides a realistic bug of the kind that shows up in community-management software: wrong balances, misapplied payments, duplicate late fees, crashes on edge-case data, and bad exports.

```
vantaca-support-lab/
├── CommunityLedger.sln          ← open this in Visual Studio
├── src/CommunityLedger/         ← C# (.NET 8) console app
├── database/                    ← schema, seed data, stored procedures (with bugs)
├── scripts/reset-db.ps1 / .sh   ← rebuild the database (puts all bugs back)
├── tickets/                     ← T-101 … T-107: start here
├── solutions/                   ← tested answers (no peeking for 30–45 min)
└── cheatsheets/                 ← C# for TS devs, debugging, safe data fixes
```

## Setup

### Windows (recommended: matches the job's tools)
1. Install **Visual Studio Community** (free) with the workloads **.NET desktop development** and **Data storage and processing** (the second one includes SQL Server Express **LocalDB**).
2. Install **SQL Server Management Studio (SSMS)** (free).
3. Build the database, using either option:
   - Run `.\scripts\reset-db.ps1` in PowerShell from this folder. It needs `sqlcmd`: `winget install Microsoft.Sqlcmd`.
   - Or, in SSMS, connect to `(localdb)\MSSQLLocalDB` and open and execute the four files in `database/` in order (00 → 03).
4. Point the app at LocalDB. In PowerShell, run once, then restart Visual Studio:
   ```powershell
   [Environment]::SetEnvironmentVariable("LAB_CONNECTION_STRING", "Server=(localdb)\MSSQLLocalDB;Database=CommunityLab;Trusted_Connection=True;TrustServerCertificate=True", "User")
   ```
5. Open `CommunityLedger.sln`, choose the **"Help (no arguments)"** launch profile next to the green ▶ button, and press F5.

### Mac / Linux
1. Install **Docker Desktop** and the **.NET 8 SDK**. (On Apple Silicon, turn on *Use Rosetta for x86/amd64 emulation* in Docker Desktop settings.)
2. Start SQL Server:
   ```bash
   docker run -d --name sqllab -e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD='Lab_Passw0rd!' -p 1433:1433 mcr.microsoft.com/mssql/server:2022-latest
   ```
3. `./scripts/reset-db.sh`
4. Run the app: `cd src/CommunityLedger && dotnet run -- statement 2`
5. Editor: **VS Code** with the **C# Dev Kit** and **SQL Server (mssql)** extensions (or JetBrains Rider). The debugger keys are nearly the same as Visual Studio's.

### App commands
```
balance     <unitId>                                 statement   <unitId>
pay         <unitId> <amount> [yyyy-mm-dd] [method]  delinquency <associationId> <asOfDate> [minDays]
latefees    <associationId> <asOfDate>               directory   <associationId> [file.csv]
```
Associations: **1 = Pine Ridge HOA** (UnitIds 1–6 → units 101–105, 112), **2 = Lakeview Condominiums** (UnitIds 7–10 → A1, A2, A3, B1). The lab's "today" is **2026-10-15**.

## How to work each ticket (like the real job)
1. **Reproduce** before touching anything.
2. **Find the root cause.** Fix the cause, not the symptom.
3. **Fix the code or procedure**, then **fix any bad data** it already created (see `cheatsheets/safe-data-fixes.md`).
4. **Verify** the original problem is gone, and that you didn't break something nearby.
5. **Write the customer reply** in plain language, plus a one-paragraph internal/KB note.
6. Time yourself. The role's target is about **10 tickets a day**, so a ticket averages under an hour including the write-up. These lab tickets are harder than typical day-to-day ones.

Tickets get harder in order. Reset the database whenever you want a clean slate. That also puts every bug back, so you can repeat a ticket until it feels routine.

## 4-week prep plan

| Week | Focus | Do |
|---|---|---|
| 1 | **C# reading fluency** | Microsoft Learn: *Foundational C# with Microsoft* (with freeCodeCamp). Skim what you know from TypeScript; spend time on LINQ, nullability, exceptions and `decimal`. Read `cheatsheets/csharp-for-typescript-devs.md` and the lab's `src/` code until you can explain every method. |
| 2 | **T-SQL and stored procedures** | Microsoft Learn path: *Get started querying with Transact-SQL* (joins, GROUP BY, subqueries, CTEs, window functions). Then lab tickets **T-101, T-102, T-103**. |
| 3 | **Visual Studio debugger** | Microsoft docs: *First look at the Visual Studio debugger*. Read `cheatsheets/debugging-visual-studio-and-ssms.md`. Lab tickets **T-104, T-105**. Practice conditional breakpoints and *Break on exceptions*. |
| 4 | **Data fixes and the HOA domain** | Read `cheatsheets/safe-data-fixes.md` until it's habit. Lab tickets **T-106, T-107**. Learn HOA basics: assessments, special assessments, late fees, delinquency/collections, reserves, general ledger, bank reconciliation, board vs. management company roles. |

**Ongoing:** reset the database and redo the tickets without hints, faster each time. Write every customer reply as if Vantaca's CSAT target (92%+) depended on it.

## First 30 days on the job
- Ask for read-only database access to a test or staging environment first, and learn the schema: owners, units, charges, payments.
- Keep a personal runbook: every query and fix you write, with the ticket it solved.
- Learn the escalation path: when to hand off to the CMP Engineering Team Lead instead of fixing it yourself.
- Ask early about the team's rules for production data changes: reviews, reversing entries versus deletes, and change logging.
