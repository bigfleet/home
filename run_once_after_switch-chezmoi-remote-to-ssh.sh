#!/bin/bash

# Switch chezmoi source repo remote from HTTPS to SSH
# Runs after dotfiles are applied so ~/.ssh/config (with 1Password agent) is in place
#
# This won't make git push work on its own — you still need to:
#   1. Launch 1Password and sign in
#   2. Enable SSH agent in Settings → Developer

CHEZMOI_DIR="$(chezmoi source-path 2>/dev/null)"

if [ -z "$CHEZMOI_DIR" ] || [ ! -d "$CHEZMOI_DIR/.git" ]; then
    echo "chezmoi source directory not found - skipping remote switch"
    exit 0
fi

cd "$CHEZMOI_DIR"

CURRENT_URL=$(git remote get-url origin 2>/dev/null)

case "$CURRENT_URL" in
    git@github.com:*)
        echo "chezmoi remote already using SSH"
        ;;
    https://github.com/*)
        # Transform https://github.com/user/repo.git → git@github.com:user/repo.git
        SSH_URL=$(echo "$CURRENT_URL" | sed 's|https://github.com/|git@github.com:|')
        git remote set-url origin "$SSH_URL"
        echo "Switched chezmoi remote to SSH: $SSH_URL"
        ;;
    *)
        echo "Unrecognized remote URL: $CURRENT_URL - skipping"
        ;;
esac
