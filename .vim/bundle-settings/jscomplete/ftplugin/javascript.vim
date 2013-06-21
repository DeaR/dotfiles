" -*- mode: vimrc; coding: unix -*-

" @name       javascript.vim
" @description JsComplete ftplugin for JavaScript
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-21 17:26:26 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal omnifunc=jscomplete#CompleteJS

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal omnifunc<'

let &cpo = s:save_cpo
unlet s:save_cpo
