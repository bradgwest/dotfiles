" bind jj to escape
imap jj <ESC>

" show numbers
set number

" show the ruler
set ruler

" We're probably using a dark background
set background=dark

" View whitespace
set list
" Line below makes it annoying to copy from a vim buffer
" set listchars=tab:>-,space:·,trail:~

" Syntax hilighting is nice
syntax on

" Set column indicator at 80 and set it to a light color
set colorcolumn=80
highlight ColorColumn ctermbg=5

" Tabs to spaces
set softtabstop=0 tabstop=4 expandtab shiftwidth=4 smarttab

" Different cursor for insert mode
" https://superuser.com/a/1234770
let &t_SI="\033[4 q" " start insert mode
let &t_EI="\033[1 q" " end insert mode

