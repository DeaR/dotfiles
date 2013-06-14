" -*- mode: vimrc; coding: unix -*-

" @name        c.vim
" @description TextObj Function ftplugin for C
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:09 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aF <Plug>(textobj-function-a)
xmap <buffer> aF <Plug>(textobj-function-a)
omap <buffer> iF <Plug>(textobj-function-i)
xmap <buffer> iF <Plug>(textobj-function-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aF|
  \ silent! xunmap <buffer> aF|
  \ silent! ounmap <buffer> iF|
  \ silent! xunmap <buffer> iF'

let &cpo = s:save_cpo
unlet s:save_cpo
