#!/bin/bash
echo "--- Running commands from flatpak-app.sh ---"
echo "Checking for Flatpak installation..."

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null
then
    echo "Flatpak is not installed. Installing Flatpak..."

    # Update package lists
    sudo apt update

    # Install Flatpak and the Flatpak plugin for Gnome Software (Ubuntu Software Center)
    sudo apt install -y flatpak gnome-software-plugin-flatpak

    # Add the Flathub repository
    echo "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Flatpak installed successfully."
else
    echo "Flatpak is already installed."
fi

# Install KiCad from Flathub
flatpak install --noninteractive flathub org.kicad.KiCad
flatpak install --noninteractive flathub us.zoom.Zoom
flatpak install --noninteractive flathub org.videolan.VLC 
flatpak install --noninteractive flathub org.videolan.VLC 
flatpak install --noninteractive flathub io.neovim.nvim 
flatpak install --noninteractive flathub com.brave.Browser
flatpak install --noninteractive flathub cc.arduino.IDE2
flatpak install --noninteractive flathub com.calibre_ebook.calibre
flatpak install --noninteractive flathub com.slack.Slack
flatpak install --noninteractive flathub fr.handbrake.ghb 
flatpak install --noninteractive flathub md.obsidian.Obsidian
flatpak install --noninteractive com.nextcloud.desktopclient.nextcloud

echo "--- Finished flatpak-app.sh commands ---"
