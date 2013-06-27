" -*- mode: vimrc; coding: unix -*-

" @name        hybrid.vim
" @description Syntax setting for HybridText
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-27 20:39:04 DeaR>

if exists('g:loaded_hybrid_syntax')
  finish
endif
let g:loaded_hybrid_syntax = 1

let s:save_cpo = &cpo
set cpo&vim

augroup HybridText_Syntax
  autocmd!
  autocmd FileType text
    \ setlocal syntax=hybrid
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
