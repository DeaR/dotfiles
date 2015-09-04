scriptencoding utf-8
" GVim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  04-Sep-2015.
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
"}}}

"==============================================================================
" Pre Init: {{{
" Skip vim-tiny, vim-small, below vim-7.2
if v:version < 703 | finish | endif

"------------------------------------------------------------------------------
" Variable: {{{
" Direct Write
let s:directx_enable = 0
"}}}

"------------------------------------------------------------------------------
" Common: {{{
" GVimrc autocmd group
augroup MyGVimrc
  autocmd!
augroup END

" Script ID
function! s:SID()
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

" CPU Cores
function! s:cpucores()
  if !exists('s:_cpucores')
    let s:_cpucores = str2nr(
      \ exists('$NUMBER_OF_PROCESSORS') ? $NUMBER_OF_PROCESSORS :
      \ s:executable('nproc')           ? system('nproc') :
      \ s:executable('getconf')         ? system('getconf _NPROCESSORS_ONLN') :
      \ filereadable('/proc/cpuinfo')   ? system('cat /proc/cpuinfo | grep -c "processor"') : '1')
  endif
  return s:_cpucores
endfunction

" Check Vim version
function! s:has_patch(major, minor, patch)
  let l:version = (a:major * 100 + a:minor)
  return has('patch-' . a:major . '.' . a:minor . '.' . a:patch) ||
    \ (v:version > l:version) ||
    \ (v:version == l:version && has('patch' . a:patch))
endfunction

" Check vimproc
function! s:has_vimproc()
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

" Wrapped neobundle#tap
function! s:neobundle_tap(name)
  return exists('*neobundle#tap') && neobundle#tap(a:name)
endfunction

" Check enabled bundle
function! s:is_enabled_bundle(name)
  return
    \ exists('*neobundle#is_installed') && neobundle#is_installed(a:name) &&
    \ exists('*neobundle#get') && !get(neobundle#get(a:name), 'disabled', 1)
endfunction

" Cached executable
let s:_executable = {}
function! s:executable(expr)
  if !has_key(s:_executable, a:expr)
    let s:_executable[a:expr] = executable(a:expr)
  endif
  return s:_executable[a:expr]
endfunction

" Check executable or enabled
function! s:executable_or_enabled(expr, name)
  return s:is_enabled_bundle(a:name) || s:executable(a:expr)
endfunction

" Check japanese
let s:is_lang_ja = has('multi_byte') && v:lang =~? '^ja'

" Check colored UI
let s:is_colored = has('gui_running') || &t_Co > 255

" Check JIS X 0213
let s:has_jisx0213 = has('iconv') &&
  \ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
"}}}
"}}}

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
endif

" Multi byte charactor width
if has('kaoriya')
  set ambiwidth=auto
endif
"}}}

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

" Direct Write
if s:directx_enable && has('directx')
  set renderoptions=type:directx
endif

" Full screen
autocmd MyGVimrc GUIEnter *
  \ winpos 0 0 |
  \ set lines=999 columns=9999
"}}}

"------------------------------------------------------------------------------
" Colors: {{{
" Cursor color
autocmd MyGVimrc ColorScheme *
  \ highlight Cursor   guifg=#000000 guibg=#eedd82 gui=NONE |
  \ highlight CursorIM guifg=#000000 guibg=#6495ed gui=NONE
"}}}
"}}}

"==============================================================================
" Post Init: {{{
" Do PostInit Event
if exists('#User#MyGVimrcPost')
  execute 'doautocmd' (s:has_patch(7, 3, 438) ? '<nomodeline>' : '')
    \ 'User MyGVimrcPost'
endif

" Local gvimrc
if filereadable($HOME . '/.local/.gvimrc_local.vim')
  source ~/.local/.gvimrc_local.vim
endif

" ColorScheme
if !exists('g:colors_name')
  silent! colorscheme molokai
endif
"}}}
