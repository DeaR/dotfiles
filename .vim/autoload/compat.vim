" Vim compatibility
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  27-May-2016.
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
"     THE OSFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
"     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE OSFTWARE OR
"     THE USE OR OTHER DEALINGS IN THE OSFTWARE.
" }}}

"------------------------------------------------------------------------------
" Vim.Compat.has_version: {{{
" 7.4.237  (after 7.4.236) has() not checking for specific patch
if has('patch-7.4.237')
  function! compat#has_patch(args) abort
    return has('patch-' . a:args)
  endfunction
else
  function! compat#has_patch(args) abort
    let a = split(a:args, '\.')
    let v = a[0] * 100 + a[1]
    return v:version > v || v:version == v && has('patch' . a[2])
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Vim.Compat.shiftwidth: {{{
" 7.3.629  there is no way to make 'shiftwidth' follow 'tabstop'
" 7.3.694  'shiftwidth' is not so easy to use in indent files
if exists('*shiftwidth')
  function! compat#shiftwidth() abort
    return shiftwidth()
  endfunction
elseif compat#has_patch('7.3.629')
  function! compat#shiftwidth() abort
    return &shiftwidth ? &shiftwidth : &tabstop
  endfunction
else
  function! compat#shiftwidth() abort
    return &shiftwidth
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Vim.Compat.writefile: {{{
" 7.4.503  cannot append a list of lines to a file
if compat#has_patch('7.4.503')
  function! compat#writefile(...) abort
    return call('writefile', a:000)
  endfunction
else
  function! compat#writefile(list, fname, ...) abort
    let flags = get(a:000, 0, '')
    if flags !~# 'a'
      return writefile(a:list, a:fname, flags)
    elseif flags !~# 'b'
      let list = readfile(a:fname, flags)
      return writefile(list + a:list, a:fname, flags)
    else
      let list = readfile(a:fname, flags)
      let connect = list[-1] . (type(a:list[0]) == type('') ?
      \ a:list[0] : string(a:list[0]))
      return writefile(list[:-2] + [connect] + a:list[1:], a:fname, flags)
    endif
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Vim.Compat.doautocmd: {{{
" 7.3.438  there is no way to avoid ":doautoall" reading modelines
if compat#has_patch('7.3.438')
  function! compat#doautocmd(...) abort
    execute 'doautocmd' join(a:000)
  endfunction
else
  function! compat#doautocmd(...) abort
    execute 'doautocmd' substitute(join(a:000), '^\s*<nomodeline>', '', '')
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Vim.Compat.getbufvar, Vim.Compat.getwinvar: {{{
" 7.3.831  clumsy to handle the situation that a variable does not exist
if compat#has_patch('7.3.831')
  function! compat#getbufvar(...) abort
    return call('getbufvar', a:000)
  endfunction
  function! compat#getwinvar(...) abort
    return call('getwinvar', a:000)
  endfunction
else
  function! compat#getbufvar(expr, varname, ...) abort
    let v = getbufvar(a:expr, a:varname)
    return empty(v) ? get(a:000, 0, '') : v
  endfunction
  function! compat#getwinvar(expr, varname, ...) abort
    let v = getwinvar(a:expr, a:varname)
    return empty(v) ? get(a:000, 0, '') : v
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Prelude.glob: {{{
" 7.3.465  cannot get file name with newline from glob()
" 7.4.654  glob()/ globpath() cannot include links to non-existing files
if compat#has_patch('7.4.654')
  function! compat#glob(...) abort
    return call('glob', a:000)
  endfunction
elseif compat#has_patch('7.3.465')
  function! compat#glob(...) abort
    return call('glob', a:000[:2])
  endfunction
else
  function! compat#glob(...) abort
    return get(a:000, 2) ?
    \ split(call('glob', a:000[:1]), '\n') :
    \ call('glob', a:000[:1])
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Prelude.globpath: {{{
" 7.4.279  globpath() returns a string, a list would be better
" 7.4.654  glob()/ globpath() cannot include links to non-existing files
if compat#has_patch('7.4.654')
  function! compat#globpath(...) abort
    return call('globpath', a:000)
  endfunction
elseif compat#has_patch('7.4.279')
  function! compat#globpath(...) abort
    return call('globpath', a:000[:3])
  endfunction
else
  function! compat#globpath(...) abort
    return get(a:000, 3) ?
    \ split(call('globpath', a:000[:2]), '\n') :
    \ call('globpath', a:000[:2])
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Filepath.which: {{{
" 7.4.235  it is not easy to get the full path of a command
if exists('*exepath')
  function! compat#exepath(expr) abort
    return exepath(a:expr)
  endfunction
else
  function! compat#exepath(expr) abort
    let path = split($PATH, has('win32') ? ';' : ':')
    let ext  = has('win32') ? split($PATHEXT, ';') :
    \ has('win32unix') ? ['', '.exe'] : ['']
    let sep  = fnamemodify('.', ':p')[-1:]
    for p in path
      let h = p ==# '' ? '' : (p . sep)
      for e in ext
        let name = fnamemodify(h . a:expr . e, ':p')
        if filereadable(name)
          return name
        endif
      endfor
    endfor
    return ''
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" system(): {{{
" 7.4.247  NUL and NL mixed up when giving input to system()
if compat#has_patch('7.4.247')
  function! compat#system(...) abort
    return call('system', a:000)
  endfunction
else
  function! compat#system(expr, ...) abort
    let input = get(a:000, 0)
    if type(input) == type([])
      let input = join(input, '\n')
    endif
    return system(a:expr, input)
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" systemlist(): {{{
" 7.4.248  cannot distinguish between NL and NUL in output of system()
if exists('*systemlist')
  function! compat#systemlist(...) abort
    return call('systemlist', a:000)
  endfunction
else
  function! compat#systemlist(...) abort
    let r = call('compat#system', a:000)
    return empty(r) ? '' :
    \ map(split(r, '\n'), 'substitute(v:val, 0, "\\n", "")')
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" glob2regpat(): {{{
" 7.4.668  can't use a glob pattern as a regexp pattern
if exists('*glob2regpat')
  function! compat#glob2regpat(...) abort
    return call('glob2regpat', a:000)
  endfunction
else
  function! compat#glob2regpat(expr) abort
    let pat = split(a:expr, '\zs')
    let reg_pat = []
    let nested = 0
    let add_dollar = 0
    if pat[0] != '*'
      let pat = pat[1:]
    else
      call add(reg_pat, '^')
    endif
    if pat[-1] == '*'
      let pat = pat[:-2]
    else
      let add_dollar = 1
    endif
    for p in pat
      if p == '*'
        call add(reg_pat, '.*')
      elseif p == '.' || p == '~'
        call add(reg_pat, '\' . p)
      elseif p == '?'
        call add(reg_pat, '.')
      elseif p == '\' || p == '/'
        call add(reg_pat, '[\/]')
      elseif p == '{'
        call add(reg_pat, '\(')
        let nested += 1
      elseif p == '}'
        call add(reg_pat, '\)')
        let nested -= 1
      elseif p == ',' && nested
        call add(reg_pat, '\|')
      else
        call add(reg_pat, p)
      endif
    endfor
    if nested < 0
      echoerr 'E219: Missing {.'
    elseif nested > 0
      echoerr 'E220: Missing }.'
    elseif add_dollar
      call add(reg_pat, '$')
    endif
    return join(reg_pat, '')
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" sort(), uniq(): {{{
" 7.4.218  it's not easy to remove duplicates from a list
" 7.4.341  sort() doesn't handle numbers well
" 7.4.951  sorting number strings does not work as expected
" 7.4.1143  can't sort on floating point numbers
if compat#has_patch('7.4.1143')
  function! compat#sort(...) abort
    return call('sort', a:000)
  endfunction
  function! compat#uniq(...) abort
    return call('uniq', a:000)
  endfunction
elseif compat#has_patch('7.4.951')
  function! compat#sort(list, ...) abort
    let func = get(a:000, 0)
    return sort(a:list,
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
  function! compat#uniq(list, ...) abort
    let func = get(a:000, 0)
    return uniq(a:list,
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
elseif compat#has_patch('7.4.341')
  function! compat#sort(list, ...) abort
    let func = get(a:000, 0)
    return sort(a:list,
    \ func ==# 'N' ? 's:compare_N' :
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
  function! compat#uniq(list, ...) abort
    let func = get(a:000, 0)
    return uniq(a:list,
    \ func ==# 'N' ? 's:compare_N' :
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
elseif compat#has_patch('7.4.218')
  function! compat#sort(list, ...) abort
    let func = get(a:000, 0)
    return sort(a:list,
    \ func ==# '1' ? 's:compare_1' :
    \ func ==# 'i' ? 's:compare_1' :
    \ func ==# 'n' ? 's:compare_n' :
    \ func ==# 'N' ? 's:compare_N' :
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
  function! compat#uniq(list, ...) abort
    let func = get(a:000, 0)
    return uniq(a:list,
    \ func ==# '1' ? 's:compare_1' :
    \ func ==# 'i' ? 's:compare_1' :
    \ func ==# 'n' ? 's:compare_n' :
    \ func ==# 'N' ? 's:compare_N' :
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
else
  function! compat#sort(list, ...) abort
    let func = get(a:000, 0)
    return sort(a:list,
    \ func ==# '1' ? 's:compare_1' :
    \ func ==# 'i' ? 's:compare_1' :
    \ func ==# 'n' ? 's:compare_n' :
    \ func ==# 'N' ? 's:compare_N' :
    \ func ==# 'f' ? 's:compare_f' :
    \ func)
  endfunction
  function! compat#uniq(list, ...) abort
    let func = get(a:000, 0)
    let r = a:list[0]
    for l in a:list[1:]
      if call(
      \ empty(func)  ? 's:compare_0' :
      \ func ==# '1' ? 's:compare_1' :
      \ func ==# 'i' ? 's:compare_1' :
      \ func ==# 'n' ? 's:compare_n' :
      \ func ==# 'N' ? 's:compare_N' :
      \ func ==# 'f' ? 's:compare_f' :
      \ func, [r[-1], l])
        call add(r, l)
      endif
    endfor
    return r
  endfunction
endif

if !compat#has_patch('7.4.218')
  function! s:compare_0(i1, i2) abort
    return i1 ==# i2 ? 0 : i1 ># i2 ? 1 : -1
  endfunction
endif
if !compat#has_patch('7.4.341')
  function! s:compare_1(i1, i2) abort
    return i1 ==? i2 ? 0 : i1 >? i2 ? 1 : -1
  endfunction
  function! s:compare_n(i1, i2) abort
    let i1 = type(a:i1) == type(0) || type(a:i1) == type(0.0) ? a:i1 : 0
    let i2 = type(a:i2) == type(0) || type(a:i2) == type(0.0) ? a:i2 : 0
    return i1 == i2 ? 0 : i1 > i2 ? 1 : -1
  endfunction
endif
if !compat#has_patch('7.4.951')
  function! s:compare_N(i1, i2) abort
    let i1 = a:i1 != type('') ? a:i1 : compat#str2nr(a:i1,
    \ a:i1 =~? '0x\x\+'   ? 16 :
    \ a:i1 =~? '0\d\+'    ? 8 :
    \ a:i1 =~? '0b[01]\+' ? 2 : 10)
    let i2 = a:i2 != type('') ? a:i2 : compat#str2nr(a:i2,
    \ a:i2 =~? '0x\x\+'   ? 16 :
    \ a:i2 =~? '0\d\+'    ? 8 :
    \ a:i2 =~? '0b[01]\+' ? 2 : 10)
    return i1 == i2 ? 0 : i1 > i2 ? 1 : -1
  endfunction
endif
if !compat#has_patch('7.4.1143')
  function! s:compare_f(i1, i2) abort
    if type(a:i1) == type(function('tr'))
      echoerr 'E891: Using a Funcref as a Float'
    elseif type(a:i1) == type('')
      echoerr 'E892: Using a String as a Float'
    elseif type(a:i1) == type([])
      echoerr 'E893: Using a List as a Float'
    elseif type(a:i1) == type({})
      echoerr 'E894: Using a Dictionary as a Float'
    endif
    if type(a:i2) == type(function('tr'))
      echoerr 'E891: Using a Funcref as a Float'
    elseif type(a:i2) == type('')
      echoerr 'E892: Using a String as a Float'
    elseif type(a:i2) == type([])
      echoerr 'E893: Using a List as a Float'
    elseif type(a:i2) == type({})
      echoerr 'E894: Using a Dictionary as a Float'
    endif
    return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" str2nr(): {{{
" 7.4.1027  No support for binary numbers.
if compat#has_patch('7.4.1027')
  function! compat#str2nr(...)
    return call('str2nr', a:000)
  endfunction
else
  function! compat#str2nr(expr, ...)
    let base = get(a:000, 0, 10)
    if base == 2
      let r = 0
      for c in split(matchstr(a:expr, '0b\zs[01]\+\c'), '\zs')
        let r = r * 2
        if c == '1'
          let r += 1
        endif
      endfor
      return r
    else
      return call('str2nr', [a:expr] + a:000)
    endif
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" resolve(): {{{
" FIXME
if has('win32') && executable('realpath') && executable('cygpath')
  function! compat#resolve(...) abort
    return system('realpath ' . shellescape(call('resolve', a:000)) .
    \ ' | cygpath -w -f -')
  endfunction
else
  function! compat#resolve(...) abort
    return call('resolve', a:000)
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" expand(): {{{
if exists('+shellslash')
  function! compat#expand_slash(...) abort
    let save_ssl = &shellslash
    try
      set shellslash
      return call('expand', a:000)
    finally
      let &shellslash = save_ssl
    endtry
  endfunction
else
  function! compat#expand_slash(...) abort
    return call('expand', a:000)
  endfunction
endif
" }}}
