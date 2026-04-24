set nocompatible

syntax on
set shortmess+=I
set number
set relativenumber
set laststatus=2
set backspace=indent,eol,start
set hidden
set ignorecase
set smartcase
set incsearch
set hlsearch

" Open splits in more natural positions
set splitright
set splitbelow

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Show matching brackets, trailing whitespace, etc.
set showmatch
set list
set listchars=tab:»·,trail:·,nbsp:·

" Scroll before hitting the edge
set scrolloff=8

" Faster screen update (helps gitgutter, etc. feel snappy)
set updatetime=100

" Keep undo history across sessions
set undofile
set undodir=~/.vim/undodir

" Netrw
let g:netrw_liststyle = 3  " Tree-style listing
let g:netrw_banner    = 0  " Hide the noisy top banner
let g:netrw_altv      = 1  " Vertical split opens to the right

" FZF — primary file navigation
nnoremap <leader>e :Files<CR>
nnoremap <leader>f :Rg<Space>
nnoremap <leader>b :Buffers<CR>

if !isdirectory($HOME . '/.vim/undodir')
    call mkdir($HOME . '/.vim/undodir', 'p')
endif

nmap Q <Nop>

set noerrorbells visualbell t_vb=
set mouse=

" Disable Ctrl+Arrow — tmux can accidentally send these, causing unexpected
" actions like deleting lines
noremap  <C-Up>    <Nop>
noremap  <C-Down>  <Nop>
noremap  <C-Left>  <Nop>
noremap  <C-Right> <Nop>
inoremap <C-Up>    <Nop>
inoremap <C-Down>  <Nop>
inoremap <C-Left>  <Nop>
inoremap <C-Right> <Nop>

" --- Clipboard (WSL) ---
" Yank to Windows clipboard using the built-in clip.exe (write-only, but enough)
if executable('clip.exe')
    autocmd TextYankPost * call system('clip.exe', @")
endif
" Yank to tmux if inside tmux
if !empty($TMUX)
    autocmd TextYankPost * call system('tmux load-buffer -', @")
endif

" Enable fzf plugin
set rtp+=~/.fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
let $FZF_DEFAULT_OPTS = '--preview-window=hidden'
command! FilesAll call fzf#vim#files('', {
  \ 'source': 'rg --files --hidden --no-ignore --glob "!.git/*"',
  \ 'options': $FZF_DEFAULT_OPTS
  \ })

" Tell vim the terminal supports true color (needed for WSL + Windows Terminal)
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
" Sonokai Shusia colorscheme
let g:sonokai_style = 'shusia'
let g:sonokai_better_performance = 1
colorscheme sonokai
" Background transparent
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE

nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Keep swap files in one place
if !isdirectory($HOME . '/.vim/swapfiles')
    call mkdir($HOME . '/.vim/swapfiles', 'p')
endif
set directory=~/.vim/swapfiles//
