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

# this function obtained from:
# https://thevaluable.dev/practical-guide-fzf-example/
se() {
  if [ -z "$1" ]; then
    search_folder="$HOME"
  else
    search_folder="$1"
  fi

  selection=$(
    find "$search_folder" -type d | fzf \
      --preview='tree -C {}' --preview-window='50%' \
      --prompt='Dirs > ' \
      --bind='del:execute(rm -ri {+})' \
      --bind='ctrl-p:toggle-preview' \
      --bind='ctrl-d:change-prompt(Dirs > )' \
      --bind="ctrl-d:+reload(find $search_folder -type d)" \
      --bind='ctrl-d:+change-preview(tree -C {})' \
      --bind='ctrl-d:+refresh-preview' \
      --bind='ctrl-f:change-prompt(Files > )' \
      --bind="ctrl-f:+reload(find $search_folder -type f)" \
      --bind='ctrl-f:+change-preview(batcat --color=always {})' \
      --bind='ctrl-f:+refresh-preview' \
      --bind='ctrl-a:select-all' \
      --bind='ctrl-x:deselect-all' \
      --color header:italic \
      --header '
CTRL-D to display directories
CTRL-F to display files
CTRL-A/CTRL-X to select/deselect all
ENTER to edit | DEL to delete
CTRL-P to toggle preview

'
  )

  if [ -d "$selection" ]; then
    cd "$selection" || return
  elif [ -f "$selection" ]; then
    # Change to the directory containing the file
    cd "$(dirname "$selection")" || return
  fi
  # alternatively edit selection via EDITOR
  # else
  #     eval "$EDITOR $selection"
  # fi
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
