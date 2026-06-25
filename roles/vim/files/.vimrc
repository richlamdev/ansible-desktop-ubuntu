"Filename & location    ~/.vimrc
"Github                 https://github.com/richlamdev/ansible-desktop-ubuntu/
"Todo                   This should be broken down to ~/.vim/ tree structure for better management

" UI settings {{{
" debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible
set title                             " set title of window
set modeline
set modelines=1
set titlestring=\ [CWD:\ %{getcwd()}]\ \ \ \ [%t]%a%r%m%h%w%q titlelen=80
"set timeout timeoutlen=1000 ttimeoutlen=50
set showmode                          " always show what mode we're currently editing in
set showcmd                           " Show (partial) command in status line.
set report=1                          " provide more information about changes
set showmatch                         " Show matching brackets.
set history=2500                      " keep 2500 lines of command line history
set ruler                             " show the cursor position all the time
set nowrap                            " NO WRAPPING OF THE LINES! (except for Python, see below)
set encoding=utf-8                    " UTF8 Support
set backspace=indent,eol,start        " allow backspacing over everything in insert mode
set number                            " set numbered lines for columns
set list                              " show all whitespace a character
set listchars=tab:▸\ ,trail:·,nbsp:␣  " set characters displayed for tab/space
set mouse=a                           " enable mouse for all modes
set scrolloff=1                       " set number of context lines visible above & below cursor
set sidescrolloff=5                   " make vertical scrolling appear more natural
set noerrorbells                      " disable beep on errors
set lazyredraw                        " don't redraw while executing macros
set smoothscroll                      " smooth scrolling
set updatetime=300                    " set updatetime to 300ms
set background=dark                   " enable dark background within editing
set hidden                            " hide buffers when they are abandoned
set shiftround
colorscheme molokai-dark              " https://github.com/pR0Ps/molokai-dark
call matchadd('ColorColumn', '\%80v', 100)

filetype plugin indent on
syntax on

augroup restore_cursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END
" }}}

" file settings {{{
set autowrite              " Automatically save before commands like :next and :make
set nobackup               " do not keep a backup file, use versions instead
augroup buf_write_cleanup
  autocmd!
  autocmd BufWrite * %s/\s\+$//e   " Remove trailing whitespace on save
augroup END
" }}}

" path and completion {{{
set path=.,**              " relative to current file and everything under :pwd
set wildmenu               " display matches in command-line mode
"set wildmode=longest:full,full " complete the longest common prefix and show all matches
set wildoptions=pum        " show a list when pressing tab
set wildignore+=.pyc,.swp  " ignore these files when opening based on glob pattern
set wildignorecase         " ignore case when completing file names
" }}}

" window management {{{
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<cr>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<cr>
nnoremap <silent> <Leader>< :exe "vert resize " . (winwidth(0) * 5/6)<cr>
nnoremap <silent> <Leader>> :exe "vert resize " . (winwidth(0) * 6/5)<cr>

augroup window_management
  autocmd!
  autocmd VimResized * wincmd =
augroup END
set splitright splitbelow     " open splits to the right and below
" }}}

" visual moving text {{{
" https://vimrcfu.com/snippet/77
" visual mode moving lines of text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" insert mode moving line of text
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
" }}}

" search settings {{{
set ignorecase                " case insensitive matching
set smartcase                 " smart case matching
set incsearch                 " show search matches while typing
set hlsearch                  " highlight all matches after search
set matchtime=5               " time in tenths of a second to show matching

" keep search centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
" }}}

" filetype indent {{{
augroup filetype_indent
  autocmd!

  " yaml + kubernetes: smartindent off — # triggers dedent and breaks comments
  autocmd FileType yaml,yaml.kubernetes
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |

  " sh: let the filetype indent plugin handle block structure
  autocmd FileType sh
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |

  " vim: smartindent off — vimscript continuation lines misbehave with it
  autocmd FileType vim
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |

  " python: pep8 — indent plugin handles blocks, we just set spacing
  autocmd FileType python
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 |
      \ setlocal expandtab autoindent nosmartindent |
      \ setlocal textwidth=88 |

  " markdown: prose — autoindent on for lists/quotes, no cursorcolumn, spell on
  autocmd FileType markdown
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 |
      \ setlocal expandtab autoindent nosmartindent |
      \ setlocal foldmethod=manual nocursorcolumn |
      \ setlocal spell spelllang=en_us |

  " json: 2-space, syntax fold, folds start open
  autocmd FileType json
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |
      \ setlocal foldmethod=syntax foldlevelstart=99 |

  " terraform: hashicorp 2-space, folds start open
  autocmd FileType terraform
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |
      \ setlocal foldmethod=syntax foldlevelstart=99 |

  " dockerfile: 4-space, nosmartindent — no block structure to help with
  autocmd FileType dockerfile
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 |
      \ setlocal expandtab autoindent nosmartindent |

  " toml: 2-space — pyproject.toml, uv.lock, Cargo.toml, aws tooling configs
  autocmd FileType toml
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |

  " conf: generic config files — sshd_config, nginx, requirements.txt etc.
  autocmd FileType conf
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 |
      \ setlocal expandtab autoindent nosmartindent |

  " lua: nmap scripts — 2-space is nmap/lua community standard
  " indentexpr handled by vim's runtime lua indent plugin
  autocmd FileType lua
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 |
      \ setlocal expandtab autoindent nosmartindent |
      \ setlocal foldmethod=syntax foldlevelstart=99 |

  " gitcommit: spell on, textwidth for commit message body
  autocmd FileType gitcommit
      \ setlocal spell spelllang=en_us |
      \ setlocal textwidth=72 |

  " prose: disable shiftround — not shifting indentation in prose
  autocmd FileType markdown,text
      \ setlocal noshiftround |

augroup END
" }}}

" filetype detection {{{
augroup filetype_detect
  autocmd!

  " uv lock file is toml format
  autocmd BufNewFile,BufRead uv.lock
      \ setlocal filetype=toml |

  " requirements files — pip format, not python, conf is more honest
  autocmd BufNewFile,BufRead requirements*.txt
      \ setlocal filetype=conf |

  " jinja2: ansible and other jinja2 templates
  " falls back to yaml highlighting without vim-jinja2-syntax or ansible-vim
  " install one of those plugins for proper jinja2 {{ }} block highlighting
  autocmd BufNewFile,BufRead *.j2,*.jinja,*.jinja2
      \ setlocal filetype=yaml |

augroup END
" }}}

" ALE {{{
" https://github.com/dense-analysis/ale
let g:ale_linters = {
    \ 'json':            ['jq'],
    \ 'python':          ['ruff', 'bandit'],
    \ 'sh':              ['shellcheck'],
    \ 'terraform':       ['trivy'],
    \ 'yaml':            ['yamllint'],
    \ 'yaml.kubernetes': ['kubeconform', 'kubescape'],
    \ }

let g:ale_fixers = {
    \ 'json':      ['jq'],
    \ 'lua':       ['stylua'],
    \ 'python':    ['black'],
    \ 'sh':        ['shfmt'],
    \ 'terraform': ['terraform'],
    \ 'yaml':      ['yamlfmt'],
    \ }

" python
let g:ale_python_black_options = '--line-length 88'
let g:ale_python_ruff_options  = '--line-length 88'

" sh
let g:ale_sh_shfmt_options       = '-i 2 -ci'
let g:ale_sh_shellcheck_options  = '--exclude=SC2034'

" yaml
let g:ale_yaml_yamllint_options  = '-c ~/.config/yamllint/config.yaml'
let g:ale_yaml_yamlfmt_options   = '-formatter retain_line_breaks=true'

" yaml.kubernetes — verify variable name with :ALEInfo in a kubernetes buffer
let g:ale_yaml_kubernetes_kubeconform_options = '-strict -ignore-missing-schemas'

" lua
let g:ale_lua_stylua_options = '--indent-type Spaces --indent-width 2'

function! AleTrivyHandler(buffer, lines) abort
  let l:output = []
  try
    let l:json = json_decode(join(a:lines, ''))
    for l:result in get(l:json, 'Results', [])
      for l:misc in get(l:result, 'Misconfigurations', [])
        let l:severity = get(l:misc, 'Severity', 'UNKNOWN')
        let l:type = (l:severity ==# 'CRITICAL' || l:severity ==# 'HIGH') ? 'E' : 'W'
        call add(l:output, {
            \ 'lnum': get(get(l:misc, 'CauseMetadata', {}), 'StartLine', 1),
            \ 'text': '[' . l:severity . '] ' . get(l:misc, 'Title', '') . ' - ' . get(l:misc, 'ID', ''),
            \ 'type': l:type,
            \ })
      endfor
    endfor
  catch
  endtry
  return l:output
endfunction

call ale#linter#Define('terraform', {
    \ 'name':          'trivy',
    \ 'executable':    'trivy',
    \ 'command':       'trivy config --exit-code 0 -f json %t',
    \ 'callback':      'AleTrivyHandler',
    \ 'output_stream': 'stdout',
    \ })

" behaviour
let g:ale_fix_on_save          = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter        = 0

" display
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error      = '✘'
let g:ale_sign_warning    = '⚠'

" navigation
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" clear ALE and search highlights
function! ClearALEHighlights()
    call ale#highlight#RemoveHighlights()
    echo "ALE and search highlights cleared"
endfunction
nnoremap <silent> <leader>ca :noh<CR> :call ClearALEHighlights()<CR> :redraw!<CR>

" }}}

" indentLine {{{
" https://github.com/Yggdroot/indentLine
"let g:indentLine_char = '⦙'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:indentLine_bufTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:markdown_syntax_conceal=0
let g:vim_json_conceal=0
nnoremap <leader>id :IndentLinesToggle<cr>
" }}}

" statusline {{{
function! GitBranch()
  if exists('*FugitiveHead')
    return strlen(FugitiveHead()) ? ' '.FugitiveHead().' ' : ''
  endif
  return ''
endfunction

function! StatusHex()
  let l:col = col('.')
  let l:line = getline('.')
  if l:col <= len(l:line)
    return printf('0x%02X', char2nr(l:line[l:col - 1]))
  endif
  return ''
endfunction

function! SetHighlights()
  hi VertSplit      ctermfg=white
  hi User1          ctermbg=red         ctermfg=white
  hi User2          ctermbg=214         ctermfg=black
  hi User3          ctermbg=yellow      ctermfg=black
  hi User4          ctermbg=darkmagenta ctermfg=white
  hi User5          ctermbg=brown       ctermfg=white
  hi User6          ctermbg=lightblue   ctermfg=black
  hi User7          ctermbg=grey        ctermfg=black
  hi User8          ctermbg=black       ctermfg=214
  hi User9          ctermbg=blue        ctermfg=yellow
  hi StatusLineNC   cterm=italic
  hi ALEErrorSign   ctermfg=Red
  hi ALEWarningSign ctermfg=Yellow
  hi Search         cterm=none          ctermbg=green ctermfg=black
  hi CursorColumn   ctermbg=red         ctermfg=blue
  hi Visual         ctermbg=64          ctermfg=white
  hi ColorColumn    ctermbg=red       " highlight a marker at column 80
endfunction

function! AIStatus()
  if exists('*codeium#GetStatusString')
    return 'Codeium: ' . codeium#GetStatusString()
  elseif exists('*copilot#Enabled')
    return 'CP: ' . (copilot#Enabled() ? 'on' : 'off')
  endif
  return ''
endfunction

function! SetStatusLine()
  set laststatus=2
  set statusline=

  " -------- Left side --------
  set statusline+=%1*
  set statusline+=\ buf:%n

  set statusline+=%4*
  set statusline+=\ %f

  set statusline+=%3*
  set statusline+=\ ft:%y

  set statusline+=%1*
  set statusline+=\ %{AIStatus()}

  set statusline+=%8*
  set statusline+=\ %{GitBranch()}

  " -------- Right side --------
  set statusline+=%=

  set statusline+=%1*
  set statusline+=\ search:\ %{searchcount().current}/%{searchcount().total}

  set statusline+=%7*
  set statusline+=\ row:%l/%L

  set statusline+=%4*
  set statusline+=\ col:%c

  set statusline+=%6*
  set statusline+=\ %p%%

  set statusline+=%5*
  set statusline+=\ hex:%{StatusHex()}
endfunction

augroup StatusLineInit
  autocmd!
  autocmd VimEnter,ColorScheme * call SetHighlights() | call SetStatusLine()
augroup END
" }}}

" vimwiki {{{
" https://github.com/vimwiki/vimwiki
augroup filetype_vimwiki
  autocmd!
  autocmd BufNewFile,BufReadPost,BufAdd *.wiki set filetype=vimwiki
" disable tab for vimwiki filetypes, to allow autocompletion via codeium
  autocmd filetype vimwiki silent! iunmap <buffer> <Tab>
augroup END
let g:vimwiki_list = [{'path': '~/backup/git/wiki/',
                      \ 'syntax': 'default', 'ext': '.wiki',
                      \ 'links_space_char': '-'}]
let g:vimwiki_global_ext = 0
" }}}

" system clipboard {{{
vnoremap <c-y> "+y
" }}}

" fzf {{{
set runtimepath+=~/.fzf,~/.vim/bundle/fzf.vim

" CTRL-A and CTRL-D to populate quickfix list when using :Ag :Rg :Lines
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --layout=reverse --height 90% --border'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

let g:fzf_preview_window = ['right,50%', 'ctrl-/']
"nnoremap <c-p> :Files<cr>
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>s :BLines<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>j :Jumps<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>mk :Marks<cr>
nnoremap <Leader>ma :Maps<cr>
nnoremap <Leader>ch :Changes<cr>
nnoremap <Leader>li :Lines<cr>

function! s:build_quickfix_list(lines)
  let l:qf = []
  for l:line in a:lines
    let l:parts = split(l:line, ':', 4)
    call add(l:qf, {
      \ 'filename': l:parts[0],
      \ 'lnum': str2nr(l:parts[1]),
      \ 'col': str2nr(l:parts[2]),
      \ 'text': l:parts[3],
      \ })
  endfor
  call setqflist(l:qf, 'r')
  copen
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-q': function('s:build_quickfix_list') }

" toggle quickfix window
nnoremap <expr> <leader>q empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
" clear quickfix list
nnoremap <leader>cq :call setqflist([], 'r')<CR>

" prepopulate :RG with word under cursor
nnoremap <leader>g :RG <c-r>=expand("<cWORD>")<cr><cr>
" shortcut to :Cfilter
nnoremap <leader>cf :Cfilter /
" }}}

" nerdtree {{{
nnoremap <leader>n :NERDTreeToggle<cr>

let NERDShutUp = 1
let NERDTreeHijackNetrw = 1
let NERDTreeQuitOnOpen = 1             " quit NERDTree after openning a file
let NERDChristmasTree = 1              " colored NERD Tree
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
" let NERDTreeMapActivateNode='<CR>'   " map enter to activating a node
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf', '\.pyc$']
" }}}

" tagbar {{{
nnoremap <Leader>tb :TagbarToggle<cr>
" }}}

" copilot {{{
if isdirectory(expand('~/.vim/pack/github/start/copilot.vim'))
  inoremap <C-n> <Plug>(copilot-next)
  inoremap <C-p> <Plug>(copilot-previous)
  inoremap <C-x> <Plug>(copilot-dismiss)
  inoremap <C-a> <Plug>(copilot-suggest)
  nnoremap <Leader>p :Copilot panel<cr>
  function! ToggleCopilot()
    if copilot#Enabled()
      Copilot disable
      echo "Copilot disabled"
    else
      Copilot enable
      echo "Copilot enabled"
    endif
  endfunction
  nnoremap <Leader>ct :call ToggleCopilot()<CR>
endif
" }}}

" codeium {{{
if isdirectory(expand('~/.vim/pack/Exafunction/start/codeium.vim'))
  let g:codeium_idle_delay = 500
  let g:codeium_disable_bindings = 1
  imap <script><silent><nowait><expr> <Tab> codeium#Accept()
  imap <C-n> <Cmd>call codeium#CycleCompletions(1)<CR>
  imap <C-p> <Cmd>call codeium#CycleCompletions(-1)<CR>
  imap <C-x> <Cmd>call codeium#Clear()<CR>
  imap <C-a> <Cmd>call codeium#Complete()<CR>
  nnoremap <Leader>ct :CodeiumToggle<cr>
  function! GetLanguageServerVersion()
    let script_file = expand("~/.vim/pack/Exafunction/start/codeium.vim/autoload/codeium/server.vim")
    if filereadable(script_file)
      for line in readfile(script_file)
        if line =~ 'let s:language_server_version'
          return "Codeium version, based on language server: " . split(line, "'")[1]
        endif
      endfor
    endif
    return "Codeium version, based on language server: not found"
  endfunction
  command! CodeiumVersion echo GetLanguageServerVersion()
endif
" }}}

" testing {{{
" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
nnoremap <leader>cd :lcd %:h<cr>

" Open files located in the same dir in with the current file is edited
nnoremap <leader>ew :e <C-R>=expand("%:.:h") . "/"<cr>

" tree view from current working directory
nnoremap <Leader>tr :!clear && echo "Working Directory:" && pwd && tree \| less<cr>

nmap <Space>r :call feedkeys(":Rename " . expand('%@'))<CR>
" }}}

" vimrc {{{
" open vimrc / reload vimrc
nnoremap ,v :edit   $MYVIMRC<cr>
nnoremap ,u :source $MYVIMRC<cr> :edit $MYVIMRC<cr>
" }}}

" sudo write {{{
" Save a file with sudo (sw => sudo write)
nnoremap <leader>sw :w !sudo tee % > /dev/null<CR>
" }}}

" view/paste register {{{
function! Reg()
    reg
    echo "Register: "
    let char = nr2char(getchar())
    if char != "\<Esc>"
        execute "normal! \"".char."p"
    endif
    redraw
endfunction

command! -nargs=0 Reg call Reg()
" }}}

" load built-in plugins {{{
packadd editorconfig
packadd hlyank
packadd matchit
packadd cfilter

packadd comment
" enable line range commenting (similar to vim-commentary)
command! -range Comment <line1>,<line2>norm gcc
" }}}

" folding {{{
augroup folding_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END
set foldmethod=syntax
set foldlevelstart=1
set foldenable
set foldnestmax=10
nnoremap <space> za
" vim:foldmethod=marker:foldlevel=0
" }}}
