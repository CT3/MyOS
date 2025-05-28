#!/bin/bash

echo "Starting installation script for Neovim, Snap, and Cargo..."

# --- Common Setup ---
echo "Updating system package lists..."
sudo pacman -Syu

echo "Package lists updated."

# app install
    ./pacman.sh
    ./yay.sh
    ./cargo-app.sh
    
# Setup git stuff
    ./e4l.sh  
    ./ct3.sh    
    
# setup apps
    ./chezmoi.sh
    ./nvim.sh   
  
# install dev tools
    ./esp.sh

echo ""
echo "All installations script finished. Please open a new terminal window to ensure all PATH variables are loaded correctly, especially for Cargo."
