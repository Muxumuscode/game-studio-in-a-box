# CLAUDE.md

@CONVENTIONS.md

## Project
**[GAME NAME]**: [one line, filled in by /interview]. Genre, camera, core verb and the vertical slice live in
`docs/design/pitch.md` and `docs/design/vertical_slice.md` once /interview has written them.
Current goal: the vertical slice. Anything else goes to `docs/decisions.md` as "later", not into the code.

## The owner
Project lead and feel tester, not a programmer.
- Explain each change in plain language, one concept at a time.
- Flag anything the owner must do by hand as a numbered list.
- Push back on scope creep directly. Do not quietly go along with a bad idea.

## Workflow
- Never commit to main. One branch per task, named `task/<short-name>`. Commit often.
- Open a pull request and merge it only when the owner says "merge". Explain "pull request" the first time.
- Start every session with `/sync`. Before any new system or mechanic run `/grill-me` (it interviews the owner first). End the session with `/wrapup`.
- End every task with: files changed, how to test it (which scene, what to see), and the `tools/check` result.

## Correctness vs feel
- Correctness (crashes, logic, numbers) is yours: headless runs, `tools/check`, screenshots.
- Feel (is a window fair, does a dash snap, is a warning readable) is the owner's call. Never say something
  "feels right" from automated tests. Say what you verified and what still needs human hands.
- Use Computer use only for visual sanity checks (is it rendering, on screen, laid out right).

## Check before done
Run `tools/check` (`.ps1` on Windows, `.sh` elsewhere) before saying done. It must pass.
Never skip or weaken a check to get green.

## Playtest-ready
When a task is finished and `tools/check` passes:
1. Commit and push.
2. In a session running on the owner's machine, run `tools/playtest [scene]` so the game is open and waiting.
   In a cloud session skip this and say: pull, then open [scene] and press F6.
3. End the message with the scene name, the controls, and 2 to 4 feel questions.
4. Never launch while a check or build is failing. Ask first if the owner may be mid-task.
5. Say plainly that an open window proves it runs, not that it feels right.

## Saving subscription limits
- The owner is on a plan, not a paid API. Never suggest pay-per-token tools. Prefer short sessions, no mid-session model switches.
- Default model is Sonnet. For design or architecture questions that merit a stronger model, stay on Sonnet, end your
  answer with "Opus: yes/no" and a one-line reason, and wait. On yes, write a short brief (question, files, constraints,
  wanted output) and run it as a one-shot Opus subagent. Save the memo in `docs/design/` if worth keeping.
- Mechanical tasks (rename, data tweak, one-file fix that `tools/check` can verify) may go to a cheap helper only when
  they touch 1-2 files and involve no combat timing, architecture or feel. Otherwise do them directly.
- Long chats re-read all history on every message: keep sessions short, one task each, and let `docs/decisions.md` be the memory.

## Memory across cleared chats
The owner may clear chats to save tokens. Keep `docs/decisions.md` (dated decisions and why) and `docs/design/` true.
Do not make the owner re-explain what is written there.
