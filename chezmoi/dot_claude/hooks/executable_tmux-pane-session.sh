#!/bin/bash
# Record: which Claude conversation is running in which tmux pane.
#
# Why: tmux-resurrect saves a pane's argv as reported by `ps` — for a Claude
# pane that is just `claude --dangerously-skip-permissions`, with no session id
# in it. On restore it replays that verbatim, so every pane comes back as a
# brand-new conversation (hit 2026-08-12 after a reboot: 4 panes in
# a-chieve-id, right cwd, 4 fresh sessions).
#
# `--continue` can't fix it: it means "newest conversation in this directory",
# so 4 panes sharing one cwd would all attach to the same conversation.
#
# So each session stamps its own pane here, and the resurrect post-save-layout
# hook (~/.tmux/resurrect-inject-claude-session.sh) rewrites the saved command
# to `... --resume <id>` at save time.
#
# Fires on SessionStart (covers startup, /clear, resume — the id is re-stamped
# whatever it turns out to be, so this never needs to know whether --resume
# keeps the id or forks a new one) and on UserPromptSubmit, so a pane whose
# claude was already running before this hook existed registers itself the
# moment it's used. lsof can't recover those: Claude closes the transcript
# between writes, so a running session holds no open .jsonl to read the id from.
#
# Format: <session_id>\t<cwd>\t<tmux server pid>
# The server pid guards against %pane-id reuse across reboots.

[ -n "$TMUX_PANE" ] || exit 0

input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
[ -n "$sid" ] || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // .workspace.current_dir // empty' 2>/dev/null)
[ -n "$cwd" ] || cwd="$PWD"

# $TMUX is "<socket>,<server pid>,<session>" — same number as
# `tmux display -p '#{pid}'`, without paying for a subprocess on every turn.
IFS=, read -r _ srv _ <<< "$TMUX"
[ -n "$srv" ] || exit 0

# Keyed by server pid as well as pane: %ids are per-server, so a second tmux
# server (a throwaway `tmux -L test` will do — it sources this same tmux.conf
# and continuum restores the whole layout into it) would otherwise overwrite
# every live pane's stamp with its own.
d="$HOME/.claude/tmux-panes"
f="$d/$srv-${TMUX_PANE#%}"

# UserPromptSubmit fires every turn but the stamp almost never changes.
IFS=$'\t' read -r have_sid _ have_srv 2>/dev/null < "$f"
[ "$have_sid" = "$sid" ] && [ "$have_srv" = "$srv" ] && exit 0

mkdir -p "$d" || exit 0
printf '%s\t%s\t%s\n' "$sid" "$cwd" "$srv" > "$f"

exit 0
