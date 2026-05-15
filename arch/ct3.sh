#!/bin/bash
git config --global user.email "mantasjurkuvenas@gmail.com"
  git config --global user.name "Mantas Jurkvenas"
# Define the base directory for your code
TARGET_BASE_DIR="$HOME/Documents/code"

# Define the list of Git repository URLs
# Add all your repository URLs here, one per line.
GIT_REPOS=(
    "git@github.com:CT3/zmk-config.git"
    "git@github.com:CT3/CopyPasta.git"
    "git@github.com:CT3/aserial.git"
    "git@github.com:CT3/initC.git"
    "git@github.com:CT3/MyOS.git"
)

# Function to display error messages and exit
function die {
    echo "Error: $1" >&2
    exit 1
}

echo "Starting multi-repository cloning process..."

# --- Step 1: Check if the base target directory exists and create it if not ---
echo "Checking for base directory: $TARGET_BASE_DIR"
if [ ! -d "$TARGET_BASE_DIR" ]; then
    echo "Directory does not exist. Creating $TARGET_BASE_DIR..."
    mkdir -p "$TARGET_BASE_DIR" || die "Failed to create directory $TARGET_BASE_DIR."
    echo "Directory $TARGET_BASE_DIR created successfully."
else
    echo "Directory $TARGET_BASE_DIR already exists."
fi

# --- Step 2: Navigate into the base target directory ---
echo "Navigating into $TARGET_BASE_DIR..."
cd "$TARGET_BASE_DIR" || die "Failed to change directory to $TARGET_BASE_DIR."
echo "Current working directory for cloning: $(pwd)"
echo ""

# --- Step 3: Loop through each repository and clone it ---
for REPO_URL in "${GIT_REPOS[@]}"; do
    echo "Processing repository: $REPO_URL"

    # Extract the repository name from the URL
    # This assumes the repo name is the last part after the last '/'
    REPO_NAME=$(basename "$REPO_URL")

    # Clean up the name if it ends with .git (common for some URLs)
    REPO_NAME="${REPO_NAME%.git}"

    # --- Check if the repository has already been cloned ---
    if [ -d "$REPO_NAME" ]; then
        echo "  Repository '$REPO_NAME' already exists in $TARGET_BASE_DIR."
        echo "  Skipping clone. You might want to 'cd $REPO_NAME && git pull' to update it."
        echo ""
    else
        echo "  Cloning repository '$REPO_NAME' from $REPO_URL..."
        # Note: Ensure your SSH key is added to your SSH agent and registered with Azure DevOps.
        git clone "$REPO_URL" "$REPO_NAME" || die "Failed to clone repository '$REPO_NAME'. Make sure your SSH key is set up correctly."
        echo "  Repository '$REPO_NAME' cloned successfully."
        echo ""
    fi
done

echo ""
echo "All specified repositories have been processed."
echo "You can find them in: $TARGET_BASE_DIR"
