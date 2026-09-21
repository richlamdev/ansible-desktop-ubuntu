Color_Off='\[\033[0m\]'
Blue027='\[\033[01;38;5;027m\]'
IPurple='\[\033[0;95m\]'
IGreen='\[\033[0;92m\]'
BWhite='\[\033[1;37m\]'
BGreen='\[\033[1;32m\]'
BIRed='\[\033[1;91m\]'
Yellow226='\[\033[01;38;5;226m\]'
IYellow='\[\033[0;93m\]'

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
    git_part="${Yellow226}\w${Color_Off}"
  fi

  PS1="${Blue027}\u${IPurple}@${IGreen}\h${Color_Off}${git_part} \$ "
}

PROMPT_COMMAND=__build_ps1
