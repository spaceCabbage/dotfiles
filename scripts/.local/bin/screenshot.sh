#!/bin/bash
# Screenshot Script for Niri
# Uses grim + slurp for screenshots

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
    area)
        # Select area with slurp, capture with grim
        grim -g "$(slurp)" - | tee "$FILENAME" | wl-copy
        notify-send "Screenshot" "Area captured and copied to clipboard" -i "$FILENAME"
        ;;
    full)
        # Full screen capture
        grim - | tee "$FILENAME" | wl-copy
        notify-send "Screenshot" "Screen captured and copied to clipboard" -i "$FILENAME"
        ;;
    window)
        # Current window (uses niri msg to get focused window geometry)
        # Fallback to area selection if window geometry not available
        grim -g "$(slurp)" - | tee "$FILENAME" | wl-copy
        notify-send "Screenshot" "Window captured and copied to clipboard" -i "$FILENAME"
        ;;
    *)
        echo "Usage: $0 {area|full|window}"
        exit 1
        ;;
esac
