#!/bin/bash
# tmux-resurrect @resurrect-hook-post-save-layout
#
# Rewrites the save file that resurrect just wrote, turning
#   :claude --dangerously-skip-permissions
# into
#   :claude --dangerously-skip-permissions --resume <session id>
# so a restored pane comes back on its own conversation instead of a new one.
#
# The pane -> session id map is written by the Claude SessionStart hook
# ~/.claude/hooks/tmux-pane-session.sh.
#
# post-save-layout, not post-save-all: it runs BEFORE resurrect's
# files_differ / `last` symlink step and receives the file path as $1, so the
# rewritten content is what gets compared and linked. post-save-all runs after
# that decision — and after an identical save has already been deleted.
#
# Three guards. Any one failing leaves the line untouched, i.e. falls back to
# today's behaviour (fresh session) rather than to a broken one:
#   1. tmux server pid matches  -> %pane ids from a previous boot can't apply
#   2. saved cwd matches        -> pane id reused by another project can't apply
#   3. transcript .jsonl exists -> --resume can't fail on a deleted conversation
#
# A failed restore is survivable anyway: resurrect uses send-keys, so a pane
# whose command exits just sits at the shell prompt.

f="$1"
[ -f "$f" ] || exit 0

mapdir="$HOME/.claude/tmux-panes"
[ -d "$mapdir" ] || exit 0

srv=$(tmux display -p '#{pid}' 2>/dev/null) || exit 0
[ -n "$srv" ] || exit 0

tbl=$(mktemp "${TMPDIR:-/tmp}/resurrect-claude.XXXXXX") || exit 0
trap 'rm -f "$tbl" "$tbl.out"' EXIT

# Entries are keyed <server pid>-<pane number>; drop ones no server has touched
# in a month so the directory can't grow without bound.
find "$mapdir" -type f -mtime +30 -delete 2>/dev/null

# "session:window.pane" -> session id, for live panes with a usable map entry
while IFS=$'\t' read -r pane_id key; do
  entry="$mapdir/$srv-${pane_id#%}"
  [ -f "$entry" ] || continue
  IFS=$'\t' read -r sid cwd esrv < "$entry" || continue
  [ -n "$sid" ] && [ "$esrv" = "$srv" ] || continue
  compgen -G "$HOME/.claude/projects/*/$sid.jsonl" > /dev/null || continue
  printf '%s\t%s\t%s\n' "$key" "$sid" "$cwd" >> "$tbl"
done < <(tmux list-panes -a -F '#{pane_id}'$'\t''#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null)

[ -s "$tbl" ] || exit 0

# Save format is 11 tab-separated fields:
#   pane  session  window  win_active  win_flags  pane_index  title  :dir  pane_active  cmd  :full_command
awk -F'\t' -v OFS='\t' -v tbl="$tbl" '
BEGIN {
  while ((getline line < tbl) > 0) {
    split(line, a, "\t"); sid[a[1]] = a[2]; dir[a[1]] = a[3]
  }
}
$1 != "pane" { print; next }
{
  key = $2 ":" $3 "." $6
  cmd = $11
  d = substr($8, 2); gsub(/\\ /, " ", d)          # strip leading ":" and resurrect'"'"'s space escaping
  if (cmd ~ /^:claude([[:space:]]|$)/ && cmd !~ /(--resume|--continue|-r[[:space:]]|-c[[:space:]])/ &&
      (key in sid) && dir[key] == d)
    $11 = cmd " --resume " sid[key]
  print
}
' "$f" > "$tbl.out" || exit 0

[ -s "$tbl.out" ] && cat "$tbl.out" > "$f"
exit 0
