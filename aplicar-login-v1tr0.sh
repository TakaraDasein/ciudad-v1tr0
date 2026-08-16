#!/usr/bin/env bash
# Desactiva el autologin de SDDM para que aparezca el greeter v1tr0.
# Uso:  sudo bash aplicar-login-v1tr0.sh
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo: sudo bash $0"
  exit 1
fi

CONF_DIR="/etc/sddm.conf.d"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${CONF_DIR}/backups-v1tr0/${STAMP}"

mkdir -p "$BACKUP_DIR"
for f in "$CONF_DIR"/*.conf; do
  [[ -e "$f" ]] && cp "$f" "$BACKUP_DIR/$(basename "$f").bak"
done
cp /etc/pam.d/sddm "$BACKUP_DIR/pam.d-sddm.bak"
echo "Backup en: $BACKUP_DIR"

# 1. El arreglo principal: sin autologin, SDDM muestra el greeter.
#    El archivo vivo se llama 2-autologin.conf; borrar cualquier variante.
shopt -s nullglob
for f in "$CONF_DIR"/*autologin*.conf; do
  rm -f "$f"
  echo "Autologin desactivado: eliminado $(basename "$f")"
done
shopt -u nullglob

# 2. Con login por contrasena, pam_gnome_keyring crea un keyring cifrado que
#    entra en conflicto con el keyring sin contrasena de Omarchy.
#    Misma limpieza que hace install/login/sddm.sh
if [[ -f /etc/pam.d/sddm ]]; then
  sed -i '/-auth.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
  sed -i '/-password.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
  echo "PAM: lineas pam_gnome_keyring de auth/password eliminadas"
fi

echo
echo "Estado resultante:"
grep -rn "Autologin" "$CONF_DIR"/*.conf 2>/dev/null && echo "  !! queda autologin" || echo "  autologin: ninguno"
echo "  tema:     $(grep -h Current "$CONF_DIR"/*.conf 2>/dev/null)"
echo "  greeter:  $(grep -h CompositorCommand "$CONF_DIR"/*.conf 2>/dev/null)"
ls -l /usr/share/sddm/hyprland.conf
echo
echo "Prueba el tema SIN reiniciar:"
echo "  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/omarchy"
echo "Si se ve bien:  sudo systemctl restart sddm   (cierra tu sesion actual)"
echo "Para revertir:  sudo cp $BACKUP_DIR/*.bak $CONF_DIR/  (renombrando sin .bak)"
