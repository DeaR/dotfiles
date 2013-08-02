" -*- mode: vimrc; coding: utf8-unix -*-

" @name        .gvimrc
" @description GVim settings
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-02 19:52:06 DeaR>

"=============================================================================
" Pre Init: {{{

"-----------------------------------------------------------------------------
" Common: {{{
" GVimrc autocmd group
augroup MyGVimrc
  autocmd!
augroup END

" Script ID
function! s:SID_PREFIX()
  let s:_SID_PREFIX = get(s:, '_SID_PREFIX',
    \ matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$'))
  return s:_SID_PREFIX
endfunction

" Check Vim version
function! s:has_patch(version, patch)
  return (v:version > a:version) || (v:version == a:version &&
    \ has(type(a:patch) == type(0) ? ('patch' . a:patch) : a:patch))
endfunction

" Check vimproc
function! s:has_vimproc()
  if !exists('s:exists_vimproc')
    try
      call vimproc#version()
      let s:exists_vimproc = 1
    catch
      let s:exists_vimproc = 0
    endtry
  endif
  return s:exists_vimproc
endfunction

" Cached executable
let s:_executable = get(s:, '_executable', {})
function! s:executable(expr)
  let s:_executable[a:expr] = get(s:_executable, a:expr, executable(a:expr))
  return s:_executable[a:expr]
endfunction

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' ||
  \  $VIM =~? 'net\.momodalo\.app\.vimtouch')
"}}}
"}}}

"=============================================================================
" General Settings: {{{

"-----------------------------------------------------------------------------
" System: {{{
" GUI options
set guioptions+=c
set guioptions-=a
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=l
set guioptions-=L
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

"-----------------------------------------------------------------------------
" Search: {{{
" Highlight
set hlsearch
"}}}

"-----------------------------------------------------------------------------
" Display: {{{
" Command line
set cmdheight=1

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
" if has('directx')
"   set renderoptions=type:directx
" endif

" Full screen
if has('win32')
  autocmd MyGVimrc GUIEnter *
    \ simalt ~x
else
  autocmd MyGVimrc GUIEnter *
    \ winpos 0 0 |
    \ set lines=999 columns=9999
endif
"}}}

"-----------------------------------------------------------------------------
" Colors: {{{
" Colorscheme
silent! colorscheme molokai

" Cursor color
autocmd MyGVimrc GUIEnter,ColorScheme *
  \ highlight clear Cursor |
  \ highlight clear CursorIM |
  \ highlight Cursor   guifg=#000000 guibg=#eedd82 |
  \ highlight CursorIM guifg=#000000 guibg=#6495ed
"}}}
"}}}

"=============================================================================
" Mappings: {{{

"-----------------------------------------------------------------------------
" From Example: {{{
map  <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
"}}}
"}}}

"=============================================================================
" Post Init: {{{
if exists('#User#GVimrcPost')
  execute 'doautocmd'
    \ (s:has_patch(703, 438) ? '<nomodeline>' : '')
    \ 'User GVimrcPost'
endif
"}}}
