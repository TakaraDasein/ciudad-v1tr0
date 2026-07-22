#!/bin/bash
set -euo pipefail

OVERLAY_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="$OVERLAY_DIR/config/omarchy"
CONFIG_DST="$HOME/.config/omarchy"

echo "Deploying v1tr0 overlay..."

mkdir -p "$CONFIG_DST"/{branding/logos,themes/v1tr0/backgrounds,hooks/{theme-set.d,post-update.d}}

cp -rv "$CONFIG_SRC/branding"/* "$CONFIG_DST/branding/"
cp -rv "$CONFIG_SRC/themes"/*   "$CONFIG_DST/themes/"

for hook_dir in theme-set.d post-update.d; do
    for hook in "$CONFIG_SRC/hooks/$hook_dir"/*; do
        [ -f "$hook" ] || continue
        dest="$CONFIG_DST/hooks/$hook_dir/$(basename "$hook")"
        cp -v "$hook" "$dest"
        chmod +x "$dest"
    done
done

echo "Overlay deployed."
echo "Run: omarchy theme-set v1tr0"
echo "And:  omarchy-hook post-update"
