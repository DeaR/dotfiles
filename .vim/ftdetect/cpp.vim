" -*- mode: vimrc; coding: unix -*-

" @name        cpp.vim
" @description Filetype detects for C++
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:49:50 DeaR>

autocmd BufNewFile,BufRead *.c
  \ setlocal filetype=cpp
