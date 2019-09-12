" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1

" Enable line numbering
:set number relativenumber

" Highlight the searched result by default
:set hlsearch
" TODO: find the plugin that lets you quickly navigate to found items

" Makes the automatic tabs 4 spaces wide instead of 8 (!)
:set expandtab
:set softtabstop=4
:set shiftwidth=4
:set tabstop=4

" Accept Unicode characters
:set encoding=utf-8

"== GRAPHICS =="
" Enable syntax highlighting
:syntax on

" Set the colorscheme to the one fitting pywal's settings
:colorscheme wal

" Set the delimiter to something less noisy
" for example tmux's separator character
:set fillchars+=vert:│

" Treat underscores as "word" separators
" :set iskeyword-=_

" Remove background from vertical splits
" to make it less noisy
:highlight VertSplit cterm=NONE ctermfg=8
:highlight StatusLineNC ctermfg=0

"== PLUGINS =="
"- Load plugins (vim-plug) -"
"
" To install plugins, find the Plug '' section for given plugin
" then run :source % and :PlugInstall (not :PluginInstall)
"
" To disable a plugin, add:
" , { 'on': [] }
" in the end of the line in plug section. For example:
" Enabled:  Plug 'junegunn/goyo.vim'
" Disabled: Plug 'junegunn/goyo.vim', { 'on': [] }
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

:call plug#begin('~/.vim/plugged')
    " https://github.com/junegunn/goyo.vim
    Plug 'junegunn/goyo.vim'
    " TODO: Consider getting limelight

    " https://vimawesome.com/plugin/surround-vim
    Plug 'tpope/vim-surround'

    " https://vimawesome.com/plugin/vim-airline-superman
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " https://github.com/scrooloose/nerdtree
    Plug 'scrooloose/nerdtree'

    " https://github.com/lyuts/vim-rtags
    Plug 'lyuts/vim-rtags'
:call plug#end()

"- vim-airline config -"
" Setup the airline bar with fancy fonts
set t_Co=256
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.space = "\ua0"

"- nerdtree config -"
" Invoke nerd tree every time vim is opened
" and focus on buffer with file
autocmd VimEnter * NERDTree | wincmd w

" Close vim when NERDTree buffer is the only one present
" In case of emergency, visit:
" https://stackoverflow.com/questions/2066590/automatically-quit-vim-if-nerdtree-is-last-and-only-buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle mini file explorer
:nmap <C-n> :NERDTreeToggle<Enter>

"- Goyo config -"
" Toggle Goyo (distration free writing)

:noremap <F3> :Goyo<Enter>

function! s:init_on_entering_goyo()
    :silent !i3-msg fullscreen enable
    :set number relativenumber
endfunction

function! s:clean_up_after_colon_qing_goyo()
    :silent !i3-msg fullscreen disable
    :highlight VertSplit cterm=NONE ctermfg=8
    :highlight StatusLineNC ctermfg=0
    " TODO: Move cursor to the previous buffer
endfunction

autocmd! User GoyoEnter call <SID>init_on_entering_goyo()
autocmd! User GoyoLeave call <SID>clean_up_after_colon_qing_goyo()

"== KEYBINDINGS =="
"
" Map Ctrl-hjkl to move between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"== LEADERS =="
" Set leader key to space
:let mapleader = " "
:nnoremap <Space> <Nop>

