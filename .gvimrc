" -*- mode: vimrc; coding: utf8-unix -*-

" @name        .gvimrc
" @description GVim settings
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-11 14:25:37 DeaR>

"=============================================================================
" Resourcing First: {{{

if !has('vim_starting')
  set guioptions&
  set guicursor&

  set guioptions+=M

  syntax off
  colorscheme default

  if filereadable($VIM . '/gvimrc')
    source $VIM/gvimrc
  endif
endif

" GVimrc autocmd group
augroup MyGVimrc
  autocmd!
augroup END

" Anywhere SID
function! s:SID_PREFIX(...)
  if !exists('s:_sid_prefix')
    let s:_sid_prefix =
      \ matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
  endif
  return s:_sid_prefix . join(a:000, '')
endfunction

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
set guicursor+=i-ci:ver50-Cursor/lCursor

" Disable bell
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

" Mouse
set mouse=a
set nomousefocus
set nomousehide
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

" Syntax highlight
syntax on

" Display cursor line & column
set cursorline
set cursorcolumn

" No cursor line & column at other window
augroup MyGVimrc
  autocmd BufWinEnter,WinEnter *
    \ if !exists('b:nocursorline') || !b:nocursorline |
    \   setlocal cursorline |
    \ endif |
    \ if !exists('b:nocursorcolumn') || !b:nocursorcolumn |
    \   setlocal cursorcolumn |
    \ endif
  autocmd BufWinLeave,WinLeave *
    \ if !exists('b:nocursorline') || !b:nocursorline |
    \   setlocal nocursorline |
    \ endif |
    \ if !exists('b:nocursorcolumn') || !b:nocursorcolumn |
    \   setlocal nocursorcolumn |
    \ endif
augroup END

" Colorscheme
silent! colorscheme molokai

" Cursor color
autocmd MyGVimrc GUIEnter,ColorScheme *
  \ highlight clear Cursor |
  \ highlight clear CursorIM |
  \ highlight Cursor   guifg=#000000 guibg=#eedd82 |
  \ highlight CursorIM guifg=#000000 guibg=#6495ed

" Font
if has('win32') || has('win64')
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

" Vim size max
if has('win32') || has('win64')
  autocmd MyGVimrc GUIEnter *
    \ simalt ~x
else
  autocmd MyGVimrc GUIEnter *
    \ winpos 0 0 |
    \ set lines=999 columns=9999
endif
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
" Vim Script: {{{

"-----------------------------------------------------------------------------
" Script Scope: {{{
function! s:getscrname(expr, name)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return join(['<SNR>', m[1], '_', a:name], '')
      endif
  endfor
endfunction
function! s:getscrfunc(expr, funcname)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return function(join(['<SNR>', m[1], '_', a:funcname], ''))
      endif
  endfor
endfunction
function! s:getscrvar(expr, varname)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return eval(join(['<SNR>', m[1], '_', a:varname], ''))
      endif
  endfor
endfunction
function! s:setscrvar(expr, varname, val)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        execute 'let' join(['<SNR>', m[1], '_', a:varname], '') '=' a:val
        return
      endif
  endfor
endfunction
"}}}
"}}}