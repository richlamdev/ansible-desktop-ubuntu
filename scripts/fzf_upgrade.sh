#!/bin/bash

# Set the desired version of fzf
#FZF_VERSION="0.27.2" # Change this to the desired version

# display current fzf version
echo "Current fzf version: "
fzf --version
echo

# Define the installation directory
INSTALL_DIR="$HOME/.fzf"

# Remove existing installation if it exists
if [ -d "$INSTALL_DIR" ]; then
  echo "Removing existing fzf installation..."
  rm -rf "$INSTALL_DIR"
fi

# Clone the fzf repository from GitHub
echo "Cloning fzf from GitHub..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_DIR"

# Run the installation script
echo "Running fzf installation script..."
"$INSTALL_DIR/install" --key-bindings --completion --no-update-rc

echo "fzf upgraded successfully to version $FZF_VERSION"
echo

# display current fzf version
echo "Upgraded fzf version: "
fzf --version
