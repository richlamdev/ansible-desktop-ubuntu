#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(basename "$(dirname "$SCRIPT_DIR")")"

echo
echo "Copying multipass ssh key to home folder and changing ownership/permissions."
echo

sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa "$HOME/id_rsa"
sudo chown "$USER":"$USER" "$HOME/id_rsa"
chmod 400 "$HOME/id_rsa"

echo
echo "Ensure [multipass] section, in "$PARENT_DIR/inventory" file is updated to match ip address of multipass machine."
echo
echo "Pausing here to ensure inventory file is updated first."
echo "Press any key to continue..."
read -n 1 -s

cd ..

ansible-playbook main.yml --become-user root --user ubuntu --limit multipass --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu"

echo
echo "Clean up ssh key from home folder."
echo
sudo rm "$HOME/id_rsa"

exit 0
