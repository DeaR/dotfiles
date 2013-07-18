" -*- mode: vimrc; coding: unix -*-

" @name        php.vim
" @description TextObj PHP ftplugin for PHP
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:21:58 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aa <Plug>(textobj-php-phparray-a)
xmap <buffer> aa <Plug>(textobj-php-phparray-a)
omap <buffer> ia <Plug>(textobj-php-phparray-i)
xmap <buffer> ia <Plug>(textobj-php-phparray-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aa|
  \ silent! xunmap <buffer> aa|
  \ silent! ounmap <buffer> aa|
  \ silent! xunmap <buffer> aa'

let &cpo = s:save_cpo
unlet s:save_cpo
