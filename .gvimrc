" -*- mode: vimrc; coding: utf8-unix -*-

" @name        .gvimrc
" @description GVim settings
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-10 12:02:04 DeaR>

"=============================================================================
" Init First: {{{
" GVimrc autocmd group
augroup MyGVimrc
  autocmd!
augroup END

" Check Vim version
function! s:has_patch(version, patch)
  return (v:version > a:version) || (v:version == a:version &&
    \  has(type(a:patch) == type(0) ? ('patch' . a:patch) : a:patch))
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

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' ||
  \  $VIM =~? 'net\.momodalo\.app\.vimtouch')
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
set noerrorbells
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
if 0 && has('directx')
  set renderoptions=type:directx
endif

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
