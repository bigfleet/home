#!/bin/bash

# Install baseline development packages
# Supports Fedora (dnf) and Ubuntu/Debian (apt)

echo "Installing baseline packages..."

if command -v dnf &> /dev/null; then
    sudo dnf install -y --skip-unavailable \
        git \
        bats \
        tree \
        lshw \
        dos2unix
elif command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y \
        git \
        bats \
        tree \
        lshw \
        dos2unix
else
    echo "Unsupported package manager - skipping baseline packages"
    exit 0
fi

echo "Baseline packages installed"
