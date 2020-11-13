" bind jj to escape
imap jj <ESC>

" show numbers
set number

" We're probably using a dark background
set background=dark

" I like seeing whitespace
set list
set listchars=tab:>-,space:·,trail:~

" Colors are nice
syntax on

" Set column indicator at 80, 120 and change it to light gray color
set colorcolumn=80
highlight ColorColumn ctermbg=5

" Tabs to spaces
set softtabstop=0 tabstop=4 expandtab shiftwidth=4 smarttab

" Different cursors for insert and normal modes

" steady bar for cursor in insert mode
let &t_SI = "\e[6 q"
" steady block for cursor otherwise
let &t_EI = "\e[2 q"
" Reset the cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Ps = 0  -> blinking block.
" Ps = 1  -> blinking block (default).
" Ps = 2  -> steady block.
" Ps = 3  -> blinking underline.
" Ps = 4  -> steady underline.
" Ps = 5  -> blinking bar (xterm).
" Ps = 6  -> steady bar (xterm).

