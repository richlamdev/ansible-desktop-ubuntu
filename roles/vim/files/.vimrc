"Filename & location    ~/.vimrc
"Github                 https://github.com/richlamdev/ansible-desktop-ubuntu/
"Notes                  This should be broken down to ~/.vim/ tree structure for better management

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
set history=1500               " keep 1500 lines of command line history
set ruler                      " show the cursor position all the time
set nowrap                     " NO WRAPPING OF THE LINES! (except for Python, see below)
set encoding=utf-8             " UTF8 Support
set bs=indent,eol,start        " allow backspacing over everything in insert mode
set nu                         " set numbered lines for columns
set list                       " show all whitespace a character
set listchars=tab:▸\ ,trail:·  " set characters displayed for tab/space
set mouse=a                    " enable mouse for all modes
set scrolloff=1
set sidescrolloff=5            " make vertical scrolling appear more natural
set noerrorbells               " disable beep on errors
set splitright splitbelow      " open splits to the right and below
"set lines=45                  " set number of lines - do not use for console VIM
"set columns=80                " set number of columns - do not use for console VIM

if has("autocmd")              " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}

" file settings {{{
set autowrite              " Automatically save before commands like :next and :make
set nobackup               " do not keep a backup file, use versions instead
" }}}

" file find {{{
set path=.,**              " Relative to current file and everything under :pwd
set wildmenu               " display matches in command-line mode
set wildignore+=.pyc,.swp  " ignore these files when opening based on glob pattern
" set wildmode=list:longest  " make wildmneu behave similar to bash completion
set hidden                 " Hide buffers when they are abandoned
" }}}

" colours {{{
syntax on                  " Vim5 and later versions support syntax highlighting.
set background=dark        " Enable dark background within editing are and syntax highlighting
"set termguicolors
colorscheme pablo          " Set colorscheme
"colorscheme zellner          " Set colorscheme

hi Search ctermbg=Yellow   " highlight seached word in white
hi Search ctermfg=DarkRed  " change cursor color to dark red when at the highlighted word

" test color scheme
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

" :call DisplayColorSchemes()  -to view all colors

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

" Ensure all types of requirements.txt files get Python syntax highlighting
autocmd BufNewFile,BufRead requirements*.txt set ft=python

" highlight a marker at column 80
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%80v', 100)

" map f9 to excute python script
" nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>

" }}}

" jump configuration {{{
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

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =
" }}}

" visual moving text {{{
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==
" }}}

" search settings {{{
set ignorecase             " Do case insensitive matching
set smartcase              " Do smart case matching
set incsearch              " Show search matches while typing
set hlsearch               " highlight all matches after search
" keep search centered
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" vimspector settings {{{

"let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

"nnoremap <Leader>dd :call vimspector#Launch()<CR>
"nnoremap <Leader>de :call vimspector#Reset()<CR>
"nnoremap <Leader>dc :call vimspector#Continue()<CR>
"
"nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
"nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>
"
"nmap <Leader>dk <Plug>VimspectorRestart
"nmap <Leader>dh <Plug>VimspectorStepOut
"nmap <Leader>dl <Plug>VimspectorStepInto
"nmap <Leader>dj <Plug>VimspectorStepOver
" }}}

" ALE - Python {{{

let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['black']}
"let g:ale_fixers = {'*': [], 'python': ['black']}
let g:ale_python_flake8_options = '--max-line-length 79'
let g:ale_python_black_options = '--line-length 79'
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" }}}

" ALE - Yaml {{{

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
let g:indentLine_char = '⦙'

"set foldlevelstart=20

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
" }}}

" statusline {{{

" To be updated for terminal colors, as opposed to gui

hi VertSplit ctermbg=blue
"hi User1 ctermfg=#ffdad8  guibg=#880c0e
"hi User2 ctermfg=#000000  guibg=#F4905C
"hi User3 ctermfg=#292b00  guibg=#f4f597
"hi User4 ctermfg=#112605  guibg=#aefe7B
"hi User5 ctermfg=#051d00  guibg=#7dcc7d
"hi User7 ctermfg=black  ctermbg=red
"hi User8 ctermfg=#ffffff  guibg=#5b7fbb
"hi User9 ctermfg=#ffffff  guibg=#810085
"hi User0 ctermfg=#ffffff  guibg=#094afe

set laststatus=2
set statusline=
"set statusline+=%7*\B:%n                                  "buffernr
set statusline+=\B:%n                                  "buffernr
set statusline+=\               " add space separator
set statusline+=\ %F               " file path and name
set statusline+=\                  " add space separator
set statusline+=\ FT:\%y           " file type in [brackets]
set statusline+=\%=                " separator point left/right of items
set statusline+=\ %l/%L            " line number / line total
set statusline+=\                  " add space separator
set statusline+=\ %c               " column number
set statusline+=\                  " add space separator
set statusline+=\ %p%%             " percentage through file
set statusline+=\                  " add space separator
set statusline+=\ H:%B             " value of char under cursor in hex
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
