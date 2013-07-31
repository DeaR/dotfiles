" -*- mode: vimrc; coding: unix -*-

" @name        map-unite.vim
" @description Mapping for Unite
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-31 13:33:43 DeaR>

let s:save_cpo = &cpo
set cpo&vim

silent! iunmap <buffer> <Tab>
silent! iunmap <buffer> <S-Tab>

nnoremap <buffer><silent><expr> dd
  \ unite#smart_map('d', unite#do_action('delete'))
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
  \ silent! nunmap <buffer> dd|
  \ silent! nunmap <buffer> <C-J>|
  \ silent! iunmap <buffer> <C-J>|
  \ silent! iunmap <buffer> <M-H>|
  \
  \ silent! nunmap <buffer> <C-S>|
  \ silent! iunmap <buffer> <C-S>|
  \ silent! nunmap <buffer> <C-V>|
  \ silent! iunmap <buffer> <C-V>'

let &cpo = s:save_cpo
unlet s:save_cpo
