" -*- mode: vimrc; coding: unix -*-

" @name        zsh.vim
" @description TextObj Continuous Line ftplugin for Zsh
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:09 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> av <Plug>(textobj-continuous-cpp-a)
xmap <buffer> av <Plug>(textobj-continuous-cpp-a)
omap <buffer> iv <Plug>(textobj-continuous-cpp-i)
xmap <buffer> iv <Plug>(textobj-continuous-cpp-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> av|
  \ silent! xunmap <buffer> av|
  \ silent! ounmap <buffer> iv|
  \ silent! xunmap <buffer> iv'

let &cpo = s:save_cpo
unlet s:save_cpo
