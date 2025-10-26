#!/bin/bash
set -e

if [ -f ./colours.sh ]; then
  source ./colours.sh
else
  CYAN="\033[0;36m"
  GREEN="\033[0;32m"
  YELLOW="\033[1;33m"
  MAGENTA="\033[0;35m"
  RED="\033[0;31m"
  NC="\033[0m"
fi

# --- Get current Neovim version ---
echo -e "${CYAN}Current Neovim version:${NC}"
CURRENT_VERSION=""
if command -v nvim >/dev/null 2>&1; then
  CURRENT_VERSION_FULL=$(nvim --version | head -n 1)
  echo "$CURRENT_VERSION_FULL"
  # Extract version number (e.g., "NVIM v0.11.4" -> "v0.11.4")
  CURRENT_VERSION=$(echo "$CURRENT_VERSION_FULL" | grep -Po 'v[0-9]+\.[0-9]+\.[0-9]+')
else
  echo -e "${YELLOW}Neovim not currently installed.${NC}"
fi
echo

# --- Fetch latest stable release via GitHub API ---
echo -e "${GREEN}Fetching latest stable Neovim release...${NC}"

API_URL="https://api.github.com/repos/neovim/neovim/releases/latest"

if command -v jq >/dev/null 2>&1; then
  # Use jq if available
  RELEASE_DATA=$(curl -Ls "$API_URL")
  LATEST_VERSION=$(echo "$RELEASE_DATA" | jq -r '.tag_name')
  LATEST_URL=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name == "nvim-linux-x86_64.appimage") | .browser_download_url')
else
  # Fallback: parse JSON with grep/sed
  RELEASE_DATA=$(curl -Ls "$API_URL")
  LATEST_VERSION=$(echo "$RELEASE_DATA" | grep -Po '"tag_name":\s*"\K[^"]+')
  LATEST_URL=$(echo "$RELEASE_DATA" | grep -Po '"browser_download_url":\s*"\K[^"]+' | grep 'nvim-linux-x86_64\.appimage$' | head -n 1)
fi

if [ -z "$LATEST_URL" ]; then
  echo -e "${RED}Failed to find nvim-linux-x86_64.appimage URL.${NC}"
  exit 1
fi

echo -e "${CYAN}Latest stable version:${NC} ${LATEST_VERSION}"
echo

# --- Compare versions ---
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo -e "${GREEN}You already have the latest version (${LATEST_VERSION}) installed!${NC}"
  echo -e "${YELLOW}No update needed.${NC}"
  exit 0
fi

if [ -n "$CURRENT_VERSION" ]; then
  echo -e "${YELLOW}Version mismatch detected: ${CURRENT_VERSION} -> ${LATEST_VERSION}${NC}"
  echo -e "${GREEN}Proceeding with upgrade...${NC}"
else
  echo -e "${GREEN}Installing Neovim ${LATEST_VERSION}...${NC}"
fi
echo

# --- Download AppImage ---
TMP_FILE=$(mktemp)
echo -e "${GREEN}Downloading Neovim AppImage...${NC}"
curl -L "$LATEST_URL" -o "$TMP_FILE"

# --- Prepare install path ---
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# --- Move and set permissions ---
echo -e "${GREEN}Installing to ${INSTALL_DIR}/nvim...${NC}"
mv "$TMP_FILE" "$INSTALL_DIR/nvim"
chmod +x "$INSTALL_DIR/nvim"

# --- Verify ---
echo
echo -e "${MAGENTA}Neovim upgraded successfully!${NC}"
echo
echo -e "${CYAN}New Neovim version:${NC}"
"$INSTALL_DIR/nvim" --version | head -n 1
echo
