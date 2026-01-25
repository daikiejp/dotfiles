" ==============================================================================
" ViM Run Commands 
" DaikieJP - 2026
" ==============================================================================

" ==============================================================================
" CORE ESSENTIALS
" ==============================================================================

" Syntax highlighting
syntax enable

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set fileformats=unix,dos,mac

" ==============================================================================
" EDITING BEHAVIOR
" ==============================================================================

" Tabs & indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Search
set incsearch
set nohlsearch

" Performance
set updatetime=50

" ==============================================================================
" FILE MANAGEMENT
" ==============================================================================

" Undo persistence
set undofile
set undodir=~/.vim/undodir

" Swap / backup / undo
set noswapfile
set nobackup

" ==============================================================================
" VISUAL & UI
" ==============================================================================

" Line numbers
set number
set relativenumber

" Colors
set termguicolors

" UI / scrolling
set scrolloff=8
set signcolumn=yes
" set colorcolumn=80

" Status line
set laststatus=0
set noshowmode

" Wrapping
set nowrap

" Cursor
set guicursor=

" Font (GUI only)
set guifont=仿宋:h18

" ==============================================================================
" MINOR TWEAKS
" ============================================================================

" Filename characters
set isfname+=@-@

" ==============================================================================
" NETRW (File Explorer)
" ==============================================================================

let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
