#!/bin/bash
echo "install dev tools"

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Please install Homebrew first (run brew.sh or cask.sh)."
    exit 1
fi

# Common dev libraries
brew install libunistring libffi

# J-Link tools (cask) — Nordic / Segger debugger support
brew install --cask segger-jlink

# nRF command line tools (cask)
brew install --cask nordic-nrf-command-line-tools

# nrfutil and its components (standalone binary; the pip package is the legacy v6)
NRFUTIL_URL="https://files.nordicsemi.com/artifactory/swtools/external/nrfutil/executables/universal-apple-darwin/nrfutil"
if ! command -v nrfutil &> /dev/null; then
    echo "Installing nrfutil to ~/bin..."
    mkdir -p "$HOME/bin"
    curl -fL -o "$HOME/bin/nrfutil" "$NRFUTIL_URL" && chmod +x "$HOME/bin/nrfutil" || { echo "Error: Failed to download nrfutil."; exit 1; }
    export PATH="$HOME/bin:$PATH"
fi

nrfutil install device
nrfutil install sdk-manager
nrfutil install toolchain-manager
nrfutil install nrf5sdk-tools

echo "--- Dev tool setup complete ---"
echo "Note: macOS does not need uucp/adbusers group membership; serial devices are user-accessible by default."
