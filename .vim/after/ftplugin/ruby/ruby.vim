" Ftplugin for Ruby
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  02-Oct-2015.
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

function! s:maparg(name, ...)
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
\ '[M' : s:maparg('[M', 'n'),
\ ']M' : s:maparg(']M', 'n'),
\ '[[' : s:maparg('[[', 'n'),
\ ']]' : s:maparg(']]', 'n'),
\ '[]' : s:maparg('[]', 'n'),
\ '][' : s:maparg('][', 'n')}
let s:x = {
\ '[m' : s:maparg('[m', 'x'),
\ ']m' : s:maparg(']m', 'x'),
\ '[M' : s:maparg('[M', 'x'),
\ ']M' : s:maparg(']M', 'x'),
\ '[[' : s:maparg('[[', 'x'),
\ ']]' : s:maparg(']]', 'x'),
\ '[]' : s:maparg('[]', 'x'),
\ '][' : s:maparg('][', 'x')}

try
  call submode#enter_with(
  \ 'rb/meth/b', 'n', 'bs', '<Plug>(submode:rb/meth/b:[)', s:n['[m'])
  call submode#enter_with(
  \ 'rb/meth/b', 'n', 'bs', '<Plug>(submode:rb/meth/b:])', s:n[']m'])
  call submode#map(
  \ 'rb/meth/b', 'n', 'bs', '[', s:n['[m'])
  call submode#map(
  \ 'rb/meth/b', 'n', 'bs', ']', s:n[']m'])
  call submode#enter_with(
  \ 'rb/meth/b', 'x', 'bs', '<Plug>(submode:rb/meth/b:[)', s:v['[m'])
  call submode#enter_with(
  \ 'rb/meth/b', 'x', 'bs', '<Plug>(submode:rb/meth/b:])', s:v[']m'])
  call submode#map(
  \ 'rb/meth/b', 'x', 'bs', '[', s:v['[m'])
  call submode#map(
  \ 'rb/meth/b', 'x', 'bs', ']', s:v[']m'])

  call submode#enter_with(
  \ 'rb/meth/e', 'n', 'bs', '<Plug>(submode:rb/meth/e:[)', s:n['[M'])
  call submode#enter_with(
  \ 'rb/meth/e', 'n', 'bs', '<Plug>(submode:rb/meth/e:[)', s:n[']M'])
  call submode#map(
  \ 'rb/meth/e', 'n', 'bs', '[', s:n['[M'])
  call submode#map(
  \ 'rb/meth/e', 'n', 'bs', ']', s:n[']M'])
  call submode#enter_with(
  \ 'rb/meth/e', 'x', 'bs', '<Plug>(submode:rb/meth/e:[)', s:v['[M'])
  call submode#enter_with(
  \ 'rb/meth/e', 'x', 'bs', '<Plug>(submode:rb/meth/e:[)', s:v[']M'])
  call submode#map(
  \ 'rb/meth/e', 'x', 'bs', '[', s:v['[M'])
  call submode#map(
  \ 'rb/meth/e', 'x', 'bs', ']', s:v[']M'])

  call submode#enter_with(
  \ 'rb/seq/b', 'n', 'bs', '<Plug>(submode:rb/seq/b:[)', s:n['[['])
  call submode#enter_with(
  \ 'rb/seq/b', 'n', 'bs', '<Plug>(submode:rb/seq/b:])', s:n[']]'])
  call submode#map(
  \ 'rb/seq/b', 'n', 'bs', '[', s:n['[['])
  call submode#map(
  \ 'rb/seq/b', 'n', 'bs', ']', s:n[']]'])
  call submode#enter_with(
  \ 'rb/seq/b', 'x', 'bs', '<Plug>(submode:rb/seq/b:[)', s:v['[['])
  call submode#enter_with(
  \ 'rb/seq/b', 'x', 'bs', '<Plug>(submode:rb/seq/b:])', s:v[']]'])
  call submode#map(
  \ 'rb/seq/b', 'x', 'bs', '[', s:v['[['])
  call submode#map(
  \ 'rb/seq/b', 'x', 'bs', ']', s:v[']]'])

  call submode#enter_with(
  \ 'rb/seq/e', 'n', 'bs', '<Plug>(submode:rb/seq/e:[)', s:n['[]'])
  call submode#enter_with(
  \ 'rb/seq/e', 'n', 'bs', '<Plug>(submode:rb/seq/e:[)', s:n[']['])
  call submode#map(
  \ 'rb/seq/e', 'n', 'bs', '[', s:n['[]'])
  call submode#map(
  \ 'rb/seq/e', 'n', 'bs', ']', s:n[']['])
  call submode#enter_with(
  \ 'rb/seq/e', 'x', 'bs', '<Plug>(submode:rb/seq/e:[)', s:v['[]'])
  call submode#enter_with(
  \ 'rb/seq/e', 'x', 'bs', '<Plug>(submode:rb/seq/e:[)', s:v[']['])
  call submode#map(
  \ 'rb/seq/e', 'x', 'bs', '[', s:v['[]'])
  call submode#map(
  \ 'rb/seq/e', 'x', 'bs', ']', s:v[']['])

  nmap <buffer> [m <Plug>(submode:rb/meth/b:[)
  xmap <buffer> [m <Plug>(submode:rb/meth/b:[)
  nmap <buffer> ]m <Plug>(submode:rb/meth/b:])
  xmap <buffer> ]m <Plug>(submode:rb/meth/b:])

  nmap <buffer> [M <Plug>(submode:rb/meth/e:[)
  xmap <buffer> [M <Plug>(submode:rb/meth/e:[)
  nmap <buffer> ]M <Plug>(submode:rb/meth/e:])
  xmap <buffer> ]M <Plug>(submode:rb/meth/e:])

  nmap <buffer> [[ <Plug>(submode:rb/seq/b:[)
  xmap <buffer> [[ <Plug>(submode:rb/seq/b:[)
  nmap <buffer> ]] <Plug>(submode:rb/seq/b:])
  xmap <buffer> ]] <Plug>(submode:rb/seq/b:])

  nmap <buffer> [] <Plug>(submode:rb/seq/e:[)
  xmap <buffer> [] <Plug>(submode:rb/seq/e:[)
  nmap <buffer> ][ <Plug>(submode:rb/seq/e:])
  xmap <buffer> ][ <Plug>(submode:rb/seq/e:])
catch
  execute 'nnoremap <buffer><silent> [m' s:n['[m']
  execute 'xnoremap <buffer><silent> [m' s:x['[m']
  execute 'nnoremap <buffer><silent> ]m' s:n[']m']
  execute 'xnoremap <buffer><silent> ]m' s:x[']m']

  execute 'nnoremap <buffer><silent> [M' s:n['[M']
  execute 'xnoremap <buffer><silent> [M' s:x['[M']
  execute 'nnoremap <buffer><silent> ]M' s:n[']M']
  execute 'xnoremap <buffer><silent> ]M' s:x[']M']

  execute 'nnoremap <buffer><silent> [[' s:n['[[']
  execute 'xnoremap <buffer><silent> [[' s:x['[[']
  execute 'nnoremap <buffer><silent> ]]' s:n[']]']
  execute 'xnoremap <buffer><silent> ]]' s:x[']]']

  execute 'nnoremap <buffer><silent> []' s:n['[]']
  execute 'xnoremap <buffer><silent> []' s:x['[]']
  execute 'nnoremap <buffer><silent> ][' s:n['][']
  execute 'xnoremap <buffer><silent> ][' s:x['][']
endtry

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! call submode#unmap("rb/meth/b", "nx", "bs", "<Plug>(submode:rb/meth/b:[)") |
\ silent! call submode#unmap("rb/meth/b", "nx", "bs", "<Plug>(submode:rb/meth/b:])") |
\ silent! call submode#unmap("rb/meth/e", "nx", "bs", "<Plug>(submode:rb/meth/e:[)") |
\ silent! call submode#unmap("rb/meth/e", "nx", "bs", "<Plug>(submode:rb/meth/e:])") |
\
\ silent! call submode#unmap("rb/seq/b", "nx", "bs", "<Plug>(submode:rb/seq/b:[)") |
\ silent! call submode#unmap("rb/seq/b", "nx", "bs", "<Plug>(submode:rb/seq/b:])") |
\ silent! call submode#unmap("rb/seq/e", "nx", "bs", "<Plug>(submode:rb/seq/e:[)") |
\ silent! call submode#unmap("rb/seq/e", "nx", "bs", "<Plug>(submode:rb/seq/e:])") |
\
\ silent! execute "nunmap <buffer> [m" |
\ silent! execute "xunmap <buffer> [m" |
\ silent! execute "nunmap <buffer> ]m" |
\ silent! execute "xunmap <buffer> ]m" |
\
\ silent! execute "nunmap <buffer> [M" |
\ silent! execute "xunmap <buffer> [M" |
\ silent! execute "nunmap <buffer> ]M" |
\ silent! execute "xunmap <buffer> ]M" |
\
\ silent! execute "nunmap <buffer> [[" |
\ silent! execute "xunmap <buffer> [[" |
\ silent! execute "nunmap <buffer> ]]" |
\ silent! execute "xunmap <buffer> ]]" |
\
\ silent! execute "nunmap <buffer> []" |
\ silent! execute "xunmap <buffer> []" |
\ silent! execute "nunmap <buffer> ][" |
\ silent! execute "xunmap <buffer> ]["'

let &cpo = s:save_cpo
unlet s:save_cpo
