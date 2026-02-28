#!/bin/bash

# Install asdf plugins and versions from ~/.tool-versions
# Depends on: asdf, Ruby build deps (for ruby)

ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

if [ ! -d "$ASDF_DIR" ]; then
    echo "asdf not installed - run chezmoi apply first"
    exit 1
fi

# Ensure asdf is on PATH (v0.18+ puts binary at $ASDF_DIR/asdf directly)
export PATH="$ASDF_DIR:$PATH"

# Add plugins for each tool listed in .tool-versions
if [ -f "$HOME/.tool-versions" ]; then
    while read -r plugin _version; do
        [ -z "$plugin" ] && continue
        if ! asdf plugin list 2>/dev/null | grep -q "^${plugin}$"; then
            echo "Adding asdf plugin: $plugin"
            asdf plugin add "$plugin"
        else
            echo "Updating asdf plugin: $plugin"
            asdf plugin update "$plugin"
        fi
    done < "$HOME/.tool-versions"

    echo "Installing tool versions from ~/.tool-versions..."
    asdf install
else
    echo "No ~/.tool-versions found - skipping"
fi

echo "asdf plugins configured"
