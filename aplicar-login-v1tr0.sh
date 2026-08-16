#!/usr/bin/env bash
# Restablece el esquema de login de Omarchy para discos cifrados:
# una sola contrasena, la de LUKS, escrita en la caja de Plymouth al arrancar.
#
# NO ejecutar con sudo: necesita tu $HOME para resolver el tema v1tr0.
# El script pide sudo por si mismo donde hace falta.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "No lo ejecutes con sudo. Lanzalo como tu usuario:  bash $0" >&2
  exit 1
fi

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_DIR="/etc/sddm.conf.d"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${CONF_DIR}/backups-v1tr0/${STAMP}"

echo "==> Backup"
sudo mkdir -p "$BACKUP_DIR"
for f in "$CONF_DIR"/*.conf; do
  [[ -e $f ]] && sudo cp "$f" "$BACKUP_DIR/$(basename "$f").bak"
done

# 1. Autologin. El archivo vivo se ha llamado historicamente 2-autologin.conf;
#    se instala con el nombre del repo y se limpia cualquier variante previa
#    para no acabar con dos archivos compitiendo.
echo "==> Restaurando autologin"
sudo rm -f "$CONF_DIR"/*autologin*.conf
sudo install -m 0644 "$REPO/etc/sddm.conf.d/30-autologin.conf" "$CONF_DIR/30-autologin.conf"

# 2. Plymouth con el logo a escala correcta. Antes unlock.png era un wallpaper
#    de 1920x1080 y el tema coloca la caja de contrasena justo debajo del logo
#    (entry.y = logo.y + logo.height + 40), asi que caia fuera de la pantalla y
#    obligaba a pulsar Esc. Con un logo de 800x269 la caja cae en y=714.
#    Este comando reconstruye ademas la initramfs.
echo "==> Aplicando tema Plymouth v1tr0 (reconstruye la initramfs, tarda)"
omarchy-plymouth-set-by-theme v1tr0

# 3. omarchy-plymouth-set sobrescribe /usr/share/sddm/themes/omarchy/Main.qml
#    con la plantilla de UPSTREAM, que no tiene el fix de maxLogoHeight, y
#    reemplaza logo.png por el que acabamos de pasarle. Hay que restaurar el
#    tema v1tr0 despues, siempre en este orden.
echo "==> Restaurando el tema SDDM v1tr0 (plymouth-set lo pisa)"
"$REPO/bin/omarchy-refresh-sddm"

echo
echo "Estado resultante:"
echo -n "  autologin: "; grep -h "^User=" "$CONF_DIR"/*.conf 2>/dev/null || echo "NINGUNO (!)"
echo -n "  logo plymouth: "; magick identify -format "%wx%h\n" /usr/share/plymouth/themes/omarchy/logo.png
echo -n "  logo sddm:     "; magick identify -format "%wx%h\n" /usr/share/sddm/themes/omarchy/logo.png
echo "  maxLogoHeight en SDDM: $(grep -c maxLogoHeight /usr/share/sddm/themes/omarchy/Main.qml) (debe ser >0)"
echo
echo "Reinicia para probar. Deberias ver, en orden:"
echo "  1. Plymouth con el logo v1tr0 y la caja de contrasena VISIBLE (sin Esc)"
echo "  2. Escritorio directo, sin segunda contrasena"
echo
echo "Revertir:  sudo cp $BACKUP_DIR/<archivo>.bak $CONF_DIR/<archivo>"
