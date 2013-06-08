" -*- mode: vimrc; coding: unix -*-

" @name        perl.vim
" @description PerlOmni ftplugin for Perl
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:44 DeaR>

let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ setlocal omnifunc<'

let &cpo = s:save_cpo
unlet s:save_cpo
