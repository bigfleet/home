#!/bin/bash

# Install atuin and log in using credentials from 1Password

# Install atuin if not present
if ! command -v atuin &> /dev/null; then
    echo "Installing atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
    echo "atuin already installed"
fi

# Skip login if already logged in (session file exists and sync works)
if atuin sync 2>/dev/null; then
    echo "atuin already logged in and syncing"
    exit 0
fi

# Need op to pull credentials
if ! command -v op &> /dev/null; then
    echo "1Password CLI not found - skipping atuin login"
    echo "Run 'chezmoi apply' again after installing op"
    exit 0
fi

echo "Logging into atuin via 1Password..."

ATUIN_PASSWORD=$(op item get 6uklwitqpuz3x4y4h4vumppjyi --fields password --reveal 2>&1)
if [ $? -ne 0 ]; then
    echo "Could not retrieve atuin password from 1Password"
    echo "Make sure you are signed into op, then re-run: chezmoi apply"
    exit 0
fi

ATUIN_KEY=$(op item get 6uklwitqpuz3x4y4h4vumppjyi --fields "recovery phrase" --reveal 2>&1)
if [ $? -ne 0 ]; then
    echo "Could not retrieve atuin key from 1Password"
    exit 0
fi

atuin login -u bigfleet -p "$ATUIN_PASSWORD" -k "$ATUIN_KEY"

if [ $? -eq 0 ]; then
    echo "atuin login successful"
    atuin sync
else
    echo "atuin login failed"
fi
