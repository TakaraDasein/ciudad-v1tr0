#!/bin/bash
sleep 2
swww-daemon &
sleep 1
THEME_NAME=$(cat "$HOME/.config/omarchy/current/theme.name" 2>/dev/null)

if [[ $THEME_NAME == "osaka-jade" ]]; then
  swww img -o eDP-1 ~/.config/omarchy/themes/osaka-jade/backgrounds/23.gif
  swww img -o HDMI-A-1 ~/.config/omarchy/themes/osaka-jade/backgrounds/29.gif
else
  swww img -o eDP-1 ~/.config/omarchy/themes/efren-cyborg/backgrounds/14.gif
  swww img -o HDMI-A-1 ~/.config/omarchy/themes/efren-cyborg/backgrounds/16.gif
fi
