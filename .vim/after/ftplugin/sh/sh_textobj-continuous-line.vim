" TextObj Continuous Line ftplugin for Shell
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  10-Sep-2015.
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

if !exists('g:loaded_textobj_continuous_line') && (!exists('*neobundle#get') ||
\ get(neobundle#get('textobj-continuous-line'), 'disabled', 1))
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

xmap <buffer> a<Bslash> <Plug>(textobj-continuous-cpp-a)
omap <buffer> a<Bslash> <Plug>(textobj-continuous-cpp-a)
xmap <buffer> i<Bslash> <Plug>(textobj-continuous-cpp-i)
omap <buffer> i<Bslash> <Plug>(textobj-continuous-cpp-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "xunmap <buffer> a<Bslash>" |
\ silent! execute "ounmap <buffer> a<Bslash>" |
\ silent! execute "xunmap <buffer> i<Bslash>" |
\ silent! execute "ounmap <buffer> i<Bslash>"'

let &cpo = s:save_cpo
unlet s:save_cpo
