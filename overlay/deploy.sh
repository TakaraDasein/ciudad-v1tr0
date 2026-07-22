#!/bin/bash
set -euo pipefail

OVERLAY_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="$OVERLAY_DIR/config/omarchy"
CONFIG_DST="$HOME/.config/omarchy"
BIN_DST="$HOME/.local/bin"

echo "Deploying v1tr0 overlay..."

# -- Omarchy branding & themes --
mkdir -p "$CONFIG_DST"/{branding/logos,themes/v1tr0/backgrounds,hooks/{theme-set.d,post-update.d,post-boot.d}}

cp -rv "$CONFIG_SRC/branding"/*     "$CONFIG_DST/branding/"
cp -rv "$CONFIG_SRC/themes"/*       "$CONFIG_DST/themes/"

# -- Hooks --
cp -rv "$CONFIG_SRC/hooks"/*.sample "$CONFIG_DST/hooks/" 2>/dev/null || true
cp -rv "$CONFIG_SRC/hooks/theme-set" "$CONFIG_DST/hooks/" 2>/dev/null || true

for hook_dir in theme-set.d post-update.d post-boot.d; do
    for hook in "$CONFIG_SRC/hooks/$hook_dir"/*; do
        [ -f "$hook" ] || continue
        dest="$CONFIG_DST/hooks/$hook_dir/$(basename "$hook")"
        cp -v "$hook" "$dest"
        chmod +x "$dest"
    done
done

# -- Waybar icons --
if [ -d "$OVERLAY_DIR/config/waybar/icons" ]; then
    mkdir -p "$HOME/.config/waybar/icons"
    cp -v "$OVERLAY_DIR/config/waybar/icons"/* "$HOME/.config/waybar/icons/"
fi

# -- CLI launcher --
if [ -f "$OVERLAY_DIR/bin/v1tr0-launch" ]; then
    mkdir -p "$BIN_DST"
    cp -v "$OVERLAY_DIR/bin/v1tr0-launch" "$BIN_DST/v1tr0-launch"
    chmod +x "$BIN_DST/v1tr0-launch"
fi

# -- SDDM theme --
if [ -d "$OVERLAY_DIR/sddm/v1tr0-universal" ]; then
    mkdir -p "$HOME/sddm-v1tr0-universal"
    cp -rv "$OVERLAY_DIR/sddm/v1tr0-universal"/* "$HOME/sddm-v1tr0-universal/"
fi

echo "Overlay deployed."
echo "Run: omarchy theme-set v1tr0"
echo "And:  omarchy-hook post-update"
