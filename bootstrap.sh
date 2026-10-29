#!/usr/bin/env bash
# Sets up a new machine: installs packages, then links the dotfiles.
# This is the entry point for fresh machines and GitHub Codespaces.
# For day-to-day symlink refreshes, run ./link.sh directly.
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$REPO/scripts/packages.sh"
bash "$REPO/link.sh"

echo "Bootstrap complete."
