#!/usr/bin/env bash
# PURPOSE: Read-only list of what Claude Code can reach on this machine, so you can check the walls hold.
#          Changes nothing. Run it after setup and again after any change: ./tools/audit.sh
# EMITS: none
# DEPENDS ON: none
set -uo pipefail

section() { printf '\n-- %s --\n' "$1"; }

section "Folder Claude works in"
pwd

section "Top level of your home folder (anything personal here is readable)"
ls -1A "$HOME" 2>/dev/null | head -40

section "Mounted drives, shares and USB storage"
if command -v findmnt >/dev/null 2>&1; then
    findmnt -rno TARGET,FSTYPE | grep -Ev '^/(proc|sys|dev|run|snap)|tmpfs|cgroup|overlay' | head -20
else
    mount | grep -Ev 'proc|sysfs|devfs|tmpfs|autofs' | head -20
fi

section "Credentials lying around (names only)"
for f in "$HOME/.ssh" "$HOME/.aws" "$HOME/.config/gcloud" "$HOME/.kube" "$HOME/.gnupg" "$HOME/.netrc" "$HOME/.git-credentials"; do
    [ -e "$f" ] && echo "FOUND  $f"
done
env | cut -d= -f1 | grep -Ei 'token|secret|api_?key|password' | sed 's/^/ENV VAR  /' || true

section "Who is signed in"
git config --global user.name 2>/dev/null | sed 's/^/git name:  /'
git config --global user.email 2>/dev/null | sed 's/^/git email: /'
command -v gh >/dev/null 2>&1 && gh auth status 2>&1 | head -6

printf '\nRead the list above. Anything personal, any extra account, any share you do not need: remove or lock it down, then run this again.\n'
