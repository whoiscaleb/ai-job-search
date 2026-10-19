# C# for TypeScript developers

TypeScript and C# were designed by the same person (Anders Hejlsberg). You already know most of the ideas.

| TypeScript | C# | Notes |
|---|---|---|
| `let x = 5` / `const` | `var x = 5;` / `const int X = 5;` | `var` is still strongly typed (inferred) |
| `number` | `int`, `decimal`, `double` | **Money is always `decimal`.** `double` causes rounding bugs |
| `string \| null` | `string?` | With `<Nullable>enable</Nullable>` the compiler warns on possible nulls |
| `x?.name ?? "n/a"` | `x?.Name ?? "n/a"` | Identical |
| `interface User { name: string }` | `record User(string Name);` or a `class` with `{ get; set; }` properties | |
| `arr.filter(f)` | `list.Where(f)` | LINQ (`using System.Linq;`) |
| `arr.map(f)` | `list.Select(f)` | |
| `arr.find(f)` | `list.FirstOrDefault(f)` | Returns `null` if no match → **NullReferenceException** if you use it blindly |
| `arr.some(f)` / `every` | `Any(f)` / `All(f)` | |
| `arr.sort((a,b)=>a.d-b.d)` | `list.OrderBy(x => x.D)` / `OrderByDescending` | Then `.ThenBy(...)` for tie-breaks |
| `arr.reduce` | `Sum(x => x.Amount)`, `Aggregate(...)` | |
| `async function f(): Promise<T>` | `async Task<T> F()` | `await` works the same |
| `` `Hi ${name}` `` | `$"Hi {name}"` | Format specifiers: `{amount:C}` = $1,234.00 |
| `import x from` | `using Namespace;` | |
| npm / package.json | NuGet / `.csproj` | |
| `throw new Error()` | `throw new InvalidOperationException()` | Many specific exception types |

## Exceptions you'll see most in support
- **NullReferenceException**: something was null. Find which variable on that line.
- **InvalidOperationException: Sequence contains no elements**: `.First()` or `.Single()` found nothing. Should it be `FirstOrDefault()`?
- **SqlException**: the error came from SQL Server. Read the message: timeout, constraint violation, or bad column name.
- **FormatException**: parsing bad input (`int.Parse("abc")`).
- **KeyNotFoundException**: a dictionary lookup for a missing key.

## Reading a stack trace
```
System.NullReferenceException: Object reference not set to an instance of an object.
   at CommunityLedger.Services.StatementService.PrintStatement(Int32 unitId) in ...StatementService.cs:line 20   ← start here
   at Program.<Main>$(String[] args) in ...Program.cs:line 34                                                   ← who called it
```
The **top** line in *your* code is where it blew up. Lines below it are the chain of callers. Skip frames from `System.*` / `Microsoft.*`.
