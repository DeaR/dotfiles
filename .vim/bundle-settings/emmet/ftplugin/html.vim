" -*- mode: vimrc; coding: unix -*-

" @name        html.vim
" @description Emmet ftplugin for HTML
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-06 20:07:48 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal omnifunc=emmet#CompleteTag

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal omnifunc<'

let &cpo = s:save_cpo
unlet s:save_cpo
