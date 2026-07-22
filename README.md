# v1tr0 — Sistema Operativo Empresarial

> Basado en **Omarchy** (Arch Linux + Hyprland)
> Estrategia: **overlay + wrapper**, sin fork del core

v1tr0 NO es un fork de Omarchy. Es una **capa corporativa** encima:

- Omarchy es el motor interno (infraestructura, updates, scripts)
- v1tr0 es la cara visible (branding, CLI, temas corporativos)

Esto garantiza **0 conflictos de merge** al actualizar Omarchy.

---

## Arquitectura: 3 Capas

### Capa 1 — Overlay (seguro, reusable)
`overlay/` → se deploya sobre `~/.config/omarchy/`

- Tema v1tr0 (colores, wallpapers, hooks)
- ASCII art (terminal, fastfetch, screensaver)
- Hooks: post-update (plymouth/limine/sddm), theme-set
- Temas extra: efren-cyborg, event-horizon, one-dark-pro, ash
- SDDM login theme, waybar icons, v1tr0-launch

Deploy: `overlay/deploy.sh`

### Capa 2 — CLI Wrapper
`bin/v1tr0` — traduce comandos v1tr0 a omarchy con branding propio.

### Capa 3 — Sistema (via post-update hook)
Parchea bootloader, Plymouth, SDDM, UKI después de `omarchy update`.

---

## Snapshot de Configuración

`config/` contiene el `~/.config/` completo del desarrollador original
(solo archivos de texto, ~68 MB mergeados sobre defaults de Omarchy).

- Editores: VSCode, nvim, helix, zed, obsidian
- Terminal: ghostty, alacritty, kitty, tmux, starship
- Sistema: hypr, waybar, swayosd, systemd, dconf, gtk
- Apps: spotify, vlc, obs-studio, mpv, walker

---

## Repositorio

- `origin`: `git@github.com:TakaraDasein/ciudad-v1tr0.git` (branch `quattro`)
- `upstream`: `https://github.com/basecamp/omarchy.git`

## Package Lists

- `packages.txt` — 1508 paquetes oficiales
- `packages-aur.txt` — 19 paquetes AUR

## Licencia

MIT (como Omarchy)
