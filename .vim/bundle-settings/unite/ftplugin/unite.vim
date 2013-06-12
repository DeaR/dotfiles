" -*- mode: vimrc; coding: unix -*-

" @name        unite.vim
" @description Unite ftplugin for Unite
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-10 22:11:28 DeaR>

let s:save_cpo = &cpo
set cpo&vim

function! s:check_back_space()
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

silent! iunmap <buffer> <Tab>
silent! iunmap <buffer> <S-Tab>
silent! iunmap <buffer> <C-L>

nmap <buffer> <C-J> <Plug>(unite_choose_action)
imap <buffer> <C-J> <Plug>(unite_choose_action)
imap <buffer> <M-H> <Plug>(unite_move_head)

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
  \ silent! nunmap <buffer> <C-J> |
  \ silent! iunmap <buffer> <C-J> |
  \ silent! iunmap <buffer> <M-H> |
  \
  \ silent! nunmap <buffer> <C-S> |
  \ silent! iunmap <buffer> <C-S> |
  \ silent! nunmap <buffer> <C-V> |
  \ silent! iunmap <buffer> <C-V>'

let &cpo = s:save_cpo
unlet s:save_cpo
