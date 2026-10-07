#!/bin/bash
# Clone ElevatedSelf organisation repositories.

source "$(dirname "$0")/clone-repos.sh"

TARGET_BASE_DIR="$HOME/code/self"

GIT_REPOS=(
    "git@github.com:ElevatedSelf/ElevatedWebsite.git"
    "git@github.com:ElevatedSelf/backendAPI.git"
    "git@github.com:ElevatedSelf/moms.git"
    "git@github.com:ElevatedSelf/Jtodoapp.git"
    "git@github.com:ElevatedSelf/HerbalRX.git"
    "git@github.com:ElevatedSelf/DrHerb.git"
    "git@github.com:ElevatedSelf/DrPeptide.git"
    "git@github.com:ElevatedSelf/DrMind.git"
    "git@github.com:ElevatedSelf/Research.git"
    "git@github.com:ElevatedSelf/marketing.git"
    "git@github.com:ElevatedSelf/YT-videos.git"
    "git@github.com:ElevatedSelf/assets.git"
)

clone_repos "$TARGET_BASE_DIR" "${GIT_REPOS[@]}"
