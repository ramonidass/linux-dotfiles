#!/bin/bash

scrDir="$HOME/.config/hypr/scripts"
cacheDir="$HOME/.config/hypr/.cache"
themeFile="$cacheDir/.theme"
wallCache="$cacheDir/.wallpaper"

theme=$(cat "$themeFile")
wallDir="$HOME/.config/hypr/Wallpapers/${theme}"

[[ ! -f "$wallCache" ]] && touch "$wallCache"

PICS=($(find ${wallDir} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
wallpaper=${PICS[ $RANDOM % ${#PICS[@]} ]}

# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
AWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

notify-send -i "${wallpaper}" "Changing wallpaper" -t 1500

# Ensure awww-daemon is alive (it can die after suspend, leaving a stale socket)
if ! awww query &>/dev/null; then
    pkill -x awww-daemon
    rm -f "$XDG_RUNTIME_DIR/${WAYLAND_DISPLAY}-awww-daemon.sock"
    awww-daemon &
    until awww query &>/dev/null; do sleep 0.2; done
fi

awww img ${wallpaper} $AWWW_PARAMS

ln -sf "$wallpaper" "$cacheDir/current_wallpaper.png"

baseName="$(basename $wallpaper)"
wallName=${baseName%.*}
echo "$wallName" > "$wallCache"

sleep 0.5
"$scrDir/wallcache.sh"
# "$scrDir/themes.sh"
