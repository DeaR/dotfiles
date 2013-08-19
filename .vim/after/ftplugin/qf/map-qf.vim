" Close mapping for QuickFix
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  19-Aug-2013.
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

nnoremap <buffer> q      :<C-U>cclose<CR>
nnoremap <buffer> <S-CR> <CR>zz<C-W>p

function! s:jk(motion)
  let max = line('$')
  let list = getloclist(0)
  if empty(list) || len(list) != max
    let list = getqflist()
  endif
  let cur = line('.') - 1
  let pos = (cur + a:motion + max) % max
  let m = 0 < a:motion ? 1 : -1
  while cur != pos && list[pos].bufnr == 0
    let pos = (pos + m + max) % max
  endwhile
  return (pos + 1) . 'G'
endfunction
nnoremap <buffer><silent><expr> j <SID>jk(v:count1)
xnoremap <buffer><silent><expr> j <SID>jk(v:count1)
onoremap <buffer><silent><expr> j <SID>jk(v:count1)
nnoremap <buffer><silent><expr> k <SID>jk(-v:count1)
xnoremap <buffer><silent><expr> k <SID>jk(-v:count1)
onoremap <buffer><silent><expr> k <SID>jk(-v:count1)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''nunmap <buffer> q'' |
  \ silent! execute ''nunmap <buffer> <S-CR>'' |
  \ silent! execute ''nunmap <buffer> j'' |
  \ silent! execute ''xunmap <buffer> j'' |
  \ silent! execute ''ounmap <buffer> j'' |
  \ silent! execute ''nunmap <buffer> k'' |
  \ silent! execute ''xunmap <buffer> k'' |
  \ silent! execute ''ounmap <buffer> k'''

let &cpo = s:save_cpo
unlet s:save_cpo
