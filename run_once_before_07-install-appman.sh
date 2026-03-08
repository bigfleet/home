#!/bin/bash

# Install AppMan (single-user AppImage manager, no root needed)
# https://github.com/ivan-hc/AppMan

if command -v appman &> /dev/null; then
    echo "AppMan already installed"
    exit 0
fi

echo "Installing AppMan..."
mkdir -p "$HOME/.local/bin"

wget -q "https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER" -O /tmp/AM-INSTALLER
chmod a+x /tmp/AM-INSTALLER

# Automated install: option 2 = AppMan (local/single-user)
echo "2" | /tmp/AM-INSTALLER
rm -f /tmp/AM-INSTALLER

echo "AppMan installation complete"
