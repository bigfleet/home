#!/bin/bash

# Install asdf plugins and versions from ~/.tool-versions
# Supports "latest" in .tool-versions by resolving to actual version at apply time
# Depends on: asdf, Ruby build deps (for ruby)

ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"

if [ ! -d "$ASDF_DIR" ]; then
    echo "asdf not installed - run chezmoi apply first"
    exit 1
fi

# Ensure asdf is on PATH (v0.18+ puts binary at $ASDF_DIR/asdf directly)
export PATH="$ASDF_DIR:$PATH"

if [ ! -f "$HOME/.tool-versions" ]; then
    echo "No ~/.tool-versions found - skipping"
    exit 0
fi

# Add/update plugins for each tool listed in .tool-versions
while read -r plugin version; do
    [ -z "$plugin" ] && continue
    if ! asdf plugin list 2>/dev/null | grep -q "^${plugin}$"; then
        echo "Adding asdf plugin: $plugin"
        asdf plugin add "$plugin"
    else
        echo "Updating asdf plugin: $plugin"
        asdf plugin update "$plugin"
    fi

    # Resolve "latest" to an actual version number
    if [ "$version" = "latest" ]; then
        resolved=$(asdf latest "$plugin" 2>/dev/null)
        if [ -n "$resolved" ]; then
            echo "$plugin: latest -> $resolved"
            version="$resolved"
        else
            echo "$plugin: could not resolve latest, skipping install"
            continue
        fi
    fi

    # Install if not already present
    if asdf list "$plugin" 2>/dev/null | grep -q "$version"; then
        echo "$plugin $version already installed"
    else
        echo "Installing $plugin $version..."
        asdf install "$plugin" "$version"
    fi
done < "$HOME/.tool-versions"

echo "asdf plugins configured"
