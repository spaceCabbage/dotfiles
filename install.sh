#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

echo "Installing all required packages"

# sudo apt update
# sudo apt install nala btop neovim zoxide hstr exa laygit git cowsay

# Function to create a symbolic link with backup
link_file() {
    if [ -L "$2" ]; then
        echo "Removing existing symbolic link: $2"
        rm "$2"
    elif [ -e "$2" ]; then
        echo "Backing up existing file: $2"
        mv "$2" "$2.bak"
    fi
    echo "Linking: $1"
    ln -s "$1" "$2"
}

# Assuming the script is located in the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Link Dotfiles to their respective locations
echo "linking dotfiles"
link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo -------------
echo "All done!"
echo -------------
