set wildmenu
set ruler
set number
set splitright
set splitbelow


set autoread

syntax enable
set cmdheight=1

let g:netrw_liststyle = 3
let g:netrw_banner = 0
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"	autocmd!
"	autocmd VimEnter * :Vexplore
"augroup END 

set ignorecase
set smartcase
set hlsearch
set incsearch

set lazyredraw
set magic
set showmatch


set noerrorbells
set novisualbell
set t_vb=
set tm=500

set foldcolumn=1

set nobackup
set nowb
set noswapfile

set laststatus=2
set statusline=\ File:\ %F\ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

set wrap
set linebreak

" set mouse=a

" note trailing space at end of next line
set showbreak=>\ \ \


" remove trailing whitespace
autocmd FileType c,cpp,java,php,go autocmd BufWritePre <buffer> %s/\s\+$//e

" colorscheme blue
