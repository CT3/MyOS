
#!/bin/bash

# This script automates launching J-Link RTT Viewer in the terminal.
# It starts JLinkExe in the background and JLinkRTTClient in the foreground.

# --- Configuration ---
# Default device name (e.g., NRF52840_xxAA, STM32F103ZE)
# IMPORTANT: Change this to match your target device.
DEFAULT_DEVICE="CORTEX-M4" # A generic Cortex-M device as a fallback
# Default interface speed in kHz
DEFAULT_SPEED="4000"
# Interface type (SWD or JTAG)
INTERFACE="SWD"

# --- Functions ---

# Function to display usage instructions
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "This script starts J-Link RTT viewing in your terminal."
    echo ""
    echo "Options:"
    echo "  -d, --device <name>    Specify the target device name (e.g., NRF52840_xxAA)."
    echo "                         Default: ${DEFAULT_DEVICE}"
    echo "  -s, --speed <kHz>      Specify the interface speed in kHz (e.g., 4000, 50000)."
    echo "                         Default: ${DEFAULT_SPEED}"
    echo "  -i, --interface <type> Specify the interface type (SWD or JTAG)."
    echo "                         Default: ${INTERFACE}"
    echo "  -h, --help             Display this help message."
    echo ""
    echo "Prerequisites:"
    echo "  - SEGGER J-Link Software and Documentation Pack must be installed."
    echo "  - 'JLinkExe' and 'JLinkRTTClient' must be in your system's PATH."
    echo "  - Your target device must be connected to the J-Link debugger and powered on."
    echo "  - Your embedded application must be configured to use SEGGER RTT for output."
    echo ""
    echo "Example:"
    echo "  $0 --device NRF52840_xxAA --speed 8000"
    exit 1
}

# --- Argument Parsing ---
DEVICE=$DEFAULT_DEVICE
SPEED=$DEFAULT_SPEED

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d|--device)
            DEVICE="$2"
            shift
            ;;
        -s|--speed)
            SPEED="$2"
            shift
            ;;
        -i|--interface)
            INTERFACE="$2"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# --- Check for J-Link tools ---
if ! command -v JLinkExe &> /dev/null; then
    echo "Error: 'JLinkExe' not found. Please ensure SEGGER J-Link Software is installed and in your PATH."
    exit 1
fi

if ! command -v JLinkRTTClient &> /dev/null; then
    echo "Error: 'JLinkRTTClient' not found. Please ensure SEGGER J-Link Software is installed and in your PATH."
    exit 1
fi

# --- Main Script Logic ---

echo "--- Starting J-Link RTT Terminal Viewer ---"
echo "Target Device:   ${DEVICE}"
echo "Interface:       ${INTERFACE}"
echo "Interface Speed: ${SPEED} kHz"
echo ""

# Start JLinkExe in the background
echo "Starting JLinkExe in the background..."
# We redirect stdout/stderr to a log file to keep the main terminal clean,
# but you can uncomment the next line and comment out the `>` part if you want to see JLinkExe output.
# JLinkExe -if "${INTERFACE}" -device "${DEVICE}" -speed "${SPEED}" -autoconnect 1 > jlinkexe_log.txt 2>&1 &
JLinkExe -if "${INTERFACE}" -device "${DEVICE}" -speed "${SPEED}" -autoconnect 1 &
JLINK_EXE_PID=$!
echo "JLinkExe started with PID: ${JLINK_EXE_PID}"

# Trap to kill JLinkExe when this script exits (e.g., Ctrl+C)
trap "echo 'Stopping JLinkExe (PID: ${JLINK_EXE_PID})...'; kill ${JLINK_EXE_PID} 2>/dev/null; exit" EXIT

# Give JLinkExe a moment to establish connection
echo "Giving JLinkExe a few seconds to connect..."
sleep 3

# Start JLinkRTTClient in the foreground
echo "Starting JLinkRTTClient. RTT output will appear below:"
echo "----------------------------------------------------"
JLinkRTTClient

echo "----------------------------------------------------"
echo "J-Link RTT session ended."
