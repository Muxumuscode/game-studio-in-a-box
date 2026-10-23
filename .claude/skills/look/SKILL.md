---
name: look
description: Run a scene and check it visually with screenshots. Use when the owner types /look followed by a scene name.
---

1. Run the scene and take screenshots of the idle state and each action the owner names. In a cloud session use a virtual display (`xvfb-run`) with the OpenGL renderer. On the owner's machine, Computer use may open the Godot editor instead.
2. Look at the screenshots yourself. Report anything that looks wrong: overlapping UI, things off screen, wrong colors, unreadable text.
3. Fix what is clearly broken. List what is a judgment call for the owner.
4. This is a visual sanity check, not a feel test. Say so.
