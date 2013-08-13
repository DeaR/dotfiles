" SmartChr ftplugin for C#
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  13-Aug-2013.
" License:      MIT License {{{
"     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
"
"     Permission is hereby granted, free of charge, to any person obtaining a
"     copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

function! s:smartchr_equal()
  for c in ['<<', '>>', '+', '-', '*', '/', '%', '^', '&', '|', '<', '>', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '=\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '= ', ec . '=')
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ' ' . ec . '= ', ec . '=')
    endif
  endfor
  return smartchr#one_of(' = ', ' == ', '=')
endfunction
inoremap <buffer><expr> = <SID>smartchr_equal()

function! s:smartchr_star()
  if search('\V\^\s\*\%#') &&
    \ synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') ==# 'Comment'
    return "* \<C-F>"
  elseif search('\V /*\? \%#', 'bcnW')
    return smartchr#one_of(' / ', '/*')
  elseif search('\V/\%#', 'bcnW')
    return smartchr#one_of('/', '/*')
  else
    return smartchr#one_of(' * ', '*')
  endif
endfunction
inoremap <buffer><expr> * <SID>smartchr_star()

inoremap <buffer><expr> >
  \ search('\V - \%#', 'bcnW') ?
  \   smartchr#one_of(' - ', '->', ' -> ') :
  \   search('\V->\?\%#', 'bcnW') ?
  \     smartchr#one_of('-', '->', ' -> ') :
  \     smartchr#one_of(' > ', ' >> ', '>')

inoremap <buffer><expr> /
  \ search('\V */\? \%#', 'bcnW') ?
  \   smartchr#one_of(' * ', '*/<C-F>') :
  \   search('\V*\%#', 'bcnW') ?
  \     smartchr#one_of('*', '*/<C-F>') :
  \     smartchr#one_of(' / ', '// ', '/// ', '/')

inoremap <buffer><expr> +  smartchr#one_of(' + ',  '++', '+')
inoremap <buffer><expr> -  smartchr#one_of(' - ',  '--', '-')
inoremap <buffer><expr> %  smartchr#one_of(' % ',  '%')
inoremap <buffer><expr> ^  smartchr#one_of(' ^ ',  '^')
inoremap <buffer><expr> :  smartchr#one_of(' : ',  ':')
inoremap <buffer><expr> ?  smartchr#one_of(' ? ',  ' ?? ',   '?')
inoremap <buffer><expr> &  smartchr#one_of(' & ',  ' && ',   '&')
inoremap <buffer><expr> \| smartchr#one_of(' \| ', ' \|\| ', '\|')
inoremap <buffer><expr> <  smartchr#one_of(' < ',  ' << ',   '<')

inoremap <buffer><expr> ,  smartchr#one_of(', ',   ',')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> =|
  \ silent! iunmap <buffer> *|
  \
  \ silent! iunmap <buffer> >|
  \ silent! iunmap <buffer> /|
  \
  \ silent! iunmap <buffer> +|
  \ silent! iunmap <buffer> -|
  \ silent! iunmap <buffer> %|
  \ silent! iunmap <buffer> :|
  \ silent! iunmap <buffer> ?|
  \ silent! iunmap <buffer> ^|
  \ silent! iunmap <buffer> &|
  \ silent! iunmap <buffer> \||
  \ silent! iunmap <buffer> <|
  \
  \ silent! iunmap <buffer> ,'

let &cpo = s:save_cpo
unlet s:save_cpo
