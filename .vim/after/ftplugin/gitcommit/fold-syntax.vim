" -*- mode: vimrc; coding: unix -*-

" @name        fold-syntax.vim
" @description Syntax folding
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:17 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal foldmethod=syntax

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal foldmethod<'

let &cpo = s:save_cpo
unlet s:save_cpo
