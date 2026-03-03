#!/bin/bash

# Nvim Configuration Uninstaller
# This script removes the installed nvim configuration and reverts changes

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

NVIM_CONFIG_DIR="$HOME/.config/nvim"
BASHRC_SOURCE_LINE="source ~/.config/nvim/.bashrc"

print_info "Starting nvim configuration uninstall..."

# Check if nvim config exists (symlink or directory)
if [ ! -L "$NVIM_CONFIG_DIR" ] && [ ! -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "No nvim configuration found at $NVIM_CONFIG_DIR"
    print_info "Nothing to uninstall."
    exit 0
fi

# Confirm uninstall
echo
print_warning "This will remove your nvim configuration from $NVIM_CONFIG_DIR"
print_info "This includes:"
print_info "  - All nvim configuration files"
print_info "  - Custom bashrc integration"
print_info "  - Terminal themes"
echo
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Uninstall cancelled."
    exit 1
fi

# Look for and offer to restore backups
BACKUP_DIRS=($(find "$HOME/.config" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null | sort -r))

if [ ${#BACKUP_DIRS[@]} -gt 0 ]; then
    echo
    print_info "Found ${#BACKUP_DIRS[@]} backup(s):"
    for i in "${!BACKUP_DIRS[@]}"; do
        BACKUP_NAME=$(basename "${BACKUP_DIRS[$i]}")
        print_info "  $((i+1)). $BACKUP_NAME"
    done
    echo
    read -p "Do you want to restore a backup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ ${#BACKUP_DIRS[@]} -eq 1 ]; then
            SELECTED_BACKUP="${BACKUP_DIRS[0]}"
        else
            echo "Select a backup to restore:"
            for i in "${!BACKUP_DIRS[@]}"; do
                BACKUP_NAME=$(basename "${BACKUP_DIRS[$i]}")
                echo "$((i+1)). $BACKUP_NAME"
            done
            read -p "Enter selection (1-${#BACKUP_DIRS[@]}): " -r SELECTION
            if [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ "$SELECTION" -ge 1 ] && [ "$SELECTION" -le ${#BACKUP_DIRS[@]} ]; then
                SELECTED_BACKUP="${BACKUP_DIRS[$((SELECTION-1))]}"
            else
                print_error "Invalid selection. Skipping backup restore."
                SELECTED_BACKUP=""
            fi
        fi
        
        if [ -n "$SELECTED_BACKUP" ]; then
            print_info "Removing current configuration..."
            rm -f "$NVIM_CONFIG_DIR" 2>/dev/null || rm -rf "$NVIM_CONFIG_DIR"
            print_info "Restoring backup from: $SELECTED_BACKUP"
            mv "$SELECTED_BACKUP" "$NVIM_CONFIG_DIR"
            print_success "Backup restored successfully!"
        fi
    else
        # Just remove the current configuration
        print_info "Removing nvim configuration..."
        rm -rf "$NVIM_CONFIG_DIR"
        print_success "Nvim configuration removed."
    fi
else
    # No backups found, just remove
    print_info "Removing nvim configuration..."
    rm -rf "$NVIM_CONFIG_DIR"
    print_success "Nvim configuration removed."
fi

# Remove bashrc integration
print_info "Removing bashrc integration..."

# Remove from ~/.profile
if [ -f "$HOME/.profile" ]; then
    if grep -q "$BASHRC_SOURCE_LINE" "$HOME/.profile"; then
        # Create a temporary file without the source line and the comment
        grep -v "$BASHRC_SOURCE_LINE" "$HOME/.profile" | grep -v "# Source nvim custom bashrc" > "$HOME/.profile.tmp"
        mv "$HOME/.profile.tmp" "$HOME/.profile"
        print_success "Removed bashrc integration from ~/.profile"
    fi
fi

# Remove from ~/.bashrc
if [ -f "$HOME/.bashrc" ]; then
    if grep -q "$BASHRC_SOURCE_LINE" "$HOME/.bashrc"; then
        echo
        read -p "Remove bashrc integration from ~/.bashrc as well? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create a temporary file without the source line and the comment
            grep -v "$BASHRC_SOURCE_LINE" "$HOME/.bashrc" | grep -v "# Source nvim custom bashrc" > "$HOME/.bashrc.tmp"
            mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
            print_success "Removed bashrc integration from ~/.bashrc"
        fi
    fi
fi

# Clean up empty lines that might be left behind
for file in "$HOME/.profile" "$HOME/.bashrc"; do
    if [ -f "$file" ]; then
        # Remove multiple consecutive empty lines, leaving only one
        sed -i '/^$/N;/^\n$/d' "$file"
    fi
done

print_success "Uninstall completed successfully!"
echo
print_info "Your terminal configuration has been restored to its previous state."
print_info "You may want to restart your terminal or run: source ~/.profile"

# Show remaining backups
REMAINING_BACKUPS=($(find "$HOME/.config" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null))
if [ ${#REMAINING_BACKUPS[@]} -gt 0 ]; then
    echo
    print_info "Remaining backups (you can remove these manually if not needed):"
    for backup in "${REMAINING_BACKUPS[@]}"; do
        BACKUP_NAME=$(basename "$backup")
        print_info "  $backup"
    done
fi