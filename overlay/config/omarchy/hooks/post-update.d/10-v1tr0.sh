#!/bin/bash

# Re-applies v1tr0 branding after an Omarchy update.
#
# This hook lives in ~/.config/omarchy/hooks/ and so cannot derive the v1tr0
# repo location from its own path. Override with V1TR0_PATH if the repo moves.
V1TR0_PATH="${V1TR0_PATH:-$HOME/1.Cyborg-Town/2.Daten-Town/6.v1tr0-sistema-operativo/omarchy}"

if [[ ! -d "$V1TR0_PATH" ]]; then
  echo "10-v1tr0: v1tr0 repo not found at $V1TR0_PATH — branding NOT reapplied" >&2
  exit 1
fi

omarchy-plymouth-set-by-theme v1tr0
omarchy-refresh-limine || true
omarchy-refresh-config || true

# Deliberately the repo's copy, not the one on PATH: an update overwrites
# ~/.local/share/omarchy/bin/omarchy-refresh-sddm with the upstream version,
# which refreshes the theme from upstream and wipes the v1tr0 logo.
#
# Errors are NOT silenced here. A previous version piped this to /dev/null,
# which is why the branding regression went unnoticed after an update.
"$V1TR0_PATH/bin/omarchy-refresh-sddm"
