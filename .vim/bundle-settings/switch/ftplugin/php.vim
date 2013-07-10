" -*- mode: vimrc; coding: unix -*-

" @name        php.vim
" @description Switch ftplugin for PHP
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-10 16:01:20 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:initialize()
  let s:cst = {}
  let s:inc = {}
  let s:dec = {}

  for l in [
    \ ['and', 'or', 'xor']]
    for i in range(len(l))
      call extend(s:cst, {'\C\<' . l[i] . '\>' : get(l, i + 1, l[0])})
    endfor
  endfor

  for l in [
    \ ['&&', '||']]
    for i in range(len(l))
      call extend(s:cst, {'\C' . l[i] : get(l, i + 1, l[0])})
    endfor
  endfor

  call extend(s:cst, {
    \ '&\@<!&&\@!' : '|',
    \ '|\@<!||\@!' : '^',
    \ '\^'         : '&',
    \
    \ '\C==='         : '!==',
    \ '\C!=='         : '===',
    \ '\C=\@<!===\@!' : '!=',
    \ '\C!==\@!'      : '=='})
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

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID_PREFIX$')
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
  \ call call("' . s:SID_PREFIX() . 'finalize", [])'

let &cpo = s:save_cpo
unlet s:save_cpo
