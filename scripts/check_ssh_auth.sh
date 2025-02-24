#!/bin/bash

source ./colours.sh

echo -e "${CYAN}This script checks the supported SSH authentication methods for a given hostname or IP address.${NC}"

if [ $# -eq 0 ]; then
  echo
  echo -e "${YELLOW}Usage: $0 <hostname-or-ip>${NC}"
  echo
  exit 1
fi

HOST="$1"

echo -e "${YELLOW}Checking supported authentication methods for: $HOST...${NC}"
echo
# Execute the SSH command to check supported authentication methods
ssh -o PreferredAuthentications=none -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "nonexistent-username@$HOST"
echo

exit 0
