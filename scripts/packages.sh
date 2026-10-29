#!/usr/bin/env bash
# Installs the tools these dotfiles expect (run by bootstrap.sh; link.sh does not need it).
#   macOS: brew bundle, driven by ../Brewfile
#   Linux: packages-linux.sh (apt list + upstream installers)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

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
print_info "Installing packages for $OS..."

case "$OS" in
    Darwin)
        if ! command -v brew &> /dev/null; then
            print_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew bundle --file="$REPO_DIR/Brewfile"
        ;;
    Linux)
        source "$SCRIPT_DIR/packages-linux.sh"
        ;;
    *)
        print_error "Unsupported OS: $OS"
        exit 1
        ;;
esac

print_success "Done. Open a new terminal, then run: fnm install --lts"
