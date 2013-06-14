" -*- mode: vimrc; coding: unix -*-

" @name        Go.vim
" @description Switch ftplugin for Go
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 16:55:12 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:init_definitions()
  let cst = {}
  let inc = {}
  let dec = {}

  for l in [
    \ ['int8',  'int16',  'int32',  'int64'],
    \ ['uint8', 'uint16', 'uint32', 'uint64'],
    \ ['float32', 'float64'], ['complex64', 'complex128']]
    for i in range(len(l))
      let s1 = l[i]
      let s2 = get(l, i + 1, l[0])
      call extend(inc, {'\C\<' . s1 . '\>' : s2})
      call extend(dec, {'\C\<' . s2 . '\>' : s1})
    endfor
  endfor

  for l in [
    \ ['==', '!='],
    \ ['&&', '||']]
    for i in range(len(l))
      call extend(cst, {'\C' . l[i] : get(l, i + 1, l[0])})
    endfor
  endfor

  call extend(cst, {
    \ '&\@<!&&\@!' : '|',
    \ '|\@<!||\@!' : '^',
    \ '\^'         : '&'})

  let b:go_switch_custom_definitions    = cst
  let b:go_switch_increment_definitions = inc
  let b:go_switch_decrement_definitions = dec
endfunction
if !exists('b:go_switch_custom_definitions') ||
  \ !exists('b:go_switch_increment_definitions') ||
  \ !exists('b:go_switch_decrement_definitions')
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

call add(b:switch_custom_definitions,    b:go_switch_custom_definitions)
call add(b:switch_increment_definitions, b:go_switch_increment_definitions)
call add(b:switch_decrement_definitions, b:go_switch_decrement_definitions)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ call filter(b:switch_custom_definitions, "
  \   !exists(\"b:go_switch_custom_definitions\") ||
  \   v:val != b:go_switch_custom_definitions") |
  \ call filter(b:switch_increment_definitions, "
  \   !exists(\"b:go_switch_increment_definitions\") ||
  \   v:val != b:go_switch_increment_definitions") |
  \ call filter(b:switch_decrement_definitions, "
  \   !exists(\"b:go_switch_decrement_definitions\") ||
  \   v:val != b:go_switch_decrement_definitions")'

let &cpo = s:save_cpo
unlet s:save_cpo
