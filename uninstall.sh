#!/usr/bin/env bash
# Removes symlinks that point into this repo, restoring the newest backup if any.
set -eu

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=("$HOME/.gitconfig" "$HOME/.config/nvim" "$HOME/.config/tmux")

for dst in "${TARGETS[@]}"; do
  if [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$REPO"/* ]]; then
    rm "$dst"
    echo "unlink  $dst"
    latest="$(ls -d "$dst".backup.* 2>/dev/null | sort | tail -n 1 || true)"
    if [ -n "$latest" ]; then
      mv "$latest" "$dst"
      echo "restore $latest -> $dst"
    fi
  else
    echo "skip    $dst (not linked to this repo)"
  fi
done
