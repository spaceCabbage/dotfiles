#!/bin/bash

### Qtile Autostart script

xrandr --output eDP-1 --mode 1920x1200
xinput set-prop 12 318 1
picom &
nitrogen --restore &
nm-applet &

echo "ran the autostart"
