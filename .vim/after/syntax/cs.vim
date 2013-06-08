" -*- mode: vimrc; coding: unix -*-

" @name        cs.vim
" @description Syntax settings for C#
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-05-29 18:43:10 DeaR>

let s:save_cpo = &cpo
set cpo&vim

" Linq Keywords
syntax keyword csLinq  from where select group into orderby join let in on equals by ascending descending

" Async Keywords
syntax keyword csAsync async await

highlight def link csLinq  Keyword
highlight def link csAsync Keyword

let &cpo = s:save_cpo
unlet s:save_cpo
