set nocompatible              " be iMproved, required
filetype off                  " required

"vim needs a more POSIX compatible shell than fish
if &shell =~# 'fish$'
    set shell=bash
endif

call plug#begin('~/.vim/plugged')
Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sbdchd/neoformat'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'Konfekt/FastFold'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'tomtom/tcomment_vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
"Plug 'junegunn/fzf'  " On Archlinux this plugin is installed globally when installing fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }

if has('nvim')
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': './install.sh',
        \ 'for': ['python', 'haskell']
        \ }

    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" Colorschemes
Plug 'NLKNguyen/papercolor-theme'
"Plug 'chriskempson/base16-vim'
"Plug 'rakr/vim-one'
"Plug 'tomasr/molokai'
"Plug 'reedes/vim-colors-pencil'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" General settings
"------------------------------------------------------------

" Better command-line completion
set wildmenu
set wildmode=longest:full,full

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches
set hlsearch

" highlight matching pattern as you type
set incsearch

" store swap files in a central place
set directory=~/.vim/swapfiles//,/tmp//

" Command line history
set history=100

" Set Window title
set title

" open new buffers to the right of the current one when splitting vertically
set splitright

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
         \ | wincmd p | diffthis
endif

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Disable mouse
set mouse=

" Display line numbers on the left
set number
"set relativenumber

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=100

" Use <F11> to toggle between 'paste' and 'nopaste'. This is only useful in
" terminal vim
"set pastetoggle=<F11>

" show vertical line after 120 characters
set colorcolumn=121

" linewrapping and textwidth
set textwidth=120
set formatoptions-=t
set wrap
set linebreak
set breakindent
set nojoinspaces

" highlight current line. Can cause Vim to respond slowly, especially for
" large files or files with long lines.
"set cursorline

" minimize lag when scrolling large files with cursorline enabled
set lazyredraw

" always show at least 3 lines above and below cursor when scrolling
set scrolloff=3

" show hex code of unprinteable characters
set display="uhex"

" Syntay highlighting items specify folds
set foldmethod=syntax

" avoids that too many folds are created
set foldnestmax=3

" start with all folds expanded
set nofoldenable

" allows to hide buffers without saving
set hidden

" show tab characters
set list
set listchars=tab:▸\ 

" updatetime (for gitgutter)
set updatetime=250

" enable undodir
set undofile
set undodir=~/.vim/undodir

" Enable increasing of alphabetical characters with <C-A>
set nrformats+=alpha

" Warn when file changed on disk
set autoread
autocmd CursorHold * checktime

" Indentation options
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab


if has('nvim')
    " live preview of substitution in split window
    set inccommand=split
endif

" Automatically save notes when focus is lost
autocmd FocusLost ~/workspace/masterthesis/notes* :wa
autocmd FocusLost ~/sync/Notes* :wa
autocmd BufRead ~/sync/Notes* :set nospell

"------------------------------------------------------------
" Mappings
"------------------------------------------------------------
let mapleader='ö'
let maplocalleader='ö'

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nnoremap Y y$

" Force saving files that require root permission
cmap w!! w !sudo tee > /dev/null %

" the escape key is tooo far away
inoremap jj <ESC>

" don't leave visual selection mode after changing indentation
vmap > >gv
vmap < <gv
vmap = =gv

" run default macro (recorded with qq)
nnoremap Q @q

" scroll by wrapped, rather than by actual lines
imap <up> <C-O>gk
imap <down> <C-O>gj
nmap <up> gk
nmap <down> gj
vmap <up> gk
vmap <down> gj

" Move lines up and down using Alt+J and Alt+K (works in all modes)
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Set common command misspellings as aliases to make them work nonetheless
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))

" Copy to clipboard and stay in visualmode
vnoremap <C-C> "*ygv

" Insert new line in normal mode
nmap <S-CR> i<CR><Esc>

" Insert space in normal mode
"nnoremap <SPACE> i<SPACE><ESC>

" increment/decrement feature
nnoremap - <C-X>
nnoremap + <C-A>

" Toggle NERDTree
nnoremap <A-n> :NERDTreeToggle<CR>

" Cycle through buffers
nnoremap <Leader><TAB> :bnext<CR>
nnoremap <Leader><S-TAB> :bprevious<CR>

" ctags jumping
nmap <A-a> <C-]>
nmap <A-q> :tnext<CR>
nmap <A-Q> :tprevious<CR>

" b and w in insert mode
inoremap <A-right> <ESC>lwi
inoremap <A-left> <ESC>bi

" toggle spellchecking
map <F12> :setlocal spell! spelllang=de_de<CR>

" Esc to disable highlighting of search matches
if has('nvim')
    nnoremap <Esc> :nohlsearch<CR>
endif

" Copy to X clipboard
vmap <C-c> "*y

" Paste from X clipboard
vmap <Insert> d"*p
imap <Insert> <Esc>"*pa
nmap <Insert> "*p

" neovim terminal mappings
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
endif

" window navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Disable <F1> showing the help
map <F1> <nop>
imap <F1> <nop>

"------------------------------------------------------------
" Theming
"------------------------------------------------------------

" Remove annoying GUI elements in gvim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=e  "remove ugly tab bar

set guifont=Hack\ 9
set termguicolors
set background=light
colorscheme PaperColor
"highlight Cursor guibg=#65ff51


"------------------------------------------------------------
" Plugin Settings
"------------------------------------------------------------

" fzf commands and mappings
command! Fd call fzf#run(fzf#wrap({'source': 'fd --follow --type f --hidden --exclude .git'}))

function! s:rg_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:rg_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:rg_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Rg call fzf#run({
\ 'source':  empty(<q-args>)
\               ?        'rg --hidden --glob "!.git/" --iglob "!license*" --iglob "!COPYING" --column --no-heading --color always --colors "match:none" "\S"'
\               : printf('rg --hidden --glob "!.git/" --iglob "!license*" --iglob "!COPYING" --column --no-heading --color always --colors "match:none" "%s"',
\                       escape(<q-args>, '"\')),
\ 'sink*':    function('<sid>rg_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all ',
\ 'down':    '50%'
\ })

nnoremap <A-f> :Fd<CR>
nnoremap <A-r> :Rg<CR>
nnoremap <A-b> :Buffers<CR>

" Neomake. Run only on write if on battery.
function! OnBattery()
    let l:bat_file = '/sys/class/power_supply/AC/online'
    return filereadable(bat_file) && readfile(bat_file) == ['0']
endfunction

if OnBattery()
  call neomake#configure#automake('w')
else
  call neomake#configure#automake('nw', 1000)
endif

hi NeomakeWarningSign guifg=#ff8700 ctermfg=208
hi NeomakeVirtualtextWarning guifg=#ff8700 ctermfg=208
hi NeomakeErrorSign guifg=#d70000 ctermfg=160
hi NeomakeVirtualtextError guifg=#d70000 ctermfg=160

" on nvim the language client already provides warnings
if has('nvim')
    let g:neomake_haskell_enabled_makers = []
    let g:neomake_python_enabled_makers = []
endif

" Airline settings
"let g:airline_theme='tomorrow'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = '␣'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#disable_refresh=1

" vim-notes settings
"let g:notes_directories = ['~/sync/notes']
"let g:notes_suffix = '.txt'

" neoformat settings
let g:neoformat_haskell_brittany = {
    \ 'exe': 'brittany',
    \ 'args': ['--indent 4', '--columns 99', '--import-col 49', '--import-as-col 50'],
    \ 'stdin': 1,
    \ }

let g:neoformat_enabled_haskell = ['brittany']

let g:SuperTabDefaultCompletionType = '<C-n>'

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit = "vertical"

" vimlatex settings
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
            \ 'continuous' : 1,
            \ 'build_dir' : 'build',
            \ }
"let g:vimtex_fold_enabled = 1
let g:vimtex_imaps_leader = 'ö'
let g:vimtex_complete_close_braces = 1
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_mode = 2
let g:vimtex_view_method = 'zathura'
if has('nvim')
    let g:vimtex_compiler_progname = '/usr/bin/nvr'
endif

"set filetype=tex on empty tex files.
let g:tex_flavor='latex'

" fastfold settings
let g:tex_fold_enabled=1
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:php_folding = 1
let g:perl_fold = 1

" EditorConfig settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" highlightedyank
let g:highlightedyank_highlight_duration = 600
hi HighlightedyankRegion cterm=reverse gui=reverse

" vim-better-whitespace settings
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf', 'help']
let g:strip_whitelines_at_eof=1
highlight ExtraWhitespace guibg=#E06C75 ctermbg=210

" vim-markdown
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_folding_level = 4

" deoplete
let g:deoplete#enable_at_startup = 1

" LanguageClient config
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie-wrapper'],
    \ 'python': ['/usr/bin/pyls'],
    \}
let g:LanguageClient_rootMarkers = {
    \ 'haskell': ['*.cabal', 'stack.yaml'],
    \ }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
