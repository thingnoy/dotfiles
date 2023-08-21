#!/usr/bin/env bash

source "$HOME/.config/sketchybar/icons.sh"

#SKETCHBAR_BIN="/opt/homebrew/bin/sketchy_topbar"

# $SKETCHBAR_BIN --set $NAME label="$(date '+%Y-%m-%d %H:%M')"

ICON="󰅐"
LABEL=$(date '+%H:%M:%S')
sketchybar --set $NAME icon="$ICON" label="$LABEL"
