" -*- mode: vimrc; coding: utf8-unix -*-

" @name        .vimrc
" @description Vim settings
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-07-29 20:52:24 DeaR>

set nocompatible
scriptencoding utf-8

"=============================================================================
" Init First: {{{
" Encoding
if has('multi_byte')
  set encoding=utf-8
  if &term == 'win32' && !has('gui_running')
    set termencoding=cp932
  endif
  scriptencoding utf-8
endif

" Language
if has('win32') && has('multi_lang')
  language japanese
  language time C
endif

if has('win32')
  " Shell
  set shell=sh
  set shellslash

  " Unix like runtime
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
endif

" Local runtime
set runtimepath^=~/.local/.vim
set runtimepath+=~/.local/.vim/after

" Singleton
if has('clientserver') && isdirectory($HOME . '/.local/bundle/singleton')
  set runtimepath+=~/.local/bundle/singleton
  let g:singleton#opener = 'drop'
  call singleton#enable()
endif

"-----------------------------------------------------------------------------
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
let s:_executable = get(s:, '_executable', {})
function! s:executable(expr)
  let s:_executable[a:expr] = get(s:_executable, a:expr, executable(a:expr))
  return s:_executable[a:expr]
endfunction

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' ||
  \  $VIM =~? 'net\.momodalo\.app\.vimtouch')
"}}}

"-----------------------------------------------------------------------------
" Variable: {{{
" <Leader> <LocalLeader>
let g:mapleader      = '\'
let g:maplocalleader = '|'

" Command line window
let s:cmdwin_enable = 1

" AlterCommand
let s:altercmd_define =
  \ get(s:, 'altercmd_define', {})

" NeoComplete or NeoComplCache
let s:neocompl_force_omni_patterns =
  \ get(s:, 'neocompl_force_omni_patterns', {})
let s:neocompl_keyword_patterns =
  \ get(s:, 'neocompl_keyword_patterns', {})
let s:neocompl_omni_patterns =
  \ get(s:, 'neocompl_omni_patterns', {})
let s:neocompl_dictionary_filetype_lists =
  \ get(s:, 'neocompl_dictionary_filetype_lists', {})
let s:neocompl_vim_completefuncs =
  \ get(s:, 'neocompl_vim_completefuncs', {})

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

"-----------------------------------------------------------------------------
" NeoBundle: {{{
if isdirectory($HOME . '/.local/bundle/neobundle')
  set runtimepath+=~/.local/bundle/neobundle
  if has('win32')
    let g:neobundle#rm_command = 'rm -rf'
  elseif s:is_android
    let g:neobundle#types#git#default_protocol = 'ssh'
    let g:neobundle#types#hg#default_protocol  = 'ssh'
  endif
  let g:neobundle#enable_name_conversion = 1
  let g:neobundle#enable_tail_path       = 1
  call neobundle#rc($HOME . '/.local/bundle')

  NeoBundleLazy 'h1mesuke/vim-alignta', {
    \ 'autoload' : {
    \   'commands' : ['Align', 'Alignta'],
    \   'unite_sources' : 'alignta'}}

  NeoBundleLazy 'tyru/vim-altercmd', {
    \ 'autoload' : {
    \   'commands' : [
    \     'AlterCommand',  'CAlterCommand', 'IAlterCommand',
    \     'NAlterCommand', 'VAlterCommand', 'XAlterCommand',
    \     'SAlterCommand', 'OAlterCommand', 'LAlterCommand']}}

  NeoBundleLazy 'kana/vim-altr', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvoi', '<Plug>(altr-forward)', '<Plug>(altr-back)']]}}

  NeoBundleLazy 'gist:iori-yja/1615430', {
    \ 'name' : 'arm',
    \ 'autoload' : {'filetypes' : 'arm'},
    \ 'script_type' : 'syntax'}

  NeoBundleLazy 'autodate.vim'

  NeoBundleLazy 'vim-jp/autofmt'

  NeoBundleLazy 'h1mesuke/vim-benchmark'

  NeoBundleLazy 'mattn/benchvimrc-vim', {
    \ 'autoload' : {'commands' : 'BenchVimrc'}}

  if has('python') && s:executable('clang')
    NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {'filetypes' : ['c', 'cpp', 'objc', 'objcpp']}}
  endif

  NeoBundleLazy 'rhysd/clever-f.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(clever-f-f)', '<Plug>(clever-f-F)',
    \      '<Plug>(clever-f-t)', '<Plug>(clever-f-T)',
    \      '<Plug>(clever-f-reset)',
    \      '<Plug>(clever-f-repeat-forward)',
    \      '<Plug>(clever-f-repeat-back)']],
    \   'insert' : 1}}

  NeoBundleLazy 'deris/columnjump', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(columnjump-forward)',
    \      '<Plug>(columnjump-backward)']],
    \   'commands' : [
    \     'ColumnJumpForward', 'ColumnJumpBackward'],
    \   'insert' : 1}}

  NeoBundleLazy 'vim-jp/cpp-vim', {
    \ 'autoload' : {'filetypes' : ['c', 'cpp']}}

  NeoBundleLazy 'hail2u/vim-css3-syntax', {
    \ 'autoload' : {'filetypes' : ['css', 'html', 'scss']}}

  NeoBundleLazy 'JesseKPhillips/d.vim', {
    \ 'autoload' : {'filetypes' : 'd'}}

  NeoBundleLazy 'thinca/vim-ft-clojure', {
    \ 'autoload' : {'filetypes' : 'clojure'}}

  NeoBundleLazy 'thinca/vim-ft-diff_fold', {
    \ 'autoload' : {'filetypes' : 'diff'}}

  NeoBundleLazy 'thinca/vim-ft-help_fold', {
    \ 'autoload' : {'filetypes' : 'help'}}

  NeoBundleLazy 'thinca/vim-ft-markdown_fold', {
    \ 'autoload' : {'filetypes' : 'markdown'}}

  NeoBundleLazy 'thinca/vim-ft-vim_fold', {
    \ 'autoload' : {'filetypes' : 'vim'}}

  NeoBundleLazy 'tpope/vim-fugitive', {
    \ 'autoload' : {
    \   'commands' : [
    \     'Git',     'Gcd',     'Glcd',     'Gstatus',
    \     'Gcommit', 'Ggrep',   'Glgrep',   'Glog',
    \     'Gllog',   'Ge',      'Gedit',    'Gpedit',
    \     'Gsplit',  'Gvsplit', 'Gtabedit', 'Gread',
    \     'Gwrite',  'Gw',      'Gwq',      'Gdiff',
    \     'Gvdiff',  'Gsdiff',  'Gbrowse']}}

  NeoBundleLazy 'kana/vim-gf-user', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nv',
    \      '<Plug>(gf-user-gf)',
    \      '<Plug>(gf-user-gF)',
    \      '<Plug>(gf-user-<C-w>f)',
    \      '<Plug>(gf-user-<C-w><C-f>)',
    \      '<Plug>(gf-user-<C-w>F)',
    \      '<Plug>(gf-user-<C-w>gf)',
    \      '<Plug>(gf-user-<C-w>gF)']]},
    \ 'depends' : [
    \   'sgur/vim-gf-autoload',
    \   'kana/vim-gf-diff']}

  NeoBundleLazy 'yomi322/vim-gitcomplete', {
    \ 'autoload' : {'filetypes' : 'vimshell'}}

  NeoBundleLazy 'gregsexton/gitv', {
    \ 'autoload' : {'commands' : 'Gitv'},
    \ 'depends' : 'tpope/vim-fugitive'}

  NeoBundleLazy 'jnwhiteh/vim-golang', {
    \ 'autoload' : {
    \   'filetypes' : 'go',
    \   'commands' : [
    \     {'name' : 'Godoc',
    \      'complete' : 'customlist,go#complete#Package'}],
    \   'mappings' : [['n', '<Plug>(godoc-keyword)']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Godoc' : 'go#complete#Package'})

  NeoBundleLazy 'kana/vim-grex', {
    \ 'autoload' : {
    \   'commands' : ['Gred', 'Grey'],
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-grex-delete)',
    \      '<Plug>(operator-grex-yank)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'cohama/vim-hier', {
    \ 'autoload' : {
    \   'filetypes' : 'qf',
    \   'commands' : [
    \     'HierUpdate', 'HierClear', 'HierStart', 'HierStop']}}

  NeoBundleLazy 'HybridText', {
    \ 'autoload' : {'filetypes' : 'hybrid'}}

  if has('conceal')
    NeoBundle 'Yggdroot/indentLine'
  endif

  NeoBundleLazy 'jelera/vim-javascript-syntax', {
    \ 'autoload' : {'filetypes' : 'javascript'}}

  if has('python') || has('python3')
    NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'autoload' : {'filetypes' : 'python'}}
  endif

  NeoBundleLazy 'teramako/jscomplete-vim', {
    \ 'autoload' : {'filetypes' : 'javascript'}}

  NeoBundleLazy 'elzr/vim-json', {
    \ 'autoload' : {'filetypes' : 'json'}}

  NeoBundleLazy 'kwbdi.vim', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>Kwbd']]}}

  NeoBundle 'thinca/vim-localrc'

  if has('lua') || s:executable('lua')
    NeoBundleLazy 'xolox/vim-lua-ftplugin', {
      \ 'name' : 'ft_lua',
      \ 'autoload' : {'filetypes' : 'lua'},
      \ 'depends' : 'xolox/vim-misc'}
  endif

  NeoBundleLazy 'https://raw.github.com/januswel/dotfiles/master/.vim/syntax/mayu.vim', {
    \ 'name' : 'mayu',
    \ 'autoload' : {'filetypes' : 'mayu'},
    \ 'script_type' : 'syntax'}

  if has('unix') && !has('gui_running')
    NeoBundle 'gist:DeaR/5560785', {
      \ 'name' : 'map-alt-keys',
      \ 'script_type' : 'plugin'}
  endif

  NeoBundleLazy 'gist:DeaR/5558981', {
    \ 'name' : 'maplist',
    \ 'autoload' : {
    \   'commands' : [
    \     'MapList',  'NMapList', 'VMapList', 'OMapList', 'XMapList',
    \     'SMapList', 'IMapList', 'CMapList', 'LMapList']},
    \ 'script_type' : 'plugin'}

  NeoBundle 'tomasr/molokai'

  NeoBundleLazy 'kana/vim-narrow', {
    \ 'autoload' : {'commands' : ['Narrow', 'Widen']}}

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
      \     {'name' : 'NeoCompleteSetFileType',
      \      'complete' : 'filetype'},
      \     {'name' : 'NeoCompleteBufferMakeCache',
      \      'complete' : 'file'},
      \     {'name' : 'NeoCompleteDictionaryMakeCache',
      \      'compelte' : 'customlist,neocomplete#filetype_complete'},
      \     {'name' : 'NeoCompleteIncludeMakeCache',
      \      'complete' : 'buffer'},
      \     {'name' : 'NeoCompleteSyntaxMakeCache',
      \      'complete' : 'customlist,neocomplete#filetype_complete'},
      \     'NeoCompleteTagMakeCache'],
      \   'unite_sources' : ['file_include', 'neocomplete'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'Shougo/context_filetype.vim',
      \   'hrsh7th/vim-neco-calc',
      \   'ujihisa/neco-look',
      \   'Shougo/neosnippet.vim']}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'NeoCompleteDictionaryMakeCache' : 'neocomplete#filetype_complete',
      \ 'NeoCompleteSyntaxMakeCache'     : 'neocomplete#filetype_complete'})
  else
    NeoBundleLazy 'Shougo/neocomplcache.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'NeoComplCacheEnable',     'NeoComplCacheDisable',
      \     'NeoComplCacheLock',       'NeoComplCacheUnlock',
      \     'NeoComplCacheLockSource', 'NeoComplCacheUnlockSource',
      \     'NeoComplCacheToggle',     'NeoComplCacheClean',
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
      \      'complete' : 'customlist,neocomplcache#filetype_complete'},
      \     'NeoComplCacheCachingTags'],
      \   'unite_sources' : ['file_include', 'neocomplcache'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'hrsh7th/vim-neco-calc',
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
    \      'compelte' : 'customlist,neosnippet#filetype_complete'},
    \     {'name' : 'NeoSnippetSource',
    \      'complete' : 'file'}],
    \   'mappings' : [
    \     ['v',
    \      '<Plug>(neosnippet_expand_or_jump)',
    \      '<Plug>(neosnippet_jump_or_expand)',
    \      '<Plug>(neosnippet_expand)',
    \      '<Plug>(neosnippet_jump)'],
    \     ['x',
    \      '<Plug>(neosnippet_get_selected_text)',
    \      '<Plug>(neosnippet_expand_target)',
    \      '<Plug>(neosnippet_start_unite_snippet_target)',
    \      '<Plug>(neosnippet_register_oneshot_snippet)'],
    \     ['i',
    \      '<Plug>(neosnippet_start_unite_snippet)']],
    \   'unite_sources' : [
    \     'snippet', 'snippet/target',
    \     'neosnippet/user', 'neosnippet/runtime']},
    \ 'depends' : 'Shougo/context_filetype.vim'}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoSnippetEdit'      : 'neosnippet#edit_complete',
    \ 'NeoSnippetMakeCache' : 'neosnippet#filetype_complete'})

  NeoBundleLazy 'Shougo/vim-nyaos', {
    \ 'autoload' : {'filetypes' : 'nyaos'}}

  if has('python') && (exists('$VCVARSALL') || s:executable('xbuild'))
    NeoBundleLazy 'nosami/Omnisharp', {
      \ 'autoload' : {'filetypes' : 'cs'},
      \ 'depends' : 'tpope/vim-dispatch',
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
    \   'mappings' : [
    \     ['nv',
    \      '<Plug>(openbrowser-open)',
    \      '<Plug>(openbrowser-search)',
    \      '<Plug>(openbrowser-smart-search)']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
    \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})

  NeoBundleLazy 'tyru/operator-camelize.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-camelize)',
    \      '<Plug>(operator-decamelize)',
    \      '<Plug>(operator-camelize-toggle)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'tyru/operator-html-escape.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-html-escape)',
    \      '<Plug>(operator-html-unescape)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'kana/vim-operator-replace', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>(operator-replace)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'sgur/vim-operator-openbrowser', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>(operator-openbrowser)']]},
    \ 'depends' : [
    \   'tyru/open-browser.vim',
    \   'kana/vim-operator-user']}

  NeoBundleLazy 'tyru/operator-reverse.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-reverse-text)',
    \      '<Plug>(operator-reverse-lines)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'emonkak/vim-operator-sort', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>(operator-sort)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'tyru/operator-star.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(operator-*)', '<Plug>(operator-g*)',
    \      '<Plug>(operator-#)', '<Plug>(operator-g#)']]},
    \ 'depends' : [
    \   'kana/vim-operator-user',
    \   'thinca/vim-visualstar']}

  NeoBundleLazy 'kana/vim-operator-user', {
    \ 'autoload' : {'function_prefix' : 'operator'}}

  NeoBundleLazy 'deris/parajump', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(parajump-forward)',
    \      '<Plug>(parajump-backward)']],
    \   'insert' : 1}}

  if s:executable('perl')
    NeoBundleLazy 'c9s/perlomni.vim', {
      \ 'autoload' : {'filetypes' : 'perl'}}
  endif

  NeoBundleLazy 'shawncplus/phpcomplete.vim', {
    \ 'autoload' : {'filetypes' : 'php'}}

  NeoBundleLazy '2072/PHP-Indenting-for-VIm', {
    \ 'name' : 'PHPIndent',
    \ 'autoload' : {'filetypes' : 'php'}}

  NeoBundleLazy 'osyo-manga/vim-precious', {
    \ 'autoload' : {
    \    'mappings' : [
    \      ['vo', '<Plug>(textobj-precious-i)'],
    \      ['n',  '<Plug>(precious-quickrun-op)']],
    \    'commands' : 'PreciousSwitch'},
    \ 'depends' : [
    \   'Shougo/context_filetype.vim',
    \   'thinca/vim-quickrun',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'thinca/vim-prettyprint', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'PrettyPrint',
    \      'complete' : 'expression'},
    \     {'name' : 'PP',
    \      'complete' : 'expression'}],
    \   'functions': ['PrettyPrint', 'PP']}}

  NeoBundleLazy 'kannokanno/previm', {
    \ 'autoload' : {'filetypes' : 'markdown'},
    \ 'depends' : 'tyru/open-browser.vim'}

  " NeoBundleLazy 'fuenor/qfixhowm', {
  "   \ 'autoload' : {
  "   \   'filetypes' : 'qf',
  "   \   'commands' : [
  "   \     'Grep',  'Grepadd',  'RGrep',  'RGrepadd',
  "   \     'EGrep', 'EGrepadd', 'REGrep', 'REGrepadd',
  "   \     'FGrep', 'FGrepadd', 'RFGrep', 'RFGrepadd',
  "   \     'BGrep', 'BGrepadd', 'VGrep',  'VGrepadd',
  "   \     'Vimgrep', 'Vimgrepadd', 'ToggleLocationListMode',
  "   \     'MyGrepWriteResult', 'MyGrepReadResult', 'FList',
  "   \     'OpenQFixWin', 'CloseQFixWin', 'ToggleQFixWin', 'MoveToQFixWin'],
  "   \   'mappings' : [['nv', 'g,']]},
  "   \   'explorer' : 1}

  NeoBundleLazy 'thinca/vim-qfreplace', {
    \ 'autoload' : {
    \   'filetypes' : ['qf', 'unite']}}

  NeoBundleLazy 'dannyob/quickfixstatus', {
    \ 'autoload' : {
    \   'filetypes' : 'qf',
    \   'commands' : [
    \     'QuickfixStatusEnable', 'QuickfixStatusDisable']}}

  NeoBundleLazy 'thinca/vim-quickrun', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'QuickRun',
    \      'complete' : 'customlist,quickrun#complete'}],
    \   'mappings' : [
    \     ['nv', '<Plug>(quickrun)'], ['n', '<Plug>(quickrun-op)']]},
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
    \   'unite_sources' : 'ref'}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Ref' : 'ref#complete'})

  NeoBundleLazy 'vim-ruby/vim-ruby', {
    \ 'autoload' : {'filetypes' : ['eruby', 'ruby']}}

  " NeoBundleLazy 'savevers.vim', {
  NeoBundleLazy 'DeaR/savevers.vim', {
    \ 'autoload' : {'commands' : ['Purge', 'VersDiff']}}

  NeoBundleLazy 'thinca/vim-scouter', {
    \ 'autoload' : {'commands' : 'Scouter'}}

  NeoBundleLazy 'kana/vim-scratch', {
    \ 'autoload' : {
    \   'commands' : 'ScratchOpen',
    \   'mappings' : [['nvo', '<Plug>(scratch-open)']]}}

  NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
    \ 'autoload' : {'filetypes' : 'javascript'}}

  if has('clientserver')
    NeoBundleLazy 'thinca/vim-singleton', {
      \ 'sourced' : 1}
  endif

  " NeoBundleLazy 'kana/vim-smartchr'

  " NeoBundleLazy 'kana/vim-smartinput', {
  "   \ 'autoload' : {'insert' : 1}}
  
  NeoBundleLazy 'kana/vim-smartword', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(smartword-w)', '<Plug>(smartword-b)',
    \      '<Plug>(smartword-e)', '<Plug>(smartword-ge)']],
    \   'insert' : 1}}

  NeoBundleLazy 'tpope/vim-surround', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nx',
    \      '<Plug>Dsurround', '<Plug>Csurround',  '<Plug>Ysurround',
    \      '<Plug>YSurround', '<Plug>Yssurround', '<Plug>YSsurround'],
    \     ['v',
    \      '<Plug>VSurround', '<Plug>VgSurround'],
    \     ['i',
    \      '<Plug>Isurround', '<Plug>ISurround']]},
    \ 'depends' : 'tpope/vim-repeat'}

  NeoBundleLazy 'AndrewRadev/switch.vim', {
    \ 'depends' : 'tpope/vim-repeat'}

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
    \      'complete' : 'customlist,tcomment#CompleteArgs'}]}}
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
    \     ['nv',
    \      '<Plug>(textmanip-duplicate-down)',
    \      '<Plug>(textmanip-duplicate-up)'],
    \     ['v',
    \      '<Plug>(textmanip-move-left)',
    \      '<Plug>(textmanip-move-down)',
    \      '<Plug>(textmanip-move-up)',
    \      '<Plug>(textmanip-move-right)']]}}

  NeoBundleLazy 'thinca/vim-textobj-between', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-between-a)',
    \      '<Plug>(textobj-between-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'thinca/vim-textobj-comment', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-comment-a)',
    \      '<Plug>(textobj-comment-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-datetime', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-datetime-auto)',
    \      '<Plug>(textobj-datetime-date)',
    \      '<Plug>(textobj-datetime-full)',
    \      '<Plug>(textobj-datetime-time)',
    \      '<Plug>(textobj-datetime-tz)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-diff', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(textobj-diff-file-N)',
    \      '<Plug>(textobj-diff-file-P)',
    \      '<Plug>(textobj-diff-file-n)',
    \      '<Plug>(textobj-diff-file-p)',
    \      '<Plug>(textobj-diff-hunk-N)',
    \      '<Plug>(textobj-diff-hunk-P)',
    \      '<Plug>(textobj-diff-hunk-n)',
    \      '<Plug>(textobj-diff-hunk-p)'],
    \     ['vo',
    \      '<Plug>(textobj-diff-file)',
    \      '<Plug>(textobj-diff-file)',
    \      '<Plug>(textobj-diff-hunk)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', {
    \ 'autoload' : {'filetypes' : ['perl', 'ruby', 'eruby']},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-entire', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-entire-a)',
    \      '<Plug>(textobj-entire-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-fold', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-fold-a)',
    \      '<Plug>(textobj-fold-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-function', {
    \ 'autoload' : {'filetypes' : ['c', 'cpp', 'objc', 'objcpp', 'vim']},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'thinca/vim-textobj-function-javascript', {
    \ 'autoload' : {'filetypes' : 'javascript'},
    \ 'depends' : [
    \   'kana/vim-textobj-function',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'thinca/vim-textobj-function-perl', {
    \ 'autoload' : {'filetypes' : 'perl'},
    \ 'depends' : [
    \   'kana/vim-textobj-function',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 't9md/vim-textobj-function-ruby', {
    \ 'autoload' : {'filetypes' : ['eruby', 'ruby']},
    \ 'depends' : [
    \   'kana/vim-textobj-function',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'anyakichi/vim-textobj-ifdef', {
    \ 'autoload' : {'filetypes' : ['c', 'cpp', 'cs', 'objc', 'objcpp']},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'glts/vim-textobj-indblock', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-indblock-a)',
    \      '<Plug>(textobj-indblock-i)',
    \      '<Plug>(textobj-indblock-same-a)',
    \      '<Plug>(textobj-indblock-same-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-indent', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-indent-a)',
    \      '<Plug>(textobj-indent-i)',
    \      '<Plug>(textobj-indent-same-a)',
    \      '<Plug>(textobj-indent-same-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-jabraces', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-jabraces-parens-a)',
    \      '<Plug>(textobj-jabraces-parens-i)',
    \      '<Plug>(textobj-jabraces-braces-a)',
    \      '<Plug>(textobj-jabraces-braces-i)',
    \      '<Plug>(textobj-jabraces-brackets-a)',
    \      '<Plug>(textobj-jabraces-brackets-i)',
    \      '<Plug>(textobj-jabraces-angles-a)',
    \      '<Plug>(textobj-jabraces-angles-i)',
    \      '<Plug>(textobj-jabraces-double-angles-a)',
    \      '<Plug>(textobj-jabraces-double-angles-i)',
    \      '<Plug>(textobj-jabraces-kakko-a)',
    \      '<Plug>(textobj-jabraces-kakko-i)',
    \      '<Plug>(textobj-jabraces-double-kakko-a)',
    \      '<Plug>(textobj-jabraces-double-kakko-i)',
    \      '<Plug>(textobj-jabraces-yama-kakko-a)',
    \      '<Plug>(textobj-jabraces-yama-kakko-i)',
    \      '<Plug>(textobj-jabraces-double-yama-kakko-a)',
    \      '<Plug>(textobj-jabraces-double-yama-kakko-i)',
    \      '<Plug>(textobj-jabraces-kikkou-kakko-a)',
    \      '<Plug>(textobj-jabraces-kikkou-kakko-i)',
    \      '<Plug>(textobj-jabraces-sumi-kakko-a)',
    \      '<Plug>(textobj-jabraces-sumi-kakko-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-line', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-line-a)',
    \      '<Plug>(textobj-line-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-multiblock-a)',
    \      '<Plug>(textobj-multiblock-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'osyo-manga/vim-textobj-multitextobj', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-multitextobj-a)',
    \      '<Plug>(textobj-multitextobj-A-a)',
    \      '<Plug>(textobj-multitextobj-B-a)',
    \      '<Plug>(textobj-multitextobj-C-a)',
    \      '<Plug>(textobj-multitextobj-D-a)',
    \      '<Plug>(textobj-multitextobj-E-a)',
    \      '<Plug>(textobj-multitextobj-i)',
    \      '<Plug>(textobj-multitextobj-A-i)',
    \      '<Plug>(textobj-multitextobj-B-i)',
    \      '<Plug>(textobj-multitextobj-C-i)',
    \      '<Plug>(textobj-multitextobj-D-i)',
    \      '<Plug>(textobj-multitextobj-E-i)']]},
    \ 'depends' : [
    \   'kana/vim-textobj-jabraces',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'hchbaw/textobj-motionmotion.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-motionmotion-a)',
    \      '<Plug>(textobj-motionmotion-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'sgur/vim-textobj-parameter', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-parameter-a)',
    \      '<Plug>(textobj-parameter-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'akiyan/vim-textobj-php', {
    \ 'autoload' : {'filetypes' : 'php'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'bps/vim-textobj-python', {
    \ 'autoload' : {'filetypes' : 'python'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'rhysd/vim-textobj-ruby', {
    \ 'autoload' : {'filetypes' : 'ruby'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'vimtaku/vim-textobj-sigil', {
    \ 'autoload' : {'filetypes' : 'perl'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'saihoooooooo/vim-textobj-space', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-space-a)',
    \      '<Plug>(textobj-space-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-syntax', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-syntax-a)',
    \      '<Plug>(textobj-syntax-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'mattn/vim-textobj-url', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo',
    \      '<Plug>(textobj-url-a)',
    \      '<Plug>(textobj-url-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-user', {
    \ 'autoload' : {'function_prefix' : 'textobj'}}

  NeoBundleLazy 'h1mesuke/textobj-wiw', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo',
    \      '<Plug>(textobj-wiw-n)',
    \      '<Plug>(textobj-wiw-p)',
    \      '<Plug>(textobj-wiw-N)',
    \      '<Plug>(textobj-wiw-P)'],
    \     ['vo',
    \      '<Plug>(textobj-wiw-a)',
    \      '<Plug>(textobj-wiw-i)']]}}

  NeoBundleLazy 'akiyan/vim-textobj-xml-attribute', {
    \ 'autoload' : {'filetypes' : ['html', 'xml']},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'zaiste/tmux.vim', {
    \ 'autoload' : {'filetypes' : 'tmux'}}

  NeoBundleLazy 'mbbill/undotree', {
    \ 'autoload' : {
    \   'commands' : 'UndotreeToggle',
    \   'functions' : 'UndotreeToggle',
    \   'insert' : 1}}

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
    \ 'autoload' : {'unite_sources' : 'build'}}

  NeoBundleLazy 'osyo-manga/unite-filetype', {
    \ 'autoload' : {'unite_sources' : 'filetype'}}

  NeoBundleLazy 'tsukkee/unite-help', {
    \ 'autoload' : {'unite_sources' : 'help'}}

  NeoBundleLazy 'thinca/vim-unite-history', {
    \ 'autoload' : {
    \   'unite_sources' : [
    \     'history/command', 'history/search']}}

  NeoBundleLazy 'KamunagiChiduru/unite-javaimport', {
    \ 'autoload' : {'unite_sources' : 'javaimport'}}

  NeoBundleLazy 'ujihisa/unite-locate', {
    \ 'autoload' : {'unite_sources' : 'locate'}}

  NeoBundleLazy 'tacroe/unite-mark', {
    \ 'autoload' : {'unite_sources' : 'mark'}}

  NeoBundleLazy 'Shougo/unite-outline', {
    \ 'autoload' : {'unite_sources' : 'outline'}}

  " NeoBundleLazy 'osyo-manga/unite-qfixhowm', {
  "   \ 'autoload' : {'unite_sources' : 'qfixhowm'},
  "   \ 'depends' : 'fuenor/qfixhowm'}

  NeoBundleLazy 'osyo-manga/unite-quickfix', {
    \ 'autoload' : {'unite_sources' : 'quickfix'}}

  NeoBundleLazy 'osyo-manga/unite-quickrun_config', {
    \ 'autoload' : {'unite_sources' : 'quickrun_config'},
    \ 'depends' : 'thinca/vim-quickrun'}

  if has('clientserver')
    NeoBundleLazy 'mattn/unite-remotefile', {
      \ 'autoload' : {'unite_sources' : 'remotefile'}}
  endif

  NeoBundleLazy 'rhysd/unite-ruby-require.vim', {
    \ 'autoload' : {'unite_sources' : 'ruby/require'}}

  NeoBundleLazy 'Shougo/unite-ssh', {
    \ 'autoload' : {'unite_sources' : 'ssh'},
    \ 'depends' : 'Shougo/vimfiler.vim'}

  NeoBundleLazy 'Shougo/unite-sudo', {
    \ 'autoload' : {'unite_sources' : 'sudo'},
    \ 'depends' : 'Shougo/vimfiler.vim'}

  NeoBundleLazy 'tsukkee/unite-tag', {
    \ 'autoload' : {'unite_sources' : 'tag'}}

  NeoBundleLazy 'pasela/unite-webcolorname', {
    \ 'autoload' : {'unite_sources' : 'webcolorname'}}

  NeoBundleLazy 'vbnet.vim', {
    \ 'autoload' : {'filetypes' : 'vbnet'}}

  NeoBundleLazy 'rbtnn/vbnet_indent.vim', {
    \ 'autoload' : {'filetypes' : 'vbnet'}}

  if has('iconv')
    NeoBundleLazy 'koron/verifyenc-vim'
  endif

  NeoBundleLazy 'Shougo/vim-vcs', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Vcs',
    \      'complete' : 'customlist,vcs#complete'}]},
    \ 'depends' : 'thinca/vim-openbuf'}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Vcs' : 'vcs#complete'})

  NeoBundleLazy 'rbtnn/vimconsole.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     'VimConsole', 'VimConsoleOpen', 'VimConsoleToggle',
    \     'VimConsoleLog', 'VimConsoleWarn', 'VimConsoleError']},
    \ 'depends' : 'thinca/vim-prettyprint'}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'VimConsoleLog'   : 'expression',
    \ 'VimConsoleWarn'  : 'expression',
    \ 'VimConsoleError' : 'expression'})

  if has('multi_lang')
    NeoBundleLazy 'vim-jp/vimdoc-ja', {
      \ 'autoload' : {'filetypes' : 'help'}}
  endif

  NeoBundleLazy 'Shougo/vimfiler.vim', {
    \ 'autoload' : {
    \   'commands' : [
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

  NeoBundleLazy 'syngan/vim-vimlint', {
    \ 'depends' : 'ynkdir/vim-vimlparser'}

  NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \   'windows' :
    \     $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' .
    \     'nmake -f Make_msvc.mak nodebug=1',
    \   'others'  : 'make'}}

  NeoBundleLazy 'Shougo/vimshell.vim', {
    \ 'autoload' : {
    \   'filetypes' : 'vimshrc',
    \   'commands' : [
    \     {'name' : 'VimShell',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellCreate',
    \      'complete' : 'customlist,vimshell#complete'},
    \     {'name' : 'VimShellTab',
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
    \   'unite_sources' : [
    \     'vimshell/external_history', 'vimshell/history']},
    \ 'depends' : 'ujihisa/vimshell-ssh'}
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
    \   'mappings' : [
    \     ['nvo',
    \       '<Plug>(visualstar-*)', '<Plug>(visualstar-g*)',
    \       '<Plug>(visualstar-#)', '<Plug>(visualstar-g#)']]}}

  NeoBundle 'vim-jp/vital.vim'

  NeoBundleLazy 'osyo-manga/vim-watchdogs', {
    \ 'autoload' : {
    \   'commands' : [
    \     'WatchdogsRun', 'WatchdogsRunSilent', 'WatchdogsRunSweep']},
    \ 'depends' : [
    \   'thinca/vim-quickrun',
    \   'osyo-manga/quickrun-hook-vcvarsall',
    \   'osyo-manga/shabadou.vim',
    \   'syngan/vim-vimlint']}

  NeoBundleLazy 'mattn/zencoding-vim', {
    \ 'autoload' : {
    \   'filetypes' : [
    \     'css', 'css.drupal', 'haml', 'html', 'html.django_template',
    \     'htmldjango', 'less', 'mustache', 'sass', 'scss', 'slim',
    \     'xhtml', 'xml', 'xsl', 'xslt'],
    \   'commands' : 'Zen',
    \   'mappings' : [['nvi', '<C-Y>']]}}
endif
"}}}

"-----------------------------------------------------------------------------
" Mapping Some Mode: {{{
command! -complete=mapping -nargs=*
  \ NVmap
  \ nmap <args>| vmap <args>
command! -complete=mapping -nargs=*
  \ NOmap
  \ nmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ NXmap
  \ nmap <args>| xmap <args>
command! -complete=mapping -nargs=*
  \ NSmap
  \ nmap <args>| smap <args>
command! -complete=mapping -nargs=*
  \ VOmap
  \ vmap <args>| omap <args>
command! -complete=mapping -nargs=*
  \ OXmap
  \ omap <args>| xmap <args>
command! -complete=mapping -nargs=*
  \ OSmap
  \ omap <args>| smap <args>
command! -complete=mapping -nargs=*
  \ NOXmap
  \ nmap <args>| omap <args>| xmap <args>
command! -complete=mapping -nargs=*
  \ NOSmap
  \ nmap <args>| omap <args>| smap <args>

command! -complete=mapping -nargs=*
  \ NVnoremap
  \ nnoremap <args>| vnoremap <args>
command! -complete=mapping -nargs=*
  \ NOnoremap
  \ nnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ NXnoremap
  \ nnoremap <args>| xnoremap <args>
command! -complete=mapping -nargs=*
  \ NSnoremap
  \ nnoremap <args>| snoremap <args>
command! -complete=mapping -nargs=*
  \ VOnoremap
  \ vnoremap <args>| onoremap <args>
command! -complete=mapping -nargs=*
  \ OXnoremap
  \ onoremap <args>| xnoremap <args>
command! -complete=mapping -nargs=*
  \ OSnoremap
  \ onoremap <args>| snoremap <args>
command! -complete=mapping -nargs=*
  \ NOXnoremap
  \ nnoremap <args>| onoremap <args>| xnoremap <args>
command! -complete=mapping -nargs=*
  \ NOSnoremap
  \ nnoremap <args>| onoremap <args>| snoremap <args>
"}}}
"}}}

"=============================================================================
" General Settings: {{{

"-----------------------------------------------------------------------------
" System: {{{
" GUI options
if has('gui_running')
  set guioptions+=M
endif

" Message
set shortmess+=a
set title

" Use beep
set errorbells
set novisualbell
set t_vb=

" VimInfo
if s:is_android
  set viminfo+=n/data/data/net.momodalo.app.vimtouch/files/vim/.viminfo
else
  set viminfo+=n~/.local/.viminfo
endif
set history=100

" Backup
set backup
set nowritebackup
set backupdir^=~/.bak
set backupskip+=*.clean,*/.hg/*,*/.git/*,*/.svn/*
set patchmode=.clean
set suffixes+=.clean

" Swap
set swapfile
if has('win32')
  set directory^=$TEMP,~/.bak
else
  set directory^=$TMPDIR,~/.bak
endif

" Undo persistence
set undofile
set undodir^=~/.bak
autocmd MyVimrc BufNewFile,BufRead *
  \ if expand('%:p') =~? '\.clean$\|/\.hg/\|/\.git/\|/\.svn/' |
  \   setlocal noundofile |
  \ endif

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
set wildignore+=*.clean,.drive.r,.hg,.git,.svn

" Mouse
set mouse=a
set nomousefocus
set nomousehide
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Search: {{{
" Options
set ignorecase
set smartcase
set incsearch
set wrapscan
set magic

" Highlight
if &t_Co > 2
  set hlsearch
endif

" Keyword
set iskeyword=a-z,A-Z,@,48-57,_

" Grep
if s:executable('jvgrep')
  set grepprg=jvgrep\ -n\ --exclude\ .drive.r
elseif s:executable('grep')
  set grepprg=grep\ -Hn
else
  set grepprg=internal
endif
autocmd MyVimrc QuickFixCmdPost make,grep,vimgrep,helpgrep
  \ cwindow
"}}}

"-----------------------------------------------------------------------------
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
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
augroup MyVimrc
  autocmd CmdwinEnter *
    \ let s:save_bs = &backspace |
    \ set backspace=start
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

" Indent By FileType
let g:vim_indent_cont = 2

" Folding
set foldenable
set foldmethod=marker
set foldcolumn=2
set foldlevelstart=99
autocmd MyVimrc CmdwinEnter *
  \ setlocal nofoldenable foldcolumn=0

" Folding By FileType
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

"-----------------------------------------------------------------------------
" Status Line: {{{
set statusline=%<%f\ %m%r[
if has('multi_byte')
  set statusline+=%{(&fenc!=''?&fenc:&enc).':'}
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

"-----------------------------------------------------------------------------
" File Encodings: {{{
if has('multi_byte')
  let s:enc_jisx0213 = has('iconv') &&
    \ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"

  let &fileencodings =
    \ (s:enc_jisx0213 ? 'iso-2022-jp-3,' : 'iso-2022-jp,') .
    \ 'cp932,' .
    \ (s:enc_jisx0213 ? 'euc-jisx0213,euc-jp,' : 'euc-jp,') .
    \ 'ucs-bom'
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

"-----------------------------------------------------------------------------
" Plugins: {{{
" Assembler
let g:asmsyntax = 'masm'
" let g:asmsyntax = 'arm'
" let g:asmsyntax = 'z80'

" Shell Script
let g:is_bash = 1

" Runtimepath by bundle
if exists(':NeoBundle')
  function! s:load_bundle_settings()
    for d in split(glob('~/.vim/bundle-settings/*'), '\n')
      if neobundle#get(fnamemodify(d, ':t')) != {}
        execute 'set runtimepath+=' . d
      endif
    endfor
  endfunction
  call s:load_bundle_settings()
endif

" Enable plugin
filetype plugin indent on
"}}}

"-----------------------------------------------------------------------------
" Colors: {{{
" Cursor line & column
if has('gui_running') || &t_Co > 255
  set cursorline
  set cursorcolumn

  " No cursor line & column at other window
  augroup MyVimrc
    autocmd BufWinEnter,WinEnter *
      \ if exists('b:nocursorline') && b:nocursorline |
      \   setlocal nocursorline |
      \ else |
      \   setlocal cursorline |
      \ endif |
      \ if exists('b:nocursorcolumn') && b:nocursorcolumn |
      \   setlocal nocursorcolumn |
      \ else |
      \   setlocal cursorcolumn |
      \ endif
    autocmd BufWinLeave,WinLeave *
      \ setlocal nocursorline nocursorcolumn
    autocmd CmdwinEnter *
      \ setlocal nocursorcolumn
  augroup END
endif

" Syntax highlight
syntax on

" Colorscheme
if &t_Co > 255
  silent! colorscheme molokai
endif
"}}}
"}}}

"=============================================================================
" Mappings: {{{

"-----------------------------------------------------------------------------
" Prefix: {{{
" <Leader> <LocalLeader>
NOXnoremap <Leader>      <Nop>
NOXnoremap <LocalLeader> <Nop>

" Useless
NOXnoremap ;     <Nop>
NOXnoremap ,     <Nop>
NOXnoremap s     <Nop>
NOXnoremap S     <Nop>
NOXnoremap m     <Nop>
NOXnoremap M     <Nop>
NOnoremap  <C-G> <Nop>
cnoremap   <C-G> <Nop>
"}}}

"-----------------------------------------------------------------------------
" Moving: {{{
" Jump
NOXnoremap ' `
NOXnoremap ` '
NOXnoremap gH H
NOXnoremap gM M
NOXnoremap gL L
NOXnoremap <Space> %

" Window Control
NXnoremap <M-j>  <C-W>j
NXnoremap <M-k>  <C-W>k
NXnoremap <M-h>  <C-W>h
NXnoremap <M-l>  <C-W>l
NXnoremap <M-J>  <C-W>J
NXnoremap <M-K>  <C-W>K
NXnoremap <M-H>  <C-W>H
NXnoremap <M-L>  <C-W>L
NXnoremap <M-+>  <C-W>+
NXnoremap <M-->  <C-W>-
NXnoremap <M-<>  <C-W><
NXnoremap <M->>  <C-W>>
NXnoremap <M-=>  <C-W>=
NXnoremap <C-W>Q :<C-U>confirm qall<CR>

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

" Command-line-mode
cnoremap <M-H> <Home>
cnoremap <M-L> <End>
cnoremap <M-w> <S-Right>
cnoremap <M-b> <S-Left>

" Mark
NOXnoremap mj ]`
NOXnoremap mk [`
"}}}

"-----------------------------------------------------------------------------
" Useful: {{{
" Split Nicely
function! s:split_nicely_expr()
  return &columns < 160
endfunction
noremap <expr> <SID>(split-nicely)
  \ <SID>split_nicely_expr() ?
  \   '<C-W>s' :
  \   '<C-W>v'

" Semi-colon shortcut
nnoremap ;w     :<C-U>confirm update<CR>
nnoremap ;W     :<C-U>confirm wall<CR>
nnoremap ;c     :<C-U>confirm bdelete<CR>
nnoremap ;C     :<C-U>confirm 1,$bdelete<CR>
nnoremap ;j     :<C-U>jumps<CR>
nnoremap ;J     :<C-U>changes<CR>
nnoremap ;<C-D> :<C-U>pwd<CR>
nnoremap ;e     :<C-U>edit<Space>
nnoremap ;b     :<C-U>buffer<Space>
nnoremap ;t     :<C-U>tabm<Space>
nnoremap ;g     :<C-U>grep<Space>
nnoremap ;<M-d> :<C-U>lcd<Space>
nnoremap ;<M-D> :<C-U>cd<Space>

" Paste
NXnoremap <C-P> :<C-U>registers<CR>
inoremap  <C-P> <C-O>:<C-U>registers<CR>
noremap!  <M-p> <C-R>"

" BackSpace
nnoremap <BS> X

" Yank at end of line
nnoremap Y y$

" Undo branch
nnoremap <M-u>     g-
nnoremap <M-r>     g+
nnoremap <Leader>u :<C-U>undolist<CR>

" New line
nnoremap <M-o> o<Esc>0"_Dk
nnoremap <M-O> O<Esc>0"_Dj

" Auto recenter
nnoremap  <Tab> <Tab>zz
nnoremap  <C-O> <C-O>zz
NXnoremap *     *zz
NXnoremap #     #zz
NXnoremap g*    g*zz
NXnoremap g#    g#zz

" Back jump
nnoremap <S-Tab> <C-O>

" Paste toggle
set pastetoggle=<F11>
nnoremap <expr> <F11>
  \ &paste ?
  \   ':<C-U>set nopaste<CR>' :
  \   ':<C-U>set paste<CR>'

" Start Visual-mode with the same area
onoremap gv :<C-U>normal! gv<CR>

" Start Visual-mode with the last changed area
nnoremap  g[ `[v`]
OXnoremap g[ :<C-U>normal g[<CR>

" Delete at Insert-mode
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>

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
  \   '<C-O>:<C-U>help<Space>' :
  \   '<C-O>:<C-U>vertical help<Space>'
nnoremap <expr> <F1>
  \ <SID>split_nicely_expr() ?
  \   ':<C-U>help<Space>' :
  \   ':<C-U>vertical help<Space>'
nnoremap <expr> g<F1>
  \ <SID>split_nicely_expr() ?
  \   ':<C-U>help ' . expand('<cword>') . '<CR>' :
  \   ':<C-U>vertical help ' . expand('<cword>') . '<CR>'

" Search
NXmap g/ *
NXmap g? #
nnoremap <C-N> :<C-U>global//print<CR>
xnoremap <C-N> :global//print<CR>
nnoremap <Esc><Esc> :<C-U>nohlsearch<CR><Esc>

" Search Split Window
NXnoremap <script> <C-W>/  <SID>(split-nicely)<SID>/
NXnoremap <script> <C-W>?  <SID>(split-nicely)<SID>?
NXnoremap <script> <C-W>*  <SID>(split-nicely)*zz
NXnoremap <script> <C-W>#  <SID>(split-nicely)#zz
NXnoremap <script> <C-W>g* <SID>(split-nicely)*zz
NXnoremap <script> <C-W>g# <SID>(split-nicely)#zz

NXmap <C-W>g/ <C-W>*
NXmap <C-W>g? <C-W>#

" QuickFix
nnoremap <C-W>, :<C-U>copen<CR>
nnoremap <C-W>. :<C-U>cclose<CR>
"}}}

"-----------------------------------------------------------------------------
" Subrogation: {{{
" Mark
nnoremap <M-m> m

" Repeat find
NOXnoremap <M-;> ;
NOXnoremap <M-,> ,

" To Column
NOXnoremap g\| \|

" Rot13
NXnoremap g13    g?
nnoremap  g13g13 g?g?
nnoremap  g1313  g??
nnoremap  g133   g??

" FileInfo
nnoremap <C-G><C-G> <C-G>

" To Select-mode
nnoremap <C-G>h     gh
nnoremap <C-G>H     gH
nnoremap <C-G><C-H> g<C-H>

" Repeat command
nnoremap Q  @
nnoremap Q; @:
nnoremap QQ @@

" Dangerous key
nnoremap ZQ    <Nop>
nnoremap ZZ    <Nop>
nnoremap gQ    gq
inoremap <C-C> <Esc>

" Insert Tab
inoremap <C-T> <C-V><Tab>
"}}}
"}}}

"=============================================================================
" Commands: {{{

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Shell Setting: {{{
if has('win32')
  function! s:get_shell()
    return {
      \ 'shell'        : &shell,
      \ 'shellslash'   : &shellslash,
      \ 'shellcmdflag' : &shellcmdflag,
      \ 'shellquote'   : &shellquote,
      \ 'shellxquote'  : &shellxquote}
  endfunction
  function! s:set_shell(value)
    let &shell        = a:value.shell
    let &shellslash   = a:value.shellslash
    let &shellcmdflag = a:value.shellcmdflag
    let &shellquote   = a:value.shellquote
    let &shellxquote  = a:value.shellxquote
  endfunction

  command! -bar
    \ ShellCmd
    \ call s:set_shell({
    \   'shell'        : 'cmd',
    \   'shellslash'   : 0,
    \   'shellcmdflag' : '/c',
    \   'shellquote'   : '',
    \   'shellxquote'  : '('})

  command! -bar -nargs=?
    \ ShellSh
    \ call s:set_shell({
    \   'shell'        : len(<q-args>) ? <q-args> : 'sh',
    \   'shellslash'   : 1,
    \   'shellcmdflag' : '-c',
    \   'shellquote'   : '',
    \   'shellxquote'  : '"'})
endif
"}}}

"-----------------------------------------------------------------------------
" VC Vars: {{{
if exists('$VCVARSALL')
  function! s:vcvarsall(arch)
    let save_shell = s:get_shell()
    let save_isi   = &isident
    ShellCmd
    set isident+=( isident+=)
    try
      let env = system($VCVARSALL . ' ' . a:arch . ' & set')
      for s in split(env, '\n')
        let e = matchlist(s, '\([^=]\+\)=\(.*\)')
        if len(e) > 2
          execute 'let $' . e[1] . '=''' . e[2] . ''''
        endif
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
      \ call s:vcvarsall(
      \   exists('PROCESSOR_ARCHITEW6432') ?
      \     $PROCESSOR_ARCHITEW6432 :
      \     $PROCESSOR_ARCHITECTURE)
  endif
endif
"}}}

"-----------------------------------------------------------------------------
" From CmdEx: {{{
command! -bar
  \ CdCurrent
  \ cd %:p:h
command! -bar
  \ LcdCurrent
  \ lcd %:p:h
command! -bar -nargs=1 -complete=file
  \ Diff
  \ vertical diffsplit <args>
command! -bar
  \ Undiff
  \ setlocal nodiff scrollbind< wrap< cursorbind<

nnoremap ;D :<C-U>CdCurrent<CR>
nnoremap ;d :<C-U>LcdCurrent<CR>
nnoremap <F8> :<C-U>Undiff<CR>
"}}}

"-----------------------------------------------------------------------------
" From Example: {{{
command! -bar
  \ DiffOrig
  \ vertical new | setlocal buftype=nofile |
  \ read # | 0d_ | diffthis | wincmd p | diffthis

nnoremap <F6> :<C-U>DiffOrig<CR>
"}}}
"}}}

"=============================================================================
" Vim Script: {{{

"-----------------------------------------------------------------------------
" Command Line Window: {{{
function! s:cmdwin_enter()
  startinsert!
  nnoremap <buffer><silent> q :<C-U>quit<CR>

  inoremap <buffer><silent><script><expr> <C-H>
    \ col('.') == 1 ?
    \   '<Esc>:quit<CR>' :
    \   '<SID>(smartinput-<C-H>)'
  inoremap <buffer><silent><script><expr> <BS>
    \ col('.') == 1 ?
    \   '<Esc>:quit<CR>' :
    \   '<SID>(smartinput-<BS>)'
endfunction
autocmd MyVimrc CmdwinEnter *
  \ call s:cmdwin_enter()

function! s:cmdline_enter(type)
  execute 'doautocmd'
    \ (s:has_patch(703, 438) ? '<nomodeline>' : '')
    \ 'User CmdlineEnter'
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

"-----------------------------------------------------------------------------
" Auto Mark: {{{
let s:mark_char = [
  \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

function! s:_get_mark_pos()
  let pos = get(b:, 'mark_pos', -1)
  let pos = (pos + 1) % len(s:mark_char)
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
  return
    \ (":\<C-U>mark " .
    \  s:mark_char[b:mark_pos] .
    \  "\<CR>")
endfunction
function! s:clear_marks()
  let b:mark_pos = -1
  return
    \ (":\<C-U>delmarks " .
    \  join(s:mark_char, '') .
    \  "\<CR>")
endfunction

function! s:_get_file_mark_pos()
  let pos = get(s:, 'file_mark_pos', -1)
  let pos = (pos + 1) % len(s:mark_char)
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
  return
    \ (":\<C-U>mark " .
    \  toupper(s:mark_char[s:file_mark_pos]) .
    \  "\<CR>")
endfunction
function! s:clear_file_marks()
  let s:file_mark_pos = -1
  return
    \ (":\<C-U>rviminfo | delmarks " .
    \  toupper(join(s:mark_char, '')) .
    \  " | wviminfo!\<CR>")
endfunction

function! s:marks()
  let char = join(s:mark_char, '')
  return
    \ (":\<C-U>marks " .
    \ char . toupper(char) .
    \ "\<CR>")
endfunction

nnoremap <expr> mm <SID>auto_mark()
nnoremap <expr> mc <SID>clear_marks()
nnoremap <expr> mM <SID>auto_file_mark()
nnoremap <expr> mC <SID>clear_file_marks()
nnoremap <expr> ml <SID>marks()
"}}}

"-----------------------------------------------------------------------------
" Smart BOL: {{{
function! s:smart_bol()
  let col = col('.')
  return
    \ col <= 1 || col > match(getline('.'), '^\s*\zs') + 1 ?
    \   '^' :
    \   '0'
endfunction
function! s:smart_eol()
  return
    \ col('.') < col('$') - (mode() !~# "[vV\<C-V>sS\<C-S>]" ? 1 : 0) ?
    \   '$' :
    \   'g_'
endfunction

NOXnoremap <silent><expr> H <SID>smart_bol()
NOXnoremap <silent><expr> L <SID>smart_eol()
inoremap <silent><expr> <M-H> '<C-O>' . <SID>smart_bol()
inoremap <silent><expr> <M-L> '<C-O>' . <SID>smart_eol()
"}}}

"-----------------------------------------------------------------------------
" Make Searching Directions Consistent: {{{
function! s:search_forward_expr()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction

NXnoremap <expr> n <SID>search_forward_expr() ? 'nzvzz' : 'Nzvzz'
NXnoremap <expr> N <SID>search_forward_expr() ? 'Nzvzz' : 'nzvzz'
onoremap  <expr> n <SID>search_forward_expr() ? 'n' : 'N'
onoremap  <expr> N <SID>search_forward_expr() ? 'N' : 'n'
"}}}

"-----------------------------------------------------------------------------
" Line Number: {{{
function! s:toggle_line_number_style()
  set relativenumber!
  if !&number && !&relativenumber
    set number
  endif
endfunction

nnoremap <F12> :<C-U>call <SID>toggle_line_number_style()<CR>
"}}}

"-----------------------------------------------------------------------------
" Insert One Character: {{{
function! s:insert_one_character()
  echohl ModeMsg
  if v:lang =~? '^ja' && has('multi_lang')
    echo '-- 挿入 (1文字) --'
  else
    echo '-- INSERT (one char) --'
  endif
  echohl None
  return nr2char(getchar()) . "\<Esc>"
endfunction
nnoremap <M-a> a<C-R>=<SID>insert_one_character()<CR>
nnoremap <M-A> A<C-R>=<SID>insert_one_character()<CR>
nnoremap <M-i> i<C-R>=<SID>insert_one_character()<CR>
nnoremap <M-I> I<C-R>=<SID>insert_one_character()<CR>
"}}}

"-----------------------------------------------------------------------------
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
    call mkdir(
      \ has('iconv') ?
      \   iconv(a:dir, &encoding, &termencoding) :
      \   a:dir, 'p')
  endif
endfunction
autocmd MyVimrc BufWritePre *
  \ call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
"}}}

"-----------------------------------------------------------------------------
" Windows Symlink Fix: {{{
if has('win32') && !s:has_patch(703, 1182)
  set backupcopy=yes
  augroup MyVimrc
    autocmd BufWritePre,FileWritePre,FileAppendPre *
      \ if filewritable(expand('%')) |
      \   let b:save_ar = &l:autoread |
      \ endif
    autocmd BufWritePost,FileWritePost,FileAppendPost *
      \ if exists('b:save_ar') |
      \   setlocal autoread |
      \   if s:has_vimproc() |
      \     call vimproc#cmd#system('attrib -R ' . expand('%:p')) |
      \   else |
      \     call system('attrib -R ' . expand('%:p')) |
      \   endif |
      \ endif
    autocmd BufReadPost *
      \ if exists('b:save_ar') |
      \   let &l:autoread = b:save_ar |
      \   unlet b:save_ar |
      \ endif
  augroup END
endif
"}}}

"-----------------------------------------------------------------------------
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
    return substitute(s,
      \ '\%(\%(re\|in\)verse,\?\|,\%(re\|in\)verse\)', '', 'g')
  elseif s != '' && s != 'NONE'
    return s . ',reverse'
  else
    return 'reverse'
  endif
endfunction

function! s:reverse_highlight(hl)
  return
    \ a:hl .
    \ ' term='  . s:_reverse_highlight(a:hl, 'term') .
    \ ' cterm=' . s:_reverse_highlight(a:hl, 'cterm') .
    \ ' gui='   . s:_reverse_highlight(a:hl, 'gui')
endfunction
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" From Example: {{{
autocmd MyVimrc BufRead *
  \ if line("'\"") > 1 && line("'\"") <= line('$') &&
  \   expand('%:p') !~? '\.clean$\|/\.hg/\|/\.git/\|/\.svn/' |
  \   execute 'normal! g`"' |
  \ endif
"}}}
"}}}

"=============================================================================
" Plugins: {{{

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Altr: {{{
silent! let s:bundle = neobundle#get('altr')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nmap <F2>  <Plug>(altr-forward)
  nmap g<F2> <Plug>(altr-back)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" AutoDate: {{{
silent! let s:bundle = neobundle#get('autodate')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:autodate_lines        = 10
    let g:autodate_format       = '%Y-%m-%d %H:%M:%S DeaR'
    let g:autodate_keyword_post = '[>"]'
    let g:autodate_keyword_pre  =
      \ '\c@\?time[-[:space:]]*stamp\s*:\?\s\+[<"]'
  endfunction

  autocmd MyVimrc BufNewFile,BufRead *
    \ NeoBundleSource autodate
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" AutoFmt: {{{
silent! let s:bundle = neobundle#get('autofmt')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  set formatexpr=autofmt#japanese#formatexpr()
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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
    if exists('g:clang_library_path') && len(g:clang_library_path)
      let g:clang_use_library = 1
    endif
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
    function s:clang_complete_init_2(ext)
      silent! iunmap <buffer> <C-X><C-U>
      silent! iunmap <buffer> .
      silent! iunmap <buffer> >
      silent! iunmap <buffer> :

      if neobundle#get('smartchr') != {}
        " from ~/.vim/bundle-settings/vim-smartchr/*.vim
        inoremap <buffer><expr> >
          \ search('\V ->\? \%#', 'bcn') ?
          \   smartchr#one_of(' - ', '->', ' -> ') :
          \   search('\V-\%#', 'bcn') ?
          \     smartchr#one_of('-', '->', ' -> ') :
          \     smartchr#one_of(' > ', ' >> ', '>')
        if a:ext =~? 'cpp$'
          inoremap <buffer><expr> : smartchr#one_of(' : ', '::', ':')
        else
          inoremap <buffer><expr> : smartchr#one_of(' : ', ':')
        endif
      endif
    endfunction

    autocmd MyVimrc FileType c,cpp,objc,objcpp
      \ call s:clang_complete_init_2('<amatch>')
    execute 'doautocmd'
      \ (s:has_patch(703, 438) ? '<nomodeline>' : '')
      \ 'MyVimrc FileType' &filetype
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'c'      : '[^.[:digit:] *\t]\%(\.\|->\)',
    \ 'objc'   : '[^.[:digit:] *\t]\%(\.\|->\)',
    \ 'cpp'    : '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
    \ 'objcpp' : '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Clever F: {{{
silent! let s:bundle = neobundle#get('clever-f')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:clever_f_not_overwrites_standard_mappings = 1
  endfunction

  NOXmap f     <Plug>(clever-f-f)
  NOXmap F     <Plug>(clever-f-F)
  NOXmap t     <Plug>(clever-f-t)
  NOXmap T     <Plug>(clever-f-T)
  NOXmap <M-.> <Plug>(clever-f-reset)
  NOXmap <M-;> <Plug>(clever-f-repeat-forward)
  NOXmap <M-,> <Plug>(clever-f-repeat-back)

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
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ColumnJump: {{{
silent! let s:bundle = neobundle#get('columnjump')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nmap <SID>(columnjump-backward) <Plug>(columnjump-backward)
  nmap <SID>(columnjump-forward)  <Plug>(columnjump-forward)

  nnoremap <script> <C-K> <SID>(columnjump-backward)zz
  nnoremap <script> <C-J> <SID>(columnjump-forward)zz

  inoremap <script> <M-K> <C-O><SID>(columnjump-backward)
  inoremap <script> <M-J> <C-O><SID>(columnjump-forward)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Fugitive: {{{
silent! let s:bundle = neobundle#get('fugitive')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_post_source(bundle)
    call fugitive#detect(expand('%') == '' ? getcwd() : expand('%:p'))
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Grex: {{{
silent! let s:bundle = neobundle#get('grex')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap sd <Plug>(operator-grex-delete)
  NOXmap sy <Plug>(operator-grex-yank)

  nmap sdd sdsd
  nmap syy sysy
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Hier: {{{
silent! let s:bundle = neobundle#get('hier')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap <Esc><Esc> :<C-U>nohlsearch \| HierClear<CR><Esc>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" HybridText: {{{
silent! let s:bundle = neobundle#get('HybridText')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  autocmd MyVimrc FileType text
    \ setlocal syntax=hybrid
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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
      \ if get(b:, 'indentLine_enabled', 1) && !&expandtab |
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

"-----------------------------------------------------------------------------
" Jedi: {{{
silent! let s:bundle = neobundle#get('jedi')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:jedi#auto_initialization    = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot           = 0
    let g:jedi#auto_close_doc         = 0
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'python' : '[^.[:digit:] *\t]\.'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" JsComplete: {{{
silent! let s:bundle = neobundle#get('jscomplete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:jscomplete_use = ['dom', 'moz', 'xpcom', 'es6th']
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'javascript' : '[^.[:digit:] *\t]\.'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Kwbdi: {{{
silent! let s:bundle = neobundle#get('kwbdi')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:kwbd()
    if &modified
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

    NeoBundleSource kwbdi
    silent execute "normal \<Plug>Kwbd"
  endfunction
  nnoremap ;c :<C-U>call <SID>kwbd()<CR>
  map <SID>Kwbd <Plug>Kwbd
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Lua FtPlugin: {{{
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

  call extend(s:neocompl_force_omni_patterns, {
    \ 'lua' : '[^.[:digit:] *\t]\.\|\h\w*:'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" MapList: {{{
silent! let s:bundle = neobundle#get('maplist')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:maplist_mode_length  = 4
    let g:maplist_key_length   = 50
    let g:maplist_local_length = 2
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Narrow: {{{
silent! let s:bundle = neobundle#get('narrow')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  xnoremap <Leader>n :Narrow<CR>
  nnoremap <Leader>w :Widen<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" NeoBundle: {{{
silent! let s:bundle = neobundle#get('neobundle')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:neobundle_git_gc(names)
    let names   = split(a:names)
    let bundles =
      \ empty(names) ?
      \   neobundle#config#get_neobundles() :
      \   neobundle#config#search(names)

    let cwd = getcwd()
    let System = function(
      \ s:has_vimproc() ?
      \   has('win32') ?
      \     'vimproc#cmd#system' :
      \     'vimproc#system' :
      \   'system')
    try
      for bundle in bundles
        if bundle.type != 'git'
          continue
        endif
        if isdirectory(bundle.path)
          lcd `=bundle.path`
        endif
        call call(System, ['git gc'])
      endfor
    finally
      if isdirectory(cwd)
        lcd `=cwd`
      endif
    endtry
  endfunction
  command! -bar -complete=customlist,neobundle#complete_bundles -nargs=?
    \ NeoBundleGitGc
    \ :call s:neobundle_git_gc(<q-args>)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" NeoComplCache: {{{
silent! let s:bundle = neobundle#get('neocomplcache')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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

    call neocomplcache#custom_source(
      \ 'syntax_complete', 'rank',  9)
    call neocomplcache#custom_source(
      \ 'snippets_complete', 'rank', 80)

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
      \ neocomplcache#smart_close_popup() . '<SID>(smartinput-<CR>)'
    inoremap <script><expr> <C-H>
      \ neocomplcache#smart_close_popup() . '<SID>(smartinput-<C-H>)'
    inoremap <script><expr> <BS>
      \ neocomplcache#smart_close_popup() . '<SID>(smartinput-<BS>)'

    call neocomplcache#initialize()
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
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<SID>(smartinput-<C-H>)')
    inoremap <buffer><script><silent><expr> <BS>
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   (neocomplcache#smart_close_popup() . '<SID>(smartinput-<BS>)')
  endfunction
  augroup MyVimrc
    autocmd CmdwinEnter *
      \ call s:cmdwin_enter_neocomplcache()
    autocmd CmdwinEnter :
      \ let b:neocomplcache_sources_list = ['vim_complete']
  augroup END

  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  call extend(s:neocompl_dictionary_filetype_lists, {
    \ '_' : ''})
  call extend(s:neocompl_keyword_patterns, {
    \ '_' : '[a-zA-Z@0-9_]\+'})

  autocmd MyVimrc CursorHold *
    \ NeoBundleSource neocomplcache
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" NeoComplete: {{{
silent! let s:bundle = neobundle#get('neocomplete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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

    call neocomplete#custom#source(
      \ '_', 'matchers', ['matcher_head'])
    call neocomplete#custom#source(
      \ 'syntax_complete', 'rank',  9)
    call neocomplete#custom#source(
      \ 'snippets_complete', 'rank', 80)

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
      \ neocomplete#smart_close_popup() . '<SID>(smartinput-<CR>)'
    inoremap <script><expr> <C-H>
      \ neocomplete#smart_close_popup() . '<SID>(smartinput-<C-H>)'
    inoremap <script><expr> <BS>
      \ neocomplete#smart_close_popup() . '<SID>(smartinput-<BS>)'

    call neocomplete#initialize()
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
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<SID>(smartinput-<C-H>)')
    inoremap <buffer><silent><script><expr> <BS>
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   (neocomplete#smart_close_popup() . '<SID>(smartinput-<BS>)')
  endfunction
  augroup MyVimrc
    autocmd CmdwinEnter *
      \ call s:cmdwin_enter_neocomplete()
    autocmd CmdwinEnter :
      \ let b:neocomplete_sources = ['vim']
  augroup END

  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction

  call extend(s:neocompl_dictionary_filetype_lists, {
    \ '_' : ''})
  call extend(s:neocompl_keyword_patterns, {
    \ '_' : '[a-zA-Z@0-9_]\+'})

  autocmd MyVimrc CursorHold *
    \ NeoBundleSource neocomplete
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" NeoSnippet: {{{
silent! let s:bundle = neobundle#get('neosnippet')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:neosnippet#snippets_directory           = $HOME . '/.vim/snippets'
    let g:neosnippet#disable_select_mode_mappings = 0

    let g:neosnippet#disable_runtime_snippets =
      \ get(g:, 'neosnippet#disable_runtime_snippets', {})
    let g:neosnippet#disable_runtime_snippets._ = 1

    imap <C-J> <Plug>(neosnippet_expand_or_jump)
  endfunction

  smap <C-J> <Plug>(neosnippet_expand_or_jump)
  xmap <C-J> <Plug>(neosnippet_expand_target)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" OmniSharp: {{{
silent! let s:bundle = neobundle#get('Omnisharp')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:OmniSharp_typeLookupInPreview    = 0
    let g:OmniSharp_timeout                = 5
    let g:OmniSharp_BufWritePreSyntaxCheck = 1
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'cs' : '[^.[:digit:] *\t]\.'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Open Browser: {{{
silent! let s:bundle = neobundle#get('open-browser')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nmap gxgx <Plug>(openbrowser-smart-search)
  nmap gxx gxgx
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Camelize: {{{
silent! let s:bundle = neobundle#get('operator-camelize')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap sU <Plug>(operator-camelize)
  NOXmap su <Plug>(operator-decamelize)
  NOXmap s~ <Plug>(operator-camelize-toggle)

  nmap sUU sUsU
  nmap suu susu
  nmap s~~ s~s~
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator HTML Escape: {{{
silent! let s:bundle = neobundle#get('operator-html-escape')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap sh <Plug>(operator-html-escape)
  NOXmap sH <Plug>(operator-html-unescape)

  nmap shh shsh
  nmap sHH sHsH
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Open Browser: {{{
silent! let s:bundle = neobundle#get('operator-openbrowser')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap gx <Plug>(operator-openbrowser)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Replace: {{{
silent! let s:bundle = neobundle#get('operator-replace')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap p <Plug>(operator-replace)
  nnoremap pp p
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Reverse: {{{
silent! let s:bundle = neobundle#get('operator-reverse')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap sv <Plug>(operator-reverse-text)
  NOXmap sV <Plug>(operator-reverse-lines)

  nmap svv svsv
  nmap sVV sVsV
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Sort: {{{
silent! let s:bundle = neobundle#get('operator-sort')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap sS <Plug>(operator-sort)

  nmap sSS sSsS
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

  nnoremap **   *zz
  nnoremap ##   #zz
  nnoremap g*g* g*zz
  nnoremap g#g# g#zz

  nmap g/g/ **
  nmap g?g? ##
  nmap g//  **
  nmap g??  ##
  nmap g**  g*g*
  nmap g##  g#g#

  nnoremap <script> <C-W>**   <SID>(split-nicely)*zz
  nnoremap <script> <C-W>##   <SID>(split-nicely)#zz
  nnoremap <script> <C-W>g*g* <SID>(split-nicely)g*zz
  nnoremap <script> <C-W>g#g# <SID>(split-nicely)g#zz

  nmap <C-W>g/g/ <C-W>**
  nmap <C-W>g?g? <C-W>##
  nmap <C-W>g//  <C-W>**
  nmap <C-W>g??  <C-W>##
  nmap <C-W>g**  <C-W>g*g*
  nmap <C-W>g##  <C-W>g#g#
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ParaJump: {{{
silent! let s:bundle = neobundle#get('parajump')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:parajump_no_default_key_mappings = 1
  endfunction

  nmap <SID>(parajump-backward) <Plug>(parajump-backward)
  nmap <SID>(parajump-forward)  <Plug>(parajump-forward)

  nnoremap <script> { <SID>(parajump-backward)zz
  nnoremap <script> } <SID>(parajump-forward)zz

  inoremap <script> <M-{> <C-O><SID>(parajump-backward)
  inoremap <script> <M-}> <C-O><SID>(parajump-forward)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

  call extend(s:neocompl_force_omni_patterns, {
    \ 'perl' : '[^.[:digit:] *\t]->\|\h\w*::'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" PHP Complete: {{{
silent! let s:bundle = neobundle#get('phpcomplete')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  call extend(s:neocompl_force_omni_patterns, {
    \ 'php' : '[^.[:digit:] *\t]->\|\h\w*::'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Precious: {{{
silent! let s:bundle = neobundle#get('precious')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_precious_no_default_key_mappings = 1
    let g:precious_enable_switchers                = {
      \ 'help' : {'setfiletype' : 0}}
  endfunction

  OXmap ax <Plug>(textobj-precious-i)
  OXmap ix <Plug>(textobj-precious-i)

  autocmd MyVimrc FileType *
    \ NeoBundleSource precious
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" QFixHowm: {{{
silent! let s:bundle = neobundle#get('qfixhowm')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:QFix_Height                    = 20
    let g:QFix_PreviewHeight             = 20
    let g:MyGrep_MenuBar                 = 0
    let g:MyGrep_MultiEncodingGrepScript = 1
    let g:MyGrep_Resultfile              = $HOME . '/.local/.qfgrep.txt'
    let g:MyGrep_ExcludeReg              =
      \ '/\.drive\.r/|/\.hg/|/\.git/|/\.svn/'
    if s:executable('jvgrep')
      let g:mygrepprg   = 'jvgrep'
    elseif s:executable('grep')
      let g:mygrepprg   = 'grep'
    else
      let g:mygrepprg   = 'internal'
      let g:myjpgrepprg = 'agrep.vim'
    endif

    let g:howm_dir                = $HOME . '/howm'
    let g:howm_filename           = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
    let g:howm_fileformat         = 'unix'
    let g:qfixmemo_menubar        = 0
    let g:QFixHowm_Menufile       = '0000-00-01-000000.howm'
    let g:QFixHowm_MenuHeight     = 20
    let g:QFixHowm_keywordfile    = $HOME . '/howm/.howm-keys'
    let g:QFixHowm_RandomWalkFile = $HOME . '/.local/.howm-random'
    let g:QFixHowm_VimEnterFile   = $HOME . '/.local/.vimenter.qf'
    let g:QFixMRU_Filename        = $HOME . '/.local/.qfixmru'
    if has('multi_byte')
      let g:howm_fileencoding = 'cp932'
    endif
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
    sunmap g,B
    sunmap g,E
    sunmap g,F
    sunmap g,V
    sunmap g,b
    sunmap g,e
    sunmap g,f
    sunmap g,v
    sunmap g,rE
    sunmap g,rF
    sunmap g,re
    sunmap g,rf
  endfunction

  nnoremap <C-W>, :<C-U>OpenQFixWin<CR>
  nnoremap <C-W>. :<C-U>CloseToQFixWin<CR>
  nnoremap <C-W>0 :<C-U>ToggleLocationListMode<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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
      \ quickrun#is_running() ?
      \   quickrun#sweep_sessions() :
      \   '<C-C>'
  endfunction

  if neobundle#get('precious') != {}
    NOXmap sr <Plug>(precious-quickrun-op)
  else
    NOXmap sr <Plug>(quickrun-op)
  endif

  nmap srr srsr
  nmap <Leader>r <Plug>(quickrun)
  nmap <F5>      <Plug>(quickrun)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Reanimate: {{{
silent! let s:bundle = neobundle#get('reanimate')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:reanimate_save_dir = $HOME . '/.local/reanimate'
  endfunction

  nnoremap ;ur  <Nop>
  nnoremap ;url :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_load<CR>
  nnoremap ;urs :<C-U>Unite reanimate
    \ -buffer-name=files -no-split -default-action=reanimate_save<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" Ruby: {{{
silent! let s:bundle = neobundle#get('ruby')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  if has('ruby')
    call extend(s:neocompl_force_omni_patterns, {
      \ 'ruby' : '[^.[:digit:] *\t]\.\|\h\w*::'})
  endif
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SaveVers: {{{
silent! let s:bundle = neobundle#get('savevers')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:savevers_max          = 99
    let g:savevers_dirs         = &backupdir
    let g:savevers_hierarchical = 1
    let g:versdiff_no_resize    = 1
  endfunction

  nnoremap <F7>  :<C-U>VersDiff -<CR>
  nnoremap g<F7> :<C-U>VersDiff +<CR>
  nnoremap g<F8> :<C-U>VersDiff -c<CR>

  autocmd MyVimrc BufNewFile,BufRead *
    \ NeoBundleSource savevers
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Scratch: {{{
silent! let s:bundle = neobundle#get('scratch')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:scratch_buffer_name = '[scratch]'
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SmartChr: {{{
silent! let s:bundle = neobundle#get('smartchr')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:cmdwin_enter_smartchr()
    silent! iunmap <buffer> =
    silent! iunmap <buffer> ~
    silent! iunmap <buffer> ?
    silent! iunmap <buffer> #

    silent! iunmap <buffer> +
    silent! iunmap <buffer> -
    silent! iunmap <buffer> *
    silent! iunmap <buffer> /
    silent! iunmap <buffer> %
    silent! iunmap <buffer> :
    silent! iunmap <buffer> .
    silent! iunmap <buffer> &
    silent! iunmap <buffer> \|
    silent! iunmap <buffer> <
    silent! iunmap <buffer> >

    silent! iunmap <buffer> ,
  endfunction
  autocmd MyVimrc CmdwinEnter *
    \ call s:cmdwin_enter_smartchr()
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SmartInput: {{{
silent! let s:bundle = neobundle#get('smartinput')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    call smartinput#map_to_trigger(
      \ 'i',
      \ '<Plug>(smartinput-<CR>)',
      \ '<CR>',
      \ '<CR>')
    call smartinput#map_to_trigger(
      \ 'i',
      \ '<Plug>(smartinput-<BS>)',
      \ '<BS>',
      \ '<BS>')
    call smartinput#map_to_trigger(
      \ 'i',
      \ '<Plug>(smartinput-<C-H>)',
      \ '<C-H>',
      \ '<C-H>')

    imap <SID>(smartinput-<CR>)  <Plug>(smartinput-<CR>)
    imap <SID>(smartinput-<BS>)  <Plug>(smartinput-<BS>)
    imap <SID>(smartinput-<C-H>) <Plug>(smartinput-<C-H>)
  endfunction
else
  inoremap <SID>(smartinput-<CR>)  <CR>
  inoremap <SID>(smartinput-<BS>)  <BS>
  inoremap <SID>(smartinput-<C-H>) <C-H>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SmartWord: {{{
silent! let s:bundle = neobundle#get('smartword')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NOXmap w  <Plug>(smartword-w)
  NOXmap b  <Plug>(smartword-b)
  NOXmap e  <Plug>(smartword-e)
  NOXmap ge <Plug>(smartword-ge)

  nmap <SID>(smartword-w)  <Plug>(smartword-w)
  nmap <SID>(smartword-b)  <Plug>(smartword-b)
  nmap <SID>(smartword-e)  <Plug>(smartword-e)
  nmap <SID>(smartword-ge) <Plug>(smartword-ge)

  inoremap <script> <M-w>      <C-O><SID>(smartword-w)
  inoremap <script> <M-b>      <C-O><SID>(smartword-b)
  inoremap <script> <M-e>      <C-O><SID>(smartword-e)
  inoremap <script> <M-g><M-e> <C-O><SID>(smartword-ge)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Surround: {{{
silent! let s:bundle = neobundle#get('surround')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:surround_no_mappings = 1
  endfunction

  nmap ds     <Plug>Dsurround
  nmap cs     <Plug>Csurround
  nmap ys     <Plug>Ysurround
  nmap yS     <Plug>YSurround
  nmap yss    <Plug>Yssurround
  nmap ySs    <Plug>YSsurround
  nmap ySS    <Plug>YSsurround
  xmap S      <Plug>VSurround
  xmap gS     <Plug>VgSurround
  imap <C-S>s <Plug>Isurround
  imap <C-S>S <Plug>Isurround
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

    call extend(g:switch_increment_definitions, [
      \ {'\C\(-\?\d*\)\%(TH\|ST\|ND\|RD\)' :
      \    '\=toupper(call(''' . s:SID_PREFIX() . 'ordinal'', [submatch(1) + 1]))',
      \  '\C\(-\?\d*\)\%(th\|st\|nd\|rd\)' :
      \    '\=tolower(call(''' . s:SID_PREFIX() . 'ordinal'', [submatch(1) + 1]))'}])
    call extend(g:switch_decrement_definitions, [
      \ {'\C\(-\?\d*\)\%(TH\|ST\|ND\|RD\)' :
      \    '\=toupper(call(''' . s:SID_PREFIX() . 'ordinal'', [submatch(1) - 1]))',
      \  '\C\(-\?\d*\)\%(th\|st\|nd\|rd\)' :
      \    '\=tolower(call(''' . s:SID_PREFIX() . 'ordinal'', [submatch(1) - 1]))'}])
  endfunction

  function! s:switch(direction)
    NeoBundleSource switch

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
    if a:direction == '+'
      if exists('g:switch_increment_definitions')
        call extend(definitions, g:switch_increment_definitions)
      endif
      if exists('b:switch_increment_definitions')
        call extend(definitions, b:switch_increment_definitions)
      endif
    elseif a:direction == '-'
      if exists('g:switch_decrement_definitions')
        call extend(definitions, g:switch_decrement_definitions)
      endif
      if exists('b:switch_decrement_definitions')
        call extend(definitions, b:switch_decrement_definitions)
      endif
    endif

    if !switch#Switch(definitions)
      if a:direction == '+'
        execute "normal! \<C-A>"
      elseif a:direction == '-'
        execute "normal! \<C-X>"
      endif
    endif
  endfunction

  nnoremap <C-A> :<C-U>call <SID>switch('+')<CR>
  nnoremap <C-X> :<C-U>call <SID>switch('-')<CR>

  autocmd MyVimrc VimEnter,BufNewFile,BufRead *
    \ let b:switch_no_builtins = 1
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TComment: {{{
silent! let s:bundle = neobundle#get('tcomment')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:tcommentMaps = 0

    call tcomment#DefineType('d',         '// %s')
    call tcomment#DefineType('d_inline',  g:tcommentInlineC)
    call tcomment#DefineType('d_block',   g:tcommentBlockC)
    call tcomment#DefineType('gitconfig', '# %s')
    call tcomment#DefineType('lua',       '-- %s')
    call tcomment#DefineType('lua_block', '--[[%s]]')
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

  nnoremap gc
    \ :<C-U>let w:tcommentPos = getpos('.') \|
    \  set opfunc=tcomment#Operator<CR>g@
  nnoremap gcgc
    \ :<C-U>let w:tcommentPos = getpos('.') \|
    \  set opfunc=tcomment#OperatorLine<CR>g@$
  nnoremap gC
    \ :<C-U>let w:tcommentPos = getpos('.') \|
    \  call tcomment#SetOption('mode_extra', 'B') \|
    \  set opfunc=tcomment#OperatorLine<CR>g@
  nmap gcc gcgc

  xnoremap gc :TComment<CR>
  xnoremap gC :TCommentBlock<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextManipilate: {{{
silent! let s:bundle = neobundle#get('textmanip')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  NXmap <M-p> <Plug>(textmanip-duplicate-down)
  NXmap <M-P> <Plug>(textmanip-duplicate-up)
  xmap  <M-j> <Plug>(textmanip-move-down)
  xmap  <M-k> <Plug>(textmanip-move-up)
  xmap  <M-h> <Plug>(textmanip-move-left)
  xmap  <M-l> <Plug>(textmanip-move-right)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Between: {{{
silent! let s:bundle = neobundle#get('textobj-between')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_between_no_default_key_mappings = 1
  endfunction

  OXmap af <Plug>(textobj-between-a)
  OXmap if <Plug>(textobj-between-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Comment: {{{
silent! let s:bundle = neobundle#get('textobj-comment')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  OXmap ac <Plug>(textobj-comment-a)
  OXmap ic <Plug>(textobj-comment-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj DateTime: {{{
silent! let s:bundle = neobundle#get('textobj-datetime')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_datetime_no_default_key_mappings = 1
  endfunction

  OXnoremap ad <Nop>
  OXmap ada <Plug>(textobj-datetime-auto)
  OXmap add <Plug>(textobj-datetime-date)
  OXmap adf <Plug>(textobj-datetime-full)
  OXmap adt <Plug>(textobj-datetime-time)
  OXmap adz <Plug>(textobj-datetime-tz)

  OXnoremap id <Nop>
  OXmap ida <Plug>(textobj-datetime-auto)
  OXmap idd <Plug>(textobj-datetime-date)
  OXmap idf <Plug>(textobj-datetime-full)
  OXmap idt <Plug>(textobj-datetime-time)
  OXmap idz <Plug>(textobj-datetime-tz)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Diff: {{{
silent! let s:bundle = neobundle#get('textobj-diff')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_diff_no_default_key_mappings = 1
  endfunction

  NOXnoremap <Leader>d <Nop>
  NOXmap <Leader>dfJ <Plug>(textobj-diff-file-N)
  NOXmap <Leader>dfK <Plug>(textobj-diff-file-P)
  NOXmap <Leader>dfj <Plug>(textobj-diff-file-n)
  NOXmap <Leader>dfk <Plug>(textobj-diff-file-p)
  NOXmap <Leader>dJ  <Plug>(textobj-diff-hunk-N)
  NOXmap <Leader>dK  <Plug>(textobj-diff-hunk-P)
  NOXmap <Leader>dj  <Plug>(textobj-diff-hunk-n)
  NOXmap <Leader>dk  <Plug>(textobj-diff-hunk-p)

  OXnoremap ad <Nop>
  OXmap adH <Plug>(textobj-diff-file)
  OXmap adf <Plug>(textobj-diff-file)
  OXmap adh <Plug>(textobj-diff-hunk)

  OXnoremap id <Nop>
  OXmap idH <Plug>(textobj-diff-file)
  OXmap idf <Plug>(textobj-diff-file)
  OXmap idh <Plug>(textobj-diff-hunk)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Entrie: {{{
silent! let s:bundle = neobundle#get('textobj-entire')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  OXmap ae <Plug>(textobj-entire-a)
  OXmap ie <Plug>(textobj-entire-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj EnclosedSyntax: {{{
silent! let s:bundle = neobundle#get('textobj-enclosedsyntax')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_enclosedsyntax_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Fold: {{{
silent! let s:bundle = neobundle#get('textobj-fold')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_fold_no_default_key_mappings = 1
  endfunction

  OXmap az <Plug>(textobj-fold-a)
  OXmap iz <Plug>(textobj-fold-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Function: {{{
silent! let s:bundle = neobundle#get('textobj-function')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_function_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Ifdef: {{{
silent! let s:bundle = neobundle#get('textobj-ifdef')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj IndentBlock: {{{
silent! let s:bundle = neobundle#get('textobj-indblock')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_indblock_no_default_key_mappings = 1
  endfunction

  OXmap ao <Plug>(textobj-indblock-a)
  OXmap io <Plug>(textobj-indblock-i)
  OXmap aO <Plug>(textobj-indblock-same-a)
  OXmap iO <Plug>(textobj-indblock-same-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Indent: {{{
silent! let s:bundle = neobundle#get('textobj-indent')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_indent_no_default_key_mappings = 1
  endfunction

  OXmap ai <Plug>(textobj-indent-a)
  OXmap ii <Plug>(textobj-indent-i)
  OXmap aI <Plug>(textobj-indent-same-a)
  OXmap iI <Plug>(textobj-indent-same-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj JaBraces: {{{
silent! let s:bundle = neobundle#get('textobj-jabraces')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
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
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Line: {{{
silent! let s:bundle = neobundle#get('textobj-line')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  OXmap al <Plug>(textobj-line-a)
  OXmap il <Plug>(textobj-line-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj MultiBlock: {{{
silent! let s:bundle = neobundle#get('textobj-multiblock')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_multiblock_no_default_key_mappings = 1
  endfunction

  OXmap ab <Plug>(textobj-multiblock-a)
  OXmap ib <Plug>(textobj-multiblock-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj MultiTextObj: {{{
silent! let s:bundle = neobundle#get('textobj-multitextobj')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_multitextobj_textobjects_group_a = {
      \ 'A' : [[
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
      \ 'A' : [[
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

  OXmap <SID>(textobj-jabraces-a) <Plug>(textobj-multitextobj-A-a)
  OXmap <SID>(textobj-jabraces-i) <Plug>(textobj-multitextobj-A-i)

  OXmap aB <SID>(textobj-jabraces-a)
  OXmap iB <SID>(textobj-jabraces-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj MotionMotion: {{{
silent! let s:bundle = neobundle#get('textobj-motionmotion')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_motionmotion_no_default_key_mappings = 1
  endfunction

  OXmap am <Plug>(textobj-motionmotion-a)
  OXmap im <Plug>(textobj-motionmotion-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Parameter: {{{
silent! let s:bundle = neobundle#get('textobj-parameter')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  OXmap a, <Plug>(textobj-parameter-a)
  OXmap i, <Plug>(textobj-parameter-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj PHP: {{{
silent! let s:bundle = neobundle#get('textobj-php')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_php_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Python: {{{
silent! let s:bundle = neobundle#get('textobj-python')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_python_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
" TextObj Sigil: {{{
silent! let s:bundle = neobundle#get('textobj-sigil')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Space: {{{
silent! let s:bundle = neobundle#get('textobj-space')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_space_no_default_key_mappings = 1
  endfunction

  OXmap aS <Plug>(textobj-space-a)
  OXmap iS <Plug>(textobj-space-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Syntax: {{{
silent! let s:bundle = neobundle#get('textobj-syntax')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  OXmap ay <Plug>(textobj-syntax-a)
  OXmap iy <Plug>(textobj-syntax-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Url: {{{
silent! let s:bundle = neobundle#get('textobj-url')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  OXmap au <Plug>(textobj-url-a)
  OXmap iu <Plug>(textobj-url-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj WordInWord: {{{
silent! let s:bundle = neobundle#get('textobj-wiw')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_wiw_no_default_key_mappings = 1
  endfunction

  NOXmap <M-w>      <Plug>(textobj-wiw-n)
  NOXmap <M-b>      <Plug>(textobj-wiw-p)
  NOXmap <M-e>      <Plug>(textobj-wiw-N)
  NOXmap <M-g><M-e> <Plug>(textobj-wiw-P)

  OXmap a<M-w> <Plug>(textobj-wiw-a)
  OXmap i<M-w> <Plug>(textobj-wiw-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj XML Attribute: {{{
silent! let s:bundle = neobundle#get('textobj-xml-attribute')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_xmlattribute_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" UndoTree: {{{
silent! let s:bundle = neobundle#get('undotree')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:undotree_SetFocusWhenToggle = 1
  endfunction

  nnoremap <Leader>u :<C-U>UndotreeToggle<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

    if s:executable('jvgrep')
      let g:unite_source_grep_command       = 'jvgrep'
      let g:unite_source_grep_recursive_opt = '-R'
      let g:unite_source_grep_default_opts  = '-n --exclude .drive.r'
    elseif s:executable('grep')
      let g:unite_source_grep_command       = 'grep'
      let g:unite_source_grep_recursive_opt = '-r'
      let g:unite_source_grep_default_opts  = '-Hn'
    endif

    let g:unite_source_menu_menus =
      \ get(g:, 'unite_source_menu_menus', {})

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

  function! s:unite_search_forward()
    if line('$') > 10000
      Unite line/fast
        \ -buffer-name=search -no-split -start-insert
    else
      Unite line
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_backward()
    if line('$') > 10000
      Unite line/fast:backward
        \ -buffer-name=search -no-split -start-insert
    else
      Unite line:backward
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_cword_forward()
    if line('$') > 10000
      UniteWithCursorWord line/fast
        \ -buffer-name=search -no-split -start-insert
    else
      UniteWithCursorWord line
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_cword_backward()
    if line('$') > 10000
      UniteWithCursorWord line/fast:backward
        \ -buffer-name=search -no-split -start-insert
    else
      UniteWithCursorWord line:backward
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction

  nnoremap ;u <Nop>

  nnoremap <script> ;uu <SID>:<C-U>Unite<Space>

  nnoremap ;um :<C-U>Unite menu<CR>
  nnoremap ;u<CR> :<C-U>Unite menu:set_ff<CR>
  if has('multi_byte')
    nnoremap ;ue :<C-U>Unite menu:edit_enc<CR>
    nnoremap ;uf :<C-U>Unite menu:set_fenc<CR>
  endif

  nnoremap ;us
    \ :<C-U>Unite source
    \ -buffer-name=help -no-split<CR>

  nnoremap ;e
    \ :<C-U>Unite file_mru file file/new directory/new
    \ -buffer-name=files -no-split<CR>
  nnoremap ;b
    \ :<C-U>Unite buffer
    \ -buffer-name=files -no-split<CR>
  nnoremap ;t
    \ :<C-U>Unite tab
    \ -buffer-name=files -no-split<CR>
  nnoremap ;<M-d>
    \ :<C-U>Unite directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=lcd<CR>
  nnoremap ;<M-D>
    \ :<C-U>Unite directory_mru directory directory/new
    \ -buffer-name=files -no-split -default-action=cd<CR>

  if &grepprg == 'internal'
    nnoremap ;g
      \ :<C-U>Unite vimgrep
      \ -buffer-name=grep -no-split -multi-line -auto-preview<CR>
  else
    nnoremap ;g
      \ :<C-U>Unite grep
      \ -buffer-name=grep -no-split -multi-line -auto-preview<CR>
  endif
  nnoremap ;G
    \ :<C-U>UniteResume grep
    \ -no-split -multi-line -no-start-insert -auto-preview<CR>

  nnoremap ;j
    \ :<C-U>Unite jump
    \ -buffer-name=register -no-split -multi-line<CR>
  nnoremap ;J
    \ :<C-U>Unite change
    \ -buffer-name=register -no-split -multi-line -auto-preview<CR>
  nnoremap <C-P>
    \ :<C-U>Unite register history/yank
    \ -buffer-name=register -multi-line<CR>
  xnoremap <C-P>
    \ d:<C-U>Unite register history/yank
    \ -buffer-name=register -multi-line<CR>
  inoremap <expr> <C-P>
    \ unite#start_complete(['register', 'history/yank'], {
    \   'buffer_name': 'register',
    \   'is_multi_line' : 1,
    \   'direction' : 'leftabove'})

  nnoremap ;u/
    \ :<C-U>call <SID>unite_search_forward()<CR>
  nnoremap ;u?
    \ :<C-U>call <SID>unite_search_backward()<CR>
  nnoremap ;u*
    \ :<C-U>call <SID>unite_search_cword_forward()<CR>
  nnoremap ;u#
    \ :<C-U>call <SID>unite_search_cword_backward()<CR>
  nnoremap ;ug/
    \ :<C-U>call <SID>unite_search_cword_forward()<CR>
  nnoremap ;ug?
    \ :<C-U>call <SID>unite_search_cword_backward()<CR>
  nnoremap ;un
    \ :<C-U>UniteResume search -start-insert<CR>

  call extend(s:altercmd_define, {
    \ 'u[nite]' : 'Unite'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Help: {{{
silent! let s:bundle = neobundle#get('unite-help')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap ;u<F1>
    \ :<C-U>Unite help
    \ -buffer-name=help -no-split -start-insert<CR>
  nnoremap ;ug<F1>
    \ :<C-U>UniteWithCursorWord help
    \ -buffer-name=help -no-split -no-start-insert<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Mark: {{{
silent! let s:bundle = neobundle#get('unite-mark')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_source_mark_marks =
      \ join(s:mark_char, '') . toupper(join(s:mark_char, ''))
  endfunction

  nnoremap ml
    \ :<C-U>Unite mark bookmark
    \ -buffer-name=register -no-split -multi-line -no-start-insert<CR>
  nnoremap mu :<C-U>UniteBookmarkAdd<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Outline: {{{
silent! let s:bundle = neobundle#get('unite-outline')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap ;o
    \ :<C-U>Unite outline
    \ -buffer-name=outline -no-split -auto-preview -multi-line<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite QuickRun Config: {{{
silent! let s:bundle = neobundle#get('unite-quickrun_config')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap ;ur  <Nop>
  nnoremap ;urr
    \ :<C-U>Unite quickrun_config
    \ -buffer-name=register<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite SSH: {{{
silent! let s:bundle = neobundle#get('unite-ssh')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:check_arg_ssh()
    for i in range(argc())
      if argv(i) =~# '^ssh:'
        return 1
      endif
    endfor
    return 0
  endfunction
  if has('vim_starting') && s:check_arg_ssh()
    NeoBundleSource unite-ssh
  endif
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Sudo: {{{
silent! let s:bundle = neobundle#get('unite-sudo')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:check_arg_sudo()
    for i in range(argc())
      if argv(i) =~# '^sudo:'
        return 1
      endif
    endfor
    return 0
  endfunction
  if has('vim_starting') && s:check_arg_sudo()
    NeoBundleSource unite-sudo
  endif
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Tag: {{{
silent! let s:bundle = neobundle#get('unite-tag')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  nnoremap ;ut
    \ :<C-U>UniteWithCursorWord tag tag/include
    \ -buffer-name=outline -no-split<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VerifyEnc: {{{
silent! let s:bundle = neobundle#get('verifyenc')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  autocmd MyVimrc BufReadPre *
    \ NeoBundleSource verifyenc
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VimDoc Ja: {{{
silent! let s:bundle = neobundle#get('vimdoc-ja')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  set helplang^=ja
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VimFiler: {{{
silent! let s:bundle = neobundle#get('vimfiler')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_data_directory      = $HOME . '/.local/.vimfiler'
    let g:vimfiler_as_default_explorer = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

"-----------------------------------------------------------------------------
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

  call extend(s:altercmd_define, {
    \ 'sh[ell]' : 'VimShell',
    \
    \ '_sh[ell]' : 'shell'})
  call extend(s:neocompl_dictionary_filetype_lists, {
    \ 'vimshell' : $HOME . '/.local/.vimshell/command-history'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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

  xnoremap <script> *  <SID>(visualstar-*)zz
  xnoremap <script> #  <SID>(visualstar-#)zz
  xnoremap <script> g* <SID>(visualstar-g*)zz
  xnoremap <script> g# <SID>(visualstar-g#)zz

  xnoremap <script> <C-W>*  <SID>(split-nicely)gv<SID>(visualstar-*)zz
  xnoremap <script> <C-W>#  <SID>(split-nicely)gv<SID>(visualstar-#)zz
  xnoremap <script> <C-W>g* <SID>(split-nicely)gv<SID>(visualstar-g*)zz
  xnoremap <script> <C-W>g# <SID>(split-nicely)gv<SID>(visualstar-g#)zz
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
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
      \     s:executable('luac52') ? 'watchdogs_checker/luac52' : ''},
      \ 'watchdogs_checker/luac52' : {
      \   'command' : 'luac52',
      \   'exec'    : '%c %o %s:p',
      \   'quickfix/errorformat' : '%.%#: %#%f:%l: %m'}})
  endfunction

  autocmd MyVimrc FileType *
    \ NeoBundleSource watchdogs
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ZenCoding: {{{
silent! let s:bundle = neobundle#get('zencoding')
if exists('s:bundle') && !get(s:bundle, 'disabled', 1)
  function! s:bundle.hooks.on_source(bundle)
    let g:user_zen_settings = {
      \ 'lang' : 'ja',
      \ 'indentation' : '  ',
      \ 'xml' : {'extends' : 'html'}}
  endfunction

  call extend(s:neocompl_omni_patterns, {
    \ 'css' : '.*', 'css.drupal' : '.*', 'haml' : '.*', 'html' : '.*',
    \ 'html.django_template' : '.*', 'htmldjango' : '.*', 'less' : '.*',
    \ 'mustache' : '.*', 'sass' : '.*', 'scss' : '.*', 'slim' : '.*',
    \ 'xhtml' : '.*', 'xml' : '.*', 'xsl' : '.*', 'xslt' : '.*'})
endif
unlet! s:bundle
"}}}
"}}}

"=============================================================================
" Init Last: {{{
" NeoBundle
if exists(':NeoBundle')
  call neobundle#call_hook('on_source')
endif
"}}}
