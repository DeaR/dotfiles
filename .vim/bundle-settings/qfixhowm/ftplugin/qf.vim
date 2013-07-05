" -*- mode: vimrc; coding: unix -*-

" @name        qf.vim
" @description Close mapping for QuickFix
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-05 14:45:11 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> q :<C-U>CloseQFixWin<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> q'

let &cpo = s:save_cpo
unlet s:save_cpo
