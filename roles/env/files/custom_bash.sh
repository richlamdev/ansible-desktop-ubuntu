HISTSIZE=100000
HISTFILESIZE=100000
HISTFILE=/home/$USER/.bash_history
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:pwd:cd *:export AWS_*"

# cbc/cbp=cliboard; similar to pbcopy/pbpaste on MacOS
alias cbc='xclip -sel clip'
alias cbp='xclip -sel clip -o'
alias dateu='echo -e "\n\e[32m$(date)\e[0m\n\e[33m$(date -u)\e[0m\n"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias ipa='ip -4 a | awk '\''BEGIN {print ""} /^[0-9]+:/ {iface=$2; sub(":", "", iface); print "\033[1;33m" iface "\033[0m"} /inet / {split($2, ip, "/"); printf "  \033[1;36m%-15s\033[0m\n", ip[1]} END {print ""}'\'
alias update='sudo apt update && sudo apt dist-upgrade -y && sudo snap refresh && sudo apt autoremove -y && sudo apt clean'
alias g='git'

# google search from the command line
google() {
  xdg-open "https://www.google.com/search?q=$*" >/dev/null 2>&1 &
}

acg() {
  . ~/.local/bin/$USER/sandbox-creds.sh
}

acg-clear() {
  . ~/.local/bin/$USER/sandbox-creds-delete.sh
}

# minikube autocomplete
#source <(minikube completion bash)

# kubectl autocomplete
source <(kubectl completion bash)
alias k='kubectl'
complete -o default -F __start_kubectl k

# aws autocomplete
complete -C '/usr/local/bin/aws_completer' aws

# terraform autocomplete
complete -C /usr/bin/terraform terraform

# vagrant command completion (start)
# . /opt/vagrant/embedded/gems/gems/vagrant-2.4.6/contrib/bash/completion.sh
VAGRANT_COMPLETION=$(find /opt/vagrant/embedded/gems/gems/ -type f -path "*/vagrant-*/contrib/bash/completion.sh" | sort -V | tail -n 1)

if [ -f "$VAGRANT_COMPLETION" ]; then
  . "$VAGRANT_COMPLETION"
fi

# pipx autocomplete
eval "$(register-python-argcomplete pipx)"
