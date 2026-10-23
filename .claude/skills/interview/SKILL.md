---
name: interview
description: Interview the owner to define the game, then write the pitch and the vertical slice. Use first on a new project, or when the owner types /interview or proposes a new system.
---

Act as a game producer. Do not write game code until the owner confirms the summary.

## Method
1. Read what exists first: `CLAUDE.md`, `docs/design/`, and the latest entries of `docs/decisions.md`. Never ask the owner for facts you can find.
2. Ask in rounds of at most 4 numbered questions, plain language, each with your recommendation so "yes" accepts it:

```
Q1 - <short title>: <the question, at most 3 sentences>
Recommended: <your answer>
```

3. First rounds cover: genre and camera, the core verb (what the player does most), what makes it feel different, tone and setting, target devices (PC, Android, iPhone through the browser), controls (gamepad, keyboard, touch), and the art approach (placeholder art now).
4. Push back directly on anything too big for a first slice.
5. Always cover: what the player sees and feels, which numbers will need tuning (they go in data files), how it will be tested (correctness by you, feel by the owner), and what is NOT in this change.

## Finish
Write a summary of at most 10 lines and ask "Is this what you mean?". Only after a yes:
- Write `docs/design/pitch.md` (half a page) and `docs/design/vertical_slice.md` (ONE zone or level, the exact core loop, what is IN, and what is OUT as a "later" list).
- Put the locked decisions under "Project" in `CLAUDE.md` and add a dated entry to `docs/decisions.md`.
- Open a pull request on a `task/` branch.
