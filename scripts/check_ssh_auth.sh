#!/bin/bash

source ./colours.sh

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo
  echo -e "${YELLOW}Usage: $0 <hostname-or-ip>${NC}"
  echo
  exit 1
fi

# Extract the server from the first argument
server="$1"

echo
# Execute the SSH command to check supported authentication methods
ssh -o PreferredAuthentications=none -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "nonexistent-username@$server"
echo
