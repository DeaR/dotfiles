" Ftplugin for Python
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  13-May-2016.
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

function! s:maparg(name, ...) abort
  let mode = get(a:000, 0, '')
  let abbr = get(a:000, 1)
  let dict = get(a:000, 2)
  if dict
    return maparg(a:name, mode, abbr, dict)
  else
    return substitute(maparg(a:name, mode, abbr), '|', '<bar>', 'g')
endfunction

let s:n = {
\ '[m' : s:maparg('[m', 'n'),
\ ']m' : s:maparg(']m', 'n'),
\ '[[' : s:maparg('[[', 'n'),
\ ']]' : s:maparg(']]', 'n')}
let s:x = {
\ '[m' : ':<C-U>execute "normal! gv"<bar>' . s:n['[m'],
\ ']m' : ':<C-U>execute "normal! gv"<bar>' . s:n[']m'],
\ '[[' : ':<C-U>execute "normal! gv"<bar>' . s:n['[['],
\ ']]' : ':<C-U>execute "normal! gv"<bar>' . s:n[']]']}

try
  call submode#enter_with(
  \ 'py/meth/b', 'n', 'bs', '<Plug>(submode:py/meth/b:[)', s:n['[m'])
  call submode#enter_with(
  \ 'py/meth/b', 'n', 'bs', '<Plug>(submode:py/meth/b:])', s:n[']m'])
  call submode#map(
  \ 'py/meth/b', 'n', 'bs', '[', s:n['[m'])
  call submode#map(
  \ 'py/meth/b', 'n', 'bs', ']', s:n[']m'])
  call submode#enter_with(
  \ 'py/meth/b', 'x', 'bs', '<Plug>(submode:py/meth/b:[)', s:x['[m'])
  call submode#enter_with(
  \ 'py/meth/b', 'x', 'bs', '<Plug>(submode:py/meth/b:])', s:x[']m'])
  call submode#map(
  \ 'py/meth/b', 'x', 'bs', '[', s:x['[m'])
  call submode#map(
  \ 'py/meth/b', 'x', 'bs', ']', s:x[']m'])

  call submode#enter_with(
  \ 'py/seq/b', 'n', 'bs', '<Plug>(submode:py/seq/b:[)', s:n['[['])
  call submode#enter_with(
  \ 'py/seq/b', 'n', 'bs', '<Plug>(submode:py/seq/b:])', s:n[']]'])
  call submode#map(
  \ 'py/seq/b', 'n', 'bs', '[', s:n['[['])
  call submode#map(
  \ 'py/seq/b', 'n', 'bs', ']', s:n[']]'])
  call submode#enter_with(
  \ 'py/seq/b', 'x', 'bs', '<Plug>(submode:py/seq/b:[)', s:x['[['])
  call submode#enter_with(
  \ 'py/seq/b', 'x', 'bs', '<Plug>(submode:py/seq/b:])', s:x[']]'])
  call submode#map(
  \ 'py/seq/b', 'x', 'bs', '[', s:x['[['])
  call submode#map(
  \ 'py/seq/b', 'x', 'bs', ']', s:x[']]'])

  nmap <buffer> [m <Plug>(submode:py/meth/b:[)
  xmap <buffer> [m <Plug>(submode:py/meth/b:[)
  nmap <buffer> ]m <Plug>(submode:py/meth/b:])
  xmap <buffer> ]m <Plug>(submode:py/meth/b:])

  nmap <buffer> [[ <Plug>(submode:py/seq/b:[)
  xmap <buffer> [[ <Plug>(submode:py/seq/b:[)
  nmap <buffer> ]] <Plug>(submode:py/seq/b:])
  xmap <buffer> ]] <Plug>(submode:py/seq/b:])
catch
  execute 'nnoremap <buffer><silent> ]m' s:n['[m']
  execute 'xnoremap <buffer><silent> ]m' s:x['[m']
  execute 'nnoremap <buffer><silent> ]m' s:n[']m']
  execute 'xnoremap <buffer><silent> ]m' s:x[']m']

  execute 'nnoremap <buffer><silent> [[' s:n['[[']
  execute 'xnoremap <buffer><silent> [[' s:x['[[']
  execute 'nnoremap <buffer><silent> ]]' s:n[']]']
  execute 'xnoremap <buffer><silent> ]]' s:x[']]']
endtry

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! call submode#unmap("py/meth/b", "nx", "bs", "<Plug>(submode:py/meth/b:[)") |
\ silent! call submode#unmap("py/meth/b", "nx", "bs", "<Plug>(submode:py/meth/b:])") |
\ silent! call submode#unmap("py/seq/b", "nx", "bs", "<Plug>(submode:py/seq/b:[)") |
\ silent! call submode#unmap("py/seq/b", "nx", "bs", "<Plug>(submode:py/seq/b:])") |
\
\ silent! execute "nunmap <buffer> [m" |
\ silent! execute "xunmap <buffer> [m" |
\ silent! execute "nunmap <buffer> ]m" |
\ silent! execute "xunmap <buffer> ]m" |
\
\ silent! execute "nunmap <buffer> [[" |
\ silent! execute "xunmap <buffer> [[" |
\ silent! execute "nunmap <buffer> ]]" |
\ silent! execute "xunmap <buffer> ]]"'

let &cpo = s:save_cpo
unlet s:save_cpo
