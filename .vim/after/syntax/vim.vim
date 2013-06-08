" -*- mode: vimrc; coding: unix -*-

" @name        vim.vim
" @description Syntax settings for Vim 7.3 Script
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-05-18 18:03:34 DeaR>

let s:save_cpo = &cpo
set cpo&vim

syntax keyword vimMap NVmap NOmap NXmap NSmap VOmap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap OXmap OSmap NOXmap NOSmap       skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NVnoremap NOnoremap NXnoremap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NSnoremap VOnoremap OXnoremap   skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap OSnoremap NOXnoremap NOSnoremap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs

let &cpo = s:save_cpo
unlet s:save_cpo
