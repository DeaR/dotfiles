scriptencoding utf-8
" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  21-Jul-2015.
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

"==============================================================================
" Pre Init: {{{
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
  if has('multi_lang')
    language japanese
    language time C
  endif

  " Shell
  let s:default_shell =
    \ [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote]
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
" <Leader> <LocalLeader>
let g:mapleader      = ';'
let g:maplocalleader = ','

" Gips
let s:gips_enable = 0

" Command line window
let s:cmdwin_enable = 0

" Ignore pattern
let s:ignore_ext = [
  \ 'git', 'hg', 'bzr', 'svn', 'drive.r',
  \ 'o', 'obj', 'a', 'lib', 'so', 'dll', 'dylib', 'exe', 'bin',
  \ 'swp', 'swo', 'bak', 'lc', 'elc', 'fas', 'pyc', 'luac', 'zwc']
let s:ignore_ft = [
  \ 'gitcommit', 'gitrebase', 'hgcommit']

" AlterCommand
let s:altercmd_define = {}

" NeoComplete and NeoComplCache
let s:neocompl_dictionary_filetype_lists = {
  \ 'default' : ''}
let s:neocompl_vim_completefuncs = {
  \ 'SQLSetType' : 'SQL_GetList'}
let s:neocompl_omni_patterns = {
  \ 'CucumberComplete'              : '\h\w*',
  \ 'adacomplete#Complete'          : '\h\w*',
  \ 'clojurecomplete#Complete'      : '\h\w*',
  \ 'csscomplete#CompleteCSS'       : '\h\w*\|[@!]',
  \ 'sqlcomplete#Complete'          : '\h\w*'}
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

" VCvarsall.bat
if has('win32') && !exists('$VCVARSALL')
  let s:save_ssl = &shellslash
  set noshellslash
  if exists('$VS120COMNTOOLS')
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
  let &shellslash = s:save_ssl
  unlet s:save_ssl

  let s:save_isi = &isident
  set isident+=(,)
  let s:programfiles = expand(exists('$PROGRAMFILES(X86)') ?
    \ '$PROGRAMFILES(X86)' : '$PROGRAMFILES')
  if isdirectory(s:programfiles . '\Microsoft SDKs\Windows\v7.1A\Include')
    let $SDK_INCLUDE_DIR = s:programfiles . '\Microsoft SDKs\Windows\v7.1A\Include'
  elseif isdirectory(s:programfiles . '\Microsoft SDKs\Windows\v7.1\Include')
    let $SDK_INCLUDE_DIR = s:programfiles . '\Microsoft SDKs\Windows\v7.1\Include'
  endif
  let &isident = s:save_isi
  unlet s:save_isi
endif
"}}}

"------------------------------------------------------------------------------
" Common: {{{
" Vimrc autocmd group
augroup MyVimrc
  autocmd!
augroup END

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

"------------------------------------------------------------------------------
" NeoBundle: {{{
if s:has_neobundle
  set runtimepath+=~/.local/bundle/neobundle
  let g:neobundle#enable_name_conversion = 1
  let g:neobundle#enable_tail_path       = 1
  let g:neobundle#install_max_processes  =
    \ exists('$NUMBER_OF_PROCESSORS') ? str2nr($NUMBER_OF_PROCESSORS) : 1
  if s:is_android
    let g:neobundle#types#git#default_protocol = 'ssh'
    let g:neobundle#types#hg#default_protocol  = 'ssh'
  endif

  call neobundle#begin($HOME . '/.local/bundle')
  if (!has('win32') && v:progname !=# 'gvim') ||
    \ (has('win32') && v:progname !=# 'gvim.exe')
    call neobundle#load_toml($HOME . '/.vim/neobundle.toml', {'lazy' : 1})
  elseif neobundle#load_cache($HOME . '/.vim/neobundle.toml')
    call neobundle#load_toml($HOME . '/.vim/neobundle.toml', {'lazy' : 1})
    NeoBundleSaveCache
  endif
  call neobundle#end()

  execute 'set runtimepath+=' .
    \ join(map(filter(split(glob($HOME . '/.vim/bundle-settings/*'), '\n'),
    \                 'neobundle#is_installed(fnamemodify(v:val, ":t"))'),
    \          'escape(v:val, " ,")'), ',')

  autocmd MyVimrc User VimrcPost
    \ call neobundle#call_hook('on_source')

  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoBundleSource'    : 'neobundle#complete_lazy_bundles',
    \ 'NeoBundleDisable'   : 'neobundle#complete_bundles',
    \ 'NeoBundleInstall'   : 'neobundle#complete_bundles',
    \ 'NeoBundleUpdate'    : 'neobundle#complete_bundles',
    \ 'NeoBundleClean'     : 'neobundle#complete_deleted_bundles',
    \ 'NeoBundleReinstall' : 'neobundle#complete_bundles'})
endif
"}}}
"}}}

"==============================================================================
" General Settings: {{{

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
if s:is_android
  set viminfo+=n/data/data/net.momodalo.app.vimtouch/files/vim/.viminfo
elseif isdirectory($HOME . '/.local')
  set viminfo+=n~/.local/.viminfo
endif
set history=100

" Backup
set nobackup
set swapfile
set undofile
set undodir^=~/.local/.vimundo
autocmd MyVimrc BufNewFile,BufRead *
  \ let &l:undofile = (index(copy(s:ignore_ft), &filetype) < 0)

" ClipBoard
set clipboard=unnamed

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
  \ join(map(copy(s:ignore_ext), '''*.'' . escape(v:val, ''\,'')'), ',')

" Mouse
set mouse=a
set nomousefocus
set nomousehide
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
if &t_Co > 2
  set hlsearch
endif

" Grep
if (s:has_neobundle && neobundle#is_installed('jvgrep')) ||
  \ s:executable('jvgrep')
  set grepprg=jvgrep\ -n
elseif (s:has_neobundle && neobundle#is_installed('the_silver_searcher')) ||
  \ s:executable('ag')
  set grepprg=ag\ --line-numbers\ --nocolor\ --nogroup\ --hidden
elseif s:executable('grep')
  set grepprg=grep\ -Hn
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
set statusline=%<%f\ %m%r[
if has('multi_byte')
  set statusline+=%{&fenc!=''?&fenc:&enc}:
endif
set statusline+=%{&ff}]%y%=

if has('multi_byte')
  set statusline+=\ [U+%04B]
endif
set statusline+=\ (%v,%l)/%L

if s:is_lang_ja
  set statusline+=\ %4P
else
  set statusline+=\ %3P
endif
"}}}

"------------------------------------------------------------------------------
" File Encodings: {{{
if has('multi_byte')
  let s:enc_jisx0213 = has('iconv') &&
    \ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"

  let &fileencodings =
    \ (has('guess_encode') ? 'guess,' : '') .
    \ (s:enc_jisx0213 ? 'iso-2022-jp-3,' : 'iso-2022-jp,') .
    \ 'cp932,' .
    \ (s:enc_jisx0213 ? 'euc-jisx0213,' : '') .
    \ 'euc-jp,ucs-bom'

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
if has('gui_running') || &t_Co > 255
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

" Enable plugin
filetype plugin indent on

" Syntax highlight
syntax on

" Colorscheme
if &t_Co > 255
  silent! colorscheme molokai
endif
"}}}
"}}}

"==============================================================================
" Mappings: {{{

"------------------------------------------------------------------------------
" Multi Mode Mapping: {{{
command! -complete=mapping -nargs=*
  \ NVmap
  \ nmap <args>| vmap <args>
command! -complete=mapping -nargs=*
  \ NXmap
  \ nmap <args>| xmap <args>
command! -complete=mapping -nargs=*
  \ NSmap
  \ nmap <args>| smap <args>
command! -complete=mapping -nargs=*
  \ NOmap
  \ nmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ VOmap
  \ vmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ XOmap
  \ xmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ SOmap
  \ smap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ NXOmap
  \ nmap <args>| xmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ NSOmap
  \ nmap <args>| smap <args>| omap <args>

command! -complete=mapping -nargs=*
  \ NVnoremap
  \ nnoremap <args>| vnoremap <args>
command! -complete=mapping -nargs=*
  \ NXnoremap
  \ nnoremap <args>| xnoremap <args>
command! -complete=mapping -nargs=*
  \ NSnoremap
  \ nnoremap <args>| snoremap <args>
command! -complete=mapping -nargs=*
  \ NOnoremap
  \ nnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ VOnoremap
  \ vnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ XOnoremap
  \ xnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ SOnoremap
  \ snoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ NXOnoremap
  \ nnoremap <args>| xnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ NSOnoremap
  \ nnoremap <args>| snoremap <args>| onoremap <args>
"}}}

"------------------------------------------------------------------------------
" Common: {{{
" <Leader> <LocalLeader>
NXOnoremap <Leader>      <Nop>
NXOnoremap <LocalLeader> <Nop>

" Prefix
NXOnoremap ;     <Nop>
NXOnoremap ,     <Nop>
NXOnoremap s     <Nop>
NXOnoremap S     <Nop>
NXOnoremap m     <Nop>
NXOnoremap M     <Nop>
NOnoremap  <C-G> <Nop>
cnoremap   <C-G> <Nop>

" Split Nicely
NXnoremap <expr> <SID>(split-nicely)
  \ myvimrc#split_nicely_expr() ? '<C-W>s' : '<C-W>v'
"}}}

"------------------------------------------------------------------------------
" Command Line: {{{
if s:cmdwin_enable
  noremap <SID>: q:
  noremap <SID>/ q/
  noremap <SID>? q?
else
  noremap <expr> <SID>: myvimrc#cmdline_enter(':')
  noremap <expr> <SID>/ myvimrc#cmdline_enter('/')
  noremap <expr> <SID>? myvimrc#cmdline_enter('?')
endif

NXmap ;; <SID>:
NXmap :  <SID>:
NXmap /  <SID>/
NXmap ?  <SID>?

NXnoremap <expr> ;: myvimrc#cmdline_enter(':')
NXnoremap <expr> ;/ myvimrc#cmdline_enter('/')
NXnoremap <expr> ;? myvimrc#cmdline_enter('?')

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

augroup MyVimrc
  autocmd CmdwinEnter *
    \ call myvimrc#cmdwin_enter()
  autocmd CmdwinLeave *
    \ call myvimrc#cmdwin_leave()
  autocmd CmdwinEnter /
    \ inoremap <buffer> / \/
  autocmd CmdwinEnter ?
    \ inoremap <buffer> ? \?
augroup END
"}}}

"------------------------------------------------------------------------------
" Escape Key: {{{
nnoremap <expr> <Esc><Esc> myvimrc#escape_key()
"}}}

"------------------------------------------------------------------------------
" Gips: {{{
if s:gips_enable
  noremap <Up>       <Nop>
  noremap <Down>     <Nop>
  noremap <Right>    <Nop>
  noremap <Left>     <Nop>
  noremap <Home>     <Nop>
  noremap <End>      <Nop>
  noremap <PageUp>   <Nop>
  noremap <PageDown> <Nop>
endif
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
NXOnoremap ' `
NXOnoremap ` '
nnoremap <S-Tab> <C-O>

" Mark
NXOnoremap mj ]`
NXOnoremap mk [`

" Diff
NXOnoremap <C-J> ]c
NXOnoremap <C-K> [c

" Command-line
cnoremap <expr> <C-H>
  \ getcmdtype() == '@' && getcmdpos() == 1 && getcmdline() == '' ?
  \   '<Esc>' : '<C-H>'
cnoremap <expr> <BS>
  \ getcmdtype() == '@' && getcmdpos() == 1 && getcmdline() == '' ?
  \   '<Esc>' : '<BS>'
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
NXnoremap <Leader>C     :<C-U>only<CR>
NXnoremap <Leader><M-c> :<C-U>tabclose<CR>
NXnoremap <Leader><M-C> :<C-U>tabonly<CR>
NXnoremap <Leader>w     :<C-U>update<CR>
NXnoremap <Leader>W     :<C-U>wall<CR>
NXnoremap <Leader>q     :<C-U>bdelete<CR>
NXnoremap <Leader>!     :<C-U>shell<CR>
NXnoremap <Leader>B     :<C-U>buffers<CR>
NXnoremap <Leader>E     :<C-U>Explorer<CR>
NXnoremap <Leader>T     :<C-U>tabs<CR>
NXnoremap <Leader>j     :<C-U>jumps<CR>
NXnoremap <Leader>J     :<C-U>changes<CR>
NXnoremap <Leader><C-D> :<C-U>pwd<CR>
NXnoremap <script> <Leader>e <SID>:<C-U>edit<Space>
NXnoremap <script> <Leader>b <SID>:<C-U>buffer<Space>
NXnoremap <script> <Leader>t <SID>:<C-U>tabm<Space>
NXnoremap <script> <Leader>d <SID>:<C-U>lcd<Space>
NXnoremap <script> <Leader>D <SID>:<C-U>cd<Space>
NXnoremap <expr> <Leader>Q
  \ ':<C-U>1,' . bufnr('$') . 'bdelete<CR>'
NXnoremap <script><expr> <Leader><M-d>
  \ '<SID>:<C-U>lcd ' .
  \ expand('%:p:h' . (has('win32') ? ':gs?\\?/?' : '')) .
  \ '/'
NXnoremap <script><expr> <Leader><M-D>
  \ '<SID>:<C-U>cd ' .
  \ expand('%:p:h' . (has('win32') ? ':gs?\\?/?' : '')) .
  \ '/'
"}}}

"------------------------------------------------------------------------------
" Search: {{{
NXOmap g/ *
NXOmap g? #

NXnoremap <script> <C-W>/  <SID>(split-nicely)<SID>/
NXnoremap <script> <C-W>?  <SID>(split-nicely)<SID>?
NXnoremap <script> <C-W>*  <SID>(split-nicely)*
NXnoremap <script> <C-W>#  <SID>(split-nicely)#
NXnoremap <script> <C-W>g* <SID>(split-nicely)g*
NXnoremap <script> <C-W>g# <SID>(split-nicely)g#
NXmap <C-W>g/ <C-W>*
NXmap <C-W>g? <C-W>#

NXOnoremap <expr> n
  \ myvimrc#search_forward_expr() ? 'n' : 'N'
NXOnoremap <expr> N
  \ myvimrc#search_forward_expr() ? 'N' : 'n'
"}}}

"------------------------------------------------------------------------------
" Help: {{{
inoremap <expr> <F1>
  \ myvimrc#split_nicely_expr() ?
  \   '<Esc>:<C-U>help<Space>' :
  \   '<Esc>:<C-U>vertical help<Space>'
nnoremap <expr> <F1>
  \ myvimrc#split_nicely_expr() ?
  \   ':<C-U>help<Space>' :
  \   ':<C-U>vertical help<Space>'
nnoremap <expr> <F2>
  \ myvimrc#split_nicely_expr() ?
  \   ':<C-U>help ' . expand('<cword>') . '<CR>' :
  \   ':<C-U>vertical help ' . expand('<cword>') . '<CR>'
"}}}

"------------------------------------------------------------------------------
" Auto Mark: {{{
nnoremap <expr> mm myvimrc#auto_mark()
nnoremap <expr> mc myvimrc#clear_marks()
nnoremap <expr> mM myvimrc#auto_file_mark()
nnoremap <expr> mC myvimrc#clear_file_marks()
nnoremap <expr> ml myvimrc#marks()
"}}}

"------------------------------------------------------------------------------
" Smart BOL: {{{
NXOnoremap <expr> H myvimrc#smart_bol()
NXOnoremap <expr> L myvimrc#smart_eol()
inoremap <expr> <M-H> '<C-O>' . myvimrc#smart_bol()
inoremap <expr> <M-L> '<C-O>' . myvimrc#smart_eol()
"}}}

"------------------------------------------------------------------------------
" Smart Close: {{{
autocmd MyVimrc FileType *
  \ if (&readonly || !&modifiable) && maparg('q', 'n') == '' |
  \   nnoremap <buffer><expr> q
  \     winnr('$') != 1 ? ':<C-U>close<CR>' : ''|
  \ endif
"}}}

"------------------------------------------------------------------------------
" Line Number: {{{
nnoremap <F12> :<C-U>call myvimrc#toggle_line_number_style()<CR>
"}}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
nnoremap  <expr> <M-a> myvimrc#insert_one_char('a')
NXnoremap <expr> <M-A> myvimrc#insert_one_char('A')
nnoremap  <expr> <M-i> myvimrc#insert_one_char('i')
NXnoremap <expr> <M-I> myvimrc#insert_one_char('I')
"}}}

"------------------------------------------------------------------------------
" Others: {{{
" Paste
set pastetoggle=<F11>
nnoremap  <F11> :<C-U>set paste! paste?<CR>
NXnoremap <C-P> :<C-U>registers<CR>
inoremap  <C-P> <C-O>:<C-U>registers<CR>
noremap!  <M-p> <C-R>"

" BackSpace
nnoremap <BS> X

" Yank to end of line
nnoremap Y y$

" Tabs
NXnoremap g<M-t> :<C-U>tabmove +1<CR>
NXnoremap g<M-T> :<C-U>tabmove -1<CR>

" Undo branch
nnoremap <M-u> :<C-U>undolist<CR>

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
" Increment: {{{
silent! vunmap <C-X>
if s:has_patch(7, 4, 754)
  xnoremap <C-A> <C-A>gv
  xnoremap <C-X> <C-X>gv
endif
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

" Insert Tab
inoremap <C-T> <C-V><Tab>

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
  if s:enc_jisx0213
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
  command! -bang -bar -complete=file -nargs=?
    \ EditUtf8
    \ edit<bang> ++enc=utf-8 <args>
  command! -bang -bar -complete=file -nargs=?
    \ EditUtf16le
    \ edit<bang> ++enc=utf-16le <args>
  command! -bang -bar -complete=file -nargs=?
    \ EditUtf16
    \ edit<bang> ++enc=utf-16 <args>
  command! -bang -bar -complete=file -nargs=?
    \ EditCp932
    \ edit<bang> ++enc=cp932 <args>
  command! -bang -bar -complete=file -nargs=?
    \ EditEucjp
    \ edit<bang> ++enc=euc-jp <args>
  if s:enc_jisx0213
    command! -bang -bar -complete=file -nargs=?
      \ EditEucJisx0213
      \ edit<bang> ++enc=euc-jisx0213 <args>
    command! -bang -bar -complete=file -nargs=?
      \ EditIso2022jp
      \ edit<bang> ++enc=iso-2022-jp-3 <args>
  else
    command! -bang -bar -complete=file -nargs=?
      \ EditIso2022jp
      \ edit<bang> ++enc=iso-2022-jp <args>
  endif
endif
"}}}

"------------------------------------------------------------------------------
" Shell Setting: {{{
if has('win32')
  command! -bar
    \ ShellCmd
    \ call myvimrc#set_shell(s:default_shell)
  command! -bar -nargs=?
    \ ShellSh
    \ call myvimrc#set_shell([<q-args> != '' ? <q-args> : 'sh', 1, '-c', '', '"'])
endif
"}}}

"------------------------------------------------------------------------------
" VC Vars: {{{
if exists('$VCVARSALL')
  command! -bar
    \ VCVars32
    \ call myvimrc#vcvarsall('x86')

  if exists('$PROGRAMFILES(X86)')
    command! -bar
      \ VCVars64
      \ call myvimrc#vcvarsall(exists('PROCESSOR_ARCHITEW6432') ?
      \   $PROCESSOR_ARCHITEW6432 : $PROCESSOR_ARCHITECTURE)
  endif
endif
"}}}

"------------------------------------------------------------------------------
" QuickFix Toggle: {{{
command! -bar -nargs=?
  \ CToggle
  \ call myvimrc#toggle_quickfix('c', <q-args>)
command! -bar -nargs=?
  \ LToggle
  \ call myvimrc#toggle_quickfix('l', <q-args>)

NXnoremap <C-W>, :<C-U>CToggle<CR>
NXnoremap <C-W>. :<C-U>LToggle<CR>

augroup MyVimrc
  autocmd QuickFixCmdPost [^l]*
    \ cwindow
  autocmd QuickFixCmdPost l*
    \ lwindow
augroup END
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
  \ execute 'doautocmd' (s:has_patch(7, 3, 438) ? '<nomodeline>' : '')
  \ 'FileType'

nnoremap <F8> :<C-U>Undiff<CR>
"}}}

"------------------------------------------------------------------------------
" From Example: {{{
command! -bar
  \ DiffOrig
  \ let s:save_ft = &l:filetype | vertical new | setlocal buftype=nofile |
  \ read # | 0d_ | let &l:filetype = s:save_ft | unlet s:save_ft |
  \ diffthis | wincmd p | diffthis

nnoremap <F6> :<C-U>DiffOrig<CR>
"}}}
"}}}

"==============================================================================
" Vim Script: {{{

"------------------------------------------------------------------------------
" Auto MkDir: {{{
autocmd MyVimrc BufWritePre *
  \ call myvimrc#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
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
      \ s, '\%(\%(re\|in\)verse,\?\|,\%(re\|in\)verse\)', '', 'g')
  elseif s != '' && s != 'NONE'
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
function! s:set_status_line_color(is_enter, force)
  if !exists('s:hi_status_line') || !exists('s:hi_status_line_i') || a:force
    silent! let s:hi_status_line   = s:get_highlight('StatusLine')
    silent! let s:hi_status_line_i = s:reverse_highlight(s:hi_status_line)
  endif

  if exists('s:hi_status_line') && exists('s:hi_status_line_i')
    highlight clear StatusLine
    if a:is_enter
      execute 'highlight StatusLine' s:hi_status_line_i
    else
      execute 'highlight StatusLine' s:hi_status_line
    endif
  endif
endfunction

augroup MyVimrc
  autocmd ColorScheme *
    \ call s:set_status_line_color(mode() =~# '[iR]', 1)
  autocmd InsertEnter *
    \ call s:set_status_line_color(1, 0)
  autocmd InsertLeave *
    \ call s:set_status_line_color(0, 0)
augroup END
"}}}

"------------------------------------------------------------------------------
" Highlight Ideographic Space: {{{
if has('multi_byte')
  function! s:set_ideographic_space(force)
    if !exists('s:hi_ideographic_space') || a:force
      silent! let s:hi_ideographic_space =
        \ s:get_highlight('SpecialKey') .
        \ ' term=underline cterm=underline gui=underline'
    endif

    if exists('s:hi_ideographic_space')
      execute 'highlight IdeographicSpace' s:hi_ideographic_space
      syntax match IdeographicSpace "　" display containedin=ALL
    endif
  endfunction

  augroup MyVimrc
    autocmd ColorScheme *
      \ call s:set_ideographic_space(1)
    autocmd Syntax *
      \ call s:set_ideographic_space(0)
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" From Example: {{{
autocmd MyVimrc BufRead *
  \ if line('.') == 1 && line("'\"") > 1 && line("'\"") <= line('$') &&
  \     index(copy(s:ignore_ft), &filetype) < 0 |
  \   execute 'normal! g`"' |
  \ endif
"}}}
"}}}

"==============================================================================
" Plugins: {{{

"------------------------------------------------------------------------------
" Built In: {{{
" Assembler
let g:asmsyntax = 'masm'
" let g:asmsyntax = 'z80'
" let g:asmsyntax = 'arm'

" Shell Script
let g:is_bash = 1

" Indent
let g:vim_indent_cont = 2

" Folding
let g:c_no_comment_fold   = 1
let g:c_no_block_fold     = 1
let g:javaScript_fold     = 1
let g:perl_fold           = 1
let g:php_folding         = 1
let g:ruby_fold           = 1
let g:sh_fold_enabled     = 1
let g:vbnet_no_code_folds = 1
let g:vimsyn_folding      = 'af'
let g:xml_syntax_folding  = 1
"}}}

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
" Alignta: {{{
if s:has_neobundle && neobundle#tap('alignta')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('altercmd')
  function! neobundle#tapped.hooks.on_post_source(bundle)
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
if s:has_neobundle && neobundle#tap('altr')
  nmap g<M-f>     <Plug>(altr-forward)
  nmap g<M-F>     <Plug>(altr-back)
  nmap <C-W><M-f> <SID>(split-nicely)<Plug>(altr-forward)
  nmap <C-W><M-F> <SID>(split-nicely)<Plug>(altr-back)

  autocmd MyVimrc User CmdlineEnter
    \ NeoBundleSource altr
endif
"}}}

"------------------------------------------------------------------------------
" Anzu: {{{
if s:has_neobundle && neobundle#tap('anzu')
  set shortmess+=s

  nmap <expr> n
    \ myvimrc#search_forward_expr() ?
    \   '<Plug>(anzu-jump-n)<Plug>(anzu-echo-search-status)' :
    \   '<Plug>(anzu-jump-N)<Plug>(anzu-echo-search-status)'
  nmap <expr> N
    \ myvimrc#search_forward_expr() ?
    \   '<Plug>(anzu-jump-N)<Plug>(anzu-echo-search-status)' :
    \   '<Plug>(anzu-jump-n)<Plug>(anzu-echo-search-status)'
endif
"}}}

"------------------------------------------------------------------------------
" AutoDate: {{{
if s:has_neobundle && neobundle#tap('autodate')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:autodate_lines = 10
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" AutoFmt: {{{
if s:has_neobundle && neobundle#tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif
"}}}

"------------------------------------------------------------------------------
" Clever F: {{{
if s:has_neobundle && neobundle#tap('clever-f')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('columnjump')
  function! neobundle#tapped.hooks.on_source(bundle)
    nmap <SID>(columnjump-backward) <Plug>(columnjump-backward)
    nmap <SID>(columnjump-forward)  <Plug>(columnjump-forward)

    inoremap <script> <M-(> <C-O><SID>(columnjump-backward)
    inoremap <script> <M-)> <C-O><SID>(columnjump-forward)
  endfunction

  NXOmap ( <Plug>(columnjump-backward)
  NXOmap ) <Plug>(columnjump-forward)
endif
"}}}

"------------------------------------------------------------------------------
" Dispatch: {{{
if s:has_neobundle && neobundle#tap('dispatch')
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
if s:has_neobundle && neobundle#tap('echodoc')
  function! neobundle#tapped.hooks.on_source(bundle)
    call echodoc#enable()
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Emmet: {{{
if s:has_neobundle && neobundle#tap('emmet')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('eskk')
  function! neobundle#tapped.hooks.on_source(bundle)
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

  autocmd MyVimrc User CmdlineEnter
    \ NeoBundleSource eskk
endif
"}}}

"------------------------------------------------------------------------------
" Fugitive: {{{
if s:has_neobundle && neobundle#tap('fugitive')
  function! neobundle#tapped.hooks.on_post_source(bundle)
    call fugitive#detect(expand('%') == '' ? getcwd() : expand('%:p'))
  endfunction

  NXnoremap <Leader>g <Nop>
  NXnoremap <Leader>gd :<C-U>Gdiff<CR>
  NXnoremap <Leader>gs :<C-U>Gstatus<CR>
  NXnoremap <Leader>ga :<C-U>Gwrite<CR>
  NXnoremap <Leader>gc :<C-U>Gcommit<CR>
  NXnoremap <Leader>gC :<C-U>Gcommit --amend<CR>
  NXnoremap <Leader>gb :<C-U>Gblame<CR>
  NXnoremap <expr> <Leader>gl
    \ neobundle#is_installed('gitv') ? ':<C-U>Gitv<CR>' : ':<C-U>Glog<CR>'

  NXnoremap <script> <Leader>gg <SID>:<C-U>Git<Space>
endif
"}}}

"------------------------------------------------------------------------------
" Lua Ftplugin: {{{
if s:has_neobundle && neobundle#tap('lua-ftplugin')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:lua_complete_omni = 1
    let g:lua_check_syntax  = 0
    let g:lua_check_globals = 0
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'xolox#lua#omnifunc' : '\%(\.\|:\)\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Goto File: {{{
if s:has_neobundle && neobundle#tap('gf-user')
  function! neobundle#tapped.hooks.on_source(bundle)
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
" Go: {{{
if s:has_neobundle && neobundle#tap('go')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:go_bin_path            = $HOME . '/.local/.vim-go'
    let g:go_disable_autoinstall = 1
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'go#complete#Complete' : '\.\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Go Extra: {{{
if s:has_neobundle && neobundle#tap('go-extra')
  call extend(s:neocompl_force_omni_patterns, {
    \ 'gocomplete#Complete' : '\.\h\w*'})
  call extend(s:neocompl_vim_completefuncs, {
    \ 'GoDoc' : 'go#complete#Package'})
endif
"}}}

"------------------------------------------------------------------------------
" Grex: {{{
if s:has_neobundle && neobundle#tap('grex')
  NXOmap sD <Plug>(operator-grex-delete)
  NXOmap sY <Plug>(operator-grex-yank)

  nmap sDD sDsD
  nmap sYY sYsY
endif
"}}}

"------------------------------------------------------------------------------
" Hier: {{{
if s:has_neobundle && neobundle#tap('hier')
  autocmd MyVimrc User EscapeKey
    \ HierClear
endif
"}}}

"------------------------------------------------------------------------------
" J6uil: {{{
if s:has_neobundle && neobundle#tap('J6uil')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:J6uil_config_dir             = $HOME . '/.local/.J6uil'
    let g:J6uil_echo_presence          = 0
    let g:J6uil_open_buffer_cmd        = 'tabedit'
    let g:J6uil_no_default_keymappings = 1
    let g:J6uil_user                   = 'DeaR'

    if (has('win32')  && isdirectory($PROGRAMFILES . '/ImageMagick-6.9.0-Q16')) ||
      \ (!has('win32') && s:executable('convert'))
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
if s:has_neobundle && neobundle#tap('jedi')
  function! neobundle#tapped.hooks.on_source(bundle)
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
" Jvgrep: {{{
if s:has_neobundle && neobundle#tap('jvgrep')
  let $JVGREP_EXCLUDE =
    \ join(map(
    \   copy(s:ignore_ext),
    \   '''\.'' . escape(v:val, ''\*+.?{}()[]^$-|/'') . ''$'''), '|')
endif

"------------------------------------------------------------------------------
" Kwbdi: {{{
if s:has_neobundle && neobundle#tap('kwbdi')
  function! neobundle#tapped.hooks.on_source(bundle)
    command! -bar
      \ Kwbd
      \ call myvimrc#kwbd()
  endfunction

  NXnoremap <Leader>q :<C-U>Kwbd<CR>
  map <SID>Kwbd <Plug>Kwbd

  call extend(s:altercmd_define, {
    \ 'bd[elete]' : 'Kwbd',
    \
    \ '_bd[elete]' : 'bdelete'})
endif
"}}}

"------------------------------------------------------------------------------
" Localrc: {{{
if s:has_neobundle && neobundle#tap('localrc')
  augroup MyVimrc
    autocmd BufNewFile,BufRead *
      \ if exists("b:undo_localrc") |
      \   execute b:undo_localrc |
      \   unlet! b:undo_localrc |
      \ endif
    autocmd FileType *
      \ if exists("b:undo_ftlocalrc") |
      \   execute b:undo_ftlocalrc |
      \   unlet! b:undo_ftlocalrc |
      \ endif
  augroup END
endif
"}}}

"------------------------------------------------------------------------------
" MatchIt: {{{
if s:has_neobundle && neobundle#tap('matchit')
  function! neobundle#tapped.hooks.on_post_source(bundle)
    silent! sunmap %
    silent! sunmap g%
    silent! sunmap [%
    silent! sunmap ]%
    silent! sunmap a%
  endfunction

  xmap <SID>[% [%
  xmap <SID>]% ]%

  xnoremap <script> [% <Esc><SID>[%m'gv``
  xnoremap <script> ]% <Esc><SID>]%m'gv``
  xnoremap <script> a% <Esc><SID>[%v<SID>]%

  NXOmap <Space>   %
  NXOmap <S-Space> g%
endif
"}}}

"------------------------------------------------------------------------------
" MapList: {{{
if s:has_neobundle && neobundle#tap('maplist')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:maplist_mode_length  = 4
    let g:maplist_lhs_length   = 50
    let g:maplist_local_length = 2
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Marching: {{{
if s:has_neobundle && neobundle#tap('marching')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:marching_enable_neocomplete = 1
    let g:marching_backend            =
      \ neobundle#is_installed('snowdrop') ?
      \   "snowdrop" : "sync_clang_command"
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'marching#complete' : '\%(\.\|->\|::\)\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Narrow: {{{
if s:has_neobundle && neobundle#tap('narrow')
  function! neobundle#tapped.hooks.on_source(bundle)
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
" NeoComplCache: {{{
if s:has_neobundle && neobundle#tap('neocomplcache')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neocomplcache_enable_at_startup            = 1
    let g:neocomplcache_enable_auto_select           = 0
    let g:neocomplcache_enable_auto_delimiter        = 1
    " let g:neocomplcache_enable_insert_char_pre       = 1
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
    " let g:neocomplcache_omni_patterns             =
    "   \ s:neocompl_omni_patterns
    " let g:neocomplcache_force_omni_patterns       =
    "   \ s:neocompl_force_omni_patterns
    let g:neocomplcache_omni_patterns             = {}
    let g:neocomplcache_force_omni_patterns       = {}

    call neocomplcache#custom_source('syntax_complete',   'rank',  9)
    call neocomplcache#custom_source('snippets_complete', 'rank', 80)

    inoremap <expr> <C-Y>
      \ neocomplcache#close_popup()
    inoremap <expr> <C-G>
      \ neocomplcache#undo_completion()
    inoremap <expr> <C-C>
      \ pumvisible() ?
      \   neocomplcache#cancel_popup() :
      \   '<C-C>'
    inoremap <expr> <C-L>
      \ pumvisible() ?
      \   neocomplcache#complete_common_string() :
      \   '<C-L>'
    inoremap <expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   myvimrc#check_back_space() ?
      \     '<Tab>' :
      \     neocomplcache#start_manual_complete()
    inoremap <expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplcache#start_manual_complete()

    inoremap <expr> <CR>
      \ neocomplcache#close_popup() . '<CR>'
    inoremap <expr> <C-H>
      \ neocomplcache#smart_close_popup() . '<C-H>'
    inoremap <expr> <BS>
      \ neocomplcache#smart_close_popup() . '<BS>'
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
if s:has_neobundle && neobundle#tap('neocomplete')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_auto_select           = 0
    let g:neocomplete#enable_auto_delimiter        = 1
    " let g:neocomplete#enable_insert_char_pre       = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#data_directory               =
      \ $HOME . '/.local/.cache/neocomplete'

    let g:neocomplete#sources#dictionary#dictionaryies =
      \ s:neocompl_dictionary_filetype_lists
    let g:neocomplete#sources#vim#complete_functions   =
      \ s:neocompl_vim_completefuncs
    " let g:neocomplete#sources#omni#input_patterns      =
    "   \ s:neocompl_omni_patterns
    " let g:neocomplete#force_omni_input_patterns        =
    "   \ s:neocompl_force_omni_patterns
    let g:neocomplete#sources#omni#input_patterns      = {}
    let g:neocomplete#force_omni_input_patterns        = {}

    call neocomplete#custom#source('_', 'matchers', ['matcher_head'])
    call neocomplete#custom#source('syntax_complete',   'rank',  9)
    call neocomplete#custom#source('snippets_complete', 'rank', 80)

    inoremap <expr> <C-Y>
      \ neocomplete#close_popup()
    inoremap <expr> <C-G>
      \ neocomplete#undo_completion()
    inoremap <expr> <C-C>
      \ pumvisible() ?
      \   neocomplete#cancel_popup() :
      \   '<C-C>'
    inoremap <expr> <C-L>
      \ pumvisible() ?
      \   neocomplete#complete_common_string() :
      \   '<C-L>'
    inoremap <expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   myvimrc#check_back_space() ?
      \     '<Tab>' :
      \     neocomplete#start_manual_complete()
    inoremap <expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplete#start_manual_complete()

    inoremap <expr> <CR>
      \ neocomplete#close_popup() . '<CR>'
    inoremap <expr> <C-H>
      \ neocomplete#smart_close_popup() . '<C-H>'
    inoremap <expr> <BS>
      \ neocomplete#smart_close_popup() . '<BS>'
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
if s:has_neobundle && neobundle#tap('neomru')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neomru#file_mru_path       = $HOME . '/.local/.cache/neomru/file'
    let g:neomru#directory_mru_path  = $HOME . '/.local/.cache/neomru/directory'
    let g:neomru#file_mru_limit      = 50
    let g:neomru#directory_mru_limit = 50
    let g:neomru#do_validate         = 0

    let g:neomru#file_mru_ignore_pattern =
      \ '[/\\]doc[/\\][^/\\]\+\.\%(txt\|\a\ax\)$\|' .
      \ join(map(
      \   copy(s:ignore_ext),
      \   '''\.'' . escape(v:val, ''\*.^$'') . ''$'''), '\|')
  endfunction

  NXnoremap <Leader>e
    \ :<C-U>Unite neomru/file file file/new
    \ -buffer-name=files -no-split<CR>
  NXnoremap <Leader>d
    \ :<C-U>Unite
    \ menu:directory_current neomru/directory directory directory/new
    \ -buffer-name=files -no-split -default-action=lcd<CR>
  NXnoremap <Leader>D
    \ :<C-U>Unite
    \ menu:directory_current neomru/directory directory directory/new
    \ -buffer-name=files -no-split -default-action=cd<CR>
  NXnoremap <Leader><M-d>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file neomru/directory directory directory/new
    \ -buffer-name=files -no-split -default-action=lcd<CR>
  NXnoremap <Leader><M-D>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file neomru/directory directory directory/new
    \ -buffer-name=files -no-split -default-action=cd<CR>
endif
"}}}

"------------------------------------------------------------------------------
" NeoSnippet: {{{
if s:has_neobundle && neobundle#tap('neosnippet')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neosnippet#snippets_directory           = $HOME . '/.vim/snippets'
    let g:neosnippet#data_directory               = $HOME . '/.local/.cache/neosnippet'
    let g:neosnippet#disable_select_mode_mappings = 0

    let g:neosnippet#disable_runtime_snippets =
      \ get(g:, 'neosnippet#disable_runtime_snippets', {})
    let g:neosnippet#disable_runtime_snippets._ = 1

    imap <C-E> <Plug>(neosnippet_expand_or_jump)
  endfunction

  smap <C-E> <Plug>(neosnippet_expand_or_jump)
  xmap <C-E> <Plug>(neosnippet_expand_target)

  autocmd MyVimrc InsertLeave *
    \ NeoSnippetClearMarkers

  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoSnippetEdit'      : 'neosnippet#edit_complete',
    \ 'NeoSnippetMakeCache' : 'neosnippet#filetype_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" NeoSSH: {{{
if s:has_neobundle && neobundle#tap('neossh')
  autocmd MyVimrc User VimrcPost
    \ if has('vim_starting') && filter(argv(), 'v:val =~# "^ssh:"') != [] |
    \   NeoBundleSource neossh |
    \ endif
endif
"}}}

"------------------------------------------------------------------------------
" OmniSharp: {{{
if s:has_neobundle && neobundle#tap('Omnisharp')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:OmniSharp_typeLookupInPreview    = 0
    let g:OmniSharp_timeout                = 5
    let g:OmniSharp_BufWritePreSyntaxCheck = 1
    let g:Omnisharp_stop_server            = 2
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'OmniSharp#Complete' : '\.\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" Open Browser: {{{
if s:has_neobundle && neobundle#tap('open-browser')
  nmap gxgx <Plug>(openbrowser-smart-search)
  nmap gxx gxgx

  call extend(s:neocompl_vim_completefuncs, {
    \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
    \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})
endif
"}}}

"------------------------------------------------------------------------------
" Operator Camelize: {{{
if s:has_neobundle && neobundle#tap('operator-camelize')
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
if s:has_neobundle && neobundle#tap('operator-filled-with-blank')
  NXOmap s<Space> <Plug>(operator-filled-with-blank)

  nmap s<Space><Space> s<Space>s<Space>
endif
"}}}

"------------------------------------------------------------------------------
" Operator HTML Escape: {{{
if s:has_neobundle && neobundle#tap('operator-html-escape')
  NXOmap se <Plug>(operator-html-escape)
  NXOmap sE <Plug>(operator-html-unescape)

  nmap see sese
  nmap sEE sEsE
endif
"}}}

"------------------------------------------------------------------------------
" Operator Open Browser: {{{
if s:has_neobundle && neobundle#tap('operator-openbrowser')
  NXOmap gx <Plug>(operator-openbrowser)
endif
"}}}

"------------------------------------------------------------------------------
" Operator Replace: {{{
if s:has_neobundle && neobundle#tap('operator-replace')
  NXOmap p <Plug>(operator-replace)

  nnoremap pp p
endif
"}}}

"------------------------------------------------------------------------------
" Operator Reverse: {{{
if s:has_neobundle && neobundle#tap('operator-reverse')
  NXOmap sv <Plug>(operator-reverse-text)
  NXOmap sV <Plug>(operator-reverse-lines)

  nmap svv svsv
  nmap sVV sVsV
endif
"}}}

"------------------------------------------------------------------------------
" Operator Search: {{{
if s:has_neobundle && neobundle#tap('operator-search')
  NXOmap s/ <Plug>(operator-search)

  nmap s// s/s/
endif
"}}}

"------------------------------------------------------------------------------
" Operator Sequence: {{{
if s:has_neobundle && neobundle#tap('operator-sequence')
  NXOmap <expr> s<C-U>
    \ operator#sequence#map("\<Plug>(operator-decamelize)", 'gU')

  nmap s<C-U><C-U> s<C-U>s<C-U>
endif
"}}}

"------------------------------------------------------------------------------
" Operator Shuffle: {{{
if s:has_neobundle && neobundle#tap('operator-shuffle')
  NXOmap sS <Plug>(operator-shuffle)

  nmap sSS sSsS
endif
"}}}

"------------------------------------------------------------------------------
" Operator Sort: {{{
if s:has_neobundle && neobundle#tap('operator-sort')
  NXOmap ss <Plug>(operator-sort)

  nmap sss ssss
endif
"}}}

"------------------------------------------------------------------------------
" Operator Star: {{{
if s:has_neobundle && neobundle#tap('operator-star')
  NOmap *  <Plug>(operator-*)
  NOmap #  <Plug>(operator-#)
  NOmap g* <Plug>(operator-g*)
  NOmap g# <Plug>(operator-g#)

  NOnoremap **   *
  NOnoremap ##   #
  NOnoremap g*g* g*
  NOnoremap g#g# g#

  NOmap g/g/ **
  NOmap g?g? ##
  NOmap g//  **
  NOmap g??  ##
  NOmap g**  g*g*
  NOmap g##  g#g#

  nmap <C-W>*  <SID>(split-nicely)<Plug>(operator-*)
  nmap <C-W>#  <SID>(split-nicely)<Plug>(operator-#)
  nmap <C-W>g* <SID>(split-nicely)<Plug>(operator-g*)
  nmap <C-W>g# <SID>(split-nicely)<Plug>(operator-g#)

  nnoremap <script> <C-W>**   <SID>(split-nicely)*
  nnoremap <script> <C-W>##   <SID>(split-nicely)#
  nnoremap <script> <C-W>g*g* <SID>(split-nicely)g*
  nnoremap <script> <C-W>g#g# <SID>(split-nicely)g#

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
if s:has_neobundle && neobundle#tap('operator-suddendeath')
  NXOmap s! <Plug>(operator-suddendeath)

  nmap s!! s!s!
endif
"}}}

"------------------------------------------------------------------------------
" Operator Surround: {{{
if s:has_neobundle && neobundle#tap('operator-surround')
  NXOmap sa <Plug>(operator-surround-append)
  NXOmap sd <Plug>(operator-surround-delete)
  NXOmap sc <Plug>(operator-surround-replace)

  nmap sdsd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap scsc <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

  nmap saa sasa
  nmap sdd sdsd
  nmap scc scsc
endif
"}}}

"------------------------------------------------------------------------------
" Operator Tabular: {{{
if s:has_neobundle && neobundle#tap('operator-tabular')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('operator-trailingspace-killer')
  NXOmap s$ <Plug>(operator-trailingspace-killer)

  nmap s$$ s$s$
endif
"}}}

"------------------------------------------------------------------------------
" Operator User: {{{
if s:has_neobundle && neobundle#tap('operator-user')
  function! neobundle#tapped.hooks.on_source(bundle)
    call operator#user#define(
      \ 'grep',
      \ 'myvimrc#operator_grep')
    call operator#user#define(
      \ 'justify',
      \ 'myvimrc#operator_justify')
  endfunction

  NXOmap sg <Plug>(operator-grep)
  NXOmap sJ <Plug>(operator-justify)

  nmap sgg sgsg
  nmap sJJ sJsJ

  if neobundle#is_installed('unite')
    nnoremap sgsg :<C-U>execute input(':', 'grep ')<CR>
  endif
endif
"}}}

"------------------------------------------------------------------------------
" ParaJump: {{{
if s:has_neobundle && neobundle#tap('parajump')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('partedit')
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Partedit' : 'partedit#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" PerlOmni: {{{
if s:has_neobundle && neobundle#tap('perlomni')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('precious')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_precious_no_default_key_mappings = 1
    let g:precious_enable_switchers                = {
      \ 'help' : {'setfiletype' : 0}}
  endfunction

  function! neobundle#tapped.hooks.on_post_source(bundle)
    let &statusline = substitute(&statusline, '%y', '%{StatusLine_y()}', '')
  endfunction

  function! StatusLine_y()
    if &l:filetype == ''
      return ''
    endif

    let context = precious#context_filetype()
    return '[' . &l:filetype .
      \ (&l:filetype != context ? (':' . context) : '') . ']'
  endfunction

  XOmap ax <Plug>(textobj-precious-i)
  XOmap ix <Plug>(textobj-precious-i)
endif
"}}}

"------------------------------------------------------------------------------
" Quickhl: {{{
if s:has_neobundle && neobundle#tap('quickhl')
  NXmap  sM <Plug>(quickhl-manual-reset)
  NXOmap sm <Plug>(operator-quickhl-manual-this-motion)

  nmap smm smsm
endif
"}}}

"------------------------------------------------------------------------------
" QuickRun: {{{
if s:has_neobundle && neobundle#tap('quickrun')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:quickrun_no_default_key_mappings = 1

    let g:quickrun_config =
      \ get(g:, 'quickrun_config', {})

    call extend(g:quickrun_config, {
      \ '_' : {
      \   'runner' : s:has_vimproc() ? 'vimproc' : 'system',
      \   'runner/vimproc/updatetime' : 100},
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
      \   'hook/vcvarsall/bat' : shellescape($VCVARSALL)},
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
      \   'hook/vcvarsall/bat' : shellescape($VCVARSALL)},
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
      \   'hook/vcvarsall/bat' : shellescape($VCVARSALL)},
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
      \   'hook/vcvarsall/bat' : shellescape($VCVARSALL)}})

    nnoremap <expr> <C-C>
      \ quickrun#is_running() ? quickrun#sweep_sessions() : '<C-C>'
  endfunction

  nmap <expr> sr
    \ neobundle#is_installed('precious') ?
    \   '<Plug>(precious-quickrun-op)' : '<Plug>(quickrun-op)'
  xmap sr  <Plug>(quickrun)
  omap sr  g@
  nmap srr srsr

  NXmap <Leader>r <Plug>(quickrun)
  NXmap <F5>      <Plug>(quickrun)

  call extend(s:neocompl_vim_completefuncs, {
    \ 'QuickRun' : 'quickrun#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" Reanimate: {{{
if s:has_neobundle && neobundle#tap('reanimate')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:reanimate_save_dir = $HOME . '/.local/reanimate'
  endfunction

  NXnoremap <Leader>us  <Nop>
  NXnoremap <Leader>usl :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_load<CR>
  NXnoremap <Leader>uss :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_save<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Ref: {{{
if s:has_neobundle && neobundle#tap('ref')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:ref_no_default_key_mappings = 1
    let g:ref_cache_dir               = $HOME . '/.local/.vim_ref_cache'
  endfunction

  NXmap K <Plug>(ref-keyword)

  call extend(s:neocompl_vim_completefuncs, {
    \ 'Ref' : 'ref#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" RengBang: {{{
if s:has_neobundle && neobundle#tap('rengbang')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('repeat')
  nnoremap <M-o>
    \ :<C-U>call append(line('.'), repeat([''], v:count1))<Bar>
    \ call repeat#set('<M-o>', v:count1)<CR>
  nnoremap <M-O>
    \ :<C-U>call append(line('.') - 1, repeat([''], v:count1))<Bar>
    \ call repeat#set('<M-O>', v:count1)<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Scratch: {{{
if s:has_neobundle && neobundle#tap('scratch')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:scratch_buffer_name = '[scratch]'

    call operator#user#define_ex_command(
      \ 'scratch-evaluate',
      \ 'ScratchEvaluate')
    call operator#user#define_ex_command(
      \ 'scratch-evaluate!',
      \ 'ScratchEvaluate!')
  endfunction

  autocmd MyVimrc User PluginScratchInitializeAfter
    \ nmap <buffer> sr <Plug>(operator-scratch-evaluate)
endif
"}}}

"------------------------------------------------------------------------------
" SmartWord: {{{
if s:has_neobundle && neobundle#tap('smartword')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('snowdrop')
  function! neobundle#tapped.hooks.on_source(bundle)
    if has('win64')
      let g:snowdrop#libclang_directory = $HOME . '/bin64'
      let g:snowdrop#libclang_file      = 'libclang.dll'
    elseif has('win32')
      let g:snowdrop#libclang_directory = $HOME . '/bin'
      let g:snowdrop#libclang_file      = 'libclang.dll'
    elseif filereadable($HOME . '/lib/libclang.so')
      let g:snowdrop#libclang_directory = $HOME . '/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    elseif filereadable(expand('/usr/local/lib/libclang.so'))
      let g:snowdrop#libclang_directory = '/usr/local/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    elseif filereadable(expand('/usr/lib/libclang.so'))
      let g:snowdrop#libclang_directory = '/usr/lib'
      let g:snowdrop#libclang_file      = 'libclang.so'
    endif
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Switch: {{{
if s:has_neobundle && neobundle#tap('switch')
  function! neobundle#tapped.hooks.on_source(bundle)
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
          call extend(inc, {'\C' . s1[0:3] . '\@!' : s2[:2]})
        endif
        if len(s2) > 3
          call extend(dec, {'\C' . s2[0:3] . '\@!' : s1[:2]})
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
      \ '\C\(-\?\d\+\)\%(TH\|ST\|ND\|RD\)' :
      \   '\=toupper(call(''myvimrc#ordinal'', [submatch(1) + 1]))',
      \ '\C\(-\?\d\+\)\%(th\|st\|nd\|rd\)' :
      \   '\=tolower(call(''myvimrc#ordinal'', [submatch(1) + 1]))'}])
    call extend(g:switch_decrement_definitions, [{
      \ '\C\(-\?\d\+\)\%(TH\|ST\|ND\|RD\)' :
      \   '\=toupper(call(''myvimrc#ordinal'', [submatch(1) - 1]))',
      \ '\C\(-\?\d\+\)\%(th\|st\|nd\|rd\)' :
      \   '\=tolower(call(''myvimrc#ordinal'', [submatch(1) - 1]))'}])

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
" TComment: {{{
if s:has_neobundle && neobundle#tap('tcomment')
  function! neobundle#tapped.hooks.on_source(bundle)
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

  function! neobundle#tapped.hooks.on_post_source(bundle)
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
if s:has_neobundle && neobundle#tap('tern')
  call extend(s:neocompl_force_omni_patterns, {
    \ 'tern#Complete' : '\.\h\w*'})
endif
"}}}

"------------------------------------------------------------------------------
" TextManipilate: {{{
if s:has_neobundle && neobundle#tap('textmanip')
  function! neobundle#tapped.hooks.on_source(bundle)
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
  endfunction

  NOmap <M-p> <Plug>(operator-textmanip-duplicate-down)
  NOmap <M-P> <Plug>(operator-textmanip-duplicate-up)
  xmap  <M-p> <Plug>(textmanip-duplicate-down)
  xmap  <M-P> <Plug>(textmanip-duplicate-up)

  NOmap sj <Plug>(operator-textmanip-move-down)
  NOmap sk <Plug>(operator-textmanip-move-up)
  NOmap sh <Plug>(operator-textmanip-move-left)
  NOmap sl <Plug>(operator-textmanip-move-right)
  xmap  sj <Plug>(textmanip-move-down)
  xmap  sk <Plug>(textmanip-move-up)
  xmap  sh <Plug>(textmanip-move-left)
  xmap  sl <Plug>(textmanip-move-right)

  nmap sjj sjsj
  nmap skk sksk
  nmap shh shsh
  nmap sll slsl
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Between: {{{
if s:has_neobundle && neobundle#tap('textobj-between')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_between_no_default_key_mappings = 1
  endfunction

  XOmap af <Plug>(textobj-between-a)
  XOmap if <Plug>(textobj-between-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Comment: {{{
if s:has_neobundle && neobundle#tap('textobj-comment')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  XOmap ac <Plug>(textobj-comment-a)
  XOmap ic <Plug>(textobj-comment-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Continuous Line: {{{
if s:has_neobundle && neobundle#tap('textobj-continuous-line')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_continuous_line_no_default_key_mappings = 1
    let g:textobj_continuous_line_no_default_mappings     = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj DateTime: {{{
if s:has_neobundle && neobundle#tap('textobj-datetime')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_datetime_no_default_key_mappings = 1
  endfunction

  XOnoremap ad <Nop>
  XOmap ada <Plug>(textobj-datetime-auto)
  XOmap add <Plug>(textobj-datetime-date)
  XOmap adf <Plug>(textobj-datetime-full)
  XOmap adt <Plug>(textobj-datetime-time)
  XOmap adz <Plug>(textobj-datetime-tz)

  XOnoremap id <Nop>
  XOmap ida <Plug>(textobj-datetime-auto)
  XOmap idd <Plug>(textobj-datetime-date)
  XOmap idf <Plug>(textobj-datetime-full)
  XOmap idt <Plug>(textobj-datetime-time)
  XOmap idz <Plug>(textobj-datetime-tz)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Diff: {{{
if s:has_neobundle && neobundle#tap('textobj-diff')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_diff_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Entrie: {{{
if s:has_neobundle && neobundle#tap('textobj-entire')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  XOmap ae <Plug>(textobj-entire-a)
  XOmap ie <Plug>(textobj-entire-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj EnclosedSyntax: {{{
if s:has_neobundle && neobundle#tap('textobj-enclosedsyntax')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_enclosedsyntax_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Fold: {{{
if s:has_neobundle && neobundle#tap('textobj-fold')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_fold_no_default_key_mappings = 1
  endfunction

  XOmap az <Plug>(textobj-fold-a)
  XOmap iz <Plug>(textobj-fold-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Function: {{{
if s:has_neobundle && neobundle#tap('textobj-function')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_function_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Ifdef: {{{
if s:has_neobundle && neobundle#tap('textobj-ifdef')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj IndentBlock: {{{
if s:has_neobundle && neobundle#tap('textobj-indblock')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('textobj-indent')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('textobj-jabraces')
  function! neobundle#tapped.hooks.on_source(bundle)
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
" TextObj Line: {{{
if s:has_neobundle && neobundle#tap('textobj-line')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  XOmap al <Plug>(textobj-line-a)
  XOmap il <Plug>(textobj-line-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj MultiBlock: {{{
if s:has_neobundle && neobundle#tap('textobj-multiblock')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_multiblock_no_default_key_mappings = 1
  endfunction

  XOmap ab <Plug>(textobj-multiblock-a)
  XOmap ib <Plug>(textobj-multiblock-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj MultiTextObj: {{{
if s:has_neobundle && neobundle#tap('textobj-multitextobj')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_multitextobj_textobjects_group_a = {
      \ 'doublequotes' : [
      \   {'textobj' : 'a"',  'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'singlequotes' : [
      \   {'textobj' : 'a''', 'is_cursor_in' : 1, 'noremap' : 1}],
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
      \   {'textobj' : 'i''', 'is_cursor_in' : 1, 'noremap' : 1}],
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
if s:has_neobundle && neobundle#tap('textobj-motionmotion')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_motionmotion_no_default_key_mappings = 1
  endfunction

  XOmap am <Plug>(textobj-motionmotion-a)
  XOmap im <Plug>(textobj-motionmotion-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Parameter: {{{
if s:has_neobundle && neobundle#tap('textobj-parameter')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  XOmap a, <Plug>(textobj-parameter-a)
  XOmap i, <Plug>(textobj-parameter-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj PHP: {{{
if s:has_neobundle && neobundle#tap('textobj-php')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_php_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Python: {{{
if s:has_neobundle && neobundle#tap('textobj-python')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_python_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Ruby: {{{
if s:has_neobundle && neobundle#tap('textobj-ruby')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_ruby_no_default_key_mappings = 1
    let g:textobj_ruby_more_mappings           = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Sigil: {{{
if s:has_neobundle && neobundle#tap('textobj-sigil')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Space: {{{
if s:has_neobundle && neobundle#tap('textobj-space')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_space_no_default_key_mappings = 1
  endfunction

  XOmap aS <Plug>(textobj-space-a)
  XOmap iS <Plug>(textobj-space-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Syntax: {{{
if s:has_neobundle && neobundle#tap('textobj-syntax')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  XOmap ay <Plug>(textobj-syntax-a)
  XOmap iy <Plug>(textobj-syntax-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj Url: {{{
if s:has_neobundle && neobundle#tap('textobj-url')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  XOmap au <Plug>(textobj-url-a)
  XOmap iu <Plug>(textobj-url-i)
endif
"}}}

"------------------------------------------------------------------------------
" TextObj WordInWord: {{{
if s:has_neobundle && neobundle#tap('textobj-wiw')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('textobj-word-column')
  function! neobundle#tapped.hooks.on_source(bundle)
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
if s:has_neobundle && neobundle#tap('textobj-xml-attribute')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:textobj_xmlattribute_no_default_key_mappings = 1
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" UndoTree: {{{
if s:has_neobundle && neobundle#tap('undotree')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:undotree_SetFocusWhenToggle = 1
  endfunction

  NXnoremap <M-U> :<C-U>UndotreeToggle<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unified Diff: {{{
if s:has_neobundle && neobundle#tap('unified-diff')
  set diffexpr=unified_diff#diffexpr()
endif
"}}}

"------------------------------------------------------------------------------
" Unite: {{{
if s:has_neobundle && neobundle#tap('unite')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:unite_data_directory             = $HOME . '/.local/.cache/unite'
    let g:unite_enable_start_insert        = 1
    let g:unite_winheight                  = 25
    let g:unite_candidate_icon             = "-"
    let g:unite_marked_icon                = "+"
    let g:unite_cursor_line_highlight      = 'CursorLine'
    let g:unite_source_history_yank_enable = 1
    let g:unite_source_grep_max_candidates = 1000
    let g:unite_source_grep_encoding       = 'utf-8'

    if !has('win32') && s:executable('find')
      let g:unite_source_rec_async_command = 'find'
    elseif neobundle#is_installed('files') || s:executable('files')
      let g:unite_source_rec_async_command = 'files -p'
    elseif neobundle#is_installed('the_silver_searcher') || s:executable('ag')
      let g:unite_source_rec_async_command =
        \ 'ag --follow --nocolor --nogroup --hidden -g ""'
    endif

    if neobundle#is_installed('jvgrep') || s:executable('jvgrep')
      let g:unite_source_grep_command       = 'jvgrep'
      let g:unite_source_grep_recursive_opt = '-R'
      let g:unite_source_grep_default_opts  = '-n'
    elseif neobundle#is_installed('the_silver_searcher') || s:executable('ag')
      let g:unite_source_grep_command       = 'ag'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_grep_default_opts  =
        \ '--line-numbers --nocolor --nogroup --hidden'
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
      \ (has('win32') ? ':gs?\\?/?' : '') . ':s?/$??' : ''}
    function! g:unite_source_menu_menus.directory_file.map(key, value)
      let d = expand('%') != '' ? expand('%:p:h') : getcwd()
      return {
        \ 'word' : fnamemodify(d, a:key) . '/',
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
      if s:enc_jisx0213
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
      if s:enc_jisx0213
        call extend(g:unite_source_menu_menus.edit_enc.command_candidates, [
          \ ['euc-jisx0213',  'EditEucJisx0213'],
          \ ['iso-2022-jp-3', 'EditIso2022jp']])
      else
        call extend(g:unite_source_menu_menus.edit_enc.command_candidates, [
          \ ['iso-2022-jp', 'EditIso2022jp']])
      endif
    endif
  endfunction

  NXnoremap <Leader>u <Nop>
  NXnoremap <script> <Leader>uu <SID>:<C-U>Unite<Space>

  NXnoremap <Leader>uU
    \ :<C-U>Unite source
    \ -buffer-name=help -no-split<CR>

  NXnoremap <Leader>um :<C-U>Unite menu<CR>
  NXnoremap <Leader>u<CR> :<C-U>Unite menu:set_ff<CR>
  if has('multi_byte')
    NXnoremap <Leader>ue :<C-U>Unite menu:edit_enc<CR>
    NXnoremap <Leader>uf :<C-U>Unite menu:set_fenc<CR>
  endif

  NXnoremap <Leader>b
    \ :<C-U>Unite buffer
    \ -buffer-name=files -no-split<CR>
  NXnoremap <Leader>t
    \ :<C-U>Unite tab
    \ -buffer-name=files -no-split<CR>

  if &grepprg == 'internal'
    nnoremap sgsg
      \ :<C-U>Unite vimgrep
      \ -buffer-name=grep -no-split -wrap<CR>
  else
    nnoremap sgsg
      \ :<C-U>Unite grep
      \ -buffer-name=grep -no-split -wrap<CR>
  endif
  NXnoremap sG
    \ :<C-U>UniteResume grep
    \ -no-split -wrap -no-start-insert<CR>

  NXnoremap <Leader>j
    \ :<C-U>Unite jump
    \ -buffer-name=register -no-empty<CR>
  NXnoremap <Leader>J
    \ :<C-U>Unite change
    \ -buffer-name=register -no-empty<CR>
  nnoremap <C-P>
    \ :<C-U>Unite history/yank
    \ -buffer-name=register -no-empty -wrap<CR>
  xnoremap <C-P>
    \ d:<C-U>Unite history/yank
    \ -buffer-name=register -no-empty -wrap<CR>
  inoremap <expr> <C-P>
    \ unite#start_complete('history/yank', {
    \   'buffer_name': 'register',
    \   'is_multi_line' : 1,
    \   'direction' : 'leftabove'})

  NXnoremap <Leader>un
    \ :<C-U>UniteResume search -start-insert<CR>

  NXnoremap <Leader>u/
    \ :<C-U>Unite line
    \ -buffer-name=search -no-split -start-insert<CR>
  NXnoremap <Leader>u?
    \ :<C-U>Unite line:backward
    \ -buffer-name=search -no-split -start-insert<CR>
  NXnoremap <Leader>u*
    \ :<C-U>UniteWithCursorWord line
    \ -buffer-name=search -no-split -no-start-insert<CR>
  NXnoremap <Leader>u#
    \ :<C-U>UniteWithCursorWord line:backward
    \ -buffer-name=search -no-split -no-start-insert<CR>

  NXmap <Leader>ug/ <Leader>u*
  NXmap <Leader>ug? <Leader>u#

  call extend(s:altercmd_define, {
    \ 'u[nite]' : 'Unite'})
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Unite'                   : 'unite#complete_source',
    \ 'UniteWithCurrentDir'     : 'unite#complete_source',
    \ 'UniteWithBufferDir'      : 'unite#complete_source',
    \ 'UniteWithCursorWord'     : 'unite#complete_source',
    \ 'UniteWithInput'          : 'unite#complete_source',
    \ 'UniteWithInputDirectory' : 'unite#complete_source',
    \ 'UniteResume'             : 'unite#complete_buffer_name'})
endif
"}}}

"------------------------------------------------------------------------------
" Unite Help: {{{
if s:has_neobundle && neobundle#tap('unite-help')
  nnoremap <Leader>u<F1>
    \ :<C-U>Unite help
    \ -buffer-name=help -start-insert<CR>
  nnoremap <Leader>u<F2>
    \ :<C-U>UniteWithCursorWord help
    \ -buffer-name=help -no-start-insert<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite Mark: {{{
if s:has_neobundle && neobundle#tap('unite-mark')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:unite_source_mark_marks =
      \ myvimrc#unite_source_mark_marks()
  endfunction

  nnoremap ml
    \ :<C-U>Unite mark bookmark
    \ -buffer-name=register -no-start-insert -no-empty<CR>
  nnoremap mu :<C-U>UniteBookmarkAdd<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite Outline: {{{
if s:has_neobundle && neobundle#tap('unite-outline')
  NXnoremap <Leader>uo
    \ :<C-U>Unite outline
    \ -buffer-name=outline -no-split<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite QuickFix: {{{
if s:has_neobundle && neobundle#tap('unite-quickfix')
  NXnoremap <Leader>u,
    \ :<C-U>Unite quickfix
    \ -buffer-name=register -no-empty<CR>
  NXnoremap <Leader>u.
    \ :<C-U>Unite location_list
    \ -buffer-name=register -no-empty<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite QuickRun Config: {{{
if s:has_neobundle && neobundle#tap('unite-quickrun_config')
  NXnoremap <Leader>ur
    \ :<C-U>Unite quickrun_config
    \ -buffer-name=register -no-empty<CR>
endif
"}}}

"------------------------------------------------------------------------------
" Unite SUDO: {{{
if s:has_neobundle && neobundle#tap('unite-sudo')
  autocmd MyVimrc User VimrcPost
    \ if has('vim_starting') && filter(argv(), 'v:val =~# "^sudo:"') != [] |
    \   NeoBundleSource unite-sudo |
    \ endif
endif
"}}}

"------------------------------------------------------------------------------
" Unite Tag: {{{
if s:has_neobundle && neobundle#tap('unite-tag')
  NXnoremap <Leader>ut
    \ :<C-U>UniteWithCursorWord tag tag/include
    \ -buffer-name=outline -no-split -no-start-insert<CR>
endif
"}}}

"------------------------------------------------------------------------------
" VCS: {{{
if s:has_neobundle && neobundle#tap('vcs')
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Vcs' : 'vcs#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" VeryftEnc: {{{
if s:has_neobundle && neobundle#tap('verifyenc')
  autocmd MyVimrc BufReadPre *
    \ NeoBundleSource verifyenc
endif
"}}}

"------------------------------------------------------------------------------
" VimConsole: {{{
if s:has_neobundle && neobundle#tap('vimconsole')
  call extend(s:neocompl_vim_completefuncs, {
    \ 'VimConsoleLog'   : 'expression',
    \ 'VimConsoleWarn'  : 'expression',
    \ 'VimConsoleError' : 'expression'})
endif
"}}}

"------------------------------------------------------------------------------
" VimDoc Ja: {{{
if s:has_neobundle && neobundle#tap('vimdoc-ja')
  set helplang^=ja
endif
"}}}

"------------------------------------------------------------------------------
" VimFiler: {{{
if s:has_neobundle && neobundle#tap('vimfiler')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimfiler_data_directory      = $HOME . '/.local/.cache/vimfiler'
    let g:vimfiler_as_default_explorer = 1
  endfunction

  let g:loaded_netrwPlugin = 1

  NXnoremap <Leader>E     :<C-U>VimFiler<CR>
  NXnoremap <Leader><C-E> :<C-U>VimFilerExplorer<CR>

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
" VimProc: {{{
if s:has_neobundle && neobundle#tap('vimproc')
  function! neobundle#tapped.hooks.on_source(bundle)
    if s:is_android
      let g:vimproc_dll_path = '/data/local/vimproc_unix.so'
    endif
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" VimShell: {{{
if s:has_neobundle && neobundle#tap('vimshell')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimshell_data_directory           = $HOME . '/.local/.cache/vimshell'
    let g:vimshell_vimshrc_path             = $HOME . '/.vim/.vimshrc'
    let g:vimshell_max_command_history      = 100000
    let g:vimshell_no_save_history_commands = {}
    let g:vimshell_scrollback_limit         = 500
    let g:vimshell_prompt                   = '$ '
    let g:vimshell_secondary_prompt         = '> '
    let g:vimshell_right_prompt             =
      \ 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

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

  NXnoremap <Leader>! :<C-U>VimShell<CR>

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
if s:has_neobundle && neobundle#tap('vinarize')
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Vinarise'     : 'vinarise#complete',
    \ 'VinariseDump' : 'vinarise#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" VisualStar: {{{
if s:has_neobundle && neobundle#tap('visualstar')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:visualstar_no_default_key_mappings = 1
  endfunction

  xmap *  <Plug>(visualstar-*)
  xmap #  <Plug>(visualstar-#)
  xmap g* <Plug>(visualstar-g*)
  xmap g# <Plug>(visualstar-g#)

  xmap <SID>(visualstar-*)  <Plug>(visualstar-*)
  xmap <SID>(visualstar-#)  <Plug>(visualstar-#)
  xmap <SID>(visualstar-g*) <Plug>(visualstar-g*)
  xmap <SID>(visualstar-g#) <Plug>(visualstar-g#)

  xnoremap <script> <C-W>*
    \ <SID>(split-nicely)gv<SID>(visualstar-*)
  xnoremap <script> <C-W>#
    \ <SID>(split-nicely)gv<SID>(visualstar-#)
  xnoremap <script> <C-W>g*
    \ <SID>(split-nicely)gv<SID>(visualstar-g*)
  xnoremap <script> <C-W>g#
    \ <SID>(split-nicely)gv<SID>(visualstar-g#)
endif
"}}}

"------------------------------------------------------------------------------
" VisualStudio: {{{
if s:has_neobundle && neobundle#tap('visualstudio')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:visualstudio_controllerpath =
      \ neobundle#get('VisualStudioController').path .
      \ '/bin/VisualStudioController.exe'
  endfunction
endif
"}}}

"------------------------------------------------------------------------------
" Vital: {{{
if s:has_neobundle && neobundle#tap('vital')
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Vitalize' : 'vitalizer#complete'})
endif
"}}}

"------------------------------------------------------------------------------
" WatchDogs: {{{
if s:has_neobundle && neobundle#tap('watchdogs')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enable = 1

    let g:quickrun_config =
      \ get(g:, 'quickrun_config', {})

    call extend(g:quickrun_config, {
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
      \   'hook/vcvarsall/bat' : shellescape($VCVARSALL)},
      \
      \ 'vim/watchdogs_checker' : {
      \   'type' :
      \     has('python') ? 'watchdogs_checker/vimlint_by_dbakker' : ''}})

    call watchdogs#setup(g:quickrun_config)
  endfunction

  call extend(s:neocompl_vim_completefuncs, {
    \ 'WatchdogsRun'       : 'quickrun#complete',
    \ 'WatchdogsRunSilent' : 'quickrun#complete'})
endif
"}}}

"==============================================================================
" Post Init: {{{
silent! call neobundle#untap()

if filereadable($HOME . '/.local/.vimrc_local.vim')
  source ~/.local/.vimrc_local.vim
endif

if exists('#User#VimrcPost')
  execute 'doautocmd' (s:has_patch(7, 3, 438) ? '<nomodeline>' : '')
    \ 'User VimrcPost'
endif
"}}}
