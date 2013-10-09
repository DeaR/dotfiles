" Vim settings
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  09-Oct-2013.
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

scriptencoding utf-8

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
let s:cmdwin_enable = 1

" Grep
let s:jvgrep_enable = 1
let s:ag_enable     = 1

" AlterCommand
let s:altercmd_define = {}

" NeoComplete or NeoComplCache
let s:neocompl_keyword_patterns = {}
let s:neocompl_vim_completefuncs = {}
let s:neocompl_dictionary_filetype_lists = {}
let s:neocompl_force_omni_patterns = {}
let s:neocompl_omni_patterns = {}

" VCvarsall.bat
if has('win32') && !exists('$VCVARSALL')
  let s:save_ssl = &shellslash
  set noshellslash
  if exists('$VS120COMNTOOLS')
    let $VCVARSALL = shellescape($VS120COMNTOOLS . '..\..\VC\vcvarsall.bat')
  elseif exists('$VS110COMNTOOLS')
    let $VCVARSALL = shellescape($VS110COMNTOOLS . '..\..\VC\vcvarsall.bat')
  elseif exists('$VS100COMNTOOLS')
    let $VCVARSALL = shellescape($VS100COMNTOOLS . '..\..\VC\vcvarsall.bat')
  elseif exists('$VS90COMNTOOLS')
    let $VCVARSALL = shellescape($VS90COMNTOOLS  . '..\..\VC\vcvarsall.bat')
  elseif exists('$VS80COMNTOOLS')
    let $VCVARSALL = shellescape($VS80COMNTOOLS  . '..\..\VC\vcvarsall.bat')
  endif
  let &shellslash = s:save_ssl
  unlet s:save_ssl
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
  let s:_SID_PREFIX = get(s:, '_SID_PREFIX',
    \ matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$'))
  return s:_SID_PREFIX
endfunction

" Check Vim version
function! s:has_patch(version, patch)
  return (v:version > a:version) || (v:version == a:version &&
    \ has(type(a:patch) == type(0) ? ('patch' . a:patch) : a:patch))
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
  let s:_executable[a:expr] = get(s:_executable, a:expr, executable(a:expr))
  return s:_executable[a:expr]
endfunction

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' || $VIM =~? 'net\.momodalo\.app\.vimtouch')
"}}}

"------------------------------------------------------------------------------
" NeoBundle: {{{
if isdirectory($HOME . '/.local/bundle/neobundle')
  set runtimepath+=~/.local/bundle/neobundle
  let g:neobundle#enable_name_conversion = 1
  let g:neobundle#enable_tail_path       = 1
  let g:neobundle#install_max_processes  =
    \ has('win32') ? str2nr($NUMBER_OF_PROCESSORS) : 1
  if s:is_android
    let g:neobundle#types#git#default_protocol = 'ssh'
    let g:neobundle#types#hg#default_protocol  = 'ssh'
  endif
  call neobundle#rc($HOME . '/.local/bundle')

  NeoBundleLazy 'h1mesuke/vim-alignta', {
    \ 'autoload' : {
    \   'commands' : ['Align', 'Alignta'],
    \   'mappings' : [['nvo', '<Plug>(operator-alignta)']],
    \   'unite_sources' : 'alignta'}}

  NeoBundleLazy 'tyru/vim-altercmd', {
    \ 'autoload' : {
    \   'commands' : [
    \     'AlterCommand',  'NAlterCommand', 'OAlterCommand',
    \     'VAlterCommand', 'XAlterCommand', 'SAlterCommand',
    \     'IAlterCommand', 'CAlterCommand', 'LAlterCommand']}}

  NeoBundleLazy 'kana/vim-altr', {
    \ 'autoload' : {
    \   'mappings' : [['nvoi', '<Plug>(altr-']]}}

  NeoBundleLazy 'osyo-manga/vim-anzu', {
    \ 'autoload' : {
    \   'commands' : [
    \     'AnzuClearSearchStatus',  'AnzuClearSearchCache',
    \     'AnzuUpdateSearchStatus', 'AnzuUpdateSearchStatusOutput',
    \     'AnzuSignMatchLine',      'AnzuClearSignMatchLine'],
    \   'mappings' : [['n', '<Plug>(anzu-']]}}

  NeoBundleLazy 'gist:iori-yja/1615430', {
    \ 'name' : 'arm',
    \ 'script_type' : 'syntax',
    \ 'autoload' : {
    \   'filetypes' : 'arm'}}

  NeoBundleLazy 'autodate.vim', {
    \ 'autoload' : {
    \   'commands' : ['Autodate', 'AutodateON', 'AutodateOFF']}}

  NeoBundleLazy 'vim-jp/autofmt'

  NeoBundleLazy 'h1mesuke/vim-benchmark'

  NeoBundleLazy 'mattn/benchvimrc-vim', {
    \ 'autoload' : {
    \   'commands' : 'BenchVimrc'}}

  if has('python') && s:executable('clang')
    NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {
      \   'filetypes' : ['c', 'cpp', 'objc', 'objcpp']}}
  endif

  NeoBundleLazy 'rhysd/clever-f.vim', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(clever-f-']],
    \   'insert' : 1}}

  NeoBundleLazy 'deris/columnjump', {
    \ 'autoload' : {
    \   'commands' : ['ColumnJumpForward', 'ColumnJumpBackward'],
    \   'mappings' : [['nvo', '<Plug>(columnjump-']],
    \   'insert' : 1}}

  NeoBundleLazy 'Shougo/context_filetype.vim'

  NeoBundleLazy 'vim-jp/cpp-vim', {
    \ 'autoload' : {
    \   'filetypes' : [
    \     'c', 'ch', 'cpp', 'cuda', 'cynlib', 'cynpp', 'dtrace', 'esqlc',
    \     'kwt', 'objc', 'objcpp', 'rpcgen', 'splint', 'xs']}}

  NeoBundleLazy 'hail2u/vim-css3-syntax', {
    \ 'autoload' : {
    \   'filetypes' : [
    \     'aspperl', 'aspvbs', 'cf', 'css', 'dtml', 'groovy', 'gsp', 'haml',
    \     'html', 'htmlcheetah', 'htmldjango', 'htmlm4', 'htmlos', 'jsp',
    \     'markdown', 'mason', 'msql', 'php', 'plp', 'phtml', 'sass', 'scss',
    \     'smarty', 'spyce', 'tt2html', 'webmacro', 'wml', 'xhtml']}}

  NeoBundleLazy 'pekepeke/vim-csvutil'

  NeoBundleLazy 'JesseKPhillips/d.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'd'}}

  NeoBundleLazy 'tpope/vim-dispatch', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Dispatch',
    \      'complete' : 'custom,dispatch#command_complete'},
    \     {'name' : 'FocusDispatch',
    \      'complete' : 'custom,dispatch#command_complete'},
    \     {'name' : 'Start',
    \      'complete' : 'custom,dispatch#command_complete'},
    \     {'name' : 'Make',
    \      'complete' : 'file'},
    \     'Copen']}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Dispatch'      : 'dispatch#command_complete',
    \ 'FocusDispatch' : 'dispatch#command_complete',
    \ 'Start'         : 'dispatch#command_complete'})

  NeoBundleLazy 'mattn/emmet-vim', {
    \ 'autoload' : {
    \   'commands' : 'Emmet',
    \   'mappings' : [['nvi', '<C-Y>']]}}

  NeoBundleLazy 'tyru/eskk.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'skkdict',
    \   'commands' : [
    \     'EskkMap', 'EskkForgetRegisteredWords',
    \     'EskkReload', 'EskkUpdateDictionary',
    \     {'name' : 'EskkFixDictionary',
    \      'complete' : 'file'}],
    \   'mappings' : [['i', '<Plug>(eskk:']]}}

  NeoBundleLazy 'kana/vim-filetype-haskell', {
    \ 'autoload' : {
    \   'filetypes' : 'haskell'}}

  NeoBundleLazy 'thinca/vim-ft-clojure', {
    \ 'autoload' : {
    \   'filetypes' : 'clojure'}}

  NeoBundleLazy 'thinca/vim-ft-diff_fold', {
    \ 'autoload' : {
    \   'filetypes' : 'diff'}}

  NeoBundleLazy 'thinca/vim-ft-help_fold', {
    \ 'autoload' : {
    \   'filetypes' : 'help'}}

  NeoBundleLazy 'thinca/vim-ft-markdown_fold', {
    \ 'autoload' : {
    \   'filetypes' : 'markdown'}}

  NeoBundleLazy 'thinca/vim-ft-vim_fold', {
    \ 'autoload' : {
    \   'filetypes' : 'vim'}}

  if has('lua') || s:executable('lua')
    NeoBundleLazy 'xolox/vim-lua-ftplugin', {
      \ 'name' : 'ft_lua',
      \ 'autoload' : {
      \   'filetypes' : 'lua',
      \   'commands' : ['LuaCheckSyntax', 'LuaCheckGlobals']},
      \ 'depends' : 'xolox/vim-misc'}
  endif

  NeoBundleLazy 'tpope/vim-fugitive', {
    \ 'autoload' : {
    \   'commands' : [
    \     'Git', 'Gcd', 'Glcd', 'Gstatus', 'Gcommit', 'Ggrep', 'Glgrep',
    \     'Glog', 'Gllog', 'Ge', 'Gedit', 'Gpedit', 'Gsplit', 'Gvsplit',
    \     'Gtabedit', 'Gread', 'Gwrite', 'Gw', 'Gwq',
    \     'Gdiff', 'Gvdiff', 'Gsdiff', 'Gbrowse']}}

  NeoBundleLazy 'kana/vim-gf-user', {
    \ 'autoload' : {
    \   'commands' : 'GfUserDefaultKeyMappings',
    \   'mappings' : [['nv', '<Plug>(gf-user-']]},
    \ 'depends' : [
    \   'sgur/vim-gf-autoload',
    \   'kana/vim-gf-diff']}

  NeoBundleLazy 'eagletmt/ghcmod-vim', {
    \ 'autoload' : {
    \   'filetypes' : 'haskell'}}

  NeoBundleLazy 'gregsexton/gitv', {
    \ 'autoload' : {
    \   'commands' : 'Gitv'},
    \ 'depends' : 'tpope/vim-fugitive'}

  if s:executable('go')
    NeoBundleLazy 'nsf/gocode', {
      \ 'rtp' : 'vim',
      \ 'autoload' : {
      \   'filetypes' : 'go'},
      \ 'build' : {
      \   'others' : 'go get -u github.com/nsf/gocode'}}
  endif

  NeoBundleLazy 'jnwhiteh/vim-golang', {
    \ 'autoload' : {
    \   'filetypes' : 'go',
    \   'commands' : [
    \     {'name' : 'Godoc',
    \      'complete' : 'customlist,go#complete#Package'}],
    \   'mappings' : [['n', '<Plug>(godoc-keyword)']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Godoc' : 'go#complete#Package'})

  if s:executable('go')
    NeoBundleLazy 'golang/lint', {
      \ 'name' : 'golint',
      \ 'rtp' : 'misc/vim',
      \ 'autoload' : {
      \   'filetypes' : 'go'},
      \ 'build' : {
      \   'others' : 'go get -u github.com/golang/lint/golint'}}
  endif

  NeoBundleLazy 'kana/vim-grex', {
    \ 'autoload' : {
    \   'commands' : ['Gred', 'Grey'],
    \   'mappings' : [['nvo', '<Plug>(operator-grex-']]}}

  NeoBundleLazy 'rbtnn/hexript.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'HexriptToBinaryFile',
    \      'complete' : 'file'}]}}

  NeoBundleLazy 'cohama/vim-hier', {
    \ 'autoload' : {
    \   'filetypes' : 'qf',
    \   'commands' : ['HierUpdate', 'HierClear', 'HierStart', 'HierStop']}}

  NeoBundleLazy 'othree/html5.vim', {
    \ 'autoload' : {
    \   'filetypes' : [
    \     'aspperl', 'aspvbs', 'cf', 'dtml', 'eruby',  'groovy', 'gsp',
    \     'haml', 'html', 'htmlcheetah', 'htmldjango', 'htmlm4', 'htmlos',
    \     'javascript', 'jsp', 'liquid', 'markdown', 'mason', 'msql',
    \     'php', 'phtml', 'plp', 'smarty', 'spyce', 'tt2html', 'tt2js',
    \     'webmacro', 'wml', 'xhtml']}}

  NeoBundleLazy 'HybridText', {
    \ 'autoload' : {
    \   'filetypes' : ['hybrid', 'text']}}

  if has('conceal')
    NeoBundle 'Yggdroot/indentLine'
  endif

  NeoBundleLazy 'basyura/J6uil.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     'J6uilReconnect', 'J6uilDisconnect',
    \     {'name' : 'J6uil',
    \      'complete' : 'custom,J6uil#complete#room'}],
    \   'mappings' : [['n', '<Plug>(J6uil_']],
    \   'function_prefix' : 'J6uil',
    \   'unite_sources' : ['J6uil/rooms', 'J6uil/members']}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'J6uil' : 'J6uil#complete#room'})

  NeoBundleLazy 'jelera/vim-javascript-syntax', {
    \ 'autoload' : {
    \   'filetypes' : ['javascript', 'tt2js']}}

  if has('python') || has('python3')
    NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'autoload' : {
      \   'filetypes' : ['pyrex', 'python'],
      \   'commands' : [
      \     {'name' : 'Pyimport',
      \      'complete' : 'custom,jedi#py_import_completions'}]}}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'Pyimport' : 'jedi#py_import_completions'})
  endif

  NeoBundleLazy 'elzr/vim-json', {
    \ 'autoload' : {
    \   'filetypes' : 'json'}}

  if s:jvgrep_enable && s:executable('go')
    NeoBundleFetch 'mattn/jvgrep', {
      \ 'build' : {
      \   'others' : 'go get -u github.com/mattn/jvgrep'}}
  endif

  NeoBundleLazy 'kwbdi.vim', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>Kwbd']],
    \   'commands' : 'Kwbd'}}

  NeoBundleLazy 'thinca/vim-localrc'

  NeoBundleLazy 'https://raw.github.com/januswel/dotfiles/master/.vim/syntax/mayu.vim', {
    \ 'name' : 'mayu',
    \ 'script_type' : 'syntax',
    \ 'autoload' : {
    \   'filetypes' : 'mayu'}}

  if has('unix') && !has('gui_running')
    NeoBundle 'gist:DeaR/5560785', {
      \ 'name' : 'map-alt-keys',
      \ 'script_type' : 'plugin'}
  endif

  NeoBundleLazy 'gist:DeaR/5558981', {
    \ 'name' : 'maplist',
    \ 'script_type' : 'plugin',
    \ 'autoload' : {
    \   'commands' : [
    \     'MapList',  'NMapList', 'OMapList',
    \     'VMapList', 'XMapList', 'SMapList',
    \     'IMapList', 'CMapList', 'LMapList']}}

  NeoBundleLazy 'xolox/vim-misc', {
    \ 'autoload' : {
    \   'function_prefix' : 'xolox'}}

  NeoBundle 'tomasr/molokai'

  NeoBundleLazy 'kana/vim-narrow', {
    \ 'autoload' : {
    \   'commands' : ['Narrow', 'Widen'],
    \   'mappings' : [['nvo', '<Plug>(operator-narrow)']]}}

  NeoBundleFetch 'Shougo/neobundle.vim'
  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoBundleSource'    : 'neobundle#complete_lazy_bundles',
    \ 'NeoBundleDisable'   : 'neobundle#complete_bundles',
    \ 'NeoBundleInstall'   : 'neobundle#complete_bundles',
    \ 'NeoBundleUpdate'    : 'neobundle#complete_bundles',
    \ 'NeoBundleClean'     : 'neobundle#complete_deleted_bundles',
    \ 'NeoBundleReinstall' : 'neobundle#complete_bundles'})

  if has('lua') && s:has_patch(703, 885)
    NeoBundleLazy 'Shougo/neocomplete.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'NeoCompleteEnable', 'NeoCompleteDisable',
      \     'NeoCompleteLock',   'NeoCompleteUnlock',
      \     'NeoCompleteToggle', 'NeoCompleteClean',
      \     'NeoCompleteTagMakeCache',
      \     {'name' : 'NeoCompleteSetFileType',
      \      'complete' : 'filetype'},
      \     {'name' : 'NeoCompleteBufferMakeCache',
      \      'complete' : 'file'},
      \     {'name' : 'NeoCompleteDictionaryMakeCache',
      \      'complete' : 'customlist,neocomplete#filetype_complete'},
      \     {'name' : 'NeoCompleteIncludeMakeCache',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoCompleteSyntaxMakeCache',
      \      'complete' : 'customlist,neocomplete#filetype_complete'}],
      \   'unite_sources' : ['file_include', 'neocomplete'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'hrsh7th/vim-neco-calc',
      \   'ujihisa/neco-ghc',
      \   'ujihisa/neco-look',
      \   'Shougo/neosnippet.vim']}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'NeoCompleteDictionaryMakeCache' : 'neocomplete#filetype_complete',
      \ 'NeoCompleteSyntaxMakeCache'     : 'neocomplete#filetype_complete'})
  else
    NeoBundleLazy 'Shougo/neocomplcache.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'NeoComplCacheEnable', 'NeoComplCacheDisable',
      \     'NeoComplCacheLock',   'NeoComplCacheLockSource',
      \     'NeoComplCacheUnlock', 'NeoComplCacheUnlockSource',
      \     'NeoComplCacheToggle', 'NeoComplCacheClean',
      \     'NeoComplCacheCachingTags',
      \     {'name' : 'NeoComplCacheSetFileType',
      \      'complete' : 'filetype'},
      \     {'name' : 'NeoComplCacheCachingBuffer',
      \      'complete' : 'file'},
      \     {'name' : 'NeoComplCachePrintSource',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoComplCacheOutputKeyword',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoComplCacheDisableCaching',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoComplCacheEnableCaching',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoComplCacheCachingDictionary',
      \      'complete' : 'customlist,neocomplcache#filetype_complete'},
      \     {'name' : 'NeoComplCacheCachingInclude',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoComplCacheCachingSyntax',
      \      'complete' : 'customlist,neocomplcache#filetype_complete'}],
      \   'unite_sources' : ['file_include', 'neocomplcache'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'hrsh7th/vim-neco-calc',
      \   'ujihisa/neco-ghc',
      \   'ujihisa/neco-look',
      \   'Shougo/neosnippet.vim']}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'NeoComplCacheCachingDictionary' : 'neocomplcache#filetype_complete',
      \ 'NeoComplCacheCachingSyntax'     : 'neocomplcache#filetype_complete'})
  endif

  NeoBundleLazy 'Shougo/neosnippet.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'snippet',
    \   'commands' : [
    \     {'name' : 'NeoSnippetEdit',
    \      'complete' : 'customlist,neosnippet#edit_complete'},
    \     {'name' : 'NeoSnippetMakeCache',
    \      'complete' : 'customlist,neosnippet#filetype_complete'},
    \     {'name' : 'NeoSnippetSource',
    \      'complete' : 'file'}],
    \   'mappings' : [['vi', '<Plug>(neosnippet_']],
    \   'unite_sources' : [
    \     'snippet', 'snippet/target',
    \     'neosnippet/user', 'neosnippet/runtime']}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoSnippetEdit'      : 'neosnippet#edit_complete',
    \ 'NeoSnippetMakeCache' : 'neosnippet#filetype_complete'})

  NeoBundleLazy 'evanmiller/nginx-vim-syntax', {
    \ 'autoload' : {
    \   'filetypes' : 'nginx'}}

  NeoBundleLazy 'Shougo/vim-nyaos', {
    \ 'autoload' : {
    \   'filetypes' : 'nyaos'}}

  if has('python') && (exists('$VCVARSALL') || s:executable('xbuild'))
    NeoBundleLazy 'nosami/Omnisharp', {
      \ 'autoload' : {
      \   'filetypes' : 'cs'},
      \ 'build' : {
      \   'windows' :
      \     $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' .
      \     'msbuild server/OmniSharp.sln /p:Platform="Any CPU"',
      \   'others'  :
      \     'xbuild server/OmniSharp.sln /p:Platform="Any CPU"'}}
  endif

  NeoBundleLazy 'tyru/open-browser.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     'OpenBrowser',
    \     {'name' : 'OpenBrowserSearch',
    \      'complete' : 'customlist,openbrowser#_cmd_complete'},
    \     {'name' : 'OpenBrowserSmartSearch',
    \      'complete' : 'customlist,openbrowser#_cmd_complete'}],
    \   'mappings' : [['nv', '<Plug>(openbrowser-']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
    \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})

  NeoBundleLazy 'thinca/vim-openbuf'

  NeoBundleLazy 'tyru/operator-camelize.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-camelize)', '<Plug>(operator-decamelize)',
    \      '<Plug>(operator-camelize-toggle)']]}}

  NeoBundleLazy 'rhysd/vim-operator-clang-format', {
    \ 'autoload' : {
    \   'commands' : ['ClangFormat', 'ClangFormatEchoFormattedCode'],
    \   'mappings' : [['nvo', '<Plug>(operator-clang-format)']]}}

  NeoBundleLazy 'tyru/operator-html-escape.vim', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-html-']]}}

  NeoBundleLazy 'rhysd/vim-operator-filled-with-blank', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-filled-with-blank)']]}}

  NeoBundleLazy 'sgur/vim-operator-openbrowser', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-openbrowser)']]}}

  NeoBundleLazy 'kana/vim-operator-replace', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-replace)']]}}

  NeoBundleLazy 'tyru/operator-reverse.vim', {
    \ 'autoload' : {
    \   'commands' : 'OperatorReverseLines',
    \   'mappings' : [['nvo', '<Plug>(operator-reverse-']]}}

  NeoBundleLazy 'thinca/vim-operator-sequence', {
    \ 'autoload' : {
    \   'functions' : 'operator#sequence#map'},
    \ 'depends' : 'tyru/operator-camelize.vim'}

  NeoBundleLazy 'pekepeke/vim-operator-shuffle', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-shuffle)']]}}

  NeoBundleLazy 'emonkak/vim-operator-sort', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-sort)']]}}

  NeoBundleLazy 'tyru/operator-star.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-*)', '<Plug>(operator-g*)',
    \      '<Plug>(operator-#)', '<Plug>(operator-g#)']]},
    \ 'depends' : 'thinca/vim-visualstar'}

  NeoBundleLazy 'yomi322/vim-operator-suddendeath', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-suddendeath)']]}}

  NeoBundleLazy 'rhysd/vim-operator-surround', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-surround-']]}}

  NeoBundleLazy 'pekepeke/vim-operator-tabular', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-tabularize)', '<Plug>(operator-untabularize)',
    \      '<Plug>(operator-textile_',    '<Plug>(operator-backlog_',
    \      '<Plug>(operator-md_']]}}

  NeoBundleLazy 'rhysd/vim-operator-trailingspace-killer', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-trailingspace-killer)']]}}

  NeoBundleLazy 'kana/vim-operator-user', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(operator-grep)']],
    \   'function_prefix' : 'operator'}}

  NeoBundleLazy 'deris/parajump', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(parajump-']],
    \   'insert' : 1}}

  NeoBundleLazy 'thinca/vim-partedit', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Partedit',
    \      'complete' : 'customlist,partedit#complete'}]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Partedit' : 'partedit#complete'})

  NeoBundleLazy 'vim-perl/vim-perl', {
    \ 'autoload' : {
    \   'filetypes' : [
    \     'perl', 'perl6', 'pod', 'tt2', 'tt2html', 'tt2js', 'xs']}}

  NeoBundleLazy 'y-uuki/perl-local-lib-path.vim', {
    \ 'autoload' : {
    \   'commands' : 'PerlLocalLibPath'}}

  if s:executable('perl')
    NeoBundleLazy 'c9s/perlomni.vim', {
      \ 'autoload' : {
      \   'filetypes' : 'perl'}}
  endif

  NeoBundleLazy 'shawncplus/phpcomplete.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'php'}}

  NeoBundleLazy '2072/PHP-Indenting-for-VIm', {
    \ 'name' : 'PHPIndent',
    \ 'autoload' : {
    \   'filetypes' : 'php'}}

  NeoBundleLazy 'osyo-manga/vim-precious', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'PreciousSwitch',
    \      'complete' : 'filetype'},
    \     {'name' : 'PreciousSwitchAutcmd',
    \      'complete' : 'filetype'},
    \     'PreciousSetContextLocal', 'PreciousReset',
    \     'TextobjPreciousDefaultKeyMappings'],
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-precious-i)'],
    \     ['n',  '<Plug>(precious-quickrun-op)']]}}

  NeoBundleLazy 'thinca/vim-prettyprint', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'PrettyPrint',
    \      'complete' : 'expression'},
    \     {'name' : 'PP',
    \      'complete' : 'expression'}],
    \   'functions': ['PrettyPrint', 'PP']}}

  NeoBundleLazy 'kannokanno/previm', {
    \ 'autoload' : {
    \   'filetypes' : 'markdown'}}

  NeoBundleLazy 'thinca/vim-qfreplace', {
    \ 'autoload' : {
    \   'filetypes' : ['qf', 'unite']}}

  NeoBundleLazy 'dannyob/quickfixstatus', {
    \ 'autoload' : {
    \   'filetypes' : 'qf',
    \   'commands' : ['QuickfixStatusEnable', 'QuickfixStatusDisable']}}

  NeoBundleLazy 't9md/vim-quickhl', {
    \ 'autoload' : {
    \   'commands' : [
    \     'QuickhlList', 'QuickhlAdd', 'QuickhlLock',   'QuickhlReset',
    \     'QuickhlDump', 'QuickhlDel', 'QuickhlUnlock', 'QuickhlColors',
    \     'QuickhlReloadColors', 'QuickhlMatch', 'QuickhlMatchClear',
    \     'QuickhlMatchAuto', 'QuickhlMatchNoAuto'],
    \   'mappings' : [['nv', '<Plug>(quickhl-']]}}

  NeoBundleLazy 'thinca/vim-quickrun', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'QuickRun',
    \      'complete' : 'customlist,quickrun#complete'}],
    \   'mappings' : [
    \     ['nv', '<Plug>(quickrun)'],
    \     ['n',  '<Plug>(quickrun-op)']]},
    \ 'depends' : [
    \   'osyo-manga/quickrun-hook-vcvarsall',
    \   'osyo-manga/shabadou.vim']}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'QuickRun' : 'quickrun#complete'})

  NeoBundleLazy 'osyo-manga/vim-reanimate', {
    \ 'autoload' : {
    \   'commands' : [
    \     'ReanimateSave', 'ReanimateSaveInput', 'ReanimateSaveCursorHold',
    \     'ReanimateLoad', 'ReanimateLoadInput', 'ReanimateLoadLatest',
    \     'ReanimateSwitch', 'ReanimateUnload', 'ReanimateEditVimrcLocal'],
    \   'unite_sources' : 'reanimate'}}

  NeoBundleLazy 'thinca/vim-ref', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Ref',
    \      'complete' : 'customlist,ref#complete'}],
    \   'mappings' : [['nv', '<Plug>(ref-keyword)']],
    \   'unite_sources' : 'ref'},
    \ 'depends' : 'ujihisa/ref-hoogle'}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Ref' : 'ref#complete'})

  NeoBundleLazy 'deris/vim-rengbang', {
    \ 'autoload' : {
    \   'commands' : ['RengBang', 'RengBangUsePrev'],
    \   'mappings' : [
    \     ['nvo', '<Plug>(operator-rengbang)', '<Plug>(operator-rengbang-']]}}

  NeoBundleLazy 'tpope/vim-repeat'

  NeoBundleLazy 'vim-ruby/vim-ruby', {
    \ 'autoload' : {
    \   'filetypes' : ['eruby', 'haml', 'ruby']}}

  NeoBundleLazy 'DeaR/savevers.vim', {
    \ 'autoload' : {
    \   'commands' : ['Purge', 'VersDiff']}}

  NeoBundleLazy 'thinca/vim-scouter', {
    \ 'autoload' : {
    \   'commands' : 'Scouter'}}

  NeoBundleLazy 'DeaR/vim-scratch', {
    \ 'autoload' : {
    \   'commands' : ['ScratchOpen', 'ScratchClose', 'ScratchEvaluate'],
    \   'mappings' : [['nvo', '<Plug>(scratch-']]}}

  NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
    \ 'autoload' : {
    \   'filetypes' : 'javascript'}}

  if has('clientserver')
    NeoBundleFetch 'thinca/vim-singleton'
  endif

  NeoBundleLazy 'DeaR/vim-smartword', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(smartword-']],
    \   'insert' : 1}}

  NeoBundleLazy 'AndrewRadev/switch.vim', {
    \ 'autoload' : {
    \   'commands' : ['Switch', 'SwitchIncrement', 'SwitchDecrement']}}

  if has('python') && s:executable('node')
    NeoBundleFetch 'marijnh/tern', {
      \ 'build' : {
      \   'others' : 'npm install'}}

    NeoBundleLazy 'marijnh/tern_for_vim', {
      \ 'name' : 'tern_for_vim',
      \ 'autoload' : {
      \   'filetypes' : 'javascript'}}
  else
    NeoBundleLazy 'teramako/jscomplete-vim', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript'}}
  endif

  NeoBundleLazy 'tomtom/tcomment_vim', {
    \ 'name' : 'tcomment',
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'TComment',
    \      'complete' : 'customlist,tcomment#CompleteArgs'},
    \     {'name' : 'TCommentAs',
    \      'complete' : 'customlist,tcomment#Complete'},
    \     {'name' : 'TCommentRight',
    \      'complete' : 'customlist,tcomment#CompleteArgs'},
    \     {'name' : 'TCommentBlock',
    \      'complete' : 'customlist,tcomment#CompleteArgs'},
    \     {'name' : 'TCommentInline',
    \      'complete' : 'customlist,tcomment#CompleteArgs'},
    \     {'name' : 'TCommentMaybeInline',
    \      'complete' : 'customlist,tcomment#CompleteArgs'}],
    \   'mappings' : [
    \     ['nvo', '<Plug>(operator-tcomment)', '<Plug>(operator-tcomment-']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'TComment'            : 'tcomment#CompleteArgs',
    \ 'TCommentAs'          : 'tcomment#Complete',
    \ 'TCommentRight'       : 'tcomment#CompleteArgs',
    \ 'TCommentBlock'       : 'tcomment#CompleteArgs',
    \ 'TCommentInline'      : 'tcomment#CompleteArgs',
    \ 'TCommentMaybeInline' : 'tcomment#CompleteArgs'})

  NeoBundleLazy 't9md/vim-textmanip', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nv',  '<Plug>(textmanip-'],
    \     ['nvo', '<Plug>(operator-textmanip-']]}}

  NeoBundleLazy 'thinca/vim-textobj-between', {
    \ 'autoload' : {
    \   'commands' : 'TextobjBetweenDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-between-']]}}

  NeoBundleLazy 'thinca/vim-textobj-comment', {
    \ 'autoload' : {
    \   'commands' : 'TextobjCommentDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-comment-']]}}

  NeoBundleLazy 'rhysd/vim-textobj-continuous-line', {
    \ 'autoload' : {
    \   'commands' : 'TextobjContinuousDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-continuous-']]}}

  NeoBundleLazy 'kana/vim-textobj-datetime', {
    \ 'autoload' : {
    \   'commands' : 'TextobjDatetimeDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-datetime-']]}}

  NeoBundleLazy 'kana/vim-textobj-diff', {
    \ 'autoload' : {
    \   'commands' : 'TextobjDiffDefaultKeyMappings',
    \   'mappings' : [['nvo', '<Plug>(textobj-diff-']]}}

  NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', {
    \ 'autoload' : {
    \   'commands' : 'TextobjEnclosedsyntaxDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-enclosedsyntax-']]}}

  NeoBundleLazy 'kana/vim-textobj-entire', {
    \ 'autoload' : {
    \   'commands' : 'TextobjEntireDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-entire-']]}}

  NeoBundleLazy 'kana/vim-textobj-fold', {
    \ 'autoload' : {
    \   'commands' : 'TextobjFoldDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-fold-']]}}

  NeoBundleLazy 'kana/vim-textobj-function', {
    \ 'autoload' : {
    \   'commands' : 'TextobjFunctionDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-function-']]},
    \ 'depends' : [
    \   'thinca/vim-textobj-function-javascript',
    \   'thinca/vim-textobj-function-perl',
    \   't9md/vim-textobj-function-ruby']}

  NeoBundleLazy 'anyakichi/vim-textobj-ifdef', {
    \ 'autoload' : {
    \   'commands' : 'TextobjIfdefDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-ifdef-']]}}

  NeoBundleLazy 'glts/vim-textobj-indblock', {
    \ 'autoload' : {
    \   'commands' : 'TextobjIndblockDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-indblock-']]}}

  NeoBundleLazy 'kana/vim-textobj-indent', {
    \ 'autoload' : {
    \   'commands' : 'TextobjIndentDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-indent-']]}}

  NeoBundleLazy 'kana/vim-textobj-jabraces', {
    \ 'autoload' : {
    \   'commands' : 'TextobjJabracesDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-jabraces-']]}}

  NeoBundleLazy 'kana/vim-textobj-line', {
    \ 'autoload' : {
    \   'commands' : 'TextobjLineDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-line-']]}}

  NeoBundleLazy 'hchbaw/textobj-motionmotion.vim', {
    \ 'autoload' : {
    \   'commands' : 'TextobjMotionmotionDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-motionmotion-']]}}

  NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
    \ 'autoload' : {
    \   'commands' : 'TextobjMultiblockDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-multiblock-']]}}

  NeoBundleLazy 'osyo-manga/vim-textobj-multitextobj', {
    \ 'autoload' : {
    \   'commands' : 'TextobjMultitextobjDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-multitextobj-']]},
    \ 'depends' : 'kana/vim-textobj-jabraces'}

  NeoBundleLazy 'sgur/vim-textobj-parameter', {
    \ 'autoload' : {
    \   'commands' : 'TextobjParameterDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-parameter-']]}}

  NeoBundleLazy 'akiyan/vim-textobj-php', {
    \ 'autoload' : {
    \   'commands' : 'TextobjPhpDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-php-']]}}

  NeoBundleLazy 'bps/vim-textobj-python', {
    \ 'autoload' : {
    \   'commands' : 'TextobjPythonDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-python-']]}}

  NeoBundleLazy 'rhysd/vim-textobj-ruby', {
    \ 'autoload' : {
    \   'commands' : 'TextobjRubyDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-ruby-']]}}

  NeoBundleLazy 'vimtaku/vim-textobj-sigil', {
    \ 'autoload' : {
    \   'commands' : 'TextobjSigilDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-sigil-']]}}

  NeoBundleLazy 'saihoooooooo/vim-textobj-space', {
    \ 'autoload' : {
    \   'commands' : 'TextobjSpaceDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-space-']]}}

  NeoBundleLazy 'kana/vim-textobj-syntax', {
    \ 'autoload' : {
    \   'commands' : 'TextobjSyntaxDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-syntax-']]}}

  NeoBundleLazy 'mattn/vim-textobj-url', {
    \ 'autoload' : {
    \   'commands' : 'TextobjUrlDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-url-']]}}

  NeoBundleLazy 'DeaR/vim-textobj-user', {
    \ 'autoload' : {
    \   'function_prefix' : 'textobj'}}

  NeoBundleLazy 'DeaR/vim-textobj-wiw', {
    \ 'autoload' : {
    \   'commands' : 'TextobjWiwDefaultKeyMappings',
    \   'mappings' : [['nvo', '<Plug>(textobj-wiw-']]}}

  NeoBundleLazy 'rhysd/textobj-word-column.vim', {
    \ 'autoload' : {
    \   'commands' : 'TextobjWordcolumnDefaultKeyMappings',
    \   'mappings' : [['nvo', '<Plug>(textobj-wordcolumn-']]}}

  NeoBundleLazy 'akiyan/vim-textobj-xml-attribute', {
    \ 'autoload' : {
    \   'commands' : 'TextobjXmlattributeDefaultKeyMappings',
    \   'mappings' : [['vo', '<Plug>(textobj-xmlattribute-']]}}

  if s:ag_enable
    NeoBundleFetch 'ggreer/the_silver_searcher', {
      \ 'build' : {
      \   'windows' :
      \     'mingw32-make -f ~/.vim/tools/the_silver_searcher/Makefile.w32',
      \   'others'  :
      \     './build.sh && sudo make install'}}
  endif

  NeoBundleLazy 'zaiste/tmux.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'tmux'}}

  NeoBundleLazy 'mbbill/undotree', {
    \ 'autoload' : {
    \   'commands' : 'UndotreeToggle',
    \   'functions' : 'UndotreeToggle'}}

  NeoBundle 'Shougo/unite.vim'
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Unite'                   : 'unite#complete_source',
    \ 'UniteWithCurrentDir'     : 'unite#complete_source',
    \ 'UniteWithBufferDir'      : 'unite#complete_source',
    \ 'UniteWithCursorWord'     : 'unite#complete_source',
    \ 'UniteWithInput'          : 'unite#complete_source',
    \ 'UniteWithInputDirectory' : 'unite#complete_source',
    \ 'UniteResume'             : 'unite#complete_buffer_name'})

  NeoBundleLazy 'Shougo/unite-build', {
    \ 'autoload' : {
    \   'unite_sources' : 'build'}}

  NeoBundleLazy 'osyo-manga/unite-filetype', {
    \ 'autoload' : {
    \   'unite_sources' : 'filetype'}}

  NeoBundleLazy 'osyo-manga/unite-fold', {
    \ 'autoload' : {
    \   'unite_sources' : 'fold'}}

  NeoBundleLazy 'ujihisa/unite-haskellimport', {
    \ 'autoload' : {
    \   'commands' : 'Haskellimport',
    \   'unite_sources' : 'haskellimport'}}

  NeoBundleLazy 'tsukkee/unite-help', {
    \ 'autoload' : {
    \   'unite_sources' : 'help'}}

  NeoBundleLazy 'thinca/vim-unite-history', {
    \ 'autoload' : {
    \   'unite_sources' : ['history/command', 'history/search']}}

  NeoBundleLazy 'KamunagiChiduru/unite-javaimport', {
    \ 'autoload' : {
    \   'unite_sources' : 'javaimport'}}

  NeoBundleLazy 'ujihisa/unite-locate', {
    \ 'autoload' : {
    \   'unite_sources' : 'locate'}}

  NeoBundleLazy 'tacroe/unite-mark', {
    \ 'autoload' : {
    \   'unite_sources' : 'mark'}}

  NeoBundleLazy 'Shougo/unite-outline', {
    \ 'autoload' : {
    \   'unite_sources' : 'outline'}}

  NeoBundleLazy 'y-uuki/unite-perl-module.vim', {
    \ 'autoload' : {
    \   'unite_sources' : ['perl/global', 'perl/local']}}

  NeoBundleLazy 'osyo-manga/unite-quickfix', {
    \ 'autoload' : {
    \   'unite_sources' : ['location_list', 'quickfix']}}

  NeoBundleLazy 'osyo-manga/unite-quickrun_config', {
    \ 'autoload' : {
    \   'unite_sources' : 'quickrun_config'},
    \ 'depends' : 'thinca/vim-quickrun'}

  if has('clientserver')
    NeoBundleLazy 'mattn/unite-remotefile', {
      \ 'autoload' : {
      \   'unite_sources' : 'remotefile'}}
  endif

  NeoBundleLazy 'rhysd/unite-ruby-require.vim', {
    \ 'autoload' : {
    \   'unite_sources' : 'ruby/require'}}

  NeoBundleLazy 'Shougo/unite-ssh', {
    \ 'autoload' : {
    \   'unite_sources' : 'ssh'},
    \ 'depends' : 'Shougo/vimfiler.vim'}

  NeoBundleLazy 'Shougo/unite-sudo', {
    \ 'autoload' : {
    \   'unite_sources' : 'sudo'},
    \ 'depends' : 'Shougo/vimfiler.vim'}

  NeoBundleLazy 'tsukkee/unite-tag', {
    \ 'autoload' : {
    \   'unite_sources' : 'tag'}}

  NeoBundleLazy 'pasela/unite-webcolorname', {
    \ 'autoload' : {
    \   'unite_sources' : 'webcolorname'}}

  NeoBundleLazy 'vbnet.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'vbnet'}}

  NeoBundleLazy 'rbtnn/vbnet_indent.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'vbnet'}}

  if has('iconv')
    NeoBundleLazy 'koron/verifyenc-vim', {
      \ 'autoload' : {
      \   'commands' : 'VerifyEnc'}}
  endif

  NeoBundleLazy 'Shougo/vim-vcs', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Vcs',
    \      'complete' : 'customlist,vcs#complete'}]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Vcs' : 'vcs#complete'})

  NeoBundleLazy 'rbtnn/vimconsole.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     'VimConsoleOpen', 'VimConsoleClose', 'VimConsoleToggle',
    \     'VimConsoleTest', 'VimConsoleClear', 'VimConsoleRedraw',
    \     'VimConsoleDump',
    \     {'name' : 'VimConsole',
    \      'complete' : 'expression'},
    \     {'name' : 'VimConsoleLog',
    \      'complete' : 'expression'},
    \     {'name' : 'VimConsoleWarn',
    \      'complete' : 'expression'},
    \     {'name' : 'VimConsoleError',
    \      'complete' : 'expression'}]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'VimConsoleLog'   : 'expression',
    \ 'VimConsoleWarn'  : 'expression',
    \ 'VimConsoleError' : 'expression'})

  if has('multi_lang')
    NeoBundleLazy 'vim-jp/vimdoc-ja', {
      \ 'autoload' : {
      \   'filetypes' : 'help'}}
  endif

  NeoBundleLazy 'Shougo/vimfiler.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     'VimFilerDetectDrives', 'VimFilerClose',
    \     {'name' : 'VimFiler',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerDouble',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerCurrentDir',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerBufferDir',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerCreate',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerSimple',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerSplit',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerTab',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'VimFilerExplorer',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'Edit',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'Read',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'Source',
    \      'complete' : 'customlist,vimfiler#complete'},
    \     {'name' : 'Write',
    \      'complete' : 'customlist,vimfiler#complete'}],
    \   'unite_sources' : [
    \     'vimfiler/drive', 'vimfiler/execute', 'vimfiler/history',
    \     'vimfiler/mask',  'vimfiler/popd',    'vimfiler/sort'],
    \   'explorer' : 1}}
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
    \ 'Edit'               : 'vimfiler#complete',
    \ 'Read'               : 'vimfiler#complete',
    \ 'Source'             : 'vimfiler#complete',
    \ 'Write'              : 'vimfiler#complete'})

  NeoBundleLazy 'syngan/vim-vimlint'

  NeoBundleLazy 'ynkdir/vim-vimlparser'

  NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \   'windows' : $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' .
    \     'nmake -f Make_msvc.mak nodebug=1',
    \   'others'  : 'make'}}

  NeoBundleLazy 'Shougo/vimshell.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'vimshrc',
    \   'commands' : [
    \     'VimShellSendString', 'VimShellSendBuffer',
    \     {'name' : 'VimShell',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellCreate',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellTab',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellPop',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellCurrentDir',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellBufferDir',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellExecute',
    \      'complete' : 'customlist,vimshell#vimshell_execute_complete'},
    \     {'name' : 'VimShellInteractive',
    \      'complete' : 'customlist,vimshell#vimshell_execute_complete'},
    \     {'name' : 'VimShellTerminal',
    \      'complete' : 'customlist,vimshell#vimshell_execute_complete'}],
    \   'unite_sources' : ['vimshell/external_history', 'vimshell/history']},
    \ 'depends' : [
    \   'yomi322/vim-gitcomplete',
    \   'ujihisa/vimshell-ssh']}
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

  if has('python') || has('python3')
    NeoBundleLazy 'Shougo/vinarise.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     {'name' : 'Vinarise',
      \      'complete' : 'customlist,vinarise#complete'},
      \     {'name' : 'VinariseDump',
      \      'complete' : 'customlist,vinarise#complete'},
      \     {'name' : 'VinariseScript2Hex',
      \      'complete' : 'customlist,vinarise#complete'}],
      \   'unite_sources' : 'vinarise/analysis'},
      \ 'depends' : 'rbtnn/hexript.vim'}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'Vinarise'           : 'vinarise#complete',
      \ 'VinariseDump'       : 'vinarise#complete',
      \ 'VinariseScript2Hex' : 'vinarise#complete'})
  endif

  NeoBundleLazy 'thinca/vim-visualstar', {
    \ 'autoload' : {
    \   'mappings' : [['nvo', '<Plug>(visualstar-']]}}

  NeoBundle 'vim-jp/vital.vim'

  NeoBundleLazy 'osyo-manga/vim-watchdogs', {
    \ 'autoload' : {
    \   'commands' : [
    \     'WatchdogsRun', 'WatchdogsRunSilent', 'WatchdogsRunSweep']},
    \ 'depends' : [
    \   'dbakker/vim-lint',
    \   'thinca/vim-quickrun',
    \   'syngan/vim-vimlint',
    \   'ynkdir/vim-vimlparser']}

  NeoBundleLazy 'mattn/webapi-vim'

  for s:bundle in filter(split(glob($HOME . '/.vim/bundle-settings/*'), '\n'),
    \ 'neobundle#get(fnamemodify(v:val, ":t")) != {}')
    execute 'set runtimepath+=' . s:bundle
  endfor
  unlet! s:bundle
  autocmd MyVimrc User VimrcPost
    \ call neobundle#call_hook('on_source')
endif
"}}}
"}}}

"==============================================================================
" General Settings: {{{

"------------------------------------------------------------------------------
" System: {{{
" GUI options
if has('gui_running')
  set guioptions+=M
endif

" Message
set shortmess+=a
set title
set confirm

" Use beep
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
set backup
set patchmode=.clean
set suffixes+=.clean
set backupskip+=*.clean,*/.drive.r/*,*/.hg/*,*/.git/*,*/.svn/*
let s:skip_regexp = '\.clean$\|[/\\]\%(\.drive\.r\|\.hg\|\.git\|\.svn\)[/\\]'

" Swap
set swapfile

" Undo persistence
set undofile
autocmd MyVimrc BufNewFile,BufRead *
  \ let &l:undofile = (expand('%:p') !~? s:skip_regexp)

" Directory
if exists('$TEMP')
  set backupdir^=~/.bak,$TEMP
  set undodir^=~/.bak,$TEMP
  set directory^=$TEMP
elseif exists('$TMP')
  set backupdir^=~/.bak,$TMP
  set undodir^=~/.bak,$TMP
  set directory^=$TMP
elseif exists('$TMPDIR')
  set backupdir^=~/.bak,$TMPDIR
  set undodir^=~/.bak,$TMPDIR
  set directory^=$TMPDIR
endif

" ClipBoard
set clipboard=unnamed

" Timeout
set timeout
set timeoutlen=3000
set ttimeoutlen=100
set updatetime=1000

" Hidden buffer
set hidden

" Multi byte charactor width
set ambiwidth=double

" Wild menu
set wildmenu
set wildignore+=*.swp,*.clean,.drive.r,.hg,.git,.svn
set wildignore+=*.o,*.a,*.so,*.obj,*.lib,*.dll,*.exe
set wildignore+=*.lc,*.elc,*.fas,*.pyc,*.luac

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
set ruler
set wrap
set display=lastline
set scrolloff=5
autocmd MyVimrc CmdwinEnter *
  \ setlocal nonumber norelativenumber

" Match
set showmatch
set matchtime=1

" Command line
set cmdheight=1
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
if s:jvgrep_enable
  set grepprg=jvgrep\ -n\ --exclude\ .drive.r
elseif s:ag_enable
  set grepprg=ag\ --line-numbers\ --nocolor\ --nogroup\ --hidden\
    \ --ignore\ .drive.r\ --ignore\ .hg\ --ignore\ .git\ --ignore\ .svn
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
silent! set completeopt+=noselect

" Format
set nrformats=hex
set formatoptions+=m
set formatoptions+=B

" Free cursor
set virtualedit=block

" Cursor can move to bol & eol
set backspace=indent,eol,start
augroup MyVimrc
  autocmd CmdwinEnter *
    \ let s:save_bs = &backspace |
    \ set backspace=
  autocmd CmdwinLeave *
    \ let &backspace = s:save_bs
augroup END

" Ctags
set showfulltag

" Default file format
set fileformat=unix
set fileformats=unix,dos,mac

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
autocmd MyVimrc CmdwinEnter *
  \ setlocal nofoldenable foldcolumn=0
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

if v:lang =~? '^ja' && has('multi_lang')
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
    \ (s:enc_jisx0213 ? 'euc-jisx0213,euc-jp,' : 'euc-jp,') .
    \ 'ucs-bom'

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
    autocmd CmdwinEnter *
      \ setlocal nocursorcolumn
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
" Prefix: {{{
" <Leader> <LocalLeader>
NXOnoremap <Leader>      <Nop>
NXOnoremap <LocalLeader> <Nop>

" Useless
NXOnoremap ;     <Nop>
NXOnoremap ,     <Nop>
NXOnoremap s     <Nop>
NXOnoremap S     <Nop>
NXOnoremap m     <Nop>
NXOnoremap M     <Nop>
NOnoremap  <C-G> <Nop>
cnoremap   <C-G> <Nop>
"}}}

"------------------------------------------------------------------------------
" Moving: {{{
" Split Nicely
function! s:split_nicely_expr()
  return &columns < 160
endfunction
noremap <expr> <SID>(split-nicely)
  \ <SID>split_nicely_expr() ? '<C-W>s' : '<C-W>v'

" Gips
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

" Window Control
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

" Paren
NXOnoremap <Space> %

" Mark
NXOnoremap mj ]`zvzz
NXOnoremap mk [`zvzz

" Diff
NXOnoremap <C-J> ]czvzz
NXOnoremap <C-K> [czvzz

" Motion
NXOnoremap ( (zvzz
NXOnoremap ) )zvzz
NXOnoremap { {zvzz
NXOnoremap } }zvzz

" Search
NXOnoremap *  *zvzz
NXOnoremap #  #zvzz
NXOnoremap g* g*zvzz
NXOnoremap g# g#zvzz
NXOmap g/ *
NXOmap g? #

" Search Split Window
NXnoremap <script> <C-W>/  <SID>(split-nicely)<SID>/
NXnoremap <script> <C-W>?  <SID>(split-nicely)<SID>?
NXnoremap <script> <C-W>*  <SID>(split-nicely)*zvzz
NXnoremap <script> <C-W>#  <SID>(split-nicely)#zvzz
NXnoremap <script> <C-W>g* <SID>(split-nicely)g*zvzz
NXnoremap <script> <C-W>g# <SID>(split-nicely)g#zvzz
NXmap <C-W>g/ <C-W>*
NXmap <C-W>g? <C-W>#
"}}}

"------------------------------------------------------------------------------
" Useful: {{{
" Leader keys
NXnoremap <Leader>c     :<C-U>close<CR>
NXnoremap <Leader>C     :<C-U>only<CR>
NXnoremap <Leader><M-c> :<C-U>tabclose<CR>
NXnoremap <Leader><M-C> :<C-U>tabonly<CR>
NXnoremap <Leader>w     :<C-U>update<CR>
NXnoremap <Leader>W     :<C-U>wall<CR>
NXnoremap <Leader>q     :<C-U>bdelete<CR>
NXnoremap <Leader>Q     :<C-U>bufdo bdelete<CR>
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
NXnoremap <script><expr> <Leader><M-d>
  \ '<SID>:<C-U>lcd ' .
  \ expand('%:p:h' . (has('win32') ? ':gs?\\?/?' : '')) .
  \ '/'
NXnoremap <script><expr> <Leader><M-D>
  \ '<SID>:<C-U>cd ' .
  \ expand('%:p:h' . (has('win32') ? ':gs?\\?/?' : '')) .
  \ '/'

" Paste
NXnoremap <C-P> :<C-U>registers<CR>
inoremap  <C-P> <C-O>:<C-U>registers<CR>
noremap!  <M-p> <C-R>"

" BackSpace
nnoremap <BS> X

" Yank at end of line
nnoremap Y y$

" Jump
nnoremap <S-Tab> <C-O>

" Tabs
NXnoremap g<M-t> :<C-U>tabmove +1<CR>
NXnoremap g<M-T> :<C-U>tabmove -1<CR>

" Buffer Grep
NXnoremap <C-N> :<C-U>vimgrep // %<CR>

" Search highlight
nnoremap <Esc><Esc> :<C-U>nohlsearch<CR><Esc>

" Undo branch
nnoremap <M-u> g-
nnoremap <M-r> g+
nnoremap <M-U> :<C-U>undolist<CR>

" New line
nnoremap <M-o>
  \ :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
nnoremap <M-O>
  \ :<C-U>call append(line('.') - 1, repeat([''], v:count1))<CR>

" Paste toggle
set pastetoggle=<F11>
nnoremap <expr> <F11>
  \ &paste ? ':<C-U>set nopaste<CR>' : ':<C-U>set paste<CR>'

" Start Visual-mode with the same area
onoremap gv :<C-U>normal! gv<CR>

" Start Visual-mode with the last changed area
nnoremap  g[ `[v`]
XOnoremap g[ :<C-U>normal g[<CR>

" Delete at Insert-mode
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>

" Auto exit at Command-mode
cnoremap <expr> <C-H>
  \ getcmdtype() == '@' && getcmdpos() == 1 && getcmdline() == '' ?
  \   '<Esc>' : '<C-H>'
cnoremap <expr> <BS>
  \ getcmdtype() == '@' && getcmdpos() == 1 && getcmdline() == '' ?
  \   '<Esc>' : '<BS>'

" Auto escape at Command-mode
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
augroup MyVimrc
  autocmd CmdwinEnter /
    \ inoremap <buffer> / \/
  autocmd CmdwinEnter ?
    \ inoremap <buffer> ? \?
augroup END

" Help
inoremap <expr> <F1>
  \ <SID>split_nicely_expr() ?
  \   '<Esc>:<C-U>help<Space>' :
  \   '<Esc>:<C-U>vertical help<Space>'
nnoremap <expr> <F1>
  \ <SID>split_nicely_expr() ?
  \   ':<C-U>help<Space>' :
  \   ':<C-U>vertical help<Space>'
nnoremap <expr> <F2>
  \ <SID>split_nicely_expr() ?
  \   ':<C-U>help ' . expand('<cword>') . '<CR>' :
  \   ':<C-U>vertical help ' . expand('<cword>') . '<CR>'

" QuickFix
augroup MyVimrc
  autocmd QuickFixCmdPost [^l]*
    \ cwindow
  autocmd QuickFixCmdPost l*
    \ lwindow
augroup END
"}}}

"------------------------------------------------------------------------------
" Subrogation: {{{
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
  \ setlocal modified fileformat=unix
command! -bar
  \ FfDos
  \ setlocal modified fileformat=dos
command! -bar
  \ FfMac
  \ setlocal modified fileformat=mac
"}}}

"------------------------------------------------------------------------------
" Change File Encoding Option: {{{
if has('multi_byte')
  command! -bar
    \ FencUtf8
    \ setlocal modified fileencoding=utf-8
  command! -bar
    \ FencUtf16le
    \ setlocal modified fileencoding=utf-16le
  command! -bar
    \ FencUtf16
    \ setlocal modified fileencoding=utf-16
  command! -bar
    \ FencCp932
    \ setlocal modified fileencoding=cp932
  command! -bar
    \ FencEucjp
    \ setlocal modified fileencoding=euc-jp
  if s:enc_jisx0213
    command! -bar
      \ FencEucJisx0213
      \ setlocal modified fileencoding=euc-jisx0213
    command! -bar
      \ FencIso2022jp
      \ setlocal modified fileencoding=iso-2022-jp-3
  else
    command! -bar
      \ FencIso2022jp
      \ setlocal modified fileencoding=iso-2022-jp
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
  function! s:get_shell()
    return [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote]
  endfunction
  function! s:set_shell(value)
    let [&shell, &shellslash, &shellcmdflag, &shellquote, &shellxquote] =
      \ a:value
  endfunction

  command! -bar
    \ ShellCmd
    \ call s:set_shell(s:default_shell)
  command! -bar -nargs=?
    \ ShellSh
    \ call s:set_shell([<q-args> != '' ? <q-args> : 'sh', 1, '-c', '', '"'])
endif
"}}}

"------------------------------------------------------------------------------
" VC Vars: {{{
if exists('$VCVARSALL')
  function! s:vcvarsall(arch)
    let save_shell = s:get_shell()
    let save_isi   = &isident
    ShellCmd
    set isident+=( isident+=)
    try
      let env = system($VCVARSALL . ' ' . a:arch . ' & set')
      for matches in filter(map(split(env, '\n'),
        \ 'matchlist(v:val, ''\([^=]\+\)=\(.*\)'')'), 'len(v:val) > 1')
        execute 'let $' . matches[1] . '=' . string(matches[2])
      endfor
    finally
      call s:set_shell(save_shell)
      let &isident = save_isi
    endtry
  endfunction

  command! -bar
    \ VCVars32
    \ call s:vcvarsall('x86')

  if exists('$PROGRAMFILES(x86)')
    command! -bar
      \ VCVars64
      \ call s:vcvarsall(exists('PROCESSOR_ARCHITEW6432') ?
      \   $PROCESSOR_ARCHITEW6432 : $PROCESSOR_ARCHITECTURE)
  endif
endif
"}}}

"------------------------------------------------------------------------------
" QuickFix Toggle: {{{
function! s:toggle_quickfix(type, height)
  let w = winnr('$')
  execute a:type . 'close'
  if w == winnr('$')
    execute a:type . 'window' a:height
  endif
endfunction
command! -bar -nargs=?
  \ CToggle
  \ call s:toggle_quickfix('c', <q-args>)
command! -bar -nargs=?
  \ LToggle
  \ call s:toggle_quickfix('l', <q-args>)

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
  \ doautocmd FileType

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
" Command Line Window: {{{
function! s:cmdwin_enter()
  startinsert!
  nnoremap <buffer><silent> q :<C-U>quit<CR>

  inoremap <buffer><silent><script><expr> <C-H>
    \ col('.') == 1 && getline('.') == '' ? '<Esc>:<C-U>quit<CR>' : '<C-H>'
  inoremap <buffer><silent><script><expr> <BS>
    \ col('.') == 1 && getline('.') == '' ? '<Esc>:<C-U>quit<CR>' : '<BS>'
endfunction
autocmd MyVimrc CmdwinEnter *
  \ call s:cmdwin_enter()

function! s:cmdline_enter(type)
  if exists('#User#CmdlineEnter')
    execute 'doautocmd' (s:has_patch(703, 438) ? '<nomodeline>' : '')
      \ 'User CmdlineEnter'
  endif
  return a:type
endfunction

if s:cmdwin_enable
  noremap <SID>: q:
  noremap <SID>/ q/
  noremap <SID>? q?
else
  noremap <expr> <SID>: <SID>cmdline_enter(':')
  noremap <expr> <SID>/ <SID>cmdline_enter('/')
  noremap <expr> <SID>? <SID>cmdline_enter('?')
endif

NXmap ;; <SID>:
NXmap :  <SID>:
NXmap /  <SID>/
NXmap ?  <SID>?

NXnoremap <expr> ;: <SID>cmdline_enter(':')
NXnoremap <expr> ;/ <SID>cmdline_enter('/')
NXnoremap <expr> ;? <SID>cmdline_enter('?')
"}}}

"------------------------------------------------------------------------------
" Auto Mark: {{{
let s:mark_char = [
  \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

function! s:_get_mark_pos()
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
function! s:auto_mark()
  let b:mark_pos = s:_get_mark_pos()
  return (":\<C-U>mark " . s:mark_char[b:mark_pos] . "\<CR>")
endfunction
function! s:clear_marks()
  let b:mark_pos = -1
  return (":\<C-U>delmarks " . join(s:mark_char, '') . "\<CR>")
endfunction

function! s:_get_file_mark_pos()
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
function! s:auto_file_mark()
  let s:file_mark_pos = s:_get_file_mark_pos()
  return (":\<C-U>mark " . toupper(s:mark_char[s:file_mark_pos]) . "\<CR>")
endfunction
function! s:clear_file_marks()
  let s:file_mark_pos = -1
  return (":\<C-U>rviminfo | delmarks " .
    \ toupper(join(s:mark_char, '')) . " | wviminfo!\<CR>")
endfunction

function! s:marks()
  let char = join(s:mark_char, '')
  return (":\<C-U>marks " . char . toupper(char) . "\<CR>")
endfunction

nnoremap <expr> mm <SID>auto_mark()
nnoremap <expr> mc <SID>clear_marks()
nnoremap <expr> mM <SID>auto_file_mark()
nnoremap <expr> mC <SID>clear_file_marks()
nnoremap <expr> ml <SID>marks()
"}}}

"------------------------------------------------------------------------------
" Smart BOL: {{{
function! s:smart_bol()
  if v:count
    return repeat("\<Del>", len(v:count)) . (v:count % 2 ? '^' : '0')
  else
    let col = col('.')
    return col <= 1 || col > match(getline('.'), '^\s*\zs') + 1 ? '^' : '0'
  endif
endfunction
function! s:smart_eol()
  if v:count
    return repeat("\<Del>", len(v:count)) . (v:count % 2 ? '$' : 'g_')
  else
    return col('.') < col('$') - (mode() !~# "[vV\<C-V>]" ? 1 : 0) ? '$' : 'g_'
  endif
endfunction

NXOnoremap <expr> H <SID>smart_bol()
NXOnoremap <expr> L <SID>smart_eol()
inoremap <expr> <M-H> '<C-O>' . <SID>smart_bol()
inoremap <expr> <M-L> '<C-O>' . <SID>smart_eol()
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
" Make Searching Directions Consistent: {{{
function! s:search_forward_expr()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction

NXOnoremap <expr> n
  \ <SID>search_forward_expr() ? 'nzvzz' : 'Nzvzz'
NXOnoremap <expr> N
  \ <SID>search_forward_expr() ? 'Nzvzz' : 'nzvzz'
"}}}

"------------------------------------------------------------------------------
" Line Number: {{{
function! s:toggle_line_number_style()
  set relativenumber!
  if !&number && !&relativenumber
    set number
  endif
endfunction

nnoremap <F12> :<C-U>call <SID>toggle_line_number_style()<CR>
"}}}

"------------------------------------------------------------------------------
" Insert One Character: {{{
function! s:insert_one_char(cmd)
  echohl ModeMsg
  if v:lang =~? '^ja' && has('multi_lang')
    echo '-- 挿入 (1文字) --'
  else
    echo '-- INSERT (one char) --'
  endif
  echohl None
  return a:cmd . nr2char(getchar()) . "\<Esc>"
endfunction

nnoremap  <expr> <M-a> <SID>insert_one_char('a')
NXnoremap <expr> <M-A> <SID>insert_one_char('A')
nnoremap  <expr> <M-i> <SID>insert_one_char('i')
NXnoremap <expr> <M-I> <SID>insert_one_char('I')
"}}}

"------------------------------------------------------------------------------
" Auto MkDir: {{{
function! s:auto_mkdir(dir, force)
  if v:lang =~? '^ja' && has('multi_lang')
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
autocmd MyVimrc BufWritePre *
  \ call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
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
  \ if line("'\"") > 1 && line("'\"") <= line('$') &&
  \   expand('%:p') !~? s:skip_regexp |
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

" Omni
call extend(s:neocompl_omni_patterns, {
  \ 'CucumberComplete'              : '.*',
  \ 'adacomplete#Complete'          : '.*',
  \ 'ccomplete#Complete'            : '.*',
  \ 'clojurecomplete#Complete'      : '.*',
  \ 'csscomplete#CompleteCSS'       : '.*',
  \ 'htmlcomplete#CompleteTags'     : '.*',
  \ 'javascriptcomplete#CompleteJS' : '.*',
  \ 'phpcomplete#CompletePHP'       : '.*',
  \ 'sqlcomplete#Complete'          : '.*',
  \ 'xmlcomplete#CompleteTags'      : '.*'})
if has('python3')
  call extend(s:neocompl_omni_patterns, {
    \ 'python3complete#Complete' : '.*'})
endif
if has('python')
  call extend(s:neocompl_omni_patterns, {
    \ 'pythoncomplete#Complete' : '.*'})
endif
if has('ruby')
  call extend(s:neocompl_omni_patterns, {
    \ 'rubycomplete#Complete' : '.*'})
endif
"}}}

"------------------------------------------------------------------------------
" Alignta: {{{
silent! let s:bundle = neobundle#get('alignta')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    function! s:operator_alignta(motion_wise)
      execute input(':', line("'[") . ',' . line("']") . 'Alignta ')
    endfunction

    call operator#user#define('alignta', s:SID_PREFIX() . 'operator_alignta')
  endfunction

  NXOmap s= <Plug>(operator-alignta)

  nmap s== s=s=
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" AlterCommand: {{{
silent! let s:bundle = neobundle#get('altercmd')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_post_source(bundle)
    for [key, value] in items(s:altercmd_define)
      execute 'CAlterCommand' key value
    endfor
  endfunction

  function! s:cmdwin_enter_altercmd()
    for [key, value] in items(s:altercmd_define)
      execute 'IAlterCommand <buffer>' key value
    endfor
  endfunction

  augroup MyVimrc
    autocmd CmdwinEnter :
      \ call s:cmdwin_enter_altercmd()
    autocmd User CmdlineEnter
      \ NeoBundleSource altercmd
  augroup END
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Altr: {{{
silent! let s:bundle = neobundle#get('altr')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nmap g<M-f>     <Plug>(altr-forward)
  nmap g<M-F>     <Plug>(altr-back)
  nmap <C-W><M-f> <SID>(split-nicely)<Plug>(altr-forward)
  nmap <C-W><M-F> <SID>(split-nicely)<Plug>(altr-back)

  autocmd MyVimrc User CmdlineEnter
    \ NeoBundleSource altr
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Anzu: {{{
silent! let s:bundle = neobundle#get('anzu')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    set shortmess+=s

    nmap <Plug>(anzu-jump-n-with-echo)
      \ <Plug>(anzu-jump-n)<Plug>(anzu-echo-search-status)
    nmap <Plug>(anzu-jump-N-with-echo)
      \ <Plug>(anzu-jump-N)<Plug>(anzu-echo-search-status)
  endfunction

  nmap <expr> n
    \ <SID>search_forward_expr() ?
    \   '<Plug>(anzu-jump-n-with-echo)zvzz' :
    \   '<Plug>(anzu-jump-N-with-echo)zvzz'
  nmap <expr> N
    \ <SID>search_forward_expr() ?
    \   '<Plug>(anzu-jump-N-with-echo)zvzz' :
    \   '<Plug>(anzu-jump-n-with-echo)zvzz'
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" AutoDate: {{{
silent! let s:bundle = neobundle#get('autodate')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:autodate_lines = 10
  endfunction

  autocmd MyVimrc BufNewFile,BufRead *
    \ NeoBundleSource autodate
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" AutoFmt: {{{
silent! let s:bundle = neobundle#get('autofmt')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  set formatexpr=autofmt#japanese#formatexpr()
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Clang Complete: {{{
silent! let s:bundle = neobundle#get('clang_complete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:clang_complete_auto          = 0
    let g:clang_auto_select            = 0
    let g:clang_user_options           = '-w'
    let g:clang_jumpto_declaration_key = '<LocalLeader><C-]>'
    let g:clang_jumpto_back_key        = '<LocalLeader><C-T>'

    if has('win64')
      if filereadable($HOME . '/bin64/libclang.dll')
        let g:clang_library_path = $HOME . '/bin64'
      endif
    elseif has('win32')
      if filereadable($HOME . '/bin/libclang.dll')
        let g:clang_library_path = $HOME . '/bin'
      endif
    else
      if filereadable($HOME . '/lib/libclang.so')
        let g:clang_library_path = $HOME . '/lib'
      elseif filereadable(expand('/usr/local/lib/libclang.so'))
        let g:clang_library_path = expand('/usr/local/lib')
      elseif filereadable(expand('/usr/lib/libclang.so'))
        let g:clang_library_path = expand('/usr/lib')
      endif
    endif
    if exists('g:clang_library_path')
      let g:clang_use_library = 1
    endif
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
    function s:clang_complete_init()
      silent! iunmap <buffer> <C-X><C-U>
      silent! iunmap <buffer> .
      silent! iunmap <buffer> >
      silent! iunmap <buffer> :
    endfunction

    autocmd MyVimrc FileType c,cpp,objc,objcpp
      \ call s:clang_complete_init()

    if &filetype == 'c' || &filetype == 'cpp' ||
      \ &filetype == 'objc' || &filetype == 'objcpp'
      doautocmd FileType
    endif
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'ClangComplete' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Clever F: {{{
silent! let s:bundle = neobundle#get('clever-f')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" ColumnJump: {{{
silent! let s:bundle = neobundle#get('columnjump')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    nmap <SID>(columnjump-backward) <Plug>(columnjump-backward)
    nmap <SID>(columnjump-forward)  <Plug>(columnjump-forward)

    inoremap <script> <M-(> <C-O><SID>(columnjump-backward)
    inoremap <script> <M-)> <C-O><SID>(columnjump-forward)
  endfunction

  NXOmap ( <Plug>(columnjump-backward)zvzz
  NXOmap ) <Plug>(columnjump-forward)zvzz
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Emmet: {{{
silent! let s:bundle = neobundle#get('emmet')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:user_emmet_settings   = {
      \ 'lang' : 'ja',
      \ 'indentation' : '  ',
      \ 'xml' : {'extends' : 'html'}}
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'emmet#CompleteTag' : '.*'})
endif
unlet! s:bundle
"}}}
"}}}

"------------------------------------------------------------------------------
" Eskk: {{{
silent! let s:bundle = neobundle#get('eskk')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}
"}}}

"------------------------------------------------------------------------------
" FT_Lua: {{{
silent! let s:bundle = neobundle#get('ft_lua')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:lua_complete_omni = 1
    let g:lua_check_syntax  = 0
    let g:lua_check_globals = 0

    if s:executable('luac')
      let g:lua_compiler_name = 'luac'
    elseif s:executable('luac52')
      let g:lua_compiler_name = 'luac52'
    endif
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'xolox#lua#omnifunc' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Fugitive: {{{
silent! let s:bundle = neobundle#get('fugitive')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_post_source(bundle)
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
    \ exists(':Gitv') ? ':<C-U>Gitv<CR>' : ':<C-U>Glog<CR>'

  NXnoremap <script> <Leader>gg <SID>:<C-U>Git<Space>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Goto File: {{{
silent! let s:bundle = neobundle#get('gf-user')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Gocode: {{{
silent! let s:bundle = neobundle#get('gocode')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  call extend(s:neocompl_omni_patterns, {
    \ 'gocomplete#Complete' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Grex: {{{
silent! let s:bundle = neobundle#get('grex')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap sD <Plug>(operator-grex-delete)
  NXOmap sY <Plug>(operator-grex-yank)

  nmap sDD sDsD
  nmap sYY sYsY
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Hier: {{{
silent! let s:bundle = neobundle#get('hier')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    nnoremap <Esc><Esc> :<C-U>nohlsearch<Bar>HierClear<CR><Esc>
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" IndentLine: {{{
silent! let s:bundle = neobundle#get('indentLine')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:indentLine_char     = '|'
    let g:indentLine_maxLines = 10000

    call s:set_indent_line_color(0)
  endfunction

  function! s:set_indent_line_color(force)
    if !exists('g:indentLine_color_term') ||
      \ !exists('g:indentLine_color_gui') || a:force
      let hi_special_key          = s:get_highlight('SpecialKey')
      let g:indentLine_color_term = matchstr(hi_special_key, 'ctermfg=\zs\S\+')
      let g:indentLine_color_gui  = matchstr(hi_special_key, 'guifg=\zs\S\+')
    endif
  endfunction

  augroup MyVimrc
    autocmd CmdwinEnter *
      \ let b:indentLine_enabled = 0
    autocmd ColorScheme *
      \ call s:set_indent_line_color(1)
    autocmd FileType *
      \ if get(b:, 'indentLine_enabled', 1) && !&l:expandtab |
      \   execute 'IndentLinesToggle' |
      \ endif
    autocmd Syntax *
      \ if get(b:, 'indentLine_enabled', 1) |
      \   execute 'IndentLinesReset' |
      \ endif
  augroup END
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" J6uil: {{{
silent! let s:bundle = neobundle#get('J6uil')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:J6uil_config_dir             = $HOME . '/.local/.J6uil'
    let g:J6uil_display_interval       = 0
    let g:J6uil_open_buffer_cmd        = 'tabedit'
    let g:J6uil_no_default_keymappings = 1

    if has('win32') && isdirectory($PROGRAMFILES . '/ImageMagick-6.8.6-Q16')
      let g:J6uil_display_icon = 1
      let $PATH = $PROGRAMFILES . '\ImageMagick-6.8.6-Q16;' . $PATH
    elseif !has('win32') && s:executable('convert')
      let g:J6uil_display_icon = 1
    endif

    if filereadable($HOME . '/.vim/J6uil_config.vim')
      source ~/.vim/j6uil_config.vim
    endif
  endfunction

  call extend(s:altercmd_define, {
    \ 'j[6uil]' : 'J6uil'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Jedi: {{{
silent! let s:bundle = neobundle#get('jedi')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:jedi#auto_initialization    = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot           = 0
    let g:jedi#auto_close_doc         = 0
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'jedi#completions' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" JsComplete: {{{
silent! let s:bundle = neobundle#get('jscomplete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:jscomplete_use = ['dom', 'moz', 'xpcom', 'es6th']
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'jscomplete#CompleteJS' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Kwbdi: {{{
silent! let s:bundle = neobundle#get('kwbdi')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    function! s:kwbd()
      if &l:modified
        if v:lang =~? '^ja' && has('multi_lang')
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
    command! -bar
      \ Kwbd
      \ call s:kwbd()
  endfunction

  NXnoremap <Leader>q :<C-U>Kwbd<CR>
  map <SID>Kwbd <Plug>Kwbd

  call extend(s:altercmd_define, {
    \ 'bd[elete]' : 'Kwbd',
    \
    \ '_bd[elete]' : 'bdelete'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Localrc: {{{
silent! let s:bundle = neobundle#get('localrc')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_post_source(bundle)
    call localrc#load(g:localrc_filename)

    if &filetype != ''
      call localrc#load(
        \ map(type(g:localrc_filetype) == type([]) ?
        \     copy(g:localrc_filetype) : [g:localrc_filetype],
        \   'printf(v:val, &filetype)'))
    endif
  endfunction

  autocmd MyVimrc BufNewFile,BufRead,FileType *
    \ NeoBundleSource localrc
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" MapList: {{{
silent! let s:bundle = neobundle#get('maplist')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:maplist_mode_length  = 4
    let g:maplist_lhs_length   = 50
    let g:maplist_local_length = 2
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Narrow: {{{
silent! let s:bundle = neobundle#get('narrow')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    call operator#user#define_ex_command('narrow', 'Narrow')

    NXnoremap sN :<C-U>Widen<CR>
  endfunction

  NXOmap sn <Plug>(operator-narrow)

  nmap snn snsn
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" NeoComplCache: {{{
silent! let s:bundle = neobundle#get('neocomplcache')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:neocomplcache_enable_at_startup            = 1
    let g:neocomplcache_enable_auto_select           = 0
    let g:neocomplcache_enable_auto_delimiter        = 1
    " let g:neocomplcache_enable_insert_char_pre       = 1
    let g:neocomplcache_enable_camel_case_completion = 0
    let g:neocomplcache_enable_underbar_completion   = 0
    let g:neocomplcache_enable_fuzzy_completion      = 0
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_temporary_dir                =
      \ $HOME . '/.local/.neocomplcache'

    let g:neocomplcache_force_omni_patterns       =
      \ s:neocompl_force_omni_patterns
    let g:neocomplcache_keyword_patterns          =
      \ s:neocompl_keyword_patterns
    let g:neocomplcache_omni_patterns             =
      \ s:neocompl_omni_patterns
    let g:neocomplcache_dictionary_filetype_lists =
      \ s:neocompl_dictionary_filetype_lists
    let g:neocomplcache_vim_completefuncs         =
      \ s:neocompl_vim_completefuncs

    call neocomplcache#custom_source('syntax_complete',   'rank',  9)
    call neocomplcache#custom_source('snippets_complete', 'rank', 80)

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
      \   <SID>check_back_space() ?
      \     '<Tab>' :
      \     neocomplcache#start_manual_complete()
    inoremap <expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplcache#start_manual_complete()

    inoremap <script><expr> <CR>
      \ neocomplcache#smart_close_popup() . '<CR>'
    inoremap <script><expr> <C-H>
      \ neocomplcache#smart_close_popup() . '<C-H>'
    inoremap <script><expr> <BS>
      \ neocomplcache#smart_close_popup() . '<BS>'
  endfunction

  function! s:cmdwin_enter_neocomplcache()
    let b:neocomplcache_sources_list = []

    inoremap <buffer><expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   <SID>check_back_space() ?
      \     '<Tab>' :
      \     neocomplcache#start_manual_complete()
    inoremap <buffer><expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplcache#start_manual_complete()

    inoremap <buffer><script><silent><expr> <C-H>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<C-H>')
    inoremap <buffer><script><silent><expr> <BS>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<BS>')
  endfunction
  augroup MyVimrc
    autocmd CmdwinEnter *
      \ call s:cmdwin_enter_neocomplcache()
    autocmd CmdwinEnter :
      \ let b:neocomplcache_sources_list = ['file_complete', 'vim_complete']
  augroup END

  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  call extend(s:neocompl_dictionary_filetype_lists, {
    \ '_' : ''})
  call extend(s:neocompl_keyword_patterns, {
    \ '_' : '[a-zA-Z@0-9_]\+'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" NeoComplete: {{{
silent! let s:bundle = neobundle#get('neocomplete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_auto_select           = 0
    let g:neocomplete#enable_auto_delimiter        = 1
    " let g:neocomplete#enable_insert_char_pre       = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#data_directory               =
      \ $HOME . '/.local/.neocomplete'

    let g:neocomplete#force_omni_input_patterns        =
      \ s:neocompl_force_omni_patterns
    let g:neocomplete#keyword_patterns                 =
      \ s:neocompl_keyword_patterns
    let g:neocomplete#sources#omni#input_patterns      =
      \ s:neocompl_omni_patterns
    let g:neocomplete#sources#dictionary#dictionaryies =
      \ s:neocompl_dictionary_filetype_lists
    let g:neocomplete#sources#vim#complete_functions   =
      \ s:neocompl_vim_completefuncs

    call neocomplete#custom#source('_', 'matchers', ['matcher_head'])
    call neocomplete#custom#source('syntax_complete',   'rank',  9)
    call neocomplete#custom#source('snippets_complete', 'rank', 80)

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
      \   <SID>check_back_space() ?
      \     '<Tab>' :
      \     neocomplete#start_manual_complete()
    inoremap <expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplete#start_manual_complete()

    inoremap <script><expr> <CR>
      \ neocomplete#smart_close_popup() . '<CR>'
    inoremap <script><expr> <C-H>
      \ neocomplete#smart_close_popup() . '<C-H>'
    inoremap <script><expr> <BS>
      \ neocomplete#smart_close_popup() . '<BS>'
  endfunction

  function! s:cmdwin_enter_neocomplete()
    let b:neocomplete_sources = []

    inoremap <buffer><expr> <Tab>
      \ pumvisible() ?
      \   '<C-N>' :
      \   <SID>check_back_space() ?
      \     '<Tab>' :
      \     neocomplete#start_manual_complete()
    inoremap <buffer><expr> <S-Tab>
      \ pumvisible() ?
      \   '<C-P>' :
      \   neocomplete#start_manual_complete()

    inoremap <buffer><silent><script><expr> <C-H>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<C-H>')
    inoremap <buffer><silent><script><expr> <BS>
      \ col('.') == 1 && getline('.') == '' ?
      \   '<Esc>:<C-U>quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<BS>')
  endfunction
  augroup MyVimrc
    autocmd CmdwinEnter *
      \ call s:cmdwin_enter_neocomplete()
    autocmd CmdwinEnter :
      \ let b:neocomplete_sources = ['file', 'vim']
  augroup END

  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  call extend(s:neocompl_dictionary_filetype_lists, {
    \ '_' : ''})
  call extend(s:neocompl_keyword_patterns, {
    \ '_' : '[a-zA-Z@0-9_]\+'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" NeoSnippet: {{{
silent! let s:bundle = neobundle#get('neosnippet')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:neosnippet#snippets_directory           = $HOME . '/.vim/snippets'
    let g:neosnippet#disable_select_mode_mappings = 0

    let g:neosnippet#disable_runtime_snippets =
      \ get(g:, 'neosnippet#disable_runtime_snippets', {})
    let g:neosnippet#disable_runtime_snippets._ = 1

    imap <C-E> <Plug>(neosnippet_expand_or_jump)

    call neosnippet#initialize()
  endfunction

  smap <C-E> <Plug>(neosnippet_expand_or_jump)
  xmap <C-E> <Plug>(neosnippet_expand_target)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" OmniSharp: {{{
silent! let s:bundle = neobundle#get('Omnisharp')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:OmniSharp_typeLookupInPreview    = 0
    let g:OmniSharp_timeout                = 5
    let g:OmniSharp_BufWritePreSyntaxCheck = 1
    let g:Omnisharp_stop_server            = 0

    autocmd MyVimrc VimLeavePre *
      \ if OmniSharp#ServerIsRunning() |
      \   call OmniSharp#StopServer() |
      \ endif
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'OmniSharp#Complete' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Open Browser: {{{
silent! let s:bundle = neobundle#get('open-browser')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nmap gxgx <Plug>(openbrowser-smart-search)
  nmap gxx gxgx
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Camelize: {{{
silent! let s:bundle = neobundle#get('operator-camelize')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap sU <Plug>(operator-camelize)
  NXOmap su <Plug>(operator-decamelize)
  NXOmap s~ <Plug>(operator-camelize-toggle)

  nmap sUU sUsU
  nmap suu susu
  nmap s~~ s~s~
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Filled With Blank: {{{
silent! let s:bundle = neobundle#get('operator-filled-with-blank')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap s<Space> <Plug>(operator-filled-with-blank)

  nmap s<Space><Space> s<Space>s<Space>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator HTML Escape: {{{
silent! let s:bundle = neobundle#get('operator-html-escape')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap se <Plug>(operator-html-escape)
  NXOmap sE <Plug>(operator-html-unescape)

  nmap see sese
  nmap sEE sEsE
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Open Browser: {{{
silent! let s:bundle = neobundle#get('operator-openbrowser')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap gx <Plug>(operator-openbrowser)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Replace: {{{
silent! let s:bundle = neobundle#get('operator-replace')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap p <Plug>(operator-replace)
  nnoremap pp p
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Reverse: {{{
silent! let s:bundle = neobundle#get('operator-reverse')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap sv <Plug>(operator-reverse-text)
  NXOmap sV <Plug>(operator-reverse-lines)

  nmap svv svsv
  nmap sVV sVsV
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Sequence: {{{
silent! let s:bundle = neobundle#get('operator-sequence')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap <expr> s<C-U>
    \ operator#sequence#map("\<Plug>(operator-decamelize)", 'gU')

  nmap s<C-U><C-U> s<C-U>s<C-U>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Shuffle: {{{
silent! let s:bundle = neobundle#get('operator-shuffle')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap sS <Plug>(operator-shuffle)

  nmap sSS sSsS
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Sort: {{{
silent! let s:bundle = neobundle#get('operator-sort')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap ss <Plug>(operator-sort)

  nmap sss ssss
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Star: {{{
silent! let s:bundle = neobundle#get('operator-star')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOmap *  <Plug>(operator-*)
  NOmap #  <Plug>(operator-#)
  NOmap g* <Plug>(operator-g*)
  NOmap g# <Plug>(operator-g#)

  NOmap <C-W>*  <SID>(split-nicely)<Plug>(operator-*)
  NOmap <C-W>#  <SID>(split-nicely)<Plug>(operator-#)
  NOmap <C-W>g* <SID>(split-nicely)<Plug>(operator-g*)
  NOmap <C-W>g# <SID>(split-nicely)<Plug>(operator-g#)

  NOnoremap **   *zvzz
  NOnoremap ##   #zvzz
  NOnoremap g*g* g*zvzz
  NOnoremap g#g# g#zvzz

  NOmap g/g/ **
  NOmap g?g? ##
  NOmap g//  **
  NOmap g??  ##
  NOmap g**  g*g*
  NOmap g##  g#g#

  nnoremap <script> <C-W>**   <SID>(split-nicely)*zvzz
  nnoremap <script> <C-W>##   <SID>(split-nicely)#zvzz
  nnoremap <script> <C-W>g*g* <SID>(split-nicely)g*zvzz
  nnoremap <script> <C-W>g#g# <SID>(split-nicely)g#zvzz

  nmap <C-W>g/g/ <C-W>**
  nmap <C-W>g?g? <C-W>##
  nmap <C-W>g//  <C-W>**
  nmap <C-W>g??  <C-W>##
  nmap <C-W>g**  <C-W>g*g*
  nmap <C-W>g##  <C-W>g#g#
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Suddendeath: {{{
silent! let s:bundle = neobundle#get('operator-suddendeath')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap s! <Plug>(operator-suddendeath)

  nmap s!! s!s!
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Surround: {{{
silent! let s:bundle = neobundle#get('operator-surround')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap sa <Plug>(operator-surround-append)
  NXOmap sd <Plug>(operator-surround-delete)
  NXOmap sc <Plug>(operator-surround-replace)

  nmap saa sasa
  nmap sdd sdsd
  nmap scc scsc
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Tabular: {{{
silent! let s:bundle = neobundle#get('operator-tabular')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let s:operator_tabular_kind = 'markdown'
    let s:operator_tabular_ext  = 'csv'

    function! s:operator_tabularize(motion_wise, ...)
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
    function! s:operator_untabularize(motion_wise)
      call s:operator_tabularize(a:motion_wise, 1)
    endfunction
    function! s:operator_tabular_kind_complete(...)
      return ['markdown', 'textile', 'backlog']
    endfunction
    function! s:operator_tabular_ext_complete(...)
      return ['csv', 'tsv']
    endfunction

    call operator#user#define(
      \ 'tabularize',
      \ s:SID_PREFIX() . 'operator_tabularize')
    call operator#user#define(
      \ 'untabularize',
      \ s:SID_PREFIX() . 'operator_untabularize')
  endfunction

  NXOmap st <Plug>(operator-tabularize)
  NXOmap sT <Plug>(operator-untabularize)

  nmap stt stst
  nmap sTT sTsT
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator Trailingspace Killer: {{{
silent! let s:bundle = neobundle#get('operator-trailingspace-killer')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXOmap s$ <Plug>(operator-trailingspace-killer)

  nmap s$$ s$s$
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Operator User: {{{
silent! let s:bundle = neobundle#get('operator-user')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    if s:jvgrep_enable
      let s:operator_grep_escape = '\[](){}|.?+*^$'
    elseif s:ag_enable
      let s:operator_grep_escape = '\[](){}|.?+*^$'
    elseif s:executable('grep')
      let s:operator_grep_escape = '\[].*^$'
    else
      let s:operator_grep_escape = '\[].*^$'
    endif

    function! s:operator_grep(motion_wise)
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

      if neobundle#get('unite') != {}
        execute 'Unite'
          \ (&grepprg == 'internal' ? 'vimgrep::' : 'grep:::') .
          \ escape(join(lines), s:operator_grep_escape . ' :')
          \ '-buffer-name=grep -no-split -multi-line'
      else
        execute input(':',
          \ 'grep "' . escape(join(lines), s:operator_grep_escape) . '" '))
      endif
    endfunction

    call operator#user#define('grep', s:SID_PREFIX() . 'operator_grep')
  endfunction

  NXOmap sg <Plug>(operator-grep)
  nnoremap <script> sgsg :<C-U>execute input(':', 'grep ')<CR>

  nmap sgg sgsg
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" ParaJump: {{{
silent! let s:bundle = neobundle#get('parajump')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:parajump_no_default_key_mappings = 1

    nmap <SID>(parajump-backward) <Plug>(parajump-backward)
    nmap <SID>(parajump-forward)  <Plug>(parajump-forward)

    inoremap <script> <M-{> <C-O><SID>(parajump-backward)
    inoremap <script> <M-}> <C-O><SID>(parajump-forward)
  endfunction

  NXOmap { <Plug>(parajump-backward)zvzz
  NXOmap } <Plug>(parajump-forward)zvzz
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" PerlOmni: {{{
silent! let s:bundle = neobundle#get('perlomni')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    if has('win32')
      let $PATH = substitute(a:bundle.path, '/', '\\', 'g') . '\bin;' . $PATH
    else
      let $PATH = a:bundle.path . '/bin:' . $PATH
    endif
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'PerlComplete' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Precious: {{{
silent! let s:bundle = neobundle#get('precious')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_precious_no_default_key_mappings = 1
    let g:precious_enable_switchers                = {
      \ 'help' : {'setfiletype' : 0}}

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

  autocmd MyVimrc FileType *
    \ NeoBundleSource precious
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Quickhl: {{{
silent! let s:bundle = neobundle#get('quickhl')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXmap sM <Plug>(quickhl-reset)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" QuickRun: {{{
silent! let s:bundle = neobundle#get('quickrun')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
      \     exists('$VCVARSALL')  ? 'c/vc' :
      \     s:executable('cl')    ? 'c/vc' :
      \     s:executable('clang') ? 'c/clang' :
      \     s:executable('gcc')   ? 'c/gcc' : ''},
      \ 'c/vc' : {
      \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
      \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
      \   'hook/vcvarsall/bat' : $VCVARSALL},
      \
      \ 'cpp' : {
      \   'type' :
      \     exists('$VCVARSALL')    ? 'cpp/vc' :
      \     s:executable('cl')      ? 'cpp/vc' :
      \     s:executable('clang++') ? 'cpp/clang++' :
      \     s:executable('g++')     ? 'cpp/g++' : ''},
      \ 'cpp/vc' : {
      \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
      \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
      \   'hook/vcvarsall/bat' : $VCVARSALL},
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
      \   'hook/vcvarsall/bat' : $VCVARSALL},
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
      \   'hook/vcvarsall/bat' : $VCVARSALL}})

    nnoremap <expr> <C-C>
      \ quickrun#is_running() ? quickrun#sweep_sessions() : '<C-C>'
  endfunction

  nmap <expr> sr
    \ neobundle#get('precious') != {} ?
    \   '<Plug>(precious-quickrun-op)' : '<Plug>(quickrun-op)'
  xmap sr  <Plug>(quickrun)
  omap sr  g@
  nmap srr srsr

  NXmap <Leader>r <Plug>(quickrun)
  NXmap <F5>      <Plug>(quickrun)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Reanimate: {{{
silent! let s:bundle = neobundle#get('reanimate')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:reanimate_save_dir = $HOME . '/.local/reanimate'
  endfunction

  NXnoremap <Leader>us  <Nop>
  NXnoremap <Leader>usl :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_load<CR>
  NXnoremap <Leader>uss :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_save<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Ref: {{{
silent! let s:bundle = neobundle#get('ref')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:ref_no_default_key_mappings = 1
    let g:ref_cache_dir               = $HOME . '/.local/.vim_ref_cache'
  endfunction

  NXmap K <Plug>(ref-keyword)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" RengBang: {{{
silent! let s:bundle = neobundle#get('rengbang')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    function! s:operator_rengbang_prompt(motion_wise)
      execute input(':', line("'[") . ',' . line("']") . 'RengBang ')
    endfunction

    call operator#user#define('rengbang-prompt', s:SID_PREFIX() . 'operator_rengbang_prompt')
  endfunction

  NXOmap s+ <Plug>(operator-rengbang-prompt)

  nmap s++ s+s+
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Repeat: {{{
silent! let s:bundle = neobundle#get('repeat')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap <M-o>
    \ :<C-U>call append(line('.'), repeat([''], v:count1))<Bar>
    \ call repeat#set('<M-o>', v:count1)<CR>
  nnoremap <M-O>
    \ :<C-U>call append(line('.') - 1, repeat([''], v:count1))<Bar>
    \ call repeat#set('<M-O>', v:count1)<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" SaveVers: {{{
silent! let s:bundle = neobundle#get('savevers')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:savevers_dirs         = &backupdir
    let g:savevers_hierarchical = 1
    let g:versdiff_no_resize    = 1
  endfunction

  NXnoremap <F6> :<C-U>VersDiff -<CR>
  NXnoremap <F7> :<C-U>VersDiff +<CR>
  NXnoremap <F8> :<C-U>execute 'VersDiff -c'<Bar>Undiff<CR>

  autocmd MyVimrc BufNewFile,BufRead *
    \ NeoBundleSource savevers
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Scratch: {{{
silent! let s:bundle = neobundle#get('scratch')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:scratch_buffer_name = '[scratch]'
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" SmartWord: {{{
silent! let s:bundle = neobundle#get('smartword')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Switch: {{{
silent! let s:bundle = neobundle#get('switch')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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

    let s:ordinal_suffixes = [
      \ 'th', 'st', 'nd', 'rd', 'th',
      \ 'th', 'th', 'th', 'th', 'th']
    function! s:ordinal(num)
      return a:num . s:ordinal_suffixes[abs(a:num % 10)]
    endfunction

    call extend(g:switch_increment_definitions, [{
      \ '\C\(-\?\d*\)\%(TH\|ST\|ND\|RD\)' :
      \   '\=toupper(call(''' . s:SID_PREFIX() .
      \   'ordinal'', [submatch(1) + 1]))',
      \ '\C\(-\?\d*\)\%(th\|st\|nd\|rd\)' :
      \   '\=tolower(call(''' . s:SID_PREFIX() .
      \   'ordinal'', [submatch(1) + 1]))'}])
    call extend(g:switch_decrement_definitions, [{
      \ '\C\(-\?\d*\)\%(TH\|ST\|ND\|RD\)' :
      \   '\=toupper(call(''' . s:SID_PREFIX() .
      \   'ordinal'', [submatch(1) - 1]))',
      \ '\C\(-\?\d*\)\%(th\|st\|nd\|rd\)' :
      \   '\=tolower(call(''' . s:SID_PREFIX() .
      \   'ordinal'', [submatch(1) - 1]))'}])

    function! s:switch(is_increment)
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
    command! -bar
      \ SwitchIncrement
      \ call s:switch(1)
    command! -bar
      \ SwitchDecrement
      \ call s:switch(0)
  endfunction

  nnoremap <C-A> :<C-U>SwitchIncrement<CR>
  nnoremap <C-X> :<C-U>SwitchDecrement<CR>

  autocmd MyVimrc VimEnter,BufNewFile,BufRead *
    \ let b:switch_no_builtins = 1
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TComment: {{{
silent! let s:bundle = neobundle#get('tcomment')
if exists('s:bundle') && !get(s:bundle, 'disabled', )
  function! s:bundle.hooks.on_source(bundle)
    let g:tcommentMaps = 0

    function! s:tcomment_operator_setup(options)
      let w:tcommentPos = getpos('.')
      call tcomment#SetOption('count', v:count)
      for [key, value] in items(a:options)
        call tcomment#SetOption(key, value)
      endfor
    endfunction

    function! s:tcomment_operator_block(type)
      call tcomment#Operator(a:type, 'B')
    endfunction

    call operator#user#define(
      \ 'tcomment',
      \ 'tcomment#Operator',
      \ 'call ' . s:SID_PREFIX() .
      \ 'tcomment_operator_setup({})')
    call operator#user#define(
      \ 'tcomment-col=1',
      \ 'tcomment#Operator',
      \ 'call ' . s:SID_PREFIX() .
      \ 'tcomment_operator_setup({"col" : 1})')

    call operator#user#define(
      \ 'tcomment-block',
      \ s:SID_PREFIX() . 'tcomment_operator_block',
      \ 'call ' . s:SID_PREFIX() .
      \ 'tcomment_operator_setup({})')
    call operator#user#define(
      \ 'tcomment-block-col=1',
      \ s:SID_PREFIX() . 'tcomment_operator_block',
      \ 'call ' . s:SID_PREFIX() .
      \ 'tcomment_operator_setup({"col" : 1})')
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
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
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Tern: {{{
silent! let s:bundle = neobundle#get('tern_for_vim')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:tern#command = ['node',
      \ neobundle#get('tern').path . '/bin/tern']
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'tern#Complete' : '.*'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextManipilate: {{{
silent! let s:bundle = neobundle#get('textmanip')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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

    function! s:operator_textmanip_duplicate_down(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#duplicate("down", "v")', a:motion_wise)
    endfunction
    function! s:operator_textmanip_duplicate_up(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#duplicate("up", "v")', a:motion_wise)
    endfunction
    function! s:operator_textmanip_move_left(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#move("left")', a:motion_wise)
    endfunction
    function! s:operator_textmanip_move_right(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#move("right")', a:motion_wise)
    endfunction
    function! s:operator_textmanip_move_down(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#move("down")', a:motion_wise)
    endfunction
    function! s:operator_textmanip_move_up(motion_wise)
      call s:operator_textmanip(
        \ 'textmanip#move("up")', a:motion_wise)
    endfunction

    call operator#user#define(
      \ 'textmanip-duplicate-down',
      \ s:SID_PREFIX() . 'operator_textmanip_duplicate_down')
    call operator#user#define(
      \ 'textmanip-duplicate-up',
      \ s:SID_PREFIX() . 'operator_textmanip_duplicate_up')
    call operator#user#define(
      \ 'textmanip-move-left',
      \ s:SID_PREFIX() . 'operator_textmanip_move_left')
    call operator#user#define(
      \ 'textmanip-move-right',
      \ s:SID_PREFIX() . 'operator_textmanip_move_right')
    call operator#user#define(
      \ 'textmanip-move-down',
      \ s:SID_PREFIX() . 'operator_textmanip_move_down')
    call operator#user#define(
      \ 'textmanip-move-up',
      \ s:SID_PREFIX() . 'operator_textmanip_move_up')
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Between: {{{
silent! let s:bundle = neobundle#get('textobj-between')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_between_no_default_key_mappings = 1
  endfunction

  XOmap af <Plug>(textobj-between-a)
  XOmap if <Plug>(textobj-between-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Comment: {{{
silent! let s:bundle = neobundle#get('textobj-comment')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  XOmap ac <Plug>(textobj-comment-a)
  XOmap ic <Plug>(textobj-comment-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Continuous Line: {{{
silent! let s:bundle = neobundle#get('textobj-continuous-line')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_continuous_line_no_default_key_mappings = 1
    let g:textobj_continuous_line_no_default_mappings     = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj DateTime: {{{
silent! let s:bundle = neobundle#get('textobj-datetime')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Diff: {{{
silent! let s:bundle = neobundle#get('textobj-diff')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_diff_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Entrie: {{{
silent! let s:bundle = neobundle#get('textobj-entire')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  XOmap ae <Plug>(textobj-entire-a)
  XOmap ie <Plug>(textobj-entire-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj EnclosedSyntax: {{{
silent! let s:bundle = neobundle#get('textobj-enclosedsyntax')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_enclosedsyntax_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Fold: {{{
silent! let s:bundle = neobundle#get('textobj-fold')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_fold_no_default_key_mappings = 1
  endfunction

  XOmap az <Plug>(textobj-fold-a)
  XOmap iz <Plug>(textobj-fold-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Function: {{{
silent! let s:bundle = neobundle#get('textobj-function')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_function_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Ifdef: {{{
silent! let s:bundle = neobundle#get('textobj-ifdef')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj IndentBlock: {{{
silent! let s:bundle = neobundle#get('textobj-indblock')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_indblock_no_default_key_mappings = 1
  endfunction

  XOmap ao <Plug>(textobj-indblock-a)
  XOmap io <Plug>(textobj-indblock-i)
  XOmap aO <Plug>(textobj-indblock-same-a)
  XOmap iO <Plug>(textobj-indblock-same-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Indent: {{{
silent! let s:bundle = neobundle#get('textobj-indent')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_indent_no_default_key_mappings = 1
  endfunction

  XOmap ai <Plug>(textobj-indent-a)
  XOmap ii <Plug>(textobj-indent-i)
  XOmap aI <Plug>(textobj-indent-same-a)
  XOmap iI <Plug>(textobj-indent-same-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj JaBraces: {{{
silent! let s:bundle = neobundle#get('textobj-jabraces')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Line: {{{
silent! let s:bundle = neobundle#get('textobj-line')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  XOmap al <Plug>(textobj-line-a)
  XOmap il <Plug>(textobj-line-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj MultiBlock: {{{
silent! let s:bundle = neobundle#get('textobj-multiblock')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_multiblock_no_default_key_mappings = 1
  endfunction

  XOmap ab <Plug>(textobj-multiblock-a)
  XOmap ib <Plug>(textobj-multiblock-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj MultiTextObj: {{{
silent! let s:bundle = neobundle#get('textobj-multitextobj')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_multitextobj_textobjects_group_a = {
      \ 'A' : [{'textobj' : 'a"',  'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'B' : [{'textobj' : 'a''', 'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'C' : [{'textobj' : 'a`',  'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'D' : [[
      \   "\<Plug>(textobj-jabraces-parens-a)",
      \   "\<Plug>(textobj-jabraces-braces-a)",
      \   "\<Plug>(textobj-jabraces-brackets-a)",
      \   "\<Plug>(textobj-jabraces-angles-a)",
      \   "\<Plug>(textobj-jabraces-double-angles-a)",
      \   "\<Plug>(textobj-jabraces-kakko-a)",
      \   "\<Plug>(textobj-jabraces-double-kakko-a)",
      \   "\<Plug>(textobj-jabraces-yama-kakko-a)",
      \   "\<Plug>(textobj-jabraces-double-yama-kakko-a)",
      \   "\<Plug>(textobj-jabraces-kikkou-kakko-a)",
      \   "\<Plug>(textobj-jabraces-sumi-kakko-a)"]]}
    let g:textobj_multitextobj_textobjects_group_i = {
      \ 'A' : [{'textobj' : 'i"',  'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'B' : [{'textobj' : 'i''', 'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'C' : [{'textobj' : 'i`',  'is_cursor_in' : 1, 'noremap' : 1}],
      \ 'D' : [[
      \   "\<Plug>(textobj-jabraces-parens-i)",
      \   "\<Plug>(textobj-jabraces-braces-i)",
      \   "\<Plug>(textobj-jabraces-brackets-i)",
      \   "\<Plug>(textobj-jabraces-angles-i)",
      \   "\<Plug>(textobj-jabraces-double-angles-i)",
      \   "\<Plug>(textobj-jabraces-kakko-i)",
      \   "\<Plug>(textobj-jabraces-double-kakko-i)",
      \   "\<Plug>(textobj-jabraces-yama-kakko-i)",
      \   "\<Plug>(textobj-jabraces-double-yama-kakko-i)",
      \   "\<Plug>(textobj-jabraces-kikkou-kakko-i)",
      \   "\<Plug>(textobj-jabraces-sumi-kakko-i)"]]}
  endfunction

  XOmap <SID>(textobj-double-quotes-a) <Plug>(textobj-multitextobj-A-a)
  XOmap <SID>(textobj-double-quotes-i) <Plug>(textobj-multitextobj-A-i)
  XOmap <SID>(textobj-single-quotes-a) <Plug>(textobj-multitextobj-B-a)
  XOmap <SID>(textobj-single-quotes-i) <Plug>(textobj-multitextobj-B-i)
  XOmap <SID>(textobj-back-quotes-a)   <Plug>(textobj-multitextobj-C-a)
  XOmap <SID>(textobj-back-quotes-i)   <Plug>(textobj-multitextobj-C-i)
  XOmap <SID>(textobj-jabraces-a)      <Plug>(textobj-multitextobj-D-a)
  XOmap <SID>(textobj-jabraces-i)      <Plug>(textobj-multitextobj-D-i)

  XOmap a" <SID>(textobj-double-quotes-a)
  XOmap i" <SID>(textobj-double-quotes-i)
  XOmap a' <SID>(textobj-single-quotes-a)
  XOmap i' <SID>(textobj-single-quotes-i)
  XOmap a` <SID>(textobj-back-quotes-a)
  XOmap i` <SID>(textobj-back-quotes-i)
  XOmap aB <SID>(textobj-jabraces-a)
  XOmap iB <SID>(textobj-jabraces-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj MotionMotion: {{{
silent! let s:bundle = neobundle#get('textobj-motionmotion')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_motionmotion_no_default_key_mappings = 1
  endfunction

  XOmap am <Plug>(textobj-motionmotion-a)
  XOmap im <Plug>(textobj-motionmotion-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Parameter: {{{
silent! let s:bundle = neobundle#get('textobj-parameter')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  XOmap a, <Plug>(textobj-parameter-a)
  XOmap i, <Plug>(textobj-parameter-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj PHP: {{{
silent! let s:bundle = neobundle#get('textobj-php')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_php_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Python: {{{
silent! let s:bundle = neobundle#get('textobj-python')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_python_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Ruby: {{{
silent! let s:bundle = neobundle#get('textobj-ruby')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_ruby_no_default_key_mappings = 1
    let g:textobj_ruby_more_mappings           = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Sigil: {{{
silent! let s:bundle = neobundle#get('textobj-sigil')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Space: {{{
silent! let s:bundle = neobundle#get('textobj-space')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_space_no_default_key_mappings = 1
  endfunction

  XOmap aS <Plug>(textobj-space-a)
  XOmap iS <Plug>(textobj-space-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Syntax: {{{
silent! let s:bundle = neobundle#get('textobj-syntax')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  XOmap ay <Plug>(textobj-syntax-a)
  XOmap iy <Plug>(textobj-syntax-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Url: {{{
silent! let s:bundle = neobundle#get('textobj-url')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  XOmap au <Plug>(textobj-url-a)
  XOmap iu <Plug>(textobj-url-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj WordInWord: {{{
silent! let s:bundle = neobundle#get('textobj-wiw')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_wiw_no_default_key_mappings = 1
  endfunction

  NXOmap <M-w>      <Plug>(textobj-wiw-n)
  NXOmap <M-b>      <Plug>(textobj-wiw-p)
  NXOmap <M-e>      <Plug>(textobj-wiw-N)
  NXOmap <M-g><M-e> <Plug>(textobj-wiw-P)

  XOmap a<M-w> <Plug>(textobj-wiw-a)
  XOmap i<M-w> <Plug>(textobj-wiw-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj Word Column: {{{
silent! let s:bundle = neobundle#get('textobj-word-column')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_wordcolumn_no_default_key_mappings = 1
  endfunction

  XOmap av <Plug>(textobj-wordcolumn-w-a)
  XOmap aV <Plug>(textobj-wordcolumn-W-a)
  XOmap iv <Plug>(textobj-wordcolumn-w-i)
  XOmap iV <Plug>(textobj-wordcolumn-W-i)
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" TextObj XML Attribute: {{{
silent! let s:bundle = neobundle#get('textobj-xml-attribute')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_xmlattribute_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" UndoTree: {{{
silent! let s:bundle = neobundle#get('undotree')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:undotree_SetFocusWhenToggle = 1
  endfunction

  NXnoremap <M-U> :<C-U>UndotreeToggle<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite: {{{
silent! let s:bundle = neobundle#get('unite')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_data_directory             = $HOME . '/.local/.unite'
    let g:unite_enable_start_insert        = 1
    let g:unite_winheight                  = 25
    let g:unite_source_history_yank_enable = 1
    let g:unite_cursor_line_highlight      = 'CursorLine'
    let g:unite_source_grep_max_candidates = 1000
    let g:unite_source_grep_encoding       = 'utf-8'
    let g:unite_source_file_mru_limit      = 50
    let g:unite_source_directory_mru_limit = 50

    let g:unite_source_directory_mru_ignore_pattern =
      \ '\%(^\|[/\\]\)\.\%(hg\|git\|bzr\|svn\)\%($\|[/\\]\)' .
      \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'
    let g:unite_source_file_mru_ignore_pattern =
      \ '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$' .
      \ '\|\%(^\|[/\\]\)\.\%(hg\|git\|bzr\|svn\)\%($\|[/\\]\)' .
      \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)' .
      \ '\|\%(^\%(fugitive\):\%(//\|\\\\\)\)'

    if s:jvgrep_enable
      let g:unite_source_grep_command       = 'jvgrep'
      let g:unite_source_grep_recursive_opt = '-R'
      let g:unite_source_grep_default_opts  = '-n --exclude .drive.r'
    elseif s:ag_enable
      let g:unite_source_grep_command       = 'ag'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_grep_default_opts  =
        \ '--line-numbers --nocolor --nogroup --hidden --ignore .drive.r ' .
        \ '--ignore .hg --ignore .git --ignore .svn'
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

  function! s:unite_search_expr()
    return line('$') > 10000
  endfunction
  function! s:unite_search_forward()
    return s:unite_search_expr() ?
      \ (":\<C-U>Unite line/fast" .
      \  " -buffer-name=search -no-split -start-insert\<CR>") :
      \ (":\<C-U>Unite line" .
      \  " -buffer-name=search -no-split -start-insert\<CR>")
  endfunction
  function! s:unite_search_backward()
    return s:unite_search_expr() ?
      \ (":\<C-U>Unite line/fast:backward" .
      \  " -buffer-name=search -no-split -start-insert\<CR>") :
      \ (":\<C-U>Unite line:backward" .
      \  " -buffer-name=search -no-split -start-insert\<CR>")
  endfunction
  function! s:unite_search_cword_forward()
    return s:unite_search_expr() ?
      \ (":\<C-U>UniteWithCursorWord line/fast" .
      \  " -buffer-name=search -no-split -no-start-insert\<CR>") :
      \ (":\<C-U>UniteWithCursorWord line" .
      \  " -buffer-name=search -no-split -no-start-insert\<CR>")
  endfunction
  function! s:unite_search_cword_backward()
    return s:unite_search_expr() ?
      \ (":\<C-U>UniteWithCursorWord line/fast:backward" .
      \  " -buffer-name=search -no-split -no-start-insert\<CR>") :
      \ (":\<C-U>UniteWithCursorWord line:backward" .
      \  " -buffer-name=search -no-split -no-start-insert\<CR>")
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

  NXnoremap <Leader>e
    \ :<C-U>Unite file_mru file file/new
    \ -buffer-name=files -no-split<CR>
  NXnoremap <Leader>b
    \ :<C-U>Unite buffer
    \ -buffer-name=files -no-split<CR>
  NXnoremap <Leader>t
    \ :<C-U>Unite tab
    \ -buffer-name=files -no-split<CR>
  NXnoremap <Leader>d
    \ :<C-U>Unite
    \ menu:directory_current directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=lcd<CR>
  NXnoremap <Leader>D
    \ :<C-U>Unite
    \ menu:directory_current directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=cd<CR>
  NXnoremap <Leader><M-d>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=lcd<CR>
  NXnoremap <Leader><M-D>
    \ :<C-U>UniteWithBufferDir
    \ menu:directory_file directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=cd<CR>

  if &grepprg == 'internal'
    nnoremap sgsg
      \ :<C-U>Unite vimgrep
      \ -buffer-name=grep -no-split -multi-line<CR>
  else
    nnoremap sgsg
      \ :<C-U>Unite grep
      \ -buffer-name=grep -no-split -multi-line<CR>
  endif
  NXnoremap sG
    \ :<C-U>UniteResume grep
    \ -no-split -multi-line -no-start-insert<CR>

  NXnoremap <Leader>j
    \ :<C-U>Unite jump
    \ -buffer-name=register -no-empty<CR>
  NXnoremap <Leader>J
    \ :<C-U>Unite change
    \ -buffer-name=register -no-empty<CR>
  nnoremap <C-P>
    \ :<C-U>Unite register history/yank
    \ -buffer-name=register -no-empty -multi-line<CR>
  xnoremap <C-P>
    \ d:<C-U>Unite register history/yank
    \ -buffer-name=register -no-empty -multi-line<CR>
  inoremap <expr> <C-P>
    \ unite#start_complete(['register', 'history/yank'], {
    \   'buffer_name': 'register',
    \   'is_multi_line' : 1,
    \   'direction' : 'leftabove'})

  NXnoremap <Leader>un
    \ :<C-U>UniteResume search -start-insert<CR>
  NXnoremap <C-N>
    \ :<C-U>execute 'Unite vimgrep:%:' . escape(@/, '\ :')
    \ '-buffer-name=search -no-split -multi-line'<CR>

  NXnoremap <expr> <Leader>u/ <SID>unite_search_forward()
  NXnoremap <expr> <Leader>u? <SID>unite_search_backward()
  NXnoremap <expr> <Leader>u* <SID>unite_search_cword_forward()
  NXnoremap <expr> <Leader>u# <SID>unite_search_cword_backward()

  NXmap <Leader>ug/ <Leader>u*
  NXmap <Leader>ug? <Leader>u#

  call extend(s:altercmd_define, {
    \ 'u[nite]' : 'Unite'})
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite Help: {{{
silent! let s:bundle = neobundle#get('unite-help')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap <Leader>u<F1>
    \ :<C-U>Unite help
    \ -buffer-name=help -start-insert<CR>
  nnoremap <Leader>u<F2>
    \ :<C-U>UniteWithCursorWord help
    \ -buffer-name=help -no-start-insert<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite Mark: {{{
silent! let s:bundle = neobundle#get('unite-mark')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_source_mark_marks =
      \ join(s:mark_char, '') . toupper(join(s:mark_char, ''))
  endfunction

  nnoremap ml
    \ :<C-U>Unite mark bookmark
    \ -buffer-name=register -no-start-insert -no-empty<CR>
  nnoremap mu :<C-U>UniteBookmarkAdd<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite Outline: {{{
silent! let s:bundle = neobundle#get('unite-outline')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXnoremap <Leader>uo
    \ :<C-U>Unite outline
    \ -buffer-name=outline -no-split<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite QuickFix: {{{
silent! let s:bundle = neobundle#get('unite-quickfix')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXnoremap <Leader>u,
    \ :<C-U>Unite quickfix
    \ -buffer-name=register -no-empty<CR>
  NXnoremap <Leader>u.
    \ :<C-U>Unite location_list
    \ -buffer-name=register -no-empty<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite QuickRun Config: {{{
silent! let s:bundle = neobundle#get('unite-quickrun_config')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXnoremap <Leader>ur
    \ :<C-U>Unite quickrun_config
    \ -buffer-name=register -no-empty<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite SSH: {{{
silent! let s:bundle = neobundle#get('unite-ssh')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  autocmd MyVimrc User VimrcPost
    \ if has('vim_starting') && filter(argv(), 'v:val =~# "^ssh:"') != [] |
    \   NeoBundleSource unite-ssh |
    \ endif
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite Sudo: {{{
silent! let s:bundle = neobundle#get('unite-sudo')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  autocmd MyVimrc User VimrcPost
    \ if has('vim_starting') && filter(argv(), 'v:val =~# "^sudo:"') != [] |
    \   NeoBundleSource unite-sudo |
    \ endif
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" Unite Tag: {{{
silent! let s:bundle = neobundle#get('unite-tag')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXnoremap <Leader>ut
    \ :<C-U>UniteWithCursorWord tag tag/include
    \ -buffer-name=outline -no-split -no-start-insert<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VerifyEnc: {{{
silent! let s:bundle = neobundle#get('verifyenc')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  autocmd MyVimrc BufReadPre *
    \ NeoBundleSource verifyenc
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VimDoc Ja: {{{
silent! let s:bundle = neobundle#get('vimdoc-ja')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  set helplang^=ja
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VimFiler: {{{
silent! let s:bundle = neobundle#get('vimfiler')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_data_directory      = $HOME . '/.local/.vimfiler'
    let g:vimfiler_as_default_explorer = 1
  endfunction

  NXnoremap <Leader>E     :<C-U>VimFiler<CR>
  NXnoremap <Leader><C-E> :<C-U>VimFilerExplorer<CR>
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VimProc: {{{
silent! let s:bundle = neobundle#get('vimproc')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    if s:is_android
      let g:vimproc_dll_path = expand('/data/local/vimproc_unix.so')
    endif
  endfunction
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VimShell: {{{
silent! let s:bundle = neobundle#get('vimshell')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:vimshell_temporary_directory      = $HOME . '/.local/.vimshell'
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
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" VisualStar: {{{
silent! let s:bundle = neobundle#get('visualstar')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:visualstar_no_default_key_mappings = 1
  endfunction

  xmap <SID>(visualstar-*)  <Plug>(visualstar-*)
  xmap <SID>(visualstar-#)  <Plug>(visualstar-#)
  xmap <SID>(visualstar-g*) <Plug>(visualstar-g*)
  xmap <SID>(visualstar-g#) <Plug>(visualstar-g#)

  xnoremap <script> *  <SID>(visualstar-*)zvzz
  xnoremap <script> #  <SID>(visualstar-#)zvzz
  xnoremap <script> g* <SID>(visualstar-g*)zvzz
  xnoremap <script> g# <SID>(visualstar-g#)zvzz

  xnoremap <script> <C-W>*
    \ <SID>(split-nicely)gv<SID>(visualstar-*)zvzz
  xnoremap <script> <C-W>#
    \ <SID>(split-nicely)gv<SID>(visualstar-#)zvzz
  xnoremap <script> <C-W>g*
    \ <SID>(split-nicely)gv<SID>(visualstar-g*)zvzz
  xnoremap <script> <C-W>g#
    \ <SID>(split-nicely)gv<SID>(visualstar-g#)zvzz
endif
unlet! s:bundle
"}}}

"------------------------------------------------------------------------------
" WatchDogs: {{{
silent! let s:bundle = neobundle#get('watchdogs')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enable = 1

    let g:quickrun_config =
      \ get(g:, 'quickrun_config', {})

    call extend(g:quickrun_config, {
      \ 'c/watchdogs_checker' : {
      \   'type' :
      \     exists('$VCVARSALL')  ? 'watchdogs_checker/msvc' :
      \     s:executable('cl')    ? 'watchdogs_checker/msvc' :
      \     s:executable('clang') ? 'watchdogs_checker/clang' :
      \     s:executable('gcc')   ? 'watchdogs_checker/gcc' : ''},
      \ 'cpp/watchdogs_checker' : {
      \   'type' :
      \     exists('$VCVARSALL')    ? 'watchdogs_checker/msvc' :
      \     s:executable('cl')      ? 'watchdogs_checker/msvc' :
      \     s:executable('clang++') ? 'watchdogs_checker/clang++' :
      \     s:executable('g++')     ? 'watchdogs_checker/g++' : ''},
      \ 'watchdogs_checker/msvc' : {
      \   'hook/output_encode/encoding' : has('win32') ? 'cp932' : &encoding,
      \   'hook/vcvarsall/enable' : exists('$VCVARSALL'),
      \   'hook/vcvarsall/bat' : $VCVARSALL},
      \
      \ 'lua/watchdogs_checker' : {
      \   'type' :
      \     s:executable('luac')   ? 'watchdogs_checker/luac' :
      \     s:executable('luac52') ? 'watchdogs_checker/luac' : ''},
      \ 'watchdogs_checker/luac' : {
      \   'command' :
      \     s:executable('luac')   ? 'luac' :
      \     s:executable('luac52') ? 'luac52' : ''},
      \
      \ 'vim/watchdogs_checker' : {
      \   'type' :
      \     has('python') ? 'watchdogs_checker/vimlint_by_dbakker' : ''}})
  endfunction

  autocmd MyVimrc FileType *
    \ NeoBundleSource watchdogs
endif
unlet! s:bundle
"}}}

"==============================================================================
" Post Init: {{{
if filereadable($HOME . '/.local/.vimrc_local.vim')
  source ~/.local/.vimrc_local.vim
endif

if exists('#User#VimrcPost')
  execute 'doautocmd' (s:has_patch(703, 438) ? '<nomodeline>' : '')
    \ 'User VimrcPost'
endif
"}}}
