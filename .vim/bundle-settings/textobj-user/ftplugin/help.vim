" Text Object for Help
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  27-Sep-2013.
" License:      MIT License {{{
"     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
"
"     Permission is hereby granted, free of charge, to any person obtaining a
"     copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to permit
"     persons to whom the Software is furnished to do so, subject to the
"     following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
"     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
"     THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

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

nmap <buffer> <C-J> <Plug>(textobj-help-any-n)zvzz
xmap <buffer> <C-J> <Plug>(textobj-help-any-n)zvzz
omap <buffer> <C-J> <Plug>(textobj-help-any-n)zvzz
nmap <buffer> <C-K> <Plug>(textobj-help-any-p)zvzz
xmap <buffer> <C-K> <Plug>(textobj-help-any-p)zvzz
omap <buffer> <C-K> <Plug>(textobj-help-any-p)zvzz

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''unmap <buffer> <LocalLeader>j'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>k'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>J'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>K'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>f'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>r'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>F'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>R'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>d'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>e'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>D'' |
  \ silent! execute ''unmap <buffer> <LocalLeader>E'' |
  \ silent! execute ''nunmap <buffer> <C-J>'' |
  \ silent! execute ''xunmap <buffer> <C-J>'' |
  \ silent! execute ''ounmap <buffer> <C-J>'' |
  \ silent! execute ''nunmap <buffer> <C-K>'' |
  \ silent! execute ''xunmap <buffer> <C-K>'' |
  \ silent! execute ''ounmap <buffer> <C-K>'''

let &cpo = s:save_cpo
unlet s:save_cpo
