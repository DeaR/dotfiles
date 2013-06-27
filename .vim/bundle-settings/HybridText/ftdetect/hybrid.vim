" -*- mode: vimrc; coding: unix -*-

" @name        hybrid.vim
" @description FileType detects for HybridText
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-27 20:05:07 DeaR>

autocmd BufNewFile,BufRead *
  \ if bufname('%') != '' && &filetype == '' |
  \   setfiletype text |
  \ endif
