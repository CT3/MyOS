#!/bin/bash
echo "--- Running commands from snap-app.sh ---"

# --- Snap Installation ---
echo ""
echo "--- Installing Snapd ---"
if ! command -v snap &> /dev/null; then
    echo "Snapd not found. Installing snapd..."
    sudo apt install snapd -y
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install snapd. Exiting."
        exit 1
    fi
    echo "Snapd installed successfully!"
    echo "Waiting for snapd to be ready..."
    # Give snapd a moment to initialize
    sleep 10
else
    echo "Snapd is already installed."
fi
echo "Installing snap packages..."
snap install code --classic
snap install chezmoi --classic
snap install ghostty --classic
snap install mosquitto
sudo snap install nextcloud
echo "--- Finished snap-app.sh commands ---"
