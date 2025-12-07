# Dotfiles

Personal dotfiles for Arch Linux and Debian servers.

## Quick Install

**Fresh machine (one-liner):**
```bash
curl -fsSL https://raw.githubusercontent.com/spaceCabbage/dotfiles/main/install.sh | bash
```

**With custom GitHub username:**
```bash
GITHUB_USER=someone curl -fsSL https://raw.githubusercontent.com/someone/dotfiles/main/install.sh | bash
```

**Already cloned:**
```bash
cd ~/dotfiles && ./install.sh
```

## What It Does

1. Detects distro (Arch or Debian)
2. Installs git and yay (on Arch)
3. Clones this repo to `~/dotfiles`
4. Installs packages from `packages.txt`
5. Installs tools via curl (starship, rustup, bun, uv)
6. Creates symlinks (backs up existing files to `~/.dotfiles-backup/`)
7. Creates `~/.bashrc_local` for machine-specific config

## Symlinks Created

| Source                   | Target                    |
|--------------------------|---------------------------|
| `terminal/.bashrc`       | `~/.bashrc`               |
| `terminal/.bash_aliases` | `~/.bash_aliases`         |
| `terminal/.tmux.conf`    | `~/.tmux.conf`            |
| `terminal/starship.toml` | `~/.config/starship.toml` |
| `nvim/`                  | `~/.config/nvim`          |
| `konsole/` configs       | `~/.config/` (Arch only)  |

## Packages

Edit `packages.txt` to customize. One package per line, comments with `#`.

Tools installed via curl (not package manager):
- **starship** - prompt
- **rustup** - Rust toolchain
- **bun** - JavaScript runtime
- **uv** - Python package manager

## Re-running

Safe to run multiple times:
- Existing correct symlinks are skipped
- Existing files are backed up before replacing
- Already-installed packages are skipped (`--needed`)
