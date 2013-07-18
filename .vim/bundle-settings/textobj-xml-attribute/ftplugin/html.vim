" -*- mode: vimrc; coding: unix -*-

" @name        html.vim
" @description TextObj XML Attribute ftplugin for HTML
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-18 14:31:43 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> aa <Plug>(textobj-xmlattribute-xmlattribute)
xmap <buffer> aa <Plug>(textobj-xmlattribute-xmlattribute)
omap <buffer> ia <Plug>(textobj-xmlattribute-xmlattributenospace)
xmap <buffer> ia <Plug>(textobj-xmlattribute-xmlattributenospace)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> aa|
  \ silent! xunmap <buffer> aa|
  \ silent! ounmap <buffer> ia|
  \ silent! xunmap <buffer> ia'

let &cpo = s:save_cpo
unlet s:save_cpo
