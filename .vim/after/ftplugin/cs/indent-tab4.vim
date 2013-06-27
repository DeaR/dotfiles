" -*- mode: vimrc; coding: unix -*-

" @name        indent-tab4.vim
" @description Indantation of tab(4)
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-27 19:34:10 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
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
