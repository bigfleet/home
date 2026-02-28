#!/bin/bash

# Install system dependencies required to compile Ruby and Python via asdf
# Covers: C toolchain, OpenSSL, libyaml, readline, zlib, libffi,
#         bzip2, sqlite, lzma (for Python)

echo "Installing language build dependencies..."

if command -v dnf &> /dev/null; then
    # Fedora / RHEL / CentOS
    sudo dnf install -y --skip-unavailable \
        gcc make \
        openssl-devel libyaml-devel readline-devel zlib-devel libffi-devel \
        gdbm-devel ncurses-devel \
        bzip2-devel sqlite-devel xz-devel tk-devel
elif command -v apt-get &> /dev/null; then
    # Debian / Ubuntu
    sudo apt-get update
    sudo apt-get install -y \
        gcc make \
        libssl-dev libyaml-dev libreadline-dev zlib1g-dev libffi-dev \
        libgdbm-dev libncurses-dev \
        libbz2-dev libsqlite3-dev liblzma-dev
else
    echo "Unsupported package manager - install build deps manually"
    exit 1
fi

echo "Language build dependencies installed"
