#!/bin/bash

# Skip on WSL - Docker Desktop with WSL integration is more common
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "WSL detected - skipping Podman install (consider Docker Desktop with WSL integration)"
    exit 0
fi

# Check if Podman is already installed
if command -v podman &> /dev/null; then
    echo "Podman is already installed"
    podman --version
    exit 0
fi

echo "Installing Podman for Fedora..."

# Install podman and related tools
sudo dnf install -y podman podman-compose podman-docker

# Enable podman socket (for Docker compatibility)
systemctl --user enable --now podman.socket

echo "Podman installation complete"
podman --version

# Optional: Create docker alias
echo "Note: 'podman-docker' package creates 'docker' alias pointing to podman"