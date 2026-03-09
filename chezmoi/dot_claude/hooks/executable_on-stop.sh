#!/bin/bash
INPUT=$(cat)

# Mute check
[ -f ~/.claude/mute ] && exit 0

# Prevent infinite loops
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

PHRASES=(
  "Construction complete"
  "Unit ready"
  "Mission accomplished"
  "Training complete"
  "New construction options"
  "Upgrade complete"
)

RANDOM_INDEX=$((RANDOM % ${#PHRASES[@]}))

# Speech lock to prevent overlapping voices
LOCK=~/.claude/.say-lock
if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  exit 0
fi

say "[[volm 0.3]] ${PHRASES[$RANDOM_INDEX]}" &
echo $! > "$LOCK"
exit 0
