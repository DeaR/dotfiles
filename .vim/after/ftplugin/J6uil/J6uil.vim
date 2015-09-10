" Ftplugin for J6uil
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  10-Sep-2015.
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

function! s:del_count()
  if v:count == 0
    return ''
  endif

  let ret = ''
  for i in range(len(v:count))
    let ret .= "\<Del>"
  endfor
  return ret
endfunction

function! s:j()
  let max = line('$')
  let cur = line('.')
  let pos = cur + v:count1
  let pos = pos > max ? max : pos
  while pos < max && getline(pos) =~# '^-\+$'
    let pos = pos + 1
  endwhile
  return s:del_count() . pos . 'G'
endfunction
nnoremap <buffer><silent><expr> j <SID>j()
xnoremap <buffer><silent><expr> j <SID>j()
onoremap <buffer><silent><expr> j <SID>j()

function! s:k()
  let min = 1
  let cur = line('.')
  let pos = cur - v:count1
  let pos = pos < min ? min : pos
  while pos > min && getline(pos) =~# '^-\+$'
    let pos = pos - 1
  endwhile
  return s:del_count() . pos . 'G'
endfunction
nnoremap <buffer><silent><expr> k <SID>k()
xnoremap <buffer><silent><expr> k <SID>k()
onoremap <buffer><silent><expr> k <SID>k()

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "nunmap <buffer> <Space>" |
\ silent! execute "nunmap <buffer> R" |
\ silent! execute "nunmap <buffer> D" |
\ silent! execute "nunmap <buffer> r" |
\ silent! execute "nunmap <buffer> u" |
\ silent! execute "nunmap <buffer> <CR>" |
\ silent! execute "nunmap <buffer> o" |
\ silent! execute "nunmap <buffer> j" |
\ silent! execute "xunmap <buffer> j" |
\ silent! execute "ounmap <buffer> j" |
\ silent! execute "nunmap <buffer> k" |
\ silent! execute "xunmap <buffer> k" |
\ silent! execute "ounmap <buffer> k"'

let &cpo = s:save_cpo
unlet s:save_cpo
