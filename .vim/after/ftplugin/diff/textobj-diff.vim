" Text Object Diff
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  28-Apr-2016.
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

if !exists('g:loaded_textobj_diff') &&
\ empty(exists('*dein#get') ? dein#get('textobj-diff') : 0)
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

try
  call submode#enter_with(
  \ 'to-diff/h', 'nx', 'br', '[c', '<Plug>(textobj-diff-hunk-p)')
  call submode#enter_with(
  \ 'to-diff/h', 'nx', 'br', ']c', '<Plug>(textobj-diff-hunk-n)')
  call submode#map(
  \ 'to-diff/h', 'nx', 'br', '[',  '<Plug>(textobj-diff-hunk-p)')
  call submode#map(
  \ 'to-diff/h', 'nx', 'br', ']',  '<Plug>(textobj-diff-hunk-n)')

  call submode#enter_with(
  \ 'to-diff/H', 'nx', 'br', '[C', '<Plug>(textobj-diff-hunk-P)')
  call submode#enter_with(
  \ 'to-diff/H', 'nx', 'br', ']C', '<Plug>(textobj-diff-hunk-N)')
  call submode#map(
  \ 'to-diff/H', 'nx', 'br', '[',  '<Plug>(textobj-diff-hunk-P)')
  call submode#map(
  \ 'to-diff/H', 'nx', 'br', ']',  '<Plug>(textobj-diff-hunk-N)')

  call submode#enter_with(
  \ 'to-diff/f', 'nx', 'br', '[<M-c>', '<Plug>(textobj-diff-file-p)')
  call submode#enter_with(
  \ 'to-diff/f', 'nx', 'br', ']<M-c>', '<Plug>(textobj-diff-file-n)')
  call submode#map(
  \ 'to-diff/f', 'nx', 'br', '[',  '<Plug>(textobj-diff-file-p)')
  call submode#map(
  \ 'to-diff/f', 'nx', 'br', ']',  '<Plug>(textobj-diff-file-n)')

  call submode#enter_with(
  \ 'to-diff/F', 'nx', 'br', '[<M-C>', '<Plug>(textobj-diff-file-P)')
  call submode#enter_with(
  \ 'to-diff/F', 'nx', 'br', ']<M-C>', '<Plug>(textobj-diff-file-N)')
  call submode#map(
  \ 'to-diff/F', 'nx', 'br', '[',  '<Plug>(textobj-diff-file-P)')
  call submode#map(
  \ 'to-diff/F', 'nx', 'br', ']',  '<Plug>(textobj-diff-file-N)')
catch
  nmap <buffer> [c <Plug>(textobj-diff-hunk-p)
  xmap <buffer> [c <Plug>(textobj-diff-hunk-p)
  nmap <buffer> ]c <Plug>(textobj-diff-hunk-n)
  xmap <buffer> ]c <Plug>(textobj-diff-hunk-n)
  nmap <buffer> [C <Plug>(textobj-diff-hunk-P)
  xmap <buffer> [C <Plug>(textobj-diff-hunk-P)
  nmap <buffer> ]C <Plug>(textobj-diff-hunk-N)
  xmap <buffer> ]C <Plug>(textobj-diff-hunk-N)

  nmap <buffer> [<M-c> <Plug>(textobj-diff-file-p)
  xmap <buffer> [<M-c> <Plug>(textobj-diff-file-p)
  nmap <buffer> ]<M-c> <Plug>(textobj-diff-file-n)
  xmap <buffer> ]<M-c> <Plug>(textobj-diff-file-n)
  nmap <buffer> [<M-C> <Plug>(textobj-diff-file-P)
  xmap <buffer> [<M-C> <Plug>(textobj-diff-file-P)
  nmap <buffer> ]<M-C> <Plug>(textobj-diff-file-N)
  xmap <buffer> ]<M-C> <Plug>(textobj-diff-file-N)
endtry

omap <buffer> [c <Plug>(textobj-diff-hunk-p)
omap <buffer> ]c <Plug>(textobj-diff-hunk-n)
omap <buffer> [C <Plug>(textobj-diff-hunk-P)
omap <buffer> ]C <Plug>(textobj-diff-hunk-N)

omap <buffer> [<M-c> <Plug>(textobj-diff-file-p)
omap <buffer> ]<M-c> <Plug>(textobj-diff-file-n)
omap <buffer> [<M-C> <Plug>(textobj-diff-file-P)
omap <buffer> ]<M-C> <Plug>(textobj-diff-file-N)

onoremap <buffer> ad <Nop>
xnoremap <buffer> ad <Nop>
xmap <buffer> adh <Plug>(textobj-diff-hunk)
omap <buffer> adh <Plug>(textobj-diff-hunk)
xmap <buffer> adf <Plug>(textobj-diff-file)
omap <buffer> adf <Plug>(textobj-diff-file)

onoremap <buffer> id <Nop>
xnoremap <buffer> id <Nop>
xmap <buffer> idh <Plug>(textobj-diff-hunk)
omap <buffer> idh <Plug>(textobj-diff-hunk)
xmap <buffer> idf <Plug>(textobj-diff-file)
omap <buffer> idf <Plug>(textobj-diff-file)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! call submode#unmap("to-diff/h", "nx", "br", "[c") |
\ silent! call submode#unmap("to-diff/h", "nx", "br", "]c") |
\ silent! call submode#unmap("to-diff/H", "nx", "br", "[C") |
\ silent! call submode#unmap("to-diff/H", "nx", "br", "]C") |
\
\ silent! call submode#unmap("to-diff/f", "nx", "br", "[<M-c>") |
\ silent! call submode#unmap("to-diff/f", "nx", "br", "]<M-c>") |
\ silent! call submode#unmap("to-diff/F", "nx", "br", "[<M-C>") |
\ silent! call submode#unmap("to-diff/F", "nx", "br", "]<M-C>") |
\
\ silent! execute "nunmap <buffer> [c" |
\ silent! execute "ounmap <buffer> [c" |
\ silent! execute "xunmap <buffer> [c" |
\ silent! execute "nunmap <buffer> ]c" |
\ silent! execute "ounmap <buffer> ]c" |
\ silent! execute "xunmap <buffer> ]c" |
\ silent! execute "nunmap <buffer> [C" |
\ silent! execute "ounmap <buffer> [C" |
\ silent! execute "xunmap <buffer> [C" |
\ silent! execute "nunmap <buffer> ]C" |
\ silent! execute "ounmap <buffer> ]C" |
\ silent! execute "xunmap <buffer> ]C" |
\
\ silent! execute "nunmap <buffer> [<M-c>" |
\ silent! execute "ounmap <buffer> [<M-c>" |
\ silent! execute "xunmap <buffer> [<M-c>" |
\ silent! execute "nunmap <buffer> ]<M-c>" |
\ silent! execute "ounmap <buffer> ]<M-c>" |
\ silent! execute "xunmap <buffer> ]<M-c>" |
\ silent! execute "nunmap <buffer> [<M-C>" |
\ silent! execute "ounmap <buffer> [<M-C>" |
\ silent! execute "xunmap <buffer> [<M-C>" |
\ silent! execute "nunmap <buffer> ]<M-C>" |
\ silent! execute "ounmap <buffer> ]<M-C>" |
\ silent! execute "xunmap <buffer> ]<M-C>" |
\
\ silent! execute "ounmap <buffer> ad" |
\ silent! execute "xunmap <buffer> ad" |
\ silent! execute "ounmap <buffer> adf" |
\ silent! execute "xunmap <buffer> adf" |
\ silent! execute "ounmap <buffer> adh" |
\ silent! execute "xunmap <buffer> adh" |
\
\ silent! execute "ounmap <buffer> id"|
\ silent! execute "xunmap <buffer> id"|
\ silent! execute "ounmap <buffer> idf" |
\ silent! execute "xunmap <buffer> idf" |
\ silent! execute "ounmap <buffer> idh" |
\ silent! execute "xunmap <buffer> idh"'

let &cpo = s:save_cpo
unlet s:save_cpo
