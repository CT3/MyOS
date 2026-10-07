#!/bin/bash
# This script provides a command-line interface (CLI) to select and run
# various shell scripts from a predefined list for macOS setup.
# Compatible with the stock macOS bash 3.2 (no associative arrays).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Configuration ---
# Index N in SCRIPTS matches menu number N+1
SCRIPTS=(
    "brew.sh"
    "cask.sh"
    "cargo-app.sh"
    "mas.sh"
    "e4l.sh"
    "ct3.sh"
    "self.sh"
    "chezmoi.sh"
    "nvim.sh"
    "esp.sh"
    "dev.sh"
)

DESCRIPTIONS=(
    "Install apps using Homebrew (formulas)"
    "Install GUI apps using Homebrew Cask"
    "Install Rust-based applications via Cargo"
    "Install Mac App Store apps via mas"
    "Clone E4L repositories"
    "Setup Git configuration and clone CT3 repositories"
    "Clone ElevatedSelf repositories"
    "Setup Chezmoi dotfiles management"
    "Setup Neovim configuration"
    "Install ESP development tools"
    "Setup Dev tools"
)

# --- Functions ---

menu_item() {
    local n="$1"
    local i=$((n - 1))
    printf "    %2d. %s (./%s)\n" "$n" "${DESCRIPTIONS[$i]}" "${SCRIPTS[$i]}"
}

display_menu() {
    echo "-------------------------------------"
    echo "  Select Shell Scripts to Run (macOS)"
    echo "-------------------------------------"
    echo ""
    echo "  # App Install"
    menu_item 1
    menu_item 2
    menu_item 3
    menu_item 4
    echo ""
    echo "  # Setup Git Stuff"
    menu_item 5
    menu_item 6
    menu_item 7
    echo ""
    echo "  # Setup Apps"
    menu_item 8
    menu_item 9
    echo ""
    echo "  # Install Dev Tools"
    menu_item 10
    menu_item 11
    echo ""
    echo "-------------------------------------"
    echo "  Enter numbers separated by spaces (e.g., 1 3 5)"
    echo "  Or type 'all' to run all scripts."
    echo "  Or type 'exit' to quit."
    echo "-------------------------------------"
}

run_script() {
    local i="$1"
    local script_path="$SCRIPT_DIR/${SCRIPTS[$i]}"
    echo "Running: ${SCRIPTS[$i]} (${DESCRIPTIONS[$i]})"
    if [ ! -f "$script_path" ]; then
        echo "  Error: Script '$script_path' not found. Skipping."
        echo ""
        return
    fi
    bash "$script_path"
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "  Script ${SCRIPTS[$i]} exited with error code $exit_code."
    else
        echo "  Script ${SCRIPTS[$i]} completed successfully."
    fi
    echo ""
}

run_scripts() {
    if [ $# -eq 0 ]; then
        echo "No scripts selected."
        return
    fi

    echo ""
    echo "--- Running Selected Scripts ---"

    for option in "$@"; do
        if [ "$option" = "all" ]; then
            local i
            for i in "${!SCRIPTS[@]}"; do
                run_script "$i"
            done
            break
        elif [[ "$option" =~ ^[0-9]+$ ]] && [ "$option" -ge 1 ] && [ "$option" -le "${#SCRIPTS[@]}" ]; then
            run_script $((option - 1))
        else
            echo "Invalid option: $option. Skipping."
        fi
    done

    echo "--- Script Execution Finished ---"
}

# --- Main Logic ---

while true; do
    display_menu
    read -p "Your choice(s): " choices

    case "$choices" in
        "exit")
            echo "Exiting script runner. Goodbye!"
            break
            ;;
        *)
            read -r -a selected_scripts_array <<< "$choices"
            run_scripts "${selected_scripts_array[@]}"
            ;;
    esac
    echo ""
done
