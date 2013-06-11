" -*- mode: vimrc; coding: unix -*-

" @name        java.vim
" @description SmartChr ftplugin for Java
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:33:33 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:smartchr_equal()
  for c in ['>>>', '<<', '>>', '+', '-', '*', '/', '%', '^', '&', '|', '<', '>', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '=\? \%#', 'bcn')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '= ', ec . '=')
    elseif search('\V' . ec . '=\?\%#', 'bcn')
      return smartchr#one_of(ec, ' ' . ec . '= ', ec . '=')
    endif
  endfor
  return smartchr#one_of(' = ', ' == ', ' === ', '=')
endfunction
inoremap <buffer><expr> = <SID>smartchr_equal()

inoremap <buffer><expr> *
  \ search('\V /*\? \%#', 'bcn') ?
  \   smartchr#one_of(' / ', '/*') :
  \   search('\V/*\?\%#', 'bcn') ?
  \     smartchr#one_of('/', '/*') :
  \     smartchr#one_of(' * ', '*')

inoremap <buffer><expr> /
  \ search('\V */\? \%#', 'bcn') ?
  \   smartchr#one_of(' * ', '*/' . nr2char(6)) :
  \   search('\V*/\?\%#', 'bcn') ?
  \     smartchr#one_of('*', '*/' . nr2char(6)) :
  \     smartchr#one_of(' / ', '// ', '/')

inoremap <buffer><expr> +  smartchr#one_of(' + ',  '++', '+')
inoremap <buffer><expr> -  smartchr#one_of(' - ',  '--', '-')
inoremap <buffer><expr> %  smartchr#one_of(' % ',  '%')
inoremap <buffer><expr> :  smartchr#one_of(' : ',  ':')
inoremap <buffer><expr> ?  smartchr#one_of(' ? ',  '?')
inoremap <buffer><expr> ^  smartchr#one_of(' ^ ',  '^')
inoremap <buffer><expr> &  smartchr#one_of(' & ',  ' && ',   '&')
inoremap <buffer><expr> \| smartchr#one_of(' \| ', ' \|\| ', '\|')
inoremap <buffer><expr> <  smartchr#one_of(' < ',  ' << ',   '<')
inoremap <buffer><expr> >  smartchr#one_of(' > ',  ' >> ',   '>>>', '>')

inoremap <buffer><expr> ,  smartchr#one_of(', ',   ',')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> = |
  \
  \ silent! iunmap <buffer> * |
  \ silent! iunmap <buffer> / |
  \
  \ silent! iunmap <buffer> + |
  \ silent! iunmap <buffer> - |
  \ silent! iunmap <buffer> % |
  \ silent! iunmap <buffer> : |
  \ silent! iunmap <buffer> ? |
  \ silent! iunmap <buffer> ^ |
  \ silent! iunmap <buffer> & |
  \ silent! iunmap <buffer> \| |
  \ silent! iunmap <buffer> < |
  \ silent! iunmap <buffer> > |
  \
  \ silent! iunmap <buffer> ,'

let &cpo = s:save_cpo
unlet s:save_cpo