#!/bin/sh
# Command for iTerm2's "Hotkey Window" profile. Replaces:
#   /opt/homebrew/bin/tmux -CC new-session -As hotkey
#
# Why: at login iTerm2 launches that profile TWICE — once because a hotkey window
# always exists, once because its own window restoration re-creates the window and
# re-runs its command. Two -CC clients on one session means every tmux window is
# rendered twice (overlapping windows) and the next attach dies with "Cannot Attach".
# Chasing iTerm's restoration switches did not hold: iTerm rewrites them on quit
# (NoSyncIgnoreSystemWindowRestoration went back to 1 by itself on 2026-07-14).
#
# So guard the attach instead: whoever gets there first owns the session; any later
# launch exits, and iTerm closes that window ("Close Sessions On End" is on).
# iTerm spawns this with a bare PATH (no login shell), hence the absolute path.
TMUX_BIN=/opt/homebrew/bin/tmux
LOCK=/tmp/tmux-hotkey-attach.lock

# Someone is already attached -> this is the duplicate launch.
if [ -n "$("$TMUX_BIN" list-clients -t hotkey 2>/dev/null)" ]; then
	exit 0
fi

# Both launches can reach here together before either registers a client, so let
# only the first one through. 5s covers the login burst without blocking a real
# re-attach later (detach, then hotkey again).
if [ -f "$LOCK" ]; then
	age=$(( $(date +%s) - $(stat -f %m "$LOCK" 2>/dev/null || echo 0) ))
	[ "$age" -lt 5 ] && exit 0
fi
date +%s > "$LOCK" 2>/dev/null

exec "$TMUX_BIN" -CC new-session -As hotkey
