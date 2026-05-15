#!/bin/bash
echo "--- Installing common build tools and Python environment ---"

# Install essential build tools (often part of base-devel, but explicit)
sudo pacman -S --noconfirm --needed \
    gcc \
    make \
    cmake \
    ninja \
    gdb \
    git \
    python \
    python-pip \
    doxygen \
    wget \
    unzip \
    libffi \
    ncurses # For menuconfig related tools


yay -S --noconfirm --needed esp-idf
