#!/bin/bash
INPUT=$(cat)

# Mute check
[ -f ~/.claude/mute ] && exit 0

# Only speak when Claude actually needs us back (permission/attention/approval).
# Skip idle "Claude is waiting for your input" — it's 67% of notifications and the noise source.
MSG=$(echo "$INPUT" | jq -r '.message // empty' 2>/dev/null)
case "$MSG" in
  *"needs your"*) ;;   # pass → speak
  *) exit 0 ;;          # idle / login / other → stay silent
esac

# Speech lock to prevent overlapping voices
LOCK=~/.claude/.say-lock
if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  exit 0
fi

PHRASES=(
  "Awaiting orders"
  "Ready and waiting"
  "Standing by"
  "Reporting"
  "At your command"
)

RANDOM_INDEX=$((RANDOM % ${#PHRASES[@]}))
say "[[volm 0.8]] ${PHRASES[$RANDOM_INDEX]}" &
echo $! > "$LOCK"
exit 0
