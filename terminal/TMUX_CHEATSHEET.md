# Tmux Cheatsheet

Prefix: `Ctrl+a`

## Quick Reference (Mobile-Friendly)

### Windows
| Keys | Action |
|------|--------|
| `prefix + 1-9` | Jump to window 1-9 |
| `prefix + c` | New window |
| `prefix + v` | Split vertical |
| `prefix + s` | Split horizontal |
| `M-j / M-k` | Next/prev window (no prefix) |

### Panes
| Keys | Action |
|------|--------|
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + z` | Zoom/unzoom pane |
| `prefix + x` | Kill pane |
| `prefix + X` | Kill window |

### Menus (Great for Mobile!)
| Keys | Action |
|------|--------|
| `prefix + Space` | **Which-Key menu** (shows all keybindings) |
| `prefix + \` | **Tmux-Menus** (hierarchical menu system) |

### Sessions
| Keys | Action |
|------|--------|
| `prefix + Space, s` | Session submenu |
| `prefix + d` | Detach |

### Copy Mode
| Keys | Action |
|------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Yank selection |

### Other
| Keys | Action |
|------|--------|
| `prefix + r` | Reload config |
| `prefix + ?` | List all keybindings |

## Which-Key Menu Structure

Press `prefix + Space` to open, then:

- `Space` - Command prompt
- `w` - Windows menu
- `p` - Panes menu
- `b` - Buffers menu
- `s` - Sessions menu
- `C` - Client menu (plugins, reload, etc.)
- `c` - Copy menu

## Tips for Mobile SSH (DaRemote)

1. **Use the menus** - `prefix + \` opens tmux-menus with full navigation
2. **Number keys** - `prefix + 1-9` for quick window switching
3. **Mouse is enabled** - tap to select panes
4. **Prefix tip** - `Ctrl+a` is easier than `Ctrl+b` on mobile

## Installation

After modifying `.tmux.conf`, install new plugins:
```bash
# Inside tmux, press:
prefix + I   # (capital I) to install plugins

# Or reload config:
prefix + r
```
