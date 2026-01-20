#!/bin/bash
set -e

# Dotfiles Bootstrap Script
# Usage: curl -fsSL https://raw.githubusercontent.com/spaceCabbage/dotfiles/main/install.sh | bash
# Or with custom user: GITHUB_USER=someone curl -fsSL ... | bash

GITHUB_USER="${GITHUB_USER:-spaceCabbage}"
DOTFILES_DIR="$HOME/dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Show what this script will do
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}       Dotfiles Bootstrap Script        ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "This script will:"
echo "  1. Install packages from packages.txt (using yay/apt)"
echo "  2. Install dev tools: starship, rustup, bun, uv"
echo "  3. Create symlinks for dotfiles (backup existing files)"
echo "  4. Create ~/.bashrc_local for machine-specific config"
echo ""
echo -e "Repo: ${GREEN}github.com/$GITHUB_USER/dotfiles${NC}"
echo -e "Target: ${GREEN}$DOTFILES_DIR${NC}"
echo ""

# Get sudo upfront and keep it alive
info "Requesting sudo privileges..."
sudo -v
# Keep sudo alive in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Detect distro
detect_distro() {
    if command -v pacman &>/dev/null; then
        echo "arch"
    elif command -v apt &>/dev/null; then
        echo "debian"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
info "Detected distro: $DISTRO"

# Install git if missing
if ! command -v git &>/dev/null; then
    info "Installing git..."
    case $DISTRO in
        arch)   sudo pacman -S --noconfirm git ;;
        debian) sudo apt update && sudo apt install -y git ;;
        *)      error "Unknown distro, please install git manually" ;;
    esac
fi

# Install yay on Arch if missing
if [[ $DISTRO == "arch" ]] && ! command -v yay &>/dev/null; then
    info "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
    success "yay installed"
fi

# Clone dotfiles if not present, or pull latest
if [[ ! -d "$DOTFILES_DIR" ]]; then
    info "Cloning dotfiles..."
    git clone "https://github.com/$GITHUB_USER/dotfiles.git" "$DOTFILES_DIR"
    success "Dotfiles cloned to $DOTFILES_DIR"
else
    info "Pulling latest dotfiles..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not pull (local changes?)"
    success "Dotfiles updated"
fi

cd "$DOTFILES_DIR"

# Package name mapping for Debian
declare -A PKG_MAP=(
    ["python"]="python3"
    ["python-pip"]="python3-pip"
    ["python-venv"]="python3-venv"
    ["go"]="golang"
)

# Packages to skip on Debian (not in apt or installed via curl)
SKIP_ON_DEBIAN="eza zoxide duf starship"

# Install packages from packages.txt
install_packages() {
    info "Installing packages..."
    local packages=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Remove comments and trim whitespace
        line="${line%%#*}"
        line="${line// /}"
        [[ -z "$line" ]] && continue

        # Skip certain packages on Debian
        if [[ $DISTRO == "debian" && " $SKIP_ON_DEBIAN " == *" $line "* ]]; then
            warn "Skipping $line (will install via curl)"
            continue
        fi

        # Map package names for Debian
        if [[ $DISTRO == "debian" && -n "${PKG_MAP[$line]}" ]]; then
            packages+=("${PKG_MAP[$line]}")
        else
            packages+=("$line")
        fi
    done < "$DOTFILES_DIR/packages.txt"

    if [[ ${#packages[@]} -gt 0 ]]; then
        case $DISTRO in
            arch)
                yay -S --needed --noconfirm "${packages[@]}"
                ;;
            debian)
                sudo apt update
                sudo apt install -y "${packages[@]}" || warn "Some packages may have failed"
                ;;
        esac
    fi
    success "Packages installed"
}

# Install tools via curl (not in package managers or better installed this way)
install_curl_tools() {
    info "Installing tools via curl..."

    # Starship prompt (installs to /usr/local/bin, needs sudo)
    if ! command -v starship &>/dev/null; then
        info "Installing starship (may prompt for sudo)..."
        curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
        success "starship installed"
    fi

    # Rustup (and cargo)
    if ! command -v rustup &>/dev/null; then
        info "Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env" 2>/dev/null || true
        success "rustup installed"
    fi

    # Bun
    if ! command -v bun &>/dev/null; then
        info "Installing bun..."
        curl -fsSL https://bun.sh/install | bash
        success "bun installed"
    fi

    # uv (Python package manager)
    if ! command -v uv &>/dev/null; then
        info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        success "uv installed"
    fi

    # Debian-specific: install tools not in apt via cargo
    if [[ $DISTRO == "debian" ]]; then
        source "$HOME/.cargo/env" 2>/dev/null || true

        if ! command -v eza &>/dev/null && command -v cargo &>/dev/null; then
            info "Installing eza via cargo..."
            cargo install eza
        fi

        if ! command -v zoxide &>/dev/null && command -v cargo &>/dev/null; then
            info "Installing zoxide via cargo..."
            cargo install zoxide
        fi

        if ! command -v bat &>/dev/null && command -v cargo &>/dev/null; then
            info "Installing bat via cargo..."
            cargo install bat
        fi

        if ! command -v duf &>/dev/null; then
            warn "duf needs manual install on Debian (see https://github.com/muesli/duf)"
        fi

    fi
}

# Install TPM (tmux plugin manager) and plugins
install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing tmux plugin manager..."
        mkdir -p ~/.tmux/plugins
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        success "TPM installed"
    else
        success "TPM already installed"
    fi

    # Install tmux plugins (requires tmux.conf to be linked first)
    if [[ -f "$HOME/.tmux.conf" ]] && [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
        info "Installing tmux plugins..."
        TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" "$HOME/.tmux/plugins/tpm/bin/install_plugins"
        success "Tmux plugins installed"
    fi
}

# Create symlink with backup
create_symlink() {
    local src="$1"
    local dest="$2"

    # Expand ~ in dest
    dest="${dest/#\~/$HOME}"

    # If dest is already correct symlink, skip
    if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
        success "Already linked: $dest"
        return
    fi

    # If dest exists (file, dir, or wrong symlink), backup
    if [[ -e "$dest" || -L "$dest" ]]; then
        local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        mv "$dest" "$backup_dir/"
        warn "Backed up: $dest -> $backup_dir/"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
    success "Linked: $dest -> $src"
}

# Preserve existing bash config before symlinking
preserve_bash_config() {
    local preserved=false

    # Check for existing .bashrc (not a symlink to our repo)
    if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]]; then
        info "Preserving existing .bashrc content..."
        {
            echo ""
            echo "# === Preserved from original .bashrc ($(date +%Y-%m-%d)) ==="
            cat "$HOME/.bashrc"
            echo "# === End preserved .bashrc ==="
            echo ""
        } >> "$HOME/.bashrc_local"
        preserved=true
    fi

    # Check for existing .bash_aliases (not a symlink to our repo)
    if [[ -f "$HOME/.bash_aliases" && ! -L "$HOME/.bash_aliases" ]]; then
        info "Preserving existing .bash_aliases content..."
        {
            echo ""
            echo "# === Preserved from original .bash_aliases ($(date +%Y-%m-%d)) ==="
            cat "$HOME/.bash_aliases"
            echo "# === End preserved .bash_aliases ==="
            echo ""
        } >> "$HOME/.bashrc_local"
        preserved=true
    fi

    if $preserved; then
        success "Existing bash config preserved in ~/.bashrc_local"
    fi
}

# Setup symlinks
setup_symlinks() {
    info "Setting up symlinks..."

    # Terminal configs
    create_symlink "$DOTFILES_DIR/terminal/.bashrc" "$HOME/.bashrc"
    create_symlink "$DOTFILES_DIR/terminal/.bash_aliases" "$HOME/.bash_aliases"
    create_symlink "$DOTFILES_DIR/terminal/.tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$DOTFILES_DIR/terminal/starship.toml" "$HOME/.config/starship.toml"

    # Neovim
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Konsole (skip on servers/Debian)
    if [[ $DISTRO == "arch" ]]; then
        create_symlink "$DOTFILES_DIR/konsole/.config/konsolerc" "$HOME/.config/konsolerc"
        create_symlink "$DOTFILES_DIR/konsole/.local/share/konsole" "$HOME/.local/share/konsole"

        # Niri Wayland compositor
        create_symlink "$DOTFILES_DIR/niri/.config/niri" "$HOME/.config/niri"

        # Waybar status bar
        create_symlink "$DOTFILES_DIR/waybar/.config/waybar" "$HOME/.config/waybar"

        # Rofi launcher
        create_symlink "$DOTFILES_DIR/rofi/.config/rofi" "$HOME/.config/rofi"

        # Mako notifications
        create_symlink "$DOTFILES_DIR/mako/.config/mako" "$HOME/.config/mako"

        # Swaylock
        create_symlink "$DOTFILES_DIR/swaylock/.config/swaylock" "$HOME/.config/swaylock"

        # Scripts
        create_symlink "$DOTFILES_DIR/scripts/.local/bin/powermenu.sh" "$HOME/.local/bin/powermenu.sh"
        create_symlink "$DOTFILES_DIR/scripts/.local/bin/screenshot.sh" "$HOME/.local/bin/screenshot.sh"
        create_symlink "$DOTFILES_DIR/scripts/.local/bin/clipboard.sh" "$HOME/.local/bin/clipboard.sh"
    fi
}

# Create bashrc_local if missing
create_bashrc_local() {
    if [[ ! -f "$HOME/.bashrc_local" ]]; then
        info "Creating ~/.bashrc_local..."
        cat > "$HOME/.bashrc_local" << 'EOF'
# Local bash configuration (machine-specific)
# This file is sourced by .bashrc and is NOT tracked in git
# Add your machine-specific aliases, exports, and functions here

EOF
        success "Created ~/.bashrc_local"
    else
        success "~/.bashrc_local already exists"
    fi
}

# Main
main() {
    install_packages
    install_curl_tools
    create_bashrc_local      # Create template first
    preserve_bash_config     # Append existing config before symlinking
    setup_symlinks           # Now safe to replace with symlinks
    install_tpm              # Install tmux plugin manager and plugins

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}            Setup Complete!             ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Restart your shell or run: source ~/.bashrc"
    echo ""
}

main "$@"
