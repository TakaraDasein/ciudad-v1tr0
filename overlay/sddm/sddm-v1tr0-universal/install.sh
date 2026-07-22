#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="v1tr0-universal"
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/99-v1tr0-theme.conf"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${CONF_DIR}/backups-v1tr0/${STAMP}"

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo: sudo bash ${SRC_DIR}/install.sh"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
  cp /etc/sddm.conf.d/autologin.conf "$BACKUP_DIR/autologin.conf.bak"
fi

if [[ -f "$CONF_FILE" ]]; then
  cp "$CONF_FILE" "$BACKUP_DIR/99-v1tr0-theme.conf.bak"
fi

rm -rf "$THEME_DIR"
mkdir -p "$THEME_DIR"
install -m 0644 "$SRC_DIR/Main.qml" "$THEME_DIR/Main.qml"
install -m 0644 "$SRC_DIR/metadata.desktop" "$THEME_DIR/metadata.desktop"
install -m 0644 "$SRC_DIR/theme.conf" "$THEME_DIR/theme.conf"
install -m 0644 "$SRC_DIR/v1tr0.png" "$THEME_DIR/v1tr0.png"

cat > "$CONF_FILE" <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo "Instalado tema ${THEME_NAME}."
echo "Backup en: ${BACKUP_DIR}"
echo "Reinicia para probar o ejecuta: systemctl restart sddm"
