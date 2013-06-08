" -*- mode: vimrc; coding: unix -*-

" @name        help.vim
" @description Text Object for Help
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:06 DeaR>

let s:save_cpo = &cpo
set cpo&vim

let s:filetype_help_pattern_link   = '|[^ |]\+|'
let s:filetype_help_pattern_option = '''[A-Za-z0-9_-]\{2,}'''
let s:filetype_help_pattern_any    = join([
  \ s:filetype_help_pattern_link,
  \ s:filetype_help_pattern_option], '\|')

call textobj#user#plugin('help', {
  \ 'any': {
  \   '*pattern*': s:filetype_help_pattern_any,
  \   'move-n': '<buffer> <LocalLeader>j',
  \   'move-p': '<buffer> <LocalLeader>k',
  \   'move-N': '<buffer> <LocalLeader>J',
  \   'move-P': '<buffer> <LocalLeader>K'},
  \ 'link': {
  \   '*pattern*': s:filetype_help_pattern_link,
  \   'move-n': '<buffer> <LocalLeader>f',
  \   'move-p': '<buffer> <LocalLeader>r',
  \   'move-N': '<buffer> <LocalLeader>F',
  \   'move-P': '<buffer> <LocalLeader>R'},
  \ 'option': {
  \   '*pattern*': s:filetype_help_pattern_option,
  \   'move-n': '<buffer> <LocalLeader>d',
  \   'move-p': '<buffer> <LocalLeader>e',
  \   'move-N': '<buffer> <LocalLeader>D',
  \   'move-P': '<buffer> <LocalLeader>E'}})

map <buffer> <C-J> <Plug>(textobj-help-any-n)
map <buffer> <C-K> <Plug>(textobj-help-any-p)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! unmap <buffer> <LocalLeader>j
  \ silent! unmap <buffer> <LocalLeader>k
  \ silent! unmap <buffer> <LocalLeader>J
  \ silent! unmap <buffer> <LocalLeader>K
  \ silent! unmap <buffer> <LocalLeader>f
  \ silent! unmap <buffer> <LocalLeader>r
  \ silent! unmap <buffer> <LocalLeader>F
  \ silent! unmap <buffer> <LocalLeader>R
  \ silent! unmap <buffer> <LocalLeader>d
  \ silent! unmap <buffer> <LocalLeader>e
  \ silent! unmap <buffer> <LocalLeader>D
  \ silent! unmap <buffer> <LocalLeader>E
  \ silent! unmap <buffer> <C-J>
  \ silent! unmap <buffer> <C-K>'

let &cpo = s:save_cpo
unlet s:save_cpo
