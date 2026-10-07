#!/bin/bash
# Shared helper: clone a list of git repos into a base directory.
# Usage (from another script):
#   source "$(dirname "$0")/clone-repos.sh"
#   clone_repos "$HOME/code/ct3" "git@host:org/repo.git" "git@host:org/other.git|custom-dir"
# An entry may be "URL|DIR" to clone into a directory name different from the repo name.

clone_repos() {
    local target_base_dir="$1"
    shift

    echo "Starting multi-repository cloning process into $target_base_dir..."
    mkdir -p "$target_base_dir" || { echo "Error: Failed to create $target_base_dir" >&2; return 1; }

    local failed=0
    for entry in "$@"; do
        local repo_url="${entry%%|*}"
        local repo_name
        if [[ "$entry" == *"|"* ]]; then
            repo_name="${entry#*|}"
        else
            repo_name="$(basename "$repo_url")"
            repo_name="${repo_name%.git}"
        fi
        local dest="$target_base_dir/$repo_name"

        if [ -d "$dest" ]; then
            echo "  '$repo_name' already exists. Skipping (cd $dest && git pull to update)."
        else
            echo "  Cloning '$repo_name' from $repo_url..."
            if git clone "$repo_url" "$dest"; then
                echo "  '$repo_name' cloned successfully."
            else
                echo "  Error: Failed to clone '$repo_name'. Check your SSH key / access." >&2
                failed=$((failed + 1))
            fi
        fi
    done

    echo ""
    echo "All repositories processed ($failed failed). Location: $target_base_dir"
    [ "$failed" -eq 0 ]
}
