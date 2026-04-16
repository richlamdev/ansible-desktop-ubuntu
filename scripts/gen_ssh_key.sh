#!/bin/bash
# Load color definitions for output
source "$(dirname "$0")/colours.sh"

# -----------------------------------------------------------------------------
# usage
# -----------------------------------------------------------------------------
usage() {
  echo -e "${CYAN}Usage:${NC} $(basename "$0") [-h] <HOSTNAME|localhost>"
  echo
  echo "Generate an ed25519 SSH key pair."
  echo
  echo -e "${YELLOW}Arguments:${NC}"
  echo "  HOSTNAME    Target hostname for the key. Keys are stored under"
  echo "              ~/.ssh/keys/<hostname>/ for remote hosts."
  echo "  localhost   Generate a key for this machine. Keys are stored in"
  echo "              ~/.ssh/ and the public key is written to authorized_keys."
  echo
  echo -e "${YELLOW}Options:${NC}"
  echo "  -h          Show this help message and exit."
  echo
  echo -e "${YELLOW}Examples:${NC}"
  echo "  $(basename "$0") localhost       # Local mode — key for this host"
  echo "  $(basename "$0") webserver01     # Remote mode — key for webserver01"
  echo "  $(basename "$0") -h              # Show this help"
  echo
  echo -e "${YELLOW}Key placement:${NC}"
  echo "  localhost:    ~/.ssh/<hostname>_<date>_ed25519_key"
  echo "  remote host:  ~/.ssh/keys/<hostname>/<hostname>_<date>_ed25519_key"
}

# -----------------------------------------------------------------------------
# Parse flags
# -----------------------------------------------------------------------------
while getopts ":h" opt; do
  case $opt in
    h) usage; exit 0 ;;
    \?) echo -e "${RED}Unknown option: -$OPTARG${NC}"; echo; usage; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# No argument — show help
if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

# -----------------------------------------------------------------------------
# Define variables
# -----------------------------------------------------------------------------
USER=$(whoami)
DATE=$(date +"%Y%m%d")
KEY_TYPE="ed25519"

# Determine mode: explicit "localhost" triggers local mode, anything else is remote
if [[ "$1" == "localhost" ]]; then
  HOSTNAME=$(hostname -s)
  REMOTE_MODE=false
  KEY_DIR="$HOME/.ssh"
else
  HOSTNAME="$1"
  REMOTE_MODE=true
  KEY_DIR="$HOME/.ssh/keys/$HOSTNAME"
fi

KEY_NAME="${HOSTNAME}_${DATE}_${KEY_TYPE}_key"
KEY_PATH="$KEY_DIR/$KEY_NAME"
AUTH_KEYS="$HOME/.ssh/authorized_keys"

# -----------------------------------------------------------------------------
# Introductory message
# -----------------------------------------------------------------------------
echo
if [[ "$REMOTE_MODE" == true ]]; then
  echo -e "${CYAN}This script will generate an SSH key pair for remote host '${HOSTNAME}'.${NC}"
  echo -e "${YELLOW}Keys will be placed in: ${KEY_DIR}${NC}"
  echo -e "${YELLOW}NOTE: Public key will NOT be written to local authorized_keys.${NC}"
else
  echo -e "${CYAN}This script will generate an SSH key pair for this host ('${HOSTNAME}').${NC}"
fi
echo

# -----------------------------------------------------------------------------
# Ensure target .ssh directory exists
# -----------------------------------------------------------------------------
mkdir -p "$KEY_DIR"

# -----------------------------------------------------------------------------
# Prompt for passphrase and generate SSH key pair
# -----------------------------------------------------------------------------
read -s -p 'Enter passphrase for the key (leave blank for no passphrase): ' PASSPHRASE
echo
echo

# Generate the SSH key pair
ssh-keygen -t "$KEY_TYPE" -f "$KEY_PATH" -N "$PASSPHRASE"

# -----------------------------------------------------------------------------
# Set secure permissions
# -----------------------------------------------------------------------------
chmod 700 "$KEY_DIR"
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

# -----------------------------------------------------------------------------
# Local mode: copy public key to authorized_keys
# -----------------------------------------------------------------------------
if [[ "$REMOTE_MODE" == false ]]; then
  cat "$KEY_PATH.pub" > "$AUTH_KEYS"
  chmod 600 "$AUTH_KEYS"
  echo
  echo -e "${CYAN}Public key copied to ${AUTH_KEYS}.${NC}"
fi

# -----------------------------------------------------------------------------
# Output key locations
# -----------------------------------------------------------------------------
echo
echo -e "${GREEN}Private key: $KEY_PATH${NC}"
echo -e "${GREEN}Public key:  $KEY_PATH.pub${NC}"

# -----------------------------------------------------------------------------
# Remote mode: next steps
# -----------------------------------------------------------------------------
if [[ "$REMOTE_MODE" == true ]]; then
  echo
  echo -e "${CYAN}Next steps for deploying this key to '${HOSTNAME}':${NC}"
  echo
  echo -e "${YELLOW}  # Option 1 — ssh-copy-id (recommended):${NC}"
  echo -e "${YELLOW}  ssh-copy-id -i $KEY_PATH.pub <user>@${HOSTNAME}${NC}"
  echo
  echo -e "${YELLOW}  # Option 2 — manual append:${NC}"
  echo -e "${YELLOW}  cat $KEY_PATH.pub | ssh <user>@${HOSTNAME} 'cat >> ~/.ssh/authorized_keys'${NC}"
  echo
  echo -e "${CYAN}To use this key when connecting to '${HOSTNAME}', add to ~/.ssh/config:${NC}"
  echo
  echo -e "${YELLOW}  Host ${HOSTNAME}${NC}"
  echo -e "${YELLOW}    IdentityFile $KEY_PATH${NC}"
fi

# -----------------------------------------------------------------------------
# Local mode: loopback key test
# -----------------------------------------------------------------------------
if [[ "$REMOTE_MODE" == false ]]; then
  echo
  echo -e "${YELLOW}Testing the key with the passphrase...${NC}"
  echo
  if ssh -i "$KEY_PATH" "$USER@localhost" true; then
    echo
    echo -e "${GREEN}Key test successful. You can use the key for SSH authentication.${NC}"
  else
    echo
    echo -e "${RED}Key test failed. Please double-check the passphrase and try again.${NC}"
  fi
fi

echo
exit 0
