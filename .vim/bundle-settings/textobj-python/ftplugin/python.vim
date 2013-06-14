" -*- mode: vimrc; coding: unix -*-

" @name        python.vim
" @description TextObj Python ftplugin for Python
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:11 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aF <Plug>(textobj-python-function-a)
xmap <buffer> aF <Plug>(textobj-python-function-a)
omap <buffer> aC <Plug>(textobj-python-class-a)
xmap <buffer> aC <Plug>(textobj-python-class-a)
omap <buffer> iF <Plug>(textobj-python-function-i)
xmap <buffer> iF <Plug>(textobj-python-function-i)
omap <buffer> iC <Plug>(textobj-python-class-i)
xmap <buffer> iC <Plug>(textobj-python-class-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aF|
  \ silent! xunmap <buffer> aF|
  \ silent! ounmap <buffer> iC|
  \ silent! xunmap <buffer> iC|
  \ silent! ounmap <buffer> aF|
  \ silent! xunmap <buffer> aF|
  \ silent! ounmap <buffer> iC|
  \ silent! xunmap <buffer> iC'

let &cpo = s:save_cpo
unlet s:save_cpo
