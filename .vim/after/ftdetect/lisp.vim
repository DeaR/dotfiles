" -*- mode: vimrc; coding: unix -*-

" @name        lisp.vim
" @description Filetype detects for Lisp
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-08 18:23:26 DeaR>

autocmd BufNewFile,BufRead *.l
  \ setlocal filetype=lisp
