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

" Bracketed paste — auto handles paste indentation
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"

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

" Yank to clipboard via OSC 52
function! OSC52Yank()
  let buffer = system('base64 -w0', @")
  let buffer = substitute(buffer, "\n", "", "g")
  let buffer = "\e]52;c;" . buffer . "\x07"
  silent exe "!echo -ne " . shellescape(buffer) . " > /dev/tty"
endfunction
autocmd TextYankPost * call OSC52Yank()

" Enable fzf plugin
set rtp+=~/.fzf
let $FZF_DEFAULT_COMMAND = 'rg --files'
let $FZF_DEFAULT_OPTS = '--preview-window=hidden'
command! FilesAll call fzf#vim#files('', {
  \ 'source': 'rg --files --hidden --no-ignore --glob "!.git/*"',
  \ 'options': $FZF_DEFAULT_OPTS
  \ })

" Tell vim the terminal supports true color (needed for WSL + Windows Terminal)
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set term=xterm-256color
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
