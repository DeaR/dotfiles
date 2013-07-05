" -*- mode: vimrc; coding: unix -*-

" @name        iabbrev.vim
" @description Abbreviations for VimShell
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-05 15:12:36 DeaR>

let s:save_cpo = &cpo
set cpo&vim

iabbrev <buffer> L \| less
if executable('head')
  iabbrev <buffer> H \| head
endif
if executable('tailf')
  iabbrev <buffer> T \| tailf
elseif executable('tail')
  iabbrev <buffer> T \| tail
endif
if executable('grep')
  iabbrev <buffer> G \| grep
endif
if executable('sort')
  iabbrev <buffer> S \| sort
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ iabbrev L|
  \ iabbrev H|
  \ iabbrev T|
  \ iabbrev G|
  \ iabbrev S'

let &cpo = s:save_cpo
unlet s:save_cpo
