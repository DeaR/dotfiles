" OmniSharp ftplugin for C#
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  25-Sep-2015.
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

if !exists('g:Omnisharp_loaded') &&
\ (!exists('*neobundle#get') ||
\  get(neobundle#get('omnisharp'), 'disabled', 1))
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

setlocal omnifunc=OmniSharp#Complete

nnoremap <buffer> <F5>    :<C-U>wall!<CR>:OmniSharpBuildAsync<CR>
nnoremap <buffer> gd      :<C-U>OmniSharpGotoDefinition<CR>
nnoremap <buffer> gD      :<C-U>OmniSharpFindImplementations<CR>
nnoremap <buffer> g<M-d>  :<C-U>OmniSharpFindMembers<CR>
nnoremap <buffer> g<M-D>  :<C-U>OmniSharpFindUsages<CR>

nnoremap <buffer> <LocalLeader>a       :<C-U>OmniSharpAddToProject<CR>
nnoremap <buffer> <LocalLeader>A       :<C-U>OmniSharpAddReference<CR>
nnoremap <buffer> <LocalLeader>f       :<C-U>OmniSharpCodeFormat<CR>
nnoremap <buffer> <LocalLeader>h       :<C-U>OmniSharpHighlightTypes<CR>
nnoremap <buffer> <LocalLeader>l       :<C-U>OmniSharpReloadSolution<CR>
nnoremap <buffer> <LocalLeader>t       :<C-U>OmniSharpTypeLookup<CR>
nnoremap <buffer> <LocalLeader>r       :<C-U>OmniSharpRename<CR>
nnoremap <buffer> <LocalLeader>R       :<C-U>OmniSharpRenameTo<CR>
nnoremap <buffer> <LocalLeader><Space> :<C-U>OmniSharpGetCodeActions<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
\ setlocal omnifunc< |
\
\ silent! execute "nunmap <buffer> <F5>" |
\ silent! execute "nunmap <buffer> <Space>" |
\ silent! execute "nunmap <buffer> gd" |
\ silent! execute "nunmap <buffer> gD" |
\ silent! execute "nunmap <buffer> g<M-d>" |
\ silent! execute "nunmap <buffer> g<M-D>" |
\
\ silent! execute "nunmap <buffer> <LocalLeader>a" |
\ silent! execute "nunmap <buffer> <LocalLeader>A" |
\ silent! execute "nunmap <buffer> <LocalLeader>f" |
\ silent! execute "nunmap <buffer> <LocalLeader>h" |
\ silent! execute "nunmap <buffer> <LocalLeader>l" |
\ silent! execute "nunmap <buffer> <LocalLeader>t" |
\ silent! execute "nunmap <buffer> <LocalLeader>r" |
\ silent! execute "nunmap <buffer> <LocalLeader>R" |
\ silent! execute "nunmap <buffer> <LocalLeader><Space>"'

let &cpo = s:save_cpo
unlet s:save_cpo
