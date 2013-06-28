" -*- mode: vimrc; coding: unix -*-

" @name        mayu.vim
" @description Filetype detects for MAYU
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:50:33 DeaR>

autocmd BufNewFile,BufRead *.mayu,*.nodoka
  \ setfiletype mayu
