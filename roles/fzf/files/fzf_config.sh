# ~/.bashrc.d/fzf_config.sh
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
# CTRL-Y to copy the command into the clipboard (wl-copy on Wayland, xclip on X11)
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-p:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | if [ -n \"\$WAYLAND_DISPLAY\" ]; then wl-copy; else xclip -selection clipboard; fi)+abort'
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
#
# Browse directories/files under a folder (default: $HOME).
#   ENTER on one directory -> cd into it
#   ENTER on one file      -> cd to the file's folder
#   TAB to select several, then ENTER -> open them all in $EDITOR
se() {
  local search_folder="${1:-$HOME}"
  local selection
  local -a selections

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

  # Command string for the reload binds below (fzf runs it in a subshell).
  # Ubuntu packages fd as fdfind. The folder is shell-quoted for safety.
  local fd_base="fdfind --hidden --no-ignore ${exclude_args[*]} . $(printf '%q' "$search_folder")"

  mapfile -t selections < <(
    fdfind --hidden --no-ignore "${exclude_args[@]}" . "$search_folder" --type d | fzf \
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
ENTER to navigate (several selected: open in editor)
DEL to delete
CTRL-P to toggle preview
'
  )

  # Nothing selected (ESC / Ctrl-C)
  [ "${#selections[@]}" -eq 0 ] && return

  # Several selected: open them all in the editor
  if [ "${#selections[@]}" -gt 1 ]; then
    ${EDITOR:-vim} "${selections[@]}"
    return
  fi

  selection="${selections[0]}"
  if [ -d "$selection" ]; then
    cd "$selection" || return
  elif [ -f "$selection" ]; then
    cd "$(dirname "$selection")" || return
  fi
}

# Key bindings and completion (CTRL-T, CTRL-R, ALT-C)
if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
elif command -v fzf >/dev/null 2>&1; then
  if _fzf_init=$(fzf --bash 2>/dev/null) && [ -n "$_fzf_init" ]; then
    eval "$_fzf_init"
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
  fi
  unset _fzf_init
fi
