#!/bin/bash

# Check if code is installed
if ! command -v code &> /dev/null; then
    echo "VSCode is not installed, skipping extensions"
    exit 0
fi

# List of extensions to install
extensions=(
    # Python development
    "ms-python.python"
    "ms-python.vscode-pylance"
    
    # Remote development
    "ms-vscode-remote.remote-ssh"
    
    # Git
    "eamodio.gitlens"
    
    # YAML/Ansible
    "redhat.vscode-yaml"
    "redhat.ansible"
    
    # Docker/Kubernetes
    "ms-azuretools.vscode-docker"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    
    # General utilities
    "editorconfig.editorconfig"
)

echo "Installing VSCode extensions..."

for ext in "${extensions[@]}"; do
    if code --list-extensions | grep -qi "^${ext}$"; then
        echo "✓ $ext already installed"
    else
        echo "Installing $ext..."
        code --install-extension "$ext" --force
    fi
done

echo "VSCode extensions installation complete"
