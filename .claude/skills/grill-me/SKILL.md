---
name: grill-me
description: Interview the owner about a feature or design idea until it is clear, before any code is written. Use when the owner types /grill-me, or before building any new system, mechanic or large change.
---

Interview the owner until you both understand the same thing. Do not write code, files or plans until they confirm.

## Method
1. First read what already exists: `CLAUDE.md`, the matching file in `docs/design/`, and `docs/decisions.md` (search it, do not read it all). Facts you can find yourself are never questions for the owner.
2. List the decisions as a tree: some questions only make sense after others are answered.
3. Ask one **round** at a time: every question that does not depend on an unanswered one. Number them. Format:

```
Q1 - <short title>: <the question, plain language, at most 3 sentences>
Recommended: <your answer, worded so that "yes" accepts it>
```

4. Wait for the answers, then ask the next round. Keep rounds to 4 questions or fewer.
5. Push back where it applies: say directly if an idea is scope creep for the vertical slice, clashes with a recorded decision, or can be tested more cheaply (a sandbox scene, a headless test).
6. Always cover: what the player sees and feels; which numbers will need tuning (they go in data files); how it will be tested (correctness by you, feel by the owner); and what is NOT in this change.

## Finish
When no open questions remain, write a summary of at most 10 lines: the decision, what is in, what is out. Ask "Is this what you mean?". Only after a yes, record it in `docs/decisions.md` (dated entry) and start the work.

## Where it fits in the development cycle
`/interview` defines the game once. `/grill-me` runs before every new system or mechanic after that. Then `/feature` builds it, `/feel` tunes it, `/wrapup` closes the task.
