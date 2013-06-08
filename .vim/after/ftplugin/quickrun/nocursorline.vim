" -*- mode: vimrc; coding: unix -*-

" @name        nocursorline.vim
" @description No CursorLine
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

let b:nocursorline = 1
setlocal nocursorline

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal cursorline< |
  \ unlet! b:nocursorline'

let &cpo = s:save_cpo
unlet s:save_cpo
