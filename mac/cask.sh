#!/bin/bash
# Install GUI applications via Homebrew Cask.
# Equivalent of arch/yay.sh

# Cask apps to install
CASKS=(
    "zoom"
    "brave-browser"
    "slack"
    "obsidian"
    "visual-studio-code"
    "ghostty"
    "nextcloud"
    "kicad"
    "vlc"
    "arduino-ide"
    "calibre"
    "handbrake"
    "font-fira-code-nerd-font"
)

command_exists () {
    type "$1" &> /dev/null
}

echo "---"
echo "Starting macOS application setup script..."
echo "---"

# Check and install Homebrew
if ! command_exists brew; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Homebrew. Exiting."
        exit 1
    fi

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# Ensure Xcode command line tools (equivalent to base-devel)
echo "---"
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Re-run this script after the Xcode Command Line Tools installation completes."
else
    echo "Xcode Command Line Tools are installed."
fi

# Install cask apps
echo "---"
echo "Installing/updating specified cask applications..."
for app in "${CASKS[@]}"; do
    echo "Attempting to install/update: $app"
    brew install --cask "$app"
    if [ $? -eq 0 ]; then
        echo "$app installed/updated successfully."
    else
        echo "Warning: Failed to install/update $app. Please check for errors."
    fi
    echo "---"
done

echo "All specified cask applications have been processed."
echo "Script finished."
