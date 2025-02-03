#!/bin/bash

source ./colours.sh

# display current fzf version
echo -e "${CYAN}Current fzf version:${NC} "
fzf --version
echo

# Define the installation directory
INSTALL_DIR="$HOME/.fzf"

# Remove existing installation if it exists
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}Removing existing fzf installation...${NC}"
  rm -rf "$INSTALL_DIR"
fi

# Clone the fzf repository from GitHub
echo -e "${GREEN}Cloning fzf from GitHub...${NC}"
git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_DIR"

# Run the installation script
echo -e "${GREEN}Running fzf installation script...${NC}"
"$INSTALL_DIR/install" --key-bindings --completion --no-update-rc

echo -e "${MAGENTA}fzf upgraded successfully${NC}"
echo

# display current fzf version
echo -e "${CYAN}Upgraded fzf version:${NC} "
fzf --version
