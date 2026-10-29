#!/usr/bin/env bash
# Symlinks everything in this repo into $HOME. Idempotent; safe to re-run.
# Existing real files/dirs are moved to <target>.backup.<timestamp>.
set -eu

# Usage: ./install.sh [--packages]
#   --packages  also run scripts/packages.sh (automatic in GitHub Codespaces)
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"

WITH_PACKAGES=false
[ "${CODESPACES:-}" = "true" ] && WITH_PACKAGES=true
for arg in "$@"; do
  case "$arg" in
    --packages) WITH_PACKAGES=true ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

# source (relative to repo)   target
LINKS=(
  ".gitconfig   $HOME/.gitconfig"
  ".zshrc       $HOME/.zshrc"
  ".zshrc.mac   $HOME/.zshrc.mac"
  "nvim         $HOME/.config/nvim"
  "tmux         $HOME/.config/tmux"
)

for entry in "${LINKS[@]}"; do
  read -r src dst <<<"$entry"
  src="$REPO/$src"

  if [ ! -e "$src" ]; then
    echo "skip    $dst (missing $src)"
    continue
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
    continue
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.backup.$STAMP"
    echo "backup  $dst -> $dst.backup.$STAMP"
  fi
  ln -sfn "$src" "$dst"
  echo "link    $dst -> $src"
done

# tmux plugin manager (optional; needs git)
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  if command -v git >/dev/null 2>&1; then
    git clone -q https://github.com/tmux-plugins/tpm "$TPM" && echo "clone   $TPM"
  else
    echo "skip    TPM (git not found)"
  fi
fi

if $WITH_PACKAGES; then
  echo "run     scripts/packages.sh"
  bash "$REPO/scripts/packages.sh"
fi

echo "Done. In tmux, press prefix + I to install plugins."
