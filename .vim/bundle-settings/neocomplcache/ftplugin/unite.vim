" -*- mode: vimrc; coding: unix -*-

" @name        unite.vim
" @description Unite ftplugin for NeoComplCache
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-28 20:07:31 DeaR>

let s:save_cpo = &cpo
set cpo&vim

imap <buffer> <SID>(unite_redraw) <Plug>(unite_redraw)
inoremap <buffer><script><expr> <C-L>
  \ pumvisible() ?
  \   neocomplcache#complete_common_string() :
  \   '<SID>(unite_redraw)'

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> <SID>(unite_redraw)|
  \ silent! iunmap <buffer> <C-L>'

let &cpo = s:save_cpo
unlet s:save_cpo
