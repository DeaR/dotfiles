" Mapping for Unite
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  30-Aug-2013.
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

silent! iunmap <buffer> <Tab>
silent! iunmap <buffer> <S-Tab>

nmap <buffer> QQ    <Plug>(unite_all_exit)
nmap <buffer> <C-J> <Plug>(unite_choose_action)
imap <buffer> <C-J> <Plug>(unite_choose_action)
imap <buffer> <M-H> <Plug>(unite_move_head)
imap <buffer> <M-j> <Plug>(unite_select_next_line)
imap <buffer> <M-k> <Plug>(unite_select_previous_line)

nnoremap <buffer><silent><expr> <C-S> unite#do_action('split')
inoremap <buffer><silent><expr> <C-S> unite#do_action('split')
nnoremap <buffer><silent><expr> <C-V> unite#do_action('vsplit')
inoremap <buffer><silent><expr> <C-V> unite#do_action('vsplit')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''nunmap <buffer> QQ'' |
  \ silent! execute ''nunmap <buffer> <C-J>'' |
  \ silent! execute ''iunmap <buffer> <C-J>'' |
  \ silent! execute ''iunmap <buffer> <M-H>'' |
  \ silent! execute ''iunmap <buffer> <M-j>'' |
  \ silent! execute ''iunmap <buffer> <M-k>'' |
  \
  \ silent! execute ''nunmap <buffer> <C-S>'' |
  \ silent! execute ''iunmap <buffer> <C-S>'' |
  \ silent! execute ''nunmap <buffer> <C-V>'' |
  \ silent! execute ''iunmap <buffer> <C-V>'''

let &cpo = s:save_cpo
unlet s:save_cpo
