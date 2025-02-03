#!/bin/bash

source ./colours.sh

# Set HOSTNAME to the hostname without domain
USER=$(whoami)
HOSTNAME=$(hostname -s)
KEY_TYPE="ed25519"
DATE=$(date +"%Y%m%d")

# Generate the SSH key pair with the specified filename and passphrase prompt
echo
KEY_NAME="${HOSTNAME}_${DATE}_${KEY_TYPE}_key"
ssh-keygen -t "$KEY_TYPE" -f "$HOME/.ssh/$KEY_NAME" -N "$(
  read -s -p 'Enter passphrase for the key: '
  echo $REPLY
)"

# Check if the .ssh directory exists, and create it if not
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
fi

# Copy the public key to authorized_keys, overwriting it
cp "$HOME/.ssh/$KEY_NAME.pub" "$HOME/.ssh/authorized_keys"

# Secure file permissions
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/$KEY_NAME"
chmod 644 "$HOME/.ssh/authorized_keys"

# Output the location of the private and public keys
echo
echo -e "${CYAN}SSH key pair generated and public key copied to authorized_keys (overwriting existing keys).${NC}"
echo -e "${GREEN}Private key: $HOME/.ssh/$KEY_NAME${NC}"
echo -e "${GREEN}Public key: $HOME/.ssh/$KEY_NAME.pub${NC}"
echo

# Test the key
echo -e "${YELLOW}Testing the key with the passphrase...${NC}"
echo -e "${RED}** DO NOT FORGET TO EXIT THIS SESSION! ***${NC}"
echo
if ssh -i "$HOME/.ssh/$KEY_NAME" $USER@localhost; then
  echo
  echo -e "${GREEN}Key test successful. You can use the key for SSH authentication.{NC}"
  echo
else
  echo
  echo -e "${RED}Key test failed. Please double-check the passphrase and try again.{NC}"
  echo
fi

exit 0
