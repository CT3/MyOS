#!/bin/bash

echo "Starting chezmoi installation and dotfiles restoration for macOS..."

# Your dotfiles repository URL
DOTFILES_URL="git@github.com:CT3/dotfiles.git"

# --- Step 1: Check and Install chezmoi ---
echo "Checking for chezmoi..."
if command -v chezmoi &> /dev/null; then
    echo "chezmoi is already installed. Version:"
    chezmoi --version
else
    echo "chezmoi not found. Installing chezmoi via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install Homebrew first (run brew.sh or cask.sh)."
        exit 1
    fi
    brew install chezmoi
    if command -v chezmoi &> /dev/null; then
        echo "chezmoi installed successfully."
    else
        echo "Failed to install chezmoi. Please check your internet connection or try installing manually."
        echo "Manual install instructions: https://www.chezmoi.io/install/"
        exit 1
    fi
fi

if ! command -v chezmoi &> /dev/null; then
    echo "chezmoi is still not found after attempted installation. Exiting."
    exit 1
fi

echo "chezmoi is ready."

# --- Step 2: Initialize chezmoi with your dotfiles repository ---
echo ""
echo "--- Initializing chezmoi with your dotfiles repository ---"
echo "Initializing chezmoi with: $DOTFILES_URL"
chezmoi init "$DOTFILES_URL"
echo "chezmoi initialization attempt complete. Your dotfiles source should now be in ~/.local/share/chezmoi."

# --- Step 3: Apply Your Dotfiles ---
echo ""
echo "--- Applying your dotfiles using chezmoi apply ---"
echo "This will synchronize your dotfiles from ~/.local/share/chezmoi to your home directory."

read -p "Press Enter to apply your dotfiles (or Ctrl+C to cancel)..."

chezmoi apply -v
echo "chezmoi apply complete."
