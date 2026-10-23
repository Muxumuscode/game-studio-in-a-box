# tools/check.ps1 - one command to sanity-check the project before a commit.
# Run from the repo root: .\tools\check.ps1
#
# Set $env:GODOT_BIN once if `godot` isn't on your PATH, e.g.:
#   $env:GODOT_BIN = "C:\dev\tools\godot\godot.exe"

$ErrorActionPreference = "Stop"
$godot = if ($env:GODOT_BIN) { $env:GODOT_BIN } else { "godot" }

Write-Host "== gdlint (GDScript style/lint, if installed) =="
if (Get-Command gdlint -ErrorAction SilentlyContinue) {
    gdlint .
} else {
    Write-Host "gdlint not found - skipping (pipx install gdtoolkit to enable)"
}

Write-Host "== Godot: headless script parse check =="
# One Godot run with autoloads registered - see tools/parse_all.gd for why
# per-file --check-only can't be used.
$ErrorActionPreference = "Continue"
$parseOutput = & $godot --headless --path . --script res://tools/parse_all.gd 2>&1
$parseExit = $LASTEXITCODE
$ErrorActionPreference = "Stop"
$parseOutput | ForEach-Object { "$_" } | Where-Object { $_ -match 'PARSE FAILED|Parsed|SCRIPT ERROR' }
if ($parseExit -ne 0) {
    Write-Host "One or more scripts failed to parse." -ForegroundColor Red
    exit 1
}

Write-Host "== Scene smoke test: every scene runs 300 frames headless =="
# Catches anything that crashes on load or in the first seconds (a missing node, a bad
# resource, a script error in _ready/_process). Each scene prints one line.
$ErrorActionPreference = "Continue"
$smokeFailed = $false
foreach ($scene in (git ls-files '*.tscn')) {
    $sceneOutput = (& $godot --headless --path . --quit-after 300 "res://$scene" 2>&1) | ForEach-Object { "$_" }
    if ($sceneOutput -match 'SCRIPT ERROR') {
        Write-Host "FAIL $scene" -ForegroundColor Red
        $sceneOutput | Select-String 'SCRIPT ERROR' -Context 0, 2 | Select-Object -First 4
        $smokeFailed = $true
    } else {
        Write-Host "ok   $scene"
    }
}
$ErrorActionPreference = "Stop"
if ($smokeFailed) {
    Write-Host "One or more scenes raised a script error." -ForegroundColor Red
    exit 1
}

Write-Host "== GUT tests (if the addon is installed) =="
if (Test-Path "addons/gut") {
    & $godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Tests FAILED." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "GUT addon not installed yet - skipping automated tests."
}

Write-Host "All checks passed." -ForegroundColor Green
