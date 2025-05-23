#!/bin/bash
echo "--- Running commands from cargo-app.sh ---"

# --- Cargo (Rustup) Installation ---
echo ""
echo "--- Installing Cargo (via Rustup) ---"

# --- Check for curl installation ---
echo "Checking for 'curl'..."
if command -v curl &> /dev/null
then
    echo "'curl' is already installed. Skipping installation."
else
    echo "'curl' not found. Installing 'curl' (required for rustup installation)..."
    sudo apt install curl -y
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install 'curl'. Exiting."
        exit 1
    fi
    echo "'curl' installed."
fi

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
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
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
cargo install bat
cargo install bottom
cargo install cargo-update
cargo install cpst
cargo install du-dust
cargo install eza
cargo install gitui 
cargo install just
cargo install ripgrep
cargo install neofetch
cargo install rm-improved
cargo install starship
cargo install stylua
cargo install topgrade
cargo install zellij
cargo install zoxide

echo "--- Finished cargo-app.sh commands ---"
