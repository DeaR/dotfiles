" -*- mode: vimrc; coding: unix -*-

" @name        go.vim
" @description Golang ftplugin for Go
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-10 20:03:27 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nmap <buffer> K <Plug>(godoc-keyword)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> K|
  \
  \ delcommand Fmt |
  \ silent! unlet b:did_ftplugin_go_fmt |
  \
  \ delcommand Drop |
  \ delcommand Import |
  \ delcommand ImportAs |
  \ silent! unmap <buffer> <LocalLeader>f|
  \ silent! unmap <buffer> <LocalLeader>F|
  \ unlet b:did_ftplugin_go_import'

let &cpo = s:save_cpo
unlet s:save_cpo
