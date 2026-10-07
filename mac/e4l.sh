#!/bin/bash
# Clone E4L (Energy4Life) work repositories.

source "$(dirname "$0")/clone-repos.sh"

TARGET_BASE_DIR="$HOME/code/e4l"

GIT_REPOS=(
    "git@ssh.dev.azure.com:v3/neshealth/E4L/GEM_WEARABLE|GEM"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/BCUv2"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/BCUv1"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/BioSync"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/field-app"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/Gem-factory-app"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/GemBLEtest"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/mihealth-ota"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/mihealth-simulator"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/mihealth-tui"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/MihealthV2"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/Mihealthv2-factory-test"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/MiHeathV2-Sub"
    "git@ssh.dev.azure.com:v3/neshealth/E4L/ScannerV2FW"
    "git@github.com:piyush-e4l/gem.git|gem_algo"
)

clone_repos "$TARGET_BASE_DIR" "${GIT_REPOS[@]}"
