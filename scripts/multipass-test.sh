#!/bin/bash

# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# PARENT_DIR="$(basename "$(dirname "$SCRIPT_DIR")")"

echo "Start a multipass instance, 2 CPU, 4GB Ram, 50GB Disk, Noble Image (Ubuntu 24.04 LTS)."
echo
multipass launch noble --name "test-vm" --cpus 2 --memory 4G --disk 50G

IP_ADDRESS=$(multipass info test-vm | grep IPv4 | awk '{print $2}')

echo
echo "Copying multipass ssh key to home folder and changing ownership/permissions."
echo

sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa "$HOME/id_rsa"
sudo chown "$USER":"$(id -gn)" "$HOME/id_rsa"
chmod 400 "$HOME/id_rsa"

# echo
# echo "Ensure [multipass] section, in "$PARENT_DIR/inventory" file is updated to match ip address of multipass machine."
# echo
# echo "Pausing here to ensure inventory file is updated first."
# echo "Press any key to continue..."
# read -n 1 -s

cd ..

#ansible-playbook -i "$IP_ADDRESS," main.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu"
ansible-playbook -i "$IP_ADDRESS," test.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu"

echo
echo "Clean up ssh key from home folder."
echo
sudo rm "$HOME/id_rsa"

echo "Delete the instance with the following command, when ready:"
echo "multipass delete test-vm"

exit 0
