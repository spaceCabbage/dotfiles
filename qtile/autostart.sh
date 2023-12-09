#!/bin/bash

xrandr --output eDP-1 --mode 1920x1200
picom &
nitrogen --restore &
nm-applet &

echo "ran the autostart"

