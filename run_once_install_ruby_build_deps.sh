#!/bin/bash

# Install system dependencies required to compile Ruby via asdf
# Covers: OpenSSL, libyaml, readline, zlib, libffi, and C toolchain

# Quick check: if ruby builds already work, skip
if asdf list ruby 2>/dev/null | grep -q "3\."; then
    echo "Ruby already installed via asdf - build deps likely present"
    exit 0
fi

echo "Installing Ruby build dependencies..."

if command -v dnf &> /dev/null; then
    # Fedora / RHEL / CentOS
    sudo dnf install -y \
        gcc make \
        openssl-devel libyaml-devel readline-devel zlib-devel libffi-devel \
        gdbm-devel ncurses-devel
elif command -v apt-get &> /dev/null; then
    # Debian / Ubuntu
    sudo apt-get update
    sudo apt-get install -y \
        gcc make \
        libssl-dev libyaml-dev libreadline-dev zlib1g-dev libffi-dev \
        libgdbm-dev libncurses-dev
else
    echo "Unsupported package manager - install Ruby build deps manually"
    exit 1
fi

echo "Ruby build dependencies installed"
