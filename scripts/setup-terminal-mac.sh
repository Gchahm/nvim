#!/bin/bash

# Sets up terminal tools on macOS via Homebrew.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

if [ "$(uname -s)" != "Darwin" ]; then
    print_error "This script only supports macOS."
    exit 1
fi

if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please run install-dependencies.sh first."
    exit 1
fi

install_cask() {
    local cask="$1"
    if brew list --cask "$cask" &> /dev/null; then
        print_success "$cask is already installed."
    else
        print_info "Installing $cask..."
        brew install --cask "$cask"
        print_success "$cask installed."
    fi
}

install_formula() {
    local formula="$1"
    if brew list "$formula" &> /dev/null; then
        print_success "$formula is already installed."
    else
        print_info "Installing $formula..."
        brew install "$formula"
        print_success "$formula installed."
    fi
}

echo
print_info "Setting up terminal tools..."
echo

install_cask iterm2
install_cask font-jetbrains-mono-nerd-font
install_formula starship

# Symlink iTerm2 preferences
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM2_SOURCE_DIR="$(dirname "$SCRIPT_DIR")/iterm2"
ITERM2_CONFIG_DIR="$HOME/.config/iterm2"

if [ -L "$ITERM2_CONFIG_DIR" ]; then
    if [ "$(readlink -f "$ITERM2_CONFIG_DIR")" = "$ITERM2_SOURCE_DIR" ]; then
        print_success "iTerm2 config already symlinked to this repository."
    else
        print_info "Replacing existing iTerm2 symlink..."
        rm "$ITERM2_CONFIG_DIR"
        ln -s "$ITERM2_SOURCE_DIR" "$ITERM2_CONFIG_DIR"
        print_success "iTerm2 symlink updated."
    fi
elif [ -d "$ITERM2_CONFIG_DIR" ]; then
    ITERM2_BACKUP="$HOME/.config/iterm2.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Backing up existing iTerm2 config to $ITERM2_BACKUP"
    mv "$ITERM2_CONFIG_DIR" "$ITERM2_BACKUP"
    ln -s "$ITERM2_SOURCE_DIR" "$ITERM2_CONFIG_DIR"
    print_success "iTerm2 symlink created (old config backed up)."
else
    mkdir -p "$HOME/.config"
    ln -s "$ITERM2_SOURCE_DIR" "$ITERM2_CONFIG_DIR"
    print_success "Symlink created: $ITERM2_CONFIG_DIR -> $ITERM2_SOURCE_DIR"
fi

STARSHIP_INIT='eval "$(starship init zsh)"'
if ! grep -qF "$STARSHIP_INIT" ~/.zshrc 2>/dev/null; then
    print_info "Adding starship init to ~/.zshrc..."
    echo "" >> ~/.zshrc
    echo "$STARSHIP_INIT" >> ~/.zshrc
    print_success "Starship init added to ~/.zshrc."
else
    print_success "Starship init already in ~/.zshrc."
fi

echo
print_success "Terminal setup complete!"
