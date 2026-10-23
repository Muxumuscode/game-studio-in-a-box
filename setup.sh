#!/usr/bin/env bash
# setup.sh - one-command setup of the game studio on Linux (apt) or macOS (brew).
# Run from the repo root:  ./setup.sh
# It installs git, GitHub CLI and Godot (pinned in tools/godot.version), sets GODOT_BIN in your shell profile,
# signs you in to GitHub, audits what Claude can see, and runs the first check.
# It does NOT install Claude Code or create accounts: do those first (see README.md).
set -euo pipefail
cd "$(dirname "$0")"
REPO="$PWD"
PIN="$(head -n1 tools/godot.version 2>/dev/null || true)"

step() { printf '\n== %s ==\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

step "Folder"
case "$REPO" in
    *" "*) echo "This folder path has a space: $REPO. Move the repo somewhere like ~/dev/my-game and run setup again."; exit 1 ;;
esac
echo "ok  $REPO"

OS="$(uname -s)"
step "Packages ($OS)"
if [ "$OS" = "Darwin" ]; then
    have brew || { echo "Homebrew not found. Install it from https://brew.sh then run setup again."; exit 1; }
    have git || brew install git
    have gh  || brew install gh
    # Homebrew installs the current Godot, not necessarily the pinned one: the version check below warns.
    have godot || [ -d "/Applications/Godot.app" ] || brew install --cask godot
elif [ "$OS" = "Linux" ]; then
    have apt-get || { echo "This script supports apt-based Linux. Install git, gh and Godot by hand, then run tools/check.sh."; exit 1; }
    sudo apt-get update -y
    have git || sudo apt-get install -y git
    have curl || sudo apt-get install -y curl
    have unzip || sudo apt-get install -y unzip
    if ! have gh; then sudo apt-get install -y gh || echo "gh is not in your apt sources: see https://cli.github.com for the install steps."; fi
else
    echo "Unsupported system: $OS. On Windows run setup.ps1."; exit 1
fi
git config --global core.autocrlf input
[ -n "$(git config --global user.name || true)" ]  || { read -r -p "Your name for commits: " n;  git config --global user.name "$n"; }
[ -n "$(git config --global user.email || true)" ] || { read -r -p "Your email for commits: " e; git config --global user.email "$e"; }

step "Godot $PIN"
GODOT=""
if have godot; then
    GODOT="$(command -v godot)"
elif [ -x "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
elif [ "$OS" = "Linux" ]; then
    dest="$HOME/.local/godot"
    mkdir -p "$dest"
    url="https://github.com/godotengine/godot/releases/download/${PIN}-stable/Godot_v${PIN}-stable_linux.x86_64.zip"
    echo "Downloading $url"
    curl -fL "$url" -o "$dest/godot.zip"
    unzip -o -q "$dest/godot.zip" -d "$dest"
    GODOT="$(ls "$dest"/Godot_v*linux.x86_64 | head -n1)"
    chmod +x "$GODOT"
fi
[ -n "$GODOT" ] || { echo "Could not find or install Godot. Set GODOT_BIN by hand (docs/dev_environment_setup.md)."; exit 1; }
export GODOT_BIN="$GODOT"
PROFILE="$HOME/.bashrc"; [ "$OS" = "Darwin" ] && PROFILE="$HOME/.zshrc"
grep -q 'GODOT_BIN=' "$PROFILE" 2>/dev/null || echo "export GODOT_BIN=\"$GODOT\"" >> "$PROFILE"
ver="$("$GODOT" --version | head -n1)"
echo "ok  GODOT_BIN=$GODOT ($ver)"
case "$ver" in *"$PIN"*) ;; *) echo "Version differs from the pinned $PIN. Fix tools/godot.version or reinstall before you build much." ;; esac

step "GitHub sign-in"
if have gh && ! gh auth status >/dev/null 2>&1; then
    echo "A browser (or a code to paste) will open. Sign in with the account or token that should own the game repo only."
    gh auth login --web
else
    echo "ok  already signed in (or gh missing: see above)"
fi

step "Audit: what can Claude see on this machine?"
bash tools/audit.sh

step "First check"
bash tools/check.sh

printf '\nSetup finished. Open Claude Code in this folder and type /interview\n'
echo "Still by hand: the cloud environment and the Android signing key (docs/dev_environment_setup.md)."
