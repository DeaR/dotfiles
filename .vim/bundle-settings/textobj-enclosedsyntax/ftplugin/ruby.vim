" -*- mode: vimrc; coding: unix -*-

" @name        ruby.vim
" @description TextObj EnclosedSyntax ftplugin for Ruby
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:09:43 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aq <Plug>(textobj-enclosedsyntax-a)
xmap <buffer> aq <Plug>(textobj-enclosedsyntax-a)
omap <buffer> iq <Plug>(textobj-enclosedsyntax-i)
xmap <buffer> iq <Plug>(textobj-enclosedsyntax-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aq|
  \ silent! xunmap <buffer> aq|
  \ silent! ounmap <buffer> iq|
  \ silent! xunmap <buffer> iq'

let &cpo = s:save_cpo
unlet s:save_cpo
