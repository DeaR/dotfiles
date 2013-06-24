" -*- mode: vimrc; coding: unix -*-

" @name        vimrc.vim
" @description QuickRun ftplugins for vimrc
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-25 02:32:12 DeaR>

if expand('%:t') !~? '^\.\?g\?vimrc'
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <F5> :<C-U>source % \| edit %<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> <F5>'

let &cpo = s:save_cpo
unlet s:save_cpo
