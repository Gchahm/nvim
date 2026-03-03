#!/bin/bash

# Creates a symlink from ~/.config/nvim to this repo's nvim/ directory.
# Backs up any existing config before linking.

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(dirname "$SCRIPT_DIR")/nvim"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
BASHRC_SOURCE_LINE="source ~/.config/nvim/.bashrc"

# Verify source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Handle existing config
if [ -L "$NVIM_CONFIG_DIR" ]; then
    if [ "$(readlink -f "$NVIM_CONFIG_DIR")" = "$SOURCE_DIR" ]; then
        print_info "Already symlinked to this repository. Nothing to do."
        exit 0
    fi
    print_warning "Existing symlink found pointing elsewhere. Removing it."
    rm "$NVIM_CONFIG_DIR"
elif [ -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "Existing nvim configuration found."
    print_info "Creating backup at: $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    print_success "Backup created."
fi

# Create symlink
mkdir -p "$HOME/.config"
print_info "Creating symlink: $NVIM_CONFIG_DIR -> $SOURCE_DIR"
ln -s "$SOURCE_DIR" "$NVIM_CONFIG_DIR"
print_success "Symlink created."

# Bashrc integration
if [ -f "$SOURCE_DIR/.bashrc" ]; then
    for rcfile in "$HOME/.profile" "$HOME/.bashrc"; do
        if [ -f "$rcfile" ] && grep -q "$BASHRC_SOURCE_LINE" "$rcfile"; then
            print_info "Custom bashrc already sourced in $(basename "$rcfile")"
        elif [ -f "$rcfile" ]; then
            echo "" >> "$rcfile"
            echo "# Source nvim custom bashrc" >> "$rcfile"
            echo "$BASHRC_SOURCE_LINE" >> "$rcfile"
            print_success "Added bashrc integration to $(basename "$rcfile")"
        fi
    done
fi

echo
print_success "Done! Restart your terminal or run: source ~/.profile"
