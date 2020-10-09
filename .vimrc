" omments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
" inoremap <Left>  <ESC>:echoe "Use h"<CR>
" inoremap <Right> <ESC>:echoe "Use l"<CR>
" inoremap <Up>    <ESC>:echoe "Use k"<CR>
" inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Highlight searches
set hlsearch

" Show the cursor position
set ruler

" Highlight current line when in 'insert' mode and remove in when in normal mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

"" Vundle definitions
"filetype off                  " required
"
"" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
"
"" alternatively, pass a path where Vundle should install plugins
""call vundle#begin('~/some/path/here')
"
"" let Vundle manage Vundle, required
"Plugin 'gmarik/Vundle.vim'
"
"" Enable better fold
"Plugin 'tmhedberg/SimpylFold'
"
"" indent and closesly to PEP8
"Plugin 'vim-scripts/indentpython.vim'
"
"" install code complition
"" Plugin 'ycm-core/YouCompleteMe'
"
"" Powerline status bar that displays things like the current virtualenv, git
"" branch, files being edited
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"
"" NERDTree is a file system explorer 
"" Plugin 'preservim/nerdtree'
"
"" All of your Plugins must be added before the following line
"call vundle#end()            " required
"filetype plugin indent on    " required
"" end Vundle definitions

" split the screen in specific locations
set splitbelow
set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Enable folding
set foldmethod=indent
set foldlevel=99

"Enable folding with the spacebar
nnoremap <space> za

" mark extra whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" toggle between hilight search, this is in order to remove the highlisght
" after search
nnoremap <F3> :set hlsearch!<CR>

"" In documentation for "Powerline" to work
"let g:Powerline_symbols = 'fancy'

""-------------------- NERDTree Settings --------------------
"" open a NERDTree automatically when vim starts up
"autocmd VimEnter * NERDTree | wincmd p
"
"" open a NERDTree automatically when vim starts up if no files were specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"
"" close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
"" map a specific key or shortcut to open NERDTree
"map <C-n> :NERDTreeToggle<CR>
"
"" show dot files
"let NERDTreeShowHidden=1
""-----------------------------------------------------------
" Same coloe to diff between files, all the color are blue, and text is green
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Green
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Green
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Green
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Green

""------------------------------Find files "fuzzy way"-----------------------------
" Search down into subfolders, Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" - Hit tab to :find by partial match
" - Use * to make it fuzzy
""---------------------------------------------------------------------

""------------------------------show tabs-----------------------------
" Shortcut to rapidly toggle `set list`
 nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ 

" Show tabs automaticly
set list

"Invisible character colors 
highlight SpecialKey guifg=#4a4a59
""---------------------------------------------------------------------

""------------------------------netrw-----------------------------
" hide netrw top message
let g:netrw_banner=0

" tree listing by default
let g:netrw_liststyle = 3

"open files in a new horizontal split
let g:netrw_browse_split = 1

" The width of the directory explorer, x% of total screen
let g:netrw_winsize = 15

" Open automaticly when vim is uploaded
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
  autocmd VimEnter * wincmd l 
augroup END

" close the netrw when is the only onw open
aug netrw_close
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
aug END
""----------------------------------------------------------------

""------------------------------Easy indents-----------------------------
" need adjustment - multiple times acting like [[ and ]]
nmap <leader>[ <<
nmap <leader>] >>
vmap <leader>[ <gv
vmap <leader>] >gv
""----------------------------------------------------------------

""------------------------------Snipping-----------------------------
" Pyhton loop snipping
nnoremap \pl :-1read $HOME/.vim/.skeleton.python.loop<CR>f(a
""----------------------------------------------------------------
