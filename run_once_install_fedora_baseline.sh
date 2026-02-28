#!/bin/bash

# Install baseline development packages for Fedora
# Skips on non-Fedora systems (WSL with apt, macOS, etc.)
# Uses --skip-unavailable so renamed/removed packages don't break the script

if ! command -v dnf &> /dev/null; then
    echo "dnf not found - skipping Fedora baseline packages"
    exit 0
fi

echo "Installing Fedora baseline packages..."

sudo dnf install -y --skip-unavailable \
    git \
    bats \
    tree \
    lshw \
    dos2unix

echo "Fedora baseline packages installed"
