" -*- mode: vimrc; coding: unix -*-

" @name        cpp.vim
" @description Switch ftplugin for C++
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-19 15:44:32 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:init_switch_definitions()
  let s:cst = {}
  let s:inc = {}
  let s:dec = {}

  for l in [
    \ ['public', 'private', 'protected'],
    \ ['intptr_t', 'uintptr_t'],
    \ ['intmax_t', 'uintmax_t'],
    \ ['dynamic_cast', 'static_cast', 'const_cast', 'reinterpret_cast', 'safe_cast']]
    for i in range(len(l))
      call extend(s:cst, {'\C\<' . l[i] . '\>' : get(l, i + 1, l[0])})
    endfor
  endfor

  for l in [
    \ ['int8_t',  'int16_t',  'int32_t',  'int64_t'],
    \ ['uint8_t', 'uint16_t', 'uint32_t', 'uint64_t'],
    \ ['int_least8_t',  'int_least16_t',  'int_least32_t',  'int_least64_t'],
    \ ['uint_least8_t', 'uint_least16_t', 'uint_least32_t', 'uint_leastw64_t'],
    \ ['int_fast8_t',  'int_fast16_t',  'int_fast32_t',  'int_fast64_t'],
    \ ['uint_fast8_t', 'uint_fast16_t', 'uint_fast32_t', 'uint_fast64_t']]
    for i in range(len(l))
      let s1 = l[i]
      let s2 = get(l, i + 1, l[0])
      call extend(s:inc, {'\C\<' . s1 . '\>' : s2})
      call extend(s:dec, {'\C\<' . s2 . '\>' : s1})
    endfor
  endfor
endfunction
if !exists('s:cst') || !exists('s:inc') || !exists('s:dec')
  call s:init_switch_definitions()
endif

if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
if !exists('b:switch_increment_definitions')
  let b:switch_increment_definitions = []
endif
if !exists('b:switch_decrement_definitions')
  let b:switch_decrement_definitions = []
endif

call add(b:switch_custom_definitions,    s:cst)
call add(b:switch_increment_definitions, s:inc)
call add(b:switch_decrement_definitions, s:dec)

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:remove_switch_definitions()
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
  \ call call("' . s:SID_PREFIX() . 'remove_switch_definitions", [])'

let &cpo = s:save_cpo
unlet s:save_cpo
