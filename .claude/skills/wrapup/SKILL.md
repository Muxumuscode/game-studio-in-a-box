---
name: wrapup
description: End of a task or session. Checks, commits, pushes, opens a pull request and gives the owner the test steps. Use when the owner types /wrapup.
---

1. Run `tools/check`. If it fails, fix it. Never weaken the check.
2. Commit and push the task branch. Open a pull request with a plain-language description. Do not merge until the owner says "merge".
3. Add what the owner needs to test to `docs/playtest_todo.md` (what to try, what they should see).
4. Record any decision made in `docs/decisions.md` (dated, with the reason).
5. Reply with: files changed, how to test, what is by hand for the owner, and a 5-line project state (goal, decisions made, remaining, open questions, next step).
6. Follow "Playtest-ready" in `CLAUDE.md` if a scene is ready to try.
