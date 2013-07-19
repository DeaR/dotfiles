" -*- mode: vimrc; coding: unix -*-

" @name        map-qf.vim
" @description Close mapping for QuickFix
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-19 17:30:46 DeaR>

let s:save_cpo = &cpo
set cpo&vim

nnoremap <buffer> q      :<C-U>cclose<CR>
nnoremap <buffer> <S-CR> <CR>zz<C-W>p

function! s:jk(motion)
  let max = line('$')
  let list = getloclist(0)
  if empty(list) || len(list) != max
    let list = getqflist()
  endif
  let cur = line('.') - 1
  let pos = (cur + a:motion) % max
  let m = 0 < a:motion ? 1 : -1
  while cur != pos && list[pos].bufnr == 0
    let pos = (pos + m) % max
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
nnoremap <buffer><silent> dd :<C-U>call <SID>del_entry()<CR>
nnoremap <buffer><silent> x  :<C-U>call <SID>del_entry()<CR>
xnoremap <buffer><silent> d  :call <SID>del_entry()<CR>
xnoremap <buffer><silent> x  :call <SID>del_entry()<CR>

function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction
nnoremap <buffer><silent> u :<C-U>call <SID>undo_entry()<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' |'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= '
  \ silent! nunmap <buffer> q|
  \ silent! nunmap <buffer> <S-CR>|
  \ silent! nunmap <buffer> j|
  \ silent! nunmap <buffer> k|
  \ silent! nunmap <buffer> dd|
  \ silent! nunmap <buffer> x|
  \ silent! xunmap <buffer> d|
  \ silent! xunmap <buffer> x|
  \ silent! nunmap <buffer> u'

let &cpo = s:save_cpo
unlet s:save_cpo
