" Text Object Difff
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  21-Oct-2013.
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

nnoremap <buffer> <LocalLeader>f <Nop>
xnoremap <buffer> <LocalLeader>f <Nop>
onoremap <buffer> <LocalLeader>f <Nop>

nmap <buffer> <LocalLeader>fj <Plug>(textobj-diff-file-n)
xmap <buffer> <LocalLeader>fj <Plug>(textobj-diff-file-n)
omap <buffer> <LocalLeader>fj <Plug>(textobj-diff-file-n)
nmap <buffer> <LocalLeader>fk <Plug>(textobj-diff-file-p)
xmap <buffer> <LocalLeader>fk <Plug>(textobj-diff-file-p)
omap <buffer> <LocalLeader>fk <Plug>(textobj-diff-file-p)
nmap <buffer> <LocalLeader>fJ <Plug>(textobj-diff-file-N)
xmap <buffer> <LocalLeader>fJ <Plug>(textobj-diff-file-N)
omap <buffer> <LocalLeader>fJ <Plug>(textobj-diff-file-N)
nmap <buffer> <LocalLeader>fK <Plug>(textobj-diff-file-P)
xmap <buffer> <LocalLeader>fK <Plug>(textobj-diff-file-P)
omap <buffer> <LocalLeader>fK <Plug>(textobj-diff-file-P)

nmap <buffer> <LocalLeader>j <Plug>(textobj-diff-hunk-n)
xmap <buffer> <LocalLeader>j <Plug>(textobj-diff-hunk-n)
omap <buffer> <LocalLeader>j <Plug>(textobj-diff-hunk-n)
nmap <buffer> <LocalLeader>k <Plug>(textobj-diff-hunk-p)
xmap <buffer> <LocalLeader>k <Plug>(textobj-diff-hunk-p)
omap <buffer> <LocalLeader>k <Plug>(textobj-diff-hunk-p)
nmap <buffer> <LocalLeader>J <Plug>(textobj-diff-hunk-N)
xmap <buffer> <LocalLeader>J <Plug>(textobj-diff-hunk-N)
omap <buffer> <LocalLeader>J <Plug>(textobj-diff-hunk-N)
nmap <buffer> <LocalLeader>K <Plug>(textobj-diff-hunk-P)
xmap <buffer> <LocalLeader>K <Plug>(textobj-diff-hunk-P)
omap <buffer> <LocalLeader>K <Plug>(textobj-diff-hunk-P)

xnoremap <buffer> ad <Nop>
onoremap <buffer> ad <Nop>
xmap <buffer> adf <Plug>(textobj-diff-file)
omap <buffer> adf <Plug>(textobj-diff-file)
xmap <buffer> adh <Plug>(textobj-diff-hunk)
omap <buffer> adh <Plug>(textobj-diff-hunk)

xnoremap <buffer> id <Nop>
onoremap <buffer> id <Nop>
xmap <buffer> idf <Plug>(textobj-diff-file)
omap <buffer> idf <Plug>(textobj-diff-file)
xmap <buffer> idh <Plug>(textobj-diff-hunk)
omap <buffer> idh <Plug>(textobj-diff-hunk)

nmap <buffer> <C-J> <Plug>(textobj-diff-hunk-n)
xmap <buffer> <C-J> <Plug>(textobj-diff-hunk-n)
omap <buffer> <C-J> <Plug>(textobj-diff-hunk-n)
nmap <buffer> <C-K> <Plug>(textobj-diff-hunk-p)
xmap <buffer> <C-K> <Plug>(textobj-diff-hunk-p)
omap <buffer> <C-K> <Plug>(textobj-diff-hunk-p)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''nunmap <buffer> <LocalLeader>f'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>f'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>f'' |
  \
  \ silent! execute ''nunmap <buffer> <LocalLeader>fj'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>fj'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>fj'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>fk'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>fk'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>fk'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>fJ'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>fJ'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>fJ'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>fK'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>fK'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>fK'' |
  \
  \ silent! execute ''nunmap <buffer> <LocalLeader>j'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>j'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>j'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>k'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>k'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>k'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>J'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>J'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>J'' |
  \ silent! execute ''nunmap <buffer> <LocalLeader>K'' |
  \ silent! execute ''xunmap <buffer> <LocalLeader>K'' |
  \ silent! execute ''ounmap <buffer> <LocalLeader>K'' |
  \
  \ silent! execute ''xunmap <buffer> ad'' |
  \ silent! execute ''ounmap <buffer> ad'' |
  \ silent! execute ''xunmap <buffer> adf'' |
  \ silent! execute ''ounmap <buffer> adf'' |
  \ silent! execute ''xunmap <buffer> adh'' |
  \ silent! execute ''ounmap <buffer> adh'' |
  \
  \ silent! execute ''xunmap <buffer> id'' |
  \ silent! execute ''ounmap <buffer> id'' |
  \ silent! execute ''xunmap <buffer> idf'' |
  \ silent! execute ''ounmap <buffer> idf'' |
  \ silent! execute ''xunmap <buffer> idh'' |
  \ silent! execute ''ounmap <buffer> idh'' |
  \
  \ silent! execute ''nunmap <buffer> <C-J>'' |
  \ silent! execute ''xunmap <buffer> <C-J>'' |
  \ silent! execute ''ounmap <buffer> <C-J>'' |
  \ silent! execute ''nunmap <buffer> <C-K>'' |
  \ silent! execute ''xunmap <buffer> <C-K>'' |
  \ silent! execute ''ounmap <buffer> <C-K>'''

let &cpo = s:save_cpo
unlet s:save_cpo
