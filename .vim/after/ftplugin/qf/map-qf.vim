" -*- mode: vimrc; coding: unix -*-

" @name        map-qf.vim
" @description Mapping for QuickFix
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-08 19:20:51 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> q :<C-U>cclose<CR>
nnoremap <buffer> p <CR>zz<C-W>p

function! s:jk(motion)
  let max = line('$')
  let list = getloclist(0)
  if empty(list) || len(list) != max
    let list = getqflist()
  endif
  let cur = line('.') - 1
  let pos = g:V.modulo(cur + a:motion, max)
  let m = 0 < a:motion ? 1 : -1
  while cur != pos && list[pos].bufnr == 0
    let pos = g:V.modulo(pos + m, max)
  endwhile
  return (pos + 1) . 'G'
endfunction
noremap <buffer><silent><expr> j <SID>jk(v:count1)
noremap <buffer><silent><expr> k <SID>jk(-v:count1)

function! s:del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(qf, 'r')
  execute a:firstline
endfunction
nnoremap <buffer> dd :call <SID>del_entry()<CR>
nnoremap <buffer> x  :call <SID>del_entry()<CR>
vnoremap <buffer> d  :call <SID>del_entry()<CR>
vnoremap <buffer> x  :call <SID>del_entry()<CR>

function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction
nnoremap <buffer> u :<C-U>call <SID>undo_entry()<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> q|
  \ silent! nunmap <buffer> p|
  \ silent! unmap  <buffer> j|
  \ silent! unmap  <buffer> k|
  \ silent! nunmap <buffer> dd|
  \ silent! nunmap <buffer> x|
  \ silent! vunmap <buffer> d|
  \ silent! vunmap <buffer> x|
  \ silent! nunmap <buffer> u'

let &cpo = s:save_cpo
unlet s:save_cpo
