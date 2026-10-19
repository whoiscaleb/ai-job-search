# Debugging: Visual Studio and SSMS

## Visual Studio debugger (C#)
| Key | Action |
|---|---|
| **F9** | Toggle breakpoint on current line |
| **F5** | Start debugging / continue to next breakpoint |
| **F10** | Step **over** (run this line, don't go inside methods) |
| **F11** | Step **into** the method on this line |
| **Shift+F11** | Step **out** (finish this method, return to caller) |
| **Shift+F5** | Stop debugging |
| **Ctrl+Shift+F9** | Delete all breakpoints |

Windows (Debug → Windows): **Locals** (variables in scope), **Watch** (expressions you type in), **Call Stack** (how you got here), **Immediate** (run C# expressions while paused, e.g. `owners.Count`).

Power moves:
- **Conditional breakpoint:** right-click the red dot → Conditions → `charge.ChargeId == 15`. Only stops when the condition is true. Essential inside loops.
- **Break on exceptions:** Debug → Windows → Exception Settings → check *Common Language Runtime Exceptions*. The debugger stops at the exact line that throws, even if a `catch` would swallow it.
- **Hover** any variable while paused to inspect it. Pin it to keep it visible.
- **Command-line arguments:** this lab includes launch profiles. Pick one from the dropdown next to the green ▶ button.

**Workflow for a ticket:** reproduce → read the error / stack trace → breakpoint *before* the suspect line → F5 → inspect state → form a hypothesis → change one thing → re-test.

## SSMS (SQL Server Management Studio)
SSMS no longer includes a T-SQL step debugger, so you debug stored procedures by **taking them apart**:
1. Right-click the procedure → **Modify** (or *Script Procedure as → ALTER To*) to see its code.
2. Copy the body into a new query window. Replace parameters with `DECLARE @UnitId INT = 2;`.
3. Run pieces: remove `GROUP BY`/`SUM` to see raw rows, run each JOIN one at a time, run the WHERE conditions as SELECT columns to see which one filters out the rows you expected.
4. Add `SELECT` statements between steps (or `PRINT`) to see intermediate values.
5. When you understand it, fix the procedure with `CREATE OR ALTER PROCEDURE ...`.

Useful SSMS habits:
- **Ctrl+E / F5** executes. Highlight text first to run only that part.
- **Ctrl+L** shows the estimated execution plan (for slow queries).
- Results → right-click → **Copy with Headers**, then paste into Excel. Or *Save Results As…* CSV.
- `sp_helptext 'dbo.usp_Name'` prints a procedure's source. `sp_help 'dbo.TableName'` shows columns and keys.
- Search all procedure code for a column or table:
  ```sql
  SELECT OBJECT_NAME(object_id) FROM sys.sql_modules WHERE definition LIKE '%RelatedChargeId%';
  ```
