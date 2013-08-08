" -*- mode: vimrc; coding: unix -*-

" @name        map-vimfiler.vim
" @description Mapping for VimFiler
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-08 16:30:14 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nmap <buffer> <SID>(vimfiler_redraw_screen) <Plug>(vimfiler_redraw_screen)
xmap <buffer> <SID>(vimfiler_redraw_screen) <Plug>(vimfiler_redraw_screen)

nnoremap <buffer><script> <C-W>=  <C-W>=<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>=  <C-W>+<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>-  <C-W>-<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>-  <C-W>-<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>+  <C-W>+<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>+  <C-W>+<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>_  <C-W>_<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>_  <C-W>_<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W><  <C-W><<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W><  <C-W><<SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>>  <C-W>><SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>>  <C-W>><SID>(vimfiler_redraw_screen)
nnoremap <buffer><script> <C-W>\| <C-W>\|<SID>(vimfiler_redraw_screen)
xnoremap <buffer><script> <C-W>\| <C-W>\|<SID>(vimfiler_redraw_screen)

nmap <buffer> <M-=>  <C-W>=
xmap <buffer> <M-=>  <C-W>=
nmap <buffer> <M-->  <C-W>-
xmap <buffer> <M-->  <C-W>-
nmap <buffer> <M-+>  <C-W>+
xmap <buffer> <M-+>  <C-W>+
nmap <buffer> <M-_>  <C-W>_
xmap <buffer> <M-_>  <C-W>_
nmap <buffer> <M-<>  <C-W><
xmap <buffer> <M-<>  <C-W><
nmap <buffer> <M->>  <C-W>>
xmap <buffer> <M->>  <C-W>>
nmap <buffer> <M-\|> <C-W>\|
xmap <buffer> <M-\|> <C-W>\|

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ nunmap <SID>(vimfiler_redraw_screen)|
  \ xunmap <SID>(vimfiler_redraw_screen)|
  \
  \ nunmap <C-W>=|
  \ xunmap <C-W>=|
  \ nunmap <C-W>-|
  \ xunmap <C-W>-|
  \ nunmap <C-W>+|
  \ xunmap <C-W>+|
  \ nunmap <C-W>_|
  \ xunmap <C-W>_|
  \ nunmap <C-W><|
  \ xunmap <C-W><|
  \ nunmap <C-W>>|
  \ xunmap <C-W>>|
  \ nunmap <C-W>\||
  \ xunmap <C-W>\||
  \
  \ nunmap <M-=>|
  \ xunmap <M-=>|
  \ nunmap <M-->|
  \ xunmap <M-->|
  \ nunmap <M-+>|
  \ xunmap <M-+>|
  \ nunmap <M-_>|
  \ xunmap <M-_>|
  \ nunmap <M-<>|
  \ xunmap <M-<>|
  \ nunmap <M->>|
  \ xunmap <M->>|
  \ nunmap <M-\|>|
  \ xunmap <M-\|>'

let &cpo = s:save_cpo
unlet s:save_cpo
