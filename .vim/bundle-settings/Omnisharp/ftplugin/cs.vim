" -*- mode: vimrc; coding: unix -*-

" @name        cs.vim
" @description OmniSharp ftplugin for C#
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:44 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> <F5>    :<C-U>wall!<CR>:OmniSharpBuild<CR>
nnoremap <buffer> <Space> :<C-U>OmniSharpGetCodeActions<CR>
nnoremap <buffer> gd      :<C-U>OmniSharpGotoDefinition<CR>
nnoremap <buffer> gD      :<C-U>OmniSharpFindImplementations<CR>

nnoremap <buffer> <LocalLeader>c :<C-U>OmniSharpCodeFormat<CR>
nnoremap <buffer> <LocalLeader>g :<C-U>OmniSharpFindUsages<CR>
nnoremap <buffer> <LocalLeader>t :<C-U>OmniSharpTypeLookup<CR>
nnoremap <buffer> <LocalLeader>r :<C-U>OmniSharpRename<CR>

nnoremap <buffer> <LocalLeader>a :<C-U>OmniSharpAddToProject<CR>
nnoremap <buffer> <LocalLeader>A :<C-U>OmniSharpAddReference<Space>
nnoremap <buffer> <LocalLeader>s :<C-U>OmniSharpStartServer<CR>
nnoremap <buffer> <LocalLeader>S :<C-U>OmniSharpStopServer<CR>
nnoremap <buffer> <LocalLeader>R :<C-U>OmniSharpReloadSolution<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> <F5> |
  \ silent! nunmap <buffer> <Space> |
  \ silent! nunmap <buffer> gd |
  \ silent! nunmap <buffer> gD |
  \
  \ silent! nunmap <buffer> <LocalLeader>c |
  \ silent! nunmap <buffer> <LocalLeader>g |
  \ silent! nunmap <buffer> <LocalLeader>t |
  \ silent! nunmap <buffer> <LocalLeader>r |
  \
  \ silent! nunmap <buffer> <LocalLeader>a |
  \ silent! nunmap <buffer> <LocalLeader>A |
  \ silent! nunmap <buffer> <LocalLeader>s |
  \ silent! nunmap <buffer> <LocalLeader>S |
  \ silent! nunmap <buffer> <LocalLeader>R'

let &cpo = s:save_cpo
unlet s:save_cpo
