" -*- mode: vimrc; coding: unix -*-

" @name        text.vim
" @description FileType detects for Default
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:48:50 DeaR>

autocmd BufNewFile,BufRead *
  \ if bufname('%') != '' && &filetype == '' |
  \   setfiletype text |
  \ endif
