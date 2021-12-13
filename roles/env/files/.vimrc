" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible

syntax on                  " Vim5 and later versions support syntax highlighting.
set background=dark        " Enable dark background within editing are and syntax highlighting
set ttyfast                " Make the keyboard fast
"set timeout timeoutlen=1000 ttimeoutlen=50
set showmode               " always show what mode we're currently editing in
set showcmd                " Show (partial) command in status line.
set showmatch              " Show matching brackets.
set ignorecase             " Do case insensitive matching
set smartcase              " Do smart case matching
set incsearch              " Show search matches while typing
set autowrite              " Automatically save before commands like :next and :make
set hidden                 " Hide buffers when they are abandoned
set nobackup               " do not keep a backup file, use versions instead
set history=1500           " keep 1500 lines of command line history
set ruler                  " show the cursor position all the time
set nowrap                 " NO WRAPPING OF THE LINES! (except for Python, see below)
set hlsearch               " highlight all matches after search
set encoding=utf-8         " UTF8 Support
set bs=indent,eol,start    " allow backspacing over everything in insert mode
set nu                     " set numbered lines for columns
colorscheme pablo          " Set colorscheme
hi Search ctermbg=Yellow   " highlight seached word in white
hi Search ctermfg=DarkRed  " change cursor color to dark red when at the highlighted word
set list
set listchars=tab:▸\ ,trail:·
set mouse=a
set scrolloff=8
set sidescrolloff=8
set title
set wildmenu               " display matches in command-line mode
" set wildmode=list:longest  " make wildmneu behave similar to bash completion
set path=.,**              " Relative to current file and everything under :pwd

"set termguicolors
"set rnu                 " set relative lines, if both set, line number is displayed instead of 0
"set lines=45            " set number of lines - do not use for console VIM
"set columns=80          " set number of columns - do not use for console VIM
"set foldmethod=indent   " Enable folding at indent
"set foldlevel=99
"nnoremap <space> za     " Map <space> as folding with the spacebar

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

if has("autocmd")     " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" highlight a marker at column 80 - for PEP8
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%80v', 100)

" map f9 to excute python script
nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>


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


" Window management
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <silent> <Leader>< :exe "vert resize " . (winwidth(0) * 5/6)<CR>
nnoremap <silent> <Leader>> :exe "vert resize " . (winwidth(0) * 6/5)<CR>


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


" visual moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==

" keeping search centred
nnoremap n nzzzv
nnoremap N Nzzzv
