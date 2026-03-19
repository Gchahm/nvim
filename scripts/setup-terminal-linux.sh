#!/bin/bash

# Sets up terminal tools on Linux without requiring sudo.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

if [ "$(uname -s)" != "Linux" ]; then
    print_error "This script only supports Linux."
    exit 1
fi

echo
print_info "Setting up terminal tools..."
echo

# Install JetBrains Mono Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if fc-list | grep -qi "JetBrainsMono Nerd Font" 2>/dev/null; then
    print_success "JetBrains Mono Nerd Font is already installed."
else
    print_info "Installing JetBrains Mono Nerd Font..."
    TMPDIR="$(mktemp -d)"
    curl -fsSL -o "$TMPDIR/JetBrainsMono.tar.xz" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    mkdir -p "$FONT_DIR"
    tar -xf "$TMPDIR/JetBrainsMono.tar.xz" -C "$FONT_DIR"
    rm -rf "$TMPDIR"
    fc-cache -f "$FONT_DIR"
    print_success "JetBrains Mono Nerd Font installed."
fi

# Install Starship prompt
if command -v starship &> /dev/null; then
    print_success "Starship is already installed."
else
    print_info "Installing Starship..."
    BIN_DIR="$HOME/.local/bin"
    mkdir -p "$BIN_DIR"
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$BIN_DIR"
    print_success "Starship installed to $BIN_DIR."
fi

# Add starship init to shell rc
SHELL_NAME="$(basename "$SHELL")"
case "$SHELL_NAME" in
    zsh)  RC_FILE="$HOME/.zshrc";    INIT_LINE='eval "$(starship init zsh)"' ;;
    bash) RC_FILE="$HOME/.bashrc";   INIT_LINE='eval "$(starship init bash)"' ;;
    fish) RC_FILE="$HOME/.config/fish/config.fish"; INIT_LINE='starship init fish | source' ;;
    *)    RC_FILE=""; print_error "Unsupported shell: $SHELL_NAME. Add starship init manually." ;;
esac

if [ -n "$RC_FILE" ]; then
    if ! grep -qF "$INIT_LINE" "$RC_FILE" 2>/dev/null; then
        print_info "Adding starship init to $RC_FILE..."
        echo "" >> "$RC_FILE"
        echo "$INIT_LINE" >> "$RC_FILE"
        print_success "Starship init added to $RC_FILE."
    else
        print_success "Starship init already in $RC_FILE."
    fi
fi

echo
print_success "Terminal setup complete!"
