" -*- mode: vimrc; coding: unix -*-

" @name        unite.vim
" @description Unite ftplugin for Unite
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-07 22:30:44 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:check_back_space()
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <buffer><expr> <Tab>
  \  pumvisible() ?
  \   '<C-N>' :
  \   <SID>check_back_space() ?
  \     '<Tab>' :
  \     neocomplcache#start_manual_complete()
inoremap <buffer><expr> <S-Tab>
  \  pumvisible() ?
  \   '<C-P>' :
  \   <SID>check_back_space() ?
  \     '<S-Tab>' :
  \     neocomplcache#start_manual_complete()

nnoremap <buffer><silent><expr> <C-S> unite#do_action('split')
inoremap <buffer><silent><expr> <C-S> unite#do_action('split')
nnoremap <buffer><silent><expr> <C-V> unite#do_action('vsplit')
inoremap <buffer><silent><expr> <C-V> unite#do_action('vsplit')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! iunmap <buffer> <Tab> |
  \ silent! iunmap <buffer> <S-Tab> |
  \ silent! nunmap <buffer> <C-S> |
  \ silent! iunmap <buffer> <C-S> |
  \ silent! nunmap <buffer> <C-V> |
  \ silent! iunmap <buffer> <C-V>'

let &cpo = s:save_cpo
unlet s:save_cpo
