#!/bin/bash


# Check if arduino-cli is already installed
if command -v arduino-cli &> /dev/null
then
    echo "Arduino CLI is already installed."
else
    echo "Arduino CLI not found. Installing now..."
    # Download and run the official Arduino CLI installation script
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
    echo "Arduino CLI installation attempt complete."
fi


echo "Starting nrfutil installation process..."

# --- Step 1: Check and Install Python 3 ---
echo "Checking for Python 3..."
if command -v python3 &> /dev/null
then
    echo "Python 3 is already installed."
else
    echo "Python 3 not found. Attempting to install Python 3..."
    # Detect OS and install Python 3
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux (e.g., Debian/Ubuntu)
        echo "Detected Linux. Attempting to install Python 3 using apt..."
        sudo apt update
        sudo apt install -y python3 python3-pip
        if command -v python3 &> /dev/null; then
            echo "Python 3 installed successfully on Linux."
        else
            echo "Failed to install Python 3 on Linux. Please install it manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Detected macOS. Attempting to install Python 3 using Homebrew..."
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo "Homebrew installation complete."
        fi
        brew install python
        if command -v python3 &> /dev/null; then
            echo "Python 3 installed successfully on macOS."
        else
            echo "Failed to install Python 3 on macOS. Please install it manually."
            exit 1
        fi
    else
        echo "Unsupported OS or automatic Python 3 installation not supported. Please install Python 3 manually."
        echo "You can download it from: https://www.python.org/downloads/"
        exit 1
    fi
fi

# Ensure Python 3 is in PATH for the rest of the script
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is still not found after attempted installation. Exiting."
    exit 1
fi

# --- Step 2: Check and Install pip (pip3) ---
echo "Checking for pip (pip3)..."
if command -v pip3 &> /dev/null
then
    echo "pip (pip3) is already installed."
else
    echo "pip (pip3) not found. Attempting to install pip3..."
    # Install pip using get-pip.py (reliable method)
    echo "Downloading get-pip.py..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    echo "Installing pip using python3..."
    python3 get-pip.py
    rm get-pip.py # Clean up the downloaded script
    echo "pip (pip3) installation attempt complete."

    # Verify pip3 installation
    if command -v pip3 &> /dev/null; then
        echo "pip (pip3) installed successfully."
    else
        echo "Failed to install pip (pip3). Please check your Python installation."
        exit 1
    fi
fi

# Ensure pip3 is in PATH for the rest of the script
if ! command -v pip3 &> /dev/null; then
    echo "pip3 is still not found after attempted installation. Exiting."
    exit 1
fi


# --- Step 3: Install nrfutil ---
echo "Checking for nrfutil..."
if command -v nrfutil &> /dev/null
then
    echo "nrfutil is already installed. Version:"
    nrfutil --version
else
    echo "nrfutil not found. Installing nrfutil using pip3..."
    pip3 install nrfutil
    echo "nrfutil installation attempt complete."

    # Final verification for nrfutil
    if command -v nrfutil &> /dev/null
    then
        echo "nrfutil has been successfully installed. Version:"
        nrfutil --version
    else
        echo "nrfutil installation failed or it's not in your PATH."
        echo "Please ensure Python, pip, and your PATH are correctly set up."
    fi
fi

echo "nrfutil installation process complete."



