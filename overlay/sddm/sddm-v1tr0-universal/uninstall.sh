#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="v1tr0-universal"
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_FILE="/etc/sddm.conf.d/99-v1tr0-theme.conf"

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo: sudo bash uninstall.sh"
  exit 1
fi

rm -rf "$THEME_DIR"
rm -f "$CONF_FILE"

echo "Tema ${THEME_NAME} removido."
echo "Si tenias otro tema en autologin.conf, SDDM volvera a usarlo."
