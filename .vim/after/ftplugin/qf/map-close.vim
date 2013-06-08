" -*- mode: vimrc; coding: unix -*-

" @name        map-close.vim
" @description Close mapping for Fixed-buffer
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-06 00:32:18 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction
nnoremap <buffer><silent> q :<C-U>call <SID>smart_close()<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> q'

let &cpo = s:save_cpo
unlet s:save_cpo
