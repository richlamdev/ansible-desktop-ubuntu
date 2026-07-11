# LibreWolf Ansible Role

An Ansible role to install LibreWolf, a privacy-focused Firefox-based browser, on Debian-based Linux systems (Ubuntu, Debian, Linux Mint, etc.).

## Features

- Installs the `extrepo` package manager
- Adds the official LibreWolf repository using `extrepo`
- Installs the latest LibreWolf browser
- Supports custom installation states (present, latest, absent)
- Idempotent and safe for repeated runs

## Requirements

- Ansible 2.10 or higher
- Debian-based Linux distribution (Ubuntu, Debian, Linux Mint)
- Root or sudo access on target hosts

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Desired state of LibreWolf
# Options: present (default, installed), latest (always upgrade), absent (remove)
librewolf_state: present
```

## Example Usage

### Basic Usage

Include the role in your playbook:

```yaml
---
- hosts: all
  become: yes
  roles:
    - librewolf
```

### Install Latest Version

```yaml
---
- hosts: all
  become: yes
  roles:
    - librewolf
  vars:
    librewolf_state: latest
```

### Remove LibreWolf

```yaml
---
- hosts: all
  become: yes
  roles:
    - librewolf
  vars:
    librewolf_state: absent
```

## Supported Platforms

- **Ubuntu**: 20.04 LTS, 22.04 LTS, 24.04 LTS
- **Debian**: 11, 12
- **Linux Mint**: 21, 22

## What This Role Does

1. Updates the apt package cache
2. Installs the `extrepo` repository manager
3. Enables the LibreWolf repository via extrepo
4. Updates the LibreWolf repository
5. Refreshes the apt cache
6. Installs the LibreWolf browser package

## Installation

1. Extract the zip file
2. Place the `librewolf` directory in your `roles/` directory
3. Reference it in your playbook

## Usage Example

Create a playbook (e.g., `install-librewolf.yml`):

```yaml
---
- hosts: ubuntu_servers
  become: yes
  roles:
    - librewolf
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini install-librewolf.yml
```

## Role Structure

```
librewolf/
├── defaults/
│   └── main.yml           # Default variables
├── tasks/
│   └── main.yml           # Main installation tasks
├── handlers/
│   └── main.yml           # Task handlers
├── meta/
│   └── main.yml           # Role metadata
└── README.md              # Documentation
```

## Notes

- This role requires `become: yes` to run installation commands with sudo privileges
- The role uses `extrepo` as recommended by the official LibreWolf documentation
- All tasks are idempotent and safe to run multiple times

## References

- [LibreWolf Official Website](https://librewolf.net/)
- [LibreWolf Debian Installation Guide](https://librewolf.net/installation/debian/)
- [Ansible Documentation](https://docs.ansible.com/)

## License

MIT
