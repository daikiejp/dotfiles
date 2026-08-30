#!/bin/zsh

# ==============================================================================
# Wakatime for Sketchybar
# DaikieJP - 2026
# !IMPORTANT: Adapt this script to your own needs.
# ==============================================================================

# ==============================================================================
# Api Configuration
# ==============================================================================

DAIKIE_FILE="$HOME/.daikie"
WAKATIME_FILE="$HOME/.wakatime.cfg"

# On a fresh machine there are no credentials yet: hide the module instead of
# spamming the sketchybar log with failed greps and empty requests.
if [[ ! -f "$WAKATIME_FILE" ]] || [[ ! -f "$DAIKIE_FILE" ]]; then
    sketchybar --set wakatime drawing=off
    exit 0
fi

API_KEY=$(grep "api_key" "$WAKATIME_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
DATE=$(date +%Y-%m-%d)
AUTH=$(echo -n "$API_KEY:" | base64)
API_WAKATIME_URL=$(grep "API_WAKATIME_URL" "$DAIKIE_FILE" | cut -d'=' -f2- | tr -d '[:space:]')

# The files exist but the keys are still empty (placeholders)
if [[ -z "$API_KEY" ]] || [[ -z "$API_WAKATIME_URL" ]]; then
    sketchybar --set wakatime drawing=off
    exit 0
fi

response=$(curl -s -H "Authorization: Basic $AUTH" "$API_WAKATIME_URL?start=$DATE&end=$DATE")

# Send data to my server (optional: skipped if not configured)
DAIKIE_TOKEN=$(grep "DAIKIE_TOKEN" "$DAIKIE_FILE" | cut -d'=' -f2- | tr -d '[:space:]')
API_URL=$(grep "DAIKIE_WAKATIME_URL" "$DAIKIE_FILE" | cut -d'=' -f2- | tr -d '[:space:]')

if [[ -n "$API_URL" ]] && [[ -n "$DAIKIE_TOKEN" ]]; then
  curl -X POST "$API_URL" \
    -H "Authorization: Bearer $DAIKIE_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$response"
fi

time_coding=$(echo "$response" | jq -r '.data[0].grand_total.text')
time_japanese=$(echo "$response" | jq -r '.data[0].grand_total.text' | sed -E 's/ hrs?/時間/g; s/ mins?/分/g; s/ secs?/秒/g; s/ //g')

# Debug
echo "Coding: $time_coding"
#echo $time_japanese

# Legacy
#sketchybar --set wakatime label="$time_coding"

# Do not show if null or empty
if [ -n "$time_coding" ] && [ "$time_coding" != "null" ]; then
  sketchybar --set wakatime label="$time_japanese" drawing=on
else
  sketchybar --set wakatime drawing=off
fi
