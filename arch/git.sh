#!/bin/bash

# Function to display error messages and exit
function die {
    echo "Error: $1" >&2
    exit 1
}

# Define your Git user name and email
GIT_USERNAME="Mantas Jurkuvenas"
GIT_EMAIL="mantasjurkuvenas@gmail.com"

# --- New Step: Check if Git is already installed ---
echo "Checking if Git is already installed..."
if command -v git &> /dev/null; then
    echo "Git is already installed. Version: $(git --version)"
    echo "Proceeding to configure Git (if not already configured)."
    
    # Check if user.name and user.email are already set
    CURRENT_GIT_USERNAME=$(git config --global user.name)
    CURRENT_GIT_EMAIL=$(git config --global user.email)

    if [ "$CURRENT_GIT_USERNAME" = "$GIT_USERNAME" ] && [ "$CURRENT_GIT_EMAIL" = "$GIT_EMAIL" ]; then
        echo "Git user name and email are already configured correctly."
        echo "Exiting script as Git is already installed and configured."
        exit 0
    else
        echo "Git is installed, but user name or email needs to be configured/updated."
        # The script will continue to the configuration step
    fi
else
    echo "Git is not installed. Proceeding with installation."
fi


# --- Step 1: Update package lists (only if Git is not installed or configuration needs update) ---
# This block will run if Git was not found, or if Git was found but configuration was not as expected.
# We explicitly update to ensure we get latest packages if installation is needed.
if ! command -v git &> /dev/null || [ "$CURRENT_GIT_USERNAME" != "$GIT_USERNAME" ] || [ "$CURRENT_GIT_EMAIL" != "$GIT_EMAIL" ]; then
    echo "Updating package lists..."
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu based systems
        sudo apt-get update || die "Failed to update apt-get package lists."
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL based systems
        sudo yum check-update || die "Failed to check for yum updates."
    elif command -v dnf &> /dev/null; then
        # Fedora based systems
        sudo dnf check-update || die "Failed to check for dnf updates."
    else
        die "Could not determine package manager. Please install Git manually."
    fi
    echo "Package lists updated successfully."
fi


# --- Step 2: Install Git (only if not already installed) ---
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y git || die "Failed to install Git using apt-get."
    elif command -v yum &> /dev/null; then
        sudo yum install -y git || die "Failed to install Git using yum."
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y git || die "Failed to install Git using dnf."
    else
        die "No suitable package manager found to install Git. Please install Git manually."
    fi
    echo "Git installed successfully."

    # Verify Git installation immediately after trying to install
    if ! command -v git &> /dev/null; then
        die "Git command not found after installation. Something went wrong."
    fi
    echo "Git version:"
    git --version
fi


# --- Step 3: Configure Git User Name and Email ---
# This step will always run if the script hasn't exited, ensuring configuration is correct.
echo ""
echo "Configuring Git with pre-defined user name and email..."

git config --global user.name "$GIT_USERNAME" || die "Failed to set Git user name."
git config --global user.email "$GIT_EMAIL" || die "Failed to set Git email."

echo ""
echo "Git configuration complete!"
echo "Your Git user name is: $(git config --global user.name)"
echo "Your Git email is: $(git config --global user.email)"
echo ""
echo "Git is now installed and configured on your system."
