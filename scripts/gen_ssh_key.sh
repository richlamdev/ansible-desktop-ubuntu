#!/bin/bash

# Load color definitions for output
source ./colours.sh

# Introductory message
echo -e "${CYAN}This script will generate an SSH key pair for your localhost.${NC}"

# Define variables
USER=$(whoami)
HOSTNAME=$(hostname -s)
KEY_TYPE="ed25519"
DATE=$(date +"%Y%m%d")
KEY_NAME="${HOSTNAME}_${DATE}_${KEY_TYPE}_key"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
AUTH_KEYS="$HOME/.ssh/authorized_keys"

# Ensure the .ssh directory exists
mkdir -p "$HOME/.ssh"

# Prompt for passphrase and generate SSH key pair
echo
read -s -p 'Enter passphrase for the key (leave blank for no passphrase): ' PASSPHRASE
echo

# Generate an SSH key pair
ssh-keygen -t "$KEY_TYPE" -f "$KEY_PATH" -N "$PASSPHRASE"

# Copy the public key to authorized_keys, overwriting existing keys
cat "$KEY_PATH.pub" >"$AUTH_KEYS"

# Set secure permissions for .ssh directory and key files
chmod 700 "$HOME/.ssh"
chmod 600 "$KEY_PATH"
chmod 644 "$AUTH_KEYS"

# Output the location of the keys
echo
echo -e "${CYAN}SSH key pair generated and public key copied to ${AUTH_KEYS} (overwriting existing keys).${NC}"
echo -e "${GREEN}Private key: $KEY_PATH${NC}"
echo -e "${GREEN}Public key: $KEY_PATH.pub${NC}"
echo

# Test the key
echo -e "${YELLOW}Testing the key with the passphrase...${NC}"
echo

if ssh -i "$KEY_PATH" "$USER@localhost" true; then
  echo
  echo -e "${GREEN}Key test successful. You can use the key for SSH authentication.${NC}"
else
  echo
  echo -e "${RED}Key test failed. Please double-check the passphrase and try again.${NC}"
fi

exit 0
