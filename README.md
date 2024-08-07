# Ansible Playbook for configuring Ubuntu Desktop

## Introduction

This is a collection of roles and configuarions I use for my Ubuntu
desktop/laptop deployment.

This Playbook is designed and tested for Ubunutu 24.04 LTS.  This playbook may
not work on older versions of Ubuntu without modification.


## Requirements

1) Basic knowledge of Ansible

2) Ubuntu 24.04 (other apt based Linux Distros may work, may require minor changes)

3) Software: ansible, git, openssh-server, vim-gtk3 (vim or vim-gtk3 is not
strictly required, but is required if the vim role is executed)


## Instructions

*This assumes a new/fresh installation and the execution of this playbook
is on the target machine (localhost).  Of course, this playbook can be executed
to a remote host, if needed.  This also assumes the user indicated
below by \<username\> belongs to the sudo group.  Additionally, this assumes
the user's primary group on the host and target machine(s) are the same.*

1. Install required software for this playbook.\
`sudo apt update && sudo apt install ansible git openssh-server vim-gtk3 -y`

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
/etc/ssh/sshd_config, which will disable SSH password authentication;
consequently, making SSH key authentication required.

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

* auto-update
  * force dpkg to accept default settings during updates
  * add cron to run apt update and dist-upgrade daily
  * add cron to run snap update daily
  * technically there are built-in methods to run apt and snap update daily
    (unattended-upgrades), however, none of those methods seem to work.
    This primitive implementation achieves a similar effect.
  * This role is for any desktop/laptop that requires operating 24/7.

* aws-cli
  * installs AWS CLI v2 via zip archive from aws
  * to update aws cli remove the following and rerun the aws-cli role
    * rm /usr/local/bin/aws
    * rm -rf /usr/local/aws-cli
  * alternatively execute the `scripts/upgrade_aws.sh` script

* base
  * packages.yml - contains a list of packages to install via apt
  * keychron.yml - enables keychron keyboard shortcuts
  * autostart.yml - enables autostart of applications
  * authentication.yml - configures ssh server and client.
                         disables password authentication

* disable-local-dns
  * disables local dns on the target host
    (again this is a personal preference, as my network DNS server handles
    DNS lookup and filtering)
  * this role is executed last, as a dns service restart is required; the
    restart will take too long and cause the following playbook role(s) to fail
    (a delay could be added, but that adds unnecessary time to the playbook)

* docker
  * installs docker-ce-cli (required for Docker Desktop)
  * creates docker group and adds the current user to it
  * install [docker-desktop](https://docs.docker.com/desktop/install/linux-install/) for remainder of local docker setup
  * NOTE: At the time of this writing, Docker is not yet officially supported
          on Ubuntu 24.04 LTS.  Follow the instructions under the
          [prerequisites section](https://docs.docker.com/desktop/install/ubuntu/#prerequisites)

      Short version, either execute this on each reboot, before executing
      Docker Desktop
      `sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0`
      or edit (create) this file /etc/sysctl.d/99-docker.conf
      `echo "kernel.apparmor_restrict_unprivileged_userns=0" > /etc/sysctl.d/99-docker.conf`

      Apply the change immediately by executing `sudo sysctl --system` or reboot

  * The kernel.apparmor_restrict_unprivileged_userns=0 setting is now applied
    with the docker role


  * Additional references:
    * [Github Issue #209](https://github.com/docker/desktop-linux/issues/209)
    * [reddit thread](https://www.reddit.com/r/docker/comments/1c9rzxz/cannot_get_docker_desktop_to_start_on_ubuntu_2404/)
    * [restricted unprivileged user namespace](https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces)

* env
  * setups personal preferences for bash shell
  * installs fzf via git (to upgrade remove ~/.fzf folder and re-run fzf role)
    * alternatively run the `scripts/install_fzf.sh` script
  * fzf is required for [fzf.vim](https://github.com/junegunn/fzf.vim)
  * .bashrc -bash function `se` is for fast directory navigation at the CLI
    refer to [fzf explorer](https://thevaluable.dev/practical-guide-fzf-example/)
    (this is slightly different from the built in alt-c command provided with fzf)

* pipx-packages
  * using pipx where possible due to [PEP 668](https://peps.python.org/pep-0668/)
  * primarily installs pipx packages for coding/development
    * [bandit](https://github.com/PyCQA/bandit)
    * [boto3](https://github.com/boto/boto3)
    * [black](https://github.com/psf/black) (needed for VIM ALE plugin)
    * [bottle](https://github.com/pallets/bottle)
    * [flake8](https://github.com/PyCQA/flake8) (needed for VIM ALE plugin)
    * [glances](https://github.com/nicolargo/glances)
    * [pre-commit](https://github.com/pre-commit/pre-commit)
    * [pytest](https://github.com/pytest-dev/pytest)
    * [ruff](https://github.com/charliermarsh/ruff)
    * [yamllint](https://github.com/adrienverge/yamllint) (needed for VIM ALE plugin)

* ufw
  * disables incoming ports, except port 22 (limit inbound connections port 22)

* vim
  * installs customization only, does not install vim
    * compile and install vim with this [script](https://github.com/richlamdev/vim-compile)
    * Note: Vim >9.0 is required for codeium plugin below, at the time of the
    writing of this playbook, Vim 9.x was not available in the official Ubuntu
    repos

  * if codeium is not wanted, disable codeium in the status line within .vimrc
    that is deployed with this role:
    * comment out this line

    ```set statusline+=\{…\}%3{codeium#GetStatusString()}  " codeium status```

      If this is not disabled before codeium.vim is uninstalled, vim will freeze
      on startup.  (you'll have to edit .vimrc with an alternative editor,and/
      or disable loading of .vimrc then comment the above line indicated)
    * remove codeium.vim from $HOME/.vim/pack:
    ```rm -rf ~/.vim/pack/Exafunction```

  * installs following plugins:
    * [ALE](https://github.com/dense-analysis/ale)
    * [codeium](https://github.com/Exafunction/codeium.vim)
    * [fzf.vim](https://github.com/junegunn/fzf.vim)
    * ~~[Github copilot](https://github.com/github/copilot.vim)~~ (use codeium)
    * [hashivim](https://github.com/hashivim/vim-terraform)
    * [indentLine](https://github.com/Yggdroot/indentLine)
    * [monokai colorscheme](https://github.com/sickill/vim-monokai)
    * [nerdtree](https://github.com/preservim/nerdtree)
    * [tagbar](https://github.com/preservim/tagbar)
    * [vim-commentary](https://github.com/tpope/vim-commentary)
    * [vim-unimpaired](https://github.com/tpope/vim-unimpaired)
    * [vimwiki](https://github.com/vimwiki/vimwiki)
    * [yammlint](https://github.com/adrienverge/yamllint)
    * [personal/custom .vimrc](https://github.com/richlamdev/ansible-desktop-ubuntu/blob/master/roles/vim/files/.vimrc)


## Upgrading System

The to upgrade system are:

1. `sudo apt update && sudo apt upgrade -y`
2. `sudo apt autoremove -y`
3. `sudo snap refresh`

Upgrade specific packages, not upraded via apt or snap:

1. `execute scripts/upgrade_aws.sh`
2. `execute scripts/upgrade_fzf.sh`
3. Docker Desktop, if installed.  Start Docker Desktop, click "Settings", then
   "Software updates", then "Check for updates", then Download and install
   updated Docker Desktop.
   `sudo apt update && sudo apt install ./docker-desktop-<version>-<arch>.deb`


## Idempotency

The majority of this playbook is idempotent.  Minimal use of Ansible shell or
command is used.

However, the idempotency checks are not perfect, not all software upgrades
are handled automatically.  To upgrade fzf (command line), remove the ~/.fzf
folder and re-run ansible (refer to above section ## Upgrading System).
Likewise for vim plugins.  Locate the folders for
any vim plugins that require an upgrade, remove them, and re-run ansible.


## Scripts

1. gen_ssh_keys.sh - generates a new SSH key pair for localhost and copies
the public key to ~/.ssh/authorized_keys.

2. desktop-setup.sh - restore dconf settings.  (instructions within this file
to save dconf settings)

3. check_ssh_auth.sh - checks for SSH authentication methods against a host
Eg: `./check_ssh_auth.sh localhost`


## Random Notes, General Information & Considerations

1. For further information regarding command line switches and arguments above,
please see the [Ansible documentation](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html),
alternatively read my [ansible-misc github repo](https://github.com/richlamdev/ansible-misc.git)

2. Review the base role for potential unwanted software installation/
configuration.  The majority of the software within the base role is software
available via the default apt repositories.  Other software are some git repos,
keychron keyboard setup, and screen blanking short-cut key enablement.
Furthermore the roles env and vim are personal preferences.

3. Appropriate GPG keys are added to /usr/share/keyrings/ folder for third
party apt packages, and referenced within repos, per deprecation of apt-key as
of Ubuntu 22.04.

4. The organization of this ansible repo has become a little messier than
preferred.  TODO: Clean it up to be more organized / readable / reusable.
