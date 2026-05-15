#!/bin/bash
# Install CLI tools and formulas via Homebrew.
# Equivalent of arch/pacman.sh

echo "--- Homebrew formula install ---"

# Install Homebrew itself if missing
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Homebrew. Exiting."
        exit 1
    fi

    # Add brew to PATH for the rest of this script (Apple Silicon vs Intel)
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

echo "Updating Homebrew..."
brew update

# CLI tools / formulas
FORMULAS=(
    git
    fish
    starship
    stylua
    topgrade
    zellij
    zoxide
    dust
    eza
    gitui
    just
    ripgrep
    neofetch
    bat
    bottom
    rust
    chezmoi
    mosquitto
    neovim
    arduino-cli
    python
    android-platform-tools
    libffi
)

for formula in "${FORMULAS[@]}"; do
    echo "Installing $formula..."
    brew install "$formula"
done

echo "--- Homebrew formula install done ---"
