" -*- mode: vimrc; coding: unix -*-

" @name        markdown.vim
" @description Filetype detects for Markdown
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:52:02 DeaR>

autocmd BufNewFile,BufRead *.md
  \ setlocal filetype=markdown
