"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'yuezk/vim-js'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" NerdCommenter
let g:NERDSpaceDelims = 1

" ALE
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_linters = {
\ 'javascript': ['eslint', 'flow-language-server'],
\ 'typescript': ['eslint', 'tsserver'],
\ 'reason': ['ocaml-lsp'],
\ }
let g:ale_fixers = {
\ 'javascript': ['prettier', 'eslint'],
\ 'typescript': ['prettier', 'eslint'],
\ 'typescriptreact': ['prettier', 'eslint'],
\ 'ocaml': ['ocamlformat'],
\ }

" OCaml/Reason

au BufRead,BufNewFile *.re set filetype=reason
au BufRead,BufNewFile *.rei set filetype=reason

function! s:fix_refmt(buffer) abort
  let ext = expand('#' . a:buffer . ':e')
  if ext ==# 'rei'
    return {
    \   'command': 'esy refmt --interface true'
    \}
  else
    return {
    \   'command': 'esy refmt'
    \}
  endif
endfunction

let g:ale_fixers.reason = [function('s:fix_refmt')]

function! s:executable_callback(buffer) abort
  return 'true'
endfunction

function! s:get_command(buffer) abort
  return 'esy exec-command --include-current-env ocamllsp'
endfunction

function! s:get_language(buffer) abort
  return getbufvar(a:buffer, '&filetype')
endfunction

function! s:get_project_root(buffer) abort
  let l:merlin_file = ale#path#FindNearestFile(a:buffer, 'esy.json')
  if empty(l:merlin_file)
    let l:merlin_file = ale#path#FindNearestFile(a:buffer, 'package.json')
  endif
  return !empty(l:merlin_file) ? fnamemodify(l:merlin_file, ':h') : ''
endfunction

call ale#linter#Define('ocaml', {
\   'name': 'ocaml-lsp',
\   'lsp': 'stdio',
\   'executable': function('s:executable_callback'),
\   'command': function('s:get_command'),
\   'language': function('s:get_language'),
\   'project_root': function('s:get_project_root')
\})

call ale#linter#Define('reason', {
\   'name': 'ocaml-lsp',
\   'lsp': 'stdio',
\   'executable': function('s:executable_callback'),
\   'command': function('s:get_command'),
\   'language': function('s:get_language'),
\   'project_root': function('s:get_project_root')
\})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Leader
let mapleader = " "

" Key mappings
imap fd <Esc>
nmap <leader>fm <plug>(fzf-maps-n)
nmap <leader>pf :GFiles<cr>
nmap <leader>pm :GFiles?<cr>
nmap <leader>ps :Ag<cr>
nmap <leader>nf :NERDTreeFind %<cr>
nmap <leader>ah :ALEHover<cr>
nmap <leader>an :ALENextWrap<cr>
nmap <leader>ao :ALEOrganizeImports<cr>

" Fast saving
nmap <leader>w :w!<cr>
nmap fs :w!<cr>

" Clipboard
set clipboard+=unnamed

if has("autocmd")
  " Auto change working dir
  " autocmd BufEnter * lcd %:p:h
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show current position
set ruler

" Show line numbers
set number

" Enable mouse
set mouse=a

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show invisible characters
set list!
set listchars=tab:▸\ ,trail:·,eol:¬

" Hide mode in favor of airline
set noshowmode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

try
  colorscheme gruvbox
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set ai "Auto indent
set si "Smart indent
