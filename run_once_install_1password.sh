#!/bin/bash

# Check if 1Password is already installed
if command -v 1password &> /dev/null; then
    echo "1Password is already installed"
    exit 0
fi

echo "Installing 1Password for Fedora..."

# Import GPG key
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Add repository
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'

# Install
sudo dnf install -y 1password

echo "1Password installation complete"

