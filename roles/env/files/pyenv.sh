   # pyenv
   export PYENV_ROOT="$HOME/.pyenv"
   if [[ -d $PYENV_ROOT/bin ]]; then
     case ":$PATH:" in
       *":$PYENV_ROOT/bin:"*) ;;
       *) export PATH="$PYENV_ROOT/bin:$PATH" ;;
     esac
   fi
   command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - bash)"
