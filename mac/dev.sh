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

# nrfutil and its components
if ! command -v nrfutil &> /dev/null; then
    echo "Installing nrfutil via pip..."
    python3 -m pip install --user --upgrade nrfutil
fi

nrfutil install sdk-manager
nrfutil install toolchain-manager
nrfutil install nrf5sdk-tools

echo "--- Dev tool setup complete ---"
echo "Note: macOS does not need uucp/adbusers group membership; serial devices are user-accessible by default."
