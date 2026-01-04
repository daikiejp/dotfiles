#!/bin/zsh

# ==============================================================================
# Wakatime for Sketchybar
# DaikieJP - 2026
# !IMPORTANT: Adapt this script to your own needs.
# ==============================================================================

# ==============================================================================
# Api Configuration
# ==============================================================================

API_KEY=$(grep "api_key" "$HOME/.wakatime.cfg" | cut -d'=' -f2 | tr -d '[:space:]')
DATE=$(date +%Y-%m-%d)
AUTH=$(echo -n "$API_KEY:" | base64)
API_WAKATIME_URL=$(grep "API_WAKATIME_URL" "$HOME/.daikie" | cut -d'=' -f2- | tr -d '[:space:]')
DAIKIE_WAKATIME_URL=$(grep "DAIKIE_WAKATIME_URL" "$HOME/.daikie" | cut -d'=' -f2- | tr -d '[:space:]')

response=$(curl -s -H "Authorization: Basic $AUTH" "$API_WAKATIME_URL?start=$DATE&end=$DATE")

# Send data to my server
DAIKIE_TOKEN=$(grep "DAIKIE_TOKEN" "$HOME/.daikie" | cut -d'=' -f2 | tr -d '[:space:]')
API_URL=$(grep "DAIKIE_WAKATIME_URL" "$HOME/.daikie" | cut -d'=' -f2 | tr -d '[:space:]')

curl -X POST "$API_URL" \
  -H "Authorization: Bearer $DAIKIE_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$response"

time_coding=$(echo "$response" | jq -r '.data[0].grand_total.text')
time_japanese=$(echo "$response" | jq -r '.data[0].grand_total.text' | sed -E 's/ hrs?/時間/g; s/ mins?/分/g; s/ //g')

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
