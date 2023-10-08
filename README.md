# Ansible Playbook for configuring Ubuntu Desktop

## Introduction

This is a collection of roles I use for my Ubuntu desktop/laptop deployment.


## Requirements

1) Basic knowledge of Ansible

2) Ubuntu (alternative apt based Linux Distro may work, will likely require
minor changes)

3) ansible\
`pip3 install ansible`

4) jinja2 template\
`pip3 install jinja2`


## Instructions

*This assumes a brand new installation and the execution of this playbook is
is the target machine (localhost).  Of course, this playbook can be run from a
remote server, if preferred.  This also assume the user indicated below by
<username> is the has sudo privilege.*

1. Install required software for this playbook.

`sudo apt update && sudo apt install git openssh-server -y`

2. Clone ansible-desktop-ubuntu repo.

`git clone https://github.com/richlamdev/ansible-desktop-ubuntu.git`

3. Generate SSH key pair for localhost.

`cd ansible-desktop-ubuntu/scripts`

The following script will generate a new SSH key pair for localhost and copy
the public key to ~/.ssh/authorized_keys.  This will allow authentication
via SSH.

`./gen_ssh_keys.sh`

Alternatively, if password authentication is preferred, install sshpass.

`sudo apt install sshpass`

** *Limit use of sshpass for setup only, due to potential security issues. * **

Note: Be aware the /role/base/tasks/authentical.yml updates the
/etc/ssh/sshd_config that disables SSH password authentication; consequently,
making the SSH key authentication required.

4. Amend inventory file if needed, default target is localhost.

5. Amend main.yml file for roles of software desired.

* The majority of third party packages are separated into roles, this was
setup this way to allow convenient inclusion/exclusion of roles as needed by
commenting/uncommenting roles in main.yml at the root level of the repo.

6. To run the playbook use the following command:

`ansible-playbook main.yml -bKu <username> --private-key ~/.ssh/<ssh-key>`
  * enter SUDO password. (assumes user is a member of the sudo user group)

If using SSH password authentication, use the following command:

`ansible-playbook main.yml -bkKu <username>`
  * enter SSH password
  * enter SUDO password. (assumes user is a member of the sudo user group)

7. Where privilege escalation is not required, the packages or configuration is
installed on the target host(s) in the context of <username> indicated.


## Notes, General Information & Considerations

1. For further information regarding command line switches and arguments above,
please see the [Ansible documentation](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html),
alternatively read my [ansible-misc github repo](https://github.com/richlamdev/ansible-misc.git)

2. Review the base role for potential unwanted software installation/
configuration.  The majority of the software within the base role is software
available via the default apt repositories.  Other software are some git repos,
keychron keyboard setup, and screen blanking short-cut key enablement.
Furthermore the roles env and vim are personal preferences.

3. The organization of this ansible repo has become a little messier than
preferred.  TODO: Clean it up to be more organized / readable / reusable.
