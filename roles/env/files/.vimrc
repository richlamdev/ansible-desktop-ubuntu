"Filename & location    ~/.vimrc
"Github                 https://github.com/richlamdev/ansible-desktop-ubuntu/
"Todo                   This should be broken down to ~/.vim/ tree structure for better management

" UI settings {{{
" debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible
set title                      " set title of window
set titlestring=VIM:\ \ %-25.55F\ %a%r%m titlelen=70
set ttyfast                    " Make the keyboard fast
"set timeout timeoutlen=1000 ttimeoutlen=50
set showmode                   " always show what mode we're currently editing in
set showcmd                    " Show (partial) command in status line.
set showmatch                  " Show matching brackets.
set history=2500               " keep 2500 lines of command line history
set ruler                      " show the cursor position all the time
set nowrap                     " NO WRAPPING OF THE LINES! (except for Python, see below)
set encoding=utf-8             " UTF8 Support
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nu                         " set numbered lines for columns
set list                       " show all whitespace a character
set listchars=tab:▸\ ,trail:·,nbsp:␣   " set characters displayed for tab/space
set mouse=a                    " enable mouse for all modes
set scrolloff=1                " set number of context lines visible above & below cursor
set sidescrolloff=5            " make vertical scrolling appear more natural
set noerrorbells               " disable beep on errors
set lazyredraw                 " don't redraw while executing macros
set smoothscroll               " smooth scrolling

if has("autocmd")              " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd BufWrite * %s/\s\+$//e " Remove trailing whitespace on save
" }}}

" file settings {{{
set autowrite              " Automatically save before commands like :next and :make
set nobackup               " do not keep a backup file, use versions instead
" }}}

" file find {{{
set path=.,**              " relative to current file and everything under :pwd
set wildmenu               " display matches in command-line mode
set wildmode=full          " first tab complete as much as possible
set wildignore+=.pyc,.swp  " ignore these files when opening based on glob pattern
set wildignorecase         " ignore case when completing file names
set hidden                 " hide buffers when they are abandoned
" }}}

" Python PEP8 {{{
" To add the proper PEP8 indentation, add the following to your .vimrc:
autocmd Filetype python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set textwidth=0 |
    \ set smarttab |
    \ set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with,async,await,match,case |

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

autocmd VimResized * wincmd = " Auto-resize splits when Vim gets resized.
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

highlight Search guibg=purple guifg='NONE'
highlight Search cterm=none ctermbg=green ctermfg=black
highlight CursorColumn guibg=blue guifg=red
highlight CursorColumn ctermbg=red ctermfg=blue

" keep search centered
nnoremap n nzzzv
nnoremap N Nzzzv
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

" shell {{{
autocmd FileType sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |
" }}}

" markdown {{{
autocmd FileType markdown
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |
" }}}

" yaml {{{
autocmd FileType yaml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |
" }}}

" ALE {{{
" https://github.com/dense-analysis/ale
let g:ale_linters = {'json': ['jq'], 'python': ['ruff', 'bandit'], 'sh': ['shellcheck'], 'yaml': ['yamllint']}
let g:ale_fixers = {'python': ['black'], 'sh': ['shfmt']}
"let g:ale_fixers = {'*': [], 'python': ['black']}
let g:ale_python_flake8_options = '--max-line-length 79'
let g:ale_python_black_options = '--line-length 79'
let g:ale_sh_shfmt_options = '-i 2 -ci'

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0 " if you don't want linters to run on opening a file
"set foldlevelstart=20
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'

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

" colours {{{
syntax on                  " Vim5 and later versions support syntax highlighting.
set background=dark        " Enable dark background within editing are and syntax highlighting
set termguicolors

"colorscheme molokai          " Set colorscheme
"let g:molokai_original = 1
colorscheme monokai          " Set colorscheme
" }}}

" statusline {{{
function! GitBranch()
  let branch = substitute(system('git rev-parse --abbrev-ref HEAD 2>/dev/null'), '\n', '', '')
  return strlen(branch) ? ' '.branch.' ' : ''
endfunction

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

set statusline+=%1*                " set to User1 color
set statusline+=\b:%n              " buffer number
set statusline+=%2*                " set to User2 color
set statusline+=%{getcwd()}/       " current working directory (same as :pwd)
set statusline+=%4*                " set to User4 color
set statusline+=%f                 " current directory + file with respect to pwd
set statusline+=\                  " add space separator
set statusline+=%3*                " set to User3 color
set statusline+=\ft:\%y            " file type in [brackets]
set statusline+=%1*
set statusline+=\{…\}%3{codeium#GetStatusString()}  " codeium status
set statusline+=%8*                " set to User8 color
set statusline+=%{GitBranch()}
set statusline+=%9*                " reset color to default blue

set statusline+=\%=                " separator point left/right of statusline

set statusline+=%7*                " set to User7 color
set statusline+=\row:%l/%L         " line number / line total
set statusline+=%4*
set statusline+=\ col:%c           " column number
set statusline+=%6*
set statusline+=\ %p%%             " percentage through file
set statusline+=%5*
set statusline+=\ hex:%B           " value of char under cursor in hex
" }}}

" vimwiki {{{
" https://github.com/vimwiki/vimwiki
filetype plugin on
autocmd BufNewFile,BufReadPost,BufAdd *.wiki set filetype=vimwiki
let g:vimwiki_list = [{'path': '~/backup/git/wiki/',
                      \ 'syntax': 'default', 'ext': '.wiki',
                      \ 'links_space_char': '-'}]
let g:vimwiki_global_ext = 0

" disable tab for vimwiki filetypes, to allow autocompletion via codeium
autocmd filetype vimwiki silent! iunmap <buffer> <Tab>
" }}}

" netrw {{{
"inoremap <c-s> <Esc>:Lex<cr>:vertical resize 30<cr>
"nnoremap <c-s> <Esc>:Lex<cr>:vertical resize 30<cr>

" https://www.akhatib.com/making-netrw-clean-and-minimally-disruptive-then-stop-using-it/
let g:netrw_banner = 0
"let g:netrw_list_hide = '^\.\.\=/\=$,.DS_Store,.idea,.git,__pycache__,venv,node_modules,*\.o,*\.pyc,.*\.swp'
let g:netrw_list_hide = '^\.\=/\=$,.DS_Store,.idea,.git,__pycache__,venv,node_modules,*\.o,*\.pyc,.*\.swp'
let g:netrw_hide = 1
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 4
"let g:netrw_winsize = 20
" }}}

" system clipboard {{{
"vnoremap <c-y> <esc>:'<,'>w !xclip -selection clipboard<cr><cr>
"above is unnecessary if clipboard support is compiled with vim,
"check with :echo has('clipboard') "return 0 = not compiled in, return 1 compiled in)
vnoremap <c-y> "+y
"set clipboard^=unnamed,unnamedplus "make vim use system clipboard
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
nnoremap <Leader>c :Changes<cr>
nnoremap <Leader>l :Lines<cr>
" }}}

" vimgrep & grep {{{
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
let g:codeium_disable_bindings = 1
imap <script><silent><nowait><expr> <Tab> codeium#Accept()
imap <C-n> <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-p> <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x> <Cmd>call codeium#Clear()<CR>
imap <C-a> <Cmd>call codeium#Complete()<CR>

function! GetLanguageServerVersion()
    let autoload_dir = expand("~/.vim/pack/Exafunction/start/codeium.vim/autoload/codeium")
    let script_file = autoload_dir . "/server.vim"

    if filereadable(script_file)
        let script_contents = readfile(script_file)
        for line in script_contents
            if line =~ 'let s:language_server_version'
                let parts = split(line, "'")
                return "Codeium version: " . parts[1]
            endif
        endfor
    endif

    return "Codeium version: not found"
endfunction

command! CodeiumVersion echo GetLanguageServerVersion()
" }}}

" nerdtree {{{
nnoremap <leader>n :NERDTreeToggle<cr>
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

" folding {{{
set foldmethod=syntax
set foldlevelstart=1
set foldenable
set foldnestmax=10
let python_folding=1
nnoremap <space> za
" vim:foldmethod=marker:foldlevel=0
" }}}
