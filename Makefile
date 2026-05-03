.PHONY: up inventory ping bootstrap apply destroy ssh status info help

VAGRANT_DIR ?= ../vagrant-ubuntu
INVENTORY    = $(VAGRANT_DIR)/vagrant-inventory.ini
PLAYBOOK     = main.yml
ARGS        ?=

# ── helpers ────────────────────────────────────────────────────────────────────
define show_info
	@echo ""
	@echo "=== VM Info ==="
	@cd $(VAGRANT_DIR) && vagrant status default 2>/dev/null \
		| awk '/default/{printf "  State:       %s %s\n", $$2, $$3}'
	@cd $(VAGRANT_DIR) && virsh list --all 2>/dev/null \
		| awk 'NR>2 && /running|shut off/{printf "  Domain:      %s (%s %s)\n", $$2, $$3, $$4}' \
		|| echo "  Domain:      (virsh unavailable)"
	@grep -oP 'ansible_host=\K[^ ]+' $(INVENTORY) 2>/dev/null \
		| xargs -I{} echo "  IP:          {}" \
		|| echo "  IP:          (inventory not found)"
	@IP=$$(grep -oP 'ansible_host=\K[^ ]+' $(INVENTORY) 2>/dev/null); \
	KEY=$$(grep -oP 'ansible_ssh_private_key_file=\K[^ ]+' $(INVENTORY) 2>/dev/null); \
	if [ -n "$$IP" ] && [ -f "$$KEY" ]; then \
		ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no \
			-o BatchMode=yes \
			-i "$$KEY" vagrant@$$IP true 2>/dev/null \
		&& echo "  SSH:         reachable" \
		|| echo "  SSH:         unreachable"; \
	else \
		echo "  SSH:         (no IP or key not found)"; \
	fi
	@echo ""
endef

# ── targets ────────────────────────────────────────────────────────────────────
help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
		| awk -F ':.*## ' '{printf "  %-15s %s\n", $$1, $$2}'

info: ## Show VM state, IP, domain, and SSH reachability
	$(call show_info)

status: ## Show Vagrant VM status + VM info
	@cd $(VAGRANT_DIR) && vagrant status
	$(call show_info)

bootstrap: ping ## Bring VM up, generate inventory, test connectivity
	$(call show_info)

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
