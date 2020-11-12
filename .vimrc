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

