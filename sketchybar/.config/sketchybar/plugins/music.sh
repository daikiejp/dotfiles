#!/bin/zsh
# ==============================================================================
# Apple Music for Sketchybar
# DaikieJP - 2026
# !IMPORTANT: Adapt this script to your own needs.
# NOTE: Music icons are from Hack Nerd Font
# https://www.nerdfonts.com/cheat-sheet
# ==============================================================================

# ==============================================================================
# Api Configuration
# ==============================================================================

INFO_FILE="/tmp/music_info.txt"
LAST_SENT="/tmp/music_last_sent.txt"
DAIKIE_SONGPLAYED_URL=$(grep "DAIKIE_SONGPLAYED_URL" "$HOME/.daikie" | cut -d'=' -f2 | tr -d '[:space:]')
DAIKIE_TOKEN=$(grep "DAIKIE_TOKEN" "$HOME/.daikie" | cut -d'=' -f2 | tr -d '[:space:]')

# Check if Music app is running
if ! pgrep -x Music > /dev/null; then
    sketchybar --set music drawing=off
    exit 0
fi

# Ensure monitor is running
if ! pgrep -f "music_monitor_file" > /dev/null; then
    ~/.config/sketchybar/plugins/music_monitor_file > /dev/null 2>&1 &
    sleep 1
fi

# Read info file
if [[ -f "$INFO_FILE" ]] && [[ -s "$INFO_FILE" ]]; then
    TITLE=$(grep "^title:" "$INFO_FILE" | cut -d: -f2- | xargs)
    ARTIST=$(grep "^artist:" "$INFO_FILE" | cut -d: -f2- | xargs)
    STATE=$(grep "^state:" "$INFO_FILE" | cut -d: -f2- | xargs)
    ALBUM=$(grep "^album:" "$INFO_FILE" | cut -d: -f2- | xargs)
    TIMESTAMP=$(grep "^timestamp:" "$INFO_FILE" | cut -d: -f2- | xargs)

    if [[ -n "$TITLE" ]]; then
        ICON=""
        [[ "$STATE" == "Paused" ]] && ICON=""

        # --- Create unique song identifier (without timestamp) ---
        SONG_ID="${TITLE}|${ARTIST}|${ALBUM}"
        CURRENT_HASH=$(echo "$SONG_ID" | shasum | awk '{print $1}')

        # --- Check last sent song ---
        LAST_HASH=$(cat "$LAST_SENT" 2>/dev/null || echo "")

        # Only send if the SONG changed (not just timestamp or state)
        if [[ "$CURRENT_HASH" != "$LAST_HASH" ]]; then
            # Prepare data to send
            DATA=$(jq -n \
                --arg title "$TITLE" \
                --arg artist "$ARTIST" \
                --arg album "$ALBUM" \
                --arg timestamp "$TIMESTAMP" \
                '[{title: $title, artist: $artist, albumTitle: $album, playbackTime: $timestamp}]')

            # Send to server
            curl -s -X POST "$DAIKIE_SONGPLAYED_URL" \
                -H "Authorization: Bearer $DAIKIE_TOKEN" \
                -H "Content-Type: application/json" \
                -d "$DATA"

            # Update last sent hash
            echo "$CURRENT_HASH" > "$LAST_SENT"
        fi

        # --- Show Bar and cut Longers Title / Artists ---
        [[ ${#TITLE} -gt 20 ]] && TITLE="${TITLE:0:20}…"
        [[ ${#ARTIST} -gt 15 ]] && ARTIST="${ARTIST:0:15}…"

        LABEL="${TITLE} - ${ARTIST}"
        [[ -z "$ARTIST" ]] && LABEL="$TITLE"

        sketchybar --set music icon="$ICON" label="$LABEL" drawing=on
    else
        sketchybar --set music drawing=off
    fi
else
    sketchybar --set music drawing=off
fi
