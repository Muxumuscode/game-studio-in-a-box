#!/usr/bin/env bash
# PURPOSE: Opens the game (or one scene) in a normal window and leaves it running, so a passing
#          build is waiting for the owner. First closes any headless Godot left over from tests.
#          Usage: ./tools/playtest.sh [scene]   e.g. ./tools/playtest.sh levels/zona_colonial/arena_01.tscn
#          No scene = the game's main scene (the title screen).
# EMITS: none
# DEPENDS ON: Godot (GODOT_BIN or `godot` on PATH). Needs a desktop session; not for cloud/SSH.
set -euo pipefail
cd "$(dirname "$0")/.."

GODOT="${GODOT_BIN:-godot}"
if ! command -v "$GODOT" >/dev/null 2>&1; then
    echo "Godot not found. Set GODOT_BIN to the Godot executable." >&2
    exit 1
fi

scene="${1:-}"
scene="${scene#res://}"
args=(--path "$PWD")
if [ -n "$scene" ]; then
    if [ ! -f "$scene" ]; then
        echo "Scene not found: $scene (path is relative to the project root)" >&2
        exit 1
    fi
    args+=("res://$scene")
fi

# Close only headless Godot runs (test leftovers). A Godot window you have open stays alone.
# Matches on the process NAME (not the whole command line), so a shell that merely mentions
# "godot --headless" in its own command is never touched.
closed=0
for pid in $(pgrep -i godot || true); do
    if ps -o args= -p "$pid" 2>/dev/null | grep -q -- '--headless'; then
        echo "Closing leftover headless Godot (pid $pid)"
        kill "$pid" 2>/dev/null || true
        closed=1
    fi
done
[ "$closed" -eq 1 ] && sleep 1

nohup "$GODOT" "${args[@]}" >/dev/null 2>&1 &
disown

echo "Game launched: ${scene:-main scene (title screen)}"
echo "It keeps running after this command ends. Close the window when you are done."
echo "What to try: see docs/playtest_todo.md."
