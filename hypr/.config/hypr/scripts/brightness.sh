#!/bin/bash
# Brightness control for multiple external monitors in Hyprland
# Uses focused monitor + fast per-monitor cache + ddcutil --bus

iDIR="$HOME/.config/hypr/icons/brightness"
STEP=10

# Get currently focused monitor name (e.g. HDMI-A-1 or DP-8)
focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Map monitor name to its I2C bus (much faster than --display)
case "$focused" in
    "HDMI-A-1")
        BUS=2
        ;;
    "DP-8")
        BUS=16
        ;;
    *)
        # Fallback if somehow unknown monitor
        echo "Unknown monitor: $focused"
        notify-send -u critical "Brightness" "Unknown monitor: $focused"
        exit 1
        ;;
esac

# Per-monitor cache file (so each monitor remembers its own brightness)
CACHE="/tmp/brightness_cache_${focused}"

# Initialize cache with real hardware value if first time
if [ ! -f "$CACHE" ]; then
    real_brightness=$(ddcutil --bus "$BUS" getvcp 10 2>/dev/null | grep -o 'current value = *[0-9]*' | awk '{print $4}')
    if [[ -z "$real_brightness" ]] || ! [[ "$real_brightness" =~ ^[0-9]+$ ]]; then
        real_brightness=50
    fi
    echo "$real_brightness" > "$CACHE"
fi

# Read current cached value
current=$(cat "$CACHE" 2>/dev/null)
if ! [[ "$current" =~ ^[0-9]+$ ]]; then
    current=50
fi

# Calculate new value
if [[ "$1" == "up" ]]; then
    new_val=$((current + STEP))
elif [[ "$1" == "down" ]]; then
    new_val=$((current - STEP))
else
    echo "Usage: $0 {up|down}"
    exit 1
fi

# Clamp between 0 and 100
[ "$new_val" -gt 100 ] && new_val=100
[ "$new_val" -lt 0 ]   && new_val=0

# Save instantly to cache
echo "$new_val" > "$CACHE"

# Show notification (with monitor name for debugging)
if [ "$new_val" -gt 75 ]; then
    icon="$iDIR/high.png"
elif [ "$new_val" -gt 40 ]; then
    icon="$iDIR/medium.png"
else
    icon="$iDIR/low.png"
fi
notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -u low -i "$icon" "Brightness: $new_val% ($focused)"

# Apply to hardware in background (fast with --bus)
ddcutil --bus "$BUS" setvcp 10 "$new_val" --noverify --sleep-multiplier=0.1 >/dev/null 2>&1 &
