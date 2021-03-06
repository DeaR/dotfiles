" Ftplugin for VHDL
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
\ '[[' : s:maparg('[[', 'n'),
\ ']]' : s:maparg(']]', 'n'),
\ '[]' : s:maparg('[]', 'n'),
\ '][' : s:maparg('][', 'n')}
let s:x = {
\ '[[' : s:maparg('[[', 'v'),
\ ']]' : s:maparg(']]', 'v'),
\ '[]' : s:maparg('[]', 'v'),
\ '][' : s:maparg('][', 'v')}

try
  call submode#enter_with(
  \ 'vhdl/seq/b', 'n', 'bs', '<Plug>(submode:vhdl/seq/b:[)', s:n['[['])
  call submode#enter_with(
  \ 'vhdl/seq/b', 'n', 'bs', '<Plug>(submode:vhdl/seq/b:])', s:n[']]'])
  call submode#map(
  \ 'vhdl/seq/b', 'n', 'bs', '[', s:n['[['])
  call submode#map(
  \ 'vhdl/seq/b', 'n', 'bs', ']', s:n[']]'])
  call submode#enter_with(
  \ 'vhdl/seq/b', 'x', 'bs', '<Plug>(submode:vhdl/seq/b:[)', s:x['[['])
  call submode#enter_with(
  \ 'vhdl/seq/b', 'x', 'bs', '<Plug>(submode:vhdl/seq/b:])', s:x[']]'])
  call submode#map(
  \ 'vhdl/seq/b', 'x', 'bs', '[', s:x['[['])
  call submode#map(
  \ 'vhdl/seq/b', 'x', 'bs', ']', s:x[']]'])

  call submode#enter_with(
  \ 'vhdl/seq/e', 'n', 'bs', '<Plug>(submode:vhdl/seq/e:[)', s:n['[]'])
  call submode#enter_with(
  \ 'vhdl/seq/e', 'n', 'bs', '<Plug>(submode:vhdl/seq/e:[)', s:n[']['])
  call submode#map(
  \ 'vhdl/seq/e', 'n', 'bs', '[', s:n['[]'])
  call submode#map(
  \ 'vhdl/seq/e', 'n', 'bs', ']', s:n[']['])
  call submode#enter_with(
  \ 'vhdl/seq/e', 'x', 'bs', '<Plug>(submode:vhdl/seq/e:[)', s:x['[]'])
  call submode#enter_with(
  \ 'vhdl/seq/e', 'x', 'bs', '<Plug>(submode:vhdl/seq/e:[)', s:x[']['])
  call submode#map(
  \ 'vhdl/seq/e', 'x', 'bs', '[', s:x['[]'])
  call submode#map(
  \ 'vhdl/seq/e', 'x', 'bs', ']', s:x[']['])

  nmap <buffer> [[ <Plug>(submode:vhdl/seq/b:[)
  xmap <buffer> [[ <Plug>(submode:vhdl/seq/b:[)
  nmap <buffer> ]] <Plug>(submode:vhdl/seq/b:])
  xmap <buffer> ]] <Plug>(submode:vhdl/seq/b:])

  nmap <buffer> [] <Plug>(submode:vhdl/seq/e:[)
  xmap <buffer> [] <Plug>(submode:vhdl/seq/e:[)
  nmap <buffer> ][ <Plug>(submode:vhdl/seq/e:])
  xmap <buffer> ][ <Plug>(submode:vhdl/seq/e:])
catch
  execute 'nnoremap <buffer><silent> [[' s:n['[[']
  execute 'xnoremap <buffer><silent> [[' s:x['[[']
  execute 'nnoremap <buffer><silent> ]]' s:n[']]']
  execute 'xnoremap <buffer><silent> ]]' s:x[']]']

  execute 'nnoremap <buffer><silent> []' s:n['[]']
  execute 'xnoremap <buffer><silent> []' s:x['[]']
  execute 'nnoremap <buffer><silent> ][' s:n['][']
  execute 'xnoremap <buffer><silent> ][' s:x['][']
finally
  silent! sunmap <buffer> [[
  silent! sunmap <buffer> ]]
  silent! sunmap <buffer> []
  silent! sunmap <buffer> ][
endtry

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! call submode#unmap("vhdl/seq/b", "nx", "bs", "<Plug>(submode:vhdl/seq/b:[)") |
\ silent! call submode#unmap("vhdl/seq/b", "nx", "bs", "<Plug>(submode:vhdl/seq/b:])") |
\ silent! call submode#unmap("vhdl/seq/e", "nx", "bs", "<Plug>(submode:vhdl/seq/e:[)") |
\ silent! call submode#unmap("vhdl/seq/e", "nx", "bs", "<Plug>(submode:vhdl/seq/e:])") |
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
