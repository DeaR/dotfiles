" -*- mode: vimrc; coding: unix -*-

" @name        vbnet.vim
" @description Filetype detects for VB.NET
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:52:29 DeaR>

autocmd BufNewFile,BufRead *.vb
  \ setlocal filetype=vbnet
