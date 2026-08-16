#!/bin/bash

BG_DIR="$HOME/.config/omarchy/themes/v1tr0/backgrounds"
MONITOR_1="eDP-1"
MONITOR_2="HDMI-A-1"
IMG_STATIC="$BG_DIR/v1tr0-wallk.png"

pkill swaybg 2>/dev/null
pkill awww-daemon 2>/dev/null
sleep 0.3

awww-daemon --no-cache &
sleep 0.3

awww img "$IMG_STATIC" --outputs "$MONITOR_1" --resize crop --transition-type none
awww img "$IMG_STATIC" --outputs "$MONITOR_2" --resize crop --transition-type none
