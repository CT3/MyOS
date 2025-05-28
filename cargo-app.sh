#!/bin/bash
echo "--- Running commands from cargo-app.sh ---"

# --- Cargo (Rustup) Installation ---
echo ""
echo "--- Installing Cargo (via Rustup) ---"


# --- Check for Rust/Cargo installation ---
echo ""
echo "Checking for Rust/Cargo..."
if command -v rustc &> /dev/null
then
    echo "Rust (and Cargo) is already installed. Skipping installation."
else
    echo "Rust/Cargo not found. Downloading and running rustup installer..."
    # The -y flag answers 'yes' to the default installation option
    # It automatically adds cargo to PATH in ~/.profile or ~/.bashrc
    sudo pacman -S rust
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Rustup/Cargo. Exiting."
        exit 1
    fi
    echo "Rustup and Cargo installed successfully!"
fi

# Source cargo's environment for the current shell session
# This makes `cargo` available immediately in the current terminal window.
# For new terminal sessions, it will be automatically available via .profile/.bashrc
if [ -f "$HOME/.cargo/env" ]; then
    echo "Sourcing Cargo environment for current session..."
    source "$HOME/.cargo/env"
else
    echo "Warning: ~/.cargo/env not found. You may need to open a new terminal or manually source it."
fi

echo "--- Script execution finished ---"


cargo install aichat
cargo install aserial
cargo install cargo-update
cargo install cpst
cargo install rm-improved


echo "--- Finished cargo-app.sh commands ---"
