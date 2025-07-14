#!/bin/bash

# This script is intended to be run as part of a chezmoi setup.
# Its sole purpose is to download the asdf-vm executable and place it in ~/.local/bin.
# Shell integration, ASDF_DATA_DIR, shims, and completions are expected to be handled
# by chezmoi templates (e.g., in dot_bashrc.tmpl).

# --- Configuration ---
BIN_DIR="$HOME/.local/bin"        # Where the asdf executable will be placed (must be in PATH)
REPO_SLUG="asdf-vm/asdf"          # GitHub repository owner/name

# --- 1. Determine Latest ASDF Release (Go Binary) ---
echo "Fetching latest ASDF release information from GitHub..."
# Using 'gh api' if GitHub CLI is installed and authenticated for robustness,
# otherwise fallback to curl.
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    LATEST_TAG=$(gh api "repos/$REPO_SLUG/releases/latest" --jq '.tag_name')
    if [ -z "$LATEST_TAG" ]; then
        echo "Warning: Failed to get latest tag using 'gh api'. Falling back to 'curl'." >&2
    fi
fi

if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO_SLUG/releases/latest" | \
                 grep -oP '"tag_name": "\K[^"]+' | head -n 1)
fi

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not find latest ASDF release tag for $REPO_SLUG. Exiting." >&2
    exit 1
fi

echo "Latest ASDF release found: $LATEST_TAG"

# --- 2. Determine Host Architecture and Operating System ---
OS=$(uname -s | tr '[:upper:]' '[:lower:]') # e.g., linux, darwin
ARCH=$(uname -m)                             # e.g., x86_64, arm64, aarch64

# Map uname -m to ASDF's asset naming conventions
case "$ARCH" in
    x86_64)  ARCH_ASSET_NAME="amd64" ;; # Maps x86_64 to amd64 for asset name
    aarch64) ARCH_ASSET_NAME="arm64" ;; # Maps aarch64 to arm64
    arm64)   ARCH_ASSET_NAME="arm64" ;; # Maps arm64 to arm64 (for macOS M-series)
    i386 | i686) ARCH_ASSET_NAME="386" ;; # Handles 32-bit Linux
    *) echo "Error: Unsupported architecture $ARCH ($OS)." >&2; exit 1 ;;
esac

# Construct the correct DOWNLOAD_URL based on actual asset names
# The asset is named like: asdf-vX.Y.Z-OS-ARCH.tar.gz
BINARY_ARCHIVE="asdf-${LATEST_TAG}-${OS}-${ARCH_ASSET_NAME}.tar.gz"
DOWNLOAD_URL="https://github.com/$REPO_SLUG/releases/download/$LATEST_TAG/$BINARY_ARCHIVE"

echo "Attempting to download ASDF from: $DOWNLOAD_URL"

# --- 3. Download and Extract ASDF Binary ---

# Ensure the target binary directory exists
mkdir -p "$BIN_DIR"

# Check if asdf is already installed and is the latest version
if [ -f "$BIN_DIR/asdf" ]; then
    CURRENT_ASDF_VERSION=$("$BIN_DIR/asdf" version 2>/dev/null | awk '{print $1}')
    if [ "$CURRENT_ASDF_VERSION" = "${LATEST_TAG#v}" ]; then
        echo "ASDF is already installed at $BIN_DIR/asdf and is the latest version ($LATEST_TAG). Skipping download."
        exit 0
    else
        echo "ASDF found at $BIN_DIR/asdf (version $CURRENT_ASDF_VERSION), but $LATEST_TAG is available. Updating..."
    fi
fi

TEMP_DIR=$(mktemp -d)
TEMP_ARCHIVE="$TEMP_DIR/asdf_temp.tar.gz"

if ! curl -fL --retry 3 --retry-delay 5 --connect-timeout 10 --max-time 30 "$DOWNLOAD_URL" -o "$TEMP_ARCHIVE"; then
    echo "Error: Failed to download ASDF from $DOWNLOAD_URL. Check URL and network connectivity." >&2
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Verify the downloaded file is a gzip archive before attempting to extract
if ! file "$TEMP_ARCHIVE" | grep -q "gzip compressed data"; then
    echo "Error: Downloaded file is not a valid gzip compressed data. It might be an HTML error page or corrupted." >&2
    echo "File type detected: $(file "$TEMP_ARCHIVE")" >&2
    echo "Partial content of downloaded file:" >&2
    head -n 20 "$TEMP_ARCHIVE" >&2 # Show first 20 lines for debugging
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Extracting ASDF binary..."
if ! tar -xzf "$TEMP_ARCHIVE" -C "$TEMP_DIR"; then
    echo "Error: Failed to extract ASDF archive. The downloaded file might be corrupted." >&2
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Move the 'asdf' executable to the target bin directory
if ! mv "$TEMP_DIR/asdf" "$BIN_DIR/asdf"; then
    echo "Error: Failed to move asdf executable to $BIN_DIR. Check permissions." >&2
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Set executable permissions
chmod +x "$BIN_DIR/asdf"

# Clean up temporary files
rm -rf "$TEMP_DIR"
echo "ASDF executable installed to: $BIN_DIR/asdf"
echo "Please ensure $BIN_DIR is in your PATH and chezmoi manages your asdf configuration."

# This script intentionally does NOT add lines to .bashrc, .zshrc, etc.
# That responsibility falls to chezmoi templates.