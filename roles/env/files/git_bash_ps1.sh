Color_Off='\[\033[0m\]'
Blue027='\[\033[01;38;5;027m\]'
IPurple='\[\033[0;95m\]'
IGreen='\[\033[0;92m\]'
BWhite='\[\033[1;37m\]'
BGreen='\[\033[1;32m\]'
BIRed='\[\033[1;91m\]'
IYellow='\[\033[0;93m\]'

# Detect which terminal this is (once per shell, not on every prompt)
__term_name=""
case "$TERM" in
  xterm-ghostty) __term_name=Ghostty ;;
  alacritty*) __term_name=Alacritty ;;
  *)
    if [[ -n $PTYXIS_VERSION ]]; then
      __term_name=Ptyxis
    elif [[ -n $ALACRITTY_WINDOW_ID ]]; then
      __term_name=Alacritty
    fi
    ;;
esac
__title_gap=$'\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0'

__build_ps1() {
  local git_part=""

  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local head_rev branch
    head_rev=$(git log --pretty=%h -n 1 2>/dev/null || echo "no-commits")
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")

    if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
      git_part="${BWhite}|${head_rev}|${BGreen}(${branch})${BWhite}|${IYellow}\w${Color_Off}"
    else
      git_part="${BWhite}|${head_rev}|${BIRed}{${branch}}${BWhite}|${IYellow}\w${Color_Off}"
    fi
  else
    git_part="${IYellow}\w${Color_Off}"
  fi

  # Window title: "<Terminal>" + gap + cwd
  local title=""
  [[ -n $__term_name ]] && title='\[\033]0;'"${__term_name}${__title_gap}"'\w\007\]'

  PS1="${title}${Blue027}\u${IPurple}@${IGreen}\h${Color_Off}${git_part} \$ "
}

# Add the hook once, so re-sourcing (bload) doesn't stack it
case ";$PROMPT_COMMAND;" in
  *";__build_ps1;"* | *";__build_ps1 "*) ;;
  *) PROMPT_COMMAND="__build_ps1${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
esac
