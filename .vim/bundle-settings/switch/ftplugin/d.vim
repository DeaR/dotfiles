" Switch ftplugin for D
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  09-Sep-2015.
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

function! s:initialize()
  let s:cst = {}
  let s:inc = {}
  let s:dec = {}

  for l in [
  \ ['public', 'private', 'protected', 'package', 'export']]
    for i in range(len(l))
      call extend(s:cst, {'\C\<' . l[i] . '\>' : get(l, i + 1, l[0])})
    endfor
  endfor

  for l in [
  \ ['byte',  'short',  'int',  'long',  'cent'],
  \ ['ubyte', 'ushort', 'uint', 'ulong', 'ucent'],
  \ ['float',  'double',  'real'],
  \ ['ifloat', 'idouble', 'ireal'],
  \ ['cfloat', 'cdouble', 'creal'],
  \ ['char', 'wchar', 'dchar']]
    for i in range(len(l))
      let s1 = l[i]
      let s2 = get(l, i + 1, l[0])
      call extend(s:inc, {'\C\<' . s1 . '\>' : s2})
      call extend(s:dec, {'\C\<' . s2 . '\>' : s1})
    endfor
  endfor

  for l in [
  \ ['==', '!='],
  \ ['&&', '||']]
    for i in range(len(l))
      call extend(s:cst, {'\C' . l[i] : get(l, i + 1, l[0])})
    endfor
  endfor
endfunction
if !exists('s:cst') || !exists('s:inc') || !exists('s:dec')
  call s:initialize()
endif

let b:switch_custom_definitions =
\ get(b:, 'switch_custom_definitions', [])
let b:switch_increment_definitions =
\ get(b:, 'switch_increment_definitions', [])
let b:switch_decrement_definitions =
\ get(b:, 'switch_decrement_definitions', [])

call add(b:switch_custom_definitions,    s:cst)
call add(b:switch_increment_definitions, s:inc)
call add(b:switch_decrement_definitions, s:dec)

function! s:SID()
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

function! s:finalize()
  if exists('s:cst')
    call filter(b:switch_custom_definitions,
    \ 'v:val isnot s:cst')
  endif
  if exists('s:inc')
    call filter(b:switch_increment_definitions,
    \ 'v:val isnot s:inc')
  endif
  if exists('s:dec')
    call filter(b:switch_decrement_definitions,
    \ 'v:val isnot s:dec')
  endif
endfunction

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ call call("\<SNR>' . s:SID() . '_finalize", [])'

let &cpo = s:save_cpo
unlet s:save_cpo
