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
install_cask font-fira-code-nerd-font
install_formula starship

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
