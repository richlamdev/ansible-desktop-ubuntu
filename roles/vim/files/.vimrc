"Filename & location    ~/.vimrc
"Github                 https://github.com/richlamdev/ansible-desktop-ubuntu/
"Todo                   This should be broken down to ~/.vim/ tree structure for better management

" UI settings {{{
" debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible
set title                             " set title of window
"set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70
set titlestring=\ \ [PWD:\ %{getcwd()}]\ \ %F\ %a%r%m titlelen=80
set ttyfast                           " Make the keyboard fast
"set timeout timeoutlen=1000 ttimeoutlen=50
set showmode                          " always show what mode we're currently editing in
set showcmd                           " Show (partial) command in status line.
set report=1                          " provide a report when any command is executed
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
set scrolloff=3                       " set number of context lines visible above & below cursor
set sidescrolloff=5                   " make vertical scrolling appear more natural
set noerrorbells                      " disable beep on errors
set lazyredraw                        " don't redraw while executing macros
set smoothscroll                      " smooth scrolling
set updatetime=300                    " set updatetime to 300ms
set background=dark                   " enable dark background within editing
set termguicolors                     " enable true colors
syntax on                             " enable syntax highlighting.

if has("autocmd")                     " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}

" file settings {{{
set autowrite                         " Automatically save before commands like :next and :make
set nobackup                          " do not keep a backup file, use versions instead
autocmd BufWrite * %s/\s\+$//e        " Remove trailing whitespace on save
" }}}

" file find {{{
set path=.,**                         " relative to current file and everything under :pwd
set wildmenu                          " display matches in command-line mode
set wildmode=list:longest,full        " first tab complete as much as possible
set wildignore+=.pyc,.swp             " ignore these files when opening based on glob pattern
set wildignorecase                    " ignore case when completing file names
set hidden                            " hide buffers when they are abandoned
" }}}

" Python PEP8 {{{
autocmd Filetype python
  \ setlocal tabstop=4 |
  \ setlocal softtabstop=4 |
  \ setlocal shiftwidth=4 |
  \ setlocal expandtab |
  \ setlocal autoindent |
  \ setlocal fileformat=unix |
  \ setlocal textwidth=0 |
  \ setlocal smarttab |
  \ setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with,async,await,match,case |

" highlight a marker at column 80
highlight ColorColumn ctermbg=red |
call matchadd('ColorColumn', '\%80v', 100)

" Ensure all types of requirements.txt files get Python syntax highlighting
autocmd BufNewFile,BufRead requirements*.txt set ft=python

" map f9 to excute python script
" nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>
" }}}

" window management {{{
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <silent> <Leader>< :exe "vert resize " . (winwidth(0) * 5/6)<CR>
nnoremap <silent> <Leader>> :exe "vert resize " . (winwidth(0) * 6/5)<CR>

autocmd VimResized * wincmd =          " Auto-resize splits when Vim gets resized.
set splitright splitbelow              " open splits to the right and below
" }}}

" visual moving text {{{
" https://vimrcfu.com/snippet/77 - visual mode moving lines of text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" insert mode moving line of text
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
" }}}

" search settings {{{
set ignorecase                         " case insensitive matching
set smartcase                          " smart case matching
set incsearch                          " show search matches while typing
set hlsearch                           " highlight all matches after search
set matchtime=5                        " time in tenths of a second to show matching

highlight Search guibg=purple guifg='NONE'
highlight Search cterm=none ctermbg=green ctermfg=black
highlight CursorColumn guibg=blue guifg=red
highlight CursorColumn ctermbg=red ctermfg=blue

" keep search centered and open fold in search result
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
" }}}

" vimspector settings {{{
" let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
"nnoremap <Leader>dd :call vimspector#Launch()<CR>
"nnoremap <Leader>de :call vimspector#Reset()<CR>
"nnoremap <Leader>dc :call vimspector#Continue()<CR>
"nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
"nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>
"nmap <Leader>dk <Plug>VimspectorRestart
"nmap <Leader>dh <Plug>VimspectorStepOut
"nmap <Leader>dl <Plug>VimspectorStepInto
"nmap <Leader>dj <Plug>VimspectorStepOver
" }}}

" shell yaml vim {{{
autocmd FileType sh,yaml,vim
  \ setlocal tabstop=2 |
  \ setlocal softtabstop=2 |
  \ setlocal shiftwidth=2 |
  \ setlocal expandtab |
  \ setlocal autoindent |
  \ setlocal smartindent |
  \ setlocal smarttab |
  "\ setlocal colorscheme molokai |
" }}}

" markdown json {{{
autocmd FileType markdown,json
  \ setlocal tabstop=4 |
  \ setlocal softtabstop=4 |
  \ setlocal shiftwidth=4 |
  \ setlocal expandtab |
  \ setlocal autoindent |
  \ setlocal smartindent |
  \ setlocal smarttab |
  \ setlocal foldmethod=manual |
" }}}

" ALE {{{
" https://github.com/dense-analysis/ale
let g:ale_linters = {'json': ['jq'], 'python': ['ruff', 'bandit'], 'sh': ['shellcheck'], 'yaml': ['yamllint'], 'terraform': ['terraform']}
let g:ale_fixers = {'json': ['jq'], 'python': ['black'], 'sh': ['shfmt'], 'yaml': ['yamlfmt'], 'terraform': ['terraform']}
let g:ale_python_flake8_options = '--max-line-length 79'
let g:ale_python_black_options = '--line-length 79'
let g:ale_sh_shfmt_options = '-i 2 -ci'

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0 " if you don't want linters to run on opening a file
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'

" don't worry about long line length for yaml
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: {max: disable}}"'

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

" indentLine {{{
" https://github.com/Yggdroot/indentLine
"let g:indentLine_char = '⦙'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:indentLine_bufTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:markdown_syntax_conceal=0
let g:vim_json_conceal=0
nnoremap <Leader>i :IndentLinesToggle<cr>
" }}}

" statusline {{{
function! GitBranch()
  let branch = substitute(system('git rev-parse --abbrev-ref HEAD 2>/dev/null'), '\n', '', '')
  return strlen(branch) ? ' '.branch.' ' : ''
endfunction

function! SetStatusLine()
  " based on gnome-terminal, use XTerm colour palette
  "set fillchars+=vert:\ " change appearance of window split border
  hi VertSplit ctermfg=white guifg=white " change color of window split border

  hi User1 ctermbg=red ctermfg=white guibg=red guifg=white
  hi User2 ctermbg=214 ctermfg=black guibg=#ffaf00 guifg=black "DarkOrange
  hi User3 ctermbg=yellow ctermfg=black guibg=yellow guifg=black
  hi User4 ctermbg=darkmagenta ctermfg=white guibg=darkmagenta guifg=white
  hi User5 ctermbg=brown ctermfg=white guibg=brown guifg=white
  hi User6 ctermbg=lightblue ctermfg=black guibg=lightblue guifg=black
  hi User7 ctermbg=grey ctermfg=black guibg=grey guifg=black
  hi User8 ctermbg=black ctermfg=214 guibg=black guifg=#ffaf00
  hi User9 ctermbg=blue ctermfg=yellow guibg=blue guifg=yellow
  hi StatusLineNC cterm=italic       " non active windows are italic

  set laststatus=2                   " always display status line
  set statusline=

  set statusline+=%2*                " set to User1 color
  set statusline+=\b:%n              " buffer number
  "set statusline+=%2*                " set to User2 color
  "set statusline+=%{getcwd()}/       " current working directory (same as :pwd)
  set statusline+=%4*                " set to User4 color
  "set statusline+=%f                 " current directory + file with respect to pwd
  set statusline+=\                  " add space separator
  set statusline+=%3*                " set to User3 color
  set statusline+=\ft:\%y            " file type in [brackets]
  set statusline+=%1*                " set to User1 color
  set statusline+=\ {Codeium:\ %3{codeium#GetStatusString()}} " codeium status
  set statusline+=%8*                " set to User8 color
  set statusline+=%{GitBranch()}     " display git branch name
  set statusline+=%9*                " reset color to default blue
  set statusline+=\%=                " separator point left/right of statusline
  set statusline+=%7*                " set to User7 color
  set statusline+=\row:%l/%L         " line number / line total
  set statusline+=%4*                " set to User4 color
  set statusline+=\ col:%c           " column number
  set statusline+=%6*                " set to User6 color
  set statusline+=\ %p%%             " percentage through file
  set statusline+=%5*                " set to User5 color
  set statusline+=\ hex:%B           " value of char under cursor in hex
endfunction
" }}}

" vimwiki {{{
" https://github.com/vimwiki/vimwiki
filetype plugin indent on
autocmd BufNewFile,BufReadPost,BufAdd *.wiki set filetype=vimwiki
let g:vimwiki_list = [{'path': '~/backup/git/wiki/',
                      \ 'syntax': 'default', 'ext': '.wiki',
                      \ 'links_space_char': '-'}]
let g:vimwiki_global_ext = 0



" disable tab for vimwiki filetypes, to allow autocompletion via codeium
autocmd filetype vimwiki silent! iunmap <buffer> <Tab>
" }}}

" system clipboard {{{
"vnoremap <c-y> <esc>:'<,'>w !xclip -selection clipboard<cr><cr> "use this if clipboard support isn't compiled in vim

"check with :echo has('clipboard') "0 = not compiled in, 1 compiled in)
vnoremap <c-y> "+y
" }}}

" fzf {{{
set runtimepath+=~/.fzf,~/.vim/bundle/fzf.vim

" CTRL-A and CTRL-D to populate quickfix list when using :Ag :Rg :Lines
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all,ctrl-d:deselect-all --layout=reverse --height 90% --border'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

let g:fzf_preview_window = ['right,50%', 'ctrl-/']
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>s :BLines<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>j :Jumps<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>a :Ag<cr>
nnoremap <Leader>mk :Marks<cr>
nnoremap <Leader>ma :Maps<cr>
nnoremap <Leader>ch :Changes<cr>
nnoremap <Leader>l :Lines<cr>
" }}}

" vimgrep & grep {{{
" need to load args list first
" use :Vim <search_term>
command! -nargs=+ Vim execute "silent vimgrep! /<args>/gj ##" | copen | execute 'silent /<args>' | redraw!
nnoremap <silent> <leader>v :Vim <c-r>=expand("<cWORD>")<cr><cr>

" modified from: https://chase-seibert.github.io/blog/2013/09/21/vim-grep-under-cursor.html
" use :Grep <search_term>
command! -nargs=+ Grep execute 'silent grep! -I -i -r -n --exclude=\*.pyc --exclude-dir=.git ## -e <args>' | copen | execute 'silent /<args>' | redraw!
nnoremap <silent> <leader>g :Grep <c-r>=expand("<cWORD>")<cr><cr>
" }}}

" codeium {{{
" https://github.com/Exafunction/codeium.vim
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
" }}}

" nerdtree {{{
nnoremap <leader>n :execute ':NERDTreeToggle ' . getcwd()<cr>

let NERDShutUp = 1
let NERDTreeHijackNetrw=1
let NERDTreeQuitOnOpen=1    " quit NERDTree after openning a file
let NERDChristmasTree = 1   " colored NERD Tree
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
" let NERDTreeMapActivateNode='<CR>' " map enter to activating a node
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf', '\.pyc$']
" }}}

" tagbar {{{
nnoremap <Leader>tb :TagbarToggle<cr>
" }}}

" testing {{{
" 'cd' towards the directory in which the current file is edited
" but only change the path for the current window
nnoremap <leader>cd :lcd %:h<CR>

" Open files located in the same dir in with the current file is edited
nnoremap <leader>ew :e <C-R>=expand("%:.:h") . "/"<CR>

" tree view from current working directory
nnoremap <Leader>tr :!clear && echo "Working Directory:" && pwd && tree \| less<cr>

" clear search
" nnoremap <cr> :noh<cr><cr>
" }}}

" vimrc {{{
" open vimrc / reload vimrc
nnoremap ,v :edit   $MYVIMRC<cr>
nnoremap ,u :source $MYVIMRC<cr> :edit $MYVIMRC<cr>
" }}}

" sudo write {{{
" Save a file with sudo (sw => sudo write)
noremap <leader>sw :w !sudo tee % > /dev/null<CR>
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

" startup {{{
" https://github.com/pR0Ps/molokai-dark
colorscheme molokai-dark
call SetStatusLine()
" let g:molokai_original = 1
"colorscheme monokai

" Reapply the status line whenever the buffer or window changes
autocmd BufEnter,WinEnter * call SetStatusLine()

" Reapply status line when the color scheme changes
autocmd ColorScheme * call SetStatusLine()
" }}}

" folding {{{
set foldmethod=syntax
set foldlevelstart=1
set foldenable
set foldnestmax=10
let python_folding=1
nnoremap <space> za
" vim:foldmethod=marker:foldlevel=0
" }}}
