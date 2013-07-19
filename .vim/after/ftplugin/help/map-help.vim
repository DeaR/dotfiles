" -*- mode: vimrc; coding: unix -*-

" @name        map-help.vim
" @description Mapping for Help
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-19 17:21:41 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <CR> <C-]>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> <CR>'

let &cpo = s:save_cpo
unlet s:save_cpo
