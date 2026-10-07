#!/bin/bash
echo "--- Running commands from cargo-app.sh ---"

# --- Cargo (Rust) Installation ---
echo ""
echo "--- Installing Cargo (via Homebrew) ---"

echo ""
echo "Checking for Rust/Cargo..."
if command -v rustc &> /dev/null; then
    echo "Rust (and Cargo) is already installed. Skipping installation."
else
    echo "Rust/Cargo not found. Installing via Homebrew..."
    brew install rust
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Rust/Cargo. Exiting."
        exit 1
    fi
    echo "Rust and Cargo installed successfully!"
fi

# Source cargo's environment if present (rustup-managed installs)
if [ -f "$HOME/.cargo/env" ]; then
    echo "Sourcing Cargo environment for current session..."
    source "$HOME/.cargo/env"
fi

echo "--- Installing Cargo-based applications ---"

# aichat and dust come from Homebrew (brew.sh)
CRATES=(
    aserial
    cargo-update
    cpst
    rm-improved
    diskonaut
    doxx
    dua-cli
    jtodo
    sweep-cli
)

for crate in "${CRATES[@]}"; do
    echo "Installing $crate..."
    cargo install "$crate" || echo "Warning: Failed to install $crate."
done

echo "--- Finished cargo-app.sh commands ---"
