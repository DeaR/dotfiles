" -*- mode: vimrc; coding: unix -*-

" @name        vim.vim
" @description Syntax settings for Vim 7.3 Script
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-09 14:19:27 DeaR>

let s:save_cpo = &cpo
set cpo&vim

syntax keyword vimMap NVmap NXmap NSmap NOmap VOmap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap XOmap SOmap NXOmap NSOmap       skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NVnoremap NXnoremap NSnoremap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NOnoremap VOnoremap XOnoremap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap SOnoremap NXOnoremap NSOnoremap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs

let &cpo = s:save_cpo
unlet s:save_cpo
