scriptencoding utf-8
" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  14-Oct-2015.
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

"==============================================================================
" Pre Init: {{{
" Skip vim-tiny, vim-small, below vim-7.2
if v:version < 703 | finish | endif

" Be iMproved
if &compatible
  set nocompatible
endif

" Encoding
if has('multi_byte')
  set encoding=utf-8
  if &term == 'win32' && !has('gui_running')
    set termencoding=cp932
  endif
  scriptencoding utf-8
endif

if has('win32')
  " Language
  language japanese
  language time C

  " Shell
  " set shell=sh
  " set shellslash

  " Unix like runtime
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
endif

" Local runtime
set runtimepath^=~/.local/.vim
set runtimepath+=~/.local/.vim/after

" Singleton
if isdirectory($HOME . '/.local/bundle/singleton')
  set runtimepath+=~/.local/bundle/singleton
  let g:singleton#opener = 'drop'
  call singleton#enable()
endif

"------------------------------------------------------------------------------
" Variable: {{{
" Command line window
let s:cmdwin_ex_enable     = 0
let s:cmdwin_search_enable = 0

" Ignore pattern
let s:ignore_dir = [
\ '.git', '.hg', '.bzr', '.svn', '.drive.r', 'temp', 'tmp']
let s:ignore_ext = [
\ 'o', 'obj', 'a', 'lib', 'so', 'dll', 'dylib', 'exe', 'bin',
\ 'swp', 'swo', 'lc', 'elc', 'fas', 'pyc', 'pyo', 'luac', 'zwc']
let s:ignore_ft = [
\ 'gitcommit', 'gitrebase', 'hgcommit', 'unite']

"------------------------------------------------------------------------------
" Common: {{{
" Vimrc autocmd group
augroup MyVimrc
  autocmd!
augroup END

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
  return
  \ exists('*neobundle#get') && !get(neobundle#get(a:name), 'disabled', 1) &&
  \ exists('*neobundle#is_installed') && neobundle#is_installed(a:name)
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
    let s:programfiles_x86 = exists('$PROGRAMFILES(X86)') ?
    \ $PROGRAMFILES(X86) : $PROGRAMFILES
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
set viminfo+=n~/.local/.viminfo
set history=10000

" Backup
set nobackup
set swapfile
set undofile
set undodir^=~/.local/.vimundo
autocmd MyVimrc FileType *
\ let &l:undofile = index(s:ignore_ft, expand('<amatch>')) < 0

" ClipBoard
set clipboard=unnamed
if has('unnamedplus')
  set clipboard^=unnamedplus
endif

" Timeout
set timeout
set timeoutlen=3000
set ttimeoutlen=10
set updatetime=1000

" Hidden buffer
set hidden

" Multi byte charactor width
set ambiwidth=double

" Wild menu
set wildmenu
execute 'set wildignore+=' .
\ join(s:ignore_dir +
\   map(copy(s:ignore_ext), '"*." . escape(v:val, " ,\\")'), ',')

" Mouse
set mouse=a
set nomousefocus
set nomousehide

" Help
if s:is_lang_ja
  set helplang^=ja
endif
"}}}

"------------------------------------------------------------------------------
" Display: {{{
" Don't redraw which macro executing
set lazyredraw

" Line number, Ruler, Wrap
set number
set relativenumber
set ruler
set wrap
set display=lastline
set scrolloff=5

" Match
set showmatch
set matchtime=1

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
if has('conceal')
  set conceallevel=2
  set concealcursor=nc
endif
"}}}

"------------------------------------------------------------------------------
" Search: {{{
" Options
set ignorecase
set smartcase
set incsearch
set wrapscan

" Highlight
if s:is_colored
  set hlsearch
endif

" Grep
if s:executable('jvgrep')
  set grepprg=jvgrep\ -nI
elseif s:executable('grep')
  set grepprg=grep\ -nHI
" elseif has('win32') && s:executable('findstr')
"   set grepprg=findstr\ /n\ /p
else
  set grepprg=internal
endif
"}}}

"------------------------------------------------------------------------------
" Editing: {{{
" Complete
set completeopt=menu,menuone
if s:has_patch(7, 4, 775)
  set completeopt+=noselect
endif

" Format
set nrformats=hex
set formatoptions+=m
set formatoptions+=B

" Cursor
set virtualedit=block
set backspace=indent,eol,start

" Ctags
set showfulltag

" File format
set fileformat=unix
set fileformats=unix,dos,mac
if s:has_patch(7, 4, 785)
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
set foldenable
set foldmethod=marker
set foldcolumn=2
set foldlevelstart=99
"}}}

"------------------------------------------------------------------------------
" Status Line: {{{
set statusline=%f%<\ %m%r[
if has('multi_byte')
  set statusline+=%{&fenc!=''?&fenc:&enc}:
endif
set statusline+=%{&ff}]%y%=

if has('multi_byte')
  set statusline+=\ [U+%04B]
endif
set statusline+=\ (%l,%v)/%L

if s:is_lang_ja
  set statusline+=\ %4P
else
  set statusline+=\ %3P
endif
"}}}

"------------------------------------------------------------------------------
" Tab Line: {{{
let s:label_noname   = s:is_lang_ja ? '[無名]' : '[No Name]'
let s:label_quickfix = s:is_lang_ja ? '[Quickfixリスト]' : '[Quickfix List]'
let s:label_location = s:is_lang_ja ? '[場所リスト]' : '[Location List]'
function! s:label_qflisttype(n)
  return getbufvar(a:n, 'qflisttype') == 'location' ?
  \ s:label_location : s:label_quickfix
endfunction
function! s:tab_bufname(n)
  let name = bufname(a:n)
  let type = getbufvar(a:n, '&buftype')
  return
  \ type == 'quickfix' ? s:label_qflisttype(a:n) :
  \ type == 'help'     ? fnamemodify(name, ':t') :
  \ empty(name)        ? s:label_noname :
  \ empty(type)        ? pathshorten(name) : name
endfunction
function! s:tab_label(n)
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
function! TabLine()
  return join(map(range(1, tabpagenr('$')), 's:tab_label(v:val)'), '') .
  \ '%#TabLineFill#%T%= %#TabLineSel# ' . getcwd() . ' '
endfunction

set tabline=%!TabLine()
set showtabline=2
"}}}

"------------------------------------------------------------------------------
" File Encodings: {{{
if has('multi_byte')
  if s:has_jisx0213
    set fileencodings=iso-2022-jp-3,cp932,euc-jisx0213,euc-jp,ucs-bom
  else
    set fileencodings=iso-2022-jp,cp932,euc-jp,ucs-bom
  endif
  if has('guess_encode')
    set fileencodings^=guess
  endif

  let s:last_enc = &encoding
  augroup MyVimrc
    autocmd EncodingChanged *
    \ if s:last_enc !=# &encoding |
    \   let &runtimepath = iconv(&runtimepath, s:last_enc, &encoding) |
    \   let s:last_enc = &encoding |
    \ endif
    autocmd BufReadPost *
    \ if &modifiable && !search('[^\x00-\x7F]', 'cnw') |
    \   setlocal fileencoding= |
    \ endif
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" Colors: {{{
" Cursor line & column
if s:is_colored
  set cursorline
  set cursorcolumn

  " No cursor line & column at other window
  augroup MyVimrc
    autocmd BufWinEnter,WinEnter *
    \ let [&l:cursorline, &l:cursorcolumn] =
    \   [!get(b:, 'nocursorline'), !get(b:, 'nocursorcolumn')]
    autocmd BufWinLeave,WinLeave *
    \ setlocal nocursorline nocursorcolumn
  augroup END
endif
"}}}
"}}}

"==============================================================================
" Macros: {{{

"------------------------------------------------------------------------------
" Justify: {{{
if filereadable($VIMRUNTIME . '/macros/justify.vim')
  source $VIMRUNTIME/macros/justify.vim
  silent! nunmap _j
  silent! vunmap _j
  silent! nunmap ,gq
  silent! vunmap ,gq
endif
"}}}

"------------------------------------------------------------------------------
" MatchIt: {{{
if filereadable($VIMRUNTIME . '/macros/matchit.vim')
  source $VIMRUNTIME/macros/matchit.vim
  silent! sunmap %
  silent! sunmap g%
  silent! sunmap [%
  silent! sunmap ]%
  silent! sunmap a%

  nmap <SID>[% [%
  xmap <SID>[% [%
  nmap <SID>]% ]%
  xmap <SID>]% ]%

  xnoremap <script> [% <Esc><SID>[%m'gv``
  xnoremap <script> ]% <Esc><SID>]%m'gv``
  xnoremap <script> a% <Esc><SID>[%v<SID>]%

  nmap <Space>   %
  xmap <Space>   %
  omap <Space>   %
  nmap <S-Space> g%
  xmap <S-Space> g%
  omap <S-Space> g%
endif
"}}}
"}}}

"==============================================================================
" Mappings: {{{

"------------------------------------------------------------------------------
" Multi Mode Mapping: {{{
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
\ NOmap
\ nmap <args>| omap <args>
command! -nargs=* -complete=mapping
\ VOmap
\ vmap <args>| omap <args>
command! -nargs=* -complete=mapping
\ XOmap
\ xmap <args>| omap <args>
command! -nargs=* -complete=mapping
\ SOmap
\ smap <args>| omap <args>
command! -nargs=* -complete=mapping
\ NXOmap
\ nmap <args>| xmap <args>| omap <args>
command! -nargs=* -complete=mapping
\ NSOmap
\ nmap <args>| smap <args>| omap <args>

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
\ NOnoremap
\ nnoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ VOnoremap
\ vnoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ XOnoremap
\ xnoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ SOnoremap
\ snoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ NXOnoremap
\ nnoremap <args>| xnoremap <args>| onoremap <args>
command! -nargs=* -complete=mapping
\ NSOnoremap
\ nnoremap <args>| snoremap <args>| onoremap <args>

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
\ VOunmap
\ vunmap <args>| ounmap <args>
command! -nargs=* -complete=mapping
\ XOunmap
\ xunmap <args>| ounmap <args>
command! -nargs=* -complete=mapping
\ SOunmap
\ sunmap <args>| ounmap <args>
command! -nargs=* -complete=mapping
\ NXOunmap
\ nunmap <args>| xunmap <args>| ounmap <args>
command! -nargs=* -complete=mapping
\ NSOunmap
\ nunmap <args>| sunmap <args>| ounmap <args>
"}}}

"------------------------------------------------------------------------------
" Common: {{{
" <Leader> <LocalLeader>
let g:mapleader      = ';'
let g:maplocalleader = ','
NXOnoremap <Leader>      <Nop>
NXOnoremap <LocalLeader> <Nop>

" For plugin
NXOnoremap <Bslash> <Nop>

" For mark
NXOnoremap m <Nop>
NXOnoremap M <Nop>

" For user operator
NXOnoremap s <Nop>
NXOnoremap S <Nop>

" " For user textobj
" XOnoremap <M-a> <Nop>
" XOnoremap <M-A> <Nop>
" XOnoremap <M-i> <Nop>
" XOnoremap <M-I> <Nop>

" " For user square
" NXOnoremap <M-[> <Nop>
" NXOnoremap <M-]> <Nop>

" For the evacuation of "g"
NOnoremap <C-G> <Nop>

" Split Nicely
noremap <expr> <SID>(split-nicely)
\ myvimrc#split_nicely_expr() ? '<C-W>s' : '<C-W>v'
"}}}

"------------------------------------------------------------------------------
" Command Line: {{{
if s:cmdwin_ex_enable
  noremap <SID>: q:
else
  noremap <expr> <SID>: myvimrc#cmdline_enter(':')
endif
if s:cmdwin_search_enable
  noremap <SID>/ q/
  noremap <SID>? q?
else
  noremap <expr> <SID>/ myvimrc#cmdline_enter('/')
  noremap <expr> <SID>? myvimrc#cmdline_enter('?')
endif

NXOmap ;; <SID>:
NXOmap :  <SID>:
NXOmap /  <SID>/
NXOmap ?  <SID>?

NXOnoremap <expr> ;: myvimrc#cmdline_enter(':')
NXOnoremap <expr> ;/ myvimrc#cmdline_enter('/')
NXOnoremap <expr> ;? myvimrc#cmdline_enter('?')

NXnoremap <script> <C-W>/ <SID>(split-nicely)<SID>/
NXnoremap <script> <C-W>? <SID>(split-nicely)<SID>?

NXnoremap <script> <C-W>q/ <SID>(split-nicely)q/
NXnoremap <script> <C-W>q? <SID>(split-nicely)q?

NXnoremap <script><expr> <C-W>;/
\ '<SID>(split-nicely)' . myvimrc#cmdline_enter('/')
NXnoremap <script><expr> <C-W>;?
\ '<SID>(split-nicely)' . myvimrc#cmdline_enter('?')

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

augroup MyVimrc
  autocmd CmdwinEnter *
  \ call myvimrc#cmdwin_enter(expand('<afile>'))
  autocmd CmdwinLeave *
  \ call myvimrc#cmdwin_leave(expand('<afile>'))
augroup END
"}}}

"------------------------------------------------------------------------------
" Search: {{{
noremap <SID>*  *zv
noremap <SID>#  #zv
noremap <SID>g* g*zv
noremap <SID>g# g#zv
noremap <SID>n  nzv
noremap <SID>N  Nzv

NXOmap *  <SID>*
NXOmap #  <SID>#
NXOmap g* <SID>g*
NXOmap g# <SID>g#
NXOmap g/ *
NXOmap g? #

nmap <C-W>*  <SID>(split-nicely)<SID>*
nmap <C-W>#  <SID>(split-nicely)<SID>#
nmap <C-W>g* <SID>(split-nicely)<SID>g*
nmap <C-W>g# <SID>(split-nicely)<SID>g#
xnoremap <script> <C-W>*  <SID>(split-nicely)gv<SID>*
xnoremap <script> <C-W>#  <SID>(split-nicely)gv<SID>#
xnoremap <script> <C-W>g* <SID>(split-nicely)gv<SID>g*
xnoremap <script> <C-W>g# <SID>(split-nicely)gv<SID>g#
NXmap <C-W>g/ <C-W>*
NXmap <C-W>g? <C-W>#

NXOmap <expr> n
\ myvimrc#search_forward_expr() ? '<SID>n' : '<SID>N'
NXOmap <expr> N
\ myvimrc#search_forward_expr() ? '<SID>N' : '<SID>n'
"}}}

"------------------------------------------------------------------------------
" Escape Key: {{{
nnoremap <expr> <Esc><Esc> myvimrc#escape_key()
"}}}

"------------------------------------------------------------------------------
" Moving: {{{
" Insert-mode & Command-line-mode
noremap! <M-j> <Down>
noremap! <M-k> <Up>
noremap! <M-h> <Left>
noremap! <M-l> <Right>

" Insert-mode
inoremap <M-w>      <C-O>w
inoremap <M-b>      <C-O>b
inoremap <M-e>      <C-O>e
inoremap <M-g><M-e> <C-O>ge
inoremap <M-W>      <C-O>W
inoremap <M-B>      <C-O>B
inoremap <M-E>      <C-O>E
inoremap <M-g><M-E> <C-O>gE
inoremap <M-f>      <C-O>f
inoremap <M-F>      <C-O>F
inoremap <M-t>      <C-O>t
inoremap <M-T>      <C-O>T
inoremap <M-;>      <C-O>;
inoremap <M-,>      <C-O>,
inoremap <M-(>      <C-O>(
inoremap <M-)>      <C-O>)
inoremap <M-{>      <C-O>{
inoremap <M-}>      <C-O>}

" Command-line-mode
cnoremap <M-H> <Home>
cnoremap <M-L> <End>
cnoremap <M-w> <S-Right>
cnoremap <M-b> <S-Left>

" Jump
nnoremap <S-Tab> <C-O>

" Mark
NXOnoremap m<Down> ]`
NXOnoremap m<Up>   [`
NXOnoremap mj      ]`
NXOnoremap mk      [`

" Command-line
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
"}}}

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
"}}}

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
\ '<SID>:<C-U>lchdir ' . myvimrc#expand('%:p:h') . '/'
NXnoremap <script><expr> <Leader><M-D>
\ '<SID>:<C-U>chdir ' . myvimrc#expand('%:p:h') . '/'
"}}}

"------------------------------------------------------------------------------
" Help: {{{
nnoremap <expr> <F1>
\ myvimrc#split_nicely_expr() ?
\   ':<C-U>help<Space>' :
\   ':<C-U>vertical help<Space>'
inoremap <expr> <F1>
\ myvimrc#split_nicely_expr() ?
\   '<C-O>:<C-U>help<Space>' :
\   '<C-O>:<C-U>vertical help<Space>'
"}}}

"------------------------------------------------------------------------------
" Auto Mark: {{{
nnoremap <expr> mm myvimrc#auto_mark()
nnoremap <expr> mc myvimrc#clear_marks()
nnoremap <expr> mM myvimrc#auto_file_mark()
nnoremap <expr> mC myvimrc#clear_file_marks()
"}}}

"------------------------------------------------------------------------------
" BOL Toggle: {{{
NXOnoremap <expr> H myvimrc#bol_toggle()
NXOnoremap <expr> L myvimrc#eol_toggle()
inoremap <expr> <M-H> '<C-O>' . myvimrc#bol_toggle()
inoremap <expr> <M-L> '<C-O>' . myvimrc#eol_toggle()
"}}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
nnoremap  <expr> <M-a> myvimrc#insert_one_char('a')
NXnoremap <expr> <M-A> myvimrc#insert_one_char('A')
nnoremap  <expr> <M-i> myvimrc#insert_one_char('i')
NXnoremap <expr> <M-I> myvimrc#insert_one_char('I')
"}}}

"------------------------------------------------------------------------------
" Force Blockwise Insert: {{{
xnoremap <expr> A myvimrc#force_blockwise_insert('A')
xnoremap <expr> I myvimrc#force_blockwise_insert('I')
"}}}

"------------------------------------------------------------------------------
" Increment: {{{
silent! vunmap <C-A>
silent! vunmap <C-X>
if s:has_patch(7, 4, 754)
  xnoremap <C-A>  <C-A>gv
  xnoremap <C-X>  <C-X>gv
  xnoremap g<C-A> g<C-A>gv
  xnoremap g<C-X> g<C-X>gv
endif
"}}}

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

" Tabs
NXnoremap <expr> g<M-t>
\ ':<C-U>tabmove +' . v:count1 . '<CR>'
NXnoremap <expr> g<M-T>
\ ':<C-U>tabmove -' . v:count1 . '<CR>'

" New line
nnoremap <M-o>
\ :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
nnoremap <M-O>
\ :<C-U>call append(line('.') - 1, repeat([''], v:count1))<CR>

" The precious area text object
onoremap gv :<C-U>normal! gv<CR>

" The last changed area text object
nnoremap  g[ `[v`]
XOnoremap g[ :<C-U>normal g[<CR>

" Delete at Insert-mode
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>
"}}}

"------------------------------------------------------------------------------
" Evacuation: {{{
" Mark
nnoremap <M-m> m

" Repeat find
NXOnoremap <M-;> ;
NXOnoremap <M-,> ,

" Jump
NXOnoremap gH H
NXOnoremap gM M
NXOnoremap gL L

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
NXOnoremap s?  g?
nnoremap   s?? g??
"}}}
"}}}

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
"}}}

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
"}}}

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
"}}}

"------------------------------------------------------------------------------
" Windows Shell: {{{
if has('win32')
  command! -bar
  \ ShellCmd
  \ call myvimrc#set_shell() |
  \ set shell? shellslash? shellcmdflag? shellquote? shellxquote?
  command! -bar -nargs=?
  \ ShellSh
  \ call myvimrc#set_shell(
  \   [!empty(<q-args>) ? <q-args> : 'sh', 1, '-c', '', '"']) |
  \ set shell? shellslash? shellcmdflag? shellquote? shellxquote?

  command! -bar -nargs=+ -complete=file
  \ CmdSource
  \ call myvimrc#cmdsource(<args>)
endif
"}}}

"------------------------------------------------------------------------------
" VC Vars: {{{
if has('win32')
  if !exists('$VCVARSALL')
    if exists('$VS140COMNTOOLS')
      let $VCVARSALL = $VS140COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif exists('$VS120COMNTOOLS')
      let $VCVARSALL = $VS120COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif exists('$VS110COMNTOOLS')
      let $VCVARSALL = $VS110COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif exists('$VS100COMNTOOLS')
      let $VCVARSALL = $VS100COMNTOOLS . '..\..\VC\vcvarsall.bat'
    elseif exists('$VS90COMNTOOLS')
      let $VCVARSALL = $VS90COMNTOOLS  . '..\..\VC\vcvarsall.bat'
    elseif exists('$VS80COMNTOOLS')
      let $VCVARSALL = $VS80COMNTOOLS  . '..\..\VC\vcvarsall.bat'
    endif
  endif
  if !exists('$SDK_INCLUDE_DIR')
    if isdirectory(
    \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.1A\Include')
      let $SDK_INCLUDE_DIR =
      \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.1A\Include'
    elseif isdirectory(
    \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.1\Include')
      let $SDK_INCLUDE_DIR =
      \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.1\Include'
    elseif isdirectory(
    \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.0A\Include')
      let $SDK_INCLUDE_DIR =
      \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.0A\Include'
    elseif isdirectory(
    \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.0\Include')
      let $SDK_INCLUDE_DIR =
      \ s:programfiles_x86 . '\Microsoft SDKs\Windows\v7.0\Include'
    endif
  endif

  command! -bar
  \ VCVars32
  \ call myvimrc#cmdsource(
  \   myvimrc#cmdescape($VCVARSALL), 'x86')

  if exists('$PROGRAMFILES(X86)')
    command! -bar
    \ VCVars64
    \ call myvimrc#cmdsource(
    \   myvimrc#cmdescape($VCVARSALL),
    \   exists('PROCESSOR_ARCHITEW6432') ?
    \   $PROCESSOR_ARCHITEW6432 : $PROCESSOR_ARCHITECTURE)
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Line Number Toggle: {{{
command! -bar
\ LineNumberToggle
\ call myvimrc#line_number_toggle() |
\ set number? relativenumber?

nnoremap <F12>
\ :<C-U>LineNumberToggle<CR>
"}}}

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
"}}}

"------------------------------------------------------------------------------
" From CmdEx: {{{
command! -bar -nargs=1 -complete=file
\ Diff
\ vertical diffsplit <args>
command! -bar
\ Undiff
\ diffoff |
\ setlocal scrollbind< cursorbind< wrap< foldmethod< foldcolumn< |
\ call s:doautocmd('FileType')

nnoremap <F8> :<C-U>Undiff<CR>
"}}}

"------------------------------------------------------------------------------
" From Example: {{{
command! -bar
\ DiffOrig
\ let s:save_ft = &l:filetype | vertical new | setlocal buftype=nofile |
\ read ++edit # | 0d_ | let &l:filetype = s:save_ft | unlet s:save_ft |
\ diffthis | wincmd p | diffthis

nnoremap <F6> :<C-U>DiffOrig<CR>
"}}}
"}}}

"==============================================================================
" Auto Command: {{{

"------------------------------------------------------------------------------
" Auto MkDir: {{{
autocmd MyVimrc BufWritePre *
\ call myvimrc#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
"}}}

"------------------------------------------------------------------------------
" Quick Close: {{{
autocmd MyVimrc FileType *
\ if (&readonly || !&modifiable) && empty(maparg('q', 'n')) |
\   nnoremap <buffer><silent><expr> q
\     winnr('$') != 1 ? ':<C-U>close<CR>' : ''|
\ endif
"}}}

"------------------------------------------------------------------------------
" QuickFix: {{{
autocmd MyVimrc BufWinEnter,WinEnter *
\ if &l:buftype == 'quickfix' && !exists('b:qflisttype') |
\   call myvimrc#set_qflisttype() |
\ endif
"}}}

"------------------------------------------------------------------------------
" Functions Of Highlight: {{{
function! s:get_highlight(hi)
  redir => hl
  silent execute 'highlight' a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', ' ', 'g')
  return matchstr(hl, 'xxx\zs.*$')
endfunction

function! s:_reverse_highlight(hl, name)
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

function! s:reverse_highlight(hl)
  return a:hl .
  \ ' term='  . s:_reverse_highlight(a:hl, 'term') .
  \ ' cterm=' . s:_reverse_highlight(a:hl, 'cterm') .
  \ ' gui='   . s:_reverse_highlight(a:hl, 'gui')
endfunction
"}}}

"------------------------------------------------------------------------------
" Reverse Status Line Color At Insert Mode: {{{
if s:is_colored
  function! s:reverse_status_line_color(is_insert, reset)
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
"}}}

"------------------------------------------------------------------------------
" Highlight Ideographic Space: {{{
if has('multi_byte') && s:is_colored
  function! s:highlight_ideographic_space(reset)
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
"}}}

"------------------------------------------------------------------------------
" From Example: {{{
autocmd MyVimrc FileType *
\ if line('.') == 1 && line("'\"") > 1 && line("'\"") <= line('$') &&
\   index(s:ignore_ft, expand('<amatch>')) < 0 |
\   execute 'normal! g`"' |
\ endif
"}}}
"}}}

"==============================================================================
" Plugins: {{{
" Default selector
let s:selector_ui = {
\ 'edit'      : 'ctrlp',
\ 'explorer'  : 'ctrlp',
\ 'chdir'     : 'ctrlp',
\ 'buffer'    : 'ctrlp',
\ 'buffers'   : 'tabpagebuffer',
\ 'bdelete'   : 'tabpagebuffer',
\ 'tabnext'   : 'ctrlp',
\ 'undo'      : 'undotree',
\ 'changes'   : 'ctrlp',
\ 'jumps'     : 'ctrlp',
\ 'registers' : 'ctrlp',
\ 'marks'     : 'ctrlp',
\ 'tag'       : 'ctrlp',
\ 'shell'     : 'vimshell',
\ 'grep'      : '',
\ 'quickfix'  : '',
\
\ 'omnisharp' : 'ctrlp'}

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
\ 'tun[hide]'    : 'tab unhide',
\ 'tba[ll]'      : 'tab ball'}

" NeoComplete, NeoComplCache
" {filetype} : {dictionary}
let s:neocompl_dictionary_filetype_lists = {
\ 'default' : ''}
" {filetype} : {expr}
let s:neocompl_tags_filter_patterns = {
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
\ 'yacc'       : 'v:val.word !~ "^[~_]"',
\
\ 'vb'         : 'v:val.word !~ "^[~_]"',
\ 'vbnet'      : 'v:val.word !~ "^[~_]"'}
" {command} : {function}
let s:neocompl_vim_completefuncs = {
\ 'SQLSetType' : 'SQL_GetList'}
" {omnifunc} : {pattern}
let s:neocompl_omni_patterns = {
\ 'CucumberComplete'              : '\h\w*',
\ 'adacomplete#Complete'          : '\h\w*',
\ 'clojurecomplete#Complete'      : '\h\w*',
\ 'csscomplete#CompleteCSS'       : '\h\w*\|[@!]',
\ 'sqlcomplete#Complete'          : '\h\w*'}
" {omnifunc} : {pattern}
let s:neocompl_force_omni_patterns = {
\ 'ccomplete#Complete'            : '\%(\.\|->\|::\)\h\w*',
\ 'htmlcomplete#CompleteTags'     : '<[^>]*',
\ 'javascriptcomplete#CompleteJS' : '\.\h\w*',
\ 'phpcomplete#CompletePHP'       : '\%(->\|::\)\h\w*',
\ 'xmlcomplete#CompleteTags'      : '<[^>]*'}
if has('python3')
  call extend(s:neocompl_force_omni_patterns, {
  \ 'python3complete#Complete' : '\.\h\w*'})
endif
if has('python')
  call extend(s:neocompl_force_omni_patterns, {
  \ 'pythoncomplete#Complete' : '\.\h\w*'})
endif
if has('ruby')
  call extend(s:neocompl_force_omni_patterns, {
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

" Indent
let g:vim_indent_cont = 0

" Folding
let g:javaScript_fold    = 1
let g:perl_fold          = 1
let g:php_folding        = 1
let g:ruby_fold          = 1
let g:sh_fold_enabled    = 1
let g:vimsyn_folding     = 'af'
let g:xml_syntax_folding = 1

" Auto Open QuickFix
if empty(get(s:selector_ui, 'quickfix'))
  augroup MyVimrc
    autocmd QuickFixCmdPost [^l]*
    \ cwindow
    autocmd QuickFixCmdPost l*
    \ lwindow
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" NeoBundle: {{{
if isdirectory($HOME . '/.local/bundle/neobundle')
  set runtimepath+=~/.local/bundle/neobundle
  let g:neobundle#enable_name_conversion = 1
  let g:neobundle#install_max_processes  = s:cpucores()
  call neobundle#begin($HOME . '/.local/bundle')

  if (has('win32') && v:progname !=# 'gvim.exe') ||
  \ (!has('win32') && v:progname !~# '^g\=vim$')
    call neobundle#load_toml($HOME . '/.vim/neobundle.toml', {'lazy' : 1})
  elseif neobundle#load_cache($HOME . '/.vim/neobundle.toml')
    call neobundle#load_toml($HOME . '/.vim/neobundle.toml', {'lazy' : 1})
    NeoBundleSaveCache
  endif

  call extend(s:neocompl_vim_completefuncs, {
  \ 'NeoBundleSource'    : 'neobundle#complete_lazy_bundles',
  \ 'NeoBundleDisable'   : 'neobundle#complete_bundles',
  \ 'NeoBundleInstall'   : 'neobundle#complete_bundles',
  \ 'NeoBundleUpdate'    : 'neobundle#complete_bundles',
  \ 'NeoBundleClean'     : 'neobundle#complete_deleted_bundles',
  \ 'NeoBundleReinstall' : 'neobundle#complete_bundles'})
endif
"}}}

"------------------------------------------------------------------------------
" Alignta: {{{
if s:neobundle_tap('alignta')
  function! neobundle#hooks.on_source(bundle)
    call operator#user#define(
    \ 'alignta',
    \ 'myvimrc#operator_alignta')
  endfunction

  NXOmap s= <Plug>(operator-alignta)

  nmap s== s=s=
endif
"}}}

"------------------------------------------------------------------------------
" AlterCommand: {{{
if s:neobundle_tap('altercmd')
  function! neobundle#hooks.on_post_source(bundle)
    for [key, value] in items(s:altercmd_define)
      execute 'CAlterCommand' key value
    endfor
  endfunction

  augroup MyVimrc
    autocmd User CmdlineEnter
    \ NeoBundleSource altercmd
    autocmd CmdwinEnter :
    \ call myvimrc#cmdwin_enter_altercmd(s:altercmd_define)
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" Altr: {{{
if s:neobundle_tap('altr')
  nmap g<M-f>     <Plug>(altr-forward)
  nmap g<M-F>     <Plug>(altr-back)
  nmap <C-W><M-f> <SID>(split-nicely)<Plug>(altr-forward)
  nmap <C-W><M-F> <SID>(split-nicely)<Plug>(altr-back)
endif
"}}}

"------------------------------------------------------------------------------
" Anzu: {{{
if s:neobundle_tap('anzu')
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
endif
"}}}

"------------------------------------------------------------------------------
" AutoDate: {{{
if s:neobundle_tap('autodate')
  function! neobundle#hooks.on_source(bundle)
    let g:autodate_lines = 10
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" AutoFmt: {{{
if s:neobundle_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif
"}}}

"------------------------------------------------------------------------------
" Clang Format: {{{
if s:neobundle_tap('clang-format')
  " NXOmap <buffer> sf <Plug>(operator-clang-format)
  "
  " nmap <buffer> sff sfsf
endif
"}}}

"------------------------------------------------------------------------------
" Clever F: {{{
if s:neobundle_tap('clever-f')
  function! neobundle#hooks.on_source(bundle)
    let g:clever_f_not_overwrites_standard_mappings = 1
    let g:clever_f_fix_key_direction                = 1
    let g:clever_f_use_migemo                       = 1

    nmap <SID>(clever-f-f)              <Plug>(clever-f-f)
    nmap <SID>(clever-f-F)              <Plug>(clever-f-F)
    nmap <SID>(clever-f-t)              <Plug>(clever-f-t)
    nmap <SID>(clever-f-T)              <Plug>(clever-f-T)
    nmap <SID>(clever-f-reset)          <Plug>(clever-f-reset)
    nmap <SID>(clever-f-repeat-forward) <Plug>(clever-f-repeat-forward)
    nmap <SID>(clever-f-repeat-back)    <Plug>(clever-f-repeat-back)

    inoremap <script> <M-f> <C-O><SID>(clever-f-f)
    inoremap <script> <M-F> <C-O><SID>(clever-f-F)
    inoremap <script> <M-t> <C-O><SID>(clever-f-t)
    inoremap <script> <M-T> <C-O><SID>(clever-f-T)
    inoremap <script> <M-.> <C-O><SID>(clever-f-reset)
    inoremap <script> <M-;> <C-O><SID>(clever-f-repeat-forward)
    inoremap <script> <M-,> <C-O><SID>(clever-f-repeat-back)
  endfunction

  NXOmap f     <Plug>(clever-f-f)
  NXOmap F     <Plug>(clever-f-F)
  NXOmap t     <Plug>(clever-f-t)
  NXOmap T     <Plug>(clever-f-T)
  NXOmap <M-.> <Plug>(clever-f-reset)
  NXOmap <M-;> <Plug>(clever-f-repeat-forward)
  NXOmap <M-,> <Plug>(clever-f-repeat-back)
endif
"}}}

"------------------------------------------------------------------------------
" ColumnJump: {{{
if s:neobundle_tap('columnjump')
  function! neobundle#hooks.on_source(bundle)
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
"}}}

"------------------------------------------------------------------------------
" Universal Ctags: {{{
if s:neobundle_tap('ctags')
  call extend(s:neocompl_tags_filter_patterns, {
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
"}}}

"------------------------------------------------------------------------------
" CtrlP: {{{
if s:neobundle_tap('ctrlp')
  function! neobundle#hooks.on_source(bundle)
    let g:ctrlp_map                 = ''
    let g:ctrlp_match_window        = 'max:20'
    let g:ctrlp_switch_buffer       = ''
    let g:ctrlp_working_path_mode   = ''
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir           = $HOME . '/.local/.cache/ctrlp'
    let g:ctrlp_show_hidden         = 1
    let g:ctrlp_open_new_file       = 'r'

    let g:ctrlp_custom_ignore       = {
    \ 'dir'  : join(s:ignore_dir, '\|'),
    \ 'file' : '\.\%(' . join(s:ignore_ext, '\|') . '\)$'}
    let g:ctrlp_mruf_exclude        =
    \ join(s:ignore_dir, '\|')

    if s:executable('files')
      let s:ctrlp_user_command =
      \ s:cpucores() > 1 ? 'files -A %s' : 'files %s'
    " elseif has('win32')
    "   let s:ctrlp_user_command =
    "   \ 'dir %s /-n /b /s /a-d'
    elseif !has('win32') && s:executable('find')
      let s:ctrlp_user_command =
      \ 'find -L %s -type f'
    endif
    if exists('s:ctrlp_user_command')
      let g:ctrlp_user_command = {
      \ 'fallback' : s:ctrlp_user_command,
      \ 'ignore'   : 1}
    endif

    if s:is_enabled_bundle('ctrlp-py-matcher')
      let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch'}
    endif

    let g:ctrlp#tabpage#visible_all_buftype = 1
  endfunction

  NXnoremap <Bslash>p <Nop>

  NXnoremap <Bslash>pe :<C-U>CtrlPMRUFiles<CR>
  NXnoremap <Bslash>pE :<C-U>CtrlP<CR>
  NXnoremap <Bslash>pB :<C-U>CtrlPBuffer<CR>

  NXnoremap <Bslash>pu :<C-U>CtrlPUndo<CR>
  NXnoremap <Bslash>pj :<C-U>CtrlPChange<CR>
  NXnoremap <Bslash>p] :<C-U>CtrlPTag<CR>

  NXnoremap <Bslash>p/ :<C-U>CtrlPLine<CR>

  if get(s:selector_ui, 'edit') == 'ctrlp'
    NXmap <Leader>e <Bslash>pe
  endif
  if get(s:selector_ui, 'explorer') == 'ctrlp'
    NXmap <Leader>E <Bslash>pE
  endif
  if get(s:selector_ui, 'undo') == 'ctrlp'
    NXmap <Leader>u <Bslash>pu
  endif
  if get(s:selector_ui, 'change') == 'ctrlp'
    NXmap <Leader>j <Bslash>pj
  endif
  if get(s:selector_ui, 'tag') == 'ctrlp'
    NXmap <Leader>] <Bslash>p]
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Chdir: {{{
if s:neobundle_tap('ctrlp-chdir')
  NXnoremap <Bslash>pd     :<C-U>CtrlPLchdir<CR>
  NXnoremap <Bslash>pD     :<C-U>CtrlPChdir<CR>
  NXnoremap <Bslash>p<M-d> :<C-U>CtrlPLchdir %:p:h<CR>
  NXnoremap <Bslash>p<M-D> :<C-U>CtrlPChdir %:p:h<CR>

  if get(s:selector_ui, 'chdir') == 'ctrlp'
    NXmap <Leader>d     <Bslash>pd
    NXmap <Leader>D     <Bslash>pD
    NXmap <Leader><M-d> <Bslash>p<M-d>
    NXmap <Leader><M-D> <Bslash>p<M-D>
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP ColorScheme: {{{
if s:neobundle_tap('ctrlp-colorscheme')
  command! -bar
  \ CtrlPColorScheme
  \ call ctrlp#init(ctrlp#colorscheme#id())
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP FileType: {{{
if s:neobundle_tap('ctrlp-filetype')
  NXnoremap <Bslash>pT
  \ :<C-U>CtrlPFileType<CR>
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Help: {{{
if s:neobundle_tap('ctrlp-help')
  NXnoremap <Bslash>p<F1>
  \ :<C-U>CtrlPHelp<CR>
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Jumps: {{{
if s:neobundle_tap('ctrlp-jumps')
  NXnoremap <Bslash>pJ :<C-U>CtrlPJump<CR>

  if get(s:selector_ui, 'jumps') == 'ctrlp'
    NXmap <Leader>J <Bslash>pJ
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP LocationList: {{{
if s:neobundle_tap('ctrlp-location-list')
  NXnoremap <Bslash>p,
  \ :<C-U>call myvimrc#ctrlp_no_empty('CtrlPQuickfix')<CR>
  NXnoremap <Bslash>p.
  \ :<C-U>call myvimrc#ctrlp_no_empty('CtrlPLocList')<CR>

  if get(s:selector_ui, 'quickfix') == 'ctrlp'
    NXmap <C-W>, <Bslash>p,
    NXmap <C-W>. <Bslash>p.

    augroup MyVimrc
      autocmd QuickFixCmdPost [^l]*
      \ call myvimrc#ctrlp_no_empty('CtrlPQuickfix')<CR>
      autocmd QuickFixCmdPost l*
      \ call myvimrc#ctrlp_no_empty('CtrlPLocList')<CR>
    augroup END
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Mark: {{{
if s:neobundle_tap('ctrlp-mark')
  NXnoremap <Bslash>pm
  \ :<C-U>CtrlPMark<CR>

  if get(s:selector_ui, 'marks') == 'ctrlp'
    NXmap <Leader>m <Bslash>pm
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Register: {{{
if s:neobundle_tap('ctrlp-register')
  if !s:is_enabled_bundle('yankround')
    nnoremap <Bslash>pp
    \ :<C-U>CtrlPRegister<CR>
    xnoremap <Bslash>pp
    \ d:<C-U>CtrlPRegister<CR>

    if get(s:selector_ui, 'registers') == 'ctrlp'
      NXmap <Leader>p <Bslash>pp
    endif
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Tabpage: {{{
if s:neobundle_tap('ctrlp-tabpage')
  NXnoremap <Bslash>pt :<C-U>CtrlPTabpage<CR>

  if get(s:selector_ui, 'tabnext') == 'ctrlp'
    NXmap <Leader>t <Bslash>pt
  endif
endif
"}}}

"------------------------------------------------------------------------------
" CtrlP Window: {{{
if s:neobundle_tap('ctrlp-window')
  NXnoremap <Bslash>pw :<C-U>CtrlPWindow<CR>
  NXnoremap <Bslash>pW :<C-U>CtrlPWindowAll<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Dispatch: {{{
if s:neobundle_tap('dispatch')
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Dispatch'      : 'dispatch#command_complete',
  \ 'FocusDispatch' : 'dispatch#command_complete',
  \ 'Make'          : 'dispatch#make_complete',
  \ 'Start'         : 'dispatch#command_complete',
  \ 'Spawn'         : 'dispatch#command_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" EchoDoc: {{{
if s:neobundle_tap('echodoc')
  function! neobundle#hooks.on_source(bundle)
    call echodoc#enable()
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Emmet: {{{
if s:neobundle_tap('emmet')
  function! neobundle#hooks.on_source(bundle)
    let g:user_emmet_leader_key = '<M-y>'
    let g:user_emmet_settings   = {
    \ 'lang' : 'ja',
    \ 'indentation' : '  ',
    \ 'xml' : {'extends' : 'html'}}
  endfunction

  call extend(s:neocompl_omni_patterns, {
  \ 'emmet#CompleteTag' : '\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Eskk: {{{
if s:neobundle_tap('eskk')
  function! neobundle#hooks.on_source(bundle)
    let g:eskk#directory               = $HOME . '/.local/.eskk'
    let g:eskk#no_default_mappings     = 1
    let g:eskk#start_completion_length = 1
    let g:eskk#dictionary              = {
    \ 'path' : $HOME . '/.skk/jisyo',
    \ 'sorted' : 0,
    \ 'encoding' : 'utf-8'}
    let g:eskk#large_dictionary        = {
    \ 'path' : $HOME . '/.skk/SKK-JISYO.L',
    \ 'sorted' : 1,
    \ 'encoding' : 'euc-jp'}
    let g:eskk#mapped_keys             =
    \ filter(eskk#get_default_mapped_keys(), 'v:val !=? "<Tab>"')
  endfunction

  map! <C-J> <Plug>(eskk:toggle)
  lmap <C-J> <Plug>(eskk:toggle)
endif
"}}}

"------------------------------------------------------------------------------
" Lua Ftplugin: {{{
if s:neobundle_tap('lua-ftplugin')
  function! neobundle#hooks.on_source(bundle)
    let g:lua_complete_omni = 1
    let g:lua_check_syntax  = 0
    let g:lua_check_globals = 0

    if s:executable('luajit')
      let g:lua_interpreter_path = 'luajit'
      let g:lua_compiler_name    = 'luajit'
      let g:lua_compiler_args    = '-bl'
      let g:lua_error_format     = 'luajit: %f:%l: %m'
    endif
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
  \ 'xolox#lua#omnifunc' : '\%(\.\|:\)\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Goto File: {{{
if s:neobundle_tap('gf-user')
  function! neobundle#hooks.on_source(bundle)
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
"}}}

"------------------------------------------------------------------------------
" Go Extra: {{{
if s:neobundle_tap('go-extra')
  call extend(s:neocompl_force_omni_patterns, {
  \ 'go#complete#Complete' : '\.\h\w*',
  \ 'gocomplete#Complete'  : '\.\h\w*'})
  call extend(s:neocompl_vim_completefuncs, {
  \ 'GoDoc' : 'go#complete#Package'})
endif
"}}}

"------------------------------------------------------------------------------
" Grex: {{{
if s:neobundle_tap('grex')
  NXOmap sD <Plug>(operator-grex-delete)
  NXOmap sY <Plug>(operator-grex-yank)

  nmap sDD sDsD
  nmap sYY sYsY
endif
"}}}

"------------------------------------------------------------------------------
" Hier: {{{
if s:neobundle_tap('hier')
  autocmd MyVimrc User EscapeKey
  \ HierClear
endif
"}}}

"------------------------------------------------------------------------------
" IncSearch: {{{
if s:neobundle_tap('incsearch')
  NXOnoremap <silent><expr> <SID>/ myvimrc#incsearch_next()
  NXOnoremap <silent><expr> <SID>? myvimrc#incsearch_prev()

  if s:is_enabled_bundle('anzu')
    autocmd MyVimrc User IncSearchExecute
    \ call feedkeys(":\<C-U>AnzuUpdateSearchStatusOutput\<CR>", 'n')
  endif
endif
"}}}

"------------------------------------------------------------------------------
" J6uil: {{{
if s:neobundle_tap('J6uil')
  function! neobundle#hooks.on_source(bundle)
    let g:J6uil_config_dir             = $HOME . '/.local/.cache/J6uil'
    let g:J6uil_echo_presence          = 0
    let g:J6uil_open_buffer_cmd        = 'tabedit'
    let g:J6uil_no_default_keymappings = 1
    let g:J6uil_user                   = 'DeaR'

    if (!has('win32') && s:executable('convert')) ||
    \ (has('win32') && isdirectory($PROGRAMFILES . '/ImageMagick-6.9.0-Q16'))
      let g:J6uil_display_icon = 1
    endif
  endfunction

  call extend(s:altercmd_define, {
  \ 'j[6uil]' : 'J6uil'})
  call extend(s:neocompl_vim_completefuncs, {
  \ 'J6uil' : 'J6uil#complete#room'})
endif
"}}}

"------------------------------------------------------------------------------
" Jedi: {{{
if s:neobundle_tap('jedi')
  function! neobundle#hooks.on_source(bundle)
    let g:jedi#auto_initialization    = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot           = 0
    let g:jedi#auto_close_doc         = 0
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
  \ 'jedi#completions' : '\.\h\w*'})
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Pyimport' : 'jedi#py_import_completions'})
endif
"}}}

"------------------------------------------------------------------------------
" Localrc: {{{
if s:neobundle_tap('localrc')
  augroup MyVimrc
    autocmd BufNewFile,BufRead *
    \ if exists('b:undo_localrc') |
    \   execute b:undo_localrc |
    \   unlet! b:undo_localrc |
    \ endif
    autocmd FileType *
    \ if exists('b:undo_ftlocalrc') |
    \   execute b:undo_ftlocalrc |
    \   unlet! b:undo_ftlocalrc |
    \ endif
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" MapList: {{{
if s:neobundle_tap('maplist')
  function! neobundle#hooks.on_source(bundle)
    let g:maplist_mode_length  = 4
    let g:maplist_lhs_length   = 50
    let g:maplist_local_length = 2
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Marching: {{{
if s:neobundle_tap('marching')
  function! neobundle#hooks.on_source(bundle)
    let g:marching_enable_neocomplete = 1
    let g:marching_backend            =
    \ s:is_enabled_bundle('snowdrop') ?
    \   'snowdrop' : 'sync_clang_command'
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
  \ 'marching#complete' : '\%(\.\|->\|::\)\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Molokai: {{{
if s:neobundle_tap('molokai')
  function! neobundle#hooks.on_source(bundle)
    let g:molokai_original = 0
    let g:rehash256        = 1
  endfunction

  function! s:molokai_after()
    if get(g:, 'colors_name', '') != 'molokai'
      return
    endif

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
"}}}

"------------------------------------------------------------------------------
" Narrow: {{{
if s:neobundle_tap('narrow')
  function! neobundle#hooks.on_source(bundle)
    call operator#user#define_ex_command(
    \ 'narrow',
    \ 'Narrow')

    silent! delcommand Narrow
    silent! delcommand Widen
  endfunction

  NXnoremap sN :<C-U>Widen<CR>
  NXOmap sn <Plug>(operator-narrow)

  nmap snn snsn
endif
"}}}

"------------------------------------------------------------------------------
" Neco Vim: {{{
if s:neobundle_tap('neco-vim')
  function! neobundle#hooks.on_source(bundle)
    let g:necovim#complete_functions =
    \ s:neocompl_vim_completefuncs
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" NeoComplCache: {{{
if s:neobundle_tap('neocomplcache')
  function! neobundle#hooks.on_source(bundle)
    let g:neocomplcache_enable_at_startup            = 1
    let g:neocomplcache_enable_auto_select           = 0
    let g:neocomplcache_enable_auto_delimiter        = 1
    let g:neocomplcache_enable_camel_case_completion = 0
    let g:neocomplcache_enable_underbar_completion   = 0
    let g:neocomplcache_enable_fuzzy_completion      = 0
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_temporary_dir                =
    \ $HOME . '/.local/.cache/neocomplcache'

    let g:neocomplcache_dictionary_filetype_lists =
    \ s:neocompl_dictionary_filetype_lists
    let g:neocomplcache_vim_completefuncs         =
    \ s:neocompl_vim_completefuncs
    " let g:neocomplcache_tags_filter_patterns      =
    " \ s:neocompl_tags_filter_patterns
    " let g:neocomplcache_omni_patterns             =
    " \ s:neocompl_omni_patterns
    " let g:neocomplcache_force_omni_patterns       =
    " \ s:neocompl_force_omni_patterns
    let g:neocomplcache_tags_filter_patterns      = {}
    let g:neocomplcache_omni_patterns             = {}
    let g:neocomplcache_force_omni_patterns       = {}

    call neocomplcache#custom_source('syntax_complete',   'rank',  9)
    call neocomplcache#custom_source('snippets_complete', 'rank', 80)

    inoremap <expr> <C-Y>
    \ neocomplcache#close_popup()
    inoremap <expr> <C-E>
    \ neocomplcache#cancel_popup()
    inoremap <expr> <C-L>
    \ neocomplcache#complete_common_string()
    inoremap <expr> <C-G>
    \ neocomplcache#undo_completion()
    inoremap <expr> <C-X><C-X>
    \ neocomplcache#close_popup() .
    \ neocomplcache#start_manual_complete()

    inoremap <expr> <CR>
    \ neocomplcache#close_popup() . '<CR>'
    inoremap <expr> <C-H>
    \ neocomplcache#smart_close_popup() . '<C-H>'
    inoremap <expr> <BS>
    \ neocomplcache#smart_close_popup() . '<BS>'

    inoremap <expr> <Tab>
    \ pumvisible() ? '<C-N>' : '<Tab>'
    inoremap <expr> <S-Tab>
    \ pumvisible() ? '<C-P>' : '<S-Tab>'
  endfunction

  augroup MyVimrc
    autocmd CmdwinEnter *
    \ call myvimrc#cmdwin_enter_neocomplcache()
    autocmd CmdwinEnter :
    \ let b:neocomplcache_sources_list = ['file_complete', 'vim_complete']
  augroup END

  call extend(s:neocompl_vim_completefuncs, {
  \ 'NeoComplCacheCachingDictionary' : 'neocomplcache#filetype_complete',
  \ 'NeoComplCacheCachingSyntax'     : 'neocomplcache#filetype_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" NeoComplete: {{{
if s:neobundle_tap('neocomplete')
  function! neobundle#hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_auto_select           = 0
    let g:neocomplete#enable_auto_delimiter        = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#data_directory               =
    \ $HOME . '/.local/.cache/neocomplete'

    let g:neocomplete#sources#dictionary#dictionaryies =
    \ s:neocompl_dictionary_filetype_lists
    " let g:neocomplete#tags_filter_patterns             =
    " \ s:neocompl_tags_filter_patterns
    " let g:neocomplete#sources#omni#input_patterns      =
    " \ s:neocompl_omni_patterns
    " let g:neocomplete#force_omni_input_patterns        =
    " \ s:neocompl_force_omni_patterns
    let g:neocomplete#tags_filter_patterns             = {}
    let g:neocomplete#sources#omni#input_patterns      = {}
    let g:neocomplete#force_omni_input_patterns        = {}

    call neocomplete#custom#source('_', 'matchers', ['matcher_head'])
    call neocomplete#custom#source('syntax_complete',   'rank',  9)
    call neocomplete#custom#source('snippets_complete', 'rank', 80)

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
    \ let b:neocomplete_sources = ['file', 'vim']
  augroup END

  call extend(s:neocompl_vim_completefuncs, {
  \ 'NeoCompleteDictionaryMakeCache' : 'neocomplete#filetype_complete',
  \ 'NeoCompleteSyntaxMakeCache'     : 'neocomplete#filetype_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" NeoMru: {{{
if s:neobundle_tap('neomru')
  function! neobundle#hooks.on_source(bundle)
    let g:neomru#file_mru_path      = $HOME . '/.local/.cache/neomru/file'
    let g:neomru#directory_mru_path = $HOME . '/.local/.cache/neomru/directory'
    let g:neomru#filename_format    = ':.'
    let g:neomru#do_validate        = 0

    let g:neomru#file_mru_ignore_pattern =
    \ '[/\\]doc[/\\][^/\\]\+\.\%(txt\|\a\ax\)$\|' .
    \ '\.\%(' . join(s:ignore_ext, '\|') . '\)$'
    let g:neomru#directory_mru_ignore_pattern =
    \ join(s:ignore_dir, '\|')
  endfunction

  NXnoremap <Bslash>ue
  \ :<C-U>Unite neomru/file file file/new
  \ -buffer-name=files<CR>
  NXnoremap <Bslash>ud
  \ :<C-U>Unite
  \ menu:directory_current neomru/directory directory directory/new
  \ -buffer-name=files -default-action=lcd<CR>
  NXnoremap <Bslash>uD
  \ :<C-U>Unite
  \ menu:directory_current neomru/directory directory directory/new
  \ -buffer-name=files -default-action=cd<CR>
  NXnoremap <Bslash>u<M-d>
  \ :<C-U>UniteWithBufferDir
  \ menu:directory_file neomru/directory directory directory/new
  \ -buffer-name=files -default-action=lcd<CR>
  NXnoremap <Bslash>u<M-D>
  \ :<C-U>UniteWithBufferDir
  \ menu:directory_file neomru/directory directory directory/new
  \ -buffer-name=files -default-action=cd<CR>

  if get(s:selector_ui, 'edit') == 'unite'
    NXmap <Leader>e <Bslash>ue
  endif
  if get(s:selector_ui, 'chdir') == 'unite'
    NXmap <Leader>d     <Bslash>ud
    NXmap <Leader>D     <Bslash>uD
    NXmap <Leader><M-d> <Bslash>u<M-d>
    NXmap <Leader><M-D> <Bslash>u<M-D>
  endif
endif
"}}}

"------------------------------------------------------------------------------
" NeoSnippet: {{{
if s:neobundle_tap('neosnippet')
  function! neobundle#hooks.on_source(bundle)
    let g:neosnippet#snippets_directory           = $HOME . '/.vim/snippets'
    let g:neosnippet#data_directory               = $HOME . '/.local/.cache/neosnippet'
    let g:neosnippet#disable_select_mode_mappings = 0

    let g:neosnippet#disable_runtime_snippets =
    \ get(g:, 'neosnippet#disable_runtime_snippets', {})
    let g:neosnippet#disable_runtime_snippets._ = 1

    imap <C-K> <Plug>(neosnippet_expand_or_jump)
  endfunction

  smap <C-K> <Plug>(neosnippet_expand_or_jump)
  xmap <C-K> <Plug>(neosnippet_expand_target)

  autocmd MyVimrc InsertLeave *
  \ NeoSnippetClearMarkers

  call extend(s:neocompl_vim_completefuncs, {
  \ 'NeoSnippetEdit'      : 'neosnippet#edit_complete',
  \ 'NeoSnippetMakeCache' : 'neosnippet#filetype_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" OmniSharp: {{{
if s:neobundle_tap('omnisharp')
  function! neobundle#hooks.on_source(bundle)
    let g:OmniSharp_server_path =
    \ a:bundle.path . '/server/OmniSharp/bin/Release/OmniSharp.exe'
    let g:OmniSharp_selector_ui = get(s:selector_ui, 'omnisharp')
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
  \ 'OmniSharp#Complete' : '\.\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Open Browser: {{{
if s:neobundle_tap('open-browser')
  nmap gxgx <Plug>(openbrowser-smart-search)
  nmap gxx gxgx

  call extend(s:neocompl_vim_completefuncs, {
  \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
  \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" Operator Camelize: {{{
if s:neobundle_tap('operator-camelize')
  NXOmap sU <Plug>(operator-camelize)
  NXOmap su <Plug>(operator-decamelize)
  NXOmap s~ <Plug>(operator-camelize-toggle)

  nmap sUU sUsU
  nmap suu susu
  nmap s~~ s~s~
endif
"}}}

"------------------------------------------------------------------------------
" Operator Filled With Blank: {{{
if s:neobundle_tap('operator-filled-with-blank')
  NXOmap s<Space> <Plug>(operator-filled-with-blank)

  nmap s<Space><Space> s<Space>s<Space>
endif
"}}}

"------------------------------------------------------------------------------
" Operator Furround: {{{
if s:neobundle_tap('operator-furround')
  NXOmap sa <Plug>(operator-furround-append-input)
  NXOmap sA <Plug>(operator-furround-append-reg)
  NXOmap sd <Plug>(operator-furround-delete)
  NXOmap sc <Plug>(operator-furround-replace-input)
  NXOmap sC <Plug>(operator-furround-replace-reg)

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
"}}}

"------------------------------------------------------------------------------
" Operator HTML Escape: {{{
if s:neobundle_tap('operator-html-escape')
  NXOmap se <Plug>(operator-html-escape)
  NXOmap sE <Plug>(operator-html-unescape)

  nmap see sese
  nmap sEE sEsE
endif
"}}}

"------------------------------------------------------------------------------
" Operator Open Browser: {{{
if s:neobundle_tap('operator-openbrowser')
  NXOmap gx <Plug>(operator-openbrowser)
endif
"}}}

"------------------------------------------------------------------------------
" Operator Replace: {{{
if s:neobundle_tap('operator-replace')
  NXOmap sr <Plug>(operator-replace)

  nnoremap srr srsr
endif
"}}}

"------------------------------------------------------------------------------
" Operator Reverse: {{{
if s:neobundle_tap('operator-reverse')
  NXOmap sv <Plug>(operator-reverse-text)
  NXOmap sV <Plug>(operator-reverse-lines)

  nmap svv svsv
  nmap sVV sVsV
endif
"}}}

"------------------------------------------------------------------------------
" Operator Search: {{{
if s:neobundle_tap('operator-search')
  NXOmap s/ <Plug>(operator-search)

  nmap s// s/s/
endif
"}}}

"------------------------------------------------------------------------------
" Operator Sequence: {{{
if s:neobundle_tap('operator-sequence')
  NXOmap <expr> s<C-U>
  \ operator#sequence#map("\<Plug>(operator-decamelize)", 'gU')

  nmap s<C-U><C-U> s<C-U>s<C-U>
endif
"}}}

"------------------------------------------------------------------------------
" Operator Shuffle: {{{
if s:neobundle_tap('operator-shuffle')
  NXOmap sS <Plug>(operator-shuffle)

  nmap sSS sSsS
endif
"}}}

"------------------------------------------------------------------------------
" Operator Sort: {{{
if s:neobundle_tap('operator-sort')
  NXOmap ss <Plug>(operator-sort)

  nmap sss ssss
endif
"}}}

"------------------------------------------------------------------------------
" Operator Star: {{{
if s:neobundle_tap('operator-star')
  function! neobundle#hooks.on_source(bundle)
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

  nmap <C-W>*  <SID>(split-nicely)<Plug>(operator-*)
  nmap <C-W>#  <SID>(split-nicely)<Plug>(operator-#)
  nmap <C-W>g* <SID>(split-nicely)<Plug>(operator-g*)
  nmap <C-W>g# <SID>(split-nicely)<Plug>(operator-g#)

  nnoremap <script> **   <SID>*
  nnoremap <script> ##   <SID>#
  nnoremap <script> g*g* <SID>g*
  nnoremap <script> g#g# <SID>g#

  nnoremap <script> <C-W>**   <SID>(split-nicely)<SID>*
  nnoremap <script> <C-W>##   <SID>(split-nicely)<SID>#
  nnoremap <script> <C-W>g*g* <SID>(split-nicely)<SID>g*
  nnoremap <script> <C-W>g#g# <SID>(split-nicely)<SID>g#

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
"}}}

"------------------------------------------------------------------------------
" Operator Suddendeath: {{{
if s:neobundle_tap('operator-suddendeath')
  NXOmap s! <Plug>(operator-suddendeath)

  nmap s!! s!s!
endif
"}}}

"------------------------------------------------------------------------------
" Operator Tabular: {{{
if s:neobundle_tap('operator-tabular')
  function! neobundle#hooks.on_source(bundle)
    call operator#user#define(
    \ 'tabularize',
    \ 'myvimrc#operator_tabularize')
    call operator#user#define(
    \ 'untabularize',
    \ 'myvimrc#operator_untabularize')
  endfunction

  NXOmap st <Plug>(operator-tabularize)
  NXOmap sT <Plug>(operator-untabularize)

  nmap stt stst
  nmap sTT sTsT
endif
"}}}

"------------------------------------------------------------------------------
" Operator Trailingspace Killer: {{{
if s:neobundle_tap('operator-trailingspace-killer')
  NXOmap s$ <Plug>(operator-trailingspace-killer)

  nmap s$$ s$s$
endif
"}}}

"------------------------------------------------------------------------------
" Operator User: {{{
if s:neobundle_tap('operator-user')
  function! neobundle#hooks.on_source(bundle)
    let g:myvimrc#operator_grep_ui = get(s:selector_ui, 'grep')

    call operator#user#define(
    \ 'lgrep',
    \ 'myvimrc#operator_lgrep')
    call operator#user#define(
    \ 'grep',
    \ 'myvimrc#operator_grep')
    call operator#user#define(
    \ 'justify',
    \ 'myvimrc#operator_justify')
  endfunction

  NXOmap sg <Plug>(operator-grep)
  NXOmap sG <Plug>(operator-lgrep)
  NXOmap sJ <Plug>(operator-justify)

  nmap sgg sgsg
  nmap sGG sGsG
  nmap sJJ sJsJ

  nmap sgsg <Leader>g
  nmap sGsG <Leader>G
endif
"}}}

"------------------------------------------------------------------------------
" ParaJump: {{{
if s:neobundle_tap('parajump')
  function! neobundle#hooks.on_source(bundle)
    let g:parajump_no_default_key_mappings = 1

    nmap <SID>(parajump-backward) <Plug>(parajump-backward)
    nmap <SID>(parajump-forward)  <Plug>(parajump-forward)

    inoremap <script> <M-{> <C-O><SID>(parajump-backward)
    inoremap <script> <M-}> <C-O><SID>(parajump-forward)
  endfunction

  NXOmap { <Plug>(parajump-backward)
  NXOmap } <Plug>(parajump-forward)
endif
"}}}

"------------------------------------------------------------------------------
" PartEdit: {{{
if s:neobundle_tap('partedit')
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Partedit' : 'partedit#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" PerlOmni: {{{
if s:neobundle_tap('perlomni')
  function! neobundle#hooks.on_source(bundle)
    if has('win32')
      let $PATH = substitute(a:bundle.path, '/', '\\', 'g') . '\bin;' . $PATH
    else
      let $PATH = a:bundle.path . '/bin:' . $PATH
    endif
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
  \ 'PerlComplete' : '\%(->\|::\)\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Precious: {{{
if s:neobundle_tap('precious')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_precious_no_default_key_mappings = 1
    let g:precious_enable_switchers                = {
    \ 'help' : {'setfiletype' : 0}}
  endfunction

  function! neobundle#hooks.on_post_source(bundle)
    let &g:statusline = substitute(&g:statusline, '%y', '%{Precious_y()}', '')
    let &g:statusline = substitute(&g:statusline, '%Y', '%{Precious_Y()}', '')
  endfunction

  function! Precious_y()
    if empty(&l:filetype)
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
  function! Precious_Y()
    if empty(&l:filetype)
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

  nmap  sR <Plug>(precious-quickrun-op)
  XOmap ax <Plug>(textobj-precious-i)
  XOmap ix <Plug>(textobj-precious-i)
endif
"}}}

"------------------------------------------------------------------------------
" Quickhl: {{{
if s:neobundle_tap('quickhl')
  NXmap  sM <Plug>(quickhl-manual-reset)
  NXOmap sm <Plug>(operator-quickhl-manual-this-motion)

  nmap smm smsm
endif
"}}}

"------------------------------------------------------------------------------
" QuickRun: {{{
if s:neobundle_tap('quickrun')
  function! neobundle#hooks.on_source(bundle)
    let g:quickrun_no_default_key_mappings = 1

    let g:quickrun_config =
    \ get(g:, 'quickrun_config', {})

    call extend(g:quickrun_config, {
    \ '_' : {
    \   'runner' : s:has_vimproc() ? 'vimproc' : 'system',
    \   'runner/vimproc/updatetime' : 100,
    \   'outputter' : 'quickfix'},
    \
    \ 'c' : {
    \   'type' :
    \     s:executable('clang') ? 'c/clang' :
    \     s:executable('gcc')   ? 'c/gcc' :
    \     exists('$VCVARSALL')  ? 'c/vc' :
    \     s:executable('cl')    ? 'c/vc' : ''},
    \ 'c/vc' : {
    \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
    \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
    \   'hook/vcvarsall/bat' : has('win32') ? myvimrc#cmdescape($VCVARSALL) : $VCVARSALL},
    \
    \ 'cpp' : {
    \   'type' :
    \     s:executable('clang++') ? 'cpp/clang++' :
    \     s:executable('g++')     ? 'cpp/g++' :
    \     exists('$VCVARSALL')    ? 'cpp/vc' :
    \     s:executable('cl')      ? 'cpp/vc' : ''},
    \ 'cpp/vc' : {
    \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
    \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
    \   'hook/vcvarsall/bat' : has('win32') ? myvimrc#cmdescape($VCVARSALL) : $VCVARSALL},
    \
    \ 'cs' : {
    \   'type' :
    \     exists('$VCVARSALL') ? 'cs/csc' :
    \     s:executable('csc')  ? 'cs/csc' :
    \     s:executable('dmcs') ? 'cs/dmcs' :
    \     s:executable('smcs') ? 'cs/smcs' :
    \     s:executable('gmcs') ? 'cs/gmcs' :
    \     s:executable('mcs')  ? 'cs/mcs' : ''},
    \ 'cs/csc' : {
    \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
    \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
    \   'hook/vcvarsall/bat' : has('win32') ? myvimrc#cmdescape($VCVARSALL) : $VCVARSALL},
    \
    \ 'vbnet' : {
    \   'type' :
    \     exists('$VCVARSALL') ? 'vbnet/vbc' :
    \     s:executable('vbc')  ? 'vbnet/vbc' : ''},
    \ 'vbnet/vbc' : {
    \   'command' : 'vbc',
    \   'exec' : [
    \     '%c /nologo /out:%s:p:r.exe %s',
    \     '%s:p:r.exe %a'],
    \   'tempfile' : '%{tempname()}.vb',
    \   'hook/sweep/files' : ['%s:p:r.exe'],
    \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
    \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
    \   'hook/vcvarsall/bat' : has('win32') ? myvimrc#cmdescape($VCVARSALL) : $VCVARSALL}})

    nnoremap <expr> <C-C>
    \ quickrun#is_running() ?
    \ ':<C-U>call quickrun#sweep_sessions()<CR>' : '<C-C>'
  endfunction

  function! neobundle#hooks.on_post_source(bundle)
    let location_list_outputter        =
    \ quickrun#outputter#buffered#new()
    let location_list_outputter.config = {
    \ 'errorformat' : '&l:errorformat',
    \ 'open_cmd'    : 'lwindow'}
    function! location_list_outputter.finish(session)
      try
        let errorformat = &l:errorformat
        let &l:errorformat = self.config.errorformat
        lgetexpr self._result
        execute self.config.open_cmd
        for winnr in range(1, winnr('$'))
          if getwinvar(winnr, '&buftype') ==# 'quickfix'
            call setwinvar(winnr, 'quickfix_title', 'quickrun: ' .
            \ join(a:session.commands, ' && '))
            break
          endif
        endfor
      finally
        let &l:errorformat = errorformat
      endtry
    endfunction
    call quickrun#register_outputter(
    \ 'location_list', location_list_outputter)
  endfunction

  if !s:is_enabled_bundle('precious')
    nmap sR <Plug>(quickrun-op)
  endif
  xmap sR  <Plug>(quickrun)
  omap sR  g@
  nmap sRR sRsR

  NXmap <F5> :<C-U>QuickRun<CR>

  call extend(s:neocompl_vim_completefuncs, {
  \ 'QuickRun' : 'quickrun#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" Reanimate: {{{
if s:neobundle_tap('reanimate')
  function! neobundle#hooks.on_source(bundle)
    let g:reanimate_save_dir = $HOME . '/.local/reanimate'
  endfunction

  NXnoremap <Bslash>us  <Nop>
  NXnoremap <Bslash>usl :<C-U>Unite reanimate
  \ -buffer-name=files -default-action=reanimate_load<CR>
  NXnoremap <Bslash>uss :<C-U>Unite reanimate
  \ -buffer-name=files -default-action=reanimate_save<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Ref: {{{
if s:neobundle_tap('ref')
  function! neobundle#hooks.on_source(bundle)
    let g:ref_no_default_key_mappings = 1
    let g:ref_cache_dir               = $HOME . '/.local/.cache/vim-ref'
  endfunction

  NXmap K <Plug>(ref-keyword)

  call extend(s:neocompl_vim_completefuncs, {
  \ 'Ref' : 'ref#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" RengBang: {{{
if s:neobundle_tap('rengbang')
  function! neobundle#hooks.on_source(bundle)
    call operator#user#define_ex_command(
    \ 'rengbang-confirm',
    \ 'RengBangConfirm')
  endfunction

  NXOmap s+ <Plug>(operator-rengbang-confirm)

  nmap s++ s+s+
endif
"}}}

"------------------------------------------------------------------------------
" Repeat: {{{
if s:neobundle_tap('repeat')
  function! neobundle#hooks.on_source(bundle)
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
"}}}

"------------------------------------------------------------------------------
" Scratch: {{{
if s:neobundle_tap('scratch')
  function! neobundle#hooks.on_source(bundle)
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
"}}}

"------------------------------------------------------------------------------
" SmartWord: {{{
if s:neobundle_tap('smartword')
  function! neobundle#hooks.on_source(bundle)
    nmap <SID>(smartword-w)  <Plug>(smartword-w)
    nmap <SID>(smartword-b)  <Plug>(smartword-b)
    nmap <SID>(smartword-e)  <Plug>(smartword-e)
    nmap <SID>(smartword-ge) <Plug>(smartword-ge)

    inoremap <script> <M-w>      <C-O><SID>(smartword-w)
    inoremap <script> <M-b>      <C-O><SID>(smartword-b)
    inoremap <script> <M-e>      <C-O><SID>(smartword-e)
    inoremap <script> <M-g><M-e> <C-O><SID>(smartword-ge)
  endfunction

  NXOmap w  <Plug>(smartword-w)
  NXOmap b  <Plug>(smartword-b)
  NXOmap e  <Plug>(smartword-e)
  NXOmap ge <Plug>(smartword-ge)
endif
"}}}

"------------------------------------------------------------------------------
" Snowdrop: {{{
if s:neobundle_tap('snowdrop')
  function! neobundle#hooks.on_source(bundle)
    if has('win64')
      let g:snowdrop#libclang_directory = $PROGRAMFILES . '/LLVM/bin'
      let g:snowdrop#libclang_file      = 'libclang.dll'
    elseif has('win32')
      let g:snowdrop#libclang_directory = s:programfiles_x86 . '/LLVM/bin'
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
"}}}

"------------------------------------------------------------------------------
" SubMode: {{{
if s:neobundle_tap('submode')
  function! neobundle#hooks.on_source(bundle)
    let g:submode_keep_leaving_key = 1

    call submode#enter_with(
    \ 'undo/br', 'n', '', '<Plug>(submode:undo/br:-)', 'g-')
    call submode#enter_with(
    \ 'undo/br', 'n', '', '<Plug>(submode:undo/br:+)', 'g+')
    call submode#map(
    \ 'undo/br', 'n', '', '-', 'g-')
    call submode#map(
    \ 'undo/br', 'n', '', '+', 'g+')

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
    \ 'sq/fold', 'nx', '', '<Plug>(submode:sq/fold:[)', '[z')
    call submode#enter_with(
    \ 'sq/fold', 'nx', '', '<Plug>(submode:sq/fold:])', ']z')
    call submode#map(
    \ 'sq/fold', 'nx', '', '[', '[z')
    call submode#map(
    \ 'sq/fold', 'nx', '', ']', ']z')

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
    \ 'move/mark', 'nx', '', '<Up>', '[`')
    call submode#map(
    \ 'move/mark', 'nx', '', 'j', ']`')
    call submode#map(
    \ 'move/mark', 'nx', '', 'k', '[`')

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

  if !s:is_enabled_bundle('repeat')
    nmap g- <Plug>(submode:undo/br:-)
    nmap g+ <Plug>(submode:undo/br:+)
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
  NXmap [z           <Plug>(submode:sq/fold:[)
  NXmap ]z           <Plug>(submode:sq/fold:])
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
"}}}

"------------------------------------------------------------------------------
" Switch: {{{
if s:neobundle_tap('switch')
  function! neobundle#hooks.on_source(bundle)
    let g:switch_mapping            = ''
    let g:switch_no_builtins        = 1
    let g:switch_custom_definitions = [
    \ ['TRUE', 'FALSE'], ['True', 'False'], ['true', 'false'],
    \ ['ENABLE', 'DISABLE'], ['Enable', 'Disable'], ['enable', 'disable']]

    let g:switch_increment_definitions = []
    let g:switch_decrement_definitions = []

    for l in [
    \ ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY',
    \  'THURSDAY', 'FRIDAY', 'SATURDAY'],
    \ ['Sunday', 'Monday', 'Tuesday', 'Wednesday',
    \  'Thursday', 'Friday', 'Saturday'],
    \ ['sunday', 'monday', 'tuesday', 'wednesday',
    \  'thursday', 'friday', 'saturday'],
    \ ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY',
    \  'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'],
    \ ['January', 'February', 'March', 'April', 'May', 'June', 'July',
    \  'August', 'September', 'October', 'November', 'December'],
    \ ['january', 'february', 'march', 'april', 'may', 'june', 'july',
    \  'august', 'september', 'october', 'november', 'december']]
      let inc = {}
      let dec = {}
      for i in range(len(l))
        let s1 = l[i]
        let s2 = get(l, i + 1, l[0])
        if len(s1) > 3
          call extend(inc, {'\C\<' . s1[:2] . '\>' : s2[:2]})
        endif
        if len(s2) > 3
          call extend(dec, {'\C\<' . s2[:2] . '\>' : s1[:2]})
        endif
      endfor
      call add(g:switch_increment_definitions, inc)
      call add(g:switch_decrement_definitions, dec)
      call add(g:switch_increment_definitions, l)
      call add(g:switch_decrement_definitions, reverse(copy(l)))
    endfor

    for l in [
    \ ['ZEROTH', 'FIRST', 'SECOND',  'THIRD',  'FOURTH',
    \  'FIFTH',  'SIXTH', 'SEVENTH', 'EIGHTH', 'NINTH',
    \  'TENTH',      'ELEVENTH',   'TWELFTH',   'THIRTEENTH',
    \  'FOURTEENTH', 'FIFTEENTH',  'SIXTEENTH', 'SEVENTEENTH',
    \  'EIGHTEENTH', 'NINETEENTH', 'TWENTIETH'],
    \ ['Zeroth', 'First', 'Second',  'Third',  'Fourth',
    \  'Fifth',  'Sixth', 'Seventh', 'Eighth', 'Ninth',
    \  'Tenth',      'Eleventh',   'Twelfth',   'Thirteenth',
    \  'Fourteenth', 'Fifteenth',  'Sixteenth', 'Seventeenth',
    \  'Eighteenth', 'Nineteenth', 'Twentieth'],
    \ ['zeroth', 'first', 'second',  'third',  'fourth',
    \  'fifth',  'sixth', 'seventh', 'eighth', 'ninth',
    \  'tenth',      'eleventh',   'twelfth',   'thirteenth',
    \  'fourteenth', 'fifteenth',  'sixteenth', 'seventeenth',
    \  'eighteenth', 'nineteenth', 'twentieth']]
      call add(g:switch_increment_definitions, l)
      call add(g:switch_decrement_definitions, reverse(copy(l)))
    endfor

    call extend(g:switch_increment_definitions, [{
    \ '\C\(-\=\d\+\)\%(TH\|ST\|ND\|RD\)' :
    \   '\=toupper(call("myvimrc#ordinal", [submatch(1) + 1]))',
    \ '\C\(-\=\d\+\)\%(th\|st\|nd\|rd\)' :
    \   '\=tolower(call("myvimrc#ordinal", [submatch(1) + 1]))'}])
    call extend(g:switch_decrement_definitions, [{
    \ '\C\(-\=\d\+\)\%(TH\|ST\|ND\|RD\)' :
    \   '\=toupper(call("myvimrc#ordinal", [submatch(1) - 1]))',
    \ '\C\(-\=\d\+\)\%(th\|st\|nd\|rd\)' :
    \   '\=tolower(call("myvimrc#ordinal", [submatch(1) - 1]))'}])

    command! -bar
    \ SwitchIncrement
    \ call myvimrc#switch(1)
    command! -bar
    \ SwitchDecrement
    \ call myvimrc#switch(0)
  endfunction

  nnoremap <C-A> :<C-U>SwitchIncrement<CR>
  nnoremap <C-X> :<C-U>SwitchDecrement<CR>

  autocmd MyVimrc VimEnter,BufNewFile,BufRead *
  \ let b:switch_no_builtins = 1
endif
"}}}

"------------------------------------------------------------------------------
" Tabpage Buffer Misc: {{{
if s:neobundle_tap('tabpagebuffer-misc')
  function! neobundle#hooks.on_source(bundle)
    let g:tabpagebuffer#command#bdelete_keeptabpage = 1
    let g:ctrlp#tabpagebuffer#visible_all_buftype   = 1
  endfunction

  if get(s:selector_ui, 'buffers') == 'tabpagebuffer'
    NXnoremap <Leader>B :<C-U>TpbBuffers<CR>
  endif
  if get(s:selector_ui, 'bdelete') == 'tabpagebuffer'
    NXnoremap <Leader>q :<C-U>TpbDelete<CR>
    NXnoremap <Leader>Q :<C-U>TpbDeleteAll<CR>
  endif

  if s:is_enabled_bundle('ctrlp')
    NXnoremap <Bslash>pb :<C-U>CtrlPTabpageBuffer<CR>

    if get(s:selector_ui, 'buffer') == 'ctrlp'
      NXmap <Leader>b <Bslash>pb
    endif
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
  \ 'tun[hide]'    : 'TTpbUnhide',
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
  \ '_tun[hide]'    : 'tab unhide',
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
"}}}

"------------------------------------------------------------------------------
" TComment: {{{
if s:neobundle_tap('tcomment')
  function! neobundle#hooks.on_source(bundle)
    let g:tcommentMaps = 0

    call operator#user#define(
    \ 'tcomment',
    \ 'tcomment#Operator',
    \ 'call myvimrc#operator_tcomment_setup({})')
    call operator#user#define(
    \ 'tcomment-col=1',
    \ 'tcomment#Operator',
    \ 'call myvimrc#operator_tcomment_setup({"col" : 1})')

    call operator#user#define(
    \ 'tcomment-block',
    \ 'myvimrc#operator_tcomment_block',
    \ 'call myvimrc#operator_tcomment_setup({})')
    call operator#user#define(
    \ 'tcomment-block-col=1',
    \ 'myvimrc#operator_tcomment_block',
    \ 'call myvimrc#operator_tcomment_setup({"col" : 1})')
  endfunction

  function! neobundle#hooks.on_post_source(bundle)
    call tcomment#DefineType('c',         '// %s', {}, 1)
    call tcomment#DefineType('d',         '// %s')
    call tcomment#DefineType('d_inline',  g:tcommentInlineC)
    call tcomment#DefineType('d_block',   g:tcommentBlockC)
    call tcomment#DefineType('gitconfig', '# %s')
    call tcomment#DefineType('mayu',      '# %s')
    call tcomment#DefineType('nyaos',     '# %s')
    call tcomment#DefineType('screen',    '# %s')
    call tcomment#DefineType('snippet',   '# %s')
    call tcomment#DefineType('tmux',      '# %s')
    call tcomment#DefineType('vbnet',     "' %s")
    call tcomment#DefineType('vimshrc',   '# %s')
    call tcomment#DefineType('wsh',       "' %s")
    call tcomment#DefineType('z80',       '; %s')
    call tcomment#DefineType('zimbu',     '# %s')
    call tcomment#DefineType('zsh',       '# %s')
  endfunction

  NXOmap gc     <Plug>(operator-tcomment)
  NXOmap gC     <Plug>(operator-tcomment-block)
  NXOmap g<M-c> <Plug>(operator-tcomment-col=1)
  NXOmap g<M-C> <Plug>(operator-tcomment-block-col=1)

  nmap gcc         gcgc
  nmap gCC         gCgC
  nmap g<M-c><M-c> g<M-c>g<M-c>
  nmap g<M-C><M-C> g<M-C>g<M-C>

  call extend(s:neocompl_vim_completefuncs, {
  \ 'TComment'            : 'tcomment#CompleteArgs',
  \ 'TCommentAs'          : 'tcomment#Complete',
  \ 'TCommentRight'       : 'tcomment#CompleteArgs',
  \ 'TCommentBlock'       : 'tcomment#CompleteArgs',
  \ 'TCommentInline'      : 'tcomment#CompleteArgs',
  \ 'TCommentMaybeInline' : 'tcomment#CompleteArgs'})
endif
"}}}

"------------------------------------------------------------------------------
" Tern: {{{
if s:neobundle_tap('tern')
  call extend(s:neocompl_force_omni_patterns, {
  \ 'tern#Complete' : '\.\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" TextManipilate: {{{
if s:neobundle_tap('textmanip')
  function! neobundle#hooks.on_source(bundle)
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

  NXOmap <M-p> <Plug>(textmanip-duplicate-down)
  NXOmap <M-P> <Plug>(textmanip-duplicate-up)

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
"}}}

"------------------------------------------------------------------------------
" TextObj Between: {{{
if s:neobundle_tap('textobj-between')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_between_no_default_key_mappings = 1
  endfunction

  XOmap af <Plug>(textobj-between-a)
  XOmap if <Plug>(textobj-between-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Comment: {{{
if s:neobundle_tap('textobj-comment')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  XOmap ac <Plug>(textobj-comment-a)
  XOmap ic <Plug>(textobj-comment-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Continuous Line: {{{
if s:neobundle_tap('textobj-continuous-line')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_continuous_line_no_default_key_mappings = 1
    let g:textobj_continuous_line_no_default_mappings     = 1
  endfunction

  " XOmap a<Bslash> <Plug>(textobj-continuous-cpp-a)
  " XOmap a<Bslash> <Plug>(textobj-continuous-python-a)
  " XOmap a<Bslash> <Plug>(textobj-continuous-vim-a)
  " XOmap i<Bslash> <Plug>(textobj-continuous-cpp-i)
  " XOmap i<Bslash> <Plug>(textobj-continuous-python-i)
  " XOmap i<Bslash> <Plug>(textobj-continuous-vim-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj DateTime: {{{
if s:neobundle_tap('textobj-datetime')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_datetime_no_default_key_mappings = 1
  endfunction

  XOnoremap ad <Nop>
  XOmap ada <Plug>(textobj-datetime-auto)
  XOmap add <Plug>(textobj-datetime-date)
  XOmap adD <Plug>(textobj-datetime-full)
  XOmap adt <Plug>(textobj-datetime-time)
  XOmap adT <Plug>(textobj-datetime-tz)

  XOnoremap id <Nop>
  XOmap ida <Plug>(textobj-datetime-auto)
  XOmap idd <Plug>(textobj-datetime-date)
  XOmap idD <Plug>(textobj-datetime-full)
  XOmap idt <Plug>(textobj-datetime-time)
  XOmap idT <Plug>(textobj-datetime-tz)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Diff: {{{
if s:neobundle_tap('textobj-diff')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_diff_no_default_key_mappings = 1
  endfunction

  " NXOmap [c <Plug>(textobj-diff-hunk-p)
  " NXOmap ]c <Plug>(textobj-diff-hunk-n)
  " NXOmap [C <Plug>(textobj-diff-hunk-P)
  " NXOmap ]C <Plug>(textobj-diff-hunk-N)
  "
  " NXOmap [<M-c> <Plug>(textobj-diff-file-p)
  " NXOmap ]<M-c> <Plug>(textobj-diff-file-n)
  " NXOmap [<M-C> <Plug>(textobj-diff-file-P)
  " NXOmap ]<M-C> <Plug>(textobj-diff-file-N)
  "
  " XOnoremap ad <Nop>
  " XOmap adh <Plug>(textobj-diff-hunk)
  " XOmap adf <Plug>(textobj-diff-file)
  "
  " XOnoremap id <Nop>
  " XOmap idh <Plug>(textobj-diff-hunk)
  " XOmap idf <Plug>(textobj-diff-file)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Entrie: {{{
if s:neobundle_tap('textobj-entire')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  XOmap ae <Plug>(textobj-entire-a)
  XOmap ie <Plug>(textobj-entire-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj EnclosedSyntax: {{{
if s:neobundle_tap('textobj-enclosedsyntax')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_enclosedsyntax_no_default_key_mappings = 1
  endfunction

  " XOmap aq <Plug>(textobj-enclosedsyntax-a)
  " XOmap iq <Plug>(textobj-enclosedsyntax-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Fold: {{{
if s:neobundle_tap('textobj-fold')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_fold_no_default_key_mappings = 1
  endfunction

  XOmap az <Plug>(textobj-fold-a)
  XOmap iz <Plug>(textobj-fold-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Function: {{{
if s:neobundle_tap('textobj-function')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_function_no_default_key_mappings = 1
  endfunction

  " XOmap aF <Plug>(textobj-function-a)
  " XOmap iF <Plug>(textobj-function-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Ifdef: {{{
if s:neobundle_tap('textobj-ifdef')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction

  " XOmap a# <Plug>(textobj-ifdef-a)
  " XOmap i# <Plug>(textobj-ifdef-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj IndentBlock: {{{
if s:neobundle_tap('textobj-indblock')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_indblock_no_default_key_mappings = 1
  endfunction

  XOmap ao <Plug>(textobj-indblock-a)
  XOmap io <Plug>(textobj-indblock-i)
  XOmap aO <Plug>(textobj-indblock-same-a)
  XOmap iO <Plug>(textobj-indblock-same-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Indent: {{{
if s:neobundle_tap('textobj-indent')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_indent_no_default_key_mappings = 1
  endfunction

  XOmap ai <Plug>(textobj-indent-a)
  XOmap ii <Plug>(textobj-indent-i)
  XOmap aI <Plug>(textobj-indent-same-a)
  XOmap iI <Plug>(textobj-indent-same-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj JaBraces: {{{
if s:neobundle_tap('textobj-jabraces')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_jabraces_no_default_key_mappings = 1
  endfunction

  XOnoremap aj <Nop>
  XOmap aj( <Plug>(textobj-jabraces-parens-a)
  XOmap aj) <Plug>(textobj-jabraces-parens-a)
  XOmap aj{ <Plug>(textobj-jabraces-braces-a)
  XOmap aj} <Plug>(textobj-jabraces-braces-a)
  XOmap aj[ <Plug>(textobj-jabraces-brackets-a)
  XOmap aj] <Plug>(textobj-jabraces-brackets-a)
  XOmap aj< <Plug>(textobj-jabraces-angles-a)
  XOmap aj> <Plug>(textobj-jabraces-angles-a)
  XOmap aja <Plug>(textobj-jabraces-angles-a)
  XOmap ajA <Plug>(textobj-jabraces-double-angles-a)
  XOmap ajk <Plug>(textobj-jabraces-kakko-a)
  XOmap ajK <Plug>(textobj-jabraces-double-kakko-a)
  XOmap ajy <Plug>(textobj-jabraces-yama-kakko-a)
  XOmap ajY <Plug>(textobj-jabraces-double-yama-kakko-a)
  XOmap ajt <Plug>(textobj-jabraces-kikkou-kakko-a)
  XOmap ajs <Plug>(textobj-jabraces-sumi-kakko-a)

  XOnoremap ij <Nop>
  XOmap ij( <Plug>(textobj-jabraces-parens-i)
  XOmap ij) <Plug>(textobj-jabraces-parens-i)
  XOmap ij{ <Plug>(textobj-jabraces-braces-i)
  XOmap ij} <Plug>(textobj-jabraces-braces-i)
  XOmap ij[ <Plug>(textobj-jabraces-brackets-i)
  XOmap ij] <Plug>(textobj-jabraces-brackets-i)
  XOmap ij< <Plug>(textobj-jabraces-angles-i)
  XOmap ij> <Plug>(textobj-jabraces-angles-i)
  XOmap ija <Plug>(textobj-jabraces-angles-i)
  XOmap ijA <Plug>(textobj-jabraces-double-angles-i)
  XOmap ijk <Plug>(textobj-jabraces-kakko-i)
  XOmap ijK <Plug>(textobj-jabraces-double-kakko-i)
  XOmap ijy <Plug>(textobj-jabraces-yama-kakko-i)
  XOmap ijY <Plug>(textobj-jabraces-double-yama-kakko-i)
  XOmap ijt <Plug>(textobj-jabraces-kikkou-kakko-i)
  XOmap ijs <Plug>(textobj-jabraces-sumi-kakko-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj LastPat: {{{
if s:neobundle_tap('textobj-lastpat')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_lastpat_no_default_key_mappings = 1
  endfunction

  if !s:has_patch(7, 3, 610)
    XOmap gn <Plug>(textobj-lastpat-n)
    XOmap gN <Plug>(textobj-lastpat-N)
  endif
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Line: {{{
if s:neobundle_tap('textobj-line')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  XOmap al <Plug>(textobj-line-a)
  XOmap il <Plug>(textobj-line-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj MultiBlock: {{{
if s:neobundle_tap('textobj-multiblock')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_multiblock_no_default_key_mappings = 1
  endfunction

  XOmap ab <Plug>(textobj-multiblock-a)
  XOmap ib <Plug>(textobj-multiblock-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj MultiTextObj: {{{
if s:neobundle_tap('textobj-multitextobj')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_multitextobj_textobjects_group_a = {
    \ 'doublequotes' : [
    \   {'textobj' : 'a"',  'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'singlequotes' : [
    \   {'textobj' : "a'", 'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'backquotes' : [
    \   {'textobj' : 'a`',  'is_cursor_in' : 1, 'noremap' : 1}],
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
    \    "\<Plug>(textobj-jabraces-sumi-kakko-a)"]]}
    let g:textobj_multitextobj_textobjects_group_i = {
    \ 'doublequotes' : [
    \   {'textobj' : 'i"',  'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'singlequotes' : [
    \   {'textobj' : "i'", 'is_cursor_in' : 1, 'noremap' : 1}],
    \ 'backquotes' : [
    \   {'textobj' : 'i`',  'is_cursor_in' : 1, 'noremap' : 1}],
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
    \    "\<Plug>(textobj-jabraces-sumi-kakko-i)"]]}
  endfunction

  XOmap <expr> a" textobj#multitextobj#mapexpr_a('doublequotes')
  XOmap <expr> i" textobj#multitextobj#mapexpr_i('doublequotes')
  XOmap <expr> a' textobj#multitextobj#mapexpr_a('singlequotes')
  XOmap <expr> i' textobj#multitextobj#mapexpr_i('singlequotes')
  XOmap <expr> a` textobj#multitextobj#mapexpr_a('backquotes')
  XOmap <expr> i` textobj#multitextobj#mapexpr_i('backquotes')
  XOmap <expr> aB textobj#multitextobj#mapexpr_a('jabraces')
  XOmap <expr> iB textobj#multitextobj#mapexpr_i('jabraces')
endif
"}}}

"------------------------------------------------------------------------------
" TextObj MotionMotion: {{{
if s:neobundle_tap('textobj-motionmotion')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_motionmotion_no_default_key_mappings = 1
  endfunction

  XOmap am <Plug>(textobj-motionmotion-a)
  XOmap im <Plug>(textobj-motionmotion-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Parameter: {{{
if s:neobundle_tap('textobj-parameter')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  XOmap a, <Plug>(textobj-parameter-a)
  XOmap i, <Plug>(textobj-parameter-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj PHP: {{{
if s:neobundle_tap('textobj-php')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_php_no_default_key_mappings = 1
  endfunction

  " XOmap aP <Plug>(textobj-php-phptag-a)
  " XOmap aa <Plug>(textobj-php-phparray-a)
  " XOmap iP <Plug>(textobj-php-phptag-i)
  " XOmap ia <Plug>(textobj-php-phparray-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj PostExpr: {{{
if s:neobundle_tap('textobj-postexpr')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_postexpr_no_default_key_mappings = 1
  endfunction

  XOmap aX <Plug>(textobj-postexpr-a)
  XOmap iX <Plug>(textobj-postexpr-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Python: {{{
if s:neobundle_tap('textobj-python')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_python_no_default_key_mappings = 1
  endfunction

  " XOmap aF <Plug>(textobj-python-function-a)
  " XOmap aC <Plug>(textobj-python-class-a)
  " XOmap iF <Plug>(textobj-python-function-i)
  " XOmap iC <Plug>(textobj-python-class-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Ruby: {{{
if s:neobundle_tap('textobj-ruby')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_ruby_no_default_key_mappings = 1
    let g:textobj_ruby_more_mappings           = 1
  endfunction

  " XOmap aC <Plug>(textobj-ruby-definition-a)
  " XOmap iC <Plug>(textobj-ruby-definition-i)
  " XOmap ar <Plug>(textobj-ruby-any-a)
  " XOmap ir <Plug>(textobj-ruby-any-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Sigil: {{{
if s:neobundle_tap('textobj-sigil')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction

  " XOmap ag <Plug>(textobj-sigil-a)
  " XOmap ig <Plug>(textobj-sigil-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Space: {{{
if s:neobundle_tap('textobj-space')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_space_no_default_key_mappings = 1
  endfunction

  XOmap aS <Plug>(textobj-space-a)
  XOmap iS <Plug>(textobj-space-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Syntax: {{{
if s:neobundle_tap('textobj-syntax')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  XOmap ay <Plug>(textobj-syntax-a)
  XOmap iy <Plug>(textobj-syntax-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Url: {{{
if s:neobundle_tap('textobj-url')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  XOmap au <Plug>(textobj-url-a)
  XOmap iu <Plug>(textobj-url-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj WordInWord: {{{
if s:neobundle_tap('textobj-wiw')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_wiw_no_default_key_mappings = 1
  endfunction

  NXOmap <M-w>      <Plug>(textobj-wiw-n)
  NXOmap <M-b>      <Plug>(textobj-wiw-p)
  NXOmap <M-e>      <Plug>(textobj-wiw-N)
  NXOmap <M-g><M-e> <Plug>(textobj-wiw-P)

  XOmap a<M-w> <Plug>(textobj-wiw-a)
  XOmap i<M-w> <Plug>(textobj-wiw-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Word Column: {{{
if s:neobundle_tap('textobj-word-column')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_wordcolumn_no_default_key_mappings = 1
  endfunction

  XOmap av <Plug>(textobj-wordcolumn-w-a)
  XOmap aV <Plug>(textobj-wordcolumn-W-a)
  XOmap iv <Plug>(textobj-wordcolumn-w-i)
  XOmap iV <Plug>(textobj-wordcolumn-W-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj XML Attribute: {{{
if s:neobundle_tap('textobj-xml-attribute')
  function! neobundle#hooks.on_source(bundle)
    let g:textobj_xmlattribute_no_default_key_mappings = 1
  endfunction

  " XOmap aa <Plug>(textobj-xmlattribute-xmlattribute)
  " XOmap ia <Plug>(textobj-xmlattribute-xmlattributenospace)
endif
"}}}

"------------------------------------------------------------------------------
" UndoTree: {{{
if s:neobundle_tap('undotree')
  function! neobundle#hooks.on_source(bundle)
    let g:undotree_SetFocusWhenToggle = 1
  endfunction

  if get(s:selector_ui, 'undo') == 'undotree'
    NXnoremap <Leader>u :<C-U>UndotreeToggle<CR>
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Unified Diff: {{{
if s:neobundle_tap('unified-diff')
  set diffexpr=unified_diff#diffexpr()

  if &diff && has('vim_starting')
    call neobundle#config({'lazy' : 0})
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Unite: {{{
if s:neobundle_tap('unite')
  function! neobundle#hooks.on_source(bundle)
    let g:unite_data_directory             = $HOME . '/.local/.cache/unite'
    let g:unite_source_history_yank_enable = !s:is_enabled_bundle('yankround')
    let g:unite_source_grep_max_candidates = 1000
    let g:unite_source_grep_encoding       = 'utf-8'
    let g:unite_source_rec_min_cache_files = -1
    let g:unite_source_rec_max_cache_files = 10000
    let g:unite_source_rec_unit            = 1000

    if !has('win32') && s:executable('find')
      let g:unite_source_rec_async_command =
      \ ['find', '-L']
    elseif s:executable('files')
      let g:unite_source_rec_async_command =
      \ ['files', s:cpucores() > 1 ? '-A' : '']
    endif

    if s:executable('jvgrep')
      let g:unite_source_grep_command       = 'jvgrep'
      let g:unite_source_grep_recursive_opt = '-R'
      let g:unite_source_grep_default_opts  = '-n'
    elseif s:executable('grep')
      let g:unite_source_grep_command       = 'grep'
      let g:unite_source_grep_recursive_opt = '-r'
      let g:unite_source_grep_default_opts  = '-Hn'
    endif

    let g:unite_source_menu_menus =
    \ get(g:, 'unite_source_menu_menus', {})

    let g:unite_source_menu_menus.directory_current = {
    \ 'description' : 'Current directory.'}
    let g:unite_source_menu_menus.directory_current.candidates = {
    \ '_' : ''}
    function! g:unite_source_menu_menus.directory_current.map(key, value)
      return {
      \ 'word' : './',
      \ 'kind' : 'directory',
      \ 'action__directory' : getcwd()}
    endfunction

    let g:unite_source_menu_menus.directory_file = {
    \ 'description' : 'File directory.'}
    let g:unite_source_menu_menus.directory_file.candidates = {
    \ '_' : ''}
    function! g:unite_source_menu_menus.directory_file.map(key, value)
      let d = myvimrc#expand('%:p:h')
      return {
      \ 'word' : d . '/',
      \ 'kind' : 'directory',
      \ 'action__directory' : d}
    endfunction

    let g:unite_source_menu_menus.set_ff = {
    \ 'description' : 'Change file format option.'}
    let g:unite_source_menu_menus.set_ff.command_candidates = [
    \ ['unix', 'FfUnix'],
    \ ['dos',  'FfDos'],
    \ ['mac',  'FfMac']]

    if has('multi_byte')
      let g:unite_source_menu_menus.set_fenc = {
      \ 'description' : 'Change file encding option.'}
      let g:unite_source_menu_menus.set_fenc.command_candidates = [
      \ ['utf-8',    'FencUtf8'],
      \ ['utf-16le', 'FencUtf16le'],
      \ ['utf-16',   'FencUtf16'],
      \ ['cp932',    'FencCp932'],
      \ ['euc-jp',   'FencEucjp']]
      if s:has_jisx0213
        call extend(g:unite_source_menu_menus.set_fenc.command_candidates, [
        \ ['euc-jisx0213',  'FencEucJisx0213'],
        \ ['iso-2022-jp-3', 'FencIso2022jp']])
      else
        call extend(g:unite_source_menu_menus.set_fenc.command_candidates, [
        \ ['iso-2022-jp', 'FencIso2022jp']])
      endif

      let g:unite_source_menu_menus.edit_enc = {
      \ 'description' : 'Open with a specific character code again.'}
      let g:unite_source_menu_menus.edit_enc.command_candidates = [
      \ ['utf-8',    'EditUtf8'],
      \ ['utf-16le', 'EditUtf16le'],
      \ ['utf-16',   'EditUtf16'],
      \ ['cp932',    'EditCp932'],
      \ ['euc-jp',   'EditEucjp']]
      if s:has_jisx0213
        call extend(g:unite_source_menu_menus.edit_enc.command_candidates, [
        \ ['euc-jisx0213',  'EditEucJisx0213'],
        \ ['iso-2022-jp-3', 'EditIso2022jp']])
      else
        call extend(g:unite_source_menu_menus.edit_enc.command_candidates, [
        \ ['iso-2022-jp', 'EditIso2022jp']])
      endif
    endif

    call unite#custom#profile('default', 'context', {
    \ 'split'          : 0,
    \ 'candidate_icon' : '-',
    \ 'marked_icon'    : '+',
    \ 'hide_icon'      : 0,
    \ 'start_insert'   : 1})
    call unite#custom#source(
    \ 'file,file_rec,file_rec/async', 'ignore_globs',
    \ map(copy(s:ignore_ext), '"*." . v:val'))
    call unite#custom#source(
    \ 'directory,directory_rec,directory_rec/async', 'ignore_globs',
    \ s:ignore_dir)
  endfunction

  NXnoremap <Bslash>u <Nop>
  NXnoremap <script> <Bslash>uu <SID>:<C-U>Unite<Space>

  NXnoremap <Bslash>u<CR>
  \ :<C-U>Unite menu:set_ff
  \ -buffer-name=files<CR>
  if has('multi_byte')
    NXnoremap <Bslash>uF
    \ :<C-U>Unite menu:edit_enc
    \ -buffer-name=files<CR>
    NXnoremap <Bslash>uf
    \ :<C-U>Unite menu:set_fenc
    \ -buffer-name=files<CR>
  endif

  NXnoremap <Bslash>ub
  \ :<C-U>Unite buffer_tab
  \ -buffer-name=files<CR>
  NXnoremap <Bslash>uB
  \ :<C-U>Unite buffer
  \ -buffer-name=files<CR>
  NXnoremap <Bslash>uw
  \ :<C-U>Unite window
  \ -buffer-name=files<CR>
  NXnoremap <Bslash>uW
  \ :<C-U>Unite window:all
  \ -buffer-name=files<CR>
  NXnoremap <Bslash>ut
  \ :<C-U>Unite tab
  \ -buffer-name=files<CR>

  NXnoremap <Bslash>uj
  \ :<C-U>Unite change
  \ -buffer-name=register<CR>
  NXnoremap <Bslash>uJ
  \ :<C-U>Unite jump
  \ -buffer-name=register<CR>

  if &grepprg == 'internal'
    nnoremap <Bslash>ug
    \ :<C-U>Unite vimgrep
    \ -buffer-name=grep<CR>
  else
    nnoremap <Bslash>ug
    \ :<C-U>Unite grep
    \ -buffer-name=grep<CR>
  endif
  NXnoremap <Bslash>uG
  \ :<C-U>UniteResume grep<CR>

  NXnoremap <Bslash>u/
  \ :<C-U>Unite line
  \ -buffer-name=search<CR>
  NXnoremap <Bslash>u?
  \ :<C-U>Unite line:backward
  \ -buffer-name=search<CR>
  NXnoremap <Bslash>u*
  \ :<C-U>UniteWithCursorWord line
  \ -buffer-name=search -no-start-insert<CR>
  NXnoremap <Bslash>u#
  \ :<C-U>UniteWithCursorWord line:backward
  \ -buffer-name=search -no-start-insert<CR>
  NXnoremap <Bslash>un
  \ :<C-U>UniteResume search<CR>

  if get(s:selector_ui, 'buffer') == 'unite'
    NXmap <Leader>b <Bslash>ub
  endif
  if get(s:selector_ui, 'tabnext') == 'unite'
    NXmap <Leader>t <Bslash>ut
  endif
  if get(s:selector_ui, 'changes') == 'unite'
    NXmap <Leader>j <Bslash>uj
  endif
  if get(s:selector_ui, 'jumps') == 'unite'
    NXmap <Leader>J <Bslash>uJ
  endif
  if get(s:selector_ui, 'grep') == 'unite'
    NXmap <Leader>g <Bslash>ug
    NXmap <Leader>G <Bslash>uG
  endif

  if !s:is_enabled_bundle('neomru')
    NXnoremap <Bslash>ue
    \ :<C-U>Unite file file/new
    \ -buffer-name=files<CR>
    NXnoremap <Bslash>ud
    \ :<C-U>Unite
    \ menu:directory_current directory directory/new
    \ -buffer-name=files -default-action=lcd<CR>
    NXnoremap <Bslash>uD
    \ :<C-U>Unite
    \ menu:directory_current directory directory/new
    \ -buffer-name=files -default-action=cd<CR>
    NXnoremap <Bslash>u<M-d>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file directory directory/new
    \ -buffer-name=files -default-action=lcd<CR>
    NXnoremap <Bslash>u<M-D>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file directory directory/new
    \ -buffer-name=files -default-action=cd<CR>

    if get(s:selector_ui, 'edit') == 'unite'
      NXmap <Leader>e <Bslash>ue
    endif
    if get(s:selector_ui, 'chdir') == 'unite'
      NXmap <Leader>d     <Bslash>ud
      NXmap <Leader>D     <Bslash>uD
      NXmap <Leader><M-d> <Bslash>u<M-d>
      NXmap <Leader><M-D> <Bslash>u<M-D>
    endif
  endif
  if !s:is_enabled_bundle('yankround')
    nnoremap <Bslash>up
    \ :<C-U>Unite history/yank register
    \ -buffer-name=register<CR>
    xnoremap <Bslash>up
    \ d:<C-U>Unite history/yank register
    \ -buffer-name=register<CR>

    if get(s:selector_ui, 'registers') == 'unite'
      NXmap <Leader>p <Bslash>up
    endif
  endif

  call extend(s:altercmd_define, {
  \ 'u[nite]' : 'Unite'})
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Unite'                   : 'unite#complete_source',
  \ 'UniteWithCurrentDir'     : 'unite#complete_source',
  \ 'UniteWithBufferDir'      : 'unite#complete_source',
  \ 'UniteWithProjectDir'     : 'unite#complete_source',
  \ 'UniteWithInputDirectory' : 'unite#complete_source',
  \ 'UniteWithCursorWord'     : 'unite#complete_source',
  \ 'UniteWithInput'          : 'unite#complete_source',
  \ 'UniteResume'             : 'unite#complete_buffer_name',
  \ 'UniteClose'              : 'unite#complete_buffer_name',
  \ 'UniteNext'               : 'unite#complete_buffer_name',
  \ 'UnitePrevious'           : 'unite#complete_buffer_name',
  \ 'UniteFirst'              : 'unite#complete_buffer_name',
  \ 'UniteLast'               : 'unite#complete_buffer_name'})
endif
"}}}

"------------------------------------------------------------------------------
" Unite FileType: {{{
if s:neobundle_tap('unite-filetype')
  NXnoremap <Bslash>uT
  \ :<C-U>Unite filetype
  \ -buffer-name=files<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite Help: {{{
if s:neobundle_tap('unite-help')
  NXnoremap <Bslash>u<F1>
  \ :<C-U>Unite help
  \ -buffer-name=help<CR>
  NXnoremap <Bslash>u<F2>
  \ :<C-U>UniteWithCursorWord help
  \ -buffer-name=help -no-start-insert<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite Mark: {{{
if s:neobundle_tap('unite-mark')
  function! neobundle#hooks.on_source(bundle)
    let g:unite_source_mark_marks =
    \ 'abcdefghijklmnopqrstuvwxyz' .
    \ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' .
    \ "0123456789.'`^<>[]{}()\""
  endfunction

  NXnoremap <Bslash>um
  \ :<C-U>Unite bookmark mark
  \ -buffer-name=register<CR>
  NXnoremap <Bslash>uM :<C-U>UniteBookmarkAdd<CR>

  if get(s:selector_ui, 'mark') == 'unite'
    NXmap <Leader>m <Bslash>um
    NXmap MM        <Bslash>uM
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Unite Outline: {{{
if s:neobundle_tap('unite-outline')
  NXnoremap <Bslash>uo
  \ :<C-U>Unite outline
  \ -buffer-name=outline<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite QuickFix: {{{
if s:neobundle_tap('unite-quickfix')
  NXnoremap <Bslash>u,
  \ :<C-U>Unite quickfix
  \ -buffer-name=register<CR>
  NXnoremap <Bslash>u.
  \ :<C-U>Unite location_list
  \ -buffer-name=register<CR>

  if get(s:selector_ui, 'quickfix') == 'unite'
    NXmap <C-W>, <Bslash>u,
    NXmap <C-W>. <Bslash>u.

    augroup MyVimrc
      autocmd QuickFixCmdPost [^l]*
      \ Unite quickfix
      \ -buffer-name=register -no-empty
      autocmd QuickFixCmdPost l*
      \ Unite location_list
      \ -buffer-name=register -no-empty
    augroup END
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Unite QuickRun Config: {{{
if s:neobundle_tap('unite-quickrun_config')
  NXnoremap <Bslash>u<F5>
  \ :<C-U>Unite quickrun_config
  \ -buffer-name=register<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite Tag: {{{
if s:neobundle_tap('unite-tag')
  NXnoremap <Bslash>u]
  \ :<C-U>UniteWithCursorWord tag tag/include
  \ -buffer-name=outline -no-start-insert<CR>

  if get(s:selector_ui, 'tag') == 'unite'
    NXmap <Leader>] <Bslash>u]
  endif
endif
"}}}

"------------------------------------------------------------------------------
" VeryftEnc: {{{
if s:neobundle_tap('verifyenc')
  autocmd MyVimrc BufReadPre *
  \ NeoBundleSource verifyenc
endif
"}}}

"------------------------------------------------------------------------------
" VimConsole: {{{
if s:neobundle_tap('vimconsole')
  call extend(s:neocompl_vim_completefuncs, {
  \ 'VimConsoleLog'   : 'expression',
  \ 'VimConsoleWarn'  : 'expression',
  \ 'VimConsoleError' : 'expression'})
endif
"}}}

"------------------------------------------------------------------------------
" VimFiler: {{{
if s:neobundle_tap('vimfiler')
  function! neobundle#hooks.on_source(bundle)
    let g:vimfiler_data_directory      = $HOME . '/.local/.cache/vimfiler'
    let g:vimfiler_as_default_explorer = 1
  endfunction

  let g:loaded_netrwPlugin = 1

  if get(s:selector_ui, 'explorer') == 'vimfiler'
    NXnoremap <Leader>E :<C-U>VimFiler<CR>
  endif

  call extend(s:neocompl_vim_completefuncs, {
  \ 'VimFiler'           : 'vimfiler#complete',
  \ 'VimFilerDouble'     : 'vimfiler#complete',
  \ 'VimFilerCurrentDir' : 'vimfiler#complete',
  \ 'VimFilerBufferDir'  : 'vimfiler#complete',
  \ 'VimFilerCreate'     : 'vimfiler#complete',
  \ 'VimFilerSimple'     : 'vimfiler#complete',
  \ 'VimFilerSplit'      : 'vimfiler#complete',
  \ 'VimFilerTab'        : 'vimfiler#complete',
  \ 'VimFilerExplorer'   : 'vimfiler#complete',
  \ 'VimFilerEdit'       : 'vimfiler#complete',
  \ 'VimFilerRead'       : 'vimfiler#complete',
  \ 'VimFilerSource'     : 'vimfiler#complete',
  \ 'VimFilerWrite'      : 'vimfiler#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" VimShell: {{{
if s:neobundle_tap('vimshell')
  function! neobundle#hooks.on_source(bundle)
    let g:vimshell_data_directory           = $HOME . '/.local/.cache/vimshell'
    let g:vimshell_vimshrc_path             = $HOME . '/.vim/vimshrc'
    let g:vimshell_max_command_history      = 100000
    let g:vimshell_no_save_history_commands = {}
    let g:vimshell_scrollback_limit         = 500
    let g:vimshell_prompt                   = '$ '
    let g:vimshell_secondary_prompt         = '> '
    " let g:vimshell_right_prompt             =
    " \ 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

    if has('win32')
      if filereadable('C:/Apps/ckw/ckw.exe')
        let g:vimshell_use_terminal_command = 'C:/Apps/ckw/ckw.exe -e'
      endif
      let g:vimshell_environment_term     = 'cygwin'
      let g:vimshell_user_prompt          =
      \ '$USERNAME . "@" . hostname() . " " . getcwd()'
    else
      let g:vimshell_environment_term     = 'xterm-256color'
      let g:vimshell_user_prompt          =
      \ '$USER . "@" . hostname() . " " . getcwd()'
    endif

    if s:executable('grep')
      call vimshell#set_alias('lld', 'ls -alF | grep "/$"')
      call vimshell#set_alias('llf', 'ls -alF | grep -v "/$"')
      call vimshell#set_alias('lle', 'ls -alF | grep "\*$"')
      call vimshell#set_alias('lls', 'ls -alF | grep "\->"')
    endif
    if s:executable('head')
      call vimshell#set_alias('h', 'head')
    endif
    if s:executable('tailf')
      call vimshell#set_alias('t', 'tailf')
    elseif s:executable('tail')
      call vimshell#set_alias('t', 'tail -f')
    endif
  endfunction

  if get(s:selector_ui, 'shell') == 'vimshell'
    NXnoremap <Leader>! :<C-U>VimShell<CR>
  endif

  call extend(s:altercmd_define, {
  \ 'sh[ell]' : 'VimShell',
  \
  \ '_sh[ell]' : 'shell'})
  call extend(s:neocompl_dictionary_filetype_lists, {
  \ 'vimshell' : $HOME . '/.local/.vimshell/command-history'})

  call extend(s:neocompl_vim_completefuncs, {
  \ 'VimShell'            : 'vimshell#complete',
  \ 'VimShellCreate'      : 'vimshell#complete',
  \ 'VimShellPop'         : 'vimshell#complete',
  \ 'VimShellTab'         : 'vimshell#complete',
  \ 'VimShellCurrentDir'  : 'vimshell#complete',
  \ 'VimShellBufferDir'   : 'vimshell#complete',
  \ 'VimShellExecute'     : 'vimshell#vimshell_execute_complete',
  \ 'VimShellInteractive' : 'vimshell#vimshell_execute_complete',
  \ 'VimShellTerminal'    : 'vimshell#vimshell_execute_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" Vinarize: {{{
if s:neobundle_tap('vinarize')
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Vinarise'     : 'vinarise#complete',
  \ 'VinariseDump' : 'vinarise#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" VisualStar: {{{
if s:neobundle_tap('visualstar')
  function! neobundle#hooks.on_source(bundle)
    let g:visualstar_no_default_key_mappings = 1
  endfunction

  if s:is_enabled_bundle('anzu')
    xmap <SID>(visualstar-*)
    \ <Plug>(visualstar-*)<Plug>(anzu-update-search-status-with-echo)
    xmap <SID>(visualstar-#)
    \ <Plug>(visualstar-#)<Plug>(anzu-update-search-status-with-echo)
    xmap <SID>(visualstar-g*)
    \ <Plug>(visualstar-g*)<Plug>(anzu-update-search-status-with-echo)
    xmap <SID>(visualstar-g#)
    \ <Plug>(visualstar-g#)<Plug>(anzu-update-search-status-with-echo)
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
"}}}

"------------------------------------------------------------------------------
" VisualStudio: {{{
if s:neobundle_tap('visualstudio')
  function! neobundle#hooks.on_source(bundle)
    let g:visualstudio_controllerpath =
    \ neobundle#get('VisualStudioController').path .
    \ '/bin/VisualStudioController.exe'
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" VBNet: {{{
if s:neobundle_tap('vbnet')
  function! neobundle#hooks.on_source(bundle)
    unlet! g:vbnet_no_code_folds
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Vital: {{{
if s:neobundle_tap('vital')
  call extend(s:neocompl_vim_completefuncs, {
  \ 'Vitalize' : 'vitalizer#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" WatchDogs: {{{
if s:neobundle_tap('watchdogs')
  function! neobundle#hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enable = 1

    let g:quickrun_config =
    \ get(g:, 'quickrun_config', {})

    call extend(g:quickrun_config, {
    \ 'watchdogs_checker/_' : {
    \   'runner' : s:has_vimproc() ? 'vimproc' : 'system'},
    \
    \ 'c/watchdogs_checker' : {
    \   'type' :
    \     s:executable('clang') ? 'watchdogs_checker/clang' :
    \     s:executable('gcc')   ? 'watchdogs_checker/gcc' :
    \     exists('$VCVARSALL')  ? 'watchdogs_checker/msvc' :
    \     s:executable('cl')    ? 'watchdogs_checker/msvc' : ''},
    \ 'cpp/watchdogs_checker' : {
    \   'type' :
    \     s:executable('clang-check') ? 'watchdogs_checker/clang_check' :
    \     s:executable('clang++')     ? 'watchdogs_checker/clang++' :
    \     s:executable('g++')         ? 'watchdogs_checker/g++' :
    \     exists('$VCVARSALL')        ? 'watchdogs_checker/msvc' :
    \     s:executable('cl')          ? 'watchdogs_checker/msvc' : ''},
    \ 'watchdogs_checker/msvc' : {
    \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
    \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
    \   'hook/vcvarsall/bat' : has('win32') ? myvimrc#cmdescape($VCVARSALL) : $VCVARSALL},
    \
    \ 'vim/watchdogs_checker' : {
    \   'type' : ''}})

    call watchdogs#setup(g:quickrun_config)
  endfunction

  call extend(s:neocompl_vim_completefuncs, {
  \ 'WatchdogsRun'       : 'quickrun#complete',
  \ 'WatchdogsRunSilent' : 'quickrun#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" YankRound: {{{
if s:neobundle_tap('yankround')
  function! neobundle#hooks.on_source(bundle)
    let g:yankround_dir           = $HOME . '/.local/.cache/yankround'
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

  nnoremap <Bslash>up
  \ :<C-U>Unite yankround register
  \ -buffer-name=register<CR>
  xnoremap <Bslash>up
  \ d:<C-U>Unite yankround register
  \ -buffer-name=register<CR>

  nnoremap <Bslash>pp
  \ :<C-U>CtrlPYankRound<CR>
  xnoremap <Bslash>pp
  \ d:<C-U>CtrlPYankRound<CR>

  autocmd MyVimrc User EscapeKey
  \ if exists('#yankround_rounder#InsertEnter') |
  \   call s:doautocmd('yankround_rounder', 'InsertEnter') |
  \ endif

  if get(s:selector_ui, 'registers') == 'unite'
    NXmap <Leader>p <Bslash>up
  elseif get(s:selector_ui, 'registers') == 'ctrlp'
    NXmap <Leader>p <Bslash>pp
  endif
endif
"}}}

silent! call neobundle#untap()
"}}}

"==============================================================================
" Post Init: {{{
" Do PostInit Event
if exists('#User#MyVimrcPost')
  call s:doautocmd('User', 'MyVimrcPost')
endif

" Local vimrc
if filereadable($HOME . '/.local/.vimrc_local.vim')
  source ~/.local/.vimrc_local.vim
elseif filereadable($HOME . '/.local/.vim/vimrc_local.vim')
  source ~/.local/.vim/vimrc_local.vim
endif

" Enable NeoBundle
silent! call neobundle#end()

" Enable plugin
filetype plugin indent on

" Syntax highlight
syntax enable

" ColorScheme
if &t_Co > 255 && !exists('g:colors_name')
  silent! colorscheme molokai
endif
"}}}
