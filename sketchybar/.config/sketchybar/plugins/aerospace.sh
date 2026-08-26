#!/bin/zsh

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# $FOCUSED_WORKSPACE comes from the aerospace_workspace_change event.
# Fallback: query aerospace directly (used on the initial --update, where no
# event has fired yet).
FOCUSED="${FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused)}"

if [ "$1" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" background.drawing=on label.color=0xffffffff
else
    sketchybar --set "$NAME" background.drawing=off label.color=0xff888888
fi
