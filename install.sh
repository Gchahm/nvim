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
SOURCE_DIR="$SCRIPT_DIR/nvim"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

print_info "Starting nvim configuration installation..."
print_info "Script directory: $SCRIPT_DIR"
print_info "Source directory: $SOURCE_DIR"
print_info "Target directory: $NVIM_CONFIG_DIR"

NVIM_REQUIRED_MAJOR=0
NVIM_REQUIRED_MINOR=11

install_neovim() {
    print_info "Installing Neovim 0.11 (stable)..."

    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64)  local nvim_asset="nvim-linux-x86_64.tar.gz" ;;
        aarch64) local nvim_asset="nvim-linux-arm64.tar.gz" ;;
        *)
            print_error "Unsupported architecture: $arch"
            print_info "Please install Neovim 0.11+ manually from: https://github.com/neovim/neovim/releases"
            exit 1
            ;;
    esac

    local install_dir="$HOME/.local"
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    print_info "Downloading $nvim_asset..."
    curl -L -o "$tmp_dir/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/latest/download/$nvim_asset"

    print_info "Extracting to $install_dir..."
    mkdir -p "$install_dir"
    tar -C "$install_dir" --strip-components=1 -xzf "$tmp_dir/nvim.tar.gz"
    rm -rf "$tmp_dir"

    # Ensure ~/.local/bin is on PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    print_success "Neovim $(nvim --version | head -1) installed to $install_dir/bin/nvim"
    print_info "Make sure $HOME/.local/bin is in your PATH (usually already set in ~/.profile)"
}

# Check nvim version — install if missing or below 0.11
nvim_ok=false
if command -v nvim &> /dev/null; then
    nvim_ver="$(nvim --version | head -1 | grep -oP '\d+\.\d+'  | head -1)"
    nvim_major="${nvim_ver%%.*}"
    nvim_minor="${nvim_ver##*.}"
    if [ "$nvim_major" -gt "$NVIM_REQUIRED_MAJOR" ] || \
       { [ "$nvim_major" -eq "$NVIM_REQUIRED_MAJOR" ] && [ "$nvim_minor" -ge "$NVIM_REQUIRED_MINOR" ]; }; then
        print_success "Neovim $(nvim --version | head -1) detected."
        nvim_ok=true
    else
        print_warning "Neovim $nvim_ver is too old (need 0.11+)."
    fi
else
    print_warning "Neovim is not installed."
fi

if [ "$nvim_ok" = false ]; then
    echo
    read -p "Install Neovim 0.11 (stable) now? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Skipping Neovim install. Note: some plugins require 0.11+."
    else
        install_neovim
    fi
fi

# Verify source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    print_error "Source directory not found: $SOURCE_DIR"
    print_info "Make sure you're running this script from the repository root."
    exit 1
fi

# Create backup if existing config exists (skip if it's already our symlink)
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
    print_success "Backup created successfully."
fi

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Create symlink
print_info "Creating symlink: $NVIM_CONFIG_DIR -> $SOURCE_DIR"
ln -s "$SOURCE_DIR" "$NVIM_CONFIG_DIR"
print_success "Symlink created. Any changes in the repo are immediately live."

# Handle bashrc integration
BASHRC_SOURCE_LINE="source ~/.config/nvim/.bashrc"

if [ -f "$SOURCE_DIR/.bashrc" ]; then
    print_info "Setting up custom bashrc..."

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
if [ -d "$BACKUP_DIR" ]; then
    print_info "Your old configuration has been backed up to: $BACKUP_DIR"
fi
print_info "Run ./uninstall.sh to revert changes if needed."