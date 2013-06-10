" -*- mode: vimrc; coding: unix -*-

" @name        cpp.vim
" @description Switch ftplugin for C++
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-08 20:16:53 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:init_definitions()
  let cst = {}
  let inc = {}
  let dec = {}

  for l in [
    \ ['public', 'private', 'protected'],
    \ ['intptr_t', 'uintptr_t'],
    \ ['intmax_t', 'uintmax_t'],
    \ ['dynamic_cast', 'static_cast', 'const_cast', 'reinterpret_cast', 'safe_cast']]
    for i in range(len(l))
      call extend(cst, {'\C\<' . l[i] . '\>' : get(l, i + 1, l[0])})
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
      call extend(inc, {'\C\<' . s1 . '\>' : s2})
      call extend(dec, {'\C\<' . s2 . '\>' : s1})
    endfor
  endfor

  let b:cpp_switch_custom_definitions    = cst
  let b:cpp_switch_increment_definitions = inc
  let b:cpp_switch_decrement_definitions = dec
endfunction
if !exists('b:cpp_switch_custom_definitions') ||
  \ !exists('b:cpp_switch_increment_definitions') ||
  \ !exists('b:cpp_switch_decrement_definitions')
  call s:init_definitions()
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

if !exists('b:switch_increment_definitions')
  let b:switch_increment_definitions = []
endif

if !exists('b:switch_decrement_definitions')
  let b:switch_decrement_definitions = []
endif

call add(b:switch_custom_definitions,    b:cpp_switch_custom_definitions)
call add(b:switch_increment_definitions, b:cpp_switch_increment_definitions)
call add(b:switch_decrement_definitions, b:cpp_switch_decrement_definitions)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ call filter(b:switch_custom_definitions, "
  \   !exists(\"b:cpp_switch_custom_definitions\") ||
  \   v:val != b:cpp_switch_custom_definitions") |
  \ call filter(b:switch_increment_definitions, "
  \   !exists(\"b:cpp_switch_increment_definitions\") ||
  \   v:val != b:cpp_switch_increment_definitions") |
  \ call filter(b:switch_decrement_definitions, "
  \   !exists(\"b:cpp_switch_decrement_definitions\") ||
  \   v:val != b:cpp_switch_decrement_definitions")'

let &cpo = s:save_cpo
unlet s:save_cpo
