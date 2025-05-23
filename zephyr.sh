#!/bin/bash

# --- Configuration ---
ZEPHYR_BASE_DIR="$HOME/zephyrproject" # Base directory for Zephyr workspace
ZEPHYR_SDK_VERSION="0.16.1" # Latest SDK version as of this script (check Zephyr docs for updates)
ZEPHYR_SDK_URL="https://github.com/zephyrproject-org/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64.tar.gz"
ZEPHYR_SDK_SHA256_URL="https://github.com/zephyrproject-org/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/sha256.txt" # URL for checksums
SDK_INSTALL_DIR="$HOME/zephyr-sdk-$ZEPHYR_SDK_VERSION"

echo "Starting Zephyr Development Environment Setup for Ubuntu..."
echo "This script will install necessary tools, dependencies, and the Zephyr SDK."
echo "Zephyr workspace will be created at: $ZEPHYR_BASE_DIR"

# --- Helper Function for Error Handling ---
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# --- Helper Function to check if a command exists ---
command_exists () {
    type "$1" &> /dev/null ;
}

# --- Step 1: Update and Upgrade System ---
echo ""
echo "--- Step 1: Updating and upgrading system packages ---"
sudo apt update && sudo apt upgrade -y
check_error "Failed to update or upgrade apt packages."
echo "System packages updated."

# --- Step 2: Install Essential Dependencies ---
echo ""
echo "--- Step 2: Installing essential Zephyr dependencies ---"
# List of essential packages
DEPENDENCIES="git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget xz-utils file make gcc gcc-arm-none-eabi libusb-1.0-0 libusb-1.0-0-dev libudev-dev"
PACKAGES_TO_INSTALL=""

for pkg in $DEPENDENCIES; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        PACKAGES_TO_INSTALL+=" $pkg"
    else
        echo "Package '$pkg' is already installed."
    fi
done

if [ -n "$PACKAGES_TO_INSTALL" ]; then
    echo "Installing missing packages: $PACKAGES_TO_INSTALL"
    sudo apt install --no-install-recommends -y $PACKAGES_TO_INSTALL
    check_error "Failed to install essential Zephyr dependencies."
else
    echo "All essential Zephyr dependencies are already installed."
fi
echo "Essential dependencies check complete."

# --- Step 3: Install Python Dependencies ---
echo ""
echo "--- Step 3: Installing Python and pip dependencies ---"
PYTHON_DEPS="python3-pip python3-dev python3-venv"
PYTHON_PACKAGES_TO_INSTALL=""

for pkg in $PYTHON_DEPS; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        PYTHON_PACKAGES_TO_INSTALL+=" $pkg"
    else
        echo "Package '$pkg' is already installed."
    fi
done

if [ -n "$PYTHON_PACKAGES_TO_INSTALL" ]; then
    echo "Installing missing Python packages: $PYTHON_PACKAGES_TO_INSTALL"
    sudo apt install --no-install-recommends -y $PYTHON_PACKAGES_TO_INSTALL
    check_error "Failed to install Python 3 and pip."
else
    echo "Python 3 and pip dependencies are already installed."
fi
echo "Python 3 and pip check complete."

# --- Step 4: Install west ---
echo ""
echo "--- Step 4: Installing west (Zephyr meta-tool) ---"
if command_exists west; then
    echo "West is already installed."
else
    echo "Installing west..."
    pip3 install --user west
    check_error "Failed to install west."

    # Add ~/.local/bin to PATH if not already there (for west)
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        # shellcheck disable=SC1090
        source "$HOME/.bashrc"
        echo "$HOME/.local/bin added to PATH in ~/.bashrc. Please restart your terminal or run 'source ~/.bashrc'."
    else
        echo "$HOME/.local/bin is already in PATH."
    fi
fi
echo "West installation check complete."

# --- Step 5: Initialize Zephyr Workspace ---
echo ""
echo "--- Step 5: Initializing Zephyr Workspace ---"
if [ -d "$ZEPHYR_BASE_DIR/zephyr" ]; then
    echo "Zephyr workspace already initialized at $ZEPHYR_BASE_DIR."
    echo "Attempting to update existing workspace..."
    cd "$ZEPHYR_BASE_DIR"
    check_error "Failed to change to Zephyr base directory."
    west update
    check_error "Failed to update west modules."
else
    echo "Creating and initializing Zephyr workspace at $ZEPHYR_BASE_DIR..."
    mkdir -p "$ZEPHYR_BASE_DIR"
    check_error "Failed to create Zephyr base directory."
    cd "$ZEPHYR_BASE_DIR"
    check_error "Failed to change to Zephyr base directory."

    west init .
    check_error "Failed to initialize west workspace."
    west update
    check_error "Failed to update west modules."
fi
echo "Zephyr workspace initialization and update check complete."

# --- Step 6: Install Zephyr SDK ---
echo ""
echo "--- Step 6: Installing Zephyr SDK ---"
if [ -d "$SDK_INSTALL_DIR" ]; then
    echo "Zephyr SDK already found at $SDK_INSTALL_DIR. Skipping download and installation."
else
    echo "Downloading Zephyr SDK from $ZEPHYR_SDK_URL..."
    wget "$ZEPHYR_SDK_URL" -O zephyr-sdk.tar.gz
    check_error "Failed to download Zephyr SDK."

    echo "Downloading SDK checksums from $ZEPHYR_SDK_SHA256_URL..."
    wget "$ZEPHYR_SDK_SHA256_URL" -O sha256.txt
    check_error "Failed to download SDK checksums."

    # Verify checksum
    echo "Verifying SDK checksum..."
    grep "zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64.tar.gz" sha256.txt | sha256sum -c -
    if [ $? -ne 0 ]; then
        echo "Error: SDK checksum verification failed! Downloaded file might be corrupted."
        echo "Please re-run the script or manually download the SDK."
        exit 1
    fi
    echo "SDK checksum verified."

    echo "Extracting Zephyr SDK..."
    tar xvf zephyr-sdk.tar.gz
    check_error "Failed to extract Zephyr SDK."

    echo "Running Zephyr SDK setup script..."
    cd "zephyr-sdk-$ZEPHYR_SDK_VERSION"
    ./setup.sh
    check_error "Failed to run Zephyr SDK setup script."
    cd "$ZEPHYR_BASE_DIR" # Go back to ZEPHYR_BASE_DIR
fi
echo "Zephyr SDK installation check complete."

# --- Step 7: Install Python Dependencies for Zephyr ---
echo ""
echo "--- Step 7: Installing Python dependencies required by Zephyr ---"
# Navigate to the zephyr repository within the workspace to find requirements.txt
if [ -d "$ZEPHYR_BASE_DIR/zephyr" ]; then
    # Check if the requirements are already satisfied (this is a best-effort check)
    # A proper check would involve parsing requirements.txt and checking installed versions
    # For simplicity, we'll just try to install; pip will handle already met requirements.
    echo "Installing/updating Zephyr-specific Python dependencies from $ZEPHYR_BASE_DIR/zephyr/requirements.txt..."
    pip3 install --user -r "$ZEPHYR_BASE_DIR/zephyr/requirements.txt"
    check_error "Failed to install Zephyr Python requirements."
    echo "Zephyr-specific Python dependencies installed/checked."
else
    echo "Warning: Could not find Zephyr repository at $ZEPHYR_BASE_DIR/zephyr. Skipping Zephyr Python dependencies installation."
fi

# --- Step 8: Setup Udev Rules (Optional but Recommended) ---
echo ""
echo "--- Step 8: Setting up Udev Rules for device access (Recommended) ---"
UDEV_RULES_SOURCE="$ZEPHYR_BASE_DIR/zephyr/doc/modules/debug_shields/doc/zephyr.rules"
UDEV_RULES_DEST="/etc/udev/rules.d/zephyr.rules"

if [ -f "$UDEV_RULES_SOURCE" ]; then
    if [ -f "$UDEV_RULES_DEST" ]; then
        echo "Udev rules file already exists at $UDEV_RULES_DEST. Skipping copy."
    else
        echo "Copying udev rules from $UDEV_RULES_SOURCE to $UDEV_RULES_DEST..."
        sudo cp "$UDEV_RULES_SOURCE" "$UDEV_RULES_DEST"
        check_error "Failed to copy udev rules."
        echo "Reloading udev rules..."
        sudo udevadm control --reload-rules
        sudo udevadm trigger
        echo "Udev rules copied and reloaded."
        echo "You may need to log out and log back in for Udev rules to take full effect."
    fi
else
    echo "Warning: Zephyr udev rules file not found at $UDEV_RULES_SOURCE. Skipping udev setup."
fi

# --- Final Steps and Verification ---
echo ""
echo "--- Setup Complete! ---"
echo "Zephyr development environment has been set up."
echo "Your Zephyr workspace is located at: $ZEPHYR_BASE_DIR"
echo "The Zephyr SDK is installed at: $SDK_INSTALL_DIR"
echo ""
echo "To activate the Zephyr environment in a new terminal session, navigate to your workspace and source the setup script:"
echo "  cd $ZEPHYR_BASE_DIR"
echo "  source zephyr/zephyr-env.sh"
echo ""
echo "You can test your setup by trying to build a sample application, for example:"
echo "  cd $ZEPHYR_BASE_DIR/zephyr/samples/hello_world"
echo "  west build -b nucleo_f401re" # Or another board you have
echo ""
echo "IMPORTANT: If you opened this script in a new terminal, the changes to PATH from ~/.bashrc will only apply to new terminals. You might need to 'source ~/.bashrc' or restart your terminal for 'west' command to be recognized immediately."
