" -*- mode: vimrc; coding: unix -*-

" @name        html.vim
" @description TextObj PHP ftplugin for HTML
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:20:33 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aP  <Plug>(textobj-php-phptag-a)
xmap <buffer> aP  <Plug>(textobj-php-phptag-a)
omap <buffer> iP  <Plug>(textobj-php-phptag-i)
xmap <buffer> iP  <Plug>(textobj-php-phptag-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aP|
  \ silent! xunmap <buffer> aP|
  \ silent! ounmap <buffer> aP|
  \ silent! xunmap <buffer> aP'

let &cpo = s:save_cpo
unlet s:save_cpo
