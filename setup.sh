#!/usr/bin/env bash
# Dotfiles setup script for macOS
# Run this to configure your development environment

set -e

echo "==> Starting dotfiles installation"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This setup is designed for macOS"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "==> Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "==> Homebrew already installed"
fi

# Install packages from Brewfile
echo "==> Installing packages from Brewfile"
brew bundle --file="$HOME/.dotfiles/Brewfile"

# Setup fish shell
FISH_PATH=$(command -v fish)
if [ -n "$FISH_PATH" ]; then
    echo "==> Configuring fish shell"
    
    # Add fish to allowed shells if not already there
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi
    
    # Set fish as default shell
    if [ "$SHELL" != "$FISH_PATH" ]; then
        chsh -s "$FISH_PATH"
        echo "==> Fish shell set as default"
    fi
    
    # Link fish configuration
    mkdir -p "$HOME/.config/fish"
    ln -sf "$HOME/.dotfiles/fish/config.fish" "$HOME/.config/fish/config.fish"
    
    # Link additional fish directories
    if [ -d "$HOME/.dotfiles/fish/conf.d" ]; then
        ln -sf "$HOME/.dotfiles/fish/conf.d" "$HOME/.config/fish/"
    fi
    if [ -d "$HOME/.dotfiles/fish/functions" ]; then
        ln -sf "$HOME/.dotfiles/fish/functions" "$HOME/.config/fish/"
    fi
fi

echo "==> Installation complete!"
echo "Please restart your terminal for changes to take effect"
