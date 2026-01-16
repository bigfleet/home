#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Checking for direnv installation..."

# Check if direnv is already installed
if command -v direnv &> /dev/null; then
    echo "direnv is already installed. Skipping installation."
    exit 0
fi

echo "direnv not found. Installing..."

if command -v dnf &> /dev/null; then
  sudo dnf install direnv
elif command -v apt &> /dev/null; then
  # Update apt cache and install direnv
  sudo apt update
  sudo apt install -y direnv
fi

echo "direnv installation complete."
