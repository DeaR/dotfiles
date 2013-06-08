" -*- mode: vimrc; coding: unix -*-

" @name        nocursorcolumn.vim
" @description No CursorColumn
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

let b:nocursorcolumn = 1
setlocal nocursorcolumn

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal cursorcolumn< |
  \ unlet! b:nocursorcolumn'

let &cpo = s:save_cpo
unlet s:save_cpo
