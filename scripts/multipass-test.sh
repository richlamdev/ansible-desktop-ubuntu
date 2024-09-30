#!/bin/bash

sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa "$HOME/id_rsa"
sudo chown "$USER":"$USER" "$HOME/id_rsa"

echo "edit inventory file, [multipass] section to match ip of multipass machine"

ansible-playbook main.yml -bKu ubuntu --limit multipass --private-key ~/id_rsa

exit 0
