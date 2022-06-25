set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allows auto-indenting depending on file type
set tabstop=4               " number of columns occupied by a tab character

call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'arcticicestudio/nord-vim'

call plug#end()

colorscheme nord

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "typescript", "php", "json", "html", "fish", "dockerfile", "css" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,


  highlight = {
    enable = true,
  },
}
EOF
