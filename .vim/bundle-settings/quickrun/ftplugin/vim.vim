" -*- mode: vimrc; coding: unix -*-

" @name        vim.vim
" @description QuickRun ftplugins for Vim
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-16 21:08:41 DeaR>

if expand('%:t') !~? '^\.\?g\?vimrc$'
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <F5> :<C-U>source % \| setlocal ft=vim<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> <F5>'

let &cpo = s:save_cpo
unlet s:save_cpo
