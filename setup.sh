#!/usr/bin/env bash
set -e

REPO="https://github.com/andrlime/neovim.git"
DEFAULT_DIR="$HOME/.config/nvim"
TARGET="${1:-$DEFAULT_DIR}"

# Clone
if [ -d "$TARGET" ]; then
  echo "Directory $TARGET already exists — skipping clone."
else
  git clone "$REPO" "$TARGET"
  echo "Cloned to $TARGET"
fi

# If non-default path, set NVIM_APPNAME in shell rc
if [ "$TARGET" != "$DEFAULT_DIR" ]; then
  APP_NAME="$(basename "$TARGET")"

  # Detect shell rc file
  if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
    RC="$HOME/.zshrc"
  else
    RC="$HOME/.bashrc"
  fi

  if grep -q "NVIM_APPNAME" "$RC" 2>/dev/null; then
    echo "NVIM_APPNAME already set in $RC — skipping."
  else
    echo "" >> "$RC"
    echo "export NVIM_APPNAME=\"$APP_NAME\"" >> "$RC"
    echo "Added NVIM_APPNAME=$APP_NAME to $RC"
  fi
fi

echo "Done. Open a new terminal and run: nvim"
