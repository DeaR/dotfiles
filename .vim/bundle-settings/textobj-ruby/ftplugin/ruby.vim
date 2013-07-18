" -*- mode: vimrc; coding: unix -*-

" @name        ruby.vim
" @description TextObj Ruby ftplugin for Ruby
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:09:04 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> ar <Plug>(textobj-ruby-any-a)
xmap <buffer> ar <Plug>(textobj-ruby-any-a)
omap <buffer> ir <Plug>(textobj-ruby-any-i)
xmap <buffer> ir <Plug>(textobj-ruby-any-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> ar|
  \ silent! xunmap <buffer> ar|
  \ silent! ounmap <buffer> ir|
  \ silent! xunmap <buffer> ir'

let &cpo = s:save_cpo
unlet s:save_cpo
