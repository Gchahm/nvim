#!/bin/bash

# Nvim Configuration Installer
# This script installs the nvim configuration from any location to ~/.config/nvim

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

print_info "Starting nvim configuration installation..."
print_info "Script directory: $SCRIPT_DIR"
print_info "Target directory: $NVIM_CONFIG_DIR"

# Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    print_warning "Neovim is not installed. Please install it first:"
    print_info "  Ubuntu/Debian: sudo apt install neovim"
    print_info "  Fedora: sudo dnf install neovim"
    print_info "  Arch: sudo pacman -S neovim"
    print_info "  Or install from: https://github.com/neovim/neovim/releases"
    echo
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installation cancelled."
        exit 1
    fi
fi

# Create backup if existing config exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "Existing nvim configuration found."
    print_info "Creating backup at: $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    print_success "Backup created successfully."
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy nvim configuration files
print_info "Copying nvim configuration files..."

# Create the nvim config directory
mkdir -p "$NVIM_CONFIG_DIR"

# Copy all nvim-related files (excluding git, terminal themes, and scripts)
cp "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG_DIR/"
cp "$SCRIPT_DIR/lazy-lock.json" "$NVIM_CONFIG_DIR/"
cp "$SCRIPT_DIR/luarc.json" "$NVIM_CONFIG_DIR/"

# Copy directories
if [ -d "$SCRIPT_DIR/lua" ]; then
    cp -r "$SCRIPT_DIR/lua" "$NVIM_CONFIG_DIR/"
fi

if [ -d "$SCRIPT_DIR/after" ]; then
    cp -r "$SCRIPT_DIR/after" "$NVIM_CONFIG_DIR/"
fi

print_success "Nvim configuration files copied successfully."

# Handle bashrc integration
BASHRC_SOURCE_LINE="source ~/.config/nvim/.bashrc"
CUSTOM_BASHRC="$NVIM_CONFIG_DIR/.bashrc"

# Copy the custom bashrc to nvim config
if [ -f "$SCRIPT_DIR/.bashrc" ]; then
    print_info "Setting up custom bashrc..."
    cp "$SCRIPT_DIR/.bashrc" "$CUSTOM_BASHRC"
    
    # Check if already sourced in ~/.profile
    if [ -f "$HOME/.profile" ] && grep -q "$BASHRC_SOURCE_LINE" "$HOME/.profile"; then
        print_info "Custom bashrc already sourced in ~/.profile"
    else
        print_info "Adding source line to ~/.profile"
        echo "" >> "$HOME/.profile"
        echo "# Source nvim custom bashrc" >> "$HOME/.profile"
        echo "$BASHRC_SOURCE_LINE" >> "$HOME/.profile"
        print_success "Custom bashrc integration added to ~/.profile"
    fi
    
    # Also check ~/.bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if grep -q "$BASHRC_SOURCE_LINE" "$HOME/.bashrc"; then
            print_info "Custom bashrc already sourced in ~/.bashrc"
        else
            echo
            read -p "Do you want to add the custom bashrc to your ~/.bashrc as well? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "" >> "$HOME/.bashrc"
                echo "# Source nvim custom bashrc" >> "$HOME/.bashrc"
                echo "$BASHRC_SOURCE_LINE" >> "$HOME/.bashrc"
                print_success "Custom bashrc integration added to ~/.bashrc"
            fi
        fi
    fi
fi

# Copy terminal themes if they exist
if [ -d "$SCRIPT_DIR/.terminal" ]; then
    print_info "Copying terminal themes..."
    cp -r "$SCRIPT_DIR/.terminal" "$NVIM_CONFIG_DIR/"
    print_success "Terminal themes copied."
fi

# Check for Node.js and nvm
print_info "Checking Node.js setup..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js is already installed: $NODE_VERSION"
elif command -v nvm &> /dev/null; then
    print_warning "nvm is available but no Node.js version is active."
    print_info "Please run: nvm install 20 && nvm use 20"
else
    print_warning "Neither Node.js nor nvm found."
    print_info "Some nvim plugins may require Node.js. Consider installing nvm:"
    print_info "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    print_info "  Then: nvm install 20 && nvm use 20"
fi

print_success "Installation completed successfully!"
echo
print_info "Next steps:"
print_info "1. Restart your terminal or run: source ~/.profile"
print_info "2. If you need Node.js: nvm install 20 && nvm use 20"
print_info "3. Start nvim and let Lazy.nvim install plugins"
echo
print_info "Your old configuration has been backed up to: $BACKUP_DIR"
print_info "Run ./uninstall.sh to revert changes if needed."