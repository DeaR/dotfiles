" -*- mode: vimrc; coding: unix -*-

" @name        phpcomplete.vim
" @description PHP complete
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal omnifunc=phpcomplete#CompletePHP

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal omnifunc<'

let &cpo = s:save_cpo
unlet s:save_cpo
