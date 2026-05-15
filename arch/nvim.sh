#!/bin/bash

# --- Configuration ---
NVIM_REPO="git@github.com:CT3/nvim.git"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d%H%M%S)" # Unique backup directory

echo "Starting Neovim dotfiles setup..."
echo "Repository: $NVIM_REPO"
echo "Target directory: $NVIM_CONFIG_DIR"

# --- Step 1: Backup existing Neovim configuration ---
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "Existing Neovim configuration found at $NVIM_CONFIG_DIR."
    read -p "Do you want to back it up? (y/N): " -n 1 -r REPLY
    echo # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Backing up $NVIM_CONFIG_DIR to $BACKUP_DIR..."
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        if [ $? -eq 0 ]; then
            echo "Backup successful: $BACKUP_DIR"
        else
            echo "Error: Failed to backup $NVIM_CONFIG_DIR. Please check permissions or disk space."
            exit 1
        fi
    else
        echo "Skipping backup. Proceeding with caution!"
    fi
fi

# --- Step 2: Clone the Neovim repository ---
echo "Cloning the Neovim dotfiles repository..."
git clone "$NVIM_REPO" "$NVIM_CONFIG_DIR"

if [ $? -eq 0 ]; then
    echo "Successfully cloned Neovim dotfiles to $NVIM_CONFIG_DIR."
else
    echo "Error: Failed to clone the repository. Please ensure you have Git installed and SSH keys are set up correctly for GitHub."
    echo "You can test your SSH connection with: ssh -T git@github.com"
    exit 1
fi

echo ""
echo "Neovim dotfiles setup complete!"
echo "Your Neovim configuration is now located at: $NVIM_CONFIG_DIR"
echo ""
echo "Next steps (if applicable, depending on your Neovim setup):"
echo "1. Open Neovim: nvim"
echo "2. Your configuration might automatically install plugins on first run."
echo "   If not, you might need to run a plugin install command (e.g., :PlugInstall, :PackerSync, etc.) depending on your plugin manager."
