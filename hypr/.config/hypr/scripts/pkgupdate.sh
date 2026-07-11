#!/usr/bin/env bash
# Interactive system updater for Fedora. Called by systemupdate.sh --update.
# Exit code reflects real success/failure so the caller can notify correctly.

set -uo pipefail

display() {
    cat << "EOF"
   ____         __              __  __        __     __
  / __/_ _____ / /____ __ _    / / / /__  ___/ /__ _/ /____
 _\ \/ // (_-</ __/ -_)  ' \  / /_/ / _ \/ _  / _ `/ __/ -_)
/___/\_, /___/\__/\__/_/_/_/  \____/ .__/\_,_/\_,_/\__/\__/
    /___/                         /_/
EOF
}

display; printf '\n'

# Confirm (fall back to plain read if gum isn't installed)
if command -v gum >/dev/null; then
    gum confirm "Update the system now?" \
        --prompt.foreground "#eabbd1" --affirmative "Update now!" \
        --selected.background "#eabbd1" --selected.foreground "#09080A" \
        --negative "Skip" || { echo "Skipped."; exit 0; }
else
    read -rp "Update the system now? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "Skipped."; exit 0; }
fi

rc=0

echo ":: Refreshing metadata and upgrading RPM packages..."
sudo dnf upgrade --refresh -y || rc=$?

# --- optional extras (guarded; delete this block for pure dnf) ---
if command -v flatpak >/dev/null; then
    echo ":: Updating Flatpak apps..."
    flatpak update -y || rc=$?
fi
if command -v fwupdmgr >/dev/null; then
    echo ":: Checking firmware..."
    fwupdmgr refresh --force || true   # 'fails' when cache is still fresh
    fwupdmgr update -y      || true    # never let firmware fail the whole run
fi
# ----------------------------------------------------------------

echo
[ "$rc" -eq 0 ] && echo "✔ Update complete." || echo "✗ Finished with errors (code $rc)." >&2

printf '\n<> Press ENTER to close '
read -r _
exit "$rc"
