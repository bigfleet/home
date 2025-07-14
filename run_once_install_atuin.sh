#!/bin/bash

# This script is intended to be run as a Chezmoi run_once_ script.
# It installs Atuin using its official setup script, but only if Atuin
# appears not to be installed already.

# Define common installation paths for Atuin
# Atuin typically installs its executable to ~/.local/bin/atuin
# and its configuration/data to ~/.config/atuin or ~/.local/share/atuin
ATUIN_EXEC_PATH="$HOME/.local/bin/atuin"
ATUIN_CONFIG_DIR="$HOME/.config/atuin" # Or ~/.local/share/atuin, depending on your setup/version

echo "Checking for existing Atuin installation..."

# --- Check 1: Is the Atuin executable already in ~/.local/bin? ---
if [ -f "$ATUIN_EXEC_PATH" ]; then
    echo "Atuin executable found at $ATUIN_EXEC_PATH. Assuming Atuin is already installed."
    echo "To force re-installation, remove $ATUIN_EXEC_PATH and then run 'chezmoi apply'."
    exit 0 # Exit successfully, no need to install
fi

# --- Check 2: Does the Atuin config directory exist? (Less definitive, but a good secondary check) ---
if [ -d "$ATUIN_CONFIG_DIR" ]; then
    echo "Atuin configuration directory found at $ATUIN_CONFIG_DIR. Assuming Atuin is already installed."
    echo "To force re-installation, remove $ATUIN_CONFIG_DIR (and $ATUIN_EXEC_PATH if present) and then run 'chezmoi apply'."
    exit 0 # Exit successfully, no need to install
fi

echo "Atuin not found. Proceeding with installation..."

# --- Atuin Installation Command ---
# This is the official Atuin setup script via curl
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash

# You might want to add a final check here to ensure the installation succeeded
if [ -f "$ATUIN_EXEC_PATH" ]; then
    echo "Atuin installation appears successful: $ATUIN_EXEC_PATH created."
else
    echo "Warning: Atuin installation script ran, but $ATUIN_EXEC_PATH was not found." >&2
    echo "Please check the Atuin setup.sh script output for errors." >&2
    exit 1 # Indicate a potential issue with the installation
fi

# Note: Configuring Atuin (e.g., auto-start, shell integration)
# should be handled by your chezmoi templates (e.g., ~/.bashrc.tmpl).