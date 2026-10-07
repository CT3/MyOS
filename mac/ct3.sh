#!/bin/bash
# Set personal git identity and clone CT3 (personal) repositories.

source "$(dirname "$0")/clone-repos.sh"

git config --global user.email "mantasjurkuvenas@gmail.com"
git config --global user.name "Mantas Jurkvenas"

TARGET_BASE_DIR="$HOME/code/ct3"

GIT_REPOS=(
    "git@github.com:CT3/zmk-config.git"
    "git@github.com:CT3/CopyPasta.git"
    "git@github.com:CT3/aserial.git"
    "git@github.com:CT3/initC.git"
    "git@github.com:CT3/MyOS.git"
    "git@github.com:CT3/alpaca-mcp.git"
    "git@github.com:CT3/biohacking.git"
    "git@github.com:CT3/gempub.git"
    "git@github.com:CT3/Jtodocli.git"
)

clone_repos "$TARGET_BASE_DIR" "${GIT_REPOS[@]}"
