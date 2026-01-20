# Niri Setup Cheatsheet

## Starting Niri

1. Log out of KDE
2. At SDDM login screen, click the session selector (bottom-left)
3. Choose "Niri" instead of "Plasma"
4. Log in

To return to KDE: `Super+Shift+E` to quit Niri, then select Plasma at login.

---

## What's Running

These start automatically:
- **Waybar** - Status bar (top)
- **Mako** - Notifications
- **swww** - Wallpaper daemon
- **wlsunset** - Night light (auto blue filter)
- **cliphist** - Clipboard history
- **xwayland-satellite** - X11 app support

---

## Keybindings

### Apps
| Key | Action |
|-----|--------|
| `Super+Enter` | Terminal (Konsole) |
| `Super+B` | Brave browser |
| `Super+E` | Dolphin file manager |
| `Alt+Space` | App launcher (Rofi) |

### Windows
| Key | Action |
|-----|--------|
| `Super+Q` | Close window |
| `Super+F` | Maximize column |
| `Super+Shift+F` | Fullscreen |
| `Super+Space` | Toggle floating |

### Navigation
| Key | Action |
|-----|--------|
| `Super+Arrow` | Focus window/column |
| `Super+Shift+Arrow` | Move window |
| `Super+1-9` | Go to workspace |
| `Super+Shift+1-9` | Move window to workspace |
| `Super+Tab` | Previous workspace |

### Mouse Scroll (hold Super)
| Action | Result |
|--------|--------|
| Scroll up/down | Focus left/right |
| Shift+Scroll | Move window left/right |

### Column Width
| Key | Action |
|-----|--------|
| `Super+R` | Cycle presets (33%/50%/66%) |
| `Super+Minus` | Shrink 10% |
| `Super+Equal` | Grow 10% |

### Utilities
| Key | Action |
|-----|--------|
| `Super+S` | Screenshot area |
| `Super+Shift+S` | Screenshot full |
| `Super+V` | Clipboard history |
| `Super+P` | Color picker |
| `Super+L` | Lock screen |
| `Super+Shift+Q` | Power menu |

### Media Keys
Volume, brightness, and player controls work as expected.

---

## Touchpad Gestures

| Gesture | Action |
|---------|--------|
| 3-finger swipe left/right | Switch workspace |
| 3-finger swipe up | Overview |
| 2-finger scroll | Scroll view |

---

## First-Time Setup

### Set wallpaper
```bash
swww img ~/path/to/wallpaper.jpg
```

### Test notifications
```bash
notify-send "Hello" "Niri is working!"
```

---

## Theme

Gruvbox Dark with 12px gaps and rounded corners (12px radius).

| Element | Color |
|---------|-------|
| Border active | `#83a598` (blue) |
| Border inactive | `#504945` (gray) |
| Background | `#282828` |

---

## Config Locations

All configs symlinked from `~/dotfiles/`:

```
~/.config/niri/config.kdl      # Main config
~/.config/waybar/              # Status bar
~/.config/rofi/                # Launcher
~/.config/mako/config          # Notifications
~/.config/swaylock/config      # Lock screen
~/.local/bin/                  # Scripts
```

---

## Troubleshooting

**Validate config:**
```bash
niri validate
```

**Reload config (while in Niri):**
```bash
Super+Shift+R
```

**Check outputs:**
```bash
niri msg outputs
```
