#!/bin/bash

# --- Configuration ---
IDF_INSTALL_DIR="$HOME/esp" # Base directory for ESP-IDF installation
IDF_DIR_NAME="esp-idf"      # The name of the ESP-IDF directory inside IDF_INSTALL_DIR
                            # This script will clone the latest default branch (usually 'master')
IDF_REPO="https://github.com/espressif/esp-idf.git"

# Full path to the ESP-IDF repository
TARGET_IDF_PATH="$IDF_INSTALL_DIR/$IDF_DIR_NAME"

echo "Starting ESP-IDF Development Environment Setup for Ubuntu (Latest Version)..."
echo "This script will install necessary tools, dependencies, and the latest ESP-IDF from the default branch."
echo "ESP-IDF will be installed at: $TARGET_IDF_PATH"

# --- Helper Function for Error Handling ---
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# --- Helper Function to check if a package is installed (apt) ---
package_installed() {
    dpkg -s "$1" &> /dev/null
}

# --- Helper Function to check if a directory exists and is not empty ---
dir_exists_and_not_empty() {
    [ -d "$1" ] && [ "$(ls -A "$1")" ]
}

# --- Helper Function to check if a command exists in PATH ---
command_exists () {
    type "$1" &> /dev/null ;
}

# --- Pre-check: Is an ESP-IDF environment already sourced in this terminal? ---
if command_exists idf.py && [ -n "$IDF_PATH" ]; then
    echo "Warning: An ESP-IDF environment seems to be currently active (idf.py found and IDF_PATH is set)."
    echo "Current IDF_PATH: $IDF_PATH"
    echo "It's recommended to run this script in a fresh terminal session to avoid conflicts."
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r REPLY
    echo # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting script. Please open a new terminal and try again."
        exit 0
    fi
fi

---

### Installation Steps

#### Step 1: Update and Upgrade System
echo ""
echo "--- Step 1: Updating and upgrading system packages ---"
sudo apt update && sudo apt upgrade -y
check_error "Failed to update or upgrade apt packages."
echo "System packages updated."

#### Step 2: Install Essential Dependencies
echo ""
echo "--- Step 2: Installing essential ESP-IDF dependencies ---"
# From ESP-IDF docs: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html#linux-macos-prerequisites
REQUIRED_PACKAGES="git wget libncurses5-dev flex bison gperf cmake ninja-build ccache libffi-dev libssl-dev dfu-util"
PACKAGES_TO_INSTALL=""

for pkg in $REQUIRED_PACKAGES; do
    if ! package_installed "$pkg"; then
        PACKAGES_TO_INSTALL+=" $pkg"
    else
        echo "Package '$pkg' is already installed."
    fi
done

if [ -n "$PACKAGES_TO_INSTALL" ]; then
    echo "Installing missing packages: $PACKAGES_TO_INSTALL"
    sudo apt install --no-install-recommends -y $PACKAGES_TO_INSTALL
    check_error "Failed to install essential ESP-IDF dependencies."
else
    echo "All essential ESP-IDF dependencies are already installed."
fi
echo "Essential dependencies check complete."

#### Step 3: Create Installation Directory and Clone ESP-IDF
echo ""
echo "--- Step 3: Creating installation directory and cloning/updating ESP-IDF ---"

if dir_exists_and_not_empty "$TARGET_IDF_PATH"; then
    echo "ESP-IDF directory '$TARGET_IDF_PATH' already exists and is not empty."
    echo "Pulling latest changes and updating submodules for the default branch."
    cd "$TARGET_IDF_PATH" || check_error "Failed to change to $TARGET_IDF_PATH."
    # Pull the latest changes from the current branch (usually master)
    git pull
    check_error "Failed to pull latest changes for ESP-IDF."
    echo "Updating submodules..."
    git submodule update --init --recursive
    check_error "Failed to update submodules for ESP-IDF."
else
    echo "Creating directory: $IDF_INSTALL_DIR"
    mkdir -p "$IDF_INSTALL_DIR"
    check_error "Failed to create directory $IDF_INSTALL_DIR."
    cd "$IDF_INSTALL_DIR" || check_error "Failed to change to $IDF_INSTALL_DIR."

    echo "Cloning ESP-IDF repository into $TARGET_IDF_PATH (latest default branch)..."
    git clone --recursive "$IDF_REPO" "$IDF_DIR_NAME"
    check_error "Failed to clone ESP-IDF repository."

    echo "Changing to ESP-IDF directory: $TARGET_IDF_PATH"
    cd "$TARGET_IDF_PATH" || check_error "Failed to change to $TARGET_IDF_PATH."
fi
echo "ESP-IDF cloning/update complete."

#### Step 4: Install ESP-IDF Tools
echo ""
echo "--- Step 4: Installing ESP-IDF tools (toolchain, Python packages, etc.) ---"
# Check for marker file and also try to run the tools check command
if [ -f "$TARGET_IDF_PATH/tools/idf_tools.py" ]; then
    cd "$TARGET_IDF_PATH" # Ensure we are in the IDF directory for install.sh
    if [ -f "$TARGET_IDF_PATH/.install_ok" ]; then
        echo "ESP-IDF tools appear to be already installed (marker file found)."
        # Optional: Attempt to run idf_tools.py check to be extra sure
        echo "Running 'idf_tools.py check' to verify tools installation..."
        python3 "$TARGET_IDF_PATH/tools/idf_tools.py" check || {
            echo "Warning: 'idf_tools.py check' reported issues. Attempting re-installation."
            rm -f "$TARGET_IDF_PATH/.install_ok" # Remove marker to force re-install
            "$TARGET_IDF_PATH/install.sh"
            check_error "Failed to re-install ESP-IDF tools after check issues."
            touch "$TARGET_IDF_PATH/.install_ok"
        }
    else
        echo "Running ESP-IDF install script..."
        "$TARGET_IDF_PATH/install.sh"
        check_error "Failed to install ESP-IDF tools."
        touch "$TARGET_IDF_PATH/.install_ok" # Create a marker file
        echo "ESP-IDF tools installed successfully."
    fi
    cd - > /dev/null # Go back to previous directory quietly
else
    echo "Error: Could not find ESP-IDF tools installer ($TARGET_IDF_PATH/tools/idf_tools.py)."
    echo "Please ensure ESP-IDF was cloned correctly."
    exit 1
fi
echo "ESP-IDF tools installation check complete."

#### Step 5: Setup Udev Rules (Optional but Recommended)
echo ""
echo "--- Step 5: Setting up Udev Rules for ESP device access (Recommended) ---"
echo "This allows non-root users to flash devices."
UDEV_RULES_SOURCE="$TARGET_IDF_PATH/tools/99-espressif.rules"
UDEV_RULES_DEST="/etc/udev/rules.d/99-espressif.rules"

if [ -f "$UDEV_RULES_SOURCE" ]; then
    if [ -f "$UDEV_RULES_DEST" ] && cmp -s "$UDEV_RULES_SOURCE" "$UDEV_RULES_DEST"; then
        echo "Udev rules file already exists at $UDEV_RULES_DEST and is identical. Skipping copy."
    else
        echo "Copying udev rules from $UDEV_RULES_SOURCE to $UDEV_RULES_DEST..."
        sudo cp "$UDEV_RULES_SOURCE" "$UDEV_RULES_DEST"
        check_error "Failed to copy udev rules."
        echo "Reloading udev rules..."
        sudo udevadm control --reload-rules
        sudo udevadm trigger
        echo "Udev rules copied and reloaded."
        echo "You may need to log out and log back in, or reboot, for Udev rules to take full effect."
    fi
else
    echo "Warning: Espressif udev rules file not found at $UDEV_RULES_SOURCE. Skipping udev setup."
fi

---

### Final Steps and Verification

echo ""
echo "--- Setup Complete! ---"
echo "ESP-IDF development environment has been set up to the latest version."
echo "Your ESP-IDF installation is located at: $TARGET_IDF_PATH"
echo ""
echo "To activate the ESP-IDF environment in a new terminal session:"
echo "  cd $TARGET_IDF_PATH"
echo "  . ./export.sh" # Note the dot space at the beginning!
echo ""
echo "You can test your setup by trying to build a sample application, for example:"
echo "  cd $TARGET_IDF_PATH/examples/get-started/hello_world"
echo "  idf.py build"
echo ""
echo "IMPORTANT: The 'idf.py' command will only be available in terminals where you have sourced 'export.sh'."
echo "Consider adding the 'source $TARGET_IDF_PATH/export.sh' line to your ~/.bashrc or ~/.profile"
echo "if you want the environment to be set up automatically in every new terminal."
echo "However, doing so for multiple IDF versions or other toolchains can complicate things."
echo "It's often better to source it manually or use an alias."
echo ""
echo "Remember to log out and log back in, or reboot, for Udev rules to take full effect if copied/updated."cho "Remember to log out and log back in, or reboot, for Udev rules to take full effect if copied/updated."cho "Remember to log out and log back in, or reboot, for Udev rules to take full effect if copied/updated."
