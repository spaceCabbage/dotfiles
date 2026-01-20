#!/bin/bash
# Power Menu Script for Rofi

options="  Lock\n  Logout\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" -theme powermenu -mesg "Power Menu")

case "$chosen" in
    *Lock*)
        swaylock
        ;;
    *Logout*)
        niri msg action quit
        ;;
    *Reboot*)
        systemctl reboot
        ;;
    *Shutdown*)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
