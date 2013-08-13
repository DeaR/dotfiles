" Text Object for Help
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  13-Aug-2013.
" License:      MIT License {{{
"     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
"
"     Permission is hereby granted, free of charge, to any person obtaining a
"     copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

map <buffer> J <Plug>(textobj-help-any-n)
map <buffer> K <Plug>(textobj-help-any-p)

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
  \ silent! unmap <buffer> J
  \ silent! unmap <buffer> K'

let &cpo = s:save_cpo
unlet s:save_cpo
