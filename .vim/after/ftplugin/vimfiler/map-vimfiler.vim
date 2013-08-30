" Mapping for VimFiler
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

nmap <buffer> QQ <Plug>(vimfiler_exit)
nmap <buffer> mm <Plug>(vimfiler_move)

nmap <buffer> <SID>(vimfiler_redraw_screen) <Plug>(vimfiler_redraw_screen)
xmap <buffer> <SID>(vimfiler_redraw_screen) <Plug>(vimfiler_redraw_screen)

nnoremap <buffer><script> <C-W>=  <C-W>=<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>=  <C-W>+<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>-  <C-W>-<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>-  <C-W>-<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>+  <C-W>+<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>+  <C-W>+<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>_  <C-W>_<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>_  <C-W>_<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W><  <C-W><<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W><  <C-W><<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>>  <C-W>><SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>>  <C-W>><SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>\| <C-W>\|<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>\| <C-W>\|<SID>(vimfiler_redraw_screen)

nmap <buffer> <M-=>  <C-W>=
xmap <buffer> <M-=>  <C-W>=
nmap <buffer> <M-->  <C-W>-
xmap <buffer> <M-->  <C-W>-
nmap <buffer> <M-+>  <C-W>+
xmap <buffer> <M-+>  <C-W>+
nmap <buffer> <M-_>  <C-W>_
xmap <buffer> <M-_>  <C-W>_
nmap <buffer> <M-<>  <C-W><
xmap <buffer> <M-<>  <C-W><
nmap <buffer> <M->>  <C-W>>
xmap <buffer> <M->>  <C-W>>
nmap <buffer> <M-\|> <C-W>\|
xmap <buffer> <M-\|> <C-W>\|

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''nunmap QQ'' |
  \ silent! execute ''nunmap mm'' |
  \
  \ silent! execute ''nunmap <SID>(vimfiler_redraw_screen)'' |
  \ silent! execute ''xunmap <SID>(vimfiler_redraw_screen)'' |
  \
  \ silent! execute ''nunmap <C-W>='' |
  \ silent! execute ''xunmap <C-W>='' |
  \ silent! execute ''nunmap <C-W>-'' |
  \ silent! execute ''xunmap <C-W>-'' |
  \ silent! execute ''nunmap <C-W>+'' |
  \ silent! execute ''xunmap <C-W>+'' |
  \ silent! execute ''nunmap <C-W>_'' |
  \ silent! execute ''xunmap <C-W>_'' |
  \ silent! execute ''nunmap <C-W><'' |
  \ silent! execute ''xunmap <C-W><'' |
  \ silent! execute ''nunmap <C-W>>'' |
  \ silent! execute ''xunmap <C-W>>'' |
  \ silent! execute ''nunmap <C-W>\|'' |
  \ silent! execute ''xunmap <C-W>\|'' |
  \
  \ silent! execute ''nunmap <M-=>'' |
  \ silent! execute ''xunmap <M-=>'' |
  \ silent! execute ''nunmap <M-->'' |
  \ silent! execute ''xunmap <M-->'' |
  \ silent! execute ''nunmap <M-+>'' |
  \ silent! execute ''xunmap <M-+>'' |
  \ silent! execute ''nunmap <M-_>'' |
  \ silent! execute ''xunmap <M-_>'' |
  \ silent! execute ''nunmap <M-<>'' |
  \ silent! execute ''xunmap <M-<>'' |
  \ silent! execute ''nunmap <M->>'' |
  \ silent! execute ''xunmap <M->>'' |
  \ silent! execute ''nunmap <M-\|>'' |
  \ silent! execute ''xunmap <M-\'' |>'

let &cpo = s:save_cpo
unlet s:save_cpo
