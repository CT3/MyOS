#!/bin/bash

# Define the applications to install
APPS=(
    "zoom"
    "brave-bin"
    "slack-desktop"
    "obsidian"
    "visual-studio-code-bin"
    "nrfutil"
    "jlink-software-and-documentation-pack"

)

# Function to check if a command exists
command_exists () {
  type "$1" &> /dev/null
}

echo "---"
echo "Starting Arch Linux application setup script..."
echo "---"

# Check and install git
if ! command_exists git; then
    echo "Git not found. Installing Git..."
    sudo pacman -S --noconfirm git
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Git. Exiting."
        exit 1
    fi
else
    echo "Git is already installed."
fi

# Check and install base-devel group
echo "---"
echo "Checking for base-devel group..."
# Check if a package from base-devel (like 'make') exists. This is a heuristic.
if ! command_exists make; then
    echo "base-devel group not fully installed. Installing..."
    sudo pacman -S --noconfirm --needed base-devel
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install base-devel. Exiting."
        exit 1
    fi
else
    echo "base-devel group appears to be installed."
fi

# Check and install yay
echo "---"
if ! command_exists yay; then
    echo "yay not found. Installing yay from AUR..."
    # Create a temporary directory for building yay
    BUILD_DIR=$(mktemp -d)
    echo "Building yay in temporary directory: $BUILD_DIR"

    if git clone https://aur.archlinux.org/yay.git "$BUILD_DIR/yay"; then
        cd "$BUILD_DIR/yay" || { echo "Error: Could not change to yay directory. Exiting."; exit 1; }
        makepkg -si --noconfirm
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install yay. Exiting."
            # Clean up the build directory even on error
            cd /tmp # Move out of the directory before trying to remove it
            rm -rf "$BUILD_DIR"
            exit 1
        fi
        cd /tmp # Move out of the directory before trying to remove it
        rm -rf "$BUILD_DIR"
        echo "yay installed successfully!"
    else
        echo "Error: Failed to clone yay repository. Exiting."
        rm -rf "$BUILD_DIR" # Clean up the build directory
        exit 1
    fi
else
    echo "yay is already installed."
fi

# Install applications using yay
echo "---"
echo "Installing/updating specified applications with yay..."
for app in "${APPS[@]}"; do
    echo "Attempting to install/update: $app"
    yay -S --noconfirm "$app"
    if [ $? -eq 0 ]; then
        echo "$app installed/updated successfully."
    else
        echo "Warning: Failed to install/update $app. Please check for errors."
    fi
    echo "---"
done

echo "All specified applications have been processed."
echo "Script finished."
