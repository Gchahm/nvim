#!/bin/bash

# Removes the ~/.config/nvim symlink and cleans up bashrc integration.
# Offers to restore a backup if one exists.

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

NVIM_CONFIG_DIR="$HOME/.config/nvim"
BASHRC_SOURCE_LINE="source ~/.config/nvim/.bashrc"

if [ ! -L "$NVIM_CONFIG_DIR" ] && [ ! -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "No nvim configuration found at $NVIM_CONFIG_DIR"
    exit 0
fi

# Confirm
echo
print_warning "This will remove your nvim configuration from $NVIM_CONFIG_DIR"
read -p "Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Cancelled."
    exit 1
fi

# Check for backups
BACKUP_DIRS=($(find "$HOME/.config" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null | sort -r))

if [ ${#BACKUP_DIRS[@]} -gt 0 ]; then
    echo
    print_info "Found ${#BACKUP_DIRS[@]} backup(s):"
    for i in "${!BACKUP_DIRS[@]}"; do
        print_info "  $((i+1)). $(basename "${BACKUP_DIRS[$i]}")"
    done
    echo
    read -p "Restore a backup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ ${#BACKUP_DIRS[@]} -eq 1 ]; then
            SELECTED_BACKUP="${BACKUP_DIRS[0]}"
        else
            read -p "Enter selection (1-${#BACKUP_DIRS[@]}): " -r SELECTION
            if [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ "$SELECTION" -ge 1 ] && [ "$SELECTION" -le ${#BACKUP_DIRS[@]} ]; then
                SELECTED_BACKUP="${BACKUP_DIRS[$((SELECTION-1))]}"
            else
                print_error "Invalid selection. Skipping restore."
                SELECTED_BACKUP=""
            fi
        fi

        if [ -n "$SELECTED_BACKUP" ]; then
            rm -f "$NVIM_CONFIG_DIR" 2>/dev/null || rm -rf "$NVIM_CONFIG_DIR"
            mv "$SELECTED_BACKUP" "$NVIM_CONFIG_DIR"
            print_success "Backup restored."
        fi
    else
        rm -f "$NVIM_CONFIG_DIR" 2>/dev/null || rm -rf "$NVIM_CONFIG_DIR"
        print_success "Configuration removed."
    fi
else
    rm -f "$NVIM_CONFIG_DIR" 2>/dev/null || rm -rf "$NVIM_CONFIG_DIR"
    print_success "Configuration removed."
fi

# Remove bashrc integration
for rcfile in "$HOME/.profile" "$HOME/.bashrc"; do
    if [ -f "$rcfile" ] && grep -q "$BASHRC_SOURCE_LINE" "$rcfile"; then
        grep -v "$BASHRC_SOURCE_LINE" "$rcfile" | grep -v "# Source nvim custom bashrc" > "${rcfile}.tmp"
        mv "${rcfile}.tmp" "$rcfile"
        # Clean up consecutive empty lines
        sed -i '' '/^$/N;/^\n$/d' "$rcfile" 2>/dev/null || sed -i '/^$/N;/^\n$/d' "$rcfile"
        print_success "Removed bashrc integration from $(basename "$rcfile")"
    fi
done

echo
print_success "Done! Restart your terminal or run: source ~/.profile"

REMAINING_BACKUPS=($(find "$HOME/.config" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null))
if [ ${#REMAINING_BACKUPS[@]} -gt 0 ]; then
    echo
    print_info "Remaining backups (remove manually if not needed):"
    for backup in "${REMAINING_BACKUPS[@]}"; do
        print_info "  $backup"
    done
fi
