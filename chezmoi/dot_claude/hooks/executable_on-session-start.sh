#!/bin/bash

# Mute check
[ -f ~/.claude/mute ] && exit 0

# Speech lock to prevent overlapping voices
LOCK=~/.claude/.say-lock
if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  exit 0
fi

PHRASES=(
  "Establishing battlefield control, standby"
  "Command and control ready"
  "Battle control online"
  "Systems operational"
  "Ready and waiting, commander"
)

RANDOM_INDEX=$((RANDOM % ${#PHRASES[@]}))
say "[[volm 0.3]] ${PHRASES[$RANDOM_INDEX]}" &
echo $! > "$LOCK"
exit 0
