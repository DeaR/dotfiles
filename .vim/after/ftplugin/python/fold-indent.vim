" -*- mode: vimrc; coding: unix -*-

" @name        fold-indent.vim
" @description Indent folding
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:17 DeaR>

let s:save_cpo = &cpo
set cpo&vim

setlocal foldmethod=indent

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal foldmethod<'

let &cpo = s:save_cpo
unlet s:save_cpo
