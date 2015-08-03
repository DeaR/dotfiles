scriptencoding utf-8
" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  03-Aug-2015.
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

"==============================================================================
" Pre Init: {{{

"------------------------------------------------------------------------------
" Common: {{{
" Script ID
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Check Vim version
function! s:has_patch(major, minor, patch)
  let l:version = (a:major * 100 + a:minor)
  return has('patch-' . a:major . '.' . a:minor . '.' . a:patch) ||
    \ (v:version > l:version) ||
    \ (v:version == l:version && has('patch' . a:patch))
endfunction

" Check vimproc
function! s:has_vimproc()
  if !exists('s:exists_vimproc')
    try
      call vimproc#version()
      let s:exists_vimproc = 1
    catch
      let s:exists_vimproc = 0
    endtry
  endif
  return s:exists_vimproc
endfunction

" Cached executable
let s:_executable = {}
function! s:executable(expr)
  if !has_key(s:_executable, a:expr)
    let s:_executable[a:expr] = executable(a:expr)
  endif
  return s:_executable[a:expr]
endfunction

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' || $VIM =~? 'net\.momodalo\.app\.vimtouch')

" Check japanese
let s:is_lang_ja = has('multi_lang') && v:lang =~? '^ja'

" Check NeoBundle
let s:has_neobundle = isdirectory($HOME . '/.local/bundle/neobundle')
"}}}
"}}}

"==============================================================================
" Mappings: {{{

"------------------------------------------------------------------------------
" Common: {{{
" Split Nicely
function! myvimrc#split_nicely_expr()
  return &columns < 160
endfunction
"}}}

"------------------------------------------------------------------------------
" Command Line: {{{
function! myvimrc#cmdwin_enter(type)
  let s:save_bs = &backspace
  set backspace=
  setlocal nocursorcolumn
  setlocal foldcolumn=0
  setlocal nofoldenable
  setlocal nonumber
  setlocal norelativenumber
  startinsert!

  if a:type == '/'
    inoremap <buffer> / \/
  elseif a:type == '?'
    inoremap <buffer> ? \?
  endif

  inoremap <buffer><silent><expr> <C-H>
    \ col('.') == 1 && getline('.') == '' ? '<Esc>:<C-U>quit<CR>' : '<C-H>'
  inoremap <buffer><silent><expr> <BS>
    \ col('.') == 1 && getline('.') == '' ? '<Esc>:<C-U>quit<CR>' : '<BS>'

  nnoremap <buffer><silent> q :<C-U>quit<CR>
endfunction
function! myvimrc#cmdwin_leave(type)
  let &backspace = s:save_bs
endfunction

function! myvimrc#cmdline_enter(type)
  if exists('#User#CmdlineEnter')
    execute 'doautocmd' (s:has_patch(7, 3, 438) ? '<nomodeline>' : '')
      \ 'User CmdlineEnter'
  endif
  return a:type
endfunction
"}}}

"------------------------------------------------------------------------------
" Escape Key: {{{
function! myvimrc#escape_key()
  if exists('#User#EscapeKey')
    execute 'doautocmd' (s:has_patch(7, 3, 438) ? '<nomodeline>' : '')
      \ 'User EscapeKey'
  endif
  return ":\<C-U>nohlsearch\<CR>\<Esc>"
endfunction
"}}}

"------------------------------------------------------------------------------
" Search: {{{
function! myvimrc#search_forward_expr()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction
"}}}

"------------------------------------------------------------------------------
" Auto Mark: {{{
let s:mark_char = [
  \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

function! s:get_mark_pos()
  let pos = (get(b:, 'mark_pos', -1) + 1) % len(s:mark_char)
  for i in range(pos, len(s:mark_char)) + range(0, pos)
    try
      silent execute 'marks' s:mark_char[i]
    catch /^Vim\%((\a\+)\)\?:E283/
      return i
    endtry
  endfor
  return pos
endfunction
function! myvimrc#auto_mark()
  let b:mark_pos = s:get_mark_pos()
  return (":\<C-U>mark " . s:mark_char[b:mark_pos] . "\<CR>")
endfunction
function! myvimrc#clear_marks()
  let b:mark_pos = -1
  return (":\<C-U>delmarks " . join(s:mark_char, '') . "\<CR>")
endfunction
function! s:get_file_mark_pos()
  let pos = (get(s:, 'file_mark_pos', -1) + 1) % len(s:mark_char)
  for i in range(pos, len(s:mark_char)) + range(0, pos)
    try
      silent execute 'marks' toupper(s:mark_char[i])
    catch /^Vim\%((\a\+)\)\?:E283/
      return i
    endtry
  endfor
  return pos
endfunction
function! myvimrc#auto_file_mark()
  let s:file_mark_pos = s:get_file_mark_pos()
  return (":\<C-U>mark " . toupper(s:mark_char[s:file_mark_pos]) . "\<CR>")
endfunction
function! myvimrc#clear_file_marks()
  let s:file_mark_pos = -1
  return (":\<C-U>rviminfo | delmarks " .
    \ toupper(join(s:mark_char, '')) . " | wviminfo!\<CR>")
endfunction
function! myvimrc#marks()
  let char = join(s:mark_char, '')
  return (":\<C-U>marks " . char . toupper(char) . "\<CR>")
endfunction
" }}}

"------------------------------------------------------------------------------
" Smart BOL: {{{
function! myvimrc#smart_bol()
  return col('.') <= 1 || col('.') > match(getline('.'), '^\s*\zs') + 1 ? '^' : '0'
endfunction
function! myvimrc#smart_eol()
  return col('.') < col('$') - (mode() !~# "[vV\<C-V>]" ? 1 : 0) ? '$' : 'g_'
endfunction
" }}}

"------------------------------------------------------------------------------
" Line Number: {{{
function! myvimrc#toggle_line_number_style()
  set relativenumber!
  if !&number && !&relativenumber
    set number
  endif
endfunction
"}}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
function! myvimrc#insert_one_char(cmd)
  echohl ModeMsg
  if s:is_lang_ja
    echo '-- 挿入 (1文字) --'
  else
    echo '-- INSERT (one char) --'
  endif
  echohl None
  return a:cmd . nr2char(getchar()) . "\<Esc>"
endfunction
"}}}
"}}}

"==============================================================================
" Commands: {{{

"------------------------------------------------------------------------------
" Shell Setting: {{{
function! myvimrc#get_shell()
  return [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote]
endfunction
function! myvimrc#set_shell(value)
  let [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote] =
    \ a:value
endfunction
"}}}

"------------------------------------------------------------------------------
" VC Vars: {{{
function! myvimrc#vcvarsall(arch)
  let save_isi   = &isident
  set isident+=( isident+=)
  try
    let env = system(shellescape($VCVARSALL) . ' ' . a:arch . ' & set')
    for matches in filter(map(split(env, '\n'),
      \ 'matchlist(v:val, ''\([^=]\+\)=\(.*\)'')'), 'len(v:val) > 1')
      execute 'let $' . matches[1] . '=' . string(matches[2])
    endfor
  finally
    let &isident = save_isi
  endtry
endfunction
"}}}

"------------------------------------------------------------------------------
" QuickFix Toggle: {{{
function! myvimrc#toggle_quickfix(type, height)
  let w = winnr('$')
  execute a:type . 'close'
  if w == winnr('$')
    execute a:type . 'window' a:height
  endif
endfunction
"}}}
"}}}

"==============================================================================
" Vim Script: {{{

"------------------------------------------------------------------------------
" Auto MkDir: {{{
function! myvimrc#auto_mkdir(dir, force)
  if s:is_lang_ja
    let msg = '"' . a:dir . '" は存在しません。作成しますか?'
    let choices = "はい(&Y)\nいいえ(&N)"
  else
    let msg = '"' . a:dir . '" does not exist. Create?'
    let choices = "&Yes\n&No"
  endif
  if !isdirectory(a:dir) &&
    \ (a:force || confirm(msg, choices, 1, 'Question') == 1)
    let dir = (has('iconv') && &termencoding != '') ?
      \ iconv(a:dir, &encoding, &termencoding) : a:dir
    call mkdir(dir, 'p')
  endif
endfunction
"}}}
"}}}

"==============================================================================
" Plugins: {{{

"------------------------------------------------------------------------------
" Alignta: {{{
if s:has_neobundle && neobundle#tap('alignta')
  function! myvimrc#operator_alignta(motion_wise)
    let range = line("'[") . ',' . line("']")
    execute range . input(':' . range, 'Alignta ')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" AlterCommand: {{{
if s:has_neobundle && neobundle#tap('altercmd')
  function! myvimrc#cmdwin_enter_altercmd(define)
    for [key, value] in items(a:define)
      execute 'IAlterCommand <buffer>' key value
    endfor
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" IncSearch: {{{
if s:has_neobundle && neobundle#tap('incsearch')
  function! myvimrc#incsearch_next()
    return incsearch#go({
      \ 'command' : '/',
      \ 'keymap' : {
      \   '/' : {'key' : '\/', 'noremap' : 1}}})
  endfunction

  function! myvimrc#incsearch_prev()
    return incsearch#go({
      \ 'command' : '?',
      \ 'keymap' : {
      \   '?' : {'key' : '\?', 'noremap' : 1},
      \   "\<Tab>" : {'key' : '<Over>(incsearch-prev)', 'noremap' : 1},
      \   "\<S-Tab>" : {'key' : '<Over>(incsearch-next)', 'noremap' : 1}}})
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Kwbdi: {{{
if s:has_neobundle && neobundle#tap('kwbdi')
  function! myvimrc#kwbd()
    if &l:modified
      if s:is_lang_ja
        let msg = '変更を "' . expand('%:t') . '" に保存しますか?'
        let choices = "はい(&Y)\nいいえ(&N)\nキャンセル(&C)"
      else
        let msg = 'Save changes to "' . expand('%:t') . '"?'
        let choices = "&Yes\n&No\n&Cancel"
      endif

      let ret = confirm(msg, choices, 1, 'Question')
      if ret == 1
        silent write!
      elseif ret == 3
        return
      endif
    endif

    silent execute "normal \<Plug>Kwbd"
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" NeoComplCache: {{{
if s:has_neobundle && neobundle#tap('neocomplcache')
  function! myvimrc#check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  function! myvimrc#cmdwin_enter_neocomplcache()
    let b:neocomplcache_sources_list = []

    inoremap <buffer><expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   myvimrc#check_back_space() ?
      \     '<Tab>' :
      \     neocomplcache#start_manual_complete()
    inoremap <buffer><expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplcache#start_manual_complete()

    inoremap <buffer><silent><expr> <C-H>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<C-H>')
    inoremap <buffer><silent><expr> <BS>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<BS>')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" NeoComplete: {{{
if s:has_neobundle && neobundle#tap('neocomplete')
  function! myvimrc#check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  function! myvimrc#cmdwin_enter_neocomplete()
    let b:neocomplete_sources = []

    inoremap <buffer><expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   myvimrc#check_back_space() ?
      \     '<Tab>' :
      \     neocomplete#start_manual_complete()
    inoremap <buffer><expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplete#start_manual_complete()

    inoremap <buffer><silent><expr> <C-H>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<C-H>')
    inoremap <buffer><silent><expr> <BS>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<BS>')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Operator Star: {{{
if s:has_neobundle && neobundle#tap('operator-star')
  function! s:operator_star_post()
    normal! zv
    call feedkeys(":\<C-U>let &hls=&hls\<CR>", 'n')
    if neobundle#is_installed('anzu')
      call feedkeys(":\<C-U>AnzuUpdateSearchStatusOutput\<CR>", 'n')
    endif
  endfunction

  function! myvimrc#operator_star_star(wiseness)
    call operator#star#star(a:wiseness)
    call s:operator_star_post()
  endfunction
  function! myvimrc#operator_star_sharp(wiseness)
    call operator#star#sharp(a:wiseness)
    call s:operator_star_post()
  endfunction
  function! myvimrc#operator_star_gstar(wiseness)
    call operator#star#gstar(a:wiseness)
    call s:operator_star_post()
  endfunction
  function! myvimrc#operator_star_gsharp(wiseness)
    call operator#star#gsharp(a:wiseness)
    call s:operator_star_post()
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Operator Tabular: {{{
if s:has_neobundle && neobundle#tap('operator-tabular')
  let s:operator_tabular_kind = 'markdown'
  let s:operator_tabular_ext  = 'csv'

  function! myvimrc#operator_tabularize(motion_wise, ...)
    let kind = input('Kind: ', s:operator_tabular_kind,
      \ 'customlist,' . s:SID_PREFIX() . 'operator_tabular_kind_complete')
    if kind == 'markdown' || kind == 'textile' || kind == 'backlog'
      let s:operator_tabular_kind = kind
    endif

    let ext = input('Kind: ', s:operator_tabular_ext,
      \ 'customlist,' . s:SID_PREFIX() . 'operator_tabular_ext_complete')
    if ext == 'csv'  || ext == 'tsv'
      let s:operator_tabular_ext = ext
    endif

    execute 'call' 'operator#tabular#' . s:operator_tabular_kind .
      \ (a:0 && a:1 ? '#untabularize_' : '#tabularize_') .
      \ s:operator_tabular_ext . '(a:motion_wise)'
  endfunction

  function! myvimrc#operator_untabularize(motion_wise)
    call myvimrc#operator_tabularize(a:motion_wise, 1)
  endfunction

  function! s:operator_tabular_kind_complete(...)
    return ['markdown', 'textile', 'backlog']
  endfunction

  function! s:operator_tabular_ext_complete(...)
    return ['csv', 'tsv']
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Operator User: {{{
if s:has_neobundle && neobundle#tap('operator-user')
  if neobundle#is_installed('jvgrep') || s:executable('jvgrep')
    let s:operator_grep_escape = '\[](){}|.?+*^$'
  elseif neobundle#is_installed('the_silver_searcher') || s:executable('ag')
    let s:operator_grep_escape = '\[](){}|.?+*^$'
  elseif s:executable('grep')
    let s:operator_grep_escape = '\[].*^$'
  else
    let s:operator_grep_escape = '\[].*^$'
  endif

  function! myvimrc#operator_grep(motion_wise)
    if a:motion_wise == 'char'
      let lines = getline(line("'["), line("']"))
      let lines[-1] = lines[-1][: col("']") - 1]
      let lines[0] = lines[0][col("'[") - 1 :]
    elseif a:motion_wise == 'line'
      let lines = getline(line("'["), line("']"))
    else " a:motion_wise == 'block'
      let start = col("'<") - 1
      let end = col("'>") - 1
      let lines = map(
        \ getline(line("'<"), line("'>")),
        \ 'v:val[start : end]')
    endif

    if neobundle#is_installed('unite')
      execute 'Unite'
        \ (&grepprg == 'internal' ? 'vimgrep::' : 'grep:::') .
        \ escape(join(lines), s:operator_grep_escape . ' :')
        \ '-buffer-name=grep -no-split -wrap'
    else
      execute input(':',
        \ 'grep "' . escape(join(lines), s:operator_grep_escape) . '" ')
    endif
  endfunction

  function! myvimrc#operator_justify(motion_wise)
    let range = line("'[") . ',' . line("']")
    execute range . input(':' . range, 'Justify ')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Switch: {{{
if s:has_neobundle && neobundle#tap('switch')
  let s:ordinal_suffixes = [
    \ 'th', 'st', 'nd', 'rd', 'th',
    \ 'th', 'th', 'th', 'th', 'th']

  function! myvimrc#ordinal(num)
    return a:num . s:ordinal_suffixes[abs(a:num % 10)]
  endfunction

  function! myvimrc#switch(is_increment)
    let save_count1 = v:count1

    let definitions = []
    if !exists('g:switch_no_builtins')
      let definitions = extend(definitions, g:switch_definitions)
    endif
    if exists('g:switch_custom_definitions')
      call extend(definitions, g:switch_custom_definitions)
    endif
    if exists('b:switch_definitions') && !exists('b:switch_no_builtins')
      call extend(definitions, b:switch_definitions)
    endif
    if exists('b:switch_custom_definitions')
      call extend(definitions, b:switch_custom_definitions)
    endif
    if a:is_increment
      if exists('g:switch_increment_definitions')
        call extend(definitions, g:switch_increment_definitions)
      endif
      if exists('b:switch_increment_definitions')
        call extend(definitions, b:switch_increment_definitions)
      endif
    else
      if exists('g:switch_decrement_definitions')
        call extend(definitions, g:switch_decrement_definitions)
      endif
      if exists('b:switch_decrement_definitions')
        call extend(definitions, b:switch_decrement_definitions)
      endif
    endif

    if !switch#Switch(definitions)
      execute "normal!" save_count1 .
        \ (a:is_increment ? "\<C-A>" : "\<C-X>")
    endif

    silent! call repeat#set(
      \ a:is_increment ? "\<C-A>" : "\<C-X>", save_count1)
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TComment: {{{
if s:has_neobundle && neobundle#tap('tcomment')
  function! myvimrc#operator_tcomment_setup(options)
    let w:tcommentPos = getpos('.')
    call tcomment#SetOption('count', v:count)
    for [key, value] in items(a:options)
      call tcomment#SetOption(key, value)
    endfor
  endfunction

  function! myvimrc#operator_tcomment_block(type)
    call tcomment#Operator(a:type, 'B')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextManipilate: {{{
if s:has_neobundle && neobundle#tap('textmanip')
  function! s:operator_textmanip(function, motion_wise)
    let save_sel = &l:selection
    try
      let &l:selection = 'inclusive'
      execute 'normal! `[' .
        \ operator#user#visual_command_from_wise_name(a:motion_wise) .
        \ "`]:\<C-U>call " . a:function . "\<CR>\<Esc>"
    finally
      let &l:selection = save_sel
    endtry
  endfunction

  function! myvimrc#operator_textmanip_duplicate_down(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#duplicate("down", "v")', a:motion_wise)
  endfunction
  function! myvimrc#operator_textmanip_duplicate_up(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#duplicate("up", "v")', a:motion_wise)
  endfunction
  function! myvimrc#operator_textmanip_move_left(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#move("left")', a:motion_wise)
  endfunction
  function! myvimrc#operator_textmanip_move_right(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#move("right")', a:motion_wise)
  endfunction
  function! myvimrc#operator_textmanip_move_down(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#move("down")', a:motion_wise)
  endfunction
  function! myvimrc#operator_textmanip_move_up(motion_wise)
    call s:operator_textmanip(
      \ 'textmanip#move("up")', a:motion_wise)
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Unite Mark: {{{
if s:has_neobundle && neobundle#tap('unite-mark')
  function! myvimrc#unite_source_mark_marks()
    return join(s:mark_char, '') . toupper(join(s:mark_char, ''))
  endfunction
endif
"}}}

"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
