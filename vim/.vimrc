" ==============================
"   BASIC SETTINGS
" ==============================
set nocompatible           " Disable compatibility mode
set number                 " Show line numbers
set relativenumber         " Show relative line numbers
set cursorline             " Highlight current line
set showcmd                " Show command in bottom bar
set showmode               " Show mode (INSERT, NORMAL, etc.)
set hidden                 " Allow buffer switching without saving
set updatetime=300         " Faster completion response
set timeoutlen=500         " Faster key sequence response

" ==============================
"   INDENTATION & FORMATTING
" ==============================
set expandtab              " Use spaces instead of tabs
set tabstop=4              " Tab width = 4 spaces
set shiftwidth=4           " Indent with 4 spaces
set softtabstop=4          " Consistent tab width
set autoindent             " Auto-indent new lines
set smartindent            " Smarter indentation
set wrap                   " Enable line wrapping
set linebreak              " Break lines at word boundaries

" ==============================
"   SEARCHING
" ==============================
set ignorecase             " Case-insensitive search
set smartcase              " Case-sensitive if capital letters used
set hlsearch               " Highlight search results
set incsearch              " Incremental search (live preview)
set gdefault               " Apply `:s` substitutions globally by default

" ==============================
"   CLIPBOARD INTEGRATION
" ==============================
set clipboard=unnamedplus  " Use system clipboard by default

set mouse=a                " Enable mouse support

" ==============================
"   APPEARANCE
" ==============================
syntax enable              " Enable syntax highlighting
" set termguicolors          " Enable 24-bit color
" colorscheme desert         " Change to your preferred colorscheme
set background=dark        " Better for dark themes


" ==============================
"   STATUS LINE
" ==============================
set laststatus=2           " Always show status line
set ruler                  " Show cursor position
" set showtabline=2          " Always show tab line

