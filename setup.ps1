# setup.ps1 - one-command setup of the game studio on Windows.
# Run from the repo root in PowerShell:  .\setup.ps1          (add -KeepAwake to turn off sleep while plugged in)
# It installs git, GitHub CLI and Godot (pinned in tools\godot.version), sets GODOT_BIN, makes the Godot
# shortcuts, signs you in to GitHub, audits what Claude can see, and runs the first check.
# It does NOT install Claude Code or create accounts: do those first (see README.md).
# Keep this file ASCII-only: Windows PowerShell 5.1 misreads non-ASCII in a BOM-less file.
param([switch]$KeepAwake)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$repo = (Get-Location).Path
$pin = if (Test-Path "tools\godot.version") { (Get-Content "tools\godot.version" | Select-Object -First 1).Trim() } else { "" }

function Step($text) { Write-Host ""; Write-Host "== $text ==" -ForegroundColor Cyan }
function Have($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}

Step "Folder"
if ($repo -match ' ') {
    Write-Host "This folder path has a space: $repo" -ForegroundColor Yellow
    Write-Host "Android tools break on spaces. Move the repo to something like C:\dev\my-game and run setup again."
    exit 1
}
Write-Host "ok  $repo"

Step "winget"
if (-not (Have winget)) {
    Write-Host "winget not found. Update 'App Installer' from the Microsoft Store, then run setup again." -ForegroundColor Red
    exit 1
}
Write-Host "ok  winget"

function Install-Pkg($id, $label, $version) {
    Write-Host "Installing $label ..."
    $args = @("install", "--id", $id, "-e", "--accept-package-agreements", "--accept-source-agreements")
    if ($version) { $args += @("--version", $version) }
    $ErrorActionPreference = "Continue"
    & winget @args | Out-Host
    $code = $LASTEXITCODE
    $ErrorActionPreference = "Stop"
    return $code
}

Step "git and GitHub CLI"
if (-not (Have git)) { Install-Pkg "Git.Git" "git" "" | Out-Null }
if (-not (Have gh))  { Install-Pkg "GitHub.cli" "GitHub CLI" "" | Out-Null }
Refresh-Path
if (-not (Have git) -or -not (Have gh)) {
    Write-Host "git or gh is still not on PATH. Close this window, open a new PowerShell and run setup again." -ForegroundColor Yellow
    exit 1
}
git config --global core.autocrlf false
if (-not (git config --global user.name))  { git config --global user.name  (Read-Host "Your name for commits") }
if (-not (git config --global user.email)) { git config --global user.email (Read-Host "Your email for commits") }
Write-Host "ok  $(git --version)"

Step "Godot $pin"
function Find-Godot {
    $roots = @("$env:LOCALAPPDATA\Microsoft\WinGet\Packages", "$env:LOCALAPPDATA\Microsoft\WinGet\Links", "C:\dev\tools")
    foreach ($r in $roots) {
        if (Test-Path $r) {
            $hit = Get-ChildItem $r -Recurse -Filter "Godot*_console.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($hit) { return $hit.FullName }
        }
    }
    return $null
}
$godot = Find-Godot
if (-not $godot) {
    $code = Install-Pkg "GodotEngine.GodotEngine" "Godot" $pin
    if ($code -ne 0) {
        Write-Host "Could not install Godot $pin through winget. Trying the latest version instead." -ForegroundColor Yellow
        Install-Pkg "GodotEngine.GodotEngine" "Godot (latest)" "" | Out-Null
    }
    $godot = Find-Godot
}
if (-not $godot) {
    Write-Host "Godot is installed but I could not find its console exe. Set GODOT_BIN by hand (see docs\dev_environment_setup.md)." -ForegroundColor Red
    exit 1
}
[Environment]::SetEnvironmentVariable("GODOT_BIN", $godot, "User")
$env:GODOT_BIN = $godot
$ver = (& $godot --version) 2>&1 | Select-Object -First 1
Write-Host "ok  GODOT_BIN = $godot  ($ver)"
if ($pin -and "$ver" -notmatch [regex]::Escape($pin)) {
    Write-Host "Version differs from the pinned $pin. Fix tools\godot.version or reinstall before you build much." -ForegroundColor Yellow
}

Step "Shortcuts (so Claude's Computer use can open the editor)"
$windowed = $godot -replace '_console\.exe$', '.exe'
if (-not (Test-Path $windowed)) { $windowed = $godot }
$shell = New-Object -ComObject WScript.Shell
$targets = @(
    (Join-Path ([Environment]::GetFolderPath("Programs")) "Godot.lnk"),
    (Join-Path ([Environment]::GetFolderPath("Desktop")) "Godot.lnk")
)
foreach ($lnk in $targets) {
    $s = $shell.CreateShortcut($lnk)
    $s.TargetPath = $windowed
    $s.Arguments = "-e --path `"$repo`""
    $s.WorkingDirectory = $repo
    $s.Save()
    Write-Host "ok  $lnk"
}

if ($KeepAwake) {
    Step "Power"
    powercfg /change standby-timeout-ac 0
    powercfg /change monitor-timeout-ac 0
    Write-Host "ok  no sleep and no screen-off while plugged in (undo in Windows power settings)"
}

Step "GitHub sign-in"
$ErrorActionPreference = "Continue"
& gh auth status *> $null
$signedIn = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = "Stop"
if (-not $signedIn) {
    Write-Host "A browser window will open. Sign in with the account (or token) that should own the game repo only."
    gh auth login --web
} else {
    Write-Host "ok  already signed in"
}

Step "Audit: what can Claude see on this machine?"
& "$PSScriptRoot\tools\audit.ps1"

Step "First check"
& "$PSScriptRoot\tools\check.ps1"

Write-Host ""
Write-Host "Setup finished. Open Claude Code in this folder and type /interview" -ForegroundColor Green
Write-Host "Still by hand: Computer use switch in the Claude desktop app, the cloud environment, the Android signing key (docs\dev_environment_setup.md)."
