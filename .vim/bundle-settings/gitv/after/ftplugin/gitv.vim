" -*- mode: vimrc; coding: unix -*-

" @name        gitv.vim
" @description Gitv ftplugin for Gitv
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:36:57 DeaR>

let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal foldmarker< foldexpr< foldtext< foldlevel<'

let &cpo = s:save_cpo
unlet s:save_cpo
