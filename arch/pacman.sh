#!/bin/bash
echo "pacman install"
sudo pacman -Syu
sudo pacman -S --noconfirm git
sudo pacman -S --needed  --noconfirm base-devel
sudo pacman -S --noconfirm xclip
sudo pacman -S --noconfirm android-tools
sudo pacman -S --noconfirm fish
sudo pacman -S --noconfirm starship
sudo pacman -S --noconfirm stylua
sudo pacman -S --noconfirm topgrade
sudo pacman -S --noconfirm zellij
sudo pacman -S --noconfirm zoxide
sudo pacman -S --noconfirm dust
sudo pacman -S --noconfirm eza
sudo pacman -S --noconfirm gitui
sudo pacman -S --noconfirm just
sudo pacman -S --noconfirm ripgrep
sudo pacman -S --noconfirm neofetch
sudo pacman -S --noconfirm bat
sudo pacman -S --noconfirm bottom
sudo pacman -S --noconfirm rust
sudo pacman -S --noconfirm ghostty
sudo pacman -S --noconfirm chezmoi
sudo pacman -S --noconfirm mosquitto
sudo pacman -S --noconfirm nextcloud-client
sudo pacman -S --noconfirm kicad kicad-library kicad-library-3d
sudo pacman -S --noconfirm vlc
sudo pacman -S --noconfirm neovim
sudo pacman -S --noconfirm arduino-ide
sudo pacman -S --noconfirm calibre
sudo pacman -S --noconfirm handbrake
sudo pacman -S --noconfirm nextcloud-client
sudo pacman -S --noconfirm arduino-cli
sudo pacman -S --noconfirm python
sudo pacman -S --noconfirm ttf-firacode-nerd
sudo pacman -S --noconfirm gvfs-mtp libmtp android-udev
sudo pacman -S --noconfirm udisks2 udiskie
sudo pacman -S --noconfirm viewnior
echo "pacman install done"

