#!/usr/bin/env bash
# PURPOSE: Installs the pinned Godot (and a virtual display for screenshots) in a Claude Code cloud session.
#          Run by the SessionStart hook in .claude/settings.json. Does nothing on your own machine.
# EMITS: none
# DEPENDS ON: tools/godot.version; the cloud environment must allow github.com and its release downloads.
set -euo pipefail

[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0   # only cloud sessions

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/..}"
PIN="$(head -n1 tools/godot.version)"
DEST="$HOME/.local/godot"
GODOT="$DEST/godot"

if [ ! -x "$GODOT" ]; then
    mkdir -p "$DEST"
    url="https://github.com/godotengine/godot/releases/download/${PIN}-stable/Godot_v${PIN}-stable_linux.x86_64.zip"
    curl -fL "$url" -o "$DEST/godot.zip" || { echo "Godot download failed. Allow github.com in the environment's network settings." >&2; exit 0; }
    unzip -o -q "$DEST/godot.zip" -d "$DEST"
    mv "$DEST"/Godot_v*linux.x86_64 "$GODOT"
    chmod +x "$GODOT"
fi

command -v xvfb-run >/dev/null 2>&1 || { sudo apt-get update -y -q && sudo apt-get install -y -q xvfb; } || true

# Make GODOT_BIN visible to every later command in the session.
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
    echo "export GODOT_BIN=\"$GODOT\"" >> "$CLAUDE_ENV_FILE"
fi
echo "Godot ready: $("$GODOT" --version | head -n1)"
