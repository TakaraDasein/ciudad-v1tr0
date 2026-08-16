#!/usr/bin/env bash
# Migra el compositor del greeter de hyprland.conf a hyprland.lua.
# El formato .conf desaparece en Hyprland 0.57; sin esto el greeter se
# quedaria sin compositor (y sin login grafico) en esa version.
#
# Uso:  sudo bash aplicar-greeter-lua.sh
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo: sudo bash $0"
  exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR="/etc/sddm.conf.d"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${CONF_DIR}/backups-v1tr0/${STAMP}"

mkdir -p "$BACKUP_DIR"
cp "$CONF_DIR/10-wayland.conf" "$BACKUP_DIR/10-wayland.conf.bak"
echo "Backup en: $BACKUP_DIR"

# hyprland.conf se conserva instalado a proposito: es el plan B para revertir
# desde una TTY sin depender de que el repo este montado.
install -m 0644 "$REPO/default/sddm/hyprland.lua"  /usr/share/sddm/hyprland.lua
install -m 0644 "$REPO/default/sddm/hyprland.conf" /usr/share/sddm/hyprland.conf
install -m 0644 "$REPO/etc/sddm.conf.d/10-wayland.conf" "$CONF_DIR/10-wayland.conf"

echo
echo "Estado resultante:"
grep -h CompositorCommand "$CONF_DIR"/*.conf
ls -l /usr/share/sddm/hyprland.lua /usr/share/sddm/hyprland.conf
echo
echo "Reinicia SDDM con una TTY de respaldo abierta (Ctrl+Alt+F2):"
echo "  sudo systemctl restart sddm"
echo
echo "Si el greeter NO levanta, desde la TTY:"
echo "  sudo cp $BACKUP_DIR/10-wayland.conf.bak $CONF_DIR/10-wayland.conf"
echo "  sudo systemctl restart sddm"
