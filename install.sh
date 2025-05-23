#!/bin/bash

echo "Starting installation script for Neovim, Snap, and Cargo..."

# --- Common Setup ---
echo "Updating system package lists..."
sudo apt update -y
if [ $? -ne 0 ]; then
    echo "Error: Failed to update package lists. Exiting."
    exit 1
fi
echo "Package lists updated."

echo "Installing 'software-properties-common' (required for add-apt-repository)..."
sudo apt install software-properties-common -y
if [ $? -ne 0 ]; then
    echo "Error: Failed to install 'software-properties-common'. Exiting."
    exit 1
fi
echo "'software-properties-common' installed."


    ./cargo-app.sh
    ./snap-app.sh
    ./flatpak-app.sh
    ./chezmoi.sh
    ./dev-app.sh
    ./e4l.sh    
    ./nvim.sh   
    ./ct3.sh    
    ./esp.sh
    ./zephyr.sh

echo ""
echo "All installations script finished. Please open a new terminal window to ensure all PATH variables are loaded correctly, especially for Cargo."
