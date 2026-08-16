# v1tr0 — Documentación Técnica

## Estructura del Proyecto

```
omarchy/                        # Fork raíz (fork de Omarchy branch quattro)
├── README.md                   # (reescrito para v1tr0)
├── VISION.md                   # (en el directorio padre del proyecto)
├── AGENTS.md                   # Reglas para IA (Omarchy)
│
├── bin/v1tr0                   # CLI wrapper: sed-traduce omarchy → v1tr0
├── logo.txt                    # ASCII art block 80×52 (omarchy-show-logo)
├── icon.txt                    # ASCII art block 54×26 (about reset)
├── v1tr0-wallk.png             # Wallpaper principal (imagotipo + texto)
├── v1tr0.png                   # Logo PNG (imagotipo)
├── logo.svg                    # Logo vectorial SVG
│
├── overlay/                    # ★ Capa reusable para deploy
│   ├── deploy.sh               #   Script de deploy
│   ├── bin/v1tr0-launch        #   Lanzador de workspace v1tr0
│   ├── config/
│   │   ├── omarchy/
│   │   │   ├── branding/       #   about.txt, screensaver.txt, logos/
│   │   │   ├── themes/         #   v1tr0 + 4 temas extra
│   │   │   └── hooks/          #   theme-set.d, post-update.d, samples
│   │   └── waybar/icons/       #   v1tr0.svg, v1tr0.png
│   └── sddm/sddm-v1tr0-universal/   # Tema SDDM
│
├── config/                     # ★ Snapshot de ~/.config/ (texto, ~68 MB)
│   ├── hypr/                   #   Hyprland (conf, no lua)
│   ├── nvim/                   #   Neovim (LazyVim-based)
│   ├── Code/User/              #   VSCode settings, keybindings, MCP
│   ├── ghostty/config          #   Ghostty config (sin extensión)
│   ├── git/config              #   Git config (sin extensión)
│   ├── waybar/                 #   Waybar style + icons
│   ├── omarchy/                #   Omarchy runtime state + hooks deployados
│   ├── zed/                    #   Zed editor config
│   ├── systemd/                #   Servicios de usuario
│   └── ... (80+ directorios)
│
├── default/bashrc              # ★ .bashrc default con logo v1tr0 + LS_COLORS
│
├── packages.txt                # Lista de paquetes oficiales (1508)
├── packages-aur.txt            # Lista de paquetes AUR (19)
│
├── applications/               # (Omarchy upstream)
├── shell/                      # (Omarchy upstream — Quickshell)
├── themes/                     # (Omarchy upstream — temas base)
├── install/                    # (Omarchy upstream — scripts de instalación)
└── docs/                       # (Omarchy upstream + v1tr0.md)
```

---

## Capa 1 — Overlay Detallado

### Branding

| Archivo | Propósito |
|---------|-----------|
| `branding/logos/v1tr0.png` | Logo fuente para omarchy-show-logo, fastfetch |
| `branding/about.txt` | ASCII art para omarchy about reset (block 54×26) |
| `branding/screensaver.txt` | ASCII art para screensaver (braille 80×52) |

### Tema v1tr0

`themes/v1tr0/`:

- **colors.toml** — 16 colores ANSI + cursor + selection + ghostty keys
  - Background: `#094248` (teal profundo)
  - Accent/Stroke: `#26FFDF` (cyan neón)
  - Nodes: `#025159` (teal medio)
- **backgrounds/** — v1tr0.png, v1tr0-wallk.png, unlock.png
- Generado por overlay, activado con `omarchy theme-set v1tr0`

### Hooks

| Hook | Disparador | Acción |
|------|-----------|--------|
| `theme-set.d/10-v1tr0.sh` | `omarchy theme-set` | Fija wallpaper v1tr0-wallk.png + unlock.png |
| `post-update.d/10-v1tr0.sh` | `omarchy update` | Parchea plymouth, limine, sddm (requiere sudo) |

### Temas Extra Incluidos

- **efren-cyborg** — Tema personal del desarrollador (15 GIFs de fondo)
- **event-horizon** — Tema espacial (14 fondos, neovim, waybar-theme)
- **one-dark-pro** — Tema One Dark Pro (8 fondos)
- **ash** — Tema minimalista ash (2 fondos)

### SDDM Theme

`overlay/sddm/sddm-v1tr0-universal/`:

- Main.qml, theme.conf, metadata.desktop
- Logo v1tr0 + SVG personalizado
- Scripts install.sh / uninstall.sh

### Waybar Icons

`overlay/config/waybar/icons/v1tr0.{svg,png}` — icono para la barra.

---

## Capa 2 — CLI Wrapper

`bin/v1tr0`:

```bash
#!/bin/bash
V1TR0_VERSION="1.0.0"
case "$1" in
    --version|-v)  echo "v1tr0 $V1TR0_VERSION" ;;
    --help|-h)     echo "v1tr0 - sistema operativo empresarial v$V1TR0_VERSION"
                   echo "Basado en Omarchy 3.8.4"
                   omarchy --help ;;
    *)             omarchy "$@" | sed 's/Omarchy/v1tr0/gI' ;;
esac
```

---

## Capa 3 — Sistema

El hook `post-update.d/10-v1tr0.sh` parchea:

| Componente | Ruta | Cambio |
|-----------|------|--------|
| Bootloader | `/boot/limine.conf` | `interface_branding: Omarchy` → `v1tr0` |
| Bootloader | `/etc/default/limine` | `TARGET_OS_NAME` → `v1tr0` |
| Plymouth | `/usr/share/plymouth/themes/omarchy/` | Logos → v1tr0 |
| SDDM | `/usr/share/sddm/themes/omarchy/` | Logos, nombres → v1tr0 |
| UKI | `/boot/EFI/Linux/omarchy_linux.efi` | Nombre → v1tr0 |

Ejecutar con: `pkexec omarchy-hook post-update`

---

## Snapshot de Configuración

`config/` contiene el `~/.config/` del sistema de desarrollo original,
copiado con rsync incluyendo solo archivos de texto (extensiones comunes
y archivos sin extensión como `ghostty/config`, `git/config`).

**Excluido:** browsers (Brave, Chrome, Vivaldi), juegos (heroic, retroarch),
app data (Signal, Spotify, LM Studio), caches, node_modules.

**Merge:** Los archivos del usuario se overlayean sobre los defaults de
Omarchy — los defaults originales se preservan (foot.ini, bar.json, etc.).

### Editores/IDEs

| Config | Archivos clave |
|--------|---------------|
| VSCode | settings.json, keybindings.json, mcp.json, extensions |
| Neovim | init.lua, lazy-lock.json, plugins/ (LazyVim) |
| Helix | config.toml |
| Zed | settings.json, themes/aether.json |
| Obsidian | obsidian.json, bóveda config |

### Terminal

| App | Config |
|-----|--------|
| Ghostty | config (sin extensión) |
| Alacritty | alacritty.toml |
| Kitty | kitty.conf |
| Tmux | tmux.conf |
| Starship | starship.toml |

### Shell

- **default/bashrc**: fastfetch con logo v1tr0, LS_COLORS (directorios cyan)
- bash, zsh, fish configs incluidos

---

## Deploy en Sistema Limpio

```bash
# 1. Clonar
git clone git@github.com:TakaraDasein/ciudad-v1tr0.git
cd ciudad-v1tr0

# 2. Deploy overlay
./overlay/deploy.sh

# 3. Activar tema
omarchy theme-set v1tr0

# 4. Branding del sistema (requiere sudo)
pkexec omarchy-hook post-update

# 5. (Opcional) Instalar SDDM theme
cd ~/sddm-v1tr0-universal
sudo ./install.sh
```

---

## Login

### Cómo funciona realmente

Con el disco cifrado, el arranque tiene **una sola contraseña** y la pide Plymouth:

```
UEFI → limine → UKI → initramfs (hook encrypt)
                          │
                          └─ Plymouth: caja de contraseña ← LA ÚNICA
                                │
                          LUKS abierto → raíz montada
                                │
                          SDDM → autologin → Hyprland
```

**La "pantalla de login con branding" es la de Plymouth, no la de SDDM.** El
greeter de SDDM no puede pedir la contraseña del disco: vive *dentro* del disco
cifrado y no existe hasta que este ya está abierto.

Omarchy activa el autologin **precisamente porque el disco está cifrado**
(`should_enable_sddm_autologin()` en `bin/omarchy-upgrade-to-quattro` termina
llamando a `root_filesystem_encrypted()`). La passphrase de LUKS es la frontera
de seguridad; un segundo prompt en SDDM le pregunta lo mismo a la misma persona
en el mismo arranque. La sesión ya encendida la protege **hyprlock**, no SDDM.

`bin/omarchy-v1tr0-login` replica ese criterio en vez de fijarlo a mano.

### Comando único

```bash
omarchy-v1tr0-login                    # autologin según cifrado (por defecto)
omarchy-v1tr0-login --autologin off    # fuerza el greeter de SDDM
omarchy-v1tr0-login --autologin on     # fuerza autologin
omarchy-v1tr0-login --dry-run          # muestra qué haría, sin tocar nada
```

Idempotente. Se ejecuta **como usuario, nunca con sudo** (necesita `$HOME` para
resolver el tema; pide sudo por sí mismo). Es lo que invocan tanto el hook
`post-update.d/10-v1tr0.sh` como `install/login/v1tr0.sh`.

### Los tres fallos que resolvió, y por qué se repiten

**1. El logo gigante deja la caja de contraseña fuera de pantalla.**

`default/plymouth/omarchy.script` coloca la caja justo debajo del logo:

```
logo.y  = (alto_pantalla - logo.height) / 2
entry.y = logo.y + logo.height + 40
```

Con `unlock.png` de 1920×1080 en una pantalla de 1080: `entry.y = 1120`, es
decir **40 px por debajo del borde inferior**. Síntoma: sólo se ve el wallpaper
y hay que pulsar **Esc** para llegar al prompt de texto de Plymouth. El logo de
Omarchy mide 800×188; `unlock.png` debe ser un **logotipo**, no un wallpaper.

`ensure_logo_scale()` reescala automáticamente cualquier imagen que supere
800×300, así que el fallo no puede volver a colarse.

Es la misma familia que el bug de SDDM que se arregló con `maxLogoHeight` en
`Main.qml` (commit `b60a3955`): imágenes v1tr0 mucho mayores de lo que el tema
asume.

**2. `omarchy-plymouth-set` sobrescribe el tema de SDDM.**

No es evidente por el nombre, pero al final del script hace:

```bash
sddm_template="$HOME/.local/share/omarchy/default/sddm/omarchy/Main.qml"   # UPSTREAM
sed ... "$sddm_template" | sudo tee /usr/share/sddm/themes/omarchy/Main.qml
sudo cp "$logo_path" /usr/share/sddm/themes/omarchy/logo.png
```

Instala el `Main.qml` de **upstream**, sin el fix de `maxLogoHeight`. Por eso
**`omarchy-refresh-sddm` tiene que ejecutarse DESPUÉS**, nunca antes. Durante un
tiempo el login se salvó por el orden accidental del hook, no por diseño.

También reconstruye la initramfs — de ahí que la UKI se compile dos veces
durante un `omarchy update`.

**3. El branding se perdía en cada actualización.**

`omarchy-refresh-sddm` de upstream copia desde `$OMARCHY_PATH`
(`~/.local/share/omarchy`), cuyo `logo.png` es el genérico de 3072 bytes. La
versión de este repo prefiere el tema v1tr0 y sólo cae a upstream si no lo
encuentra.

Relacionado: el comando que se ejecuta desde `$PATH` es el de
`~/.local/share/omarchy/bin/`, **que cada actualización sobrescribe**. Por eso
el hook invoca la copia del repo por ruta explícita.

### Archivos que componen el esquema

| Archivo | Papel |
|---|---|
| `bin/omarchy-v1tr0-login` | Mecanismo único, idempotente |
| `bin/omarchy-refresh-sddm` | Tema SDDM desde el repo, no desde upstream |
| `etc/sddm.conf.d/30-autologin.conf` | Autologin (`User=`, `Session=omarchy`) |
| `etc/sddm.conf.d/10-wayland.conf` | `CompositorCommand` del greeter |
| `default/sddm/hyprland.lua` | Compositor del greeter (formato actual) |
| `default/sddm/hyprland.conf` | Ídem en formato legacy, plan B para revertir |
| `default/sddm/omarchy/` | Tema SDDM con logo v1tr0 y `maxLogoHeight` |
| `themes/v1tr0/unlock.png` | Logo de Plymouth (**escala de logotipo**) |
| `overlay/wayland-sessions/omarchy.desktop` | Sesión a la que apunta `Session=omarchy` |
| `install/login/v1tr0.sh` | Enganche en la instalación |
| `overlay/config/omarchy/hooks/post-update.d/10-v1tr0.sh` | Reaplicación tras update |

### Compositor del greeter: `.conf` vs `.lua`

Hyprland elimina el formato `.conf` en **0.57**. `CompositorCommand` apunta a
`/usr/share/sddm/hyprland.lua`; `omarchy-refresh-sddm` instala **ambos**
formatos a propósito, para poder revertir desde una TTY sin depender del repo.

Un `CompositorCommand` que apunte a un archivo inexistente deja el greeter sin
compositor y **sin pantalla de login**. Verificar siempre:

```bash
ls -l /usr/share/sddm/hyprland.*
grep -h CompositorCommand /etc/sddm.conf.d/*.conf
```

> El aviso *"You are using the .conf config format"* que aparece en el
> escritorio es de la **sesión de usuario** (`~/.config/hypr/*.conf`), no del
> greeter, y desaparecerá cuando Omarchy publique la migración a lua.

### Verificación y recuperación

Probar el tema SDDM **sin reiniciar**:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/omarchy
```

Comprobar que un update no rompió nada:

```bash
omarchy-v1tr0-login --dry-run
diff -rq default/sddm/omarchy /usr/share/sddm/themes/omarchy
magick identify /usr/share/plymouth/themes/omarchy/logo.png   # NO 1920x1080
```

**Antes de tocar `/etc/sddm.conf.d/`, dejar una TTY con sesión abierta
(Ctrl+Alt+F2).** Cada ejecución deja copia con marca de tiempo en
`/etc/sddm.conf.d/backups-v1tr0/<timestamp>/`; revertir es copiar el `.bak`
correspondiente y `sudo systemctl restart sddm`.

---

## Historial de Cambios

### Commit 1 — Branding inicial
- Version 1.0.0, logo.svg, logo.txt, icon.txt, bin/v1tr0

### Commit 2 — ASCII art
- logo.txt, icon.txt, screensaver.txt, about.txt generados desde v1tr0.png

### Commit 3 — Overlay
- deploy.sh, tema v1tr0, branding, hooks

### Commit 4 — Full system snapshot (actual)
- Overlay con temas extra, SDDM, waybar icons, v1tr0-launch
- config/ mergeado con ~/.config/ del sistema (texto, 68 MB)
- default/bashrc con fastfetch + LS_COLORS
- packages.txt + packages-aur.txt
- Ghostty colors.toml con todas las keys ghostty
- .gitignore para caches VSCode, copilot, obs logs

---

## Referencia de Colores

| Token | Hex | Uso |
|-------|-----|-----|
| `background` | `#094248` | Fondo general |
| `color6` / `accent` | `#26FFDF` | Cyan neón (acento principal) |
| `color14` / `bright_accent` | `#5FFFE3` | Cyan brillante |
| `color4` | `#1E90FF` | Azul (links) |
| `color12` | `#5CADFF` | Azul brillante |
| `color2` | `#00E676` | Verde (éxito, ejecutables) |
| `color1` | `#FF5252` | Rojo (errores) |
