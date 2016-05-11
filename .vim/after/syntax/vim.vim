" Syntax settings for Vim 7.3 Script
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  22-Apr-2016.
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
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
"     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
"     THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

syntax keyword vimMap NVmap NXmap NSmap NOmap OVmap OXmap OSmap NOXmap NOSmap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NVnoremap NXnoremap NSnoremap NOnoremap OVnoremap OXnoremap OSnoremap NOXnoremap NOSnoremap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs
syntax keyword vimMap NVunmap NXunmap NSunmap NOunmap OVunmap OXunmap OSunmap NOXunmap NOSunmap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs

syntax keyword vimMap EskkMap skipwhite nextgroup=vimMapBang,vimMapMod,vimMapLhs

let &cpo = s:save_cpo
unlet s:save_cpo
