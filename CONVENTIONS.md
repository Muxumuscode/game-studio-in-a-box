# CONVENTIONS

## Engine
- Godot version pinned in `tools/godot.version`. GDScript only (no C#). Renderer: Compatibility.
- Install the SAME version on every machine and in the cloud. A mismatch is the most common cause of "works here, not there".
- This is Godot 4: no Godot 3 syntax.

## Code style
- Static types on every var, parameter and return: `func take_damage(amount: int) -> void:`
- Files: snake_case.gd. Classes: `class_name PascalCase`. Signals in past tense (`died`, `parried`).
- Aim for about 300 lines per file at most. Split when a file is hard to read.
- Every script starts with a header:
  ```
  # PURPOSE: one sentence
  # EMITS: signal list (or none)
  # DEPENDS ON: data resource / autoloads used (or none)
  ```

## Architecture
- No gameplay numbers in code. Speeds, damage, timings and cooldowns live in `data/*.tres` and are read as `stats.move_speed`.
- "Signals up, calls down": children emit signals, parents call children's functions.
- Input only through Input Map action names, never raw keys or buttons.
- Every new system gets its own `*_sandbox.tscn` that runs alone with F6.

## Do not edit unless the task names them
- `project.godot`, `export_presets.cfg`, `.godot/`, `addons/`, any keystore.
- Scene files (`*.tscn`) by hand: give the owner the exact editor steps, or generate them with a script.
- Never put a real keystore password in git. Use a gitignored credentials file.

## Before saying done
- `tools/check` passes.
- If the change needs a feel test, say which scene to open and what to see (or launch it per CLAUDE.md "Playtest-ready").
- Commit message: `<area>: <what changed>`, for example `parry: widen window, read from stats`.
