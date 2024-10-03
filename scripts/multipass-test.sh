#!/bin/bash

IMAGE="noble"
NAME="test-vm"

echo "Start a multipass instance, 2 CPU, 4GB Ram, 50GB Disk, Noble Image (Ubuntu 24.04 LTS)."
echo
multipass launch "$IMAGE" --name "$NAME" --cpus 2 --memory 4G --disk 50G

IP_ADDRESS=$(multipass info "$NAME" | grep IPv4 | awk '{print $2}')

echo
echo "Copying multipass ssh key to home folder and changing ownership/permissions."
echo

sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa "$HOME/id_rsa"
sudo chown "$USER":"$(id -gn)" "$HOME/id_rsa"
chmod 400 "$HOME/id_rsa"

cd ..

#ansible-playbook --inventory "$IP_ADDRESS," main.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu"
ansible-playbook --inventory "$IP_ADDRESS," test.yml --become-user root --user ubuntu --private-key ~/id_rsa --extra-vars "ansible_become_pass=ubuntu"

echo
echo "Clean up ssh key from home folder."
echo
sudo rm "$HOME/id_rsa"

echo "Delete the instance with the following commands, when ready:"
echo "multipass delete $NAME"
echo "multipass purge"

exit 0
