scriptencoding utf-8

" GVim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  12-May-2016.
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

"==============================================================================
" Pre Init: {{{
" Skip vim-tiny, vim-small, below vim-7.2
if v:version < 703 | finish | endif

" GVimrc autocmd group
augroup MyGVimrc
  autocmd!
augroup END

"------------------------------------------------------------------------------
" Common: {{{
" Script ID
function! s:SID() abort
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

" CPU Cores
function! s:cpucores() abort
  if !exists('s:_cpucores')
    let s:_cpucores = str2nr(
    \ exists('$NUMBER_OF_PROCESSORS') ? $NUMBER_OF_PROCESSORS :
    \ s:executable('nproc')           ? system('nproc') :
    \ s:executable('getconf')         ? system('getconf _NPROCESSORS_ONLN') :
    \ s:executable('sysctl')          ? system('sysctl hw.ncpu') :
    \ filereadable('/proc/cpuinfo')   ?
    \   len(filter(readfile('/proc/cpuinfo'), 'v:val =~ "processor"')) : '1')
  endif
  return s:_cpucores
endfunction

" Cached executable
let s:_executable = {}
function! s:executable(expr) abort
  if !has_key(s:_executable, a:expr)
    let s:_executable[a:expr] = executable(a:expr)
  endif
  return s:_executable[a:expr]
endfunction

" Check japanese
let s:is_lang_ja = has('multi_byte') && v:lang =~? '^ja'

" Check colored UI
let s:is_colored_ui = has('gui_running') || has('termguicolors') || &t_Co > 255

" Check JIS X 0213
let s:has_jisx0213 = has('iconv') &&
\ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"

" $PROGRAMFILES
if has('win32')
  let s:save_isi = &isident
  try
    set isident+=(,)
    let s:arch = exists('$PROGRAMFILES(X86)')
    let s:pf64 = exists('$PROGRAMW6432') ?
    \ $PROGRAMW6432 : $PROGRAMFILES
    let s:pf32 = exists('$PROGRAMFILES(X86)') ?
    \ $PROGRAMFILES(X86) : $PROGRAMFILES
  finally
    let &isident = s:save_isi
    unlet! s:save_isi
  endtry
endif
" }}}

"------------------------------------------------------------------------------
" Wrapper: {{{
" Vim.Compat.has_version
" 7.4.237  (after 7.4.236) has() not checking for specific patch
if has('patch-7.4.237')
  function! s:has_patch(args) abort
    return has('patch-' . a:args)
  endfunction
else
  function! s:has_patch(args) abort
    let a = split(a:args, '\.')
    let v = a[0] * 100 + a[1]
    return v:version > v || v:version == v && has('patch' . a[2])
  endfunction
endif

" Check vimproc
function! s:has_vimproc() abort
  if !exists('s:_has_vimproc')
    try
      call vimproc#version()
      let s:_has_vimproc = 1
    catch
      let s:_has_vimproc = 0
    endtry
  endif
  return s:_has_vimproc
endfunction

" dein#tap
function! s:dein_tap(name) abort
  return exists('*dein#tap') && dein#tap(a:name)
endfunction
" }}}
" }}}

"==============================================================================
" General Settings: {{{

"------------------------------------------------------------------------------
" System: {{{
" GUI options
set guioptions+=c
set guioptions-=a
set guioptions-=e
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=l
set guioptions-=L
set guioptions-=b
set guioptions-=h
set guicursor+=i-ci:ver50-Cursor/lCursor

" Use beep
set novisualbell
set t_vb=

" Multi byte IME
if has('multi_byte_ime') || has('xim')
  " IME state
  set iminsert=0
  set imsearch=-1
  autocmd MyGVimrc InsertLeave *
  \ set iminsert=0
endif

" Multi byte charactor width
if has('kaoriya')
  set ambiwidth=auto
endif
" }}}

"------------------------------------------------------------------------------
" Display: {{{
" Command line
set cmdheight=2

" Font
if has('win32')
  set guifont=Consolas:h9:cSHIFTJIS
  set guifontwide=MeiryoKe_Console:h9:cSHIFTJIS
  set linespace=0
  if has('printer')
    set printfont=MeiryoKe_Gothic:h12:cSHIFTJIS
  endif
elseif has('xfontset')
  set guifontset=a14,r14,k14
elseif has('mac')
  set guifont=Osaka-Mono:h14
endif

" Full screen
autocmd MyGVimrc GUIEnter *
\ winpos 0 0 |
\ set lines=999 columns=9999
" }}}

"------------------------------------------------------------------------------
" Colors: {{{
" Cursor color
autocmd MyGVimrc ColorScheme *
\ highlight Cursor   guifg=#000000 guibg=#eedd82 gui=NONE |
\ highlight CursorIM guifg=#000000 guibg=#6495ed gui=NONE
" }}}
" }}}

"==============================================================================
" Post Init: {{{
" Local gvimrc
if filereadable($HOME . '/.gvimrc_local.vim')
  source ~/.gvimrc_local.vim
elseif filereadable($HOME . '/.vim/gvimrc_local.vim')
  source ~/.vim/gvimrc_local.vim
endif

" ColorScheme
if !exists('g:colors_name')
  try
    colorscheme molokai
  catch /.*/
    colorscheme desert
  endtry
endif
" }}}
