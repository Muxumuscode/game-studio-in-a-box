# PURPOSE: Opens the game (or one scene) in a normal window and leaves it running, so a passing
#          build is waiting for the owner. First closes any headless Godot left over from tests.
#          Usage: .\tools\playtest.ps1 [scene]   e.g. .\tools\playtest.ps1 levels/zona_colonial/arena_01.tscn
#          No scene = the game's main scene (the title screen).
# EMITS: none
# DEPENDS ON: Godot (GODOT_BIN or `godot` on PATH). Needs a logged-in, unlocked desktop.
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII in a BOM-less file.

param([string]$Scene = "")

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$godot = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }
$found = Get-Command $godot -ErrorAction SilentlyContinue
if (-not $found) {
    Write-Host "Godot not found. Set `$env:GODOT_BIN to the Godot executable." -ForegroundColor Red
    exit 1
}
$exe = $found.Source
# GODOT_BIN usually points at the *_console.exe used by tools/check. Use the windowed exe to play.
$windowed = $exe -replace '_console\.exe$', '.exe'
if ($windowed -ne $exe -and (Test-Path $windowed)) { $exe = $windowed }

$projectPath = (Get-Location).Path
$argList = @("--path", "`"$projectPath`"")
$scene = $Scene -replace '^res://', '' -replace '\\', '/'
if ($scene) {
    if (-not (Test-Path $scene)) {
        Write-Host "Scene not found: $scene (path is relative to the project root)" -ForegroundColor Red
        exit 1
    }
    $argList += "res://$scene"
}

# Close only headless Godot runs (test leftovers). A Godot window you have open stays alone.
$leftovers = Get-CimInstance Win32_Process |
    Where-Object { $_.Name -like 'Godot*' -and $_.CommandLine -match '--headless' }
foreach ($p in $leftovers) {
    Write-Host "Closing leftover headless Godot (pid $($p.ProcessId))"
    Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue
}

# Start-Process returns at once and the game keeps running after this script ends.
Start-Process -FilePath $exe -ArgumentList $argList -WorkingDirectory $projectPath

if ($scene) { $label = $scene } else { $label = "main scene (title screen)" }
Write-Host "Game launched: $label"
Write-Host "It keeps running after this command ends. Close the window when you are done."
Write-Host "What to try: see docs/playtest_todo.md."
