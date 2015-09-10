" TextObj Python ftplugin for Python
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

if !exists('g:loaded_textobj_pyhon') && (!exists('*neobundle#get') ||
\ get(neobundle#get('textobj-pyhon'), 'disabled', 1))
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

xmap <buffer> aF <Plug>(textobj-python-function-a)
omap <buffer> aF <Plug>(textobj-python-function-a)
xmap <buffer> aC <Plug>(textobj-python-class-a)
omap <buffer> aC <Plug>(textobj-python-class-a)
xmap <buffer> iF <Plug>(textobj-python-function-i)
omap <buffer> iF <Plug>(textobj-python-function-i)
xmap <buffer> iC <Plug>(textobj-python-class-i)
omap <buffer> iC <Plug>(textobj-python-class-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "xunmap <buffer> aF" |
\ silent! execute "ounmap <buffer> aF" |
\ silent! execute "xunmap <buffer> iC" |
\ silent! execute "ounmap <buffer> iC" |
\ silent! execute "xunmap <buffer> aF" |
\ silent! execute "ounmap <buffer> aF" |
\ silent! execute "xunmap <buffer> iC" |
\ silent! execute "ounmap <buffer> iC"'

let &cpo = s:save_cpo
unlet s:save_cpo
