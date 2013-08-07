" -*- mode: vimrc; coding: unix -*-

" @name        directory_dot.vim
" @description "." directory source for Unite.
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-07 20:09:51 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#directory_dot#define()
  return s:source
endfunction

let s:source = {
  \ 'name' : 'directory_dot',
  \ 'description' : 'directory dot',
  \ 'default_kind' : 'directory',
  \ 'alias_table' : {'unite__new_candidate' : 'vimfiler__mkdir'}}

function! s:source.change_candidates(args, context)
  let input_list = filter(split(a:context.input,
    \ '\\\@<! ', 1), 'v:val !~ "!"')
  let input = empty(input_list) ? '' : input_list[0]
  let input = substitute(substitute(
    \ a:context.input, '\\ ', ' ', 'g'), '^\a\+:\zs\*/', '/', '')
  if input != ''
    return []
  endif

  let path = join(a:args, ':')
  if path !=# '/' && path =~ '[\\/]$'
    " Chomp.
    let path = path[: -2]
  elseif path == ''
    let path = '.'
  endif

  let is_relative_path = path !~ '^\%(/\|\a\+:/\)'

  let newfile = unite#util#expand(
        \ escape(substitute(path, '[*\\]', '', 'g'), ''))

  " Return newfile candidate.
  return [unite#sources#file#create_file_dict(
    \ newfile, is_relative_path)]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
