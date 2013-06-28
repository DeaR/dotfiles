" -*- mode: vimrc; coding: unix -*-

" @name        z80.vim
" @description Filetype detects for Z80
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:50:52 DeaR>

autocmd BufNewFile,BufRead *.z80
  \ setfiletype z80
