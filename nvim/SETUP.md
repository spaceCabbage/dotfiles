# Neovim Configuration Setup Guide

Complete setup and installation instructions for this Neovim configuration.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [First Launch](#first-launch)
4. [Verification](#verification)
5. [Team Setup](#team-setup)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required

- **Neovim** 0.9 or later
  ```bash
  nvim --version
  ```

- **Git** (for version control integration)
  ```bash
  git --version
  ```

### Recommended

- **Node.js 16+** (for TypeScript LSP and other tools)
  ```bash
  node --version
  ```

- **Python 3** (for Python LSP and tools)
  ```bash
  python3 --version
  ```

- **Go 1.21+** (for Go LSP)
  ```bash
  go version
  ```

- **Nerd Font** (for icons to display properly)
  - Download from [nerdfonts.com](https://www.nerdfonts.com)
  - Install and set as your terminal font
  - Recommended: JetBrains Mono Nerd Font

### Optional

- **ripgrep** (faster grepping)
  ```bash
  brew install ripgrep  # macOS
  apt install ripgrep   # Linux
  ```

- **fzf** (fuzzy finder)
  ```bash
  brew install fzf      # macOS
  apt install fzf       # Linux
  ```

## Installation

### Option 1: Clone Dotfiles Repo

```bash
# Clone the repository
git clone <your-dotfiles-repo> ~/dotfiles

# Create symlink to nvim config
mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config/nvim

# Or if already linked via dotfiles setup
# Your dotfiles sync script handles this
```

### Option 2: Copy Config Directly

```bash
# Copy nvim directory
cp -r ./nvim ~/.config/nvim
```

### Option 3: Fresh Install (No Existing Config)

```bash
# If you have an existing config, back it up first
mv ~/.config/nvim ~/.config/nvim.backup

# Copy this config
cp -r ./nvim ~/.config/nvim
```

## First Launch

### Step 1: Open Neovim

```bash
nvim
```

### Step 2: Wait for Plugin Installation

- Lazy.nvim will automatically download and install all plugins
- First run takes **2-5 minutes** depending on internet speed
- You'll see a dashboard with install progress
- **DO NOT** close Neovim during this process

### Step 3: LSP Servers Installation

- Mason will automatically start installing LSP servers
- Check progress: `:Mason` (appears after initial plugins load)
- This happens in background, you can use editor while it installs
- Takes 5-10 minutes total for all servers

### Step 4: Close and Reopen

```bash
# Close Neovim
:q

# Reopen - everything should be ready now
nvim
```

## Verification

### Health Check

Run the built-in health check:

```
:checkhealth
```

**Expected output:**
- ✅ nvim health check passes
- ✅ LSP: Shows which servers are active
- ✅ gitsigns: Git integration working
- ✅ No errors in output

### Check LSP Status

```
:LspInfo
```

Should show LSP servers for your current file type.

### Check Formatters

```
:ConformInfo
```

Shows which formatters are configured and working.

### Check Git Integration

```
:checkhealth gitsigns
```

Should show gitsigns working if in a git repository.

## Common Issues During Setup

### Issue: Plugins not installing

**Solution:**
```
:Lazy sync
```

### Issue: Some LSP servers not installed

**Solution:**
```
:Mason
```

Navigate and press `i` (install) for any missing servers.

### Issue: "nvim" command not found

**macOS:**
```bash
brew install neovim
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install neovim
```

**Linux (Arch):**
```bash
sudo pacman -S neovim
```

### Issue: Slow startup on first run

- This is normal! First run downloads ~50 plugins
- Subsequent launches: ~100-200ms startup time
- Check startup performance: `:Lazy profile`

## Team Setup

### For Team Members

1. **Clone/get the dotfiles**
   ```bash
   git clone <team-dotfiles-repo>
   cd dotfiles
   ```

2. **Run setup script** (if your team has one)
   ```bash
   ./setup.sh  # or whatever your setup script is called
   ```

3. **Or manual setup**
   ```bash
   mkdir -p ~/.config
   ln -s $(pwd)/nvim ~/.config/nvim
   nvim
   # Wait for automatic setup
   ```

4. **Install system dependencies**
   ```bash
   # macOS
   brew install neovim node python go ripgrep fzf

   # Ubuntu/Debian
   sudo apt-get install neovim nodejs python3 golang ripgrep fzf

   # Arch
   sudo pacman -S neovim nodejs python go ripgrep fzf
   ```

### Creating a Team Setup Script

**`setup-nvim.sh` example:**

```bash
#!/bin/bash
set -e

echo "🚀 Setting up Neovim config..."

# Check Neovim version
if ! command -v nvim &> /dev/null; then
    echo "❌ Neovim not installed. Install with:"
    echo "   brew install neovim (macOS)"
    echo "   sudo apt-get install neovim (Linux)"
    exit 1
fi

# Create config directory
mkdir -p ~/.config

# Remove existing config if it's not a symlink
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    echo "⚠️  Existing ~/.config/nvim found, backing up..."
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Create symlink
ln -sf "$(pwd)/nvim" ~/.config/nvim

echo "✅ Config linked"
echo "📦 First launch will install all plugins..."
echo "🚀 Run: nvim"
```

Make executable:
```bash
chmod +x setup-nvim.sh
```

## Customization After Setup

### Change Keybindings

Edit `nvim/init.lua` or relevant `lua/*.lua` files

All keybindings use `vim.keymap.set()` and include descriptions.

### Add LSP Server

1. Edit `nvim/lua/lsp.lua`
2. Add to `servers` table:
   ```lua
   rust_analyzer = {},  -- Rust
   ```
3. Add to `ensure_installed` in Mason:
   ```lua
   'rust-analyzer',
   ```
4. Run `:Mason` and verify it installed

### Add Formatter

Edit `nvim/lua/formatting.lua`:
```lua
formatters_by_ft = {
  rust = { 'rustfmt' },
  -- etc
}
```

### Change Theme

Edit `nvim/lua/theme.lua`:
```lua
vim.cmd.colorscheme 'catppuccin'  -- or your theme
```

## Performance Tuning

### Check Startup Time

```bash
nvim --startuptime /tmp/startup.log +q
cat /tmp/startup.log
```

### Identify Slow Plugins

```
:Lazy profile
```

Look for plugins taking >50ms.

## Uninstalling

If you need to remove this config:

```bash
# Backup (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Remove entirely
rm -rf ~/.config/nvim

# Or if symlinked:
unlink ~/.config/nvim
```

## Next Steps

1. **Read [QUICKSTART.md](./QUICKSTART.md)** - Get productive in 5 minutes
2. **See [KEYBINDINGS.md](./KEYBINDINGS.md)** - All available keybindings
3. **Check [NEOVIM_PLUGINS_GUIDE.md](./NEOVIM_PLUGINS_GUIDE.md)** - Master the plugins
4. **Review [ARCHITECTURE.md](./ARCHITECTURE.md)** - Understand the structure

## Support

Having issues?

1. Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
2. Run `:checkhealth` to diagnose
3. Check plugin README files: `:Lazy` → select plugin → `d`
4. Search GitHub issues for plugins

---

**Configuration is ready!** You're now set to be productive with Neovim 🎉
