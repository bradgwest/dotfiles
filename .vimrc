" bind jj to escape
imap jj <ESC>

" show numbers
set number

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

