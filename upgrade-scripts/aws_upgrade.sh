#!/bin/bash
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

# Function to get latest SAM CLI version from GitHub Releases
function get_sam_latest_version() {
  local api_url="https://api.github.com/repos/aws/aws-sam-cli/releases/latest"

  if command -v jq >/dev/null 2>&1; then
    curl -Ls "$api_url" | jq -r '.tag_name' | sed 's/^v//'
  else
    curl -Ls "$api_url" | grep -Po '"tag_name":\s*"\K[^"]+' | sed 's/^v//'
  fi
}

# Function to get latest AWS CLI v2 version from GitHub Tags
function get_aws_latest_version() {
  local api_url="https://api.github.com/repos/aws/aws-cli/tags"

  if command -v jq >/dev/null 2>&1; then
    # Filter for v2 tags only (tags starting with 2.)
    curl -Ls "$api_url" | jq -r '.[].name' | grep -E '^2\.' | head -n 1
  else
    # Fallback: parse JSON and filter for v2 tags
    curl -Ls "$api_url" | grep -Po '"name":\s*"\K[^"]+' | grep -E '^2\.' | head -n 1
  fi
}

# Function to manage AWS SAM CLI
function manage_sam_cli() {
  echo -e "${CYAN}=== AWS SAM CLI ===${NC}"

  # Get current version
  CURRENT_SAM_VERSION=""
  if command -v sam &>/dev/null; then
    CURRENT_SAM_FULL=$(sam --version 2>/dev/null)
    echo -e "${CYAN}Current version:${NC} ${CURRENT_SAM_FULL}"
    # Extract version (e.g., "SAM CLI, version 1.117.0" -> "1.117.0")
    CURRENT_SAM_VERSION=$(echo "$CURRENT_SAM_FULL" | grep -Po '[0-9]+\.[0-9]+\.[0-9]+')
  else
    echo -e "${YELLOW}AWS SAM CLI not currently installed.${NC}"
  fi

  # Get latest version from GitHub
  echo -e "${GREEN}Fetching latest SAM CLI release from github.com/aws/aws-sam-cli...${NC}"
  LATEST_SAM_VERSION=$(get_sam_latest_version)

  if [ -z "$LATEST_SAM_VERSION" ] || [ "$LATEST_SAM_VERSION" = "null" ]; then
    echo -e "${RED}Failed to fetch latest SAM CLI version.${NC}"
    return 1
  fi

  echo -e "${CYAN}Latest version:${NC} ${LATEST_SAM_VERSION}"

  # Compare versions
  if [ "$CURRENT_SAM_VERSION" = "$LATEST_SAM_VERSION" ]; then
    echo -e "${GREEN}Already up-to-date (${LATEST_SAM_VERSION})!${NC}"
    echo -e "${YELLOW}No update needed.${NC}"
    return 0
  fi

  # Update needed
  if [ -n "$CURRENT_SAM_VERSION" ]; then
    echo -e "${YELLOW}Update needed: ${CURRENT_SAM_VERSION} -> ${LATEST_SAM_VERSION}${NC}"
    UPDATE_FLAG="--update"
  else
    echo -e "${GREEN}Installing SAM CLI ${LATEST_SAM_VERSION}...${NC}"
    UPDATE_FLAG=""
  fi

  # Download and install from GitHub releases
  echo -e "${GREEN}Downloading SAM CLI from GitHub releases...${NC}"
  curl -L "https://github.com/aws/aws-sam-cli/releases/download/v${LATEST_SAM_VERSION}/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip"

  unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation

  if [ -n "$UPDATE_FLAG" ]; then
    sudo ./sam-installation/install --update
  else
    sudo ./sam-installation/install
  fi

  # Clean up
  rm -rf aws-sam-cli-linux-x86_64.zip sam-installation/

  # Verify
  echo -e "${MAGENTA}SAM CLI installation completed!${NC}"
  echo -e "${CYAN}Installed version:${NC} $(sam --version)"
}

# Function to manage AWS CLI
function manage_aws_cli() {
  echo -e "${CYAN}=== AWS CLI ===${NC}"

  # Get current version
  CURRENT_AWS_VERSION=""
  if command -v aws &>/dev/null; then
    CURRENT_AWS_FULL=$(aws --version 2>/dev/null)
    echo -e "${CYAN}Current version:${NC} ${CURRENT_AWS_FULL}"
    # Extract version (e.g., "aws-cli/2.15.17 ..." -> "2.15.17")
    CURRENT_AWS_VERSION=$(echo "$CURRENT_AWS_FULL" | grep -Po 'aws-cli/\K[0-9]+\.[0-9]+\.[0-9]+')
  else
    echo -e "${YELLOW}AWS CLI not currently installed.${NC}"
  fi

  # Get latest version from GitHub tags (v2 only)
  echo -e "${GREEN}Fetching latest AWS CLI v2 version from github.com/aws/aws-cli tags...${NC}"
  LATEST_AWS_VERSION=$(get_aws_latest_version)

  if [ -z "$LATEST_AWS_VERSION" ] || [ "$LATEST_AWS_VERSION" = "null" ]; then
    echo -e "${RED}Failed to fetch latest AWS CLI version from GitHub.${NC}"
    echo -e "${YELLOW}Proceeding with download from official AWS endpoint...${NC}"
    # If we can't get version, proceed with download anyway
  else
    echo -e "${CYAN}Latest version:${NC} ${LATEST_AWS_VERSION}"

    # Compare versions
    if [ "$CURRENT_AWS_VERSION" = "$LATEST_AWS_VERSION" ]; then
      echo -e "${GREEN}Already up-to-date (${LATEST_AWS_VERSION})!${NC}"
      echo -e "${YELLOW}No update needed.${NC}"
      return 0
    fi

    # Update needed
    if [ -n "$CURRENT_AWS_VERSION" ]; then
      echo -e "${YELLOW}Update needed: ${CURRENT_AWS_VERSION} -> ${LATEST_AWS_VERSION}${NC}"
    else
      echo -e "${GREEN}Installing AWS CLI ${LATEST_AWS_VERSION}...${NC}"
    fi
  fi

  # Determine if update or fresh install
  if [ -n "$CURRENT_AWS_VERSION" ]; then
    UPDATE_FLAG="--update"
  else
    UPDATE_FLAG=""
  fi

  # Download from official AWS endpoint
  echo -e "${GREEN}Downloading AWS CLI from official AWS endpoint...${NC}"
  curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

  unzip -q awscliv2.zip

  if [ -n "$UPDATE_FLAG" ]; then
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
  else
    sudo ./aws/install
  fi

  # Clean up
  rm -rf awscliv2.zip aws/

  # Verify
  echo -e "${MAGENTA}AWS CLI installation completed!${NC}"
  echo -e "${CYAN}Installed version:${NC} $(aws --version)"
}

# Main script execution
echo "Managing AWS CLIs..."
echo

manage_sam_cli
echo

manage_aws_cli
echo

# Uninstallation instructions
echo -e "${CYAN}=== Uninstallation Instructions ===${NC}"
echo "To uninstall AWS SAM CLI:"
echo "  sudo rm /usr/local/bin/sam"
echo "  sudo rm -rf /usr/local/aws-sam-cli"
echo
echo "To uninstall AWS CLI:"
echo "  sudo rm /usr/local/bin/aws"
echo "  sudo rm -rf /usr/local/aws-cli"
