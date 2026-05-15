#!/bin/bash
# This script provides a command-line interface (CLI) to select and run
# various shell scripts from a predefined list for macOS setup.
# --- Configuration ---
declare -A scripts=(
    ["1"]="brew.sh"
    ["2"]="cask.sh"
    ["3"]="cargo-app.sh"
    ["4"]="e4l.sh"
    ["5"]="ct3.sh"
    ["6"]="chezmoi.sh"
    ["7"]="nvim.sh"
    ["8"]="esp.sh"
    ["9"]="dev.sh"
)

declare -A script_descriptions=(
    ["brew.sh"]="Install apps using Homebrew (formulas)"
    ["cask.sh"]="Install GUI apps using Homebrew Cask"
    ["cargo-app.sh"]="Install Rust-based applications via Cargo"
    ["e4l.sh"]="Setup Git configuration for E4L"
    ["ct3.sh"]="Setup Git configuration for CT3"
    ["chezmoi.sh"]="Setup Chezmoi dotfiles management"
    ["nvim.sh"]="Setup Neovim configuration"
    ["esp.sh"]="Install ESP development tools"
    ["dev.sh"]="Setup Dev tools"
)

# --- Functions ---

display_menu() {
    echo "-------------------------------------"
    echo "  Select Shell Scripts to Run (macOS)"
    echo "-------------------------------------"
    echo ""
    echo "  # App Install"
    echo "    1. ${script_descriptions[brew.sh]} (./brew.sh)"
    echo "    2. ${script_descriptions[cask.sh]} (./cask.sh)"
    echo "    3. ${script_descriptions[cargo-app.sh]} (./cargo-app.sh)"
    echo ""
    echo "  # Setup Git Stuff"
    echo "    4. ${script_descriptions[e4l.sh]} (./e4l.sh)"
    echo "    5. ${script_descriptions[ct3.sh]} (./ct3.sh)"
    echo ""
    echo "  # Setup Apps"
    echo "    6. ${script_descriptions[chezmoi.sh]} (./chezmoi.sh)"
    echo "    7. ${script_descriptions[nvim.sh]} (./nvim.sh)"
    echo ""
    echo "  # Install Dev Tools"
    echo "    8. ${script_descriptions[esp.sh]} (./esp.sh)"
    echo "    9. ${script_descriptions[dev.sh]} (./dev.sh)"
    echo ""
    echo "-------------------------------------"
    echo "  Enter numbers separated by spaces (e.g., 1 3 5)"
    echo "  Or type 'all' to run all scripts."
    echo "  Or type 'exit' to quit."
    echo "-------------------------------------"
}

run_scripts() {
    local selected_options=("$@")

    if [ ${#selected_options[@]} -eq 0 ]; then
        echo "No scripts selected."
        return
    fi

    echo ""
    echo "--- Running Selected Scripts ---"

    for option in "${selected_options[@]}"; do
        if [[ "$option" == "all" ]]; then
            for key in "${!scripts[@]}"; do
                local script_path="${scripts[$key]}"
                echo "Running: $script_path (${script_descriptions[$script_path]})"
                if [ -f "$script_path" ]; then
                    if [ ! -x "$script_path" ]; then
                        echo "  Warning: $script_path is not executable. Attempting to make it executable..."
                        chmod +x "$script_path" || { echo "  Error: Failed to make $script_path executable. Skipping."; continue; }
                    fi
                    bash "$script_path"
                    local exit_code=$?
                    if [ $exit_code -ne 0 ]; then
                        echo "  Script $script_path exited with error code $exit_code."
                    else
                        echo "  Script $script_path completed successfully."
                    fi
                else
                    echo "  Error: Script '$script_path' not found. Skipping."
                fi
                echo ""
            done
            break
        elif [[ -v scripts["$option"] ]]; then
            local script_path="${scripts[$option]}"
            echo "Running: $script_path (${script_descriptions[$script_path]})"
            if [ -f "$script_path" ]; then
                if [ ! -x "$script_path" ]; then
                    echo "  Warning: $script_path is not executable. Attempting to make it executable..."
                    chmod +x "$script_path" || { echo "  Error: Failed to make $script_path executable. Skipping."; continue; }
                fi
                bash "$script_path"
                local exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    echo "  Script $script_path exited with error code $exit_code."
                else
                    echo "  Script $script_path completed successfully."
                fi
            else
                echo "  Error: Script '$script_path' not found. Skipping."
            fi
            echo ""
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
        "all")
            run_scripts "all"
            ;;
        *)
            IFS=' ' read -r -a selected_scripts_array <<< "$choices"
            run_scripts "${selected_scripts_array[@]}"
            ;;
    esac
    echo ""
done
