#!/bin/bash

# Install asdf language plugins and versions from ~/.tool-versions
# Depends on: asdf, Ruby build deps

ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

if [ ! -d "$ASDF_DIR" ]; then
    echo "asdf not installed - run chezmoi apply first"
    exit 1
fi

# Ensure asdf is on PATH (v0.18+ puts binary at $ASDF_DIR/asdf directly)
export PATH="$ASDF_DIR:$PATH"

# Ruby plugin
if ! asdf plugin list 2>/dev/null | grep -q ruby; then
    echo "Adding asdf ruby plugin..."
    asdf plugin add ruby
else
    echo "Updating asdf ruby plugin..."
    asdf plugin update ruby
fi

# Install versions from ~/.tool-versions if present
if [ -f "$HOME/.tool-versions" ]; then
    echo "Installing tool versions from ~/.tool-versions..."
    asdf install
else
    echo "No ~/.tool-versions found - skipping version install"
fi

echo "asdf plugins configured"
