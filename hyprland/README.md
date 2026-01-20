# Hyprland Setup

Gruvbox-themed Hyprland config with blur, transparency, and animations.

## Quick Start

1. **Install:** `sudo pacman -S hyprland hypridle hyprlock hyprcursor`
2. **Launch:** Select "Hyprland" at login screen (or run `Hyprland` from TTY)
3. **Open terminal:** Press `Super + Return`

## Tutorial: First 5 Minutes

1. `Super + Return` - Open Konsole
2. `Alt + Space` - Open app launcher (rofi)
3. `Super + Q` - Close focused window
4. `Super + 2` - Switch to workspace 2
5. `Super + Shift + 2` - Move window to workspace 2
6. `Super + arrows` - Navigate between windows
7. `Super + Space` - Make window floating
8. `Super + F` - Fullscreen

## Cheatsheet

### Apps
| Key | Action |
|-----|--------|
| `Super + Return` | Konsole (terminal) |
| `Super + Shift + Return` | Scratchpad terminal |
| `Alt + Space` | Rofi app launcher |
| `Super + B` | Brave browser |
| `Super + E` | Dolphin file manager |

### Windows
| Key | Action |
|-----|--------|
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + Space` | Toggle floating |
| `Super + arrows` | Move focus |
| `Super + Shift + arrows` | Move window |

### Workspaces
| Key | Action |
|-----|--------|
| `Super + 1-9` | Go to workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Tab` | Previous workspace |
| `Super + scroll` | Cycle workspaces |

### Resize
| Key | Action |
|-----|--------|
| `Super + -` | Shrink width 10% |
| `Super + =` | Grow width 10% |
| `Super + Shift + -` | Shrink height 10% |
| `Super + Shift + =` | Grow height 10% |

### Utilities
| Key | Action |
|-----|--------|
| `Super + V` | Clipboard history |
| `Super + S` | Screenshot (select area) |
| `Super + Shift + S` | Screenshot (full) |
| `Super + L` | Lock screen |
| `Super + P` | Color picker |

### Session
| Key | Action |
|-----|--------|
| `Super + Shift + R` | Reload config |
| `Super + Shift + Q` | Power menu |
| `Super + Shift + E` | Exit Hyprland |

### Media Keys
Volume, brightness, play/pause work as expected.

## Config Files

- `~/.config/hypr/hyprland.conf` - Main config
- `~/.config/waybar/` - Status bar (shared with niri)
- `~/.config/rofi/` - App launcher
- `~/.config/mako/` - Notifications

## Commands

```bash
hyprctl reload          # Reload config (no restart)
hyprctl monitors        # List displays
hyprctl clients         # List windows
hyprctl activewindow    # Current window info
hyprctl keyword ...     # Change setting live
```

## Hyprland vs Niri

| Feature | Hyprland | Niri |
|---------|----------|------|
| Blur | Yes | No |
| Window transparency | Yes | No |
| Tiling | Traditional | Scrolling columns |
| Animations | Highly customizable | Basic |
| Stability | Good | Excellent |

Both are available at login - pick based on your mood!

## Troubleshooting

**Black screen on NVIDIA?**
Config already has NVIDIA env vars. If issues persist:
```bash
# Check logs
cat ~/.local/share/hyprland/hyprland.log
```

**Waybar not showing?**
```bash
killall waybar && waybar -c ~/.config/waybar/config-hyprland.jsonc &
```

**Apps look wrong (scaling)?**
Already set in config. Adjust `monitor=` line if needed.
