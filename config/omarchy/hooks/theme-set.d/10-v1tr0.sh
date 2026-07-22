#!/bin/bash

if [ "$1" != "v1tr0" ]; then
    exit 0
fi

pkill -x swaybg
awww-daemon &
sleep 1
awww img -o eDP-1 ~/.config/omarchy/themes/v1tr0/backgrounds/v1tr0-wallk.png
