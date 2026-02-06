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
alias check-apt-update='sudo apt update && apt list --upgradeable'
alias check-unattended='sudo apt update && sudo unattended-upgrade --dry-run'
alias check-snap='sudo snap refresh --list'
alias g='git'
alias bedit='cd ~/.bashrc.d && vim custom_bash.sh'
alias bload='source ~/.bashrc'

shopt -s autocd
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell

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

# Function to pretty-print CSV files
pretty_csv() {
  perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' "$@" | column -t -s, | batcat -S
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

sts() {
  local sensitive_vars="AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN"
  local has_env_creds=false

  echo ""

  # Check for credential env vars first (they override profile)
  for var in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN; do
    local value=$(eval echo \$${var})
    if [ -n "$value" ]; then
      has_env_creds=true
      echo -e "\e[31m⚠ $var: \e[90m${value:0:5}...\e[0m"
    fi
  done

  # Show other AWS env vars
  for var in $(env | grep '^AWS_' | cut -d= -f1 | sort); do
    # Skip the sensitive ones and AWS_PROFILE (we handle those separately)
    if ! echo "AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE" | grep -qw "$var"; then
      local value=$(eval echo \$${var})
      echo -e "\e[33m$var: \e[36m${value}\e[0m"
    fi
  done

  # Show profile (but warn if env creds will override it)
  if [ -n "$AWS_PROFILE" ]; then
    if [ "$has_env_creds" = true ]; then
      echo -e "\e[33mAWS_PROFILE: \e[90m$AWS_PROFILE \e[31m(overridden by env vars above)\e[0m"
    else
      echo -e "\e[33mAWS_PROFILE: \e[36m$AWS_PROFILE\e[0m"
    fi
  fi

  echo ""
  aws sts get-caller-identity
}

bshow() {
  local files=("$HOME/.bashrc")

  if [ -d "$HOME/.bashrc.d" ]; then
    while IFS= read -r -d '' file; do
      files+=("$file")
    done < <(find "$HOME/.bashrc.d" -type f -name "*.sh" -print0 2>/dev/null)
  fi

  echo -e "\e[1;36m━━━ Aliases ━━━\e[0m"
  for file in "${files[@]}"; do
    grep -H -E '^\s*alias ' "$file" 2>/dev/null | sed "s|$HOME|~|"
  done | sed 's/^\([^:]*\):\s*alias /\1: /' | sort -t: -k2 | while IFS=: read -r filepath line; do
    name="${line%%=*}"
    rest="${line#*=}"
    filename=$(basename "$filepath")
    echo -e "\e[0;32m${name}\e[0m=${rest} \e[0;90m[${filename}]\e[0m"
  done

  echo -e "\n\e[1;33m━━━ Functions ━━━\e[0m"
  for file in "${files[@]}"; do
    grep -H -E '^(function [a-zA-Z_]|^[a-zA-Z_].*\(\)\s*\{)' "$file" 2>/dev/null | sed "s|$HOME|~|"
  done | sed 's/function //; s/().*//; s/^\([^:]*\):\s*/\1: /' | sort -t: -k2 | while IFS=: read -r filepath line; do
    filename=$(basename "$filepath")
    echo -e "\e[0;32m${line}\e[0m \e[0;90m[${filename}]\e[0m"
  done
}
