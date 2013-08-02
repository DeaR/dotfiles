" -*- mode: vimrc; coding: unix -*-

" @name        objcpp.vim
" @description Filetype plugin for Objective-C++
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-08-02 14:58:04 DeaR>

let s:save_cpo = &cpo
set cpo&vim

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/cpp.vim ftplugin/cpp_*.vim ftplugin/cpp/*.vim
unlet! b:did_ftplugin
runtime! ftplugin/objc.vim ftplugin/objc_*.vim ftplugin/objc/*.vim
let b:did_ftplugin = 1

let &cpo = s:save_cpo
unlet s:save_cpo
