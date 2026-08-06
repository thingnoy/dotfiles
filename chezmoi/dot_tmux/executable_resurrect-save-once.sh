#!/bin/sh
# Single-flight wrapper around tmux-resurrect's save.sh.
#
# Why: the client-detached hook fires once per client. When iTerm2 opens two
# hotkey windows (or macOS kills them together at shutdown), two saves run in
# the same second, write the same timestamped file, and interleave -> duplicate
# pane/window lines in the save, which would restore duplicated windows.
#
# mkdir is atomic, so only the first caller wins. A lock older than 1 minute is
# stale (previous run was SIGKILLed at shutdown) and gets cleared, otherwise a
# stale lock would silently disable every future save.
LOCK=/tmp/tmux-resurrect-save.lock

if [ -d "$LOCK" ] && [ -z "$(find "$LOCK" -maxdepth 0 -mmin -1 2>/dev/null)" ]; then
  rmdir "$LOCK" 2>/dev/null
fi

mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

"$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh"
