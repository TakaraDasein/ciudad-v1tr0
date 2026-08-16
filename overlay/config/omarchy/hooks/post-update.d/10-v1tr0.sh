#!/bin/bash

# Reaplica el branding v1tr0 despues de una actualizacion de Omarchy.
#
# Este hook vive en ~/.config/omarchy/hooks/, asi que no puede deducir la
# ubicacion del repo v1tr0 desde su propia ruta. Usa V1TR0_PATH para moverlo.
V1TR0_PATH="${V1TR0_PATH:-$HOME/1.Cyborg-Town/2.Daten-Town/6.v1tr0-sistema-operativo/omarchy}"
export V1TR0_PATH

if [[ ! -d "$V1TR0_PATH" ]]; then
  echo "10-v1tr0: repo v1tr0 no encontrado en $V1TR0_PATH — branding NO reaplicado" >&2
  exit 1
fi

omarchy-refresh-limine || true

# Sin omarchy-refresh-config: exige la ruta de un archivo como argumento, asi
# que la llamada desnuda que habia aqui nunca hizo nada (el 2>/dev/null lo
# ocultaba). Pasarle argumentos seria peor: sobrescribe ~/.config/<x> con el
# default de upstream, tirando la configuracion propia.

# Todo el esquema de login (Plymouth, SDDM, autologin, sesion Wayland) en un
# solo comando idempotente, que ademas respeta el orden critico entre
# omarchy-plymouth-set y omarchy-refresh-sddm. Ver docs/v1tr0.md.
#
# Los errores NO se silencian. Una version anterior mandaba esto a /dev/null,
# que es por lo que la regresion del branding paso desapercibida tras un update.
"$V1TR0_PATH/bin/omarchy-v1tr0-login"
