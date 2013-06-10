" -*- mode: vimrc; coding: unix -*-

" @name        python.vim
" @description Switch ftplugin for Python
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
    \ ['and', 'or']]
    for i in range(len(l))
      call extend(cst, {'\C\<' . l[i] . '\>' : get(l, i + 1, l[0])})
    endfor
  endfor

  for l in [
    \ ['==', '!=']]
    for i in range(len(l))
      call extend(cst, {'\C' . l[i] : get(l, i + 1, l[0])})
    endfor
  endfor

  call extend(cst, {
    \ '&'  : '|',
    \ '|'  : '^',
    \ '\^' : '&'})

  let b:python_switch_custom_definitions    = cst
  let b:python_switch_increment_definitions = inc
  let b:python_switch_decrement_definitions = dec
endfunction
if !exists('b:python_switch_custom_definitions') ||
  \ !exists('b:python_switch_increment_definitions') ||
  \ !exists('b:python_switch_decrement_definitions')
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

call add(b:switch_custom_definitions,    b:python_switch_custom_definitions)
call add(b:switch_increment_definitions, b:python_switch_increment_definitions)
call add(b:switch_decrement_definitions, b:python_switch_decrement_definitions)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ call filter(b:switch_custom_definitions, "
  \   !exists(\"b:python_switch_custom_definitions\") ||
  \   v:val != b:python_switch_custom_definitions") |
  \ call filter(b:switch_increment_definitions, "
  \   !exists(\"b:python_switch_increment_definitions\") ||
  \   v:val != b:python_switch_increment_definitions") |
  \ call filter(b:switch_decrement_definitions, "
  \   !exists(\"b:python_switch_decrement_definitions\") ||
  \   v:val != b:python_switch_decrement_definitions")'

let &cpo = s:save_cpo
unlet s:save_cpo
