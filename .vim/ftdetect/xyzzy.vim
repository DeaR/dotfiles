" -*- mode: vimrc; coding: unix -*-

" @name        xyzzy.vim
" @description Filetype detects for Xyzzy
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-08 18:24:46 DeaR>

autocmd BufNewFile,BufRead .xyzzy,.xyzzy.history
  \ setfiletype lisp
