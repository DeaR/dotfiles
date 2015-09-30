scriptencoding utf-8
" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  29-Sep-2015.
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
"}}}

let s:save_cpo = &cpo
set cpo&vim

"==============================================================================
" Pre Init: {{{

"------------------------------------------------------------------------------
" Common: {{{
" Script ID
function! s:SID()
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

" CPU Cores
function! s:cpucores()
  if !exists('s:_cpucores')
    let s:_cpucores = str2nr(
    \ exists('$NUMBER_OF_PROCESSORS') ? $NUMBER_OF_PROCESSORS :
    \ s:executable('nproc')           ? system('nproc') :
    \ s:executable('getconf')         ? system('getconf _NPROCESSORS_ONLN') :
    \ filereadable('/proc/cpuinfo')   ?
    \   system('cat /proc/cpuinfo | grep -c "processor"') : '1')
  endif
  return s:_cpucores
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
  if !exists('s:_has_vimproc')
    try
      call vimproc#version()
      let s:_has_vimproc = 1
    catch
      let s:_has_vimproc = 0
    endtry
  endif
  return s:_has_vimproc
endfunction

" Wrapped doautocmd
function! s:doautocmd(...)
  let nomodeline = s:has_patch(7, 3, 438) ? '<nomodeline>' : ''
  execute 'doautocmd' nomodeline join(a:000)
endfunction

" Wrapped neobundle#tap
function! s:neobundle_tap(name)
  return exists('*neobundle#tap') && neobundle#tap(a:name)
endfunction

" Check enabled bundle
function! s:is_enabled_bundle(name)
  return exists('*neobundle#get') &&
  \ !get(neobundle#get(a:name), 'disabled', 1)
endfunction

" Cached executable
let s:_executable = {}
function! s:executable(expr)
  if !has_key(s:_executable, a:expr)
    let s:_executable[a:expr] = executable(a:expr)
  endif
  return s:_executable[a:expr]
endfunction

" Get "Program Files" of 32bit
if has('win32')
  let s:save_isi = &isident
  try
    set isident+=(,)
    let s:programfiles_x86 = expand(exists('$PROGRAMFILES(X86)') ?
    \ '$PROGRAMFILES(X86)' : '$PROGRAMFILES')
  finally
    let &isident = s:save_isi
    unlet! s:save_isi
  endtry
endif

" Check japanese
let s:is_lang_ja = has('multi_byte') && v:lang =~? '^ja'

" Check colored UI
let s:is_colored = has('gui_running') || &t_Co > 255

" Check JIS X 0213
let s:has_jisx0213 = has('iconv') &&
\ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
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
  setlocal syntax=OFF
  startinsert!

  if a:type =~# '[\/]'
    inoremap <buffer> / \/
  elseif a:type =~# '?'
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
    call s:doautocmd('User', 'CmdlineEnter')
  endif
  return a:type
endfunction
"}}}

"------------------------------------------------------------------------------
" Escape Key: {{{
function! myvimrc#escape_key()
  if exists('#User#EscapeKey')
    call s:doautocmd('User', 'EscapeKey')
  endif
  return "\<Esc>:\<C-U>nohlsearch\<CR>"
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
let s:mark_char      = 'abcdefghijklmnopqrstuvwxyz'
let s:file_mark_char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

function! s:get_mark_pos()
  let pos = (get(b:, 'mark_pos', -1) + 1) % len(s:mark_char)
  for i in range(pos, len(s:mark_char)) + range(0, pos)
    try
      silent execute 'marks' s:mark_char[i]
    catch /^Vim\%((\a\+)\)\=:E283/
      return i
    endtry
  endfor
  return pos
endfunction
function! myvimrc#auto_mark()
  let b:mark_pos = s:get_mark_pos()
  return ":\<C-U>mark " . s:mark_char[b:mark_pos] . "\<CR>"
endfunction
function! myvimrc#clear_marks()
  let b:mark_pos = -1
  return ":\<C-U>delmarks " . s:mark_char . "\<CR>"
endfunction
function! s:get_file_mark_pos()
  let pos = (get(s:, 'file_mark_pos', -1) + 1) % len(s:file_mark_char)
  for i in range(pos, len(s:file_mark_char)) + range(0, pos)
    try
      silent execute 'marks' s:file_mark_char[i]
    catch /^Vim\%((\a\+)\)\=:E283/
      return i
    endtry
  endfor
  return pos
endfunction
function! myvimrc#auto_file_mark()
  let s:file_mark_pos = s:get_file_mark_pos()
  return ":\<C-U>mark " . s:file_mark_char[s:file_mark_pos] . "\<CR>"
endfunction
function! myvimrc#clear_file_marks()
  let s:file_mark_pos = -1
  return ":\<C-U>rviminfo | delmarks " . s:file_mark_char . " | wviminfo!\<CR>"
endfunction
function! myvimrc#marks()
  return ":\<C-U>marks " . s:mark_char . s:file_mark_char . "\<CR>"
endfunction
"}}}

"------------------------------------------------------------------------------
" BOL Toggle: {{{
function! myvimrc#bol_toggle()
  return col('.') <= 1 || col('.') > match(getline('.'), '^\s*\zs') + 1 ? '^' : '0'
endfunction
function! myvimrc#eol_toggle()
  return col('.') < col('$') - (mode() !~# "[vV\<C-V>]" ? 1 : 0) ? '$' : 'g_'
endfunction
"}}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
function! myvimrc#insert_one_char(key)
  echohl ModeMsg
  if s:is_lang_ja
    echo '-- 挿入 (1文字) --'
  else
    echo '-- INSERT (one char) --'
  endif
  echohl None
  return a:key . nr2char(getchar()) . "\<Esc>"
endfunction
"}}}

"------------------------------------------------------------------------------
" Force Blockwise Insert: {{{
function! myvimrc#force_blockwise_insert(key)
  if mode() ==# 'v'
    return "\<C-V>" . a:key
  elseif mode() ==# 'V'
    return "\<C-V>Oo$" . a:key
  else
    return a:key
  endif
endfunction
"}}}
"}}}

"==============================================================================
" Commands: {{{

"------------------------------------------------------------------------------
" Windows Shell: {{{
if has('win32')
  function! myvimrc#get_shell()
    return [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote]
  endfunction
  function! myvimrc#set_shell(...)
    let value = get(a:000, 0, [])
    if empty(value)
      set shell& shellslash& shellcmdflag& shellquote& shellxquote&
    else
      let [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote] = value
    endif
  endfunction

  function! myvimrc#cmdescape(string, ...)
    let special = get(a:000, 0)
    let save_shell = myvimrc#get_shell()
    try
      call myvimrc#set_shell()
      return shellescape(a:string, special)
    finally
      call myvimrc#set_shell(save_shell)
    endtry
  endfunction
  function! myvimrc#cmdsource(...)
    let save_shell = myvimrc#get_shell()
    let save_isi   = &isident
    try
      call myvimrc#set_shell()
      let env = system(join(a:000) . ' & set')

      set isident+=(,)
      for [name; rest] in map(split(env, '\n'), 'split(v:val, "=")')
        let new = join(rest, '=')
        execute 'let old=$' . name
        if new != old
          let cmd = 'let $' . name . '=' . string(new)
          echo cmd
          execute cmd
        endif
      endfor
    finally
      call myvimrc#set_shell(save_shell)
      let &isident = save_isi
    endtry
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Line Number Toggle: {{{
function! myvimrc#line_number_toggle()
  if !&l:number && !&l:relativenumber
    setlocal number
  elseif &l:relativenumber
    setlocal nonumber norelativenumber
  else
    setlocal relativenumber
  endif
endfunction
"}}}

"------------------------------------------------------------------------------
" QuickFix Toggle: {{{
function! myvimrc#quickfix_toggle(type, height)
  let w = winnr('$')
  execute a:type . 'close'
  if w == winnr('$')
    execute a:type . 'window' a:height
  endif
endfunction
"}}}
"}}}

"==============================================================================
" Auto Command: {{{

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

"------------------------------------------------------------------------------
" QuickFix: {{{
function! s:get_qflisttype()
  if exists('b:qflisttype')
    return b:qflisttype
  endif

  let save_ei = &eventignore
  try
    set eventignore+=BufWinLeave,WinLeave,BufWinEnter,WinEnter
    let ret = 'location'
    let cur = winnr()
    let rest = winrestcmd()
    let view = winsaveview()
    lopen
    if winnr() != cur
      lclose
      execute cur 'wincmd w'
      execute rest
      let ret = 'quickfix'
    endif
    call winrestview(view)
    return ret
  catch /^Vim\%((\a\+)\)\=:E776/
    return 'quickfix'
  finally
    let &eventignore = save_ei
  endtry
endfunction
function! myvimrc#set_qflisttype()
  let b:qflisttype = s:get_qflisttype()
endfunction
"}}}
"}}}

"==============================================================================
" Plugins: {{{

"------------------------------------------------------------------------------
" Alignta: {{{
if s:neobundle_tap('alignta')
  function! myvimrc#operator_alignta(motion_wise)
    let range = line("'[") . ',' . line("']")
    execute range . input(':' . range, 'Alignta ')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" AlterCommand: {{{
if s:neobundle_tap('altercmd')
  function! myvimrc#cmdwin_enter_altercmd(define)
    for [key, value] in items(a:define)
      execute 'IAlterCommand <buffer>' key value
    endfor
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" IncSearch: {{{
if s:neobundle_tap('incsearch')
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
" NeoComplCache: {{{
if s:neobundle_tap('neocomplcache')
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
if s:neobundle_tap('neocomplete')
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
if s:neobundle_tap('operator-star')
  function! s:operator_star_post()
    normal! zv
    call feedkeys(":\<C-U>let &hls=&hls\<CR>", 'n')
    if s:is_enabled_bundle('anzu')
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
if s:neobundle_tap('operator-tabular')
  let s:operator_tabular_kind = 'markdown'
  let s:operator_tabular_ext  = 'csv'

  function! myvimrc#operator_tabularize(motion_wise, ...)
    let kind = input('Kind: ', s:operator_tabular_kind,
    \ 'customlist,s:operator_tabular_kind_complete')
    if kind == 'markdown' || kind == 'textile' || kind == 'backlog'
      let s:operator_tabular_kind = kind
    endif

    let ext = input('Kind: ', s:operator_tabular_ext,
    \ 'customlist,s:operator_tabular_ext_complete')
    if ext == 'csv'  || ext == 'tsv'
      let s:operator_tabular_ext = ext
    endif

    call operator#tabular#{s:operator_tabular_kind . 
    \ (a:0 && a:1 ? '#untabularize_' : '#tabularize_') .
    \ s:operator_tabular_ext}(a:motion_wise)
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
if s:neobundle_tap('operator-user')
  let g:myvimrc#operator_grep_ui =
  \ get(g:, 'myvimrc#operator_grep_ui')

  function! s:get_grepprg_escape(grepprg)
    if a:grepprg =~? '\<jvgrep\>'
      return '\[](){}|.?+*^$'
    elseif a:grepprg =~? '\<ag\>'
      return '\[](){}|.?+*^$'
    elseif a:grepprg =~? '\<grep\>'
      return '\[].*^$'
    elseif a:grepprg =~? '\<findstr\>'
      return ''
    else
      return '\[].*^$'
    endif
  endfunction

  function! s:operator_grep(motion_wise, is_lgrep)
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

    if g:myvimrc#operator_grep_ui == 'unite' && &grepprg != 'internal'
      NeoBundleSource unite
      let esc = s:get_grepprg_escape(g:unite_source_grep_command)
      execute 'Unite' 'grep:::' . escape(join(lines), esc . ' :')
      \ '-buffer-name=grep'
    else
      let esc = s:get_grepprg_escape(&grepprg)
      if g:myvimrc#operator_grep_ui == 'unite'
        execute 'Unite' 'vimgrep::' . escape(join(lines), esc . ' :')
        \ '-buffer-name=grep'
      elseif &grepprg == 'internal'
        execute input(':', (a:is_lgrep ? 'l' : '') .
        \ 'vimgrep /' . escape(join(lines), esc . '/') . '/ .')
      elseif &grepprg =~? 'findstr'
        execute input(':', (a:is_lgrep ? 'l' : '') .
        \ 'grep /c:' . shellescape(escape(join(lines), esc)) . ' *')
      else
        execute input(':', (a:is_lgrep ? 'l' : '') .
        \ 'grep ' . shellescape(escape(join(lines), esc)) . ' .')
      endif
    endif
  endfunction
  function! myvimrc#operator_grep(motion_wise)
    call s:operator_grep(a:motion_wise, 0)
  endfunction
  function! myvimrc#operator_lgrep(motion_wise)
    call s:operator_grep(a:motion_wise, 1)
  endfunction

  function! myvimrc#operator_justify(motion_wise)
    let range = line("'[") . ',' . line("']")
    execute range . input(':' . range, 'Justify ')
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" SubMode: {{{
if s:neobundle_tap('submode')
  function! s:get_default_register()
    return
    \ &clipboard =~# 'unnamedplus' ? '+' :
    \ &clipboard =~# 'unnamed' ? '*' : '"'
  endfunction

  function! myvimrc#submode_delchar_enter(forward)
    let s:submode_register = v:register
    return a:forward ? 'x' : 'X'
  endfunction

  function! myvimrc#submode_delchar(forward)
    let r1 = getreg(s:submode_register)
    undojoin
    execute 'normal!' '"' . s:submode_register . (a:forward ? 'x' : 'X')
    let r2 = getreg(s:submode_register)
    if r1 != r2
      let r3 = a:forward ? (r1 . r2) : (r2 . r1)
      call setreg(s:submode_register, r3)
      if s:submode_register == s:get_default_register()
        call setreg('-', r3)
      endif
    endif
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Switch: {{{
if s:neobundle_tap('switch')
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
if s:neobundle_tap('tcomment')
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
if s:neobundle_tap('textmanip')
  function! s:operator_textmanip(motion_wise, map)
    let vis = operator#user#visual_command_from_wise_name(a:motion_wise)
    execute 'nnoremap <SID>(reselect)' '`[' . vis . '`]'
    let sel = "\<SNR>" . s:SID() . '_(reselect)'
    execute 'normal' sel . a:map
  endfunction

  function! myvimrc#operator_textmanip_duplicate_down(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-duplicate-down)")
  endfunction
  function! myvimrc#operator_textmanip_duplicate_up(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-duplicate-up)")
  endfunction
  function! myvimrc#operator_textmanip_move_left(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-move-left)")
  endfunction
  function! myvimrc#operator_textmanip_move_right(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-move-right)")
  endfunction
  function! myvimrc#operator_textmanip_move_down(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-move-down)")
  endfunction
  function! myvimrc#operator_textmanip_move_up(motion_wise)
    call s:operator_textmanip(
    \ a:motion_wise, "\<Plug>(textmanip-move-up)")
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Unite Mark: {{{
if s:neobundle_tap('unite-mark')
  function! myvimrc#unite_source_mark_marks()
    return s:mark_char . s:file_mark_char
  endfunction
endif
"}}}

silent! call neobundle#untap()
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
