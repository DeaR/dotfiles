" -*- mode: vimrc; coding: unix -*-

" @name        markdown.vim
" @description Markdown Previewer ftplugin for Markdown
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:44 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <F5> :<C-U>PrevimOpen<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> <F5>'

let &cpo = s:save_cpo
unlet s:save_cpo
