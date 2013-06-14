" -*- mode: vimrc; coding: unix -*-

" @name        textobj-php.vim
" @description TextObj PHP ftplugin for PHP
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:11 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aP  <Plug>(textobj-php-phptag-a)
xmap <buffer> aP  <Plug>(textobj-php-phptag-a)
omap <buffer> aap <Plug>(textobj-php-phparray-a)
xmap <buffer> aap <Plug>(textobj-php-phparray-a)
omap <buffer> iP  <Plug>(textobj-php-phptag-i)
xmap <buffer> iP  <Plug>(textobj-php-phptag-i)
omap <buffer> iap <Plug>(textobj-php-phparray-i)
xmap <buffer> iap <Plug>(textobj-php-phparray-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aP|
  \ silent! xunmap <buffer> aP|
  \ silent! ounmap <buffer> iaP|
  \ silent! xunmap <buffer> iaP|
  \ silent! ounmap <buffer> aP|
  \ silent! xunmap <buffer> aP|
  \ silent! ounmap <buffer> iaP|
  \ silent! xunmap <buffer> iaP'

let &cpo = s:save_cpo
unlet s:save_cpo
