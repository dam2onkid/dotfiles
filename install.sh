#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Linking dotfiles..."
"$DOTFILES/scripts/link.sh"

# echo "Installing Homebrew packages..."
# "$DOTFILES/scripts/brew.sh"
#
# echo "Applying macOS defaults..."
# "$DOTFILES/scripts/macos.sh"

echo "Done."
