---
name: feel
description: Turn the owner's feel notes into concrete data changes. Use when the owner types /feel followed by how something felt.
---

The owner is reporting how something feels in their own words. Turn it into changes, nothing more.

1. Restate each note as a measurable change (for example "dodge starts too slow" becomes "dodge startup frames lower").
2. Prefer editing data files (`data/*.tres`) over code. Show old and new values in a table.
3. Change only what the owner mentioned.
4. Apply it, run `tools/check`, and say exactly what to re-test and what to look for.
5. Do not claim the new values feel right. Only the owner can say that.
