" -*- mode: vimrc; coding: unix -*-

" @name        cs.vim
" @description TextObj Ifdef ftplugin for C#
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:23:36 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> a# <Plug>(textobj-ifdef-a)
xmap <buffer> a# <Plug>(textobj-ifdef-a)
omap <buffer> a3 <Plug>(textobj-ifdef-a)
xmap <buffer> a3 <Plug>(textobj-ifdef-a)
omap <buffer> i# <Plug>(textobj-ifdef-i)
xmap <buffer> i# <Plug>(textobj-ifdef-i)
omap <buffer> i3 <Plug>(textobj-ifdef-i)
xmap <buffer> i3 <Plug>(textobj-ifdef-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> a#|
  \ silent! xunmap <buffer> a#|
  \ silent! ounmap <buffer> a3|
  \ silent! xunmap <buffer> a3|
  \ silent! ounmap <buffer> i#|
  \ silent! xunmap <buffer> i#|
  \ silent! ounmap <buffer> i3|
  \ silent! xunmap <buffer> i3'

let &cpo = s:save_cpo
unlet s:save_cpo
