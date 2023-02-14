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
set listchars=tab:▸\ ,trail:·  " set characters displayed for tab/space
set mouse=a                    " enable mouse for all modes
set scrolloff=1                " set number of context lines visible above & below cursor
set sidescrolloff=5            " make vertical scrolling appear more natural
set noerrorbells               " disable beep on errors
"set lines=45                  " set number of lines - do not use for console VIM
"set columns=80                " set number of columns - do not use for console VIM

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
set wildignore+=.pyc,.swp  " ignore these files when opening based on glob pattern
set hidden                 " hide buffers when they are abandoned
" }}}

" Python PEP8 {{{
" To add the proper PEP8 indentation, add the following to your .vimrc:
"autocmd BufNewFile,BufRead *.py
autocmd Filetype python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set textwidth=0 |
    \ set smarttab |
    \ set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with |
    "\ set wrap linebreak nolist |

" highlight a marker at column 80
highlight ColorColumn ctermbg=red |
call matchadd('ColorColumn', '\%80v', 100)

" Ensure all types of requirements.txt files get Python syntax highlighting
autocmd BufNewFile,BufRead requirements*.txt set ft=python

" map f9 to excute python script
" nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>
" }}}

" jump configuration {{{
" https://vim.fandom.com/wiki/Jumping_to_previously_visited_locations
function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction

nmap <Leader>j :call GotoJump()<CR>
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
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==
" }}}

" search settings {{{
set ignorecase                " case insensitive matching
set smartcase                 " smart case matching
set incsearch                 " show search matches while typing
set hlsearch                  " highlight all matches after search
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

" Shell {{{
autocmd FileType sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |
" }}}

" Markdown {{{
autocmd FileType markdown
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |
" }}}

" ALE - Python {{{
" https://github.com/dense-analysis/ale
let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['black']}
"let g:ale_fixers = {'*': [], 'python': ['black']}
let g:ale_python_flake8_options = '--max-line-length 79'
let g:ale_python_black_options = '--line-length 79'
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0 " if you don't want linters to run on opening a file

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

" ALE - Yaml {{{
" https://github.com/dense-analysis/ale
autocmd FileType yaml
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set smarttab |

"set foldlevelstart=20
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
" }}}

" indentLine {{{
" https://github.com/Yggdroot/indentLine
"let g:indentLine_char = '⦙'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:indentLine_bufTypeExclude = ["vimwiki", "help", "json", "markdown"] "disable identline plugin (conceallevel) for specified filetypes
let g:markdown_syntax_conceal=0
let g:vim_json_conceal=0
" }}}

" colours {{{
syntax on                  " Vim5 and later versions support syntax highlighting.
set background=dark        " Enable dark background within editing are and syntax highlighting
colorscheme pablo          " Set colorscheme

" set termguicolors

hi Search ctermbg=Yellow   " highlight seached word in yellow
hi Search ctermfg=DarkRed  " change cursor color to dark red when at the highlighted word

" test color scheme
" :call DisplayColorSchemes()  -to view all colors

"function! DisplayColorSchemes()
   "let currDir = getcwd()
   "exec "cd $VIMRUNTIME/colors"
   "for myCol in split(glob("*"), '\n')
      "if myCol =~ '\.vim'
         "let mycol = substitute(myCol, '\.vim', '', '')
         "exec "colorscheme " . mycol
         "exec "redraw!"
         "echo "colorscheme = ". myCol
         "sleep 2
      "endif
   "endfor
   "exec "cd " . currDir
"endfunction
" }}}

" statusline {{{
" based on gnome-terminal, use XTerm colour palette
set fillchars+=vert:\           " change appearance of window split border
hi VertSplit ctermfg=grey guifg=grey " change color of window split border

hi User1 ctermbg=red ctermfg=white guibg=red guifg=white
hi User2 ctermbg=214 ctermfg=black guibg=#ffaf00 guifg=black "DarkOrange
hi User3 ctermbg=yellow ctermfg=black guibg=yellow guifg=black
hi User4 ctermbg=darkmagenta ctermfg=white guibg=darkmagenta guifg=white
hi User5 ctermbg=brown ctermfg=white guibg=brown guifg=white
hi User6 ctermbg=lightblue ctermfg=black guibg=lightblue guifg=black
hi User7 ctermbg=grey ctermfg=black guibg=grey guifg=black
hi User9 ctermbg=blue ctermfg=yellow guibg=blue guifg=yellow

set laststatus=2                " always display status line
set statusline=

set statusline+=%1*
set statusline+=\b:%n           " buffer number
set statusline+=%2*
set statusline+=\ %F            " file path and name
set statusline+=\               " add space separator
set statusline+=%3*
set statusline+=\ft:\%y         " file type in [brackets]
set statusline+=%9*             " reset color to default blue

set statusline+=\%=             " separator point left/right of items

set statusline+=\row:%l/%L      " line number / line total
set statusline+=%4*
set statusline+=\ col:%c        " column number
set statusline+=%6*
set statusline+=\ %p%%          " percentage through file
set statusline+=%5*
set statusline+=\ h:%B          " value of char under cursor in hex
" }}}

" vimwiki {{{
filetype plugin on
autocmd BufNewFile,BufReadPost,BufAdd *.wiki set filetype=vimwiki
let g:vimwiki_list = [{'path': '~/backup/git/wiki/',
                      \ 'syntax': 'default', 'ext': '.wiki',
                      \ 'links_space_char': '-'}]
let g:vimwiki_global_ext = 0
" }}}

" netrw {{{
inoremap <c-b> <Esc>:Lex<cr>:vertical resize 30<cr>
nnoremap <c-b> <Esc>:Lex<cr>:vertical resize 30<cr>

let g:netrw_banner = 0
let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" }}}

" system clipboard {{{
vnoremap <c-y> <esc>:'<,'>w !xclip -selection clipboard<cr><cr>
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
