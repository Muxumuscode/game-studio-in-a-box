# Game Studio in a Box: project template

A Godot 4 project that Claude Code can build, check and hand to you for playtesting. It is the starter
kit behind the "Game Studio in a Box" guide. Everything the guide's old prompts used to create is already here.

**Status: staged.** Tested on Linux with Godot 4.7.2: `publish.sh`, `tools/check.sh` (lint, parse, smoke test all pass on the
sample scene), `tools/audit.sh` and `tools/cloud_setup.sh` (it downloaded and ran Godot in a cloud session). NOT yet run:
`setup.ps1` (Windows), `setup.sh` on a clean Linux or Mac machine, `tools/audit.ps1`, `tools/playtest.*` with a real window,
and the `.claude/skills` commands in a fresh project. Run the test below before you rely on them.

## What you do (the whole setup)

1. Make a GitHub account and a Claude account on a plan that includes Claude Code. (By hand.)
2. Pick the machine: a dedicated old laptop (best), a virtual machine, or your everyday PC.
3. Install Claude Code on it and sign in. (By hand, once.)
4. On GitHub, click **Use this template** and name your game's repo. Clone it into a folder with no spaces
   (`C:\dev\my-game`).
5. In that folder run `.\setup.ps1` (Windows) or `./setup.sh` (Mac/Linux). It installs git, gh and Godot,
   sets `GODOT_BIN`, makes the shortcuts, signs you in to GitHub, audits the machine and runs the first check.
6. Open Claude Code in the folder and type `/interview`. It asks about your game and writes the pitch.

Cloud sessions need nothing more: `.claude/settings.json` installs Godot on session start.
Anything else that needs your hands (Computer use switch, cloud environment, signing key) is listed in `docs/dev_environment_setup.md`.

## What is in the box

| Path | What it is |
|---|---|
| `CLAUDE.md`, `CONVENTIONS.md` | The project rules every session reads first |
| `tools/check.ps1`, `tools/check.sh`, `tools/parse_all.gd` | Lint, parse every script, run every scene 300 frames |
| `tools/playtest.ps1`, `tools/playtest.sh` | Open the game in a window and leave it waiting |
| `tools/audit.ps1`, `tools/audit.sh` | Read-only list of what Claude can see on this machine |
| `tools/cloud_setup.sh` | Installs the pinned Godot in cloud sessions |
| `tools/godot.version` | The one place the Godot version is pinned |
| `.claude/skills/` | Slash commands: `/interview`, `/sync`, `/grill-me`, `/feature`, `/feel`, `/look`, `/wrapup` |
| `.claude/settings.json` | Cloud install hook and a few deny rules for sensitive folders |
| `docs/` | Decision log, playtest table, machine setup notes |
| `project.godot`, `scenes/hello.tscn` | A tiny runnable project so the first check has something to test |

## Test it before you trust it

On a clean machine (the spare laptop or a fresh VM snapshot):

1. Run `setup`. Note every step that failed or asked something unexpected.
2. Run `tools/check` and `tools/playtest.ps1 scenes/hello.tscn`. A window should open and the check should print `All checks passed.`
3. Start a cloud session on the repo and confirm `godot --version` works there.
4. Fix what broke here, and update the guide.

## Publishing

Copy this folder's contents to a new GitHub repo, then Settings, General, tick **Template repository**.
`tools/godot.version` is the file to bump when Godot changes. Re-test the template each time.
