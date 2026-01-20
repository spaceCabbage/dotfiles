#!/bin/bash
# Clipboard History Script using cliphist and rofi

cliphist list | rofi -dmenu -p "Clipboard" -display-columns 2 | cliphist decode | wl-copy
