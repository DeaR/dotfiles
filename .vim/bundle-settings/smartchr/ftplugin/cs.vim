" -*- mode: vimrc; coding: unix -*-

" @name        cs.vim
" @description SmartChr ftplugin for C#
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-11 19:39:14 DeaR>

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
