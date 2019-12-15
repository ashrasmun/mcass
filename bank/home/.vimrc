if has('unix')
    " All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
    " /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
    " you can find below. If you wish to change any of those settings, you should
    " do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
    " everytime an upgrade of the vim packages is performed. It is recommended to
    " make changes after sourcing archlinux.vim since it alters the value of the
    " 'compatible' option.

    " This line should not be removed as it ensures that various options are
    " properly set to work with the Vim-related packages.
    runtime! archlinux.vim

    " If you prefer the old-style vim functionalty, add 'runtime!
    " vimrc_example.vim' or better yet, read
    " /usr/share/vim/vim80/vimrc_example.vim or the vim manual
    " and configure vim to your own liking!

    " do not load defaults if ~/.vimrc is missing
    "let skip_defaults_vim=1
endif

""" Fundamental
" Set leader key to space
:let mapleader = " "
:nnoremap <Space> <Nop>

" Quickly access this file
if has('unix')
    noremap <Leader>v :e $MYVIMRC<CR>
elseif has ('win32')
    noremap <Leader>v :e $MYVIMRC<CR>:set number relativenumber<CR>:<ESC>
endif

" Quickly source current file
:noremap <Leader>s :source %<CR>

" Enable line numbering
:set number relativenumber

" Highlight the searched result by default
:set hlsearch

" Makes the automatic tabs 4 spaces wide instead of 8 (!)
:set expandtab
:set softtabstop=4
:set shiftwidth=4
:set tabstop=4

" Accept Unicode characters
:set encoding=utf-8

" Writes trailing characters
set listchars=tab:>-,trail:-,nbsp:_
set list

" Enable syntax highlighting
:syntax on

" If searching in lowercase, ignore casing. Otherwise, check for a specific
" string and take font case into consideration
set ignorecase
set smartcase

" Fix backspace behaviour
set backspace=indent,eol,start

""" Plugins
"" Load plugins (vim-plug)
"
" To install plugins, find the Plug '' section for given plugin
" then run :source % and :PlugInstall (not :PluginInstall)
"
" To disable a plugin, add:
" , { 'on': [] }
" in the end of the line in plug section. For example:
" Enabled:  Plug 'junegunn/goyo.vim'
" Disabled: Plug 'junegunn/goyo.vim', { 'on': [] }
if has('unix')
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

:call plug#begin('~/.vim/plugged')
    " https://github.com/junegunn/goyo.vim
    Plug 'junegunn/goyo.vim'
    " TODO: Consider getting limelight

    " https://vimawesome.com/plugin/surround-vim
    Plug 'tpope/vim-surround'

    " https://github.com/scrooloose/nerdtree
    Plug 'scrooloose/nerdtree'

    " https://github.com/cespare/vim-toml
    Plug 'cespare/vim-toml'

    " https://github.com/easymotion/vim-easymotion
    Plug 'easymotion/vim-easymotion'

    " Snippets with all of their's dependencies
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " Windows specific plugins
    "if has('win32')
    " https://github.com/arcticicestudio/nord-vim
    Plug 'arcticicestudio/nord-vim'
    "endif

    " Linux specific plugins
    if has('unix')
        " https://github.com/lyuts/vim-rtags
        Plug 'lyuts/vim-rtags'

        " https://vimawesome.com/plugin/vim-airline-superman
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
    endif
:call plug#end()

" Plugin installation
noremap <Leader>pi :source %<CR>:PlugInstall<CR>

"" vim-airline config
if has('unix')
    " Setup the airline bar with fancy fonts
    set t_Co=256
    let g:airline_powerline_fonts = 1

    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif

    let g:airline_symbols.space = "\ua0"
endif

"" NERDTree config
" Invoke nerd tree every time vim is opened
" and focus on buffer with file
autocmd VimEnter * NERDTree | wincmd w

" Close vim when NERDTree buffer is the only one present
" In case of emergency, visit:
" https://stackoverflow.com/questions/2066590/automatically-quit-vim-if-nerdtree-is-last-and-only-buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle mini file explorer
noremap <Leader>nt :NERDTreeToggle<CR>
noremap <Leader>nf :NERDTreeFind<CR>

"" Goyo config
" Toggle Goyo (distration free writing)

" Make Goyo as wide as this line
" ============================================================================ "
let g:goyo_width=80

if has('unix')
    noremap <F3> :Goyo<Enter>

    function! s:init_on_entering_goyo()
        silent !i3-msg fullscreen enable
        set number relativenumber
    endfunction

    function! s:clean_up_after_colon_qing_goyo()
        silent !i3-msg fullscreen disable
        call <SID>restore_highlight_settings()
        " TODO: Move cursor to the previous buffer
    endfunction

    autocmd! User GoyoEnter call <SID>init_on_entering_goyo()
    autocmd! User GoyoLeave call <SID>clean_up_after_colon_qing_goyo()
elseif has('win32')
    " Make GVim fullscreen on startup
    " Don't feel tempted to use 64-bit version of this, as it doesn't work
    " REQUIRES: https://github.com/derekmcloughlin/gvimfullscreen_win32/tree/master

    " Location of the fullscreen fixer dll
    let g:gvim_fullscreen_dll="gvimfullscreen.dll"

    function! ToggleFullscreen()
        call libcallnr(gvim_fullscreen_dll, "ToggleFullScreen", 0)
        redraw
    endfunction

    function! ForceFullscreen()
        call libcallnr(gvim_fullscreen_dll, "ToggleFullScreen", 1)
        redraw
    endfunction

    function! ForceDoubleFullscreen()
        call libcallnr(gvim_fullscreen_dll, "ToggleFullScreen", 3)
        redraw
    endfunction

    autocmd GUIEnter * call ForceFullscreen()
    noremap <F11> :call ToggleFullscreen()<CR>
    noremap <F12> :call ForceFullscreen()<CR>
    noremap <s-F12> :call ForceDoubleFullscreen()<CR>

    " This function is here only to fix Goyo's behaviour in GVim while using the 
    " gvimfullscreen.dll. Goyo methods are a bit unreliable, so we need to run
    " separate function after Goyo is done doing what it's doing.
    function! FullscreenFix()
        if g:goyo_state
            call ForceFullscreen()
        endif
    endfunction

    " 0 - outside Goyo
    " 1 - in Goyo
    let g:goyo_state=0

    "" Goyo config
    function! s:goyo_enter()
        let g:goyo_state = 1

        " Remove tilde characters - works only for "nord" colorscheme!
        :highlight EndOfBuffer guifg=#2E3440

        set number relativenumber
    endfunction

    " This supports leaving Goyo via :x, :q etc
    function! s:goyo_leave()
        let g:goyo_state = 0
    endfunction

    autocmd! User GoyoEnter call <SID>goyo_enter()
    autocmd! User GoyoLeave call <SID>goyo_leave()

    " Toggle Goyo (distration free writing)
    noremap <F3> :Goyo<CR>:call FullscreenFix()<CR>
endif

""" Graphics

" Set the delimiter to something less noisy
" for example tmux's separator character
:set fillchars+=vert:│

" Treat underscores as "word" separators
" :set iskeyword-=_

" Interface clean-up
if has('unix')
    " Remove background from vertical splits to make it less noisy
    function! s:restore_highlight_settings()
        :highlight VertSplit cterm=NONE ctermfg=8
        :highlight StatusLineNC ctermfg=0
        :highlight clear CursorLineNr
        :highlight CursorLineNr cterm=bold
    endfunction

    call <SID>restore_highlight_settings()
elseif has('win32')
    " The only variation of vim usable on Windows is GVim, so all the settings
    " assume it's usage

    " Remove background from vertical splits to make it less noisy.
    :highlight VertSplit guibg=black guifg=white
    :highlight StatusLineNC guibg=black guifg=white

    " Remove GUI components
    set guioptions-=m " menu bar
    set guioptions-=T " toolbar
    set guioptions-=r " right-hand scroll bar
    set guioptions-=L " left-hand scroll bar
    set guioptions-=M " left-hand scroll bar
endif

if has('unix')
    " Set the colorscheme to the one fitting pywal's settings
    colorscheme wal
elseif has('win32')
    " 'pywal' is unavailable on Windows, but 'nord' is a very nice colorscheme
    colorscheme nord
endif

""" Keybindings
" Map Ctrl-hjkl to move between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

""" Snippets

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window
let g:UltiSnipsEditSplit="vertical"
