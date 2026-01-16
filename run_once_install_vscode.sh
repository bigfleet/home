#!/bin/bash

# Check if VSCode is already installed
if command -v code &> /dev/null; then
    echo "VSCode is already installed"
    exit 0
fi

echo "Installing VSCode for Fedora..."

# Import Microsoft GPG key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add VSCode repository
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Install
sudo dnf install -y code

echo "VSCode installation complete"
