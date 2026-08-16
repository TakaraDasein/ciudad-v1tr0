# Esquema de login v1tr0: Plymouth con la caja de contrasena visible, tema SDDM
# con branding, y autologin decidido por el mismo criterio que Omarchy (activo
# si la raiz esta cifrada). Ver docs/v1tr0.md, seccion "Login".
#
# Idempotente. Se ejecuta como el usuario, no como root.
if [[ -x "${V1TR0_PATH:-}/bin/omarchy-v1tr0-login" ]]; then
  "$V1TR0_PATH/bin/omarchy-v1tr0-login"
fi
