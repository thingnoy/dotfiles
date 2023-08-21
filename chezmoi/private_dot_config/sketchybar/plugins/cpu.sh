#!/usr/bin/env sh

#SKETCHBAR_BIN="/opt/homebrew/bin/sketchy_topbar"

# TOPPROC=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ print $3 + $5"%" }' | cut -d "." -f1)
TOPPROC=$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')

$SKETCHBAR_BIN --set $NAME icon="󰍛" label="$TOPPROC%"
