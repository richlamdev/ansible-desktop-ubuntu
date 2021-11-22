" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible

syntax on		" Vim5 and later versions support syntax highlighting.
"set background=dark	" Enable dark background within editing are and syntax highlighting
set ttyfast		" Make the keyboard fast
set timeout timeoutlen=1000 ttimeoutlen=50
set showmode		" always show what mode we're currently editing in
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Show search matches while typing
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set nobackup            " do not keep a backup file, use versions instead
set history=500         " keep 500 lines of command line history
set ruler               " show the cursor position all the time
set nowrap              " NO WRAPPING OF THE LINES! (except for Python, see below)
set hlsearch    	" highlight all matches after search
hi Search ctermbg=White   " highlight seached word in white
hi Search ctermfg=DarkRed " change cursor color to dark red when at the highlighted word
set encoding=utf-8      " UTF8 Support
set bs=indent,eol,start " allow backspacing over everything in insert mode
set nu                  " set numbered lines for columns

"set rnu                 " set relative lines, if both set, line number is displayed instead of 0
"set lines=45		" set number of lines - do not use for console VIM
"set columns=80		" set number of columns - do not use for console VIM
"set foldmethod=indent  " Enable folding at indent
"set foldlevel=99
"nnoremap <space> za	" Map <space> as folding with the spacebar

" To add the proper PEP8 indentation, add the following to your .vimrc:
autocmd BufNewFile,BufRead *.py
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

if has("autocmd")	" Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Define BadWhitespace before using in a match
highlight BadWhitespace ctermbg=red guibg=darkred

" Flag extra whitespace
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" highlight a marker at column 80 - for PEP8 
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%80v', 100)



" map f9 to excute python script
nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>

"colorscheme torte	" Set colorscheme - mostly for windows
