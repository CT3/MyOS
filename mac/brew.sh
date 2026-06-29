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
    # Shell / prompt / navigation
    git
    gh
    fish
    starship
    zoxide
    fzf
    zellij
    # Modern CLI replacements / viewers
    dust
    eza
    bat
    bottom
    gitui
    glow
    ripgrep
    neofetch
    just
    topgrade
    wget
    # Editor / lua
    neovim
    stylua
    # Languages / runtimes / build
    rust
    python
    node@18
    yarn
    openjdk@17
    gradle
    cmake
    ninja
    ccache
    libffi
    # AI / cloud
    aichat
    azure-cli
    # Embedded / hardware dev
    arduino-cli
    platformio
    dfu-util
    mosquitto
    doxygen
    # iOS / Xcode tooling
    xcodegen
    # Media tooling
    ffmpeg
    yt-dlp
    poppler
    # dotfiles
    chezmoi
)

for formula in "${FORMULAS[@]}"; do
    echo "Installing $formula..."
    brew install "$formula"
done

echo "--- Homebrew formula install done ---"
