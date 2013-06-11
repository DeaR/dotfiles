" -*- mode: vimrc; coding: unix -*-

" @name        unite.vim
" @description NeoComplet ftplugin for Unite
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-11 22:05:35 DeaR>

let s:save_cpo = &cpo
set cpo&vim

silent! iunmap <buffer> <Tab>
silent! iunmap <buffer> <S-Tab>
silent! iunmap <buffer> <C-L>

let &cpo = s:save_cpo
unlet s:save_cpo
