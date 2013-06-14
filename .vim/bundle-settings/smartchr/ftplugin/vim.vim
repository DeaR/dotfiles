" -*- mode: vimrc; coding: unix -*-

" @name        vim.vim
" @description SmartChr ftplugin for Vim
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-14 17:36:07 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:smartchr_equal()
  for c in ['+', '-', '*', '/', '%', '.', '&', '|', '<', '>', '!']
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

function! s:smartchr_tilda()
  for c in ['=', '!']
    let ec = escape(c, '\')
    if search('\V ' . ec . '~\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '~ ', ec . '~')
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ' ' . ec . '~ ', ec . '~')
    endif
  endfor
  return '~'
endfunction
inoremap <buffer><expr> ~ <SID>smartchr_tilda()

function! s:smartchr_question()
  for c in ['==', '!=', '>', '>=', '<', '<=', '=~', '!~']
    let ec = escape(c, '\')
    if search('\V ' . ec . '?\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '? ', ec . '?')
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ' ' . ec . '? ', ec . '?')
    endif
  endfor
  for c in ['is', 'isnot']
    let ec = escape(c, '\')
    if search('\V ' . ec . '?\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '? ', ' ' . ec . ' ?')
    endif
  endfor
  return smartchr#one_of(' ? ', '?')
endfunction
inoremap <buffer><expr> ? <SID>smartchr_question()

function! s:smartchr_sharp()
  for c in ['==', '!=', '>', '>=', '<', '<=', '=~', '!~']
    let ec = escape(c, '\')
    if search('\V ' . ec . '#\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '# ', ec . '#')
    elseif search('\V' . ec . '\%#', 'bcnW')
      return smartchr#one_of(ec, ' ' . ec . '# ', ec . '#')
    endif
  endfor
  for c in ['is', 'isnot']
    let ec = escape(c, '\')
    if search('\V ' . ec . '#\? \%#', 'bcnW')
      return smartchr#one_of(' ' . ec . ' ', ' ' . ec . '# ', ' ' . ec . ' #')
    endif
  endfor
  return '#'
endfunction
inoremap <buffer><expr> # <SID>smartchr_sharp()

inoremap <buffer><expr> +  smartchr#one_of(' + ',  '+')
inoremap <buffer><expr> -  smartchr#one_of(' - ',  '-')
inoremap <buffer><expr> *  smartchr#one_of(' * ',  '*')
inoremap <buffer><expr> /  smartchr#one_of(' / ',  '/')
inoremap <buffer><expr> %  smartchr#one_of(' % ',  '%')
inoremap <buffer><expr> :  smartchr#one_of(' : ',  ':')
inoremap <buffer><expr> &  smartchr#one_of(' & ',  ' && ',   '&')
inoremap <buffer><expr> \| smartchr#one_of(' \| ', ' \|\| ', '\|')
inoremap <buffer><expr> <  smartchr#one_of(' < ',  '<')
inoremap <buffer><expr> >  smartchr#one_of(' > ',  '>')
inoremap <buffer><expr> .  smartchr#one_of(' . ',  '.')

inoremap <buffer><expr> ,  smartchr#one_of(', ',   ',')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> =|
  \ silent! iunmap <buffer> ~|
  \ silent! iunmap <buffer> ?|
  \ silent! iunmap <buffer> #|
  \
  \ silent! iunmap <buffer> +|
  \ silent! iunmap <buffer> -|
  \ silent! iunmap <buffer> *|
  \ silent! iunmap <buffer> /|
  \ silent! iunmap <buffer> %|
  \ silent! iunmap <buffer> :|
  \ silent! iunmap <buffer> .|
  \ silent! iunmap <buffer> &|
  \ silent! iunmap <buffer> \||
  \ silent! iunmap <buffer> <|
  \ silent! iunmap <buffer> >|
  \
  \ silent! iunmap <buffer> ,'

let &cpo = s:save_cpo
unlet s:save_cpo
