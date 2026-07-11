#!/usr/bin/env bash
# Waybar helper (Fedora/dnf).
#   --check   -> prints waybar JSON with the pending-update count
#   --update  -> runs pkgupdate.sh in a terminal, notifies on real result

set -uo pipefail

scripts_dir="$HOME/.config/hypr/scripts"
upd_script="$scripts_dir/pkgupdate.sh"
done_sign="$HOME/.config/hypr/icons/done.png"
error_sign="$HOME/.config/hypr/icons/error.png"
SOUND_UPDATE="$HOME/.config/hypr/sounds/update.wav"
SOUND_ERROR="$HOME/.config/hypr/sounds/error.wav"

notify() {  # icon summary body sound
    notify-send -i "$1" "$2" "$3"
    [ -f "$4" ] && command -v paplay >/dev/null && paplay "$4" &
}

# dnf check-update exits 100 when updates exist, 0 when none. Count only real
# "name.arch  version  repo" rows, skipping section headers/blank lines.
count_updates() {
    local dnf_count fp_count=0
    dnf_count=$(dnf -q check-update 2>/dev/null \
        | awk 'NF>=3 && $1 !~ /^(Obsoleting|Last|Security)/ {c++} END{print c+0}')
    command -v flatpak >/dev/null && \
        fp_count=$(flatpak remote-ls --updates 2>/dev/null | grep -c . || true)
    echo $(( dnf_count + fp_count ))
}

case "${1:-}" in
    --check)
        upd=$(count_updates)
        if [ "$upd" -eq 0 ]; then
            printf '{"text":"%s","tooltip":"  System is up to date"}\n' "$upd"
        else
            printf '{"text":"%s","tooltip":"󱓽 %s updates available\\n\\nPress CTRL + U to update"}\n' "$upd" "$upd"
        fi
        ;;
    --update)
        rc_file=$(mktemp)
        kitty --title "System Update" sh -c "$upd_script; echo \$? > '$rc_file'"
        rc=$(cat "$rc_file" 2>/dev/null || echo 1); rm -f "$rc_file"
        if [ "$rc" -eq 0 ]; then
            notify "$done_sign" "System updated" "All packages up to date" "$SOUND_UPDATE"
        else
            notify "$error_sign" "Update failed" "dnf exited $rc — see terminal" "$SOUND_ERROR"
        fi
        "$scripts_dir/waybar-reload.sh" --reload 2>/dev/null || true
        ;;
    *)
        echo "Usage: $(basename "$0") --check | --update" >&2; exit 2 ;;
esac
