#!/usr/bin/env bash
# tools/check.sh — one command to sanity-check the project before a commit.
# Run from the repo root: ./tools/check.sh
#
# Set GODOT_BIN once if `godot` isn't on your PATH, e.g.:
#   export GODOT_BIN=/path/to/godot
set -euo pipefail

GODOT="${GODOT_BIN:-godot}"

echo "== gdlint (GDScript style/lint, if installed) =="
if command -v gdlint >/dev/null 2>&1; then
    gdlint .
else
    echo "gdlint not found — skipping (pipx install gdtoolkit to enable)"
fi

echo "== Godot: headless script parse check =="
# One Godot run with autoloads registered - see tools/parse_all.gd for why
# per-file `--check-only` can't be used.
parse_exit=0
parse_output=$("$GODOT" --headless --path . --script res://tools/parse_all.gd 2>&1) || parse_exit=$?
echo "$parse_output" | grep -E 'PARSE FAILED|Parsed|SCRIPT ERROR' || true
if [ "$parse_exit" -ne 0 ]; then
    echo "One or more scripts failed to parse." >&2
    exit 1
fi

echo "== Scene smoke test: every scene runs 300 frames headless =="
# Catches anything that crashes on load or in the first seconds (a missing node, a bad
# resource, a script error in _ready/_process). Each scene prints one line.
smoke_failed=0
for scene in $(git ls-files '*.tscn'); do
    scene_output=$("$GODOT" --headless --path . --quit-after 300 "res://$scene" 2>&1) || true
    if echo "$scene_output" | grep -q "SCRIPT ERROR"; then
        echo "FAIL $scene"
        echo "$scene_output" | grep -A2 "SCRIPT ERROR" | head -12
        smoke_failed=1
    else
        echo "ok   $scene"
    fi
done
if [ "$smoke_failed" -ne 0 ]; then
    echo "One or more scenes raised a script error." >&2
    exit 1
fi

echo "== GUT tests (if the addon is installed) =="
if [ -d "addons/gut" ]; then
    "$GODOT" --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
else
    echo "GUT addon not installed yet — skipping automated tests."
fi

echo "All checks passed."
