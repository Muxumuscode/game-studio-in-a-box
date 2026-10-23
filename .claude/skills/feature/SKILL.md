---
name: feature
description: Ask for a new feature safely. Grills the idea and checks it against the vertical slice before any code. Use when the owner types /feature followed by an idea.
---

1. Is the idea inside `docs/design/vertical_slice.md`? If not, say so, add it to the "later" list in `docs/decisions.md`, and stop.
2. If it is a new system, a new mechanic, or anything that touches several files, run the `/grill-me` method first and wait for the owner's confirmed summary. Small, obvious tweaks skip this step.
3. Propose the smallest version in 5 bullets and wait for the owner's yes.
4. Then build it on its own branch (`task/<name>`) with its own `*_sandbox.tscn` (CONVENTIONS.md), numbers in data files.
5. Verify it yourself: `tools/check`, a headless run, screenshots. Fix what you find.
6. Finish with how to test it and 2 to 4 feel questions. Follow "Playtest-ready" in `CLAUDE.md`.
