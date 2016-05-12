" Ftplugin for J6uil
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  12-May-2016.
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
nmap <buffer> <CR>    <Plug>(J6uil_action_enter)
nmap <buffer> o       <Plug>(J6uil_action_open_links)

function! s:echo_members()
  echo join(map(
  \ copy(b:J6uil_roster.members),
  \ '(v:val.is_online ? "+ " : "  ") . ' .
  \ '(v:val.is_owner ? "★ " : "") . ' .
  \ 'v:val.name'), "\n")
endfunction
nmap <buffer> u :<C-U>call <SID>echo_members()<CR>

function! s:del_count()
  return v:count > 0 ? repeat("\<Del>", len(v:count)) : ''
endfunction
function! s:jk(count)
  let pos = line('.')
  let max = line('$')
  let add = a:count > 0 ? 1 : -1
  for i in range(abs(a:count))
    let pos += add
    while getline(pos) =~# '^-\+$'
      let pos += add
    endwhile
  endfor

  if pos < 1
    let pos = 1
  elseif pos > max
    let pos = max
  endif

  let cur = line('.')
  return
  \ pos > cur ? (s:del_count() . (pos - cur) . 'j') :
  \ cur > pos ? (s:del_count() . (cur - pos) . 'k') :
  \ a:count > 0 ? 'j' : 'k'
endfunction
nnoremap <buffer><expr> <Down> <SID>jk(v:count1)
onoremap <buffer><expr> <Down> <SID>jk(v:count1)
xnoremap <buffer><expr> <Down> <SID>jk(v:count1)
nnoremap <buffer><expr> <Up>   <SID>jk(-v:count1)
onoremap <buffer><expr> <Up>   <SID>jk(-v:count1)
xnoremap <buffer><expr> <Up>   <SID>jk(-v:count1)
nnoremap <buffer><expr> j      <SID>jk(v:count1)
onoremap <buffer><expr> j      <SID>jk(v:count1)
xnoremap <buffer><expr> j      <SID>jk(v:count1)
nnoremap <buffer><expr> k      <SID>jk(-v:count1)
onoremap <buffer><expr> k      <SID>jk(-v:count1)
xnoremap <buffer><expr> k      <SID>jk(-v:count1)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "nunmap <buffer> <Space>" |
\ silent! execute "nunmap <buffer> R" |
\ silent! execute "nunmap <buffer> D" |
\ silent! execute "nunmap <buffer> u" |
\ silent! execute "nunmap <buffer> <CR>" |
\ silent! execute "nunmap <buffer> o" |
\ silent! execute "nunmap <buffer> <Down>" |
\ silent! execute "ounmap <buffer> <Down>" |
\ silent! execute "xunmap <buffer> <Down>" |
\ silent! execute "nunmap <buffer> <Up>" |
\ silent! execute "ounmap <buffer> <Up>" |
\ silent! execute "xunmap <buffer> <Up>" |
\ silent! execute "nunmap <buffer> j" |
\ silent! execute "ounmap <buffer> j" |
\ silent! execute "xunmap <buffer> j" |
\ silent! execute "nunmap <buffer> k" |
\ silent! execute "ounmap <buffer> k" |
\ silent! execute "xunmap <buffer> k"'

let &cpo = s:save_cpo
unlet s:save_cpo
