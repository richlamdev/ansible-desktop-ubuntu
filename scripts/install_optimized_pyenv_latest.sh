#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 <python_major.minor_version>"
  echo "Example: $0 3.13"
  exit 1
}

# Check if argument is provided
if [ $# -ne 1 ]; then
  usage
fi

PYTHON_MAJOR_MINOR="$1"

# Validate version format (basic check)
if ! [[ $PYTHON_MAJOR_MINOR =~ ^[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format: '$PYTHON_MAJOR_MINOR'"
  usage
fi

# Fetch latest available version for the specified major.minor
latest_available=$(pyenv install --list | grep -E "^\s*${PYTHON_MAJOR_MINOR}\.[0-9]+$" | tr -d ' ' | sort -V | tail -1)

if [ -z "$latest_available" ]; then
  echo "Error: No available Python versions found for ${PYTHON_MAJOR_MINOR}.*"
  exit 1
fi

echo "Latest available Python ${PYTHON_MAJOR_MINOR}.x version: $latest_available"

OPT_FLAGS="--enable-optimizations --with-lto"
CFLAGS="-march=native -mtune=native"
MAKEFLAGS="-j10"

echo "Building Python $latest_available with:"
echo "  PYTHON_CONFIGURE_OPTS=\"$OPT_FLAGS\""
echo "  CFLAGS=\"$CFLAGS\""
echo "  MAKEFLAGS=\"$MAKEFLAGS\""

if pyenv versions --bare | grep -E -q "^${latest_available}\$"; then
  echo "Python $latest_available is already installed. Skipping installation."
else
  echo "Installing Python $latest_available with optimizations..."
  env \
    PYTHON_CONFIGURE_OPTS="$OPT_FLAGS" \
    CFLAGS="$CFLAGS" \
    MAKEFLAGS="$MAKEFLAGS" \
    pyenv install "$latest_available"
  echo "Installation complete."
fi

# Set global python version
echo "Setting global Python version to $latest_available"
pyenv global "$latest_available"

echo "✅ Global Python version now: $(pyenv global)"
