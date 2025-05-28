#!/bin/bash
echo "pacman install"

sudo pacman -S git
sudo pacman -S --needed base-devel

sudo pacman -S starship
sudo pacman -S stylua
sudo pacman -S topgrade
sudo pacman -S zellij
sudo pacman -S zoxide
sudo pacman -S dust
sudo pacman -S eza
sudo pacman -S gitui
sudo pacman -S just
sudo pacman -S ripgrep
sudo pacman -S neofetch
sudo pacman -S bat
sudo pacman -S bottom
sudo pacman -S rust
sudo pacman -S ghosstty
sudo pacman -S chezmoi
sudo pacman -S mosquitto
sudo pacman -S nextcloud-client

sudo pacman -S kicad kicad-library kicad-library-3d
sudo pacman -S vlc
sudo pacman -S neovim
sudo pacman -S arduino-ide
sudo pacman -S calibre
sudo pacman -S handbrake
sudo pacman -S nextcloud-client
sudo pacman -S arduino-cli
sudo pacman -S python


echo "pacman install done"

