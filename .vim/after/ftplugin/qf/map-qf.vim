" Close mapping for QuickFix
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
noremap <buffer><silent><expr> j <SID>jk(v:count1)
noremap <buffer><silent><expr> k <SID>jk(-v:count1)

function! s:del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(qf, 'r')
  execute a:firstline
endfunction
nnoremap <buffer><silent> dd :<C-U>call <SID>del_entry()<CR>
nnoremap <buffer><silent> x  :<C-U>call <SID>del_entry()<CR>
xnoremap <buffer><silent> d  :call <SID>del_entry()<CR>
xnoremap <buffer><silent> x  :call <SID>del_entry()<CR>

function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction
nnoremap <buffer><silent> u :<C-U>call <SID>undo_entry()<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> q|
  \ silent! nunmap <buffer> <S-CR>|
  \ silent! nunmap <buffer> j|
  \ silent! nunmap <buffer> k|
  \ silent! nunmap <buffer> dd|
  \ silent! nunmap <buffer> x|
  \ silent! xunmap <buffer> d|
  \ silent! xunmap <buffer> x|
  \ silent! nunmap <buffer> u'

let &cpo = s:save_cpo
unlet s:save_cpo
