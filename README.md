# Ansible Playbook for configuring Ubuntu Desktop

## Introduction

This is a collection of roles and configuarions I use for my Ubuntu
desktop/laptop deployment.


## Requirements

1) Basic knowledge of Ansible

2) Ubuntu (other apt based Linux Distro may work, may require minor changes)

3) ansible\
`pip3 install ansible`

4) jinja2 template\
`pip3 install jinja2`


## Instructions

*This assumes a new/fresh installation and the execution of this playbook
is on the target machine (localhost).  Of course, this playbook can be executed
to a remote host, if needed.  This also assumes the user indicated
below by \<username\> belongs to the sudo group.*

1. Install required software for this playbook.\
`sudo apt update && sudo apt install ansible git openssh-server -y`

2. Clone ansible-desktop-ubuntu repo.\
`git clone https://github.com/richlamdev/ansible-desktop-ubuntu.git`

3. Generate SSH key pair for localhost.\
`cd ansible-desktop-ubuntu/scripts`

The following script will generate a new SSH key pair for localhost and copy
the public key to ~/.ssh/authorized_keys.  This will allow authentication
via SSH key.\
`./gen_ssh_keys.sh`

Alternatively, if password authentication is preferred, install sshpass.\
`sudo apt install sshpass`

** *Limit use of sshpass for setup only, due to potential security issues. * **

Note: Be aware the /role/base/tasks/authentication.yml will update the
/etc/ssh/sshd_config, which will disable SSH password authentication; consequently,
making SSH key authentication required.

4. Amend inventory file if needed, default target is localhost.

5. Amend main.yml file for roles (software) desired.

* The majority of third party packages are separated into roles, this was
setup this way to allow convenient inclusion/exclusion of roles as needed by
commenting/uncommenting roles in main.yml at the root level of the repo.

6. To run the playbook use the following command:\
`ansible-playbook main.yml -bKu <username> --private-key ~/.ssh/<ssh-key>`
  * enter SUDO password. (assumes user is a member of the sudo user group)

To run the playbook using SSH password authentication, use the following
command:\
`ansible-playbook main.yml -bkKu <username>`
  * enter SSH password
  * enter SUDO password. (assumes user is a member of the sudo user group)

7. Where privilege escalation is not required, the packages or configuration is
installed on the target host(s) in the context of \<username\> indicated.


## Role Information

The majority of roles are self explantory in terms of what they install.

Additional information for the following roles:

* base
  * packages.yml - contains a list of packages to install via apt
  * keychron.yml - enables keychron keyboard shortcuts
  * autostart.yml - enables autostart of applications
  * authentication.yml - configures ssh server and client.
                         disables password authentication
  * .bashrc - custom fzf functions
    * sd - switch directory via fzf
    * sv - vim edit file via fzf
    * se - fzf file explorer

* disable-local-dns
  * disables local dns on the target host
    (again this is a personal preference, as my network DNS server handles
    DNS lookup and filtering)

* env
  * setups personal preferences for bash shell
  * installs fzf via git (to upgrade remove ~/.fzf folder and re-run ansible)

* ufw
  * disables incoming ports, except port 22 (limit inbound connections port 22)

* vim
  * installs customization only, does not install vim
    * compile and install vim with this [script](https://github.com/richlamdev/vim-compile)
  * installs codium
  * installs vim-commentary
  * installs fzf.vim
  * installs indentLine
  * installs monokai
  * installs vimwiki
  * installs personal .vimrc


## Idempotency

The majority of this playbook is idempotent.  Minimal use of Ansible shell or
command is used.

However, the idempotency checks are not perfect, not all software upgrades
are handled automatically.  To upgrade fzf (command line), remove the ~/.fzf
folder and re-run ansible.   Likewise for vim plugins.  Locate the folders for
any vim plugins that require an upgrade, remove them, and re-run ansible.


## Scripts

1. gen_ssh_keys.sh - generates a new SSH key pair for localhost and copies
the public key to ~/.ssh/authorized_keys.

2. desktop-setup.sh - restore dconf settings.  (instructions within this file
to save dconf settings)

3. check_ssh_auth.sh - checks for SSH authentication methods against a host


## Random Notes, General Information & Considerations

1. For further information regarding command line switches and arguments above,
please see the [Ansible documentation](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html),
alternatively read my [ansible-misc github repo](https://github.com/richlamdev/ansible-misc.git)

2. Review the base role for potential unwanted software installation/
configuration.  The majority of the software within the base role is software
available via the default apt repositories.  Other software are some git repos,
keychron keyboard setup, and screen blanking short-cut key enablement.
Furthermore the roles env and vim are personal preferences.

3. Proper GPG keys are added to /usr/share/keyrings/ folder, and referenced
within repos, per deprecation of apt-key as of Ubuntu 22.04.

4. The organization of this ansible repo has become a little messier than
preferred.  TODO: Clean it up to be more organized / readable / reusable.
