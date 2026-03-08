#!/bin/bash

# Install baseline development packages
# Supports Fedora (dnf) and Ubuntu/Debian (apt)

echo "Installing baseline packages..."

if command -v dnf &> /dev/null; then
    # --allowerasing: Fedora 43+ ships wget2-wget by default;
    # AppMan requires classic wget (wget1), so allow dnf to swap it.
    sudo dnf install -y --skip-unavailable --allowerasing \
        git \
        bats \
        tree \
        lshw \
        dos2unix \
        wget1 \
        wget1-wget
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
