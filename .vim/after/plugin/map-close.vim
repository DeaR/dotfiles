" -*- mode: vimrc; coding: unix -*-

" @name        map-close.vim
" @description Close mapping for Fixed-buffer
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-05-30 12:39:34 DeaR>

if exists('g:loaded_map_close')
  finish
endif
let g:loaded_map_close = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

augroup Map_Close
  autocmd FileType *
    \ if (&readonly || !&modifiable) && !hasmapto('q', 'n') |
    \   nnoremap <buffer><silent> q :<C-U>call <SID>smart_close()<CR>|
    \ endif
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
