" -*- mode: vimrc; coding: unix -*-

" @name        ignored_extensions.vim
" @description Filetype detects for Ignored extensions
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 15:58:58 DeaR>

autocmd BufNewFile,BufRead ?\+.org
  \ execute 'doautocmd filetypedetect BufRead' fnameescape(expand('<afile>:r'))
autocmd BufNewFile,BufRead ?\+.clean
  \ execute 'doautocmd filetypedetect BufRead' fnameescape(expand('<afile>:r:r'))
