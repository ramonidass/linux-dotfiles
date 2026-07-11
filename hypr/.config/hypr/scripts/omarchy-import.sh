#!/usr/bin/env bash
# omarchy-import.sh — pull a theme's palette + wallpapers from the Omarchy repo
# (basecamp/omarchy) and generate the per-app color files this rice expects,
# then register it in theme_select.sh. Does NOT switch to Omarchy — just borrows.
#
# Usage: omarchy-import.sh <omarchy-slug> [<omarchy-slug> ...]
#   e.g. omarchy-import.sh nord kanagawa matte-black
#
# Idempotent: re-running a slug overwrites that theme's generated files.

set -uo pipefail

REPO="basecamp/omarchy"
RAW="https://raw.githubusercontent.com/${REPO}/dev/themes"
API="https://api.github.com/repos/${REPO}/contents/themes"

C="$HOME/.config"
sel="$C/hypr/scripts/theme_select.sh"

# slug -> PascalCase (matte-black -> MatteBlack, retro-82 -> Retro82)
pretty() { echo "$1" | awk -F- '{o="";for(i=1;i<=NF;i++)o=o toupper(substr($i,1,1)) substr($i,2);print o}'; }

# Kvantum theme to use per slug (fall back to a generic dark one you have)
kv_for() { case "$1" in nord) echo "Nordic-Darker";; *) echo "KvArcDark";; esac; }

import_one() {
    local slug="$1" name toml accent cursor fg bg sel8 i v
    name="$(pretty "$slug")"
    echo ":: importing $slug -> $name"

    toml="$(mktemp)"
    if ! curl -fsSL "$RAW/$slug/colors.toml" -o "$toml"; then
        echo "   !! no colors.toml for $slug — skipping"; rm -f "$toml"; return 1
    fi

    # --- parse palette (key = "#hex") ---
    val() { sed -nE "s/^$1[[:space:]]*=[[:space:]]*\"([^\"]+)\".*/\1/p" "$toml" | head -1; }
    bg="$(val background)"; fg="$(val foreground)"
    [ -z "$bg" ] || [ -z "$fg" ] && { echo "   !! palette missing bg/fg — skipping"; rm -f "$toml"; return 1; }
    accent="$(val accent)"; [ -z "$accent" ] && accent="$(val color4)"; [ -z "$accent" ] && accent="$fg"
    cursor="$(val cursor)"; [ -z "$cursor" ] && cursor="$fg"
    local col=()
    for i in $(seq 0 15); do
        v="$(val color$i)"
        if [ -z "$v" ]; then case $i in 0) v="$bg";; 7|15) v="$fg";; *) v="$fg";; esac; fi
        col[$i]="$v"
    done
    sel8="${col[8]}"; [ -z "$sel8" ] && sel8="$accent"

    # --- kitty ---
    { printf 'foreground   %s\nbackground   %s\ncursor       %s\n\n' "$fg" "$bg" "$cursor"
      for i in $(seq 0 15); do printf 'color%-8s%s\n' "$i" "${col[$i]}"; done
    } > "$C/kitty/colors/$name.conf"

    # --- waybar + wlogout (identical @define-color set) ---
    local css; css="$(printf '@define-color foreground %s;\n@define-color background %s;\n@define-color cursor %s;\n\n' "$fg" "$bg" "$cursor"
        for i in $(seq 0 15); do printf '@define-color color%s %s;\n' "$i" "${col[$i]}"; done)"
    printf '%s\n' "$css" > "$C/waybar/colors/$name.css"
    printf '%s\n' "$css" > "$C/wlogout/colors/$name.css"

    # --- rofi ---
    cat > "$C/rofi/colors/$name.rasi" <<EOF
* {
    background: $bg;
    foreground: $fg;
    selected-normal-background: $sel8;
    selected-normal-foreground: @foreground;
    border-color: @background;
}
EOF

    # --- swaync ---
    cat > "$C/swaync/colors/$name.css" <<EOF
@define-color noti-border-color $accent;
@define-color noti-bg $bg;
@define-color noti-bg-hover-alt $sel8;
@define-color noti-bg-alt $sel8;
@define-color noti-fg $fg;
@define-color noti-bg-hover $accent;
@define-color noti-bg-focus $bg;
@define-color noti-close-bg ${col[3]};
@define-color noti-close-bg-hover ${col[1]};
@define-color noti-urgent ${col[1]};
@define-color bg-selected $bg;
EOF

    # --- hypr theme conf (dynamic top, then literal Hyprland body) ---
    local ahex="${accent#\#}" ihex="${sel8#\#}"
    {
      echo "\$activeCol = rgba(${ahex}FF)"
      echo "\$inactiveCol = rgba(${ihex}FF)"
      echo "\$icon = Tela-circle-dracula"
      echo "\$theme = Adwaita-dark"
      echo "\$color = prefer-dark"
      echo ""
      cat <<'STATIC'
exec = gsettings set org.gnome.desktop.interface icon-theme $icon
exec = gsettings set org.gnome.desktop.interface gtk-theme $theme
exec = gsettings set org.gnome.desktop.interface color-scheme $color

source=~/.config/hypr/confs/configs.conf

general {
    layout = dwindle
    gaps_in = $inner_gap
    gaps_out = $outer_gap
    border_size = $border
    col.active_border = $activeCol
    col.inactive_border = $inactiveCol
    resize_on_border = false
    allow_tearing = false
}

decoration {
    rounding = $rounding
    rounding_power = 2
    fullscreen_opacity = 1.0
    dim_strength = 0.1
    dim_special = 0.8

    shadow {
        enabled = true
        range = $shadow_range
        render_power = 4
        color = $activeCol
        color_inactive = $inactiveCol
    }

    blur {
        enabled = true
        size = $blur_size
        passes = $blur_pass
        ignore_opacity = true
        new_optimizations = true
        special = true
        popups = true
    }
}
STATIC
    } > "$C/hypr/confs/themes/$name.conf"

    # --- preview image for the rofi theme picker ---
    curl -fsSL "$RAW/$slug/preview.png" -o "$C/hypr/assets/$name.png" 2>/dev/null \
        || echo "   (no preview.png)"

    # --- wallpapers ---
    mkdir -p "$C/hypr/Wallpapers/$name"
    local bgs n
    bgs="$(curl -fsSL "$API/$slug/backgrounds" 2>/dev/null | sed -nE 's/.*"name": "([^"]+)".*/\1/p')"
    if [ -n "$bgs" ]; then
        while IFS= read -r n; do
            [ -z "$n" ] && continue
            curl -fsSL "$RAW/$slug/backgrounds/${n// /%20}" -o "$C/hypr/Wallpapers/$name/$n" 2>/dev/null
        done <<< "$bgs"
        echo "   wallpapers: $(ls "$C/hypr/Wallpapers/$name" | wc -l)"
    else
        echo "   (no backgrounds)"
    fi

    # --- register in theme_select.sh (idempotent) ---
    if ! grep -qE "^[[:space:]]*${name}\)" "$sel"; then
        local kv tmp; kv="$(kv_for "$slug")"; tmp="$(mktemp)"
        awk -v n="$name" -v kv="$kv" '
            /^[[:space:]]*\*\)/ && !ins {
                print "    " n ")";
                print "        vscodeTheme=\"Default Dark Modern\"";
                print "        kvTheme=\"" kv "\"";
                print "        ;;";
                ins=1
            }
            { print }
        ' "$sel" > "$tmp" && cat "$tmp" > "$sel" && rm -f "$tmp"
        echo "   registered case entry (kvTheme=$kv)"
    fi

    rm -f "$toml"
}

[ $# -eq 0 ] && { echo "usage: $0 <omarchy-slug> [more...]"; exit 2; }
for s in "$@"; do import_one "$s"; done
echo ":: done."
