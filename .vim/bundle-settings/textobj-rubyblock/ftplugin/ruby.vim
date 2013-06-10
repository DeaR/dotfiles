" -*- mode: vimrc; coding: unix -*-

" @name        ruby.vim
" @description TextObj RubyBlock ftplugin for Ruby
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:44 DeaR>

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> ar <Plug>(textobj-rubyblock-a)
xmap <buffer> ar <Plug>(textobj-rubyblock-a)
omap <buffer> ir <Plug>(textobj-rubyblock-i)
xmap <buffer> ir <Plug>(textobj-rubyblock-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! ounmap <buffer> ar |
  \ silent! xunmap <buffer> ar |
  \ silent! ounmap <buffer> ir |
  \ silent! xunmap <buffer> ir'

let &cpo = s:save_cpo
unlet s:save_cpo
