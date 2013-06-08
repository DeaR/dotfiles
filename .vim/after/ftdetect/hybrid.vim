" -*- mode: vimrc; coding: unix -*-

" @name        hybrid.vim
" @description Filetype detects for HybridText
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-05-28 02:25:28 DeaR>

autocmd BufNewFile,BufRead *
  \ if bufname('%') != '' && &filetype == '' |
  \   setfiletype hybrid |
  \ endif
