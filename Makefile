.PHONY: up inventory ping bootstrap apply destroy ssh status help

VAGRANT_DIR ?= ../vagrant-ubuntu
INVENTORY=$(VAGRANT_DIR)/vagrant-inventory.ini
PLAYBOOK=main.yml
# Optional arguments for ansible commands (default empty)
ARGS ?=

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  %-15s %s\n", $$1, $$2}'

bootstrap: ping ## Bring VM up, generate inventory, test connectivity

ping: inventory ## Ping test: ensure Ansible can reach VM
	ansible -i $(INVENTORY) vagrant -m ping $(ARGS)

inventory: up ## Generate inventory file from current Vagrant VM
	cd $(VAGRANT_DIR) && ./bootstrap.sh

up: ## Start the VM using Vagrant
	cd $(VAGRANT_DIR) && vagrant up

apply: ## Run Ansible playbook (e.g. make apply ARGS="--tags=test-vars")
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) $(ARGS)

destroy: ## Destroy the Vagrant VM
	cd $(VAGRANT_DIR) && vagrant destroy -f

ssh: ## SSH into the Vagrant VM
	cd $(VAGRANT_DIR) && vagrant ssh

status: ## Show Vagrant VM status
	cd $(VAGRANT_DIR) && vagrant status
