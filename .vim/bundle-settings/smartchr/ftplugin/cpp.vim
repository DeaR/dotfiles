" -*- mode: vimrc; coding: unix -*-

" @name        cpp.vim
" @description SmartChr ftplugin for C++
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-10 19:02:10 DeaR>

let s:save_cpo = &cpo
set cpo&vim

inoremap <buffer><expr> /
  \ search('\V */\? \%#', 'bcnW') ?
  \   smartchr#one_of(' * ', '*/<C-F>') :
  \   search('\V*\%#', 'bcnW') ?
  \     smartchr#one_of('*', '*/<C-F>') :
  \     smartchr#one_of(' / ', '// ', '/// ', '/')

inoremap <buffer><expr> : smartchr#one_of(' : ', '::', ':')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> /|
  \ silent! iunmap <buffer> :'

let &cpo = s:save_cpo
unlet s:save_cpo
