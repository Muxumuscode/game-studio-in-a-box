---
name: sync
description: Start of a session. Fetch the latest main, say what is new, where we left off, and what to do next. Use when the owner types /sync or starts a session.
---

Sync the project and brief the owner. Do not change code.

1. `git fetch origin` and list what is new on `main` since the last pull, plus the current branch and anything unpushed.
2. Read `CLAUDE.md` and search `docs/decisions.md` for the latest entries (do not read it all).
3. If any new commit has a `Made-by: external` line, review its diff and run `tools/check`. Commits from Claude Code are trusted without extra checks.
4. Summarize in 5 lines: where we left off, what is merged, what is open, what you recommend next, and anything the owner must do by hand.
5. Wait for the owner's pick.
