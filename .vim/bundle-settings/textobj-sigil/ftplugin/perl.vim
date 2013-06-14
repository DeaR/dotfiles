" -*- mode: vimrc; coding: unix -*-

" @name        perl.vim
" @description TextObj Sigil ftplugin for Perl
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:12 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> ag <Plug>(textobj-sigil-a)
xmap <buffer> ag <Plug>(textobj-sigil-a)
omap <buffer> ig <Plug>(textobj-sigil-i)
xmap <buffer> ig <Plug>(textobj-sigil-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> ag|
  \ silent! xunmap <buffer> ag|
  \ silent! ounmap <buffer> ig|
  \ silent! xunmap <buffer> ig'

let &cpo = s:save_cpo
unlet s:save_cpo
