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

:nnoremap <Leader>c :colorscheme
:nnoremap <Leader>e :set guifont=*<CR>

" Quickly access this file
if exists("g:VIM_RC")
    if has('unix')
        noremap <Leader>v :execute 'edit!' g:VIM_RC<CR>
    elseif has ('win32')
        noremap <Leader>v :execute 'edit!' g:VIM_RC<CR>:set number relativenumber<CR>:<ESC>
    endif
else
    echom "You need to set VIM_RC variable so that it points to this file"
endif

" On Windows, sourcing vimrc results in the window being in a really weird
" state. To fix that, the screen needs to be toggled twice at the end, so
" please don't add anything below this line.
" TODO: Move all of the functions to the top of the file, as there's no notion
" of function declaration in Vim script
function! s:FixFullscreenAfterSource() abort
    if has('win32')
        call ToggleFullscreen()
        call ToggleFullscreen()
    endif
endfunction

" Quickly source current file
:noremap <Leader>s :wa<CR>:source %<CR>:call <SID>FixFullscreenAfterSource()<CR>

" Remove highlight after searching
:noremap <Leader>n :noh<CR>

"" Functions
" This function trims the whole file!
function! s:TrimTrailingWhitespaces() range
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

:noremap <Leader>w :call <SID>TrimTrailingWhitespaces()<CR>

" Joins multiple lines into one line without producing any spaces
" Like gJ, but always remove spaces
function! s:JoinSpaceless()
    execute 'normal gJ'

    " Character under cursor is whitespace?
    if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        " Then remove it!
        execute 'normal dw'
    endif
endfunction

:noremap <Leader>J :call <SID>JoinSpaceless()<CR>

" Remove all buffers but the one opened
function! s:DeleteBuffersExceptOpened()
    execute '%bdelete|edit #|normal `'
endfunction

:noremap <Leader>bd :call <SID>DeleteBuffersExceptOpened()<CR>

"" Choose buffer
:nnoremap <Leader>bb :buffers<CR>:b

"" Folding
"  Emulate IDE-like folding ability, so that it is possible to fold the code
"  in {} block
set foldmethod=indent
set foldlevel=99
nnoremap <Leader>f za

"" Python
" This is needed because the python is loaded dynamically
if exists("g:VIM_PYTHON_PATH")
    " For some reason, I cannot simply use 'set' here. The only way to 'set'
    " these variables is to use 'let' + &...
    let &pythonthreehome=g:VIM_PYTHON_PATH
    let &pythonthreedll=g:VIM_PYTHON_DLL
else
    echom "You need to set VIM_PYTHON_PATH in order to use Python"
endif

" Silently invoke Python3 just to skip the annoying warning in the beginning.
" It's left out here for compatibility reasons (this shouldn't be a problem
" from Vim 8.2 onwards).
if has('python3')
    silent! python3 1
endif

" Add proper PEP8 indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ | set softtabstop=4
    \ | set shiftwidth=4
    \ | set textwidth=79
    \ | set expandtab
    \ | set autoindent
    \ | set fileformat=unix

let python_highlight_all=1

" Enable line numbering
:set number relativenumber

" Highlight the searched result by default
:set hlsearch

" Give myself at least some basic information about the text file
if has('win32')
    set ruler
endif

" Remove all the swap / undo / backup files
:set noundofile
:set noswapfile
:set nobackup
:set nowritebackup

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

" Turn off file specific vim on-demand formatting
set nomodeline

" If searching in lowercase, ignore casing. Otherwise, check for a specific
" string and take font case into consideration
set ignorecase
set smartcase
set incsearch
set hlsearch

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
"
" Automatically install vim-plug if it's not present
if has('unix')
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source g:VIM_RC
    endif
endif

let plugin_location=''
if has('unix')
    let plugin_location='~/.vim/plugged'
elseif has('win32')
    let plugin_location='$VIMRUNTIME\plugged'
endif

:call plug#begin(plugin_location)
    Plug 'junegunn/goyo.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'

    " File fuzzy searching
    Plug 'kien/ctrlp.vim'

    "" Programming related
    Plug 'cespare/vim-toml'
    Plug 'Valloric/YouCompleteMe' ", { 'on': [] }

    " Snippets with all of their's dependencies
    Plug 'SirVer/ultisnips' ", { 'on': [] }
    Plug 'honza/vim-snippets' ", { 'on': [] }

    " Python
    Plug 'vim-scripts/indentpython.vim'
    Plug 'vim-syntastic/syntastic'
    Plug 'nvie/vim-flake8'

    " JavaScript
    Plug 'pangloss/vim-javascript'

    " Colorschemes
    Plug 'arcticicestudio/nord-vim' " It's great!
    Plug 'danilo-augusto/vim-afterglow' " Too colorful
    Plug 'AlessandroYorba/Alduin' " Feels heavy
    Plug 'gregsexton/Atom', { 'on': [] }
    Plug 'nightsense/carbonized' " Feels heavy
    Plug 'tyrannicaltoucan/vim-deep-space' " Quite ok, colorful, but still calm
    Plug 'whatyouhide/vim-gotham' " Quite ok
    Plug 'jonathanfilip/vim-lucius' " NO
    Plug 'owickstrom/vim-colors-paramount' " Quite minimalistic...
    Plug 'cocopon/iceberg.vim' " Quite ok, but split triggers me
    Plug 'morhetz/gruvbox' " Quite ok, but looks like a swamp
    Plug 'jaredgorski/fogbell.vim' " Quite ok
    Plug 'nanotech/jellybeans.vim' " Quite ok
    Plug 'yorickpeterse/happy_hacking.vim' " Quite ok, highlights
    " as bold and white spaces are highlighted too. very similar to
    " gruvbox but the whitespace highlight makes me confused

    " Linux specific plugins
    if has('unix')
        " https://github.com/lyuts/vim-rtags
        Plug 'lyuts/vim-rtags'

        " https://vimawesome.com/plugin/vim-airline-superman
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
    endif
:call plug#end()

" Plugin Install
noremap <Leader>pi :source %<CR>:PlugInstall<CR>

" Plugin Update
noremap <Leader>pu :source %<CR>:PlugUpdate<CR>

"" CtrlP
" let g:ctrlp_working_path_mode = 0

"" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <Leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_key_list_previous_completion = ['<s-tab>', '<Up>'] " Works with Ctrl-P
let g:ycm_key_list_select_completion = ['<tab>', '<Down>'] " Works with Ctrl-N

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

"" NERDTree
" Invoke nerd tree every time vim is opened
" and focus on buffer with file
" autocmd VimEnter * NERDTree | wincmd w

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

    autocmd! User GoyoEnter nested call <SID>init_on_entering_goyo()
    autocmd! User GoyoLeave nested call <SID>clean_up_after_colon_qing_goyo()
elseif has('win32')
    " Make GVim fullscreen on startup
    " Don't feel tempted to use 64-bit version of this, as it doesn't work
    " REQUIRES: https://github.com/derekmcloughlin/gvimfullscreen_win32/tree/master

    " Location of the fullscreen fixer dll

    function! s:ToggleFullscreen()
        call libcallnr(g:VIM_GVIMFULLSCREEN_DLL, "ToggleFullScreen", 0)
        redraw
    endfunction

    function! s:ForceFullscreen()
        call libcallnr(g:VIM_GVIMFULLSCREEN_DLL, "ToggleFullScreen", 1)
        redraw
    endfunction

    function! s:ForceDoubleFullscreen()
        call libcallnr(g:VIM_GVIMFULLSCREEN_DLL, "ToggleFullScreen", 3)
        redraw
    endfunction

    autocmd GUIEnter * call <SID>ForceFullscreen()
    noremap <F11> :call <SID>ToggleFullscreen()<CR>
    noremap <F12> :call <SID>ForceFullscreen()<CR>
    noremap <s-F12> :call <SID>ForceDoubleFullscreen()<CR>

    " This function is here only to fix Goyo's behaviour in GVim while using the
    " gvimfullscreen.dll. Goyo methods are a bit unreliable, so we need to run
    " separate function after Goyo is done doing what it's doing.
    function! s:FullscreenFix()
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
    noremap <F3> :Goyo<CR>:call <SID>FullscreenFix()<CR>
endif

"" Fonts
if has('win32')
    " set guifont=Consolas:h15
    set guifont=Fira\ Mono:h16
endif

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

""" Graphics

" Set the delimiter to something less noisy
" for example tmux's separator character
:set fillchars+=vert:│

" Treat underscores as "word" separators
" :set iskeyword-=_

" Colorscheme setting needs to be done AFTER setting highlight colors
" That way, the colorscheme can react and change accordingly
" NOTE: If you are ever to make colorscheme loading more robust, try this:
" https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
if has('unix')
    " Set the colorscheme to the one fitting pywal's settings
    colorscheme wal
elseif has('win32')
    " 'pywal' is unavailable on Windows, but 'nord' is a very nice colorscheme
    :colorscheme gotham
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
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" https://github.com/SirVer/ultisnips/issues/376#issuecomment-69033351
let g:UltiSnipsExpandTrigger="<NUL>"
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

" If you want :UltiSnipsEdit to split your window
let g:UltiSnipsEditSplit="vertical"

if has('win32')
    " Workaround for :UltiSnipsEdit so that it... works
    " https://github.com/SirVer/ultisnips/issues/711

    if exists("g:VIM_SNIPPETS_PATH")
        let g:UltiSnipsSnippetDirectories = [g:VIM_SNIPPETS_PATH]
    else
        echom "You need to set variable VIM_SNIPPETS_PATH in order to use snippets"
    endif
endif

