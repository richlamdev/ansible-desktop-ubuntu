#!/bin/bash
# macOS-compatible: use sed instead of grep -Po
# alternatively use brew to install and manage fzf
set -e

# --- Optional colours ---
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

# --- Get current fzf version ---
echo -e "${CYAN}Current fzf version:${NC}"
CURRENT_VERSION=""
if command -v fzf >/dev/null 2>&1; then
  CURRENT_VERSION_FULL=$(fzf --version)
  echo "$CURRENT_VERSION_FULL"
  # Extract version number (e.g., "0.56.3 (brew)" -> "0.56.3")
  CURRENT_VERSION=$(echo "$CURRENT_VERSION_FULL" | sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
else
  echo -e "${YELLOW}fzf not currently installed.${NC}"
fi
echo

# --- Fetch latest release via GitHub API ---
echo -e "${GREEN}Fetching latest fzf release...${NC}"
API_URL="https://api.github.com/repos/junegunn/fzf/releases/latest"

if command -v jq >/dev/null 2>&1; then
  # Use jq if available
  RELEASE_DATA=$(curl -Ls "$API_URL")
  LATEST_VERSION=$(echo "$RELEASE_DATA" | jq -r '.tag_name' | sed 's/^v//')
else
  # Fallback: parse JSON with sed (macOS-compatible)
  RELEASE_DATA=$(curl -Ls "$API_URL")
  LATEST_VERSION=$(echo "$RELEASE_DATA" | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v\{0,1\}\([^"]*\)".*/\1/p' | head -n 1)
fi

if [ -z "$LATEST_VERSION" ]; then
  echo -e "${RED}Failed to fetch latest fzf version.${NC}"
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
  echo -e "${GREEN}Installing fzf ${LATEST_VERSION}...${NC}"
fi
echo

# --- Install/Upgrade fzf ---
INSTALL_DIR="$HOME/.fzf"

# Remove existing installation if it exists
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}Removing existing fzf installation...${NC}"
  rm -rf "$INSTALL_DIR"
fi

# Clone the fzf repository (checking out specific version tag)
echo -e "${GREEN}Cloning fzf ${LATEST_VERSION} from GitHub...${NC}"
git clone --depth 1 --branch "v${LATEST_VERSION}" https://github.com/junegunn/fzf.git "$INSTALL_DIR"

# Run the installation script
echo -e "${GREEN}Running fzf installation script...${NC}"
"$INSTALL_DIR/install" --key-bindings --completion --no-update-rc

# --- Verify ---
echo
echo -e "${MAGENTA}fzf upgraded successfully!${NC}"
echo
echo -e "${CYAN}New fzf version:${NC}"
fzf --version
echo
