" -*- mode: vimrc; coding: unix -*-

" @name        ruby.vim
" @description SmartChr ftplugin for Ruby
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-12 03:29:28 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:smartchr_equal()
  for c in ['**', '<<', '>>', '&&', '||', '+', '-', '*', '/', '%', '^', '&', '|', '<', '>', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '=\? \%#', 'bcn')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '= ', ec . '=')
    elseif search('\V' . ec . '\%#', 'bcn')
      return smartchr#one_of(ec, ' ' . ec . '= ', ec . '=')
    endif
  endfor
  return smartchr#one_of(' = ', ' == ', ' === ', '=')
endfunction
inoremap <buffer><expr> = <SID>smartchr_equal()

function! s:smartchr_tilda()
  for c in ['=', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '~\? \%#', 'bcn')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '~ ', ec . '~')
    elseif search('\V' . ec . '\%#', 'bcn')
      return smartchr#one_of(ec, ' ' . ec . '~ ', ec . '~')
    endif
  endfor
  return '~'
endfunction
inoremap <buffer><expr> ~ <SID>smartchr_tilda()

inoremap <buffer><expr> >
  \ search('\V <=>\? \%#', 'bcn') ?
  \   smartchr#one_of(' <= ', ' <=> ', '<=>') :
  \   search('\V<=\%#', 'bcn') ?
  \     smartchr#one_of('<=', ' <=> ', '<=>') :
  \     smartchr#one_of(' > ', ' >> ', '>')

inoremap <buffer><expr> +  smartchr#one_of(' + ',  '++', '+')
inoremap <buffer><expr> -  smartchr#one_of(' - ',  '--', '-')
inoremap <buffer><expr> /  smartchr#one_of(' / ',  '/')
inoremap <buffer><expr> %  smartchr#one_of(' % ',  '%')
inoremap <buffer><expr> :  smartchr#one_of(' : ',  ':')
inoremap <buffer><expr> ?  smartchr#one_of(' ? ',  '?')
inoremap <buffer><expr> ^  smartchr#one_of(' ^ ',  '^')
inoremap <buffer><expr> &  smartchr#one_of(' & ',  ' && ',   '&')
inoremap <buffer><expr> \| smartchr#one_of(' \| ', ' \|\| ', '\|')
inoremap <buffer><expr> *  smartchr#one_of(' * ',  ' ** ',   '*')
inoremap <buffer><expr> <  smartchr#one_of(' < ',  ' << ',   '<')
inoremap <buffer><expr> .  smartchr#one_of(' . ',  ' .. ',   ' ... ', '.')

inoremap <buffer><expr> ,  smartchr#one_of(', ',   ',')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> = |
  \ silent! iunmap <buffer> ~ |
  \
  \ silent! iunmap <buffer> > |
  \
  \ silent! iunmap <buffer> + |
  \ silent! iunmap <buffer> - |
  \ silent! iunmap <buffer> / |
  \ silent! iunmap <buffer> % |
  \ silent! iunmap <buffer> : |
  \ silent! iunmap <buffer> ? |
  \ silent! iunmap <buffer> ^ |
  \ silent! iunmap <buffer> & |
  \ silent! iunmap <buffer> \| |
  \ silent! iunmap <buffer> * |
  \ silent! iunmap <buffer> < |
  \ silent! iunmap <buffer> . |
  \
  \ silent! iunmap <buffer> ,'

let &cpo = s:save_cpo
unlet s:save_cpo
