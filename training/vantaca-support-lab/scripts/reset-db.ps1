# Rebuilds CommunityLab from scratch (all bugs back in place) on Windows.
# Default target is SQL Server Express LocalDB, which installs with Visual Studio's "Data storage and processing" workload.
# Usage:  .\scripts\reset-db.ps1                        (LocalDB)
#         .\scripts\reset-db.ps1 -Server "localhost,1433" -SqlLogin sa -Password "Lab_Passw0rd!"   (Docker / full SQL Server)
param(
    [string]$Server = "(localdb)\MSSQLLocalDB",
    [string]$SqlLogin = "",
    [string]$Password = ""
)
$ErrorActionPreference = "Stop"
$dir = Join-Path $PSScriptRoot "..\database"
$auth = if ($SqlLogin) { @("-U", $SqlLogin, "-P", $Password) } else { @("-E") }
foreach ($f in "00_create_database.sql", "01_schema.sql", "02_seed_data.sql", "03_procedures.sql") {
    Write-Host "Running $f"
    sqlcmd -C -b -S $Server @auth -i (Join-Path $dir $f)
    if ($LASTEXITCODE -ne 0) { throw "$f failed" }
}
Write-Host "CommunityLab is ready."
