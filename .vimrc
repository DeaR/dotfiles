scriptencoding utf-8

" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  15-Jun-2016.
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
"     THE OSFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
"     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE OSFTWARE OR
"     THE USE OR OTHER DEALINGS IN THE OSFTWARE.
" }}}

"==============================================================================
" Pre Init: {{{
" Skip vim-tiny, vim-small, below vim-7.2
if v:version < 703 | finish | endif

" Be iMproved
if &compatible
  set nocompatible
endif

" Encoding
set encoding=utf-8
scriptencoding utf-8
if &term == 'win32'
  set termencoding=cp932
endif

if has('win32')
  " Language
  language japanese
  language time C

  " Shell
  " set shell=sh
  " set shellslash

  " Path
  let $PATH = $VIM . ';' . $PATH

  " Unix like path
  let &runtimepath = substitute(&runtimepath,
  \ '\V' . escape($HOME, '\') . '/\zsvimfiles', '.vim', 'g')
  if has('packages')
    let &packpath = substitute(&packpath,
    \ '\V' . escape($HOME, '\') . '/\zsvimfiles', '.vim', 'g')
  endif
endif

" XDG Base Directory
let $XDG_DATA_HOME =
\ exists('$XDG_DATA_HOME')   ? $XDG_DATA_HOME   : ($HOME . '/.local/share')
let $XDG_CACHE_HOME =
\ exists('$XDG_CACHE_HOME')  ? $XDG_CACHE_HOME  : ($HOME . '/.cache')
let $XDG_CONFIG_HOME =
\ exists('$XDG_CONFIG_HOME') ? $XDG_CONFIG_HOME : ($HOME . '/.config')

" Singleton
let s:singleton_dir =
\ $XDG_DATA_HOME . '/dein/repos/github.com/thinca/vim-singleton'
if has("clientserver") && isdirectory(s:singleton_dir)
  execute 'set runtimepath^=' . escape(escape(s:singleton_dir, ' ,'), ' \')
  let g:singleton#opener = 'drop'
  call singleton#enable()
endif
unlet! s:singleton_dir

" Vimrc autocmd group
augroup MyVimrc
  autocmd!
augroup END

"------------------------------------------------------------------------------
" Variable: {{{
" Ignore pattern
let s:ignore_dir = [
\ '.git', '.hg', '.bzr', '.svn']
let s:ignore_ext = [
\ 'o', 'obj', 'a', 'lib', 'so', 'dll', 'dylib', 'exe', 'bin',
\ 'swp', 'swo', 'swn', 'lc', 'elc', 'fas', 'pyc', 'pyd', 'pyo', 'luac', 'zwc']
let s:ignore_ft = [
\ 'gitcommit', 'gitrebase', 'hgcommit']

"------------------------------------------------------------------------------
" Common: {{{
" Script ID
function! s:SID() abort
  if !exists('s:_SID')
    let s:_SID = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif
  return s:_SID
endfunction

" Cached executable
let s:_executable = {}
function! s:executable(expr) abort
  if !has_key(s:_executable, a:expr)
    let s:_executable[a:expr] = executable(a:expr)
  endif
  return s:_executable[a:expr]
endfunction

" CPU Cores
function! s:cpucores() abort
  if !exists('s:_cpucores')
    let s:_cpucores = str2nr(
    \ exists('$NUMBER_OF_PROCESSORS') ? $NUMBER_OF_PROCESSORS :
    \ s:executable('nproc')           ? system('nproc') :
    \ s:executable('getconf')         ? system('getconf _NPROCESSORS_ONLN') :
    \ s:executable('sysctl')          ? system('sysctl hw.ncpu') :
    \ filereadable('/proc/cpuinfo')   ?
    \   len(filter(readfile('/proc/cpuinfo'), 'v:val =~ "processor"')) : 1)
  endif
  return s:_cpucores
endfunction

" Check japanese
let s:is_lang_ja = has('multi_byte') && v:lang =~? '^ja'

" Check colored UI
let s:is_colored_ui = has('gui_running') || has('termguicolors') || &t_Co > 255

" Check JIS X 0213
let s:has_jisx0213 = has('iconv') &&
\ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"

" $PROGRAMFILES
if has('win32')
  let s:save_isi = &isident
  try
    set isident+=(,)
    let s:arch = exists('$PROGRAMFILES(X86)')
    let s:pf64 = exists('$PROGRAMW6432') ?
    \ $PROGRAMW6432 : $PROGRAMFILES
    let s:pf32 = exists('$PROGRAMFILES(X86)') ?
    \ $PROGRAMFILES(X86) : $PROGRAMFILES
  finally
    let &isident = s:save_isi
    unlet! s:save_isi
  endtry
endif
" }}}

"------------------------------------------------------------------------------
" Compatibility: {{{
" Vim.Compat.has_version
" 7.4.237  (after 7.4.236) has() not checking for specific patch
if has('patch-7.4.237')
  function! s:has_patch(args) abort
    return has('patch-' . a:args)
  endfunction
else
  function! s:has_patch(args) abort
    let a = split(a:args, '\.')
    let v = a[0] * 100 + a[1]
    return v:version > v || v:version == v && has('patch' . a[2])
  endfunction
endif

" Check vimproc
function! s:has_vimproc() abort
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

" dein#tap
function! s:dein_tap(name) abort
  return exists('*dein#tap') && dein#tap(a:name)
endfunction
" }}}
" }}}

"==============================================================================
" General: {{{

"------------------------------------------------------------------------------
" System: {{{
" GUI options
set guioptions+=M

" Message
set shortmess+=a
set title
set confirm

" Beep
set errorbells
set novisualbell
set t_vb=

" VimInfo
set history=10000
set viminfo+=n$XDG_CACHE_HOME/viminfo

" Undo file
set undofile
set undodir^=$XDG_CACHE_HOME/vimundo
if !isdirectory($XDG_CACHE_HOME . '/vimundo')
  call mkdir($XDG_CACHE_HOME . '/vimundo', 'p')
endif
autocmd MyVimrc BufWritePre *
\ let &undofile = index(s:ignore_ft, &filetype) < 0

" ClipBoard
set clipboard=unnamed
if has('unnamedplus')
  set clipboard^=unnamedplus
endif

" Timeout
set timeoutlen=3000
set ttimeoutlen=10
set updatetime=1000

" Hidden buffer
set hidden

" Multi byte charactor width
set ambiwidth=double

" Wild menu
set wildmenu
execute 'set wildignore+=' . join(s:ignore_dir +
\ map(copy(s:ignore_ext), '"*." . escape(escape(v:val, " ,"), " \\")'), ',')

" Mouse
set mouse=a
set nomousehide
set mousemodel=extend
" }}}

"------------------------------------------------------------------------------
" Display: {{{
" Don't redraw which macro executing
set lazyredraw

" Line number, Ruler, Wrap
set number
set relativenumber
set ruler
set display=lastline
" set scrolloff=5

" Command line
set cmdheight=2
set laststatus=2
set showcmd

" Display NonText
set list
set listchars=eol:$,tab:>-,extends:>,precedes:<
set fillchars=vert:\|

" Help
set helpheight=999

" Conceal
set conceallevel=2
set concealcursor=nc
" }}}

"------------------------------------------------------------------------------
" Search: {{{
" Options
set ignorecase
set smartcase
set incsearch

" Highlight
if s:is_colored_ui
  set hlsearch
endif

" Grep
if s:executable('jvgrep')
  set grepprg=jvgrep\ -nI
elseif s:executable('grep')
  set grepprg=grep\ -nHI
" elseif has('win32')
"   set grepprg=findstr\ /n\ /p
else
  set grepprg=internal
endif
" }}}

"------------------------------------------------------------------------------
" Edit: {{{
" Complete
set completeopt=menu,menuone
if s:has_patch('7.4.775')
  set completeopt+=noselect
endif
set showfulltag

" Format
set nrformats=hex
if s:has_patch('7.4.1027')
  set nrformats+=bin
endif
set formatoptions+=m
set formatoptions+=B

" Cursor
set virtualedit=block
set backspace=indent,eol,start

" File format
set fileformat=unix
set fileformats=unix,dos,mac
if s:has_patch('7.4.785')
  set nofixendofline
endif

" Indent
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set copyindent
set cinoptions=:0,l1,g0,(0,U1,Ws,j1,J1,)20

" Folding
set nofoldenable
" set foldcolumn=2
set foldlevelstart=99
" }}}

"------------------------------------------------------------------------------
" Status Line: {{{
set statusline=%f%<\ %m%r[
if has('multi_byte')
  set statusline+=%{empty(&fenc)?&enc:&fenc}:
endif
set statusline+=%{&ff}]%y%=

if has('multi_byte')
  set statusline+=\ [U+%04B]
endif
set statusline+=\ (%l,%v)/%L

if s:is_lang_ja
  set statusline+=\ %4P
else
  set statusline+=\ %P
endif
" }}}

"------------------------------------------------------------------------------
" Tab Line: {{{
let s:label_noname   = s:is_lang_ja ? '[無名]' : '[No Name]'
let s:label_quickfix = s:is_lang_ja ? '[Quickfixリスト]' : '[Quickfix List]'
let s:label_location = s:is_lang_ja ? '[場所リスト]' : '[Location List]'
function! s:label_qflisttype(n) abort
  return getbufvar(a:n, 'qflisttype') == 'location' ?
  \ s:label_location : s:label_quickfix
endfunction
function! s:tab_bufname(n) abort
  let name = bufname(a:n)
  let type = getbufvar(a:n, '&buftype')
  return
  \ type == 'quickfix' ? s:label_qflisttype(a:n) :
  \ type == 'help'     ? fnamemodify(name, ':t') :
  \ empty(name)        ? s:label_noname :
  \ empty(type)        ? pathshorten(name) : name
endfunction
function! s:tab_label(n) abort
  let bufs = tabpagebuflist(a:n)
  let acv = a:n == tabpagenr()
  let win = len(bufs)
  let mod = !empty(filter(copy(bufs), 'getbufvar(v:val, "&modified")'))
  let name = s:tab_bufname(bufs[tabpagewinnr(a:n) - 1])
  return '%' . a:n . 'T' .
  \ (acv ? '%#TabLineSel#' : '%#TabLine#') .
  \ (win > 1 || mod ? ' ' : '') .
  \ (win == 1 ? '' : acv ? ('%#Title#' . win . '%#TabLineSel#') : win) .
  \ (mod ? '+' : '') . ' ' . name . ' '
endfunction
function! TabLine() abort
  return join(map(range(1, tabpagenr('$')), 's:tab_label(v:val)'), '') .
  \ '%#TabLineFill#%T%= %#TabLineSel# ' . getcwd() . ' '
endfunction

set tabline=%!TabLine()
set showtabline=2
" }}}

"------------------------------------------------------------------------------
" File Encodings: {{{
if has('multi_byte')
  if s:has_jisx0213
    set fileencodings=iso-2022-jp-3,cp932,euc-jisx0213,euc-jp,ucs-bom
  else
    set fileencodings=iso-2022-jp,cp932,euc-jp,ucs-bom
  endif
  autocmd MyVimrc BufReadPost *
  \ if &modifiable && !search('[^\x00-\x7F]', 'cnw') |
  \   setlocal fileencoding= |
  \ endif
endif
if has('guess_encode')
  set fileencodings^=guess
endif
if has('iconv')
  let s:last_enc = &encoding
  autocmd MyVimrc EncodingChanged *
  \ if s:last_enc !=# &encoding |
  \   let &runtimepath = iconv(&runtimepath, s:last_enc, &encoding) |
  \   let s:last_enc = &encoding |
  \ endif
endif
" }}}

"------------------------------------------------------------------------------
" Cursor Line: {{{
if s:is_colored_ui
  set cursorline
  set cursorcolumn

  " No cursor line & column at other window
  augroup MyVimrc
    autocmd BufWinEnter,WinEnter *
    \ let [&cursorline, &cursorcolumn] =
    \   [!get(b:, 'nocursorline'), !get(b:, 'nocursorcolumn')]
    autocmd BufWinLeave,WinLeave *
    \ setlocal nocursorline nocursorcolumn
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" Multi Mode Mapping: {{{
command! -nargs=* -complete=mapping
\ NOmap
\ nmap <args>| omap <args>
command! -nargs=* -complete=mapping
\ NVmap
\ nmap <args>| vmap <args>
command! -nargs=* -complete=mapping
\ NXmap
\ nmap <args>| xmap <args>
command! -nargs=* -complete=mapping
\ NSmap
\ nmap <args>| smap <args>
command! -nargs=* -complete=mapping
\ OVmap
\ omap <args>| vmap <args>
command! -nargs=* -complete=mapping
\ OXmap
\ omap <args>| xmap <args>
command! -nargs=* -complete=mapping
\ OSmap
\ omap <args>| smap <args>
command! -nargs=* -complete=mapping
\ NOXmap
\ nmap <args>| omap <args>| xmap <args>
command! -nargs=* -complete=mapping
\ NOSmap
\ nmap <args>| omap <args>| smap <args>

command! -nargs=* -complete=mapping
\ NOnoremap
\ nnoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ NVnoremap
\ nnoremap <args>| vnoremap <args>
command! -nargs=* -complete=mapping
\ NXnoremap
\ nnoremap <args>| xnoremap <args>
command! -nargs=* -complete=mapping
\ NSnoremap
\ nnoremap <args>| snoremap <args>
command! -nargs=* -complete=mapping
\ OVnoremap
\ onoremap <args>| vnoremap <args>
command! -nargs=* -complete=mapping
\ OXnoremap
\ onoremap <args>| xnoremap <args>
command! -nargs=* -complete=mapping
\ OSnoremap
\ onoremap <args>| snoremap <args>
command! -nargs=* -complete=mapping
\ NOXnoremap
\ nnoremap <args>| onoremap <args>| xnoremap <args>
command! -nargs=* -complete=mapping
\ NOSnoremap
\ nnoremap <args>| onoremap <args>| snoremap <args>

command! -nargs=* -complete=mapping
\ NVunmap
\ nunmap <args>| vunmap <args>
command! -nargs=* -complete=mapping
\ NXunmap
\ nunmap <args>| xunmap <args>
command! -nargs=* -complete=mapping
\ NSunmap
\ nunmap <args>| sunmap <args>
command! -nargs=* -complete=mapping
\ NOunmap
\ nunmap <args>| ounmap <args>
command! -nargs=* -complete=mapping
\ OVunmap
\ ounmap <args>| vunmap <args>
command! -nargs=* -complete=mapping
\ OXunmap
\ ounmap <args>| xunmap <args>
command! -nargs=* -complete=mapping
\ OSunmap
\ ounmap <args>| sunmap <args>
command! -nargs=* -complete=mapping
\ NOXunmap
\ nunmap <args>| ounmap <args>| xunmap <args>
command! -nargs=* -complete=mapping
\ NOSunmap
\ nunmap <args>| ounmap <args>| sunmap <args>
" }}}
" }}}

"==============================================================================
" Macros: {{{
" Source macros
if has('packages')
  function! s:source_macros(name) abort
    silent! execute 'packadd' a:name
  endfunction
else
  function! s:source_macros(name) abort
    silent! execute 'source' $VIMRUNTIME . '/macros/' . a:name . '.vim'
  endfunction
endif

"------------------------------------------------------------------------------
" MatchIt: {{{
call s:source_macros('matchit')
if exists('g:loaded_matchit')
  silent! sunmap %
  silent! sunmap g%
  silent! sunmap [%
  silent! sunmap ]%
  silent! sunmap a%

  NXmap <SID>[% [%
  NXmap <SID>]% ]%

  xnoremap <script> [% <Esc><SID>[%m'gv``
  xnoremap <script> ]% <Esc><SID>]%m'gv``
  xnoremap <script> a% <Esc><SID>[%v<SID>]%

  NOXmap <Space>   %
  NOXmap <S-Space> g%
endif
" }}}
" }}}

"==============================================================================
" Mappings: {{{

"------------------------------------------------------------------------------
" Common: {{{
" <Leader> <LocalLeader>
let g:mapleader      = ';'
let g:maplocalleader = ','
NOXnoremap <Leader>      <Nop>
NOXnoremap <LocalLeader> <Nop>

" For mark
NOXnoremap m <Nop>
NOXnoremap M <Nop>

" For user operator
NOXnoremap s <Nop>
NOXnoremap S <Nop>

" " For user textobj
" OXnoremap <M-a> <Nop>
" OXnoremap <M-A> <Nop>
" OXnoremap <M-i> <Nop>
" OXnoremap <M-I> <Nop>

" " For user square
" NOXnoremap <M-[> <Nop>
" NOXnoremap <M-]> <Nop>

" For the evacuation of "g"
NOnoremap <C-G> <Nop>

" Split Nicely
noremap <expr> <SID>(split)
\ myvimrc#split_direction() ? '<C-W>s' : '<C-W>v'
" }}}

"------------------------------------------------------------------------------
" Command Line: {{{
NOXnoremap <expr> <SID>: myvimrc#cmdline_enter(':')
NXnoremap  <expr> <SID>/ myvimrc#cmdline_enter('/')
NXnoremap  <expr> <SID>? myvimrc#cmdline_enter('?')

NOXmap ;; <SID>:
NOXmap :  <SID>:
NXmap  /  <SID>/
NXmap  ?  <SID>?

NOXnoremap <expr> ;: myvimrc#cmdline_enter(':')
NXnoremap  <expr> ;/ myvimrc#cmdline_enter('/')
NXnoremap  <expr> ;? myvimrc#cmdline_enter('?')

NXnoremap <script> <C-W>/ <SID>(split)<SID>/
NXnoremap <script> <C-W>? <SID>(split)<SID>?

NXnoremap <script> <C-W>q/ <SID>(split)q/
NXnoremap <script> <C-W>q? <SID>(split)q?

NXnoremap <script><expr> <C-W>;/
\ '<SID>(split)' . myvimrc#cmdline_enter('/')
NXnoremap <script><expr> <C-W>;?
\ '<SID>(split)' . myvimrc#cmdline_enter('?')

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

augroup MyVimrc
  autocmd CmdwinEnter *
  \ call myvimrc#cmdwin_enter(expand('<afile>'))
  autocmd CmdwinLeave *
  \ call myvimrc#cmdwin_leave(expand('<afile>'))
augroup END
" }}}

"------------------------------------------------------------------------------
" Search: {{{
noremap <SID>*  *zv
noremap <SID>#  #zv
noremap <SID>g* g*zv
noremap <SID>g# g#zv
noremap <SID>n  nzv
noremap <SID>N  Nzv

NOXmap *  <SID>*
NOXmap #  <SID>#
NOXmap g* <SID>g*
NOXmap g# <SID>g#
NOXmap g/ *
NOXmap g? #

nmap <C-W>*  <SID>(split)<SID>*
nmap <C-W>#  <SID>(split)<SID>#
nmap <C-W>g* <SID>(split)<SID>g*
nmap <C-W>g# <SID>(split)<SID>g#
xnoremap <script> <C-W>*  <SID>(split)gv<SID>*
xnoremap <script> <C-W>#  <SID>(split)gv<SID>#
xnoremap <script> <C-W>g* <SID>(split)gv<SID>g*
xnoremap <script> <C-W>g# <SID>(split)gv<SID>g#
NXmap <C-W>g/ <C-W>*
NXmap <C-W>g? <C-W>#

NOXmap <expr> n v:searchforward ? '<SID>n' : '<SID>N'
NOXmap <expr> N v:searchforward ? '<SID>N' : '<SID>n'
" }}}

"------------------------------------------------------------------------------
" Escape Key: {{{
nnoremap <expr> <Esc><Esc> myvimrc#escape_key()
" }}}

"------------------------------------------------------------------------------
" Moving: {{{
" Jump
nnoremap <S-Tab> <C-O>

" Mark
NOXnoremap m<Down> ]`
NOXnoremap m<Up>   [`
NOXnoremap mj      ]`
NOXnoremap mk      [`

" Command-line-mode
cnoremap <C-A> <C-B>

cnoremap <expr> <C-H>
\ getcmdtype() == '@' && getcmdpos() == 1 && empty(getcmdline()) ?
\   '<Esc>' : '<C-H>'
cnoremap <expr> <BS>
\ getcmdtype() == '@' && getcmdpos() == 1 && empty(getcmdline()) ?
\   '<Esc>' : '<BS>'
cnoremap <expr> <Esc>
\ &cpoptions =~# 'x' ?
\   '<Esc>' : '<C-E><C-U><C-C>'
cnoremap <C-C> <C-E><C-U><C-C>
" }}}

"------------------------------------------------------------------------------
" Window Control: {{{
NXnoremap <M-s>   <C-W>s
NXnoremap <M-v>   <C-W>v
NXnoremap <M-j>   <C-W>j
NXnoremap <M-k>   <C-W>k
NXnoremap <M-h>   <C-W>h
NXnoremap <M-l>   <C-W>l
NXnoremap <M-J>   <C-W>J
NXnoremap <M-K>   <C-W>K
NXnoremap <M-H>   <C-W>H
NXnoremap <M-L>   <C-W>L
NXnoremap <M-=>   <C-W>=
NXnoremap <M-->   <C-W>-
NXnoremap <M-+>   <C-W>+
NXnoremap <M-_>   <C-W>_
NXnoremap <M-<>   <C-W><
NXnoremap <M->>   <C-W>>
NXnoremap <M-Bar> <C-W><Bar>
" }}}

"------------------------------------------------------------------------------
" Leader Prefix: {{{
NXnoremap <Leader>c     :<C-U>close<CR>
NXnoremap <Leader><M-c> :<C-U>tabclose<CR>
NXnoremap <Leader>C     :<C-U>only<CR>
NXnoremap <Leader><M-C> :<C-U>tabonly<CR>
NXnoremap <Leader>n     :<C-U>enew<CR>
NXnoremap <Leader><M-n> :<C-U>tabnew<CR>
NXnoremap <Leader>w     :<C-U>update<CR>
NXnoremap <Leader>W     :<C-U>wall<CR>
NXnoremap <Leader>q     :<C-U>bdelete<CR>
NXnoremap <Leader>E     :<C-U>Explorer<CR>
NXnoremap <Leader>B     :<C-U>buffers<CR>
NXnoremap <Leader>T     :<C-U>tabs<CR>
NXnoremap <Leader>U     :<C-U>undolist<CR>
NXnoremap <Leader>j     :<C-U>changes<CR>
NXnoremap <Leader>J     :<C-U>jumps<CR>
NXnoremap <Leader>p     :<C-U>registers<CR>
NXnoremap <Leader>m     :<C-U>marks<CR>
NXnoremap <Leader>!     :<C-U>shell<CR>
NXnoremap <script> <Leader>e <SID>:<C-U>edit<Space>
NXnoremap <script> <Leader>b <SID>:<C-U>buffer<Space>
NXnoremap <script> <Leader>t <SID>:<C-U>tabnext<Space>
NXnoremap <script> <Leader>u <SID>:<C-U>undo<Space>
NXnoremap <script> <Leader>] <SID>:<C-U>tag<Space>
NXnoremap <script> <Leader>d <SID>:<C-U>lchdir<Space>
NXnoremap <script> <Leader>D <SID>:<C-U>chdir<Space>
NXnoremap <script> <Leader>g <SID>:<C-U>grep<Space>
NXnoremap <script> <Leader>G <SID>:<C-U>lgrep<Space>
NXnoremap <expr> <Leader>Q
\ ':<C-U>1,' . bufnr('$') . 'bdelete<CR>'
NXnoremap <script><expr> <Leader><M-d>
\ '<SID>:<C-U>lchdir ' . compat#expand_slash('%:p:h') . '/'
NXnoremap <script><expr> <Leader><M-D>
\ '<SID>:<C-U>chdir ' . compat#expand_slash('%:p:h') . '/'
" }}}

"------------------------------------------------------------------------------
" Help: {{{
nnoremap <script><expr> <F1>
\ myvimrc#split_direction() ?
\   '<SID>:<C-U>help<Space>' :
\   '<SID>:<C-U>vertical help<Space>'
inoremap <script><expr> <F1>
\ myvimrc#split_direction() ?
\   '<C-O><SID>:<C-U>help<Space>' :
\   '<C-O><SID>:<C-U>vertical help<Space>'
" }}}

"------------------------------------------------------------------------------
" Auto Mark: {{{
nnoremap <expr> mm myvimrc#auto_mark()
nnoremap <expr> mc myvimrc#clear_marks()
nnoremap <expr> mM myvimrc#auto_file_mark()
nnoremap <expr> mC myvimrc#clear_file_marks()
" }}}

"------------------------------------------------------------------------------
" BOL Toggle: {{{
NOXnoremap <expr> H myvimrc#bol_toggle()
NOXnoremap <expr> L myvimrc#eol_toggle()
" }}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
nnoremap  <expr> <M-a> myvimrc#insert_one_char('a')
NXnoremap <expr> <M-A> myvimrc#insert_one_char('A')
nnoremap  <expr> <M-i> myvimrc#insert_one_char('i')
NXnoremap <expr> <M-I> myvimrc#insert_one_char('I')
" }}}

"------------------------------------------------------------------------------
" Blockwise Insert: {{{
xnoremap <expr> A myvimrc#blockwise_insert('A')
xnoremap <expr> I myvimrc#blockwise_insert('I')
" }}}

"------------------------------------------------------------------------------
" Increment: {{{
silent! vunmap <C-A>
silent! vunmap <C-X>
if s:has_patch('7.4.754')
  xnoremap <C-A>  <C-A>gv
  xnoremap <C-X>  <C-X>gv
  xnoremap g<C-A> g<C-A>gv
  xnoremap g<C-X> g<C-X>gv
endif
" }}}

"------------------------------------------------------------------------------
" Others: {{{
" Paste
set pastetoggle=<F11>
nnoremap <F11> :<C-U>set paste! paste?<CR>

" BackSpace
nnoremap <BS>  X
nnoremap <C-H> X

" Yank to end of line
nnoremap Y y$

" Tabmove
NXnoremap <expr> g<M-t>
\ ':<C-U>tabmove +' . v:count1 . '<CR>'
NXnoremap <expr> g<M-T>
\ ':<C-U>tabmove -' . v:count1 . '<CR>'

" Append line
nnoremap <M-o>
\ :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
nnoremap <M-O>
\ :<C-U>call append(line('.') - 1, repeat([''], v:count1))<CR>

" The precious area text object
onoremap gv :<C-U>normal! gv<CR>

" The last changed area text object
nnoremap  g[ `[v`]
OXnoremap g[ :<C-U>normal g[<CR>
" }}}

"------------------------------------------------------------------------------
" Evacuation: {{{
" Mark
nnoremap <M-m> m

" Repeat find
NOXnoremap <M-;> ;
NOXnoremap <M-,> ,

" Jump
NOXnoremap gH H
NOXnoremap gM M
NOXnoremap gL L

" FileInfo
nnoremap <C-G><C-G> <C-G>

" To Select-mode
nnoremap <C-G>h     gh
nnoremap <C-G>H     gH
nnoremap <C-G><C-H> g<C-H>

" Macro
NXnoremap <M-q> q
NXnoremap Q     @
NXnoremap Q;    @:
NXnoremap QQ    @@

" Dangerous key
nnoremap ZQ    <Nop>
nnoremap ZZ    <Nop>
nnoremap gQ    gq
inoremap <C-C> <Esc>

" Rot13
NOXnoremap s?  g?
nnoremap   s?? g??
" }}}
" }}}

"==============================================================================
" Commands: {{{

"------------------------------------------------------------------------------
" Change File Format Option: {{{
command! -bar
\ FfUnix
\ setlocal fileformat=unix
command! -bar
\ FfDos
\ setlocal fileformat=dos
command! -bar
\ FfMac
\ setlocal fileformat=mac
" }}}

"------------------------------------------------------------------------------
" Change File Encoding Option: {{{
if has('multi_byte')
  command! -bar
  \ FencUtf8
  \ setlocal fileencoding=utf-8
  command! -bar
  \ FencUtf16le
  \ setlocal fileencoding=utf-16le
  command! -bar
  \ FencUtf16
  \ setlocal fileencoding=utf-16
  command! -bar
  \ FencCp932
  \ setlocal fileencoding=cp932
  command! -bar
  \ FencEucjp
  \ setlocal fileencoding=euc-jp
  if s:has_jisx0213
    command! -bar
    \ FencEucJisx0213
    \ setlocal fileencoding=euc-jisx0213
    command! -bar
    \ FencIso2022jp
    \ setlocal fileencoding=iso-2022-jp-3
  else
    command! -bar
    \ FencIso2022jp
    \ setlocal fileencoding=iso-2022-jp
  endif
endif
" }}}

"------------------------------------------------------------------------------
" Open With A Specific Character Code Again: {{{
if has('multi_byte')
  command! -bang -bar -nargs=* -complete=file
  \ EditUtf8
  \ edit<bang> ++enc=utf-8 <args>
  command! -bang -bar -nargs=* -complete=file
  \ EditUtf16le
  \ edit<bang> ++enc=utf-16le <args>
  command! -bang -bar -nargs=* -complete=file
  \ EditUtf16
  \ edit<bang> ++enc=utf-16 <args>
  command! -bang -bar -nargs=* -complete=file
  \ EditCp932
  \ edit<bang> ++enc=cp932 <args>
  command! -bang -bar -nargs=* -complete=file
  \ EditEucjp
  \ edit<bang> ++enc=euc-jp <args>
  if s:has_jisx0213
    command! -bang -bar -nargs=* -complete=file
    \ EditEucJisx0213
    \ edit<bang> ++enc=euc-jisx0213 <args>
    command! -bang -bar -nargs=* -complete=file
    \ EditIso2022jp
    \ edit<bang> ++enc=iso-2022-jp-3 <args>
  else
    command! -bang -bar -nargs=* -complete=file
    \ EditIso2022jp
    \ edit<bang> ++enc=iso-2022-jp <args>
  endif
endif
" }}}

"------------------------------------------------------------------------------
" Windows Shell: {{{
if has('win32')
  command! -bar
  \ ShellCmd
  \ call myvimrc#set_shell() |
  \ set shell? shellcmdflag? shellquote? shellxquote? shellslash?
  command! -bar -nargs=?
  \ ShellSh
  \ call myvimrc#set_shell(
  \   !empty(<q-args>) ? <q-args> : 'sh', '-c', '', '"', 1) |
  \ set shell? shellcmdflag? shellquote? shellxquote? shellslash?

  command! -bar -nargs=+ -complete=file
  \ CmdSource
  \ call myvimrc#cmdsource(<q-args>)
endif
" }}}

"------------------------------------------------------------------------------
" VcVarsAll: {{{
if has('win32')
  if !exists('$VCVARSALL')
    if filereadable($VS140COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS140COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif filereadable($VS120COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS120COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif filereadable($VS110COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS110COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif filereadable($VS100COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS100COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif filereadable($VS90COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS90COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif filereadable($VS80COMNTOOLS . '..\..\VC\vcvarsall.bat')
      let $VCVARSALL = $VS80COMNTOOLS . '..\..\VC\vcvarsall.bat'
    endif
  endif
  if !exists('$SDK_INCLUDE_DIR')
    if isdirectory(s:pf32 . '\Microsoft SDKs\Windows\v7.1A\Include')
      let $SDK_INCLUDE_DIR = s:pf32 . '\Microsoft SDKs\Windows\v7.1A\Include'
    elseif isdirectory(s:pf32 . '\Microsoft SDKs\Windows\v7.1\Include')
      let $SDK_INCLUDE_DIR = s:pf32 . '\Microsoft SDKs\Windows\v7.1\Include'
    elseif isdirectory(s:pf32 . '\Microsoft SDKs\Windows\v7.0A\Include')
      let $SDK_INCLUDE_DIR = s:pf32 . '\Microsoft SDKs\Windows\v7.0A\Include'
    elseif isdirectory(s:pf32 . '\Microsoft SDKs\Windows\v7.0\Include')
      let $SDK_INCLUDE_DIR = s:pf32 . '\Microsoft SDKs\Windows\v7.0\Include'
    endif
  endif

  if exists('$VCVARSALL')
    command! -bar
    \ VCVars32
    \ call myvimrc#cmdsource(
    \   myvimrc#cmdescape($VCVARSALL), 'x86')
    if s:arch
      command! -bar
      \ VCVars64
      \ call myvimrc#cmdsource(
      \   myvimrc#cmdescape($VCVARSALL),
      \   exists('PROCESSOR_ARCHITEW6432') ?
      \   $PROCESSOR_ARCHITEW6432 : $PROCESSOR_ARCHITECTURE)
    endif
  endif
endif
" }}}

"------------------------------------------------------------------------------
" Line Number Toggle: {{{
command! -bar
\ LineNumberToggle
\ call myvimrc#line_number_toggle() |
\ set number? relativenumber?

nnoremap <F12>
\ :<C-U>LineNumberToggle<CR>
" }}}

"------------------------------------------------------------------------------
" QuickFix Toggle: {{{
command! -bar -nargs=?
\ CToggle
\ call myvimrc#quickfix_toggle('c', <q-args>)
command! -bar -nargs=?
\ LToggle
\ call myvimrc#quickfix_toggle('l', <q-args>)

NXnoremap <C-W>, :<C-U>CToggle<CR>
NXnoremap <C-W>. :<C-U>LToggle<CR>
" }}}

"------------------------------------------------------------------------------
" From CmdEx: {{{
command! -bar -nargs=1 -complete=file
\ Diff
\ vertical diffsplit <args>
command! -bar
\ Undiff
\ call myvimrc#undiff()

nnoremap <F8> :<C-U>Undiff<CR>
" }}}

"------------------------------------------------------------------------------
" From Example: {{{
command! -bar
\ DiffOrig
\ call myvimrc#difforig()

nnoremap <F7> :<C-U>DiffOrig<CR>
" }}}
" }}}

"==============================================================================
" Auto Command: {{{

"------------------------------------------------------------------------------
" Auto MkDir: {{{
autocmd MyVimrc BufWritePre *
\ call myvimrc#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}

"------------------------------------------------------------------------------
" Quick Close: {{{
autocmd MyVimrc FileType *
\ call myvimrc#quick_close()
" }}}

"------------------------------------------------------------------------------
" QuickFix: {{{
augroup MyVimrc
  autocmd BufWinEnter,WinEnter *
  \ if &buftype == 'quickfix' && !exists('b:qflisttype') |
  \   call myvimrc#set_qflisttype() |
  \ endif
  autocmd QuickFixCmdPost [^l]*
  \ cwindow
  autocmd QuickFixCmdPost l*
  \ lwindow
augroup END
" }}}

"------------------------------------------------------------------------------
" Functions Of Highlight: {{{
function! s:get_highlight(hi) abort
  redir => hl
  silent execute 'highlight' a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', ' ', 'g')
  return matchstr(hl, 'xxx\zs.*$')
endfunction

function! s:_reverse_highlight(hl, name) abort
  let s = matchstr(a:hl, a:name . '=\zs\S\+')
  if s =~ '\%(re\|in\)verse'
    return substitute(
    \ s, '\%(re\|in\)verse,\=\|,\%(re\|in\)verse', '', 'g')
  elseif !empty(s) && s != 'NONE'
    return s . ',reverse'
  else
    return 'reverse'
  endif
endfunction

function! s:reverse_highlight(hl) abort
  return a:hl .
  \ ' term='  . s:_reverse_highlight(a:hl, 'term') .
  \ ' cterm=' . s:_reverse_highlight(a:hl, 'cterm') .
  \ ' gui='   . s:_reverse_highlight(a:hl, 'gui')
endfunction
" }}}

"------------------------------------------------------------------------------
" Reverse Status Line Color At Insert Mode: {{{
if s:is_colored_ui
  function! s:reverse_status_line_color(is_insert, reset) abort
    if !exists('s:hi_status_line') || !exists('s:hi_status_line_i') || a:reset
      silent! let s:hi_status_line   = s:get_highlight('StatusLine')
      silent! let s:hi_status_line_i = s:reverse_highlight(s:hi_status_line)
    endif

    if exists('s:hi_status_line') && exists('s:hi_status_line_i')
      highlight clear StatusLine
      execute 'highlight StatusLine'
      \ a:is_insert ? s:hi_status_line_i : s:hi_status_line
    endif
  endfunction

  augroup MyVimrc
    autocmd ColorScheme *
    \ call s:reverse_status_line_color(mode() =~# '[iR]', 1)
    autocmd InsertEnter *
    \ call s:reverse_status_line_color(1, 0)
    autocmd InsertLeave *
    \ call s:reverse_status_line_color(0, 0)
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" Highlight Ideographic Space: {{{
if has('multi_byte') && s:is_colored_ui
  function! s:highlight_ideographic_space(reset) abort
    if !exists('s:hi_specialkey') || a:reset
      silent! let s:hi_specialkey =
      \ s:get_highlight('SpecialKey')

      if exists('s:hi_specialkey')
        highlight clear IdeographicSpace
        execute 'highlight IdeographicSpace' s:hi_specialkey
        \ 'term=underline cterm=underline gui=underline'
      endif
    endif

    if exists('s:hi_specialkey') && !exists('w:ideographic_space')
      let w:idographic_space = matchadd('IdeographicSpace', '　')
    endif
  endfunction

  augroup MyVimrc
    autocmd ColorScheme *
    \ call s:highlight_ideographic_space(1)
    autocmd VimEnter,WinEnter *
    \ call s:highlight_ideographic_space(0)
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" From Example: {{{
autocmd MyVimrc FileType *
\ call myvimrc#jump_to_last_position(s:ignore_ft)
" }}}
" }}}

"==============================================================================
" Plugins: {{{
" AlterCommand
" {original} : {alternative}
let s:altercmd_define = {
\ 'vb[uffer]'    : 'vertical sbuffer',
\ 'tb[uffer]'    : 'tab sbuffer',
\ 'vbn[ext]'     : 'vertical sbnext',
\ 'vbN[ext]'     : 'vertical sbNext',
\ 'vbp[revious]' : 'vertical sbprevious',
\ 'vbm[odified]' : 'vertical sbmodified',
\ 'tbn[ext]'     : 'tab sbnext',
\ 'tbN[ext]'     : 'tab sbNext',
\ 'tbp[revious]' : 'tab sbprevious',
\ 'tbm[odified]' : 'tab sbmodified',
\ 'vbr[ewind]'   : 'vertical sbrewind',
\ 'vbf[irst]'    : 'vertical sbfirst',
\ 'vbl[ast]'     : 'vertical sblast',
\ 'tbr[ewind]'   : 'tab sbrewind',
\ 'tbf[irst]'    : 'tab sbfirst',
\ 'tbl[ast]'     : 'tab sblast',
\ 'vunh[ide]'    : 'vertical unhide',
\ 'vba[ll]'      : 'vertical ball',
\ 'tunh[ide]'    : 'tab unhide',
\ 'tba[ll]'      : 'tab ball'}

" NeoComplete
" {filetype} : {dictionary}
let s:neocomplete_dictionary_filetype_lists = {
\ 'default' : ''}
" {filetype} : {expr}
let s:neocomplete_tags_filter_patterns = {
\ 'ant'        : 'v:val.word !~ "^[~_]"',
\ 'asm'        : 'v:val.word !~ "^[~_]"',
\ 'aspperl'    : 'v:val.word !~ "^[~_]"',
\ 'aspvbs'     : 'v:val.word !~ "^[~_]"',
\ 'basic'      : 'v:val.word !~ "^[~_]"',
\ 'beta'       : 'v:val.word !~ "^[~_]"',
\ 'c'          : 'v:val.word !~ "^[~_]"',
\ 'cpp'        : 'v:val.word !~ "^[~_]"',
\ 'cs'         : 'v:val.word !~ "^[~_]"',
\ 'java'       : 'v:val.word !~ "^[~_]"',
\ 'vera'       : 'v:val.word !~ "^[~_]"',
\ 'cobol'      : 'v:val.word !~ "^[~_]"',
\ 'dosbatch'   : 'v:val.word !~ "^[~_]"',
\ 'eiffel'     : 'v:val.word !~ "^[~_]"',
\ 'erlang'     : 'v:val.word !~ "^[~_]"',
\ 'fortran'    : 'v:val.word !~ "^[~_]"',
\ 'html'       : 'v:val.word !~ "^[~_]"',
\ 'xhtml'      : 'v:val.word !~ "^[~_]"',
\ 'javascript' : 'v:val.word !~ "^[~_]"',
\ 'lisp'       : 'v:val.word !~ "^[~_]"',
\ 'lua'        : 'v:val.word !~ "^[~_]"',
\ 'make'       : 'v:val.word !~ "^[~_]"',
\ 'matlab'     : 'v:val.word !~ "^[~_]"',
\ 'ocaml'      : 'v:val.word !~ "^[~_]"',
\ 'pascal'     : 'v:val.word !~ "^[~_]"',
\ 'perl'       : 'v:val.word !~ "^[~_]"',
\ 'php'        : 'v:val.word !~ "^[~_]"',
\ 'python'     : 'v:val.word !~ "^[~_]"',
\ 'rexx'       : 'v:val.word !~ "^[~_]"',
\ 'ruby'       : 'v:val.word !~ "^[~_]"',
\ 'scheme'     : 'v:val.word !~ "^[~_]"',
\ 'sh'         : 'v:val.word !~ "^[~_]"',
\ 'bash'       : 'v:val.word !~ "^[~_]"',
\ 'ksh'        : 'v:val.word !~ "^[~_]"',
\ 'zsh'        : 'v:val.word !~ "^[~_]"',
\ 'slang'      : 'v:val.word !~ "^[~_]"',
\ 'sql'        : 'v:val.word !~ "^[~_]"',
\ 'tcl'        : 'v:val.word !~ "^[~_]"',
\ 'tex'        : 'v:val.word !~ "^[~_]"',
\ 'verilog'    : 'v:val.word !~ "^[~_]"',
\ 'vhdl'       : 'v:val.word !~ "^[~_]"',
\ 'vim'        : 'v:val.word !~ "^[~_]"',
\ 'yacc'       : 'v:val.word !~ "^[~_]"'}
" {command} : {function}
let s:neocomplete_vim_completefuncs = {
\ 'SQLSetType' : 'SQL_GetList'}
" {omnifunc} : {pattern}
let s:neocomplete_omni_patterns = {
\ 'CucumberComplete'              : '\h\w*',
\ 'adacomplete#Complete'          : '\h\w*',
\ 'clojurecomplete#Complete'      : '\h\w*',
\ 'csscomplete#CompleteCSS'       : '\h\w*\|[@!]',
\ 'sqlcomplete#Complete'          : '\h\w*'}
" {omnifunc} : {pattern}
let s:neocomplete_force_omni_patterns = {
\ 'ccomplete#Complete'            : '\%(\.\|->\|::\)\h\w*',
\ 'htmlcomplete#CompleteTags'     : '<[^>]*',
\ 'javascriptcomplete#CompleteJS' : '\.\h\w*',
\ 'phpcomplete#CompletePHP'       : '\%(->\|::\)\h\w*',
\ 'xmlcomplete#CompleteTags'      : '<[^>]*'}
if has('python3')
  call extend(s:neocomplete_force_omni_patterns, {
  \ 'python3complete#Complete' : '\.\h\w*'})
endif
if has('python')
  call extend(s:neocomplete_force_omni_patterns, {
  \ 'pythoncomplete#Complete' : '\.\h\w*'})
endif
if has('ruby')
  call extend(s:neocomplete_force_omni_patterns, {
  \ 'rubycomplete#Complete' : '\%(\.\|::\)\h\w*'})
endif

"------------------------------------------------------------------------------
" Built In: {{{
" Assembler
let g:asmsyntax = 'masm'
" let g:asmsyntax = 'z80'
" let g:asmsyntax = 'arm'

" Shell Script
let g:is_bash = 1

" Doxygen
let g:load_doxygen_syntax = 1

" Vim Script
let g:vim_indent_cont = 0

" " Folding
" let g:javaScript_fold    = 1
" let g:perl_fold          = 1
" let g:php_folding        = 1
" let g:ruby_fold          = 1
" let g:sh_fold_enabled    = 1
" let g:vimsyn_folding     = 'af'
" let g:xml_syntax_folding = 1

" Disable
let g:loaded_getscript       = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball         = 1
let g:loaded_vimballPlugin   = 1
" }}}

"------------------------------------------------------------------------------
" Dein: {{{
let s:dein_dir = $XDG_DATA_HOME . '/dein/repos/github.com/Shougo/dein.vim'
if v:version > 703 && isdirectory(s:dein_dir)
  execute 'set runtimepath^=' . escape(escape(s:dein_dir, ' ,'), ' \')
  let g:dein#enable_name_conversion  = 1
  let g:dein#install_max_processes   = min([s:cpucores(), 8])
  let g:dein#install_process_timeout = 6000
  let g:dein#install_progress_type   = 'title'

  if dein#load_state($XDG_DATA_HOME . '/dein')
    let s:dein_toml = compat#glob($HOME . '/.vim/dein/*.toml', 0, 1)
    call dein#begin($XDG_DATA_HOME . '/dein', [$MYVIMRC] + s:dein_toml)

    for s:toml in s:dein_toml
      call dein#load_toml(s:toml, {'lazy' : 1})
    endfor

    call dein#end()
    call dein#save_state()
  endif

  autocmd MyVimrc VimEnter * filetype detect
endif
unlet! s:dein_dir s:dein_toml
" }}}

"------------------------------------------------------------------------------
" Alignta: {{{
if s:dein_tap('alignta')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define(
    \ 'alignta',
    \ 'myvimrc#operator_alignta')
  endfunction

  NOXmap s= <Plug>(operator-alignta)

  nmap s== s=s=
endif
" }}}

"------------------------------------------------------------------------------
" AlterCommand: {{{
if s:dein_tap('altercmd')
  function! g:dein#plugin.hook_post_source() abort
    for [key, value] in items(s:altercmd_define)
      execute 'CAlterCommand' key value
    endfor
  endfunction

  augroup MyVimrc
    autocmd User CmdlineEnter
    \ call dein#source('altercmd')
    autocmd CmdwinEnter :
    \ call myvimrc#cmdwin_enter_altercmd(s:altercmd_define)
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" Altr: {{{
if s:dein_tap('altr')
  nmap g<M-f>     <Plug>(altr-forward)
  nmap g<M-F>     <Plug>(altr-back)
  nmap <C-W><M-f> <SID>(split)<Plug>(altr-forward)
  nmap <C-W><M-F> <SID>(split)<Plug>(altr-back)
endif
" }}}

"------------------------------------------------------------------------------
" Anzu: {{{
if s:dein_tap('anzu')
  set shortmess+=s

  nmap <SID>(anzu-jump-n) <Plug>(anzu-jump-n)<Plug>(anzu-echo-search-status)
  nmap <SID>(anzu-jump-N) <Plug>(anzu-jump-N)<Plug>(anzu-echo-search-status)
  nmap <SID>(anzu-echo)   <Plug>(anzu-update-search-status-with-echo)

  nnoremap <script> <SID>*  *<SID>(anzu-echo)zv
  nnoremap <script> <SID>#  #<SID>(anzu-echo)zv
  nnoremap <script> <SID>g* g*<SID>(anzu-echo)zv
  nnoremap <script> <SID>g# g#<SID>(anzu-echo)zv
  nnoremap <script> <SID>n  <SID>(anzu-jump-n)zv
  nnoremap <script> <SID>N  <SID>(anzu-jump-N)zv

  cnoremap <script><expr> <CR>
  \ '<C-]><CR>' . (getcmdtype() =~ '[/?]' ? '<SID>(anzu-echo)zv' : '')

  augroup MyVimrc
    autocmd CmdwinLeave [/?]
    \ call feedkeys("\<Plug>(anzu-update-search-status-with-echo)")
    autocmd User IncSearchExecute,OperatorStarPost
    \ call feedkeys("\<Plug>(anzu-update-search-status-with-echo)")
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" AutoDate: {{{
if s:dein_tap('autodate')
  function! g:dein#plugin.hook_source() abort
    let g:autodate_lines = 10
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" AutoFmt: {{{
if s:dein_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif
" }}}

"------------------------------------------------------------------------------
" Caw: {{{
if s:dein_tap('caw')
  function! g:dein#plugin.hook_source() abort
    let g:caw_dollarpos_sp_left = ' '
  endfunction

  NXmap gc <Plug>(caw:prefix)
endif
" }}}

"------------------------------------------------------------------------------
" Clang Format: {{{
if s:dein_tap('clang-format')
  " NOXmap <buffer> sf <Plug>(operator-clang-format)
  "
  " nmap <buffer> sff sfsf
endif
" }}}

"------------------------------------------------------------------------------
" Clever F: {{{
if s:dein_tap('clever-f')
  function! g:dein#plugin.hook_source() abort
    let g:clever_f_not_overwrites_standard_mappings = 1
    let g:clever_f_fix_key_direction                = 1
    let g:clever_f_use_migemo                       = 1
  endfunction

  NOXmap f     <Plug>(clever-f-f)
  NOXmap F     <Plug>(clever-f-F)
  NOXmap t     <Plug>(clever-f-t)
  NOXmap T     <Plug>(clever-f-T)
  NOXmap <M-.> <Plug>(clever-f-reset)
  NOXmap <M-;> <Plug>(clever-f-repeat-forward)
  NOXmap <M-,> <Plug>(clever-f-repeat-back)
endif
" }}}

"------------------------------------------------------------------------------
" Clurin: {{{
if s:dein_tap('clurin')
  function! g:dein#plugin.hook_source() abort
    let g:clurin = {
    \ '-' : {
    \   'def' : [],
    \   'nomatch' : function('myvimrc#clurin_nomatch'),
    \   'jump' : 1},
    \ 'c' : {},
    \ 'use_default' : 0}

    call extend(g:clurin['-'].def, [
    \ ['TRUE', 'FALSE'], ['True', 'False'], ['true', 'false'],
    \ ['ENABLE', 'DISABLE'], ['Enable', 'Disable'], ['enable', 'disable'],
    \
    \ ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
    \  'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'],
    \ ['January', 'February', 'March', 'April', 'May', 'June',
    \  'July', 'August', 'September', 'October', 'November', 'December'],
    \ ['january', 'february', 'march', 'april', 'may', 'june',
    \  'july', 'august', 'september', 'october', 'november', 'december'],
    \
    \ ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    \  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'],
    \ ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    \  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    \ ['jan', 'feb', 'mar', 'apr', 'may', 'jun',
    \  'jul', 'aug', 'sep', 'oct', 'nov', 'dec'],
    \
    \ ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
    \ ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    \ ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'],
    \
    \ ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY',
    \  'THURSDAY', 'FRIDAY', 'SATURDAY'],
    \ ['Sunday', 'Monday', 'Tuesday', 'Wednesday',
    \  'Thursday', 'Friday', 'Saturday'],
    \ ['sunday', 'monday', 'tuesday', 'wednesday',
    \  'thursday', 'friday', 'saturday'],
    \
    \ ['ZERO', 'ONE', 'TWO',   'THREE', 'FOUR',
    \  'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE', 'TEN',
    \  'ELEVEN',  'TWELVE',    'THIRTEEN', 'FOURTEEN', 'FIFTEEN',
    \  'SIXTEEN', 'SEVENTEEN', 'EIGHTEEN', 'NINETEEN', 'TWENTY'],
    \ ['Zero', 'One', 'Two',   'Three', 'Four',
    \  'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
    \  'Eleven',  'Twelve',    'Thirteen', 'Fourteen', 'Fifteen',
    \  'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen', 'Twenty'],
    \ ['zero', 'one', 'two',   'three', 'four',
    \  'five', 'six', 'seven', 'eight', 'nine', 'ten',
    \  'eleven',  'twelve',    'thirteen', 'fourteen', 'fifteen',
    \  'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty'],
    \
    \ ['ZEROTH', 'FIRST', 'SECOND',  'THIRD',  'FOURTH',
    \  'FIFTH',  'SIXTH', 'SEVENTH', 'EIGHTH', 'NINTH', 'TENTH',
    \  'ELEVENTH',  'TWELFTH',     'THIRTEENTH', 'FOURTEENTH', 'FIFTEENTH',
    \  'SIXTEENTH', 'SEVENTEENTH', 'EIGHTEENTH', 'NINETEENTH', 'TWENTIETH'],
    \ ['Zeroth', 'First', 'Second',  'Third',  'Fourth',
    \  'Fifth',  'Sixth', 'Seventh', 'Eighth', 'Ninth', 'Tenth',
    \  'Eleventh',  'Twelfth',     'Thirteenth', 'Fourteenth', 'Fifteenth',
    \  'Sixteenth', 'Seventeenth', 'Eighteenth', 'Nineteenth', 'Twentieth'],
    \ ['zeroth', 'first', 'second',  'third',  'fourth',
    \  'fifth',  'sixth', 'seventh', 'eighth', 'ninth', 'tenth',
    \  'eleventh',  'twelfth',     'thirteenth', 'fourteenth', 'fifteenth',
    \  'sixteenth', 'seventeenth', 'eighteenth', 'nineteenth', 'twentieth'],
    \
    \ [{'pattern' : '\(-\?\d*1st\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*2nd\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*3rd\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*[04-9]th\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')}],
    \ [{'pattern' : '\(-\?\d*1ST\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*2ND\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*3RD\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')},
    \  {'pattern' : '\(-\?\d*[04-9]TH\)\C',
    \   'replace' : function('myvimrc#clurin_ordinal')}],
    \
    \ [{'pattern' : '\(-\?\d\*1\)\%(st\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*2\)\%(nd\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*3\)\%(rd\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*[04-9]\)\%(th\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')}],
    \ [{'pattern' : '\(-\?\d\*1\)\%(ST\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*2\)\%(ND\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*3\)\%(RD\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')},
    \  {'pattern' : '\(-\?\d\*[04-9]\)\%(TH\)\@!\C',
    \   'replace' : function('myvimrc#clurin_bypass')}]])

    if !empty(&nrformats)
      let def = []
      if &nrformats =~ 'alpha'
        call add(def, {
        \ 'pattern' : '\(\a\)',
        \ 'replace' : function('myvimrc#clurin_bypass')})
      endif
      if &nrformats =~ 'octal'
        call add(def, {
        \ 'pattern' : '\(0[0-7]\+\)',
        \ 'replace' : function('myvimrc#clurin_bypass')})
      endif
      if &nrformats =~ 'hex'
        call add(def, {
        \ 'pattern' : '\(0x\x\+\)\c',
        \ 'replace' : function('myvimrc#clurin_bypass')})
      endif
      if &nrformats =~ 'bin'
        call add(def, {
        \ 'pattern' : '\(0b[01]\+\)\c',
        \ 'replace' : function('myvimrc#clurin_bypass')})
      endif
      call add(g:clurin['-'].def, def)
    endif
  endfunction

  nmap <C-A> <Plug>(clurin-next)
  nmap <C-X> <Plug>(clurin-prev)
endif
" }}}

"------------------------------------------------------------------------------
" ColumnJump: {{{
if s:dein_tap('columnjump')
  function! g:dein#plugin.hook_source() abort
    call submode#enter_with(
    \ 'coljmp', 'nx', 'r', '<Plug>(submode:coljmp:[)',
    \ '<Plug>(columnjump-backward)')
    call submode#enter_with(
    \ 'coljmp', 'nx', 'r', '<Plug>(submode:coljmp:])',
    \ '<Plug>(columnjump-forward)')
    call submode#map(
    \ 'coljmp', 'nx', 'r', '[',
    \ '<Plug>(columnjump-backward)')
    call submode#map(
    \ 'coljmp', 'nx', 'r', ']',
    \ '<Plug>(columnjump-forward)')
  endfunction

  NXmap [<M-[> <Plug>(submode:coljmp:[)
  NXmap ]<M-]> <Plug>(submode:coljmp:])

  omap [<M-[> <Plug>(columnjump-backward)
  omap ]<M-]> <Plug>(columnjump-forward)
endif
" }}}

"------------------------------------------------------------------------------
" Universal Ctags: {{{
if s:dein_tap('ctags')
  call extend(s:neocomplete_tags_filter_patterns, {
  \ 'ada'        : 'v:val.word !~ "^[~_]"',
  \ 'ant'        : 'v:val.word !~ "^[~_]"',
  \ 'asm'        : 'v:val.word !~ "^[~_]"',
  \ 'aspperl'    : 'v:val.word !~ "^[~_]"',
  \ 'aspvbs'     : 'v:val.word !~ "^[~_]"',
  \ 'basic'      : 'v:val.word !~ "^[~_]"',
  \ 'beta'       : 'v:val.word !~ "^[~_]"',
  \ 'c'          : 'v:val.word !~ "^[~_]"',
  \ 'd'          : 'v:val.word !~ "^[~_]"',
  \ 'cpp'        : 'v:val.word !~ "^[~_]"',
  \ 'cs'         : 'v:val.word !~ "^[~_]"',
  \ 'java'       : 'v:val.word !~ "^[~_]"',
  \ 'vera'       : 'v:val.word !~ "^[~_]"',
  \ 'clojure'    : 'v:val.word !~ "^[~_]"',
  \ 'cobol'      : 'v:val.word !~ "^[~_]"',
  \ 'css'        : 'v:val.word !~ "^[~_]"',
  \ 'diff'       : 'v:val.word !~ "^[~_]"',
  \ 'dosbatch'   : 'v:val.word !~ "^[~_]"',
  \ 'eiffel'     : 'v:val.word !~ "^[~_]"',
  \ 'erlang'     : 'v:val.word !~ "^[~_]"',
  \ 'falcon'     : 'v:val.word !~ "^[~_]"',
  \ 'fortran'    : 'v:val.word !~ "^[~_]"',
  \ 'go'         : 'v:val.word !~ "^[~_]"',
  \ 'html'       : 'v:val.word !~ "^[~_]"',
  \ 'xhtml'      : 'v:val.word !~ "^[~_]"',
  \ 'javascript' : 'v:val.word !~ "^[~_]"',
  \ 'json'       : 'v:val.word !~ "^[~_]"',
  \ 'lisp'       : 'v:val.word !~ "^[~_]"',
  \ 'lua'        : 'v:val.word !~ "^[~_]"',
  \ 'make'       : 'v:val.word !~ "^[~_]"',
  \ 'matlab'     : 'v:val.word !~ "^[~_]"',
  \ 'objc'       : 'v:val.word !~ "^[~_]"',
  \ 'objcpp'     : 'v:val.word !~ "^[~_]"',
  \ 'ocaml'      : 'v:val.word !~ "^[~_]"',
  \ 'pascal'     : 'v:val.word !~ "^[~_]"',
  \ 'perl'       : 'v:val.word !~ "^[~_]"',
  \ 'perl6'      : 'v:val.word !~ "^[~_]"',
  \ 'php'        : 'v:val.word !~ "^[~_]"',
  \ 'zephir'     : 'v:val.word !~ "^[~_]"',
  \ 'python'     : 'v:val.word !~ "^[~_]"',
  \ 'r'          : 'v:val.word !~ "^[~_]"',
  \ 'rexx'       : 'v:val.word !~ "^[~_]"',
  \ 'rst'        : 'v:val.word !~ "^[~_]"',
  \ 'ruby'       : 'v:val.word !~ "^[~_]"',
  \ 'rust'       : 'v:val.word !~ "^[~_]"',
  \ 'scheme'     : 'v:val.word !~ "^[~_]"',
  \ 'sh'         : 'v:val.word !~ "^[~_]"',
  \ 'bash'       : 'v:val.word !~ "^[~_]"',
  \ 'ksh'        : 'v:val.word !~ "^[~_]"',
  \ 'zsh'        : 'v:val.word !~ "^[~_]"',
  \ 'slang'      : 'v:val.word !~ "^[~_]"',
  \ 'sml'        : 'v:val.word !~ "^[~_]"',
  \ 'sql'        : 'v:val.word !~ "^[~_]"',
  \ 'tcl'        : 'v:val.word !~ "^[~_]"',
  \ 'tex'        : 'v:val.word !~ "^[~_]"',
  \ 'verilog'    : 'v:val.word !~ "^[~_]"',
  \ 'vhdl'       : 'v:val.word !~ "^[~_]"',
  \ 'vim'        : 'v:val.word !~ "^[~_]"',
  \ 'rc'         : 'v:val.word !~ "^[~_]"',
  \ 'yacc'       : 'v:val.word !~ "^[~_]"'})
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP: {{{
if s:dein_tap('ctrlp')
  function! g:dein#plugin.hook_source() abort
    let g:ctrlp_map                 = ''
    let g:ctrlp_match_window        = 'max:20'
    let g:ctrlp_switch_buffer       = ''
    let g:ctrlp_working_path_mode   = ''
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_show_hidden         = 1
    let g:ctrlp_max_files           = 10000
    let g:ctrlp_max_depth           = 20
    let g:ctrlp_open_new_file       = 'r'
    let g:ctrlp_mruf_max            = 1000
    let g:ctrlp_mruf_case_sensitive = !&fileignorecase

    let g:ctrlp_custom_ignore       = {
    \ 'dir'  : join(s:ignore_dir, '\|'),
    \ 'file' : '\.\%(' . join(s:ignore_ext, '\|') . '\)$'}
    let g:ctrlp_mruf_exclude        =
    \ join(s:ignore_dir, '\|')

    if !has('win32') && s:executable('find')
      let l:ctrlp_user_command =
      \ 'find -L %s -type f'
    " elseif has('win32')
    "   let l:ctrlp_user_command =
    "   \ 'dir %s /-n /b /s /a-d'
    elseif s:executable('files')
      let l:ctrlp_user_command =
      \ 'files ' .
      \ (s:cpucores() > 1 ? '-A ' : '') .
      \ '%s'
    endif
    if exists('l:ctrlp_user_command')
      let g:ctrlp_user_command = {
      \ 'fallback' : l:ctrlp_user_command,
      \ 'ignore'   : 1}
    endif
  endfunction

  NXnoremap <Leader>e :<C-U>CtrlPMRUFiles<CR>
  NXnoremap <Leader>E :<C-U>CtrlP<CR>

  NXnoremap <Leader>u :<C-U>CtrlPUndo<CR>
  NXnoremap <Leader>j :<C-U>CtrlPChange<CR>
  NXnoremap <Leader>] :<C-U>CtrlPTag<CR>

  if empty(dein#get('tabpagebuffer-misc'))
    NXnoremap <Leader>b :<C-U>CtrlPBuffer<CR>
  endif
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Chdir: {{{
if s:dein_tap('ctrlp-chdir')
  NXnoremap <Leader>d     :<C-U>CtrlPLchdir<CR>
  NXnoremap <Leader>D     :<C-U>CtrlPChdir<CR>
  NXnoremap <Leader><M-d> :<C-U>CtrlPLchdir %:p:h<CR>
  NXnoremap <Leader><M-D> :<C-U>CtrlPChdir %:p:h<CR>
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP ColorScheme: {{{
if s:dein_tap('ctrlp-colorscheme')
  command! -bar
  \ CtrlPColorScheme
  \ call ctrlp#init(ctrlp#colorscheme#id())
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Jumps: {{{
if s:dein_tap('ctrlp-jumps')
  NXnoremap <Leader>J :<C-U>CtrlPJump<CR>
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Mark: {{{
if s:dein_tap('ctrlp-mark')
  NXnoremap <Leader>m :<C-U>CtrlPMark<CR>
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Py Matcher: {{{
if s:dein_tap('ctrlp-py-matcher')
  function! g:dein#plugin.hook_source() abort
    let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch'}
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Register: {{{
if s:dein_tap('ctrlp-register')
  if empty(dein#get('yankround'))
    nnoremap <Leader>p :<C-U>CtrlPRegister<CR>
    xnoremap <Leader>p d:<C-U>CtrlPRegister<CR>
  endif
endif
" }}}

"------------------------------------------------------------------------------
" CtrlP Tabpage: {{{
if s:dein_tap('ctrlp-tabpage')
  function! g:dein#plugin.hook_source() abort
    let g:ctrlp#tabpage#visible_all_buftype = 1
  endfunction

  NXnoremap <Leader>t :<C-U>CtrlPTabpage<CR>
endif
" }}}

"------------------------------------------------------------------------------
" EchoDoc: {{{
if s:dein_tap('echodoc')
  function! g:dein#plugin.hook_source() abort
    call echodoc#enable()
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Emmet: {{{
if s:dein_tap('emmet')
  function! g:dein#plugin.hook_source() abort
    let g:user_emmet_leader_key = '<C-K>'
    let g:user_emmet_settings   = {
    \ 'lang' : 'ja',
    \ 'indentation' : '  ',
    \ 'xml' : {'extends' : 'html'}}
  endfunction

  call extend(s:neocomplete_omni_patterns, {
  \ 'emmet#CompleteTag' : '\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" Eskk: {{{
if s:dein_tap('eskk')
  function! g:dein#plugin.hook_source() abort
    let g:eskk#directory               = $XDG_CACHE_HOME . '/eskk'
    let g:eskk#no_default_mappings     = 1
    let g:eskk#start_completion_length = 1
    let g:eskk#mapped_keys             =
    \ filter(eskk#get_default_mapped_keys(), 'v:val !=? "<Tab>"')
    let g:eskk#dictionary              = {
    \ 'path' : $XDG_CACHE_HOME . '/skk-jisyo',
    \ 'sorted' : 0,
    \ 'encoding' : 'utf-8'}

    if has('win32') || !filereadable('/usr/local/share/skk/SKK-JISYO.L')
      let g:eskk#large_dictionary = {
      \ 'path' : $HOME . '/.vim/dict/SKK-JISYO.L',
      \ 'sorted' : 1,
      \ 'encoding' : 'euc-jp'}
    endif
  endfunction

  map! <C-J> <Plug>(eskk:toggle)
  lmap <C-J> <Plug>(eskk:toggle)
endif
" }}}

"------------------------------------------------------------------------------
" FastFold: {{{
if s:dein_tap('FastFold')
  function! g:dein#plugin.hook_source() abort
    let g:fastfold_savehook               = 1
    let g:fastfold_fold_movement_commands = []

    call submode#enter_with(
    \ 'ff/move', 'n', 'se', '<Plug>(submode:ff/move:j)',
    \ '":<C-U>FastFoldUpdate<CR>" . v:count1 . "zj"')
    call submode#enter_with(
    \ 'ff/move', 'n', 'se', '<Plug>(submode:ff/move:k)',
    \ '":<C-U>FastFoldUpdate<CR>" . v:count1 . "zk"')
    call submode#enter_with(
    \ 'ff/move', 'x', 'se', '<Plug>(submode:ff/move:j)',
    \ '":<C-U>FastFoldUpdate<CR>gv" . v:count1 . "zj"')
    call submode#enter_with(
    \ 'ff/move', 'x', 'se', '<Plug>(submode:ff/move:k)',
    \ '":<C-U>FastFoldUpdate<CR>gv" . v:count1 . "zk"')
    call submode#map(
    \ 'ff/move', 'nx', '', 'j', 'zj')
    call submode#map(
    \ 'ff/move', 'nx', '', 'k', 'zk')

    call submode#enter_with(
    \ 'ff/sq', 'n', 'se', '<Plug>(submode:ff/sq:[)',
    \ '":<C-U>FastFoldUpdate<CR>" . v:count1 . "[z"')
    call submode#enter_with(
    \ 'ff/sq', 'n', 'se', '<Plug>(submode:ff/sq:])',
    \ '":<C-U>FastFoldUpdate<CR>" . v:count1 . "]z"')
    call submode#enter_with(
    \ 'ff/sq', 'x', 'se', '<Plug>(submode:ff/sq:[)',
    \ '":<C-U>FastFoldUpdate<CR>gv" . v:count1 . "[z"')
    call submode#enter_with(
    \ 'ff/sq', 'x', 'se', '<Plug>(submode:ff/sq:])',
    \ '":<C-U>FastFoldUpdate<CR>gv" . v:count1 . "]z"')
    call submode#map(
    \ 'ff/sq', 'nx', '', '[', '[z')
    call submode#map(
    \ 'ff/sq', 'nx', '', ']', ']z')
  endfunction

  NXmap zj <Plug>(submode:ff/move:j)
  NXmap zk <Plug>(submode:ff/move:k)
  NXmap [z <Plug>(submode:ff/sq:[)
  NXmap ]z <Plug>(submode:ff/sq:])

  autocmd MyVimrc InsertEnter,InsertLeave *
  \ FastFoldUpdate
endif
" }}}

"------------------------------------------------------------------------------
" Goto File: {{{
if s:dein_tap('gf-user')
  function! g:dein#plugin.hook_source() abort
    let g:gf_user_no_default_key_mappings = 1
  endfunction

  NXmap gf         <Plug>(gf-user-gf)
  NXmap gF         <Plug>(gf-user-gF)
  NXmap <C-W>f     <Plug>(gf-user-<C-w>f)
  NXmap <C-W>F     <Plug>(gf-user-<C-w>F)
  NXmap <C-W>gf    <Plug>(gf-user-<C-w>gf)
  NXmap <C-W>gF    <Plug>(gf-user-<C-w>gF)
  NXmap <C-W><C-F> <Plug>(gf-user-<C-w><C-f>)
endif
" }}}

"------------------------------------------------------------------------------
" Go Extra: {{{
if s:dein_tap('go-extra')
  call extend(s:neocomplete_force_omni_patterns, {
  \ 'go#complete#Complete' : '\.\h\w*',
  \ 'gocomplete#Complete'  : '\.\h\w*'})
  call extend(s:neocomplete_vim_completefuncs, {
  \ 'GoDoc' : 'go#complete#Package'})
endif
" }}}

"------------------------------------------------------------------------------
" Grex: {{{
if s:dein_tap('grex')
  NOXmap sD <Plug>(operator-grex-delete)
  NOXmap sY <Plug>(operator-grex-yank)

  nmap sDD sDsD
  nmap sYY sYsY
endif
" }}}

"------------------------------------------------------------------------------
" Hier: {{{
if s:dein_tap('hier')
  autocmd MyVimrc User EscapeKey
  \ HierClear
endif
" }}}

"------------------------------------------------------------------------------
" IncSearch: {{{
if s:dein_tap('incsearch')
  NOXnoremap <silent><expr> <SID>/ myvimrc#incsearch_next()
  NOXnoremap <silent><expr> <SID>? myvimrc#incsearch_prev()
endif
" }}}

"------------------------------------------------------------------------------
" J6uil: {{{
if s:dein_tap('J6uil')
  function! g:dein#plugin.hook_source() abort
    let g:J6uil_config_dir             = $XDG_CACHE_HOME . '/J6uil'
    let g:J6uil_echo_presence          = 0
    let g:J6uil_open_buffer_cmd        = 'tabedit'
    let g:J6uil_no_default_keymappings = 1
    let g:J6uil_user                   = 'DeaR'

    if has('win32') && s:executable('imdisplay')
      let $PATH = fnamemodify(compat#exepath('imdisplay'), ':h') . ';' . $PATH
      let g:J6uil_display_icon = 1
    elseif !has('win32') && s:executable('convert')
      let g:J6uil_display_icon = 1
    endif
  endfunction

  call extend(s:altercmd_define, {
  \ 'j[6uil]' : 'J6uil'})
  call extend(s:neocomplete_vim_completefuncs, {
  \ 'J6uil' : 'J6uil#complete#room'})
endif
" }}}

"------------------------------------------------------------------------------
" Jedi: {{{
if s:dein_tap('jedi')
  function! g:dein#plugin.hook_source() abort
    let g:jedi#auto_initialization    = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot           = 0
    let g:jedi#auto_close_doc         = 0
    let g:jedi#show_call_signatures   = 0
  endfunction

  call extend(s:neocomplete_force_omni_patterns, {
  \ 'jedi#completions' : '\.\h\w*'})
  call extend(s:neocomplete_vim_completefuncs, {
  \ 'Pyimport' : 'jedi#py_import_completions'})
endif
" }}}

"------------------------------------------------------------------------------
" Lua Ftplugin: {{{
if s:dein_tap('lua-ftplugin')
  function! g:dein#plugin.hook_source() abort
    let g:lua_complete_omni              = 1
    let g:lua_check_syntax               = 0
    let g:lua_check_globals              = 0
    let g:lua_define_completion_mappings = 0

    if s:executable('luajit')
      let g:lua_interpreter_path = 'luajit'
      let g:lua_compiler_name    = 'luajit'
      let g:lua_compiler_args    = '-bl'
      let g:lua_error_format     = 'luajit: %f:%l: %m'
    elseif s:executable('lua53') && s:executable('luac53')
      let g:lua_interpreter_path = 'lua53'
      let g:lua_compiler_name    = 'luac53'
    endif
  endfunction

  call extend(s:neocomplete_force_omni_patterns, {
  \ 'xolox#lua#omnifunc' : '\%(\.\|:\)\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" Localrc: {{{
if s:dein_tap('localrc')
  augroup MyVimrc
    autocmd BufNewFile,BufRead *
    \ call myvimrc#localrc_undo()
    autocmd FileType *
    \ call myvimrc#localrc_undo_filetype()
  augroup END
endif
" }}}

"------------------------------------------------------------------------------
" MapList: {{{
if s:dein_tap('maplist')
  function! g:dein#plugin.hook_source() abort
    let g:maplist#mode_length  = 4
    let g:maplist#lhs_length   = 50
    let g:maplist#local_length = 2
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Marching: {{{
if s:dein_tap('marching')
  function! g:dein#plugin.hook_source() abort
    let g:marching_enable_neocomplete = 1
    let g:marching_backend            =
    \ !empty(dein#get('snowdrop')) ? 'snowdrop' : 'sync_clang_command'
  endfunction

  call extend(s:neocomplete_force_omni_patterns, {
  \ 'marching#complete' : '\%(\.\|->\|::\)\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" MetaRW: {{{
if s:dein_tap('metarw')
  function! g:dein#plugin.hook_source() abort
    call metarw#define_wrapper_commands(1)
  endfunction

  " let g:loaded_gzip              = 1
  let g:loaded_netrw             = 1
  let g:loaded_netrwFileHandlers = 1
  let g:loaded_netrwPlugin       = 1
  let g:loaded_netrwSettings     = 1
  " let g:loaded_tar               = 1
  " let g:loaded_tarPlugin         = 1
  " let g:loaded_zip               = 1
  " let g:loaded_zipPlugin         = 1

  if empty(dein#get('ctrlp'))
    NXnoremap <script> <Leader>e <SID>:<C-U>Edit<Space>
  endif
  
  call extend(s:altercmd_define, {
  \ 'e[dit]'   : 'Edit',
  \ 'r[ead]'   : 'Read',
  \ 'so[urce]' : 'Source',
  \ 'w[rite]'  : 'Write',
  \
  \ '_e[dit]'   : 'edit',
  \ '_r[ead]'   : 'read',
  \ '_so[urce]' : 'source',
  \ '_w[rite]'  : 'write'})
  call extend(s:neocomplete_vim_completefuncs, {
  \ 'Edit'   : 'metarw#complete',
  \ 'Read'   : 'metarw#complete',
  \ 'Source' : 'metarw#complete',
  \ 'Write'  : 'metarw#complete'})
endif
" }}}

"------------------------------------------------------------------------------
" MetaRW Local: {{{
if s:dein_tap('metarw-local')
  function! g:dein#plugin.hook_source() abort
    let g:metarw_local_enable_fallback = 1
  endfunction

  if empty(dein#get('ctrlp'))
    NXnoremap <Leader>E :<C-U>Edit local:<CR>
  endif
endif
" }}}

"------------------------------------------------------------------------------
" Molokai: {{{
if s:dein_tap('molokai')
  function! g:dein#plugin.hook_source() abort
    let g:molokai_original = 0
    let g:rehash256        = 1
  endfunction

  function! s:molokai_after() abort
    if get(g:, 'colors_name', '') != 'molokai'
      return
    endif

    highlight clear TabLine
    highlight clear TabLineFill
    highlight TabLine
    \ ctermbg=244 ctermfg=232 cterm=NONE
    \ guibg=#808080 guifg=#080808 gui=NONE
    highlight TabLineFill
    \ ctermfg=244 ctermbg=232 cterm=reverse
    \ guifg=#808080 guibg=#080808 gui=reverse
  endfunction
  autocmd MyVimrc ColorScheme *
  \ call s:molokai_after()
endif
" }}}

"------------------------------------------------------------------------------
" Narrow: {{{
if s:dein_tap('narrow')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define_ex_command(
    \ 'narrow',
    \ 'Narrow')

    silent! delcommand Narrow
    silent! delcommand Widen
  endfunction

  NXnoremap sN :<C-U>Widen<CR>
  NOXmap sn <Plug>(operator-narrow)

  nmap snn snsn
endif
" }}}

"------------------------------------------------------------------------------
" Neco Vim: {{{
if s:dein_tap('neco-vim')
  function! g:dein#plugin.hook_source() abort
    let g:necovim#complete_functions =
    \ s:neocomplete_vim_completefuncs
  endfunction

  autocmd MyVimrc CmdwinEnter :
  \ let b:neocomplete_sources =
  \ add(get(b:, 'neocomplete_sources', []), 'vim')
endif
" }}}

"------------------------------------------------------------------------------
" NeoComplete: {{{
if s:dein_tap('neocomplete')
  function! g:dein#plugin.hook_source() abort
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_auto_select           = 0
    let g:neocomplete#enable_auto_delimiter        = 1
    let g:neocomplete#force_overwrite_completefunc = 1

    let g:neocomplete#sources#dictionary#dictionaryies =
    \ s:neocomplete_dictionary_filetype_lists
    let g:neocomplete#tags_filter_patterns             =
    \ s:neocomplete_tags_filter_patterns
    " let g:neocomplete#sources#omni#input_patterns      =
    " \ s:neocomplete_omni_patterns
    " let g:neocomplete#force_omni_input_patterns        =
    " \ s:neocomplete_force_omni_patterns

    call neocomplete#custom#source('_', 'matchers', ['matcher_head'])
    call neocomplete#custom#source('syntax_complete',   'rank',  9)

    call neocomplete#disable_default_dictionary(
    \ 'g:neocomplete#tags_filter_patterns')
    call neocomplete#disable_default_dictionary(
    \ 'g:neocomplete#sources#omni#input_patterns')
    call neocomplete#disable_default_dictionary(
    \ 'g:neocomplete#force_omni_input_patterns')

    inoremap <expr> <C-Y>
    \ neocomplete#close_popup()
    inoremap <expr> <C-E>
    \ neocomplete#cancel_popup()
    inoremap <expr> <C-L>
    \ neocomplete#complete_common_string()
    inoremap <expr> <C-G>
    \ neocomplete#undo_completion()
    inoremap <expr> <C-X><C-X>
    \ neocomplete#close_popup() .
    \ neocomplete#start_manual_complete()

    inoremap <expr> <CR>
    \ neocomplete#close_popup() . '<CR>'
    inoremap <expr> <C-H>
    \ neocomplete#smart_close_popup() . '<C-H>'
    inoremap <expr> <BS>
    \ neocomplete#smart_close_popup() . '<BS>'

    inoremap <expr> <Tab>
    \ pumvisible() ? '<C-N>' : '<Tab>'
    inoremap <expr> <S-Tab>
    \ pumvisible() ? '<C-P>' : '<S-Tab>'
  endfunction

  augroup MyVimrc
    autocmd CmdwinEnter *
    \ call myvimrc#cmdwin_enter_neocomplete()
    autocmd CmdwinEnter :
    \ let b:neocomplete_sources =
    \ add(get(b:, 'neocomplete_sources', []), 'file')
  augroup END

  call extend(s:neocomplete_vim_completefuncs, {
  \ 'NeoCompleteDictionaryMakeCache' : 'neocomplete#filetype_complete',
  \ 'NeoCompleteSyntaxMakeCache'     : 'neocomplete#filetype_complete'})
endif
" }}}

"------------------------------------------------------------------------------
" OmniSharp: {{{
if s:dein_tap('omnisharp')
  function! g:dein#plugin.hook_source() abort
    " let g:OmniSharp_server_type = 'roslyn'
    let g:OmniSharp_server_path =
    \ g:dein#plugin.path . '/server/OmniSharp/bin/Release/OmniSharp.exe'
    let g:OmniSharp_selector_ui = 'ctrlp'
  endfunction

  call extend(s:neocomplete_force_omni_patterns, {
  \ 'OmniSharp#Complete' : '\.\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" Open Browser: {{{
if s:dein_tap('open-browser')
  nmap gxgx <Plug>(openbrowser-smart-search)
  nmap gxx gxgx

  call extend(s:neocomplete_vim_completefuncs, {
  \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
  \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})
endif
" }}}

"------------------------------------------------------------------------------
" Operator Camelize: {{{
if s:dein_tap('operator-camelize')
  NOXmap sU <Plug>(operator-camelize)
  NOXmap su <Plug>(operator-decamelize)
  NOXmap s~ <Plug>(operator-camelize-toggle)

  nmap sUU sUsU
  nmap suu susu
  nmap s~~ s~s~
endif
" }}}

"------------------------------------------------------------------------------
" Operator Filled With Blank: {{{
if s:dein_tap('operator-filled-with-blank')
  NOXmap s<Space> <Plug>(operator-filled-with-blank)

  nmap s<Space><Space> s<Space>s<Space>
endif
" }}}

"------------------------------------------------------------------------------
" Operator Furround: {{{
if s:dein_tap('operator-furround')
  NOXmap sa <Plug>(operator-furround-append-input)
  NOXmap sA <Plug>(operator-furround-append-reg)
  NOXmap sd <Plug>(operator-furround-delete)
  NOXmap sc <Plug>(operator-furround-replace-input)
  NOXmap sC <Plug>(operator-furround-replace-reg)

  nmap sasa <Plug>(operator-furround-append-input)<Plug>(textobj-multiblock-a)
  nmap sAsA <Plug>(operator-furround-append-reg)<Plug>(textobj-multiblock-a)
  nmap sdsd <Plug>(operator-furround-delete)<Plug>(textobj-multiblock-a)
  nmap scsc <Plug>(operator-furround-replace-input)<Plug>(textobj-multiblock-a)
  nmap sCsC <Plug>(operator-furround-replace-reg)<Plug>(textobj-multiblock-a)

  nmap saa sasa
  nmap sAA sAsA
  nmap sdd sdsd
  nmap scc scsc
  nmap sCC sCsC
endif
" }}}

"------------------------------------------------------------------------------
" Operator HTML Escape: {{{
if s:dein_tap('operator-html-escape')
  NOXmap se <Plug>(operator-html-escape)
  NOXmap sE <Plug>(operator-html-unescape)

  nmap see sese
  nmap sEE sEsE
endif
" }}}

"------------------------------------------------------------------------------
" Operator Open Browser: {{{
if s:dein_tap('operator-openbrowser')
  NOXmap gx <Plug>(operator-openbrowser)
endif
" }}}

"------------------------------------------------------------------------------
" Operator Replace: {{{
if s:dein_tap('operator-replace')
  NOXmap sr <Plug>(operator-replace)

  nnoremap srr srsr
endif
" }}}

"------------------------------------------------------------------------------
" Operator Reverse: {{{
if s:dein_tap('operator-reverse')
  NOXmap sv <Plug>(operator-reverse-text)
  NOXmap sV <Plug>(operator-reverse-lines)

  nmap svv svsv
  nmap sVV sVsV
endif
" }}}

"------------------------------------------------------------------------------
" Operator Search: {{{
if s:dein_tap('operator-search')
  NOXmap s/ <Plug>(operator-search)

  nmap s// s/s/
endif
" }}}

"------------------------------------------------------------------------------
" Operator Sequence: {{{
if s:dein_tap('operator-sequence')
  NOXmap <expr> s<C-U>
  \ operator#sequence#map("\<Plug>(operator-decamelize)", 'gU')

  nmap s<C-U><C-U> s<C-U>s<C-U>
endif
" }}}

"------------------------------------------------------------------------------
" Operator Shuffle: {{{
if s:dein_tap('operator-shuffle')
  NOXmap sS <Plug>(operator-shuffle)

  nmap sSS sSsS
endif
" }}}

"------------------------------------------------------------------------------
" Operator Sort: {{{
if s:dein_tap('operator-sort')
  NOXmap ss <Plug>(operator-sort)

  nmap sss ssss
endif
" }}}

"------------------------------------------------------------------------------
" Operator Star: {{{
if s:dein_tap('operator-star')
  function! g:dein#plugin.hook_source() abort
    let g:loaded_operator_star = 1

    call operator#user#define('*',  'myvimrc#operator_star_star')
    call operator#user#define('#',  'myvimrc#operator_star_sharp')
    call operator#user#define('g*', 'myvimrc#operator_star_gstar')
    call operator#user#define('g#', 'myvimrc#operator_star_gsharp')
  endfunction

  NOmap *  <Plug>(operator-*)
  NOmap #  <Plug>(operator-#)
  NOmap g* <Plug>(operator-g*)
  NOmap g# <Plug>(operator-g#)

  nmap <C-W>*  <SID>(split)<Plug>(operator-*)
  nmap <C-W>#  <SID>(split)<Plug>(operator-#)
  nmap <C-W>g* <SID>(split)<Plug>(operator-g*)
  nmap <C-W>g# <SID>(split)<Plug>(operator-g#)

  nnoremap <script> **   <SID>*
  nnoremap <script> ##   <SID>#
  nnoremap <script> g*g* <SID>g*
  nnoremap <script> g#g# <SID>g#

  nnoremap <script> <C-W>**   <SID>(split)<SID>*
  nnoremap <script> <C-W>##   <SID>(split)<SID>#
  nnoremap <script> <C-W>g*g* <SID>(split)<SID>g*
  nnoremap <script> <C-W>g#g# <SID>(split)<SID>g#

  nmap g/g/ **
  nmap g?g? ##
  nmap g//  **
  nmap g??  ##
  nmap g**  g*g*
  nmap g##  g#g#

  nmap <C-W>g/g/ <C-W>**
  nmap <C-W>g?g? <C-W>##
  nmap <C-W>g//  <C-W>**
  nmap <C-W>g??  <C-W>##
  nmap <C-W>g**  <C-W>g*g*
  nmap <C-W>g##  <C-W>g#g#
endif
" }}}

"------------------------------------------------------------------------------
" Operator Suddendeath: {{{
if s:dein_tap('operator-suddendeath')
  NOXmap s! <Plug>(operator-suddendeath)

  nmap s!! s!s!
endif
" }}}

"------------------------------------------------------------------------------
" Operator Tabular: {{{
if s:dein_tap('operator-tabular')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define(
    \ 'tabularize',
    \ 'myvimrc#operator_tabularize')
    call operator#user#define(
    \ 'untabularize',
    \ 'myvimrc#operator_untabularize')
  endfunction

  NOXmap st <Plug>(operator-tabularize)
  NOXmap sT <Plug>(operator-untabularize)

  nmap stt stst
  nmap sTT sTsT
endif
" }}}

"------------------------------------------------------------------------------
" Operator Trailingspace Killer: {{{
if s:dein_tap('operator-trailingspace-killer')
  NOXmap s$ <Plug>(operator-trailingspace-killer)

  nmap s$$ s$s$
endif
" }}}

"------------------------------------------------------------------------------
" Operator User: {{{
if s:dein_tap('operator-user')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define(
    \ 'lgrep',
    \ 'myvimrc#operator_lgrep')
    call operator#user#define(
    \ 'grep',
    \ 'myvimrc#operator_grep')
  endfunction

  NOXmap sg <Plug>(operator-grep)
  NOXmap sG <Plug>(operator-lgrep)

  nmap sgg sgsg
  nmap sGG sGsG

  nmap sgsg <Leader>g
  nmap sGsG <Leader>G
endif
" }}}

"------------------------------------------------------------------------------
" ParaJump: {{{
if s:dein_tap('parajump')
  function! g:dein#plugin.hook_source() abort
    let g:parajump_no_default_key_mappings = 1
  endfunction

  NOXmap { <Plug>(parajump-backward)
  NOXmap } <Plug>(parajump-forward)
endif
" }}}

"------------------------------------------------------------------------------
" ParenMatch: {{{
if s:dein_tap('parenmatch')
  function! g:dein#plugin.hook_source() abort
    let g:parenmatch_highlight = 0
    highlight link ParenMatch MatchParen
  endfunction

  let g:loaded_matchparen = 1

  autocmd MyVimrc ColorScheme *
  \ highlight link ParenMatch MatchParen
endif
" }}}

"------------------------------------------------------------------------------
" PerlOmni: {{{
if s:dein_tap('perlomni')
  function! g:dein#plugin.hook_source() abort
    if has('win32')
      let $PATH =
      \ substitute(g:dein#plugin.path, '/', '\\', 'g') . '\bin;' . $PATH
    else
      let $PATH = g:dein#plugin.path . '/bin:' . $PATH
    endif
  endfunction

  call extend(s:neocomplete_force_omni_patterns, {
  \ 'PerlComplete' : '\%(->\|::\)\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" Precious: {{{
if s:dein_tap('precious')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_precious_no_default_key_mappings = 1
    let g:precious_enable_switchers                = {
    \ '*'        : {'setfiletype' : 0},
    \ 'markdown' : {'setfiletype' : 1}}
  endfunction

  function! Precious_y() abort
    if empty(&filetype)
      return ''
    endif

    let b = precious#base_filetype()
    let c = precious#context_filetype()
    if b == c
      return '[' . b . ']'
    else
      return '[' . b . ':' . c . ']'
    endif
  endfunction
  function! Precious_Y() abort
    if empty(&filetype)
      return ''
    endif

    let b = toupper(precious#base_filetype())
    let c = toupper(precious#context_filetype())
    if b == c
      return b . ','
    else
      return b . ':' . c . ','
    endif
  endfunction

  let &statusline  = substitute(&statusline, '%y\C', '%{Precious_y()}', 'g')
  " let &statusline  = substitute(&statusline, '%Y\C', '%{Precious_Y()}', 'g')
  " let &tabline     = substitute(&statusline, '%y\C', '%{Precious_y()}', 'g')
  " let &tabline     = substitute(&statusline, '%Y\C', '%{Precious_Y()}', 'g')
  " let &titlestring = substitute(&statusline, '%y\C', '%{Precious_y()}', 'g')
  " let &titlestring = substitute(&statusline, '%Y\C', '%{Precious_Y()}', 'g')

  nmap  sR <Plug>(precious-quickrun-op)
  OXmap aX <Plug>(textobj-precious-i)
  OXmap iX <Plug>(textobj-precious-i)
endif
" }}}

"------------------------------------------------------------------------------
" Quickhl: {{{
if s:dein_tap('quickhl')
  NXmap  sM <Plug>(quickhl-manual-reset)
  NOXmap sm <Plug>(operator-quickhl-manual-this-motion)

  nmap smm smsm
endif
" }}}

"------------------------------------------------------------------------------
" QuickRun: {{{
if s:dein_tap('quickrun')
  function! g:dein#plugin.hook_source() abort
    let g:quickrun_no_default_key_mappings = 1

    call myvimrc#extend_quickrun_config('_', {
    \ 'runner' : s:has_vimproc() ? 'vimproc' : 'system',
    \ 'runner/vimproc/updatetime' : 100,
    \ 'outputter' : 'quickfix'})

    call myvimrc#extend_quickrun_config('c', {
    \ 'type' :
    \   s:executable('clang') ? 'c/clang' :
    \   s:executable('gcc')   ? 'c/gcc' :
    \   exists('$VCVARSALL')  ? 'c/vc' :
    \   s:executable('cl')    ? 'c/vc' : ''})

    call myvimrc#extend_quickrun_config('cpp', {
    \ 'type' :
    \   s:executable('clang++') ? 'cpp/clang++' :
    \   s:executable('g++')     ? 'cpp/g++' :
    \   exists('$VCVARSALL')    ? 'cpp/vc' :
    \   s:executable('cl')      ? 'cpp/vc' : ''})

    call myvimrc#extend_quickrun_config('cs', {
    \ 'type' :
    \   exists('$VCVARSALL') ? 'cs/csc' :
    \   s:executable('csc')  ? 'cs/csc' :
    \   s:executable('dmcs') ? 'cs/dmcs' :
    \   s:executable('smcs') ? 'cs/smcs' :
    \   s:executable('gmcs') ? 'cs/gmcs' :
    \   s:executable('mcs')  ? 'cs/mcs' : ''})

    call myvimrc#extend_quickrun_config('vbnet', {
    \ 'type' :
    \   exists('$VCVARSALL') ? 'vbnet/vbc' :
    \   s:executable('vbc')  ? 'vbnet/vbc' : ''})

    call myvimrc#extend_quickrun_config('vbnet/vbc', {
    \ 'command' : 'vbc',
    \ 'exec' : ['%c /nologo /out:%s:p:r.exe %s', '%s:p:r.exe %a'],
    \ 'tempfile' : '%{tempname()}.vb',
    \ 'hook/sweep/files' : ['%s:p:r.exe']})

    if has('win32')
      call myvimrc#extend_quickrun_config('c/vc', {
      \ 'hook/output_encode/encoding' : 'cp932'})

      call myvimrc#extend_quickrun_config('cpp/vc', {
      \ 'hook/output_encode/encoding' : 'cp932'})

      call myvimrc#extend_quickrun_config('cs/csc', {
      \ 'hook/output_encode/encoding' : 'cp932'})

      call myvimrc#extend_quickrun_config('vbnet/vbc', {
      \ 'hook/output_encode/encoding' : 'cp932'})
    endif

    nnoremap <expr> <C-C>
    \ quickrun#is_running() ?
    \ ':<C-U>call quickrun#sweep_sessions()<CR>' : '<C-C>'
  endfunction

  if empty(dein#get('precious'))
    nmap sR <Plug>(quickrun-op)
  endif
  xmap sR  <Plug>(quickrun)
  omap sR  g@
  nmap sRR sRsR

  NXmap <F5> :<C-U>QuickRun<CR>

  call extend(s:neocomplete_vim_completefuncs, {
  \ 'QuickRun' : 'quickrun#complete'})
endif
" }}}

"------------------------------------------------------------------------------
" QuickRun Hook VcVarsAll: {{{
if s:dein_tap('quickrun-hook-vcvarsall')
  function! g:dein#plugin.hook_source() abort
    call myvimrc#extend_quickrun_config('c/vc', {
    \ 'hook/vcvarsall/enable' : 1,
    \ 'hook/vcvarsall/bat' : myvimrc#cmdescape($VCVARSALL)})

    call myvimrc#extend_quickrun_config('cpp/vc', {
    \ 'hook/vcvarsall/enable' : 1,
    \ 'hook/vcvarsall/bat' : myvimrc#cmdescape($VCVARSALL)})

    call myvimrc#extend_quickrun_config('cs/csc', {
    \ 'hook/vcvarsall/enable' : 1,
    \ 'hook/vcvarsall/bat' : myvimrc#cmdescape($VCVARSALL)})

    call myvimrc#extend_quickrun_config('vbnet/vbc', {
    \ 'hook/vcvarsall/enable' : 1,
    \ 'hook/vcvarsall/bat' : myvimrc#cmdescape($VCVARSALL)})

    call myvimrc#extend_quickrun_config('watchdogs_checker/msvc', {
    \ 'hook/vcvarsall/enable' : 1,
    \ 'hook/vcvarsall/bat' : myvimrc#cmdescape($VCVARSALL)})
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Ref: {{{
if s:dein_tap('ref')
  function! g:dein#plugin.hook_source() abort
    let g:ref_no_default_key_mappings = 1
  endfunction

  NXmap K <Plug>(ref-keyword)

  call extend(s:neocomplete_vim_completefuncs, {
  \ 'Ref' : 'ref#complete'})
endif
" }}}

"------------------------------------------------------------------------------
" RengBang: {{{
if s:dein_tap('rengbang')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define_ex_command(
    \ 'rengbang-confirm',
    \ 'RengBangConfirm')
  endfunction

  NOXmap s+ <Plug>(operator-rengbang-confirm)

  nmap s++ s+s+
endif
" }}}

"------------------------------------------------------------------------------
" Repeat: {{{
if s:dein_tap('repeat')
  function! g:dein#plugin.hook_source() abort
    let g:repeat_no_default_key_mappings = 1

    call submode#enter_with(
    \ 'rep/br', 'n', 'r', '<Plug>(submode:rep/br:-)',
    \ '<Plug>(repeat-g-)')
    call submode#enter_with(
    \ 'rep/br', 'n', 'r', '<Plug>(submode:rep/br:+)',
    \ '<Plug>(repeat-g+)')
    call submode#map(
    \ 'rep/br', 'n', 'r', '-',
    \ '<Plug>(repeat-g-)')
    call submode#map(
    \ 'rep/br', 'n', 'r', '+',
    \ '<Plug>(repeat-g+)')
  endfunction

  nmap .     <Plug>(repeat-.)
  nmap u     <Plug>(repeat-u)
  nmap U     <Plug>(repeat-U)
  nmap <C-R> <Plug>(repeat-<C-r>)
  nmap g-    <Plug>(submode:rep/br:-)
  nmap g+    <Plug>(submode:rep/br:+)

  nnoremap <M-o>
  \ :<C-U>call append(line('.'), repeat([''], v:count1)) <Bar>
  \ call repeat#set('<M-o>', v:count1)<CR>
  nnoremap <M-O>
  \ :<C-U>call append(line('.') - 1, repeat([''], v:count1)) <Bar>
  \ call repeat#set('<M-O>', v:count1)<CR>
endif
" }}}

"------------------------------------------------------------------------------
" Scratch: {{{
if s:dein_tap('scratch')
  function! g:dein#plugin.hook_source() abort
    let g:scratch_buffer_name = '[scratch]'

    call operator#user#define_ex_command(
    \ 'scratch-evaluate',
    \ 'ScratchEvaluate')
    call operator#user#define_ex_command(
    \ 'scratch-evaluate!',
    \ 'ScratchEvaluate!')
  endfunction

  autocmd MyVimrc User PluginScratchInitializeAfter
  \ nmap <buffer> sR <Plug>(operator-scratch-evaluate)
endif
" }}}

"------------------------------------------------------------------------------
" SmartWord: {{{
if s:dein_tap('smartword')
  NOXmap w  <Plug>(smartword-w)
  NOXmap b  <Plug>(smartword-b)
  NOXmap e  <Plug>(smartword-e)
  NOXmap ge <Plug>(smartword-ge)
endif
" }}}

"------------------------------------------------------------------------------
" Snowdrop: {{{
if s:dein_tap('snowdrop')
  function! g:dein#plugin.hook_source() abort
    if has('win64')
      let g:snowdrop#libclang_directory = s:pf64 . '/LLVM/bin'
      let g:snowdrop#libclang_file      = 'libclang.dll'
    elseif has('win32')
      let g:snowdrop#libclang_directory = s:pf32 . '/LLVM/bin'
      let g:snowdrop#libclang_file      = 'libclang.dll'
    elseif filereadable($HOME . '/lib/libclang.so')
      let g:snowdrop#libclang_directory = $HOME . '/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    elseif filereadable('/usr/local/lib/libclang.so')
      let g:snowdrop#libclang_directory = '/usr/local/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    elseif filereadable('/usr/lib/libclang.so')
      let g:snowdrop#libclang_directory = '/usr/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    endif
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" SubMode: {{{
if s:dein_tap('submode')
  function! g:dein#plugin.hook_source() abort
    let g:submode_keep_leaving_key = 1

    if empty(dein#get('repeat'))
      call submode#enter_with(
      \ 'undo/br', 'n', '', '<Plug>(submode:undo/br:-)', 'g-')
      call submode#enter_with(
      \ 'undo/br', 'n', '', '<Plug>(submode:undo/br:+)', 'g+')
      call submode#map(
      \ 'undo/br', 'n', '', '-', 'g-')
      call submode#map(
      \ 'undo/br', 'n', '', '+', 'g+')
    endif

    if empty(dein#get('FastFold'))
      call submode#enter_with(
      \ 'move/fold', 'nx', '', '<Plug>(submode:move/fold:j)', 'zj')
      call submode#enter_with(
      \ 'move/fold', 'nx', '', '<Plug>(submode:move/fold:k)', 'zk')
      call submode#map(
      \ 'move/fold', 'nx', '', 'j', 'zj')
      call submode#map(
      \ 'move/fold', 'nx', '', 'k', 'zk')

      call submode#enter_with(
      \ 'sq/fold', 'nx', '', '<Plug>(submode:sq/fold:[)', '[z')
      call submode#enter_with(
      \ 'sq/fold', 'nx', '', '<Plug>(submode:sq/fold:])', ']z')
      call submode#map(
      \ 'sq/fold', 'nx', '', '[', '[z')
      call submode#map(
      \ 'sq/fold', 'nx', '', ']', ']z')
    endif

    call submode#enter_with(
    \ 'change', 'n', '', '<Plug>(submode:change:;)', 'g;')
    call submode#enter_with(
    \ 'change', 'n', '', '<Plug>(submode:change:,)', 'g,')
    call submode#map(
    \ 'change', 'n', '', ';', 'g;')
    call submode#map(
    \ 'change', 'n', '', ',', 'g,')

    call submode#enter_with(
    \ 'move/disp', 'nx', '', '<Plug>(submode:move/disp:j)', 'gj')
    call submode#enter_with(
    \ 'move/disp', 'nx', '', '<Plug>(submode:move/disp:k)', 'gk')
    call submode#map(
    \ 'move/disp', 'nx', '', '<Down>', 'gj')
    call submode#map(
    \ 'move/disp', 'nx', '', '<Up>',   'gk')
    call submode#map(
    \ 'move/disp', 'nx', '', 'j',      'gj')
    call submode#map(
    \ 'move/disp', 'nx', '', 'k',      'gk')

    call submode#enter_with(
    \ 'sq/ifdef', 'nx', '', '<Plug>(submode:sq/ifdef:[)', '[#')
    call submode#enter_with(
    \ 'sq/ifdef', 'nx', '', '<Plug>(submode:sq/ifdef:])', ']#')
    call submode#map(
    \ 'sq/ifdef', 'nx', '', '[', '[#')
    call submode#map(
    \ 'sq/ifdef', 'nx', '', ']', ']#')

    call submode#enter_with(
    \ 'sq/mark/l', 'nx', '', "<Plug>(submode:sq/mark/l:['", "['")
    call submode#enter_with(
    \ 'sq/mark/l', 'nx', '', "<Plug>(submode:sq/mark/l:]'", "]'")
    call submode#map(
    \ 'sq/mark/l', 'nx', '', "[", "['")
    call submode#map(
    \ 'sq/mark/l', 'nx', '', "]", "]'")

    call submode#enter_with(
    \ 'sq/paren', 'nx', '', '<Plug>(submode:sq/paren:[)', '[(')
    call submode#enter_with(
    \ 'sq/paren', 'nx', '', '<Plug>(submode:sq/paren:])', '])')
    call submode#map(
    \ 'sq/paren', 'nx', '', '[', '[(')
    call submode#map(
    \ 'sq/paren', 'nx', '', ']', '])')

    call submode#enter_with(
    \ 'sq/comm/c', 'nx', '', '<Plug>(submode:sq/comm/c:[)', '[*')
    call submode#enter_with(
    \ 'sq/comm/c', 'nx', '', '<Plug>(submode:sq/comm/c:])', ']*')
    call submode#map(
    \ 'sq/comm/c', 'nx', '', '[', '[*')
    call submode#map(
    \ 'sq/comm/c', 'nx', '', ']', ']*')

    call submode#enter_with(
    \ 'sq/mark/c', 'nx', '', '<Plug>(submode:sq/mark/c:[)', '[`')
    call submode#enter_with(
    \ 'sq/mark/c', 'nx', '', '<Plug>(submode:sq/mark/c:])', ']`')
    call submode#map(
    \ 'sq/mark/c', 'nx', '', '[', '[`')
    call submode#map(
    \ 'sq/mark/c', 'nx', '', ']', ']`')

    call submode#enter_with(
    \ 'sq/seq/b', 'nx', '', '<Plug>(submode:sq/seq/b:[)', '[[')
    call submode#enter_with(
    \ 'sq/seq/b', 'nx', '', '<Plug>(submode:sq/seq/b:])', ']]')
    call submode#map(
    \ 'sq/seq/b', 'nx', '', '[', '[[')
    call submode#map(
    \ 'sq/seq/b', 'nx', '', ']', ']]')

    call submode#enter_with(
    \ 'sq/seq/e', 'nx', '', '<Plug>(submode:sq/seq/e:[)', '[]')
    call submode#enter_with(
    \ 'sq/seq/e', 'nx', '', '<Plug>(submode:sq/seq/e:])', '][')
    call submode#map(
    \ 'sq/seq/e', 'nx', '', '[', '[]')
    call submode#map(
    \ 'sq/seq/e', 'nx', '', ']', '][')

    call submode#enter_with(
    \ 'sq/meth/b', 'nx', '', '<Plug>(submode:sq/meth/b:[)', '[m')
    call submode#enter_with(
    \ 'sq/meth/b', 'nx', '', '<Plug>(submode:sq/meth/b:])', ']m')
    call submode#map(
    \ 'sq/meth/b', 'nx', '', '[', '[m')
    call submode#map(
    \ 'sq/meth/b', 'nx', '', ']', ']m')

    call submode#enter_with(
    \ 'sq/meth/e', 'nx', '', '<Plug>(submode:sq/meth/e:[)', '[M')
    call submode#enter_with(
    \ 'sq/meth/e', 'nx', '', '<Plug>(submode:sq/meth/e:])', ']M')
    call submode#map(
    \ 'sq/meth/e', 'nx', '', '[', '[M')
    call submode#map(
    \ 'sq/meth/e', 'nx', '', ']', ']M')

    call submode#enter_with(
    \ 'sq/diff', 'nx', '', '<Plug>(submode:sq/diff:[)', '[c')
    call submode#enter_with(
    \ 'sq/diff', 'nx', '', '<Plug>(submode:sq/diff:])', ']c')
    call submode#map(
    \ 'sq/diff', 'nx', '', '[', '[c')
    call submode#map(
    \ 'sq/diff', 'nx', '', ']', ']c')

    call submode#enter_with(
    \ 'sq/typo/m', 'nx', '', '<Plug>(submode:sq/typo/m:[)', '[s')
    call submode#enter_with(
    \ 'sq/typo/m', 'nx', '', '<Plug>(submode:sq/typo/m:])', ']s')
    call submode#map(
    \ 'sq/typo/m', 'nx', '', '[', '[s')
    call submode#map(
    \ 'sq/typo/m', 'nx', '', ']', ']s')

    call submode#enter_with(
    \ 'sq/typo/b', 'nx', '', '<Plug>(submode:sq/typo/b:[)', '[S')
    call submode#enter_with(
    \ 'sq/typo/b', 'nx', '', '<Plug>(submode:sq/typo/b:])', ']S')
    call submode#map(
    \ 'sq/typo/b', 'nx', '', '[', '[S')
    call submode#map(
    \ 'sq/typo/b', 'nx', '', ']', ']S')

    call submode#enter_with(
    \ 'sq/brkt', 'nx', '', '<Plug>(submode:sq/brkt:[)', '[{')
    call submode#enter_with(
    \ 'sq/brkt', 'nx', '', '<Plug>(submode:sq/brkt:])', ']}')
    call submode#map(
    \ 'sq/brkt', 'nx', '', '[', '[{')
    call submode#map(
    \ 'sq/brkt', 'nx', '', ']', ']}')

    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:j)', '<C-W>j')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:k)', '<C-W>k')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:h)', '<C-W>h')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:l)', '<C-W>l')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:w)', '<C-W>w')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:W)', '<C-W>W')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:t)', '<C-W>t')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:b)', '<C-W>b')
    call submode#enter_with(
    \ 'win/jump', 'nx', '', '<Plug>(submode:win/jump:p)', '<C-W>p')
    call submode#map(
    \ 'win/jump', 'nx', '', '<Down>',  '<C-W>j')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-J>',   '<C-W>j')
    call submode#map(
    \ 'win/jump', 'nx', '', 'j',       '<C-W>j')
    call submode#map(
    \ 'win/jump', 'nx', '', '<Up>',    '<C-W>k')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-K>',   '<C-W>k')
    call submode#map(
    \ 'win/jump', 'nx', '', 'k',       '<C-W>k')
    call submode#map(
    \ 'win/jump', 'nx', '', '<Left>',  '<C-W>h')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-H>',   '<C-W>h')
    call submode#map(
    \ 'win/jump', 'nx', '', '<BS>',    '<C-W>h')
    call submode#map(
    \ 'win/jump', 'nx', '', 'h',       '<C-W>h')
    call submode#map(
    \ 'win/jump', 'nx', '', '<Right>', '<C-W>l')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-L>',   '<C-W>l')
    call submode#map(
    \ 'win/jump', 'nx', '', 'l',       '<C-W>l')
    call submode#map(
    \ 'win/jump', 'nx', '', 'w',       '<C-W>w')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-W>',   '<C-W>w')
    call submode#map(
    \ 'win/jump', 'nx', '', 'W',       '<C-W>W')
    call submode#map(
    \ 'win/jump', 'nx', '', 't',       '<C-W>t')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-T>',   '<C-W>t')
    call submode#map(
    \ 'win/jump', 'nx', '', 'b',       '<C-W>b')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-B>',   '<C-W>b')
    call submode#map(
    \ 'win/jump', 'nx', '', 'p',       '<C-W>p')
    call submode#map(
    \ 'win/jump', 'nx', '', '<C-P>',   '<C-W>p')

    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:r)', '<C-W>r')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:R)', '<C-W>R')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:x)', '<C-W>x')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:K)', '<C-W>K')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:J)', '<C-W>J')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:H)', '<C-W>H')
    call submode#enter_with(
    \ 'win/move', 'nx', '', '<Plug>(submode:win/move:L)', '<C-W>L')
    call submode#map(
    \ 'win/move', 'nx', '', 'r',     '<C-W>r')
    call submode#map(
    \ 'win/move', 'nx', '', '<C-R>', '<C-W>r')
    call submode#map(
    \ 'win/move', 'nx', '', 'R',     '<C-W>R')
    call submode#map(
    \ 'win/move', 'nx', '', 'x',     '<C-W>x')
    call submode#map(
    \ 'win/move', 'nx', '', '<C-X>', '<C-W>x')
    call submode#map(
    \ 'win/move', 'nx', '', 'K',     '<C-W>K')
    call submode#map(
    \ 'win/move', 'nx', '', 'J',     '<C-W>J')
    call submode#map(
    \ 'win/move', 'nx', '', 'H',     '<C-W>H')
    call submode#map(
    \ 'win/move', 'nx', '', 'L',     '<C-W>L')

    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:=)',     '<C-W>=')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:-)',     '<C-W>-')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:+)',     '<C-W>+')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:_)',     '<C-W>_')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:<lt>)',  '<C-W><lt>')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:>)',     '<C-W>>')
    call submode#enter_with(
    \ 'win/size', 'nx', '', '<Plug>(submode:win/size:<Bar>)', '<C-W><Bar>')
    call submode#map(
    \ 'win/size', 'nx', '', '=',     '<C-W>=')
    call submode#map(
    \ 'win/size', 'nx', '', '-',     '<C-W>-')
    call submode#map(
    \ 'win/size', 'nx', '', '+',     '<C-W>+')
    call submode#map(
    \ 'win/size', 'nx', '', '<C-_>', '<C-W>_')
    call submode#map(
    \ 'win/size', 'nx', '', '_',     '<C-W>_')
    call submode#map(
    \ 'win/size', 'nx', '', '<lt>',  '<C-W><lt>')
    call submode#map(
    \ 'win/size', 'nx', '', '>',     '<C-W>>')
    call submode#map(
    \ 'win/size', 'nx', '', '<Bar>', '<C-W><Bar>')

    call submode#enter_with(
    \ 'tab/jump', 'nx', '', '<Plug>(submode:tab/jump:t)', 'gt')
    call submode#enter_with(
    \ 'tab/jump', 'nx', '', '<Plug>(submode:tab/jump:T)', 'gT')
    call submode#map(
    \ 'tab/jump', 'nx', '', 't', 'gt')
    call submode#map(
    \ 'tab/jump', 'nx', '', 'T', 'gT')

    call submode#enter_with(
    \ 'tab/move', 'nx', 'se', '<Plug>(submode:tab/move:<M-t>)',
    \ '":<C-U>tabmove +" . v:count1 . "<CR>"')
    call submode#enter_with(
    \ 'tab/move', 'nx', 'se', '<Plug>(submode:tab/move:<M-T>)',
    \ '":<C-U>tabmove -" . v:count1 . "<CR>"')
    call submode#map(
    \ 'tab/move', 'nx', 's', '<M-t>',
    \ ':<C-U>+tabmove<CR>')
    call submode#map(
    \ 'tab/move', 'nx', 's', '<M-T>',
    \ ':<C-U>-tabmove<CR>')

    call submode#enter_with(
    \ 'move/mark', 'nx', '', '<Plug>(submode:move/mark:j)', ']`')
    call submode#enter_with(
    \ 'move/mark', 'nx', '', '<Plug>(submode:move/mark:k)', '[`')
    call submode#map(
    \ 'move/mark', 'nx', '', '<Down>', ']`')
    call submode#map(
    \ 'move/mark', 'nx', '', '<Up>',   '[`')
    call submode#map(
    \ 'move/mark', 'nx', '', 'j',      ']`')
    call submode#map(
    \ 'move/mark', 'nx', '', 'k',      '[`')

    call submode#enter_with(
    \ 'delchar', 'n', 'se', '<Plug>(submode:delchar:x)',
    \ 'myvimrc#submode_delchar_enter(1)')
    call submode#enter_with(
    \ 'delchar', 'n', 'se', '<Plug>(submode:delchar:X)',
    \ 'myvimrc#submode_delchar_enter(0)')
    call submode#enter_with(
    \ 'delchar', 'n', 'se', '<Plug>(submode:delchar:<Del>)',
    \ 'myvimrc#submode_delchar_enter(1)')
    call submode#enter_with(
    \ 'delchar', 'n', 'se', '<Plug>(submode:delchar:<BS>)',
    \ 'myvimrc#submode_delchar_enter(0)')
    call submode#enter_with(
    \ 'delchar', 'n', 'se', '<Plug>(submode:delchar:<C-H>)',
    \ 'myvimrc#submode_delchar_enter(0)')
    call submode#map(
    \ 'delchar', 'n', 's', 'x',
    \ ':<C-U>call myvimrc#submode_delchar(1)<CR>')
    call submode#map(
    \ 'delchar', 'n', 's', 'X',
    \ ':<C-U>call myvimrc#submode_delchar(0)<CR>')
    call submode#map(
    \ 'delchar', 'n', 's', '<Del>',
    \ ':<C-U>call myvimrc#submode_delchar(1)<CR>')
    call submode#map(
    \ 'delchar', 'n', 's', '<BS>',
    \ ':<C-U>call myvimrc#submode_delchar(0)<CR>')
    call submode#map(
    \ 'delchar', 'n', 's', '<C-H>',
    \ ':<C-U>call myvimrc#submode_delchar(0)<CR>')
  endfunction

  if empty(dein#get('repeat'))
    nmap g- <Plug>(submode:undo/br:-)
    nmap g+ <Plug>(submode:undo/br:+)
  endif

  if empty(dein#get('FastFold'))
    NXmap zj <Plug>(submode:move/fold:j)
    NXmap zk <Plug>(submode:move/fold:k)
    NXmap [z <Plug>(submode:sq/fold:[)
    NXmap ]z <Plug>(submode:sq/fold:])
  endif

  nmap  g;           <Plug>(submode:change:;)
  nmap  g,           <Plug>(submode:change:,)
  NXmap g<Down>      <Plug>(submode:move/disp:j)
  NXmap g<Up>        <Plug>(submode:move/disp:k)
  NXmap gj           <Plug>(submode:move/disp:j)
  NXmap gk           <Plug>(submode:move/disp:k)
  NXmap [#           <Plug>(submode:sq/ifdef:[)
  NXmap ]#           <Plug>(submode:sq/ifdef:])
  NXmap ['           <Plug>(submode:sq/mark/l:[)
  NXmap ]'           <Plug>(submode:sq/mark/l:])
  NXmap [(           <Plug>(submode:sq/paren:[)
  NXmap ])           <Plug>(submode:sq/paren:])
  NXmap [*           <Plug>(submode:sq/comm/c:[)
  NXmap ]*           <Plug>(submode:sq/comm/c:])
  NXmap [`           <Plug>(submode:sq/mark/c:[)
  NXmap ]`           <Plug>(submode:sq/mark/c:])
  NXmap [/           <Plug>(submode:sq/comm/c:[)
  NXmap ]/           <Plug>(submode:sq/comm/c:])
  NXmap [[           <Plug>(submode:sq/seq/b:[)
  NXmap ]]           <Plug>(submode:sq/seq/b:])
  NXmap []           <Plug>(submode:sq/seq/e:[)
  NXmap ][           <Plug>(submode:sq/seq/e:])
  NXmap [m           <Plug>(submode:sq/meth/b:[)
  NXmap ]m           <Plug>(submode:sq/meth/b:])
  NXmap [M           <Plug>(submode:sq/mrth/e:[)
  NXmap ]M           <Plug>(submode:sq/mrth/e:])
  NXmap [c           <Plug>(submode:sq/diff:[)
  NXmap ]c           <Plug>(submode:sq/diff:])
  NXmap [s           <Plug>(submode:sq/typo/m:[)
  NXmap ]s           <Plug>(submode:sq/typo/m:])
  NXmap [S           <Plug>(submode:sq/typo/b:[)
  NXmap ]S           <Plug>(submode:sq/typo/b:])
  NXmap [{           <Plug>(submode:sq/brkt:[)
  NXmap ]}           <Plug>(submode:sq/brkt:])
  NXmap <C-W><Down>  <Plug>(submode:win/jump:j)
  NXmap <C-W><C-J>   <Plug>(submode:win/jump:j)
  NXmap <C-W>j       <Plug>(submode:win/jump:j)
  NXmap <C-W><Up>    <Plug>(submode:win/jump:k)
  NXmap <C-W><C-K>   <Plug>(submode:win/jump:k)
  NXmap <C-W>k       <Plug>(submode:win/jump:k)
  NXmap <C-W><Left>  <Plug>(submode:win/jump:h)
  NXmap <C-W><C-H>   <Plug>(submode:win/jump:h)
  NXmap <C-W><BS>    <Plug>(submode:win/jump:h)
  NXmap <C-W>h       <Plug>(submode:win/jump:h)
  NXmap <C-W><Right> <Plug>(submode:win/jump:l)
  NXmap <C-W><C-L>   <Plug>(submode:win/jump:l)
  NXmap <C-W>l       <Plug>(submode:win/jump:l)
  NXmap <C-W>w       <Plug>(submode:win/jump:w)
  NXmap <C-W><C-W>   <Plug>(submode:win/jump:w)
  NXmap <C-W>W       <Plug>(submode:win/jump:W)
  NXmap <C-W>t       <Plug>(submode:win/jump:t)
  NXmap <C-W><C-T>   <Plug>(submode:win/jump:t)
  NXmap <C-W>b       <Plug>(submode:win/jump:b)
  NXmap <C-W><C-B>   <Plug>(submode:win/jump:b)
  NXmap <C-W>p       <Plug>(submode:win/jump:p)
  NXmap <C-W><C-P>   <Plug>(submode:win/jump:p)
  NXmap <C-W>r       <Plug>(submode:win/move:r)
  NXmap <C-W><C-R>   <Plug>(submode:win/move:r)
  NXmap <C-W>R       <Plug>(submode:win/move:R)
  NXmap <C-W>x       <Plug>(submode:win/move:x)
  NXmap <C-W><C-X>   <Plug>(submode:win/move:x)
  NXmap <C-W>K       <Plug>(submode:win/move:K)
  NXmap <C-W>J       <Plug>(submode:win/move:J)
  NXmap <C-W>H       <Plug>(submode:win/move:H)
  NXmap <C-W>L       <Plug>(submode:win/move:L)
  NXmap <C-W>=       <Plug>(submode:win/size:=)
  NXmap <C-W>-       <Plug>(submode:win/size:-)
  NXmap <C-W>+       <Plug>(submode:win/size:+)
  NXmap <C-W><C-_>   <Plug>(submode:win/size:_)
  NXmap <C-W>_       <Plug>(submode:win/size:_)
  NXmap <C-W><lt>    <Plug>(submode:win/size:<lt>)
  NXmap <C-W>>       <Plug>(submode:win/size:>)
  NXmap <C-W><Bar>   <Plug>(submode:win/size:<Bar>)
  NXmap gt           <Plug>(submode:tab/jump:t)
  NXmap gT           <Plug>(submode:tab/jump:T)
  NXmap g<M-t>       <Plug>(submode:tab/move:<M-t>)
  NXmap g<M-T>       <Plug>(submode:tab/move:<M-T>)
  NXmap m<Down>      <Plug>(submode:move/mark:j)
  NXmap m<Up>        <Plug>(submode:move/mark:k)
  NXmap mj           <Plug>(submode:move/mark:j)
  NXmap mk           <Plug>(submode:move/mark:k)
  nmap  x            <Plug>(submode:delchar:x)
  nmap  X            <Plug>(submode:delchar:X)
  nmap  <Del>        <Plug>(submode:delchar:<Del>)
  nmap  <BS>         <Plug>(submode:delchar:<BS>)
  nmap  <C-H>        <Plug>(submode:delchar:<C-H>)
endif
" }}}

"------------------------------------------------------------------------------
" Tabpage Buffer Misc: {{{
if s:dein_tap('tabpagebuffer-misc')
  function! g:dein#plugin.hook_source() abort
    let g:tabpagebuffer#command#bdelete_keeptabpage = 1
    let g:ctrlp#tabpagebuffer#visible_all_buftype   = 1
  endfunction

  NXnoremap <Leader>B :<C-U>TpbBuffers<CR>
  NXnoremap <Leader>q :<C-U>TpbDelete<CR>
  NXnoremap <Leader>Q :<C-U>TpbDeleteAll<CR>

  if !empty(dein#get('ctrlp'))
    NXnoremap <Leader>b :<C-U>CtrlPTabpageBuffer<CR>
  endif

  call extend(s:altercmd_define, {
  \ 'bmn[ext]'      : 'TpbModifiedNext',
  \ 'bmN[ext]'      : 'TpbModifiedPrevious',
  \ 'bmp[revious]'  : 'TpbModifiedPrevious',
  \ 'sbmn[ext]'     : 'STpbModifiedNext',
  \ 'sbmN[ext]'     : 'STpbModifiedPrevious',
  \ 'sbmp[revious]' : 'STpbModifiedPrevious',
  \ 'vbmn[ext]'     : 'VTpbModifiedNext',
  \ 'vbmN[ext]'     : 'VTpbModifiedPrevious',
  \ 'vbmp[revious]' : 'VTpbModifiedPrevious',
  \ 'bmr[ewind]'    : 'TpbModifiedRewind',
  \ 'bmf[irst]'     : 'TpbModifiedFirst',
  \ 'bml[ast]'      : 'TpbModifiedLast',
  \ 'sbmr[ewind]'   : 'STpbModifiedRewind',
  \ 'sbmf[irst]'    : 'STpbModifiedFirst',
  \ 'sbml[ast]'     : 'STpbModifiedLast',
  \ 'vbmr[ewind]'   : 'VTpbModifiedRewind',
  \ 'vbmf[irst]'    : 'VTpbModifiedFirst',
  \ 'vbml[ast]'     : 'VTpbModifiedLast',
  \
  \ 'vb[uffer]'    : 'VTpbBuffer',
  \ 'tb[uffer]'    : 'TTpbBuffer',
  \ 'vbn[ext]'     : 'VTpbNext',
  \ 'vbN[ext]'     : 'VTpbPrevious',
  \ 'vbp[revious]' : 'VTpbPrevious',
  \ 'vbm[odified]' : 'VTpbModified',
  \ 'tbn[ext]'     : 'TTpbNext',
  \ 'tbN[ext]'     : 'TTpbPrevious',
  \ 'tbp[revious]' : 'TTpbPrevious',
  \ 'tbm[odified]' : 'TTpbModified',
  \ 'vbr[ewind]'   : 'VTpbRewind',
  \ 'vbf[irst]'    : 'VTpbFirst',
  \ 'vbl[ast]'     : 'VTpbLast',
  \ 'tbr[ewind]'   : 'TTpbRewind',
  \ 'tbf[irst]'    : 'TTpbFirst',
  \ 'tbl[ast]'     : 'TTpbLast',
  \ 'vunh[ide]'    : 'VTpbUnhide',
  \ 'vba[ll]'      : 'VTpbAll',
  \ 'tunh[ide]'    : 'TTpbUnhide',
  \ 'tba[ll]'      : 'TTpbAll',
  \
  \ '_vb[uffer]'    : 'vertical sbuffer',
  \ '_tb[uffer]'    : 'tab sbuffer',
  \ '_vbn[ext]'     : 'vertical sbnext',
  \ '_vbN[ext]'     : 'vertical sbNext',
  \ '_vbp[revious]' : 'vertical sbprevious',
  \ '_vbm[odified]' : 'vertical sbmodified',
  \ '_tbn[ext]'     : 'tab sbnext',
  \ '_tbN[ext]'     : 'tab sbNext',
  \ '_tbp[revious]' : 'tab sbprevious',
  \ '_tbm[odified]' : 'tab sbmodified',
  \ '_vbr[ewind]'   : 'vertical sbrewind',
  \ '_vbf[irst]'    : 'vertical sbfirst',
  \ '_vbl[ast]'     : 'vertical sblast',
  \ '_tbr[ewind]'   : 'tab sbrewind',
  \ '_tbf[irst]'    : 'tab sbfirst',
  \ '_tbl[ast]'     : 'tab sblast',
  \ '_vunh[ide]'    : 'vertical unhide',
  \ '_vba[ll]'      : 'vertical all',
  \ '_tunh[ide]'    : 'tab unhide',
  \ '_tba[ll]'      : 'tab ball',
  \
  \ 'files'        : 'TpbFiles',
  \ 'buffers'      : 'TpbBuffers',
  \ 'ls'           : 'TpbLs',
  \ 'bd[elete]'    : 'TpbDelete',
  \ 'bw[ipeout]'   : 'TpbWipeout',
  \ 'bun[load]'    : 'TpbUnload',
  \ 'b[uffer]'     : 'TpbBuffer',
  \ 'sb[uffer]'    : 'STpbBuffer',
  \ 'bn[ext]'      : 'TpbNext',
  \ 'bN[ext]'      : 'TpbPrevious',
  \ 'bp[revious]'  : 'TpbPrevious',
  \ 'bm[odified]'  : 'TpbModified',
  \ 'sbn[ext]'     : 'STpbNext',
  \ 'sbN[ext]'     : 'STpbPrevious',
  \ 'sbp[revious]' : 'STpbPrevious',
  \ 'sbm[odified]' : 'STpbModified',
  \ 'br[ewind]'    : 'TpbRewind',
  \ 'bf[irst]'     : 'TpbFirst',
  \ 'bl[ast]'      : 'TpbLast',
  \ 'sbr[ewind]'   : 'STpbRewind',
  \ 'sbf[irst]'    : 'STpbFirst',
  \ 'sbl[ast]'     : 'STpbLast',
  \ 'unh[ide]'     : 'TpbUnhide',
  \ 'sun[hide]'    : 'STpbUnhide',
  \ 'ba[ll]'       : 'TpbAll',
  \ 'sba[ll]'      : 'STpbBall',
  \
  \ '_files'        : 'files',
  \ '_buffers'      : 'buffers',
  \ '_ls'           : 'ls',
  \ '_bd[elete]'    : 'bdelete',
  \ '_bw[ipeout]'   : 'bwipeout',
  \ '_bun[load]'    : 'bunload',
  \ '_b[uffer]'     : 'buffer',
  \ '_sb[uffer]'    : 'sbuffer',
  \ '_bn[ext]'      : 'bnext',
  \ '_bN[ext]'      : 'bNext',
  \ '_bp[revious]'  : 'bprevious',
  \ '_bm[odified]'  : 'bmodified',
  \ '_sbn[ext]'     : 'sbnext',
  \ '_sbN[ext]'     : 'sbNext',
  \ '_sbp[revious]' : 'sbprevious',
  \ '_sbm[odified]' : 'sbmodified',
  \ '_br[ewind]'    : 'brewind',
  \ '_bf[irst]'     : 'bfirst',
  \ '_bl[ast]'      : 'blast',
  \ '_sbr[ewind]'   : 'sbrewind',
  \ '_sbf[irst]'    : 'sbfirst',
  \ '_sbl[ast]'     : 'sblast',
  \ '_unh[ide]'     : 'unhide',
  \ '_sun[hide]'    : 'sunhide',
  \ '_ba[ll]'       : 'ball',
  \ '_sba[ll]'      : 'sball'})
endif
" }}}

"------------------------------------------------------------------------------
" Tern: {{{
if s:dein_tap('tern')
  call extend(s:neocomplete_force_omni_patterns, {
  \ 'tern#Complete' : '\.\h\w*'})
endif
" }}}

"------------------------------------------------------------------------------
" TextManipilate: {{{
if s:dein_tap('textmanip')
  function! g:dein#plugin.hook_source() abort
    call operator#user#define(
    \ 'textmanip-duplicate-down',
    \ 'myvimrc#operator_textmanip_duplicate_down')
    call operator#user#define(
    \ 'textmanip-duplicate-up',
    \ 'myvimrc#operator_textmanip_duplicate_up')
    call operator#user#define(
    \ 'textmanip-move-left',
    \ 'myvimrc#operator_textmanip_move_left')
    call operator#user#define(
    \ 'textmanip-move-right',
    \ 'myvimrc#operator_textmanip_move_right')
    call operator#user#define(
    \ 'textmanip-move-down',
    \ 'myvimrc#operator_textmanip_move_down')
    call operator#user#define(
    \ 'textmanip-move-up',
    \ 'myvimrc#operator_textmanip_move_up')

    call submode#enter_with(
    \ 'tm/dup', 'x', 'r', '<Plug>(submode:tm/dup:j)',
    \ '<Plug>(textmanip-duplicate-down)')
    call submode#enter_with(
    \ 'tm/dup', 'x', 'r', '<Plug>(submode:tm/dup:k)',
    \ '<Plug>(textmanip-duplicate-up)')
    call submode#map(
    \ 'tm/dup', 'x', 'r', '<Down>',
    \ '<Plug>(textmanip-duplicate-down)')
    call submode#map(
    \ 'tm/dup', 'x', 'r', '<Up>',
    \ '<Plug>(textmanip-duplicate-up)')
    call submode#map(
    \ 'tm/dup', 'x', 'r', 'j',
    \ '<Plug>(textmanip-duplicate-down)')
    call submode#map(
    \ 'tm/dup', 'x', 'r', 'k',
    \ '<Plug>(textmanip-duplicate-up)')

    call submode#enter_with(
    \ 'tm/move', 'x', 'r', '<Plug>(submode:tm/move:j)',
    \ '<Plug>(textmanip-move-down)')
    call submode#enter_with(
    \ 'tm/move', 'x', 'r', '<Plug>(submode:tm/move:k)',
    \ '<Plug>(textmanip-move-up)')
    call submode#enter_with(
    \ 'tm/move', 'x', 'r', '<Plug>(submode:tm/move:h)',
    \ '<Plug>(textmanip-move-left)')
    call submode#enter_with(
    \ 'tm/move', 'x', 'r', '<Plug>(submode:tm/move:l)',
    \ '<Plug>(textmanip-move-right)')
    call submode#map(
    \ 'tm/move', 'x', 'r', '<Down>',
    \ '<Plug>(textmanip-move-down)')
    call submode#map(
    \ 'tm/move', 'x', 'r', '<Up>',
    \ '<Plug>(textmanip-move-up)')
    call submode#map(
    \ 'tm/move', 'x', 'r', '<Left>',
    \ '<Plug>(textmanip-move-left)')
    call submode#map(
    \ 'tm/move', 'x', 'r', '<Right>',
    \ '<Plug>(textmanip-move-right)')
    call submode#map(
    \ 'tm/move', 'x', 'r', 'j',
    \ '<Plug>(textmanip-move-down)')
    call submode#map(
    \ 'tm/move', 'x', 'r', 'k',
    \ '<Plug>(textmanip-move-up)')
    call submode#map(
    \ 'tm/move', 'x', 'r', 'h',
    \ '<Plug>(textmanip-move-left)')
    call submode#map(
    \ 'tm/move', 'x', 'r', 'l',
    \ '<Plug>(textmanip-move-right)')
  endfunction

  NOXmap <M-p> <Plug>(textmanip-duplicate-down)
  NOXmap <M-P> <Plug>(textmanip-duplicate-up)

  NOmap s<Down>  <Plug>(operator-textmanip-move-down)
  NOmap s<Up>    <Plug>(operator-textmanip-move-up)
  NOmap s<Left>  <Plug>(operator-textmanip-move-left)
  NOmap s<Right> <Plug>(operator-textmanip-move-right)
  NOmap sj       <Plug>(operator-textmanip-move-down)
  NOmap sk       <Plug>(operator-textmanip-move-up)
  NOmap sh       <Plug>(operator-textmanip-move-left)
  NOmap sl       <Plug>(operator-textmanip-move-right)

  xmap s<Down>  <Plug>(submode:tm/move:j)
  xmap s<Up>    <Plug>(submode:tm/move:k)
  xmap s<Left>  <Plug>(submode:tm/move:h)
  xmap s<Right> <Plug>(submode:tm/move:l)
  xmap sj       <Plug>(submode:tm/move:j)
  xmap sk       <Plug>(submode:tm/move:k)
  xmap sh       <Plug>(submode:tm/move:h)
  xmap sl       <Plug>(submode:tm/move:l)

  " nmap s<Down><Down>   s<Down>s<Down>
  " nmap s<Up><Up>       s<Up>s<Up>
  " nmap s<Left><Left>   s<Left>s<Left>
  " nmap s<Right><Right> s<Right>s<Right>
  " nmap sjj             sjsj
  " nmap skk             sksk
  " nmap shh             shsh
  " nmap sll             slsl
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Between: {{{
if s:dein_tap('textobj-between')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_between_no_default_key_mappings = 1
  endfunction

  OXmap af <Plug>(textobj-between-a)
  OXmap if <Plug>(textobj-between-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Comment: {{{
if s:dein_tap('textobj-comment')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  OXmap ac <Plug>(textobj-comment-a)
  OXmap ic <Plug>(textobj-comment-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Continuous Line: {{{
if s:dein_tap('textobj-continuous-line')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_continuous_line_no_default_key_mappings = 1
    let g:textobj_continuous_line_no_default_mappings     = 1
  endfunction

  " OXmap a<Bslash> <Plug>(textobj-continuous-cpp-a)
  " OXmap a<Bslash> <Plug>(textobj-continuous-python-a)
  " OXmap a<Bslash> <Plug>(textobj-continuous-vim-a)
  " OXmap i<Bslash> <Plug>(textobj-continuous-cpp-i)
  " OXmap i<Bslash> <Plug>(textobj-continuous-python-i)
  " OXmap i<Bslash> <Plug>(textobj-continuous-vim-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj DateTime: {{{
if s:dein_tap('textobj-datetime')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_datetime_no_default_key_mappings = 1
  endfunction

  OXnoremap ad <Nop>
  OXmap ada <Plug>(textobj-datetime-auto)
  OXmap add <Plug>(textobj-datetime-date)
  OXmap adD <Plug>(textobj-datetime-full)
  OXmap adt <Plug>(textobj-datetime-time)
  OXmap adT <Plug>(textobj-datetime-tz)

  OXnoremap id <Nop>
  OXmap ida <Plug>(textobj-datetime-auto)
  OXmap idd <Plug>(textobj-datetime-date)
  OXmap idD <Plug>(textobj-datetime-full)
  OXmap idt <Plug>(textobj-datetime-time)
  OXmap idT <Plug>(textobj-datetime-tz)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Diff: {{{
if s:dein_tap('textobj-diff')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_diff_no_default_key_mappings = 1
  endfunction

  " NOXmap [c <Plug>(textobj-diff-hunk-p)
  " NOXmap ]c <Plug>(textobj-diff-hunk-n)
  " NOXmap [C <Plug>(textobj-diff-hunk-P)
  " NOXmap ]C <Plug>(textobj-diff-hunk-N)
  "
  " NOXmap [<M-c> <Plug>(textobj-diff-file-p)
  " NOXmap ]<M-c> <Plug>(textobj-diff-file-n)
  " NOXmap [<M-C> <Plug>(textobj-diff-file-P)
  " NOXmap ]<M-C> <Plug>(textobj-diff-file-N)
  "
  " OXnoremap ad <Nop>
  " OXmap adh <Plug>(textobj-diff-hunk)
  " OXmap adf <Plug>(textobj-diff-file)
  "
  " OXnoremap id <Nop>
  " OXmap idh <Plug>(textobj-diff-hunk)
  " OXmap idf <Plug>(textobj-diff-file)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Entrie: {{{
if s:dein_tap('textobj-entire')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  OXmap ae <Plug>(textobj-entire-a)
  OXmap ie <Plug>(textobj-entire-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj EnclosedSyntax: {{{
if s:dein_tap('textobj-enclosedsyntax')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_enclosedsyntax_no_default_key_mappings = 1
  endfunction

  " OXmap aq <Plug>(textobj-enclosedsyntax-a)
  " OXmap iq <Plug>(textobj-enclosedsyntax-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Fold: {{{
if s:dein_tap('textobj-fold')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_fold_no_default_key_mappings = 1
  endfunction

  OXmap az <Plug>(textobj-fold-a)
  OXmap iz <Plug>(textobj-fold-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Function: {{{
if s:dein_tap('textobj-function')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_function_no_default_key_mappings = 1
  endfunction

  " OXmap aF <Plug>(textobj-function-a)
  " OXmap iF <Plug>(textobj-function-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Ifdef: {{{
if s:dein_tap('textobj-ifdef')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction

  " OXmap a# <Plug>(textobj-ifdef-a)
  " OXmap i# <Plug>(textobj-ifdef-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj IndentBlock: {{{
if s:dein_tap('textobj-indblock')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_indblock_no_default_key_mappings = 1
  endfunction

  OXmap ao <Plug>(textobj-indblock-a)
  OXmap io <Plug>(textobj-indblock-i)
  OXmap aO <Plug>(textobj-indblock-same-a)
  OXmap iO <Plug>(textobj-indblock-same-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Indent: {{{
if s:dein_tap('textobj-indent')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_indent_no_default_key_mappings = 1
  endfunction

  OXmap ai <Plug>(textobj-indent-a)
  OXmap ii <Plug>(textobj-indent-i)
  OXmap aI <Plug>(textobj-indent-same-a)
  OXmap iI <Plug>(textobj-indent-same-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj JaBraces: {{{
if s:dein_tap('textobj-jabraces')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_jabraces_no_default_key_mappings = 1
  endfunction

  OXnoremap aj <Nop>
  OXmap aj( <Plug>(textobj-jabraces-parens-a)
  OXmap aj) <Plug>(textobj-jabraces-parens-a)
  OXmap aj{ <Plug>(textobj-jabraces-braces-a)
  OXmap aj} <Plug>(textobj-jabraces-braces-a)
  OXmap aj[ <Plug>(textobj-jabraces-brackets-a)
  OXmap aj] <Plug>(textobj-jabraces-brackets-a)
  OXmap aj< <Plug>(textobj-jabraces-angles-a)
  OXmap aj> <Plug>(textobj-jabraces-angles-a)
  OXmap aja <Plug>(textobj-jabraces-angles-a)
  OXmap ajA <Plug>(textobj-jabraces-double-angles-a)
  OXmap ajk <Plug>(textobj-jabraces-kakko-a)
  OXmap ajK <Plug>(textobj-jabraces-double-kakko-a)
  OXmap ajy <Plug>(textobj-jabraces-yama-kakko-a)
  OXmap ajY <Plug>(textobj-jabraces-double-yama-kakko-a)
  OXmap ajt <Plug>(textobj-jabraces-kikkou-kakko-a)
  OXmap ajs <Plug>(textobj-jabraces-sumi-kakko-a)

  OXnoremap ij <Nop>
  OXmap ij( <Plug>(textobj-jabraces-parens-i)
  OXmap ij) <Plug>(textobj-jabraces-parens-i)
  OXmap ij{ <Plug>(textobj-jabraces-braces-i)
  OXmap ij} <Plug>(textobj-jabraces-braces-i)
  OXmap ij[ <Plug>(textobj-jabraces-brackets-i)
  OXmap ij] <Plug>(textobj-jabraces-brackets-i)
  OXmap ij< <Plug>(textobj-jabraces-angles-i)
  OXmap ij> <Plug>(textobj-jabraces-angles-i)
  OXmap ija <Plug>(textobj-jabraces-angles-i)
  OXmap ijA <Plug>(textobj-jabraces-double-angles-i)
  OXmap ijk <Plug>(textobj-jabraces-kakko-i)
  OXmap ijK <Plug>(textobj-jabraces-double-kakko-i)
  OXmap ijy <Plug>(textobj-jabraces-yama-kakko-i)
  OXmap ijY <Plug>(textobj-jabraces-double-yama-kakko-i)
  OXmap ijt <Plug>(textobj-jabraces-kikkou-kakko-i)
  OXmap ijs <Plug>(textobj-jabraces-sumi-kakko-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Line: {{{
if s:dein_tap('textobj-line')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  OXmap al <Plug>(textobj-line-a)
  OXmap il <Plug>(textobj-line-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj MultiBlock: {{{
if s:dein_tap('textobj-multiblock')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_multiblock_no_default_key_mappings = 1
  endfunction

  OXmap ab <Plug>(textobj-multiblock-a)
  OXmap ib <Plug>(textobj-multiblock-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj MultiTextObj: {{{
if s:dein_tap('textobj-multitextobj')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_multitextobj_textobjects_group_a = {
    \ 'doublequotes' : [
    \   {'textobj' : 'a"',  'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'singlequotes' : [
    \   {'textobj' : "a'", 'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'backquotes' : [
    \   {'textobj' : 'a`',  'is_cursor_in' : 1, 'noremap' : 1}]}
    let g:textobj_multitextobj_textobjects_group_i = {
    \ 'doublequotes' : [
    \   {'textobj' : 'i"',  'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'singlequotes' : [
    \   {'textobj' : "i'", 'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'backquotes' : [
    \   {'textobj' : 'i`',  'is_cursor_in' : 1, 'noremap' : 1}]}

    if !empty(dein#get('textobj-jabraces'))
      call extend(g:textobj_multitextobj_textobjects_group_a, {
      \ 'jabraces' : [
      \   ["\<Plug>(textobj-jabraces-parens-a)",
      \    "\<Plug>(textobj-jabraces-braces-a)",
      \    "\<Plug>(textobj-jabraces-brackets-a)",
      \    "\<Plug>(textobj-jabraces-angles-a)",
      \    "\<Plug>(textobj-jabraces-double-angles-a)",
      \    "\<Plug>(textobj-jabraces-kakko-a)",
      \    "\<Plug>(textobj-jabraces-double-kakko-a)",
      \    "\<Plug>(textobj-jabraces-yama-kakko-a)",
      \    "\<Plug>(textobj-jabraces-double-yama-kakko-a)",
      \    "\<Plug>(textobj-jabraces-kikkou-kakko-a)",
      \    "\<Plug>(textobj-jabraces-sumi-kakko-a)"]]})
      call extend(g:textobj_multitextobj_textobjects_group_i, {
      \ 'jabraces' : [
      \   ["\<Plug>(textobj-jabraces-parens-i)",
      \    "\<Plug>(textobj-jabraces-braces-i)",
      \    "\<Plug>(textobj-jabraces-brackets-i)",
      \    "\<Plug>(textobj-jabraces-angles-i)",
      \    "\<Plug>(textobj-jabraces-double-angles-i)",
      \    "\<Plug>(textobj-jabraces-kakko-i)",
      \    "\<Plug>(textobj-jabraces-double-kakko-i)",
      \    "\<Plug>(textobj-jabraces-yama-kakko-i)",
      \    "\<Plug>(textobj-jabraces-double-yama-kakko-i)",
      \    "\<Plug>(textobj-jabraces-kikkou-kakko-i)",
      \    "\<Plug>(textobj-jabraces-sumi-kakko-i)"]]})
    endif
  endfunction

  OXmap <expr> a" textobj#multitextobj#mapexpr_a('doublequotes')
  OXmap <expr> i" textobj#multitextobj#mapexpr_i('doublequotes')
  OXmap <expr> a' textobj#multitextobj#mapexpr_a('singlequotes')
  OXmap <expr> i' textobj#multitextobj#mapexpr_i('singlequotes')
  OXmap <expr> a` textobj#multitextobj#mapexpr_a('backquotes')
  OXmap <expr> i` textobj#multitextobj#mapexpr_i('backquotes')

  if !empty(dein#get('textobj-jabraces'))
    OXmap <expr> aB textobj#multitextobj#mapexpr_a('jabraces')
    OXmap <expr> iB textobj#multitextobj#mapexpr_i('jabraces')
  endif
endif
" }}}

"------------------------------------------------------------------------------
" TextObj MethodCall: {{{
if s:dein_tap('textobj-methodcall')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_methodcall_no_default_key_mappings = 1
  endfunction

  OXmap am <Plug>(textobj-methodcall-a)
  OXmap aM <Plug>(textobj-methodcall-chain-a)
  OXmap im <Plug>(textobj-methodcall-i)
  OXmap iM <Plug>(textobj-methodcall-chain-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Parameter: {{{
if s:dein_tap('textobj-parameter')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  OXmap a, <Plug>(textobj-parameter-a)
  OXmap i, <Plug>(textobj-parameter-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj PHP: {{{
if s:dein_tap('textobj-php')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_php_no_default_key_mappings = 1
  endfunction

  " OXmap aP <Plug>(textobj-php-phptag-a)
  " OXmap aa <Plug>(textobj-php-phparray-a)
  " OXmap iP <Plug>(textobj-php-phptag-i)
  " OXmap ia <Plug>(textobj-php-phparray-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj PostExpr: {{{
if s:dein_tap('textobj-postexpr')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_postexpr_no_default_key_mappings = 1
  endfunction

  OXmap ax <Plug>(textobj-postexpr-a)
  OXmap ix <Plug>(textobj-postexpr-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Python: {{{
if s:dein_tap('textobj-python')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_python_no_default_key_mappings = 1
  endfunction

  " OXmap aF <Plug>(textobj-python-function-a)
  " OXmap aC <Plug>(textobj-python-class-a)
  " OXmap iF <Plug>(textobj-python-function-i)
  " OXmap iC <Plug>(textobj-python-class-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Ruby: {{{
if s:dein_tap('textobj-ruby')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_ruby_no_default_key_mappings = 1
    let g:textobj_ruby_more_mappings           = 1
  endfunction

  " OXmap ar  <Nop>
  " OXmap arr <Plug>(textobj-ruby-any-a)
  " OXmap aro <Plug>(textobj-ruby-definition-a)
  " OXmap arl <Plug>(textobj-ruby-loop-a)
  " OXmap arc <Plug>(textobj-ruby-control-a)
  " OXmap ard <Plug>(textobj-ruby-do-a)
  "
  " OXmap ir  <Nop>
  " OXmap irr <Plug>(textobj-ruby-any-i)
  " OXmap iro <Plug>(textobj-ruby-definition-i)
  " OXmap irl <Plug>(textobj-ruby-loop-i)
  " OXmap irc <Plug>(textobj-ruby-control-i)
  " OXmap ird <Plug>(textobj-ruby-do-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Sigil: {{{
if s:dein_tap('textobj-sigil')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction

  " OXmap ag <Plug>(textobj-sigil-a)
  " OXmap ig <Plug>(textobj-sigil-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Space: {{{
if s:dein_tap('textobj-space')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_space_no_default_key_mappings = 1
  endfunction

  OXmap a<Space> <Plug>(textobj-space-a)
  OXmap i<Space> <Plug>(textobj-space-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Syntax: {{{
if s:dein_tap('textobj-syntax')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  OXmap ay <Plug>(textobj-syntax-a)
  OXmap iy <Plug>(textobj-syntax-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Url: {{{
if s:dein_tap('textobj-url')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  OXmap au <Plug>(textobj-url-a)
  OXmap iu <Plug>(textobj-url-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj WordInWord: {{{
if s:dein_tap('textobj-wiw')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_wiw_no_default_key_mappings = 1
  endfunction

  NOXmap <M-w>      <Plug>(textobj-wiw-n)
  NOXmap <M-b>      <Plug>(textobj-wiw-p)
  NOXmap <M-e>      <Plug>(textobj-wiw-N)
  NOXmap <M-g><M-e> <Plug>(textobj-wiw-P)

  OXmap a<M-w> <Plug>(textobj-wiw-a)
  OXmap i<M-w> <Plug>(textobj-wiw-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj Word Column: {{{
if s:dein_tap('textobj-word-column')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_wordcolumn_no_default_key_mappings = 1
  endfunction

  OXmap av <Plug>(textobj-wordcolumn-w-a)
  OXmap aV <Plug>(textobj-wordcolumn-W-a)
  OXmap iv <Plug>(textobj-wordcolumn-w-i)
  OXmap iV <Plug>(textobj-wordcolumn-W-i)
endif
" }}}

"------------------------------------------------------------------------------
" TextObj XML Attribute: {{{
if s:dein_tap('textobj-xml-attribute')
  function! g:dein#plugin.hook_source() abort
    let g:textobj_xmlattribute_no_default_key_mappings = 1
  endfunction

  " OXmap aa <Plug>(textobj-xmlattribute-xmlattribute)
  " OXmap ia <Plug>(textobj-xmlattribute-xmlattributenospace)
endif
" }}}

"------------------------------------------------------------------------------
" UndoTree: {{{
if s:dein_tap('undotree')
  function! g:dein#plugin.hook_source() abort
    let g:undotree_SetFocusWhenToggle = 1
  endfunction

  NXnoremap <Leader>u :<C-U>UndotreeToggle<CR>
endif
" }}}

"------------------------------------------------------------------------------
" Unified Diff: {{{
if s:dein_tap('unified-diff')
  set diffexpr=unified_diff#diffexpr()

  if has('vim_starting') && &diff
    call dein#source(dein#name)
  endif
endif
" }}}

"------------------------------------------------------------------------------
" VimConsole: {{{
if s:dein_tap('vimconsole')
  call extend(s:neocomplete_vim_completefuncs, {
  \ 'VimConsoleLog'   : 'expression',
  \ 'VimConsoleWarn'  : 'expression',
  \ 'VimConsoleError' : 'expression'})
endif
" }}}

"------------------------------------------------------------------------------
" Vimhelp Lint: {{{
if s:dein_tap('vimhelplint')
  function! g:dein#plugin.hook_source() abort
    call myvimrc#extend_quickrun_config('help/watchdogs_checker', {
    \ 'type' : ''})
    " \ 'type': 'watchdogs_checker/vimhelplint'})
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" Vim Lint: {{{
if s:dein_tap('vimlint')
  function! g:dein#plugin.hook_source() abort
    call myvimrc#extend_quickrun_config('vim/watchdogs_checker', {
    \ 'type' : ''})
    " \ 'type' : 'watchdogs_checker/vimlint'})
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" VimProc: {{{
if s:dein_tap('vimproc')
  function! g:dein#plugin.hook_source() abort
    let g:vimproc#download_windows_dll = 1
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" VisualStar: {{{
if s:dein_tap('visualstar')
  function! g:dein#plugin.hook_source() abort
    let g:visualstar_no_default_key_mappings = 1
  endfunction

  if !empty(dein#get('anzu'))
    xmap <SID>(visualstar-*)  <Plug>(visualstar-*)<SID>(anzu-echo)
    xmap <SID>(visualstar-#)  <Plug>(visualstar-#)<SID>(anzu-echo)
    xmap <SID>(visualstar-g*) <Plug>(visualstar-g*)<SID>(anzu-echo)
    xmap <SID>(visualstar-g#) <Plug>(visualstar-g#)<SID>(anzu-echo)
  else
    xmap <SID>(visualstar-*)  <Plug>(visualstar-*)
    xmap <SID>(visualstar-#)  <Plug>(visualstar-#)
    xmap <SID>(visualstar-g*) <Plug>(visualstar-g*)
    xmap <SID>(visualstar-g#) <Plug>(visualstar-g#)
  endif

  xnoremap <script> <SID>*  <SID>(visualstar-*)zv
  xnoremap <script> <SID>#  <SID>(visualstar-#)zv
  xnoremap <script> <SID>g* <SID>(visualstar-g*)zv
  xnoremap <script> <SID>g# <SID>(visualstar-g#)zv
endif
" }}}

"------------------------------------------------------------------------------
" VisualStudio: {{{
if s:dein_tap('visualstudio')
  function! g:dein#plugin.hook_source() abort
    let g:visualstudio_controllerpath =
    \ dein#get('VisualStudioController').path .
    \ '/bin/VisualStudioController.exe'
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" VBNet: {{{
if s:dein_tap('vbnet')
  function! g:dein#plugin.hook_source() abort
    unlet! g:vbnet_no_code_folds
  endfunction
endif
" }}}

"------------------------------------------------------------------------------
" WatchDogs: {{{
if s:dein_tap('watchdogs')
  function! g:dein#plugin.hook_source() abort
    let g:watchdogs_check_BufWritePost_enable = 1

    call myvimrc#extend_quickrun_config('watchdogs_checker/_', {
    \ 'runner' : s:has_vimproc() ? 'vimproc' : 'system',
    \ 'outputter' : 'quickfix'})

    call myvimrc#extend_quickrun_config('c/watchdogs_checker', {
    \ 'type' :
    \   s:executable('clang') ? 'watchdogs_checker/clang' :
    \   s:executable('gcc')   ? 'watchdogs_checker/gcc' :
    \   exists('$VCVARSALL')  ? 'watchdogs_checker/msvc' :
    \   s:executable('cl')    ? 'watchdogs_checker/msvc' : ''})

    call myvimrc#extend_quickrun_config('cpp/watchdogs_checker', {
    \ 'type' :
    \   s:executable('clang-check') ? 'watchdogs_checker/clang_check' :
    \   s:executable('clang++')     ? 'watchdogs_checker/clang++' :
    \   s:executable('g++')         ? 'watchdogs_checker/g++' :
    \   exists('$VCVARSALL')        ? 'watchdogs_checker/msvc' :
    \   s:executable('cl')          ? 'watchdogs_checker/msvc' : ''})

    call myvimrc#extend_quickrun_config('lua/watchdogs_checker', {
    \ 'type' :
    \   s:executable('luajit') ? 'watchdogs_checker/luajit' :
    \   s:executable('luac53') ? 'watchdogs_checker/luac53' :
    \   s:executable('luac')   ? 'watchdogs_checker/luac' : ''})

    call myvimrc#extend_quickrun_config('watchdogs_checker/luajit', {
    \ 'command' : 'luajit',
    \ 'exec' : '%c %o -bl %s:p',
    \ 'errorformat' : '%.%#: %#%f:%l: %m'})

    call myvimrc#extend_quickrun_config('watchdogs_checker/luac53', {
    \ 'command' : 'luac53',
    \ 'exec' : '%c %o -p %s:p',
    \ 'errorformat' : '%.%#: %#%f:%l: %m'})

    if has('win32')
      call myvimrc#extend_quickrun_config('watchdogs_checker/msvc', {
      \ 'hook/output_encode/encoding' : 'cp932'})
    endif

    call watchdogs#setup(g:quickrun_config)
  endfunction

  call extend(s:neocomplete_vim_completefuncs, {
  \ 'WatchdogsRun'       : 'quickrun#complete',
  \ 'WatchdogsRunSilent' : 'quickrun#complete'})
endif
" }}}

"------------------------------------------------------------------------------
" YankRound: {{{
if s:dein_tap('yankround')
  function! g:dein#plugin.hook_source() abort
    let g:yankround_dir           = $XDG_CACHE_HOME . '/yankround'
    let g:yankround_max_history   = 100
    let g:yankround_use_region_hl = 1
  endfunction

  cnoremap <SID><C-N> <C-N>
  cnoremap <SID><C-P> <C-P>

  NXmap p    <Plug>(yankround-p)
  NXmap P    <Plug>(yankround-P)
  NXmap gp   <Plug>(yankround-gp)
  NXmap gP   <Plug>(yankround-gP)
  nmap <C-N> <Plug>(yankround-next)
  nmap <C-P> <Plug>(yankround-prev)
  cmap <C-R> <Plug>(yankround-insert-register)
  cmap <expr> <C-N>
  \ yankround#is_cmdline_popable() ?
  \   '<Plug>(yankround-pop)' : '<SID><C-N>'
  cmap <expr> <C-P>
  \ yankround#is_cmdline_popable() ?
  \   '<Plug>(yankround-backpop)' : '<SID><C-P>'

  nnoremap <Leader>p :<C-U>CtrlPYankRound<CR>
  xnoremap <Leader>p d:<C-U>CtrlPYankRound<CR>

  autocmd MyVimrc User EscapeKey
  \ call myvimrc#yankround_escape()
endif
" }}}
" }}}

"==============================================================================
" Post Init: {{{
" Local vimrc
if filereadable($HOME . '/.vimrc_local.vim')
  source ~/.vimrc_local.vim
elseif filereadable($HOME . '/.vim/vimrc_local.vim')
  source ~/.vim/vimrc_local.vim
endif

" Enable plugin
filetype plugin indent on

" Syntax highlight
syntax enable

" ColorScheme
if !exists('g:colors_name') && !has('gui_running') && s:is_colored_ui
  try
    colorscheme molokai
  catch /.*/
    colorscheme desert
  endtry
endif
" }}}
