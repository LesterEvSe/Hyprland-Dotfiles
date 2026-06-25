#!/bin/bash
set -euo pipefail

# --- Config ---
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
COOLDOWN=60
CHECK_INTERVAL=5
DEFAULT_SENSOR="/sys/class/hwmon/hwmon5/temp1_input"
DEFAULT_THRESHOLD=85

# --- Parse waybar config once ---
JSON=$(sed 's|//.*||g' "$WAYBAR_CONFIG" 2>/dev/null || echo '{}')
SENSOR=$(jq -r '.temperature."hwmon-path"            // empty' <<< "$JSON")
THRESHOLD=$(jq -r '.temperature."critical-threshold" // empty' <<< "$JSON")
SENSOR=${SENSOR:-$DEFAULT_SENSOR}
THRESHOLD=${THRESHOLD:-$DEFAULT_THRESHOLD}

[[ -r "$SENSOR" ]] || { echo "Sensor not readable: $SENSOR" >&2; exit 1; }

THRESHOLD_RAW=$(( THRESHOLD * 1000 ))
LAST_TIME=0

trap 'exit 0' TERM INT

while :; do
    sleep "$CHECK_INTERVAL"

    read -r RAW_TEMP < "$SENSOR"
    (( RAW_TEMP >= THRESHOLD_RAW )) || continue

    printf -v NOW '%(%s)T' -1
    (( NOW - LAST_TIME >= COOLDOWN )) || continue

    notify-send -u critical -t 5000 "🔥 Overheating" "CPU: $(( RAW_TEMP / 1000 ))°C"
    LAST_TIME=$NOW
done