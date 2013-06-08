" -*- mode: vimrc; coding: unix -*-

" @name        indent-space2.vim
" @description Indantation of 2 spaces
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal shiftwidth< softtabstop< expandtab<'

let &cpo = s:save_cpo
unlet s:save_cpo
