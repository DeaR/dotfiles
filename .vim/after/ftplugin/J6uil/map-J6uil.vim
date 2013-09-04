" Mapping for J6uil
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  04-Sep-2013.
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

nmap <buffer> <Space> <Plug>(J6uil_open_say_buffer)
nmap <buffer> R       <Plug>(J6uil_reconnect)
nmap <buffer> D       <Plug>(J6uil_disconnect)
nmap <buffer> r       <Plug>(J6uil_unite_rooms)
nmap <buffer> u       <Plug>(J6uil_unite_members)
nmap <buffer> <CR>    <Plug>(J6uil_action_enter)
nmap <buffer> o       <Plug>(J6uil_action_open_links)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''nunmap <buffer> <Space>'' |
  \ silent! execute ''nunmap <buffer> R'' |
  \ silent! execute ''nunmap <buffer> D'' |
  \ silent! execute ''nunmap <buffer> r'' |
  \ silent! execute ''nunmap <buffer> u'' |
  \ silent! execute ''nunmap <buffer> <CR>'' |
  \ silent! execute ''nunmap <buffer> o'''

let &cpo = s:save_cpo
unlet s:save_cpo
