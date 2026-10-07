#!/bin/bash
# Install Mac App Store apps via mas (https://github.com/mas-cli/mas).
# You must be signed in to the App Store app first.

echo "--- Mac App Store install ---"

if ! command -v mas &> /dev/null; then
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install Homebrew first (run brew.sh)."
        exit 1
    fi
    brew install mas
fi

# "id:name" pairs
MAS_APPS=(
    "497799835:Xcode"
    "1352778147:Bitwarden"
    "571213070:DaVinci Resolve"
    "640199958:Developer"
)

for app in "${MAS_APPS[@]}"; do
    id="${app%%:*}"
    name="${app#*:}"
    echo "Installing $name ($id)..."
    mas install "$id" || echo "Warning: Failed to install $name. Are you signed in to the App Store?"
done

echo "--- Mac App Store install done ---"
