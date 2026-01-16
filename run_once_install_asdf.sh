#!/bin/bash

ASDF_VERSION="v0.18.0"
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# Check if asdf is already installed
if [ -d "$ASDF_DIR" ]; then
    echo "asdf is already installed at $ASDF_DIR"
    exit 0
fi

echo "Latest asdf tag found: $ASDF_VERSION"
echo "Checking for asdf installation..."

if ! command -v asdf &> /dev/null; then
    echo "asdf not found. Installing..."
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_VERSION"
    cd "$ASDF_DIR"
    make  # This builds the Go binary!
    echo "asdf installation complete. Please run 'chezmoi apply' again or open a new terminal to ensure .bashrc is sourced."
else
    echo "asdf is already installed."
fi
