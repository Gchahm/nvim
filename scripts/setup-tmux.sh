#!/bin/bash

# Installs tmux, symlinks config, and sets up Tmux Plugin Manager (TPM) on macOS.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

OS="$(uname -s)"

install_package() {
    local pkg="$1"
    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew &> /dev/null; then
            print_error "Homebrew is not installed. Please run install-dependencies.sh first."
            exit 1
        fi
        brew install "$pkg"
    elif [ -f /etc/debian_version ]; then
        sudo apt-get update && sudo apt-get install -y "$pkg"
    elif [ -f /etc/redhat-release ]; then
        sudo dnf install -y "$pkg"
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S --noconfirm "$pkg"
    else
        print_error "Unsupported Linux distribution. Please install $pkg manually."
        exit 1
    fi
}

is_installed() {
    local pkg="$1"
    if [ "$OS" = "Darwin" ]; then
        brew list "$pkg" &> /dev/null
    else
        command -v "$pkg" &> /dev/null
    fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")/tmux"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
BACKUP_DIR="$HOME/.config/tmux.backup.$(date +%Y%m%d_%H%M%S)"

echo
print_info "Setting up tmux..."
echo

# Install tmux
if is_installed tmux; then
    print_success "tmux is already installed."
else
    print_info "Installing tmux..."
    install_package tmux
    print_success "tmux installed."
fi

# Install fzf
if is_installed fzf; then
    print_success "fzf is already installed."
else
    print_info "Installing fzf..."
    install_package fzf
    print_success "fzf installed."
fi

# Symlink tmux config directory
if [ -L "$TMUX_CONFIG_DIR" ]; then
    if [ "$(readlink -f "$TMUX_CONFIG_DIR")" = "$SOURCE_DIR" ]; then
        print_success "tmux config already symlinked to this repository."
    else
        print_warning "Existing symlink found pointing elsewhere. Replacing it."
        rm "$TMUX_CONFIG_DIR"
        ln -s "$SOURCE_DIR" "$TMUX_CONFIG_DIR"
        print_success "Symlink updated."
    fi
elif [ -d "$TMUX_CONFIG_DIR" ]; then
    print_warning "Existing tmux config found. Creating backup at: $BACKUP_DIR"
    mv "$TMUX_CONFIG_DIR" "$BACKUP_DIR"
    ln -s "$SOURCE_DIR" "$TMUX_CONFIG_DIR"
    print_success "Symlink created (old config backed up)."
else
    mkdir -p "$HOME/.config"
    ln -s "$SOURCE_DIR" "$TMUX_CONFIG_DIR"
    print_success "Symlink created: $TMUX_CONFIG_DIR -> $SOURCE_DIR"
fi

# Source our config from ~/.tmux.conf
SOURCE_LINE="source-file ~/.config/tmux/tmux.conf"
if [ -f ~/.tmux.conf ] && grep -qF "$SOURCE_LINE" ~/.tmux.conf 2>/dev/null; then
    print_success "~/.tmux.conf already sources our config."
else
    print_info "Adding source line to ~/.tmux.conf..."
    echo "$SOURCE_LINE" >> ~/.tmux.conf
    print_success "~/.tmux.conf updated."
fi

# Install TPM
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
    print_success "Tmux Plugin Manager is already installed."
else
    print_info "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_success "Tmux Plugin Manager installed."
fi

echo
print_success "tmux setup complete!"
print_info "Press prefix + I inside tmux to install plugins."
