#!/bin/zsh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

ICON=
ampm=$(date +"%p")

if [ "$ampm" = "AM" ]; then
    jp_ampm="午前"
else
    jp_ampm="午後"
fi

sketchybar --set clock icon="$ICON" label="$(LC_TIME=ja_JP.UTF-8 date '+%m月%d日(%a)') $jp_ampm$(date +'%I:%M')"
#sketchybar --set "$NAME" label="JapaCode $jp_ampm$(date +'%I:%M')"

