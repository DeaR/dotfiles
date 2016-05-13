" Lua ftplugin
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

if !exists('g:loaded_lua_ftplugin') &&
\ empty(exists('*dein#get') ? dein#get('lua-ftplugin') : 0)
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

setlocal omnifunc=xolox#lua#omnifunc

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
\ '[{' : s:maparg('[{', 'n'),
\ ']}' : s:maparg(']}', 'n'),
\ '[[' : s:maparg('[[', 'n'),
\ ']]' : s:maparg(']]', 'n'),
\ '[]' : s:maparg('[]', 'n'),
\ '][' : s:maparg('][', 'n')}
let s:x = {
\ '[{' : ':<C-U>execute "normal! gv"<bar>' . s:n['[{'],
\ ']}' : ':<C-U>execute "normal! gv"<bar>' . s:n[']}'],
\ '[[' : ':<C-U>execute "normal! gv"<bar>' . s:n['[['],
\ ']]' : ':<C-U>execute "normal! gv"<bar>' . s:n[']]'],
\ '[]' : ':<C-U>execute "normal! gv"<bar>' . s:n['[]'],
\ '][' : ':<C-U>execute "normal! gv"<bar>' . s:n['][']}

try
  call submode#enter_with(
  \ 'lua/brkt', 'n', 'bs', '<Plug>(submode:lua/brkt:[)', s:n['[{'])
  call submode#enter_with(
  \ 'lua/brkt', 'n', 'bs', '<Plug>(submode:lua/brkt:])', s:n[']}'])
  call submode#map(
  \ 'lua/brkt', 'n', 'bs', '[', s:n['[{'])
  call submode#map(
  \ 'lua/brkt', 'n', 'bs', ']', s:n[']}'])
  call submode#enter_with(
  \ 'lua/brkt', 'x', 'bs', '<Plug>(submode:lua/brkt:[)', s:x['[{'])
  call submode#enter_with(
  \ 'lua/brkt', 'x', 'bs', '<Plug>(submode:lua/brkt:])', s:x[']}'])
  call submode#map(
  \ 'lua/brkt', 'x', 'bs', '[', s:x['[{'])
  call submode#map(
  \ 'lua/brkt', 'x', 'bs', ']', s:x[']}'])

  call submode#enter_with(
  \ 'lua/seq/b', 'n', 'bs', '<Plug>(submode:lua/seq/b:[)', s:n['[['])
  call submode#enter_with(
  \ 'lua/seq/b', 'n', 'bs', '<Plug>(submode:lua/seq/b:])', s:n[']]'])
  call submode#map(
  \ 'lua/seq/b', 'n', 'bs', '[', s:n['[['])
  call submode#map(
  \ 'lua/seq/b', 'n', 'bs', ']', s:n[']]'])
  call submode#enter_with(
  \ 'lua/seq/b', 'x', 'bs', '<Plug>(submode:lua/seq/b:[)', s:x['[['])
  call submode#enter_with(
  \ 'lua/seq/b', 'x', 'bs', '<Plug>(submode:lua/seq/b:])', s:x[']]'])
  call submode#map(
  \ 'lua/seq/b', 'x', 'bs', '[', s:x['[['])
  call submode#map(
  \ 'lua/seq/b', 'x', 'bs', ']', s:x[']]'])

  call submode#enter_with(
  \ 'lua/seq/e', 'n', 'bs', '<Plug>(submode:lua/seq/e:[)', s:n['[]'])
  call submode#enter_with(
  \ 'lua/seq/e', 'n', 'bs', '<Plug>(submode:lua/seq/e:[)', s:n[']['])
  call submode#map(
  \ 'lua/seq/e', 'n', 'bs', '[', s:n['[]'])
  call submode#map(
  \ 'lua/seq/e', 'n', 'bs', ']', s:n[']['])
  call submode#enter_with(
  \ 'lua/seq/e', 'x', 'bs', '<Plug>(submode:lua/seq/e:[)', s:x['[]'])
  call submode#enter_with(
  \ 'lua/seq/e', 'x', 'bs', '<Plug>(submode:lua/seq/e:[)', s:x[']['])
  call submode#map(
  \ 'lua/seq/e', 'x', 'bs', '[', s:x['[]'])
  call submode#map(
  \ 'lua/seq/e', 'x', 'bs', ']', s:x[']['])

  nmap <buffer> [{ <Plug>(submode:lua/brkt:[)
  xmap <buffer> [{ <Plug>(submode:lua/brkt:[)
  nmap <buffer> ]} <Plug>(submode:lua/brkt:])
  xmap <buffer> ]} <Plug>(submode:lua/brkt:])

  nmap <buffer> [[ <Plug>(submode:lua/seq/b:[)
  xmap <buffer> [[ <Plug>(submode:lua/seq/b:[)
  nmap <buffer> ]] <Plug>(submode:lua/seq/b:])
  xmap <buffer> ]] <Plug>(submode:lua/seq/b:])

  nmap <buffer> [] <Plug>(submode:lua/seq/e:[)
  xmap <buffer> [] <Plug>(submode:lua/seq/e:[)
  nmap <buffer> ][ <Plug>(submode:lua/seq/e:])
  xmap <buffer> ][ <Plug>(submode:lua/seq/e:])
catch
  execute 'nnoremap <buffer><silent> [{' s:n['[{']
  execute 'xnoremap <buffer><silent> [{' s:x['[{']
  execute 'nnoremap <buffer><silent> ]}' s:n[']}']
  execute 'xnoremap <buffer><silent> ]}' s:x[']}']

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
\ setlocal omnifunc< |
\
\ silent! call submode#unmap("lua/brkt", "nx", "bs", "<Plug>(submode:lua/brkt:[)") |
\ silent! call submode#unmap("lua/brkt", "nx", "bs", "<Plug>(submode:lua/brkt:])") |
\ silent! call submode#unmap("lua/seq/b", "nx", "bs", "<Plug>(submode:lua/seq/b:[)") |
\ silent! call submode#unmap("lua/seq/b", "nx", "bs", "<Plug>(submode:lua/seq/b:])") |
\ silent! call submode#unmap("lua/seq/e", "nx", "bs", "<Plug>(submode:lua/seq/e:[)") |
\ silent! call submode#unmap("lua/seq/e", "nx", "bs", "<Plug>(submode:lua/seq/e:])") |
\
\ silent! execute "nunmap <buffer> [{" |
\ silent! execute "xunmap <buffer> [{" |
\ silent! execute "nunmap <buffer> ]}" |
\ silent! execute "xunmap <buffer> ]}" |
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
