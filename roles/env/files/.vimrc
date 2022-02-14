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
set sidescrolloff=5
set noerrorbells               " disable beep on errors
" set laststatus=2
"set lines=45                  " set number of lines - do not use for console VIM
"set columns=80                " set number of columns - do not use for console VIM

if has("autocmd")              " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}


" File settings {{{
set autowrite              " Automatically save before commands like :next and :make
set nobackup               " do not keep a backup file, use versions instead
" }}}

" File find {{{
set path=.,**              " Relative to current file and everything under :pwd
set wildmenu               " display matches in command-line mode
" set wildmode=list:longest  " make wildmneu behave similar to bash completion
set hidden                 " Hide buffers when they are abandoned
" }}}

" Colours {{{
syntax on                  " Vim5 and later versions support syntax highlighting.
set background=dark        " Enable dark background within editing are and syntax highlighting
" set termguicolors
colorscheme pablo          " Set colorscheme

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

" }}}

" Python PEP8 {{{

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


" highlight a marker at column 80 - for PEP8
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%80v', 100)

" map f9 to excute python script
nnoremap <buffer> <F9> :w<CR> :exec '!python3' shellescape(@%, 1)<CR>

" }}}

" Jump configuration {{{
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

" Window management {{{
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 6/5)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 5/6)<CR>
nnoremap <silent> <Leader>< :exe "vert resize " . (winwidth(0) * 5/6)<CR>
nnoremap <silent> <Leader>> :exe "vert resize " . (winwidth(0) * 6/5)<CR>
" }}}

" Visual moving text {{{
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==
" }}}

" Search settings {{{
set ignorecase             " Do case insensitive matching
set smartcase              " Do smart case matching
set incsearch              " Show search matches while typing
set hlsearch               " highlight all matches after search
" keep search centered
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" Section folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
nnoremap <space> za
" vim:foldmethod=marker:foldlevel=0
" }}}


" Vimspector settings {{{

let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

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


" Section ALE {{{

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
