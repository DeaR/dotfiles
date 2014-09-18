" TextObj Continuous Line ftplugin for Python
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  24-Feb-2014.
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

let s:save_cpo = &cpo
set cpo&vim

xmap <buffer> a<Bslash> <Plug>(textobj-continuous-python-a)
omap <buffer> a<Bslash> <Plug>(textobj-continuous-python-a)
xmap <buffer> i<Bslash> <Plug>(textobj-continuous-python-i)
omap <buffer> i<Bslash> <Plug>(textobj-continuous-python-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! execute ''xunmap <buffer> a<Bslash>'' |
  \ silent! execute ''ounmap <buffer> a<Bslash>'' |
  \ silent! execute ''xunmap <buffer> i<Bslash>'' |
  \ silent! execute ''ounmap <buffer> i<Bslash>'''

let &cpo = s:save_cpo
unlet s:save_cpo
