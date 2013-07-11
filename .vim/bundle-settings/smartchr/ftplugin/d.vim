" -*- mode: vimrc; coding: unix -*-

" @name        d.vim
" @description SmartChr ftplugin for D
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-11 19:45:54 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:smartchr_equal()
  for c in ['^^', '!<>', '<>', '!>', '!<', '>>>', '<<', '>>', '+', '-', '*', '/', '%', '^', '&', '|', '<', '>', '!', '~']
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

function! s:smartchr_greater_than()
  for c in ['!<', '<', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '>\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '> ', ec . '>')
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ' ' . ec . '> ', ec . '>')
    endif
  endfor
  return smartchr#one_of(' > ', ' >> ', '>>>', '>')
endfunction
inoremap <buffer><expr> > <SID>smartchr_greater_than()

function! s:smartchr_slash()
  for c in ['+', '*']
    let ec = escape(c, '\')
    if search('\V ' . ec . '/\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ',  ec . "/\<C-F>")
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ec . "/\<C-F>")
    endif
  endfor
  return smartchr#one_of(' / ', '// ', '/')
endfunction
inoremap <buffer><expr> / <SID>smartchr_slash()

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

function! s:smartchr_plus()
  if search('\V\^\s\*\%#') &&
    \ synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') ==# 'Comment'
    return smartchr#one_of(' + ', '+')
  elseif search('\V /+\? \%#', 'bcnW')
    return smartchr#one_of(' / ', '/+')
  elseif search('\V/\%#', 'bcnW')
    return smartchr#one_of('/', '/+')
  else
    return smartchr#one_of(' + ', ' ++ ', '+')
  endif
endfunction
inoremap <buffer><expr> + <SID>smartchr_plus()

inoremap <buffer><expr> <
  \ search('\V !<\? \%#', 'bcnW') ?
  \   smartchr#one_of(' ! ', ' !< ', '!<') :
  \   search('\V!\%#', 'bcnW') ?
  \     smartchr#one_of('!', ' !< ', '!<') :
  \     smartchr#one_of(' < ', ' << ', '<')

inoremap <buffer><expr> -  smartchr#one_of(' - ',  '--', '-')
inoremap <buffer><expr> %  smartchr#one_of(' % ',  '%')
inoremap <buffer><expr> ~  smartchr#one_of(' ~ ',  '~')
inoremap <buffer><expr> :  smartchr#one_of(' : ',  ':')
inoremap <buffer><expr> ?  smartchr#one_of(' ? ',  '?')
inoremap <buffer><expr> ^  smartchr#one_of(' ^ ',  ' ^^ ',   '^')
inoremap <buffer><expr> &  smartchr#one_of(' & ',  ' && ',   '&')
inoremap <buffer><expr> \| smartchr#one_of(' \| ', ' \|\| ', '\|')

inoremap <buffer><expr> ,  smartchr#one_of(', ',   ',')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> =|
  \ silent! iunmap <buffer> >|
  \ silent! iunmap <buffer> /|
  \ silent! iunmap <buffer> *|
  \ silent! iunmap <buffer> +|
  \
  \ silent! iunmap <buffer> <|
  \
  \ silent! iunmap <buffer> -|
  \ silent! iunmap <buffer> %|
  \ silent! iunmap <buffer> ~|
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
