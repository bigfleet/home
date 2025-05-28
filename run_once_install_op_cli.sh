#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Checking for 1Password CLI (op)..."

# Check if op is already installed
if command -v op &> /dev/null; then
    echo "1Password CLI (op) is already installed. Skipping installation."
    exit 0
fi

echo "1Password CLI (op) not found. Installing..."

# Add the 1Password apt repository key
# Ensure sudo is available and passwordless if you want full automation,
# otherwise you will be prompted.
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

# Add the 1Password apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
    sudo tee /etc/apt/sources.list.d/1password.list

# Update apt cache and install 1Password CLI
sudo apt update
sudo apt install -y 1password-cli

echo "1Password CLI (op) installation complete."