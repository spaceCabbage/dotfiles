#!/bin/bash
set -e

# Dotfiles Bootstrap Script
# Usage: curl -fsSL https://raw.githubusercontent.com/spaceCabbage/dotfiles/arch/install.sh | bash
# Or with custom user: GITHUB_USER=someone curl -fsSL ... | bash
# Flags: -y / --yes (non-interactive, install everything)

GITHUB_USER="${GITHUB_USER:-spaceCabbage}"
DOTFILES_DIR="$HOME/dotfiles"
AUTO_YES=false

for arg in "$@"; do
    case "$arg" in
        -y|--yes) AUTO_YES=true ;;
    esac
done

# Colors & Formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Ensure ~/.local/bin and ~/.cargo/bin are in PATH for current session
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH"

# Header Banner
echo ""
echo -e "${CYAN}╭────────────────────────────────────────────────────╮${NC}"
echo -e "${CYAN}│${NC}           ${BOLD}Dotfiles Bootstrap & Updater${NC}             ${CYAN}│${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  Repo:   ${GREEN}github.com/$GITHUB_USER/dotfiles${NC}"
echo -e "${CYAN}│${NC}  Target: ${GREEN}$DOTFILES_DIR${NC}"
echo -e "${CYAN}╰────────────────────────────────────────────────────╯${NC}"
echo ""

# Get sudo upfront and keep it alive (supports passwordless sudo / locked password)
info "Checking sudo privileges..."
if ! sudo -n true 2>/dev/null; then
    sudo -v < /dev/tty
fi
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
[[ "$DISTRO" == "unknown" ]] && error "Unsupported distribution (requires Arch/pacman or Debian/apt)"
info "Detected distro: ${BOLD}$DISTRO${NC}"

# Ensure core bootstrap tools (git, curl, ca-certificates) are installed
if ! command -v git &>/dev/null || ! command -v curl &>/dev/null; then
    info "Installing bootstrap dependencies (git, curl, ca-certificates)..."
    case $DISTRO in
        arch)   sudo pacman -Sy --needed --noconfirm git curl ca-certificates ;;
        debian) sudo apt update -qq && sudo apt install -y git curl ca-certificates ;;
    esac
fi

# Clone dotfiles if not present, or pull latest
if [[ ! -d "$DOTFILES_DIR" ]]; then
    info "Cloning dotfiles..."
    git clone "https://github.com/$GITHUB_USER/dotfiles.git" "$DOTFILES_DIR"
    success "Dotfiles cloned to $DOTFILES_DIR"
else
    info "Updating dotfiles repository..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not fast-forward pull (local changes present, continuing with local copy)"
    success "Dotfiles repository ready"
fi

cd "$DOTFILES_DIR"

# ==============================================================================
# Interactive yay/pacman-style Selection Helpers
# ==============================================================================

# Item descriptions for menu display
declare -A ITEM_DESC=(
    # System packages
    ["git"]="Distributed version control system"
    ["curl"]="Command-line tool for transferring data with URLs"
    ["wget"]="Network utility to retrieve files from the web"
    ["unzip"]="Archive extractor (required by bun & neovim)"
    ["tmux"]="Terminal multiplexer"
    ["zoxide"]="Smarter cd command that learns your habits"
    ["fzf"]="Command-line fuzzy finder"
    ["neovim"]="Vim-fork focused on extensibility and usability"
    ["eza"]="Modern, colorful replacement for ls"
    ["ripgrep"]="Fast recursive regex search tool (rg)"
    ["bat"]="Cat clone with syntax highlighting and git integration"
    ["jq"]="Lightweight and flexible command-line JSON processor"
    ["btop"]="Resource monitor for CPU, memory, disks, network & processes"
    ["duf"]="Disk Usage/Free utility"
    ["python"]="Python 3 runtime, pip & venv"
    ["go"]="Go programming language compiler & tools"
    # Curl tools
    ["starship"]="Fast, customizable cross-shell prompt"
    ["rustup"]="Rust toolchain installer & cargo package manager"
    ["bun"]="Fast all-in-one JavaScript runtime & bundler"
    ["uv"]="Extremely fast Python package and project manager"
    # Configs
    ["bash"]="Link ~/.bashrc, ~/.bash_aliases & preserve ~/.bashrc_local"
    ["tmux-conf"]="Link ~/.tmux.conf"
    ["tpm"]="Install/update Tmux Plugin Manager & tmux plugins"
    ["starship-conf"]="Link ~/.config/starship.toml"
    ["nvim-conf"]="Link ~/.config/nvim (Lazy.nvim setup)"
    ["konsole-conf"]="Link ~/.config/konsolerc & Konsole profiles"
    ["niri-conf"]="Link ~/.config/niri (Niri Wayland compositor)"
    ["hyprland-conf"]="Link ~/.config/hypr (Hyprland compositor)"
    ["waybar-conf"]="Link ~/.config/waybar (Wayland status bar)"
    ["rofi-conf"]="Link ~/.config/rofi (App launcher)"
    ["mako-conf"]="Link ~/.config/mako (Notification daemon)"
    ["swaylock-conf"]="Link ~/.config/swaylock (Screen locker)"
    ["desktop-scripts"]="Link ~/.local/bin/{powermenu,screenshot,clipboard}.sh"
)

# Check if a package/command is already installed on the system
is_pkg_installed() {
    local pkg="$1"
    case "$pkg" in
        ripgrep) command -v rg &>/dev/null ;;
        neovim)  command -v nvim &>/dev/null ;;
        python)  command -v python3 &>/dev/null ;;
        bat)     command -v bat &>/dev/null || command -v batcat &>/dev/null ;;
        rustup)  command -v rustup &>/dev/null || [[ -x "$HOME/.cargo/bin/rustup" ]] ;;
        bun)     command -v bun &>/dev/null || [[ -x "$HOME/.bun/bin/bun" ]] ;;
        uv)      command -v uv &>/dev/null || [[ -x "$HOME/.local/bin/uv" ]] ;;
        *)       command -v "$pkg" &>/dev/null ;;
    esac
}

# Check if a config item is already linked/installed
is_config_linked() {
    local cfg="$1"
    case "$cfg" in
        bash)            [[ -L "$HOME/.bashrc" && "$(readlink -f "$HOME/.bashrc")" == "$(readlink -f "$DOTFILES_DIR/terminal/.bashrc")" ]] ;;
        tmux-conf)       [[ -L "$HOME/.tmux.conf" && "$(readlink -f "$HOME/.tmux.conf")" == "$(readlink -f "$DOTFILES_DIR/terminal/.tmux.conf")" ]] ;;
        tpm)             [[ -d "$HOME/.tmux/plugins/tpm" ]] ;;
        starship-conf)   [[ -L "$HOME/.config/starship.toml" && "$(readlink -f "$HOME/.config/starship.toml")" == "$(readlink -f "$DOTFILES_DIR/terminal/starship.toml")" ]] ;;
        nvim-conf)       [[ -L "$HOME/.config/nvim" && "$(readlink -f "$HOME/.config/nvim")" == "$(readlink -f "$DOTFILES_DIR/nvim")" ]] ;;
        konsole-conf)    [[ -L "$HOME/.config/konsolerc" ]] ;;
        niri-conf)       [[ -L "$HOME/.config/niri" ]] ;;
        hyprland-conf)   [[ -L "$HOME/.config/hypr" ]] ;;
        waybar-conf)     [[ -L "$HOME/.config/waybar" ]] ;;
        rofi-conf)       [[ -L "$HOME/.config/rofi" ]] ;;
        mako-conf)       [[ -L "$HOME/.config/mako" ]] ;;
        swaylock-conf)   [[ -L "$HOME/.config/swaylock" ]] ;;
        desktop-scripts) [[ -L "$HOME/.local/bin/powermenu.sh" ]] ;;
        *)               return 1 ;;
    esac
}

# Helper to check if an item is in an array
in_array() {
    local needle="$1"
    shift
    local el
    for el in "$@"; do
        [[ "$el" == "$needle" ]] && return 0
    done
    return 1
}

# Parse and validate yay/pacman style number/range selection (e.g. "1 3 5-8 ^10" or "all" or "none")
# Returns 0 if valid, 1 if invalid/conflicting input
declare -A SKIP_MAP=()
parse_skip_input() {
    local input="$1"
    local max_idx="$2"
    SKIP_MAP=()

    # Normalize commas to spaces and trim whitespace
    input="${input//,/ }"
    input="${input#"${input%%[![:space:]]*}"}"
    input="${input%"${input##*[![:space:]]}"}"

    [[ -z "$input" ]] && return 0

    local tokens=($input)
    local has_all=false
    local has_none=false
    local has_numbers=false

    for token in "${tokens[@]}"; do
        case "${token,,}" in
            all|\*) has_all=true ;;
            none)   has_none=true ;;
            *)      has_numbers=true ;;
        esac
    done

    # Reject conflicting keywords (e.g., "all none", "all 1 2", "none 3")
    if ( $has_all && $has_none ) || ( $has_all && $has_numbers ) || ( $has_none && $has_numbers ); then
        warn "Conflicting selection: cannot combine 'all' or 'none' with other options."
        return 1
    fi

    if $has_none; then
        return 0
    fi

    if $has_all; then
        for ((i = 1; i <= max_idx; i++)); do
            SKIP_MAP[$i]=1
        done
        return 0
    fi

    for token in "${tokens[@]}"; do
        # Strip optional leading ^ (yay-style exclusion prefix)
        local clean="${token#^}"
        if [[ "$clean" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local start=$((10#${BASH_REMATCH[1]}))
            local end=$((10#${BASH_REMATCH[2]}))
            if (( start < 1 || end < 1 || start > max_idx || end > max_idx )); then
                warn "Range '$token' is out of bounds (valid range: 1-$max_idx)."
                return 1
            fi
            if (( start > end )); then
                warn "Invalid range '$token' (start $start is greater than end $end)."
                return 1
            fi
            for ((i = start; i <= end; i++)); do
                SKIP_MAP[$i]=1
            done
        elif [[ "$clean" =~ ^[0-9]+$ ]]; then
            local num=$((10#$clean))
            if (( num < 1 || num > max_idx )); then
                warn "Number '$token' is out of bounds (valid range: 1-$max_idx)."
                return 1
            fi
            SKIP_MAP[$num]=1
        else
            warn "Invalid option '$token'. Enter numbers (e.g. 1 3), ranges (e.g. 4-6), 'all', or press Enter."
            return 1
        fi
    done

    return 0
}

# Prompt user with a numbered list (yay/pacman style) and filter items
# Usage: prompt_step_selection "Step Title" "status_type" ITEM_ARRAY SELECTED_OUT_ARRAY
prompt_step_selection() {
    local step_title="$1"
    local status_type="$2" # "pkg" or "cfg"
    local -n items_ref="$3"
    local -n out_ref="$4"

    local count="${#items_ref[@]}"
    out_ref=()
    (( count == 0 )) && return 0

    echo ""
    echo -e "${MAGENTA}${BOLD}:: ${step_title}${NC}"
    echo -e "${DIM}──────────────────────────────────────────────────────────────────────${NC}"

    for ((i = 0; i < count; i++)); do
        local idx=$((i + 1))
        local item="${items_ref[$i]}"
        local desc="${ITEM_DESC[$item]:-}"
        local status_badge=""

        if [[ "$status_type" == "pkg" ]]; then
            if is_pkg_installed "$item"; then
                status_badge="${GREEN}[installed — will update]${NC}"
            else
                status_badge="${YELLOW}[new]${NC}"
            fi
        else
            if is_config_linked "$item"; then
                status_badge="${GREEN}[linked]${NC}"
            else
                status_badge="${YELLOW}[new]${NC}"
            fi
        fi

        printf "  ${BOLD}%2d)${NC} ${CYAN}%-16s${NC} %-44s %b\n" "$idx" "$item" "$desc" "$status_badge"
    done

    echo -e "${DIM}──────────────────────────────────────────────────────────────────────${NC}"

    local user_input=""
    if ! $AUTO_YES && [[ -e /dev/tty ]]; then
        while true; do
            echo -e "${BLUE}==>${NC} ${BOLD}Enter numbers to skip${NC} (e.g. ${YELLOW}1 3 5-7${NC}, ${YELLOW}^2${NC}, ${YELLOW}all${NC}, or ${GREEN}Enter${NC} to install all)"
            printf "${BLUE}==>${NC} Skip: "
            read -r user_input < /dev/tty || user_input=""
            if parse_skip_input "$user_input" "$count"; then
                break
            fi
        done
    else
        parse_skip_input "" "$count"
    fi

    local skipped_names=()
    for ((i = 0; i < count; i++)); do
        local idx=$((i + 1))
        if [[ -n "${SKIP_MAP[$idx]:-}" ]]; then
            skipped_names+=("${items_ref[$i]}")
        else
            out_ref+=("${items_ref[$i]}")
        fi
    done

    if (( ${#skipped_names[@]} > 0 )); then
        echo -e "  ${YELLOW}↷ Skipping (${#skipped_names[@]}):${NC} ${skipped_names[*]}"
    fi
    if (( ${#out_ref[@]} > 0 )); then
        echo -e "  ${GREEN}✓ Selected (${#out_ref[@]}):${NC} ${out_ref[*]}"
    else
        echo -e "  ${YELLOW}↷ All items skipped in this step${NC}"
    fi
}

# ==============================================================================
# Build Selection Lists & Prompt User (Step 1, Step 2, Step 3)
# with Conflict & Dependency Prevention
# ==============================================================================

# 1. Read packages from packages.txt (git and curl are core bootstrap deps, always installed)
ALL_PACKAGES=()
while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line// /}"
    [[ -z "$line" ]] && continue
    # git and curl are required by the installer itself; keep them out of skippable list
    [[ "$line" == "git" || "$line" == "curl" ]] && continue
    ALL_PACKAGES+=("$line")
done < "$DOTFILES_DIR/packages.txt"

SELECTED_PACKAGES=()
prompt_step_selection "[1/3] System Packages ($DISTRO)" "pkg" ALL_PACKAGES SELECTED_PACKAGES

# 2. Curl Dev Tools
ALL_CURL_TOOLS=("starship" "rustup" "bun" "uv")
SELECTED_TOOLS=()
prompt_step_selection "[2/3] Developer Tools (curl installers)" "pkg" ALL_CURL_TOOLS SELECTED_TOOLS

# Resolve dependency: bun and neovim require unzip
if ( in_array "bun" "${SELECTED_TOOLS[@]}" || in_array "neovim" "${SELECTED_PACKAGES[@]}" ) \
    && ! in_array "unzip" "${SELECTED_PACKAGES[@]}" && ! command -v unzip &>/dev/null; then
    info "Auto-enabling 'unzip' (required by selected tool: bun/neovim)"
    SELECTED_PACKAGES+=("unzip")
fi

# 3. Configs & Symlinks (dynamically filtered so user cannot pick configs whose apps are missing/skipped)
ALL_CONFIGS=("bash")

# Only offer tmux-conf & tpm if tmux is selected or already installed
if in_array "tmux" "${SELECTED_PACKAGES[@]}" || is_pkg_installed "tmux"; then
    ALL_CONFIGS+=("tmux-conf" "tpm")
else
    warn "Omitting 'tmux-conf' and 'tpm' from config options (tmux was skipped and is not installed)"
fi

# Only offer starship-conf if starship is selected or already installed
if in_array "starship" "${SELECTED_TOOLS[@]}" || is_pkg_installed "starship"; then
    ALL_CONFIGS+=("starship-conf")
else
    warn "Omitting 'starship-conf' from config options (starship was skipped and is not installed)"
fi

# Only offer nvim-conf if neovim is selected or already installed
if in_array "neovim" "${SELECTED_PACKAGES[@]}" || is_pkg_installed "neovim"; then
    ALL_CONFIGS+=("nvim-conf")
else
    warn "Omitting 'nvim-conf' from config options (neovim was skipped and is not installed)"
fi

if [[ $DISTRO == "arch" ]]; then
    ALL_CONFIGS+=("konsole-conf" "niri-conf" "hyprland-conf" "waybar-conf" "rofi-conf" "mako-conf" "swaylock-conf" "desktop-scripts")
fi

SELECTED_CONFIGS=()
prompt_step_selection "[3/3] Dotfile Configs & Symlinks" "cfg" ALL_CONFIGS SELECTED_CONFIGS

# Conflict prevention: tpm requires ~/.tmux.conf (tmux-conf) to be linked
if in_array "tpm" "${SELECTED_CONFIGS[@]}" && ! in_array "tmux-conf" "${SELECTED_CONFIGS[@]}" && [[ ! -f "$HOME/.tmux.conf" ]]; then
    info "Auto-enabling 'tmux-conf' because 'tpm' (Tmux Plugin Manager) requires ~/.tmux.conf"
    SELECTED_CONFIGS+=("tmux-conf")
fi

echo ""

# ==============================================================================
# Locale & Distro Bootstrap
# ==============================================================================

setup_debian_locale() {
    if [[ $DISTRO == "debian" ]] && ! locale -a 2>/dev/null | grep -qi "en_US\.utf-\?8"; then
        info "Generating en_US.UTF-8 locale for Debian..."
        sudo apt update -qq
        sudo apt install -y locales >/dev/null 2>&1 || true
        sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 2>/dev/null || true
        sudo locale-gen en_US.UTF-8 >/dev/null 2>&1 || true
        success "Locale en_US.UTF-8 generated"
    fi
}

ensure_yay_on_arch() {
    if [[ $DISTRO == "arch" ]] && ! command -v yay &>/dev/null; then
        info "Installing yay AUR helper..."
        sudo pacman -S --needed --noconfirm base-devel git
        rm -rf /tmp/yay-bin
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && makepkg -si --noconfirm)
        rm -rf /tmp/yay-bin
        success "yay installed"
    fi
}

# ==============================================================================
# Step 1: Install / Update System Packages
# ==============================================================================

# Package name mapping for Debian apt
declare -A PKG_MAP=(
    ["python"]="python3 python3-pip python3-venv"
    ["go"]="golang"
)

install_eza_debian() {
    if apt-cache show eza &>/dev/null; then
        sudo apt install -y eza && return 0
    fi
    info "Installing eza prebuilt binary from GitHub releases..."
    local arch_uname
    arch_uname=$(uname -m)
    local tmp_tar="/tmp/eza.tar.gz"
    if curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${arch_uname}-unknown-linux-gnu.tar.gz" -o "$tmp_tar"; then
        sudo tar -xzf "$tmp_tar" -C /usr/local/bin
        sudo chmod +x /usr/local/bin/eza
        rm -f "$tmp_tar"
        success "eza installed to /usr/local/bin/eza"
        return 0
    fi
    rm -f "$tmp_tar"
    warn "Prebuilt eza download failed; falling back to cargo install eza..."
    sudo apt install -y build-essential pkg-config
    if command -v cargo &>/dev/null; then
        cargo install eza
    fi
}

install_zoxide_debian() {
    if apt-cache show zoxide &>/dev/null; then
        sudo apt install -y zoxide && return 0
    fi
    info "Installing zoxide via official installer..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh < /dev/null
    success "zoxide installed"
}

install_duf_debian() {
    if apt-cache show duf &>/dev/null; then
        sudo apt install -y duf && return 0
    fi
    warn "duf not found in apt repositories on this Debian release"
}

install_neovim_debian() {
    # Check if Neovim >= 0.9 is available or already installed
    local need_binary=true
    if command -v nvim &>/dev/null; then
        local ver
        ver=$(nvim --version | head -n1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+).*/\1/')
        local major="${ver%%.*}"
        local minor="${ver#*.}"
        if [[ "$major" =~ ^[0-9]+$ && "$minor" =~ ^[0-9]+$ ]] && (( major > 0 || (major == 0 && minor >= 9) )); then
            need_binary=false
        fi
    fi

    # Check apt candidate version first
    if $need_binary && apt-cache show neovim &>/dev/null; then
        local apt_ver
        apt_ver=$(apt-cache policy neovim | awk '/Candidate:/ {print $2}' | sed -E 's/^[0-9]+://; s/^([0-9]+\.[0-9]+).*/\1/')
        local apt_major="${apt_ver%%.*}"
        local apt_minor="${apt_ver#*.}"
        if [[ "$apt_major" =~ ^[0-9]+$ && "$apt_minor" =~ ^[0-9]+$ ]] && (( apt_major > 0 || (apt_major == 0 && apt_minor >= 9) )); then
            sudo apt install -y neovim
            need_binary=false
        fi
    fi

    if $need_binary; then
        info "Installing latest official Neovim release binary (required for Lazy.nvim >= 0.9)..."
        local arch_uname
        arch_uname=$(uname -m)
        local nvim_arch="$arch_uname"
        [[ "$nvim_arch" == "aarch64" ]] && nvim_arch="arm64"

        local tmp_tar="/tmp/nvim-linux.tar.gz"
        if curl -fsSL "https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" -o "$tmp_tar" \
            || curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" -o "$tmp_tar"; then
            sudo rm -rf /opt/nvim
            sudo mkdir -p /opt/nvim
            sudo tar -xzf "$tmp_tar" -C /opt/nvim --strip-components=1
            sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
            rm -f "$tmp_tar"
            success "Neovim $(nvim --version | head -n1) installed to /usr/local/bin/nvim"
        else
            rm -f "$tmp_tar"
            warn "Could not download official Neovim binary, falling back to apt neovim"
            sudo apt install -y neovim || true
        fi
    else
        # If installed via apt, ensure it stays updated
        if [[ ! -L /usr/local/bin/nvim ]]; then
            sudo apt install -y neovim || true
        fi
        success "Neovim $(nvim --version | head -n1) is up to date"
    fi
}

install_packages() {
    if (( ${#SELECTED_PACKAGES[@]} == 0 )); then
        info "Skipping system packages (none selected)"
        return 0
    fi

    info "Installing/updating selected system packages..."

    if [[ $DISTRO == "arch" ]]; then
        ensure_yay_on_arch
        yay -S --needed --noconfirm "${SELECTED_PACKAGES[@]}"
        success "Arch packages installed/updated"
        return 0
    fi

    # Debian package handling
    sudo apt update -qq
    local apt_packages=("ca-certificates")
    local install_eza=false
    local install_zoxide=false
    local install_duf=false
    local install_nvim=false
    local install_bat=false

    for pkg in "${SELECTED_PACKAGES[@]}"; do
        case "$pkg" in
            eza)    install_eza=true ;;
            zoxide) install_zoxide=true ;;
            duf)    install_duf=true ;;
            neovim) install_nvim=true; apt_packages+=("build-essential" "unzip") ;;
            bat)    install_bat=true; apt_packages+=("bat") ;;
            *)
                if [[ -n "${PKG_MAP[$pkg]:-}" ]]; then
                    # shellcheck disable=SC2206
                    apt_packages+=(${PKG_MAP[$pkg]})
                else
                    apt_packages+=("$pkg")
                fi
                ;;
        esac
    done

    if (( ${#apt_packages[@]} > 0 )); then
        sudo apt install -y "${apt_packages[@]}" || warn "Some apt packages may have failed"
    fi

    # Debian installs bat as /usr/bin/batcat — symlink to ~/.local/bin/bat
    if $install_bat && command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        success "Linked ~/.local/bin/bat -> $(command -v batcat)"
    fi

    $install_zoxide && install_zoxide_debian
    $install_duf && install_duf_debian
    $install_eza && install_eza_debian
    $install_nvim && install_neovim_debian

    success "System packages installed/updated"
}

# ==============================================================================
# Step 2: Install / Update Developer Tools (via curl)
# ==============================================================================

ensure_tool_prereq() {
    local bin="$1"
    local pkg="${2:-$1}"
    if ! command -v "$bin" &>/dev/null; then
        info "Installing required prerequisite '$pkg'..."
        case $DISTRO in
            arch)   sudo pacman -S --needed --noconfirm "$pkg" ;;
            debian) sudo apt update -qq && sudo apt install -y "$pkg" ;;
        esac
    fi
}

install_curl_tools() {
    if (( ${#SELECTED_TOOLS[@]} == 0 )); then
        info "Skipping curl developer tools (none selected)"
        return 0
    fi

    info "Installing/updating selected developer tools..."

    # Starship prompt
    if in_array "starship" "${SELECTED_TOOLS[@]}"; then
        info "Installing/updating starship..."
        curl -sS https://starship.rs/install.sh | sudo sh -s -- -y < /dev/null
        success "starship ready ($(starship --version | head -n1))"
    fi

    # Rustup & Cargo
    if in_array "rustup" "${SELECTED_TOOLS[@]}"; then
        # Ensure C compiler is available for cargo builds
        if [[ $DISTRO == "debian" ]] && ! command -v cc &>/dev/null; then
            info "Installing build-essential & pkg-config for Rust/Cargo..."
            sudo apt install -y build-essential pkg-config
        fi

        if ! command -v rustup &>/dev/null && [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
            info "Installing rustup..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path < /dev/null
            source "$HOME/.cargo/env" 2>/dev/null || true
            success "rustup installed"
        else
            info "Updating rustup toolchains..."
            source "$HOME/.cargo/env" 2>/dev/null || true
            rustup update
            success "rustup updated"
        fi
    fi

    # Bun (requires unzip!)
    if in_array "bun" "${SELECTED_TOOLS[@]}"; then
        ensure_tool_prereq unzip unzip
        if ! command -v bun &>/dev/null && [[ ! -x "$HOME/.bun/bin/bun" ]]; then
            info "Installing bun..."
            curl -fsSL https://bun.sh/install | bash < /dev/null
            export BUN_INSTALL="$HOME/.bun"
            export PATH="$BUN_INSTALL/bin:$PATH"
            success "bun installed ($(bun --version 2>/dev/null || echo 'latest'))"
        else
            info "Updating bun..."
            export BUN_INSTALL="$HOME/.bun"
            export PATH="$BUN_INSTALL/bin:$PATH"
            bun upgrade || true
            success "bun updated ($(bun --version 2>/dev/null || echo 'latest'))"
        fi
    fi

    # uv (Python package manager)
    if in_array "uv" "${SELECTED_TOOLS[@]}"; then
        if ! command -v uv &>/dev/null && [[ ! -x "$HOME/.local/bin/uv" ]]; then
            info "Installing uv..."
            env UV_NO_MODIFY_PATH=1 sh -c 'curl -LsSf https://astral.sh/uv/install.sh | sh' < /dev/null
            success "uv installed"
        else
            info "Updating uv..."
            uv self update 2>/dev/null || env UV_NO_MODIFY_PATH=1 sh -c 'curl -LsSf https://astral.sh/uv/install.sh | sh' < /dev/null
            success "uv updated"
        fi
    fi
}

# ==============================================================================
# Step 3: Configurations, Symlinks & Tmux Plugin Manager
# ==============================================================================

create_symlink() {
    local src="$1"
    local dest="$2"

    dest="${dest/#\~/$HOME}"

    if [[ ! -e "$src" ]]; then
        warn "Source does not exist, skipping symlink: $src"
        return 0
    fi

    # If dest is already correct symlink, skip cleanly
    if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
        success "Already linked: $dest"
        return 0
    fi

    # If dest exists (file, dir, or wrong symlink), backup safely
    if [[ -e "$dest" || -L "$dest" ]]; then
        local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        mv -f "$dest" "$backup_dir/"
        warn "Backed up: $dest -> $backup_dir/"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    success "Linked: $dest -> $src"
}

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

preserve_bash_config() {
    local preserved=false

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

install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing tmux plugin manager (TPM)..."
        mkdir -p "$HOME/.tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed"
    else
        info "Updating tmux plugin manager (TPM)..."
        git -C "$HOME/.tmux/plugins/tpm" pull --ff-only 2>/dev/null || true
        success "TPM up to date"
    fi

    if ! command -v tmux &>/dev/null; then
        warn "tmux is not installed; skipping tmux plugin installation"
        return 0
    fi

    if [[ -f "$HOME/.tmux.conf" ]] && [[ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]]; then
        info "Installing & updating tmux plugins..."
        # Keep a temporary session alive if no tmux server is running so the
        # global TMUX_PLUGIN_MANAGER_PATH environment variable persists across
        # all TPM helper subprocesses.
        local created_tmp_session=false
        if ! tmux has-session 2>/dev/null; then
            tmux new-session -d -s __dotfiles_tpm_init 2>/dev/null && created_tmp_session=true || true
        fi
        tmux start-server \; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/" 2>/dev/null || true

        TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/" "$HOME/.tmux/plugins/tpm/bin/install_plugins" || warn "Some tmux plugins could not be installed"
        if [[ -x "$HOME/.tmux/plugins/tpm/bin/update_plugins" ]]; then
            TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/" "$HOME/.tmux/plugins/tpm/bin/update_plugins" all >/dev/null 2>&1 || true
        fi

        if $created_tmp_session; then
            tmux kill-session -t __dotfiles_tpm_init 2>/dev/null || true
        fi
        success "Tmux plugins installed & updated"
    fi
}

setup_selected_configs() {
    if (( ${#SELECTED_CONFIGS[@]} == 0 )); then
        info "Skipping configuration symlinks (none selected)"
        return 0
    fi

    info "Setting up selected configurations..."

    if in_array "bash" "${SELECTED_CONFIGS[@]}"; then
        create_bashrc_local
        preserve_bash_config
        create_symlink "$DOTFILES_DIR/terminal/.bashrc" "$HOME/.bashrc"
        create_symlink "$DOTFILES_DIR/terminal/.bash_aliases" "$HOME/.bash_aliases"
    fi

    if in_array "tmux-conf" "${SELECTED_CONFIGS[@]}"; then
        create_symlink "$DOTFILES_DIR/terminal/.tmux.conf" "$HOME/.tmux.conf"
    fi

    if in_array "starship-conf" "${SELECTED_CONFIGS[@]}"; then
        create_symlink "$DOTFILES_DIR/terminal/starship.toml" "$HOME/.config/starship.toml"
    fi

    if in_array "nvim-conf" "${SELECTED_CONFIGS[@]}"; then
        create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    fi

    if [[ $DISTRO == "arch" ]]; then
        if in_array "konsole-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/konsole/.config/konsolerc" "$HOME/.config/konsolerc"
            create_symlink "$DOTFILES_DIR/konsole/.local/share/konsole" "$HOME/.local/share/konsole"
        fi
        if in_array "niri-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/niri/.config/niri" "$HOME/.config/niri"
        fi
        if in_array "hyprland-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/hyprland/.config/hypr" "$HOME/.config/hypr"
        fi
        if in_array "waybar-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/waybar/.config/waybar" "$HOME/.config/waybar"
        fi
        if in_array "rofi-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/rofi/.config/rofi" "$HOME/.config/rofi"
        fi
        if in_array "mako-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/mako/.config/mako" "$HOME/.config/mako"
        fi
        if in_array "swaylock-conf" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/swaylock/.config/swaylock" "$HOME/.config/swaylock"
        fi
        if in_array "desktop-scripts" "${SELECTED_CONFIGS[@]}"; then
            create_symlink "$DOTFILES_DIR/scripts/.local/bin/powermenu.sh" "$HOME/.local/bin/powermenu.sh"
            create_symlink "$DOTFILES_DIR/scripts/.local/bin/screenshot.sh" "$HOME/.local/bin/screenshot.sh"
            create_symlink "$DOTFILES_DIR/scripts/.local/bin/clipboard.sh" "$HOME/.local/bin/clipboard.sh"
        fi
    fi

    # Run TPM after tmux.conf symlink is in place
    if in_array "tpm" "${SELECTED_CONFIGS[@]}"; then
        install_tpm
    fi
}

# ==============================================================================
# Main Execution
# ==============================================================================

main() {
    setup_debian_locale
    # Preserve bash config first if bash config is selected, before curl installers touch ~/.bashrc
    if in_array "bash" "${SELECTED_CONFIGS[@]}"; then
        create_bashrc_local
        preserve_bash_config
    fi
    install_packages
    install_curl_tools
    setup_selected_configs

    echo ""
    echo -e "${GREEN}╭────────────────────────────────────────────────────╮${NC}"
    echo -e "${GREEN}│${NC}              ${BOLD}✓ Setup Complete!${NC}                     ${GREEN}│${NC}"
    echo -e "${GREEN}╰────────────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "  Restart your shell or run: ${CYAN}source ~/.bashrc${NC}"
    echo ""
}

main "$@"
