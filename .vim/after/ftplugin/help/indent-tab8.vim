" -*- mode: vimrc; coding: unix -*-

" @name        indent-tab8.vim
" @description Indantation of tab(8)
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal shiftwidth=8
setlocal tabstop=8
setlocal softtabstop=8
setlocal noexpandtab

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal shiftwidth< tabstop< softtabstop< expandtab<'

let &cpo = s:save_cpo
unlet s:save_cpo
