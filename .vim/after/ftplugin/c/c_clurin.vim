" Clurin for C
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

if !exists('g:loaded_clurin') &&
\ empty(exists('*dein#get') ? dein#get('clurin') : 0)
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let s:def = get(s:, 'def', [
\ ['char', 'short', 'int', 'long'],
\ ['float', 'double'],
\ ['int8_t',  'int16_t',  'int32_t',  'int64_t'],
\ ['uint8_t', 'uint16_t', 'uint32_t', 'uint64_t'],
\ ['int_least8_t',  'int_least16_t',  'int_least32_t',  'int_least64_t'],
\ ['uint_least8_t', 'uint_least16_t', 'uint_least32_t', 'uint_leastw64_t'],
\ ['int_fast8_t',   'int_fast16_t',   'int_fast32_t',   'int_fast64_t'],
\ ['uint_fast8_t',  'uint_fast16_t',  'uint_fast32_t',  'uint_fast64_t'],
\
\ ['==', '!='], ['&&', '||'],
\
\ ['BYTE', 'WORD', 'DWORD'],
\ ['u8', 'u16', 'u32', 'u64'], ['s8', 's16', 's32', 's64']])

let b:clurin     = get(b:, 'clurin', {})
let b:clurin.def = get(b:clurin, 'def', [])
call extend(b:clurin.def, s:def)

function! s:SID() abort
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

function! s:undo_ftplugin() abort
  if has_key(b:, 'clurin') && has_key(b:clurin, 'def')
    for d in s:def
      call filter(b:clurin.def, 'v:val isnot d')
    endfor
  endif
endfunction

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ call call("\<SNR>' . s:SID() . '_undo_ftplugin", [])'

let &cpo = s:save_cpo
unlet s:save_cpo
