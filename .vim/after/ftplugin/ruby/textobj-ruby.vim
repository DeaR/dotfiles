" TextObj Ruby
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  15-Jun-2016.
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

if !exists('g:loaded_textobj_ruby') &&
\ empty(exists('*dein#get') ? dein#get('textobj-ruby') : 0)
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

omap <buffer> ar  <Nop>
xmap <buffer> ar  <Nop>
omap <buffer> arr <Plug>(textobj-ruby-any-a)
xmap <buffer> arr <Plug>(textobj-ruby-any-a)
omap <buffer> aro <Plug>(textobj-ruby-definition-a)
xmap <buffer> aro <Plug>(textobj-ruby-definition-a)
omap <buffer> arl <Plug>(textobj-ruby-loop-a)
xmap <buffer> arl <Plug>(textobj-ruby-loop-a)
omap <buffer> arc <Plug>(textobj-ruby-control-a)
xmap <buffer> arc <Plug>(textobj-ruby-control-a)
omap <buffer> ard <Plug>(textobj-ruby-do-a)
xmap <buffer> ard <Plug>(textobj-ruby-do-a)

omap <buffer> ir  <Nop>
xmap <buffer> ir  <Nop>
omap <buffer> irr <Plug>(textobj-ruby-any-i)
xmap <buffer> irr <Plug>(textobj-ruby-any-i)
omap <buffer> iro <Plug>(textobj-ruby-definition-i)
xmap <buffer> iro <Plug>(textobj-ruby-definition-i)
omap <buffer> irl <Plug>(textobj-ruby-loop-i)
xmap <buffer> irl <Plug>(textobj-ruby-loop-i)
omap <buffer> irc <Plug>(textobj-ruby-control-i)
xmap <buffer> irc <Plug>(textobj-ruby-control-i)
omap <buffer> ird <Plug>(textobj-ruby-do-i)
xmap <buffer> ird <Plug>(textobj-ruby-do-i)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ silent! execute "ounmap <buffer> aC" |
\ silent! execute "xunmap <buffer> aC" |
\ silent! execute "ounmap <buffer> iC" |
\ silent! execute "xunmap <buffer> iC" |
\ silent! execute "ounmap <buffer> ar" |
\ silent! execute "xunmap <buffer> ar" |
\ silent! execute "ounmap <buffer> ir" |
\ silent! execute "xunmap <buffer> ir"'

let &cpo = s:save_cpo
unlet s:save_cpo
