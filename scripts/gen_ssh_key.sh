#!/bin/bash

# Set HOSTNAME to the hostname without domain
USER=$(whoami)
HOSTNAME=$(hostname -s)
KEY_TYPE="ed25519"
DATE=$(date +"%Y%m%d")

# Generate the SSH key pair with the specified filename and passphrase prompt
KEY_NAME="${HOSTNAME}_${DATE}_${KEY_TYPE}_key"
ssh-keygen -t "$KEY_TYPE" -f "$HOME/.ssh/$KEY_NAME" -N "$(read -s -p 'Enter passphrase for the key: '; echo $REPLY)"

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
echo "SSH key pair generated and public key copied to authorized_keys (overwriting existing keys)."
echo "Private key: $HOME/.ssh/$KEY_NAME"
echo "Public key: $HOME/.ssh/$KEY_NAME.pub"
echo

# Test the key
echo "Testing the key with the passphrase..."
echo "** DO NOT FORGET TO EXIT THIS SESSION! ***"
echo
if ssh -i "$HOME/.ssh/$KEY_NAME" $USER@localhost; then
  echo "Key test successful. You can use the key for SSH authentication."
else
  echo "Key test failed. Please double-check the passphrase and try again."
fi

exit 0
