" -*- mode: vimrc; coding: unix -*-

" @name        map-close.vim
" @description Close mapping for Fixed-buffer
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-05 14:45:03 DeaR>

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
  autocmd!
  autocmd FileType *
    \ if (&readonly || !&modifiable) && !hasmapto('q', 'n') |
    \   nnoremap <buffer> q :<C-U>call <SID>smart_close()<CR>|
    \ endif
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
