# Ansible Playbook for configuring Ubuntu Desktop

## Introduction

This is a collection of roles I use for my Ubuntu desktop deployment.


## Requirements

1) Basic knowledge of Ansible.

2) Ubuntu (or alternative apt based Linux Distro would likely work, may require
minor changes)

3) ansible\
```pip3 install ansible```

4) jinja2 template\
```pip3 install jinja2```


## Quick Start

*This assumes a brand new installation and the execution of this Playbook is
is on the target machine.  In other words, the deployment server and client are
the same system.  Of course, this playbook can be run from a remote server, if
preferred.  This also assume the user indicated below by <username> is the has
sudo privilege.*

1.```sudo apt update && sudo apt install git sshpass openssh-server -y```

** *Limit use of sshpass for early setup only, due to potential security issues.
Deploy ssh keys to target host(s) after this playbook has executed successfully.* **

2.```git clone https://github.com/richlamdev/ansible-desktop-ubuntu.git```

3.```cd ansible-desktop-ubuntu```

4. Amend inventory file if needed, default target is localhost.

5. Amend main.yml file for roles of software desired.

* Many of the third party packages are broken into separate roles, this was
setup this way to allow convenient inclusion/exclusion of roles as needed by
commenting/uncommenting roles in main.yml at the root level of the repo.

6. To run the playbook against target host(s) use the following command:

```ansible-playbook main.yml -bkKu <username>```
  * enter SSH password
  * enter SUDO password. (assumes user is a member of the sudo user group)
  After ssh key(s) are deployed to target hosts, amend the execution command
  to:

```ansible-playbook main.yml -bKu <username> --private-key <ssh-key>```

7. Where privilege escalation is not required, the packages or configuration is
installed on the target host(s) in the context of <username> indicated via the
above command.

Note: Be aware the /role/base/tasks/authentical.yml updates the
/etc/ssh/sshd_config that enables SSH password authentication; consequently,
making the ssh key access requirement moot.


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
