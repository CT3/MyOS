#!/bin/bash
echo "install dev tools"

sudo pacman -S --noconfirm libunistring
sudo pacman -S --noconfirm libxcrypt-compat

sudo yay -S jlink-software-and-documentation
sudo gpasswd -a $USER adbusers
#nrf util
nrfutil install sdk-manager
nrfutil install toolchain-manager
nrfutil install nrf5sdk-tools


sudo usermod -a -G uucp mantas #add uucp group for searial montitor
