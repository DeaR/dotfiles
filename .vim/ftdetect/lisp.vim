" -*- mode: vimrc; coding: unix -*-

" @name        lisp.vim
" @description Filetype detects for Lisp
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:51:41 DeaR>

autocmd BufNewFile,BufRead *.l,.xyzzy
  \ setlocal filetype=lisp
