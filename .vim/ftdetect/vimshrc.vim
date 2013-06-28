" -*- mode: vimrc; coding: unix -*-

" @name        vimshrc.vim
" @description Filetype detects for VimShell Script
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:50:42 DeaR>

autocmd BufNewFile,BufRead *.vimsh,.vimshrc
  \ setfiletype vimshrc
