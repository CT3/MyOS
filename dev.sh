#!/bin/bash
echo "install dev tools"

sudo pacman -S --noconfirm libunistring
sudo pacman -S --noconfirm libxcrypt-compat


#nrf util
nrfutil install sdk-manager
nrfutil install toolchain-manager


