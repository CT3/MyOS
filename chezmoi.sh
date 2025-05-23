#!/bin/bash

echo "Starting chezmoi installation and dotfiles restoration for Ubuntu..."

# --- Step 1: Check and Install chezmoi ---
echo "Checking for chezmoi..."
if command -v chezmoi &> /dev/null
then
    echo "chezmoi is already installed. Version:"
    chezmoi --version
else
    echo "chezmoi not found. Attempting to install chezmoi on Ubuntu..."
    # Recommended way to install chezmoi on Linux
    echo "Downloading and running chezmoi installation script..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/twpayne/chezmoi/master/install.sh)"
    if command -v chezmoi &> /dev/null; then
        echo "chezmoi installed successfully."
    else
        echo "Failed to install chezmoi. Please check your internet connection or try installing manually."
        echo "Manual install instructions: https://www.chezmoi.io/install/"
        exit 1
    fi
fi

# Ensure chezmoi is in PATH for the rest of the script
if ! command -v chezmoi &> /dev/null; then
    echo "chezmoi is still not found after attempted installation. Exiting."
    exit 1
fi

echo "chezmoi is ready."

# --- Step 2: Initialize chezmoi with your dotfiles repository ---
echo ""
echo "--- Initializing chezmoi with your dotfiles repository ---"
echo "IMPORTANT: Only run this if you are initializing chezmoi for the first time on this machine with your dotfiles."
echo "If your dotfiles are already managed by chezmoi, you can skip this step by entering nothing."
echo "Example URL: https://github.com/yourusername/dotfiles.git"

read -p "Enter your dotfiles Git repository URL (or press Enter to skip): " DOTFILES_URL

if [ -z "$DOTFILES_URL" ]; then
    echo "No URL provided. Skipping chezmoi initialization. Assuming chezmoi is already configured."
else
    echo "Initializing chezmoi with: $DOTFILES_URL"
    chezmoi init "$DOTFILES_URL"
    # Note: chezmoi init typically clones the repo into ~/.local/share/chezmoi
    echo "chezmoi initialization attempt complete. Your dotfiles source should now be in ~/.local/share/chezmoi."
fi

# --- Step 3: Apply Your Dotfiles ---
echo ""
echo "--- Applying your dotfiles using chezmoi apply ---"
echo "This will synchronize your dotfiles from ~/.local/share/chezmoi to your home directory."

read -p "Press Enter to apply your dotfiles (or Ctrl+C to cancel)..."

chezmoi apply -v
echo "chezmoi apply complete."

echo "Dotfiles restoration process finished."
