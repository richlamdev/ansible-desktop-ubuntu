.PHONY: up inventory ping bootstrap

VAGRANT_DIR ?= ../vagrant-ubuntu
INVENTORY=$(VAGRANT_DIR)/vagrant-inventory.ini
PLAYBOOK=main.yml

# Optional arguments for ansible commands (default empty)
ARGS ?=

# Bootstrap target: bring VM up, generate inventory, test connectivity
bootstrap: ping

# Ping test: ensure Ansible can reach VM
ping: inventory
	ansible -i $(INVENTORY) vagrant -m ping $(ARGS)

# Generate inventory file based on current Vagrant VM
inventory: up
	cd $(VAGRANT_DIR) && ./bootstrap.sh

# Start the VM using Vagrant
up:
	cd $(VAGRANT_DIR) && vagrant up

# Run Ansible playbook with optional args
# Example: make apply ARGS="--tags=webserver"
apply:
	#ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ARGS)
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ARGS)

destroy:
	cd $(VAGRANT_DIR) && vagrant destroy -f

ssh:
	cd $(VAGRANT_DIR) && vagrant ssh

status:
	cd $(VAGRANT_DIR) && vagrant status
