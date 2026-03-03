# fzf configuration

#export FZF_DEFAULT_COMMAND='rg --files --ignore-vcs --smart-case --hidden'
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 80%
  --layout reverse
  --multi
  --border
  --highlight-line --color gutter:-1,selected-bg:238,selected-fg:146,current-fg:189"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'batcat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-P to toggle preview window to view full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-p:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
  --color header:italic
  --header '
Press CTRL-P: toggle preview
Press CTRL-Y to copy command into clipboard
'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {} | head -200'"

export EDITOR=vim

# original function obtained from:
# https://thevaluable.dev/practical-guide-fzf-example/
se() {
  local search_folder="${1:-$HOME}"

  # Common folders to exclude from traversal
  local exclude_args=(
    --exclude .cache
    --exclude .config
    --exclude .local
    --exclude .codeium
    --exclude .git
    --exclude .vscode
    --exclude .npm
    --exclude .cargo
    --exclude .rustup
    --exclude .mozilla
    --exclude .snap
  )

  # Base fdfind command (Ubuntu packages fd as fdfind)
  local fd_base="fdfind --hidden --no-ignore ${exclude_args[*]} . '$search_folder'"

  selection=$(
    eval "$fd_base --type d" | fzf \
      --preview='command -v tree >/dev/null && tree -C {} || ls -la {}' \
      --preview-window='50%' \
      --prompt='Dirs > ' \
      --bind='del:execute(rm -ri {+})' \
      --bind='ctrl-p:toggle-preview' \
      --bind='ctrl-d:change-prompt(Dirs > )' \
      --bind="ctrl-d:+reload($fd_base --type d)" \
      --bind='ctrl-d:+change-preview(command -v tree >/dev/null && tree -C {} || ls -la {})' \
      --bind='ctrl-d:+refresh-preview' \
      --bind='ctrl-f:change-prompt(Files > )' \
      --bind="ctrl-f:+reload($fd_base --type f)" \
      --bind='ctrl-f:+change-preview(command -v batcat >/dev/null && batcat --color=always {} || cat {})' \
      --bind='ctrl-f:+refresh-preview' \
      --bind='ctrl-a:select-all' \
      --bind='ctrl-x:deselect-all' \
      --color header:italic \
      --header '
CTRL-D to display directories
CTRL-F to display files
CTRL-A/CTRL-X to select/deselect all
ENTER to navigate | DEL to delete
CTRL-P to toggle preview
'
  )

  if [ -d "$selection" ]; then
    cd "$selection" || return
  elif [ -f "$selection" ]; then
    cd "$(dirname "$selection")" || return
  elif [ -n "$selection" ]; then
    ${EDITOR:-vim} "$selection"
  fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
