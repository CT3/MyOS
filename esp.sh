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

# Other Python packages commonly used
pip install --user \
    setuptools \
    wheel \
    kconfiglib \
    west # Zephyr's meta-tool

echo "--- Common prerequisites installed ---"


# --- Espressif (ESP-IDF) Setup ---
echo "--- Setting up Espressif ESP-IDF ---"

# Define ESP-IDF installation directory
ESP_IDF_PATH="$HOME/esp/esp-idf"
ESP_IDF_INSTALL_DIR="$HOME/esp"

# Check if ESP-IDF is already cloned
if [ -d "$ESP_IDF_PATH" ]; then
    echo "ESP-IDF directory already exists. Skipping clone."
    echo "Updating ESP-IDF..."
    cd "$ESP_IDF_PATH" && git pull --rebase || { echo "Failed to update ESP-IDF. Please check manually."; exit 1; }
else
    echo "Cloning ESP-IDF repository..."
    mkdir -p "$ESP_IDF_INSTALL_DIR"
    cd "$ESP_IDF_INSTALL_DIR" || { echo "Failed to change directory to $ESP_IDF_INSTALL_DIR. Exiting."; exit 1; }
    git clone --recursive https://github.com/espressif/esp-idf.git
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone ESP-IDF. Exiting."
        exit 1
    fi
fi

# Go to the ESP-IDF directory
cd "$ESP_IDF_PATH" || { echo "Error: Could not enter ESP-IDF directory. Exiting."; exit 1; }

# Install ESP-IDF tools (Python packages, toolchain, etc.)
echo "Installing ESP-IDF tools. This may take some time..."
./install.sh all
if [ $? -ne 0 ]; then
    echo "Error: Failed to install ESP-IDF tools. Exiting."
    exit 1
fi

echo "--- Espressif ESP-IDF setup complete. ---"
echo "To activate ESP-IDF environment in your current shell, run:"
echo "source $ESP_IDF_PATH/export.sh"
echo "Consider adding this to your shell profile (.bashrc, .zshrc, etc.)"
