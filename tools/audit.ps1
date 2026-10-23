# PURPOSE: Read-only list of what Claude Code can reach on this machine, so you can check the walls hold.
#          Changes nothing. Run it after setup and again after any change: .\tools\audit.ps1
# EMITS: none
# DEPENDS ON: none
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII in a BOM-less file.
$ErrorActionPreference = "Continue"

function Section($t) { Write-Host ""; Write-Host "-- $t --" -ForegroundColor Cyan }

Section "Folder Claude works in"
(Get-Location).Path

Section "Top level of your user folder (anything personal here is readable)"
Get-ChildItem $env:USERPROFILE -Force -ErrorAction SilentlyContinue | Select-Object -First 40 | ForEach-Object { $_.Name }

Section "Drives, network shares and removable storage"
Get-PSDrive -PSProvider FileSystem | ForEach-Object { "{0}  {1}" -f $_.Name, $_.Root }
Get-CimInstance Win32_LogicalDisk -ErrorAction SilentlyContinue | Where-Object { $_.DriveType -in 2, 4 } |
    ForEach-Object { "{0}  type {1} (2 = removable, 4 = network)" -f $_.DeviceID, $_.DriveType }

Section "Credentials lying around (names only)"
foreach ($f in @("$env:USERPROFILE\.ssh", "$env:USERPROFILE\.aws", "$env:USERPROFILE\.kube", "$env:APPDATA\gcloud", "$env:USERPROFILE\.git-credentials")) {
    if (Test-Path $f) { Write-Host "FOUND  $f" }
}
Get-ChildItem Env: | Where-Object { $_.Name -match 'token|secret|api_?key|password' } | ForEach-Object { "ENV VAR  $($_.Name)" }

Section "Who is signed in"
if (Get-Command git -ErrorAction SilentlyContinue) {
    "git name:  " + (git config --global user.name)
    "git email: " + (git config --global user.email)
}
if (Get-Command gh -ErrorAction SilentlyContinue) {
    & gh auth status 2>&1 | Select-Object -First 6 | ForEach-Object { "$_" }
}

Write-Host ""
Write-Host "Read the list above. Anything personal, any extra account, any share you do not need: remove or lock it down, then run this again."
