#!/bin/bash

OMARCHY_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

omarchy-plymouth-set-by-theme v1tr0
omarchy-refresh-limine 2>/dev/null || true
omarchy-refresh-sddm  2>/dev/null || true
omarchy-refresh-config 2>/dev/null || true
