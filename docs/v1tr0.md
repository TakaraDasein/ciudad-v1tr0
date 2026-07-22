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
