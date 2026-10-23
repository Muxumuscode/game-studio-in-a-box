# Machine setup

How this machine was set up, and the few steps only a person can do. Claude keeps this file true.

## Done by setup.ps1 / setup.sh
- git, GitHub CLI and Godot installed (Godot version pinned in `tools/godot.version`).
- `GODOT_BIN` set to the Godot console exe (Windows) or binary. Open a new terminal after setup to see it.
- Windows: Start-menu and Desktop shortcut named "Godot" that opens this project in the editor (Claude's Computer use only finds apps in the Start menu).
- GitHub sign-in, an audit of what Claude can see (`tools/audit`), and a first `tools/check`.

## By hand (nothing can do these for you)
1. **Computer use** (optional, Windows/macOS desktop app only): Claude desktop app, Settings, Desktop app, turn on Computer use. It is off by default. Approve the prompts the first time.
2. **Cloud environment** (optional): claude.ai/code, connect GitHub, install the Claude GitHub app on the repo, create an environment. Allow `github.com` in its network settings so `tools/cloud_setup.sh` can download Godot.
3. **Sleep**: for "the game is already open when I come back", turn off sleep and lock while plugged in (`.\setup.ps1 -KeepAwake` does this on Windows).
4. **Android builds** (optional, later): JDK 17, the Android command-line tools, the Godot export templates matching the exact version, and a release signing key. Keep the key out of git and back it up in two places: if it is lost, every installed copy has to be uninstalled. Ask Claude to write the steps here when you get there.

## Gotchas
- A repo path with a space breaks the Android tools. Use `C:\dev\my-game`.
- A fresh terminal does not see something installed a minute ago. Open a new one.
- Windows PowerShell 5.1 fails on non-ASCII characters in a script without a BOM. Keep `.ps1` files ASCII.
- A locked or sleeping machine will start the game and nobody will see it.
