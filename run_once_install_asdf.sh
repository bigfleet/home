#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

REPO_URL="https://github.com/asdf-vm/asdf.git"

# Get all tags, sort them as versions, and pick the last one (latest)
# -t: only show tags
# sort -V: version sort
# tail -n 1: get the last line (the latest version)
LATEST_TAG=$(git ls-remote --tags "$REPO_URL" | grep -o 'refs/tags/v[0-9]*\.[0-9]*\.[0-9]*$' | sed 's/refs\/tags\///' | sort -V | tail -n 1)

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not find latest tag for $REPO_URL" >&2
    exit 1
fi

echo "Latest asdf tag found: $LATEST_TAG"

echo "Checking for asdf installation..."

# Check if asdf is already installed
if [ -d "$HOME/.asdf" ]; then
    echo "asdf is already installed. Skipping installation."
    exit 0
fi

echo "asdf not found. Installing..."

# Clone asdf from its GitHub repository
# You might need git installed for this.
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $LATEST_TAG

echo "asdf installation complete. Please run 'chezmoi apply' again or open a new terminal to ensure .bashrc is sourced."