#!/bin/bash

ASDF_VERSION="v0.18.0"
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

# Check if asdf is already installed
if [ -d "$ASDF_DIR" ]; then
    echo "asdf is already installed at $ASDF_DIR"
    exit 0
fi

echo "Installing asdf $ASDF_VERSION..."
echo "Downloading release binary..."

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ASDF_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    ASDF_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Download and extract
curl -L "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-${ASDF_ARCH}.tar.gz" -o /tmp/asdf.tar.gz
mkdir -p "$ASDF_DIR"
tar -xzf /tmp/asdf.tar.gz -C "$ASDF_DIR"
rm /tmp/asdf.tar.gz

echo "asdf installation complete. Please run 'chezmoi apply' again or open a new terminal to ensure .bashrc is sourced."
