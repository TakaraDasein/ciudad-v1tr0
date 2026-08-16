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
# Sin 2>/dev/null: si estos copiados fallan hay que enterarse. Se usa nullglob
# para que un patron sin coincidencias sea un caso normal, no un error mudo.
shopt -s nullglob
samples=("$CONFIG_SRC/hooks"/*.sample)
((${#samples[@]})) && cp -rv "${samples[@]}" "$CONFIG_DST/hooks/"
shopt -u nullglob

[ -e "$CONFIG_SRC/hooks/theme-set" ] && cp -rv "$CONFIG_SRC/hooks/theme-set" "$CONFIG_DST/hooks/"

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

# -- SDDM theme (alternativo, no es el login por defecto) --
# El directorio se llama sddm-v1tr0-universal. Esta condicion comprobaba
# "v1tr0-universal" y por tanto nunca se cumplio: el bloque jamas se ejecuto.
if [ -d "$OVERLAY_DIR/sddm/sddm-v1tr0-universal" ]; then
    mkdir -p "$HOME/sddm-v1tr0-universal"
    cp -rv "$OVERLAY_DIR/sddm/sddm-v1tr0-universal"/* "$HOME/sddm-v1tr0-universal/"
fi

echo "Overlay deployed."
echo
echo "Siguientes pasos:"
echo "  omarchy theme-set v1tr0"
echo "  omarchy-v1tr0-login            # Plymouth + SDDM + autologin"
echo "  omarchy-v1tr0-login --check    # verificar sin cambiar nada"
