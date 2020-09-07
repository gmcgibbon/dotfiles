set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-bundler'
Plugin 'vim-ruby/vim-ruby'
Plugin 'pangloss/vim-javascript'
Plugin 'janko-m/vim-test'
Plugin 'junegunn/fzf.vim'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'sickill/vim-monokai'

call vundle#end()
filetype plugin indent on

set incsearch
set history=100

set autowrite
set nobackup
set nowritebackup

set textwidth=80
set colorcolumn=+1

set laststatus=2
set ruler
set showcmd

set number
set numberwidth=4

set modelines=0
set nomodeline

syntax on
colorscheme monokai
