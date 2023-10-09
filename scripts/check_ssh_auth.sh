#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <hostname-or-ip>"
  exit 1
fi

# Extract the server from the first argument
server="$1"

# Execute the SSH command to check supported authentication methods
ssh -o PreferredAuthentications=none -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "nonexistent-username@$server"
