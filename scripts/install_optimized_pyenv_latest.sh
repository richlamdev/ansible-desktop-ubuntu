#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

source ./colours.sh

usage() {
  echo -e "${YELLOW}Usage: $0 <python_major.minor_version>${NC}"
  echo -e "${CYAN}Example: $0 3.13${NC}"
  exit 1
}

# Check if argument is provided
if [ $# -ne 1 ]; then
  usage
fi

PYTHON_MAJOR_MINOR="$1"

# Validate version format (basic check)
if ! [[ $PYTHON_MAJOR_MINOR =~ ^[0-9]+\.[0-9]+$ ]]; then
  echo -e "${RED}Error: Invalid version format: '$PYTHON_MAJOR_MINOR'${NC}"
  usage
fi

# Fetch latest available version for the specified major.minor
latest_available=$(pyenv install --list | grep -E "^\s*${PYTHON_MAJOR_MINOR}\.[0-9]+$" | tr -d ' ' | sort -V | tail -1)

if [ -z "$latest_available" ]; then
  echo -e "${RED}Error: No available Python versions found for ${PYTHON_MAJOR_MINOR}.*${NC}"
  exit 1
fi

echo
echo -e "${GREEN}Latest available Python ${PYTHON_MAJOR_MINOR}.x version: $latest_available${NC}"
echo

OPT_FLAGS="--enable-optimizations --with-lto"
CFLAGS="-march=native -mtune=native"
MAKEFLAGS="-j10"

echo -e "Building Python $latest_available with:"
echo -e "  ${CYAN}PYTHON_CONFIGURE_OPTS=\"$OPT_FLAGS\"${NC}"
echo -e "  ${CYAN}CFLAGS=\"$CFLAGS\"${NC}"
echo -e "  ${CYAN}MAKEFLAGS=\"$MAKEFLAGS\"${NC}"
echo

if pyenv versions --bare | grep -E -q "^${latest_available}\$"; then
  echo -e "${YELLOW}Python $latest_available is already installed. Skipping installation.${NC}"
else
  echo -e "${CYAN}Installing Python $latest_available with optimizations...${NC}"
  env \
    PYTHON_CONFIGURE_OPTS="$OPT_FLAGS" \
    CFLAGS="$CFLAGS" \
    MAKEFLAGS="$MAKEFLAGS" \
    pyenv install "$latest_available"
  echo -e "${GREEN}Installation complete.${NC}"
fi
echo

# Set global python version
echo -e "${BLUE}Setting global Python version to $latest_available${NC}"
pyenv global "$latest_available"

echo -e "${GREEN}✅ Global Python version now: $(pyenv global)${NC}"
echo
