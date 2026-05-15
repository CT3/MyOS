#!/bin/bash
echo "--- Installing common build tools and Python environment for ESP-IDF ---"

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Please install Homebrew first (run brew.sh or cask.sh)."
    exit 1
fi

# Build tools and Python environment required by ESP-IDF on macOS
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/macos-setup.html
brew install \
    cmake \
    ninja \
    dfu-util \
    ccache \
    git \
    python \
    wget \
    doxygen \
    libffi

# --- Clone ESP-IDF ---
ESP_IDF_DIR="$HOME/esp/esp-idf"

if [ ! -d "$ESP_IDF_DIR" ]; then
    echo "Cloning ESP-IDF into $ESP_IDF_DIR..."
    mkdir -p "$HOME/esp"
    git clone --recursive https://github.com/espressif/esp-idf.git "$ESP_IDF_DIR"
else
    echo "ESP-IDF already cloned at $ESP_IDF_DIR. Skipping clone."
fi

# --- Run ESP-IDF installer ---
if [ -d "$ESP_IDF_DIR" ]; then
    echo "Running ESP-IDF install.sh..."
    cd "$ESP_IDF_DIR" && ./install.sh
    echo ""
    echo "ESP-IDF installed."
    echo "To use it in a shell, run: . $ESP_IDF_DIR/export.sh"
fi
