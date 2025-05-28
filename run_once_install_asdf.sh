#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Checking for asdf installation..."

# Check if asdf is already installed
if [ -d "$HOME/.asdf" ]; then
    echo "asdf is already installed. Skipping installation."
    exit 0
fi

echo "asdf not found. Installing..."

# Clone asdf from its GitHub repository
# You might need git installed for this.
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch latest

echo "asdf installation complete. Please run 'chezmoi apply' again or open a new terminal to ensure .bashrc is sourced."