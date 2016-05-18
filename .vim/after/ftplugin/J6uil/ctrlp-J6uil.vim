" CtrlP J6uil
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  18-May-2016.
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

if !exists(':CtrlPJ6uilRooms') && !exists(':CtrlPJ6uilMembers') &&
\ empty(exists('*dein#get') ? dein#get('ctrlp-J6uil') : 0)
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> r :<C-U>CtrlPJ6uilRooms<CR>
nnoremap <buffer> u :<C-U>CtrlPJ6uilMembers<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "nunmap <buffer> r" |
\ silent! execute "nunmap <buffer> u"'

let &cpo = s:save_cpo
unlet s:save_cpo
