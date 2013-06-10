" -*- mode: vimrc; coding: utf8-unix -*-

" @name        .vimrc
" @description Vim settings
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-06-10 13:44:34 DeaR>

set nocompatible
scriptencoding utf-8

"=============================================================================
" Init First: {{{
" Reseting
if !has('vim_starting')
  if exists(':NeoBundle')
    call neobundle#config#init()
  endif

  set runtimepath&
  set shortmess&
  set viminfo&
  set backupdir&
  set backupskip&
  set suffixes&
  set undodir&
  set directory&
  set wildignore&
  set formatoptions&
  set helplang&

  if &t_Co > 255
    syntax off
    colorscheme default
  endif

  if filereadable($VIM . '/vimrc')
    source $VIM/vimrc
  endif
endif

" NFA engine
if exists('&regexpengine')
  set regexpengine=1
endif

" Encoding
if has('multi_byte')
  set encoding=utf-8
  if &term == 'win32' && !has('gui_running')
    set termencoding=cp932
  endif
  scriptencoding utf-8
endif

" Fix runtimepath for windows
if has('win32') || has('win64')
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
endif

" Local runtime
set runtimepath^=~/.local
set runtimepath+=~/.local/after

" Singleton
if has('clientserver') &&
  \ isdirectory(expand('~/.local/bundle/singleton'))
  set runtimepath^=~/.local/bundle/singleton
  call singleton#enable()
endif

" Vimrc autocmd group
augroup MyVimrc
  autocmd!
augroup END

" Anywhere SID
function! s:SID_PREFIX(...)
  if !exists('s:_sid_prefix')
    let s:_sid_prefix =
      \ matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
  endif
  return s:_sid_prefix . join(a:000, '')
endfunction

" Check Vim version
function! s:has_patch(version, patch)
  return (v:version > a:version) || (v:version == a:version &&
    \  has(type(a:patch) == type(0) ? ('patch' . a:patch) : a:patch))
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

" Check Android OS
let s:is_android = has('unix') &&
  \ ($HOSTNAME ==? 'android' ||
  \  $VIM =~? 'net\.momodalo\.app\.vimtouch')

"-----------------------------------------------------------------------------
" Variable: {{{
" <Leader> <LocalLeader>
let g:mapleader      = '\'
let g:maplocalleader = '|'

" Command line window
let s:cmdwin_enable = 1

" Commnad line
if !exists('s:cmdwin_enter_functions')
  let s:cmdwin_enter_functions = {
    \ '*' : {}, ':' : {}, '/' : {}, '?' : {},
    \ '>' : {}, '@' : {}, '-' : {}, '=' : {}}
endif
if !exists('s:cmdwin_leave_functions')
  let s:cmdwin_leave_functions = {
    \ '*' : {}, ':' : {}, '/' : {}, '?' : {},
    \ '>' : {}, '@' : {}, '-' : {}, '=' : {}}
endif
if !exists('s:cmdline_enter_functions')
  let s:cmdline_enter_functions = {
    \ '*' : {}, ':' : {}, '/' : {}, '?' : {}}
    " '>' : {}, '@' : {}, '-' : {},
endif

" AlterCommand
if !exists('s:altercmd_define')
  let s:altercmd_define = {}
endif

" NeoComplete or NeoComplCache
if !exists('s:neocompl_force_omni_patterns')
  let s:neocompl_force_omni_patterns = {}
endif
if !exists('s:neocompl_keyword_patterns')
  let s:neocompl_keyword_patterns = {}
endif
if !exists('s:neocompl_omni_patterns')
  let s:neocompl_omni_patterns = {}
endif
if !exists('s:neocompl_dictionary_filetype_lists')
  let s:neocompl_dictionary_filetype_lists = {}
endif
if !exists('s:neocompl_vim_completefuncs')
  let s:neocompl_vim_completefuncs = {}
endif

" VCvarsall.bat
if has('win32') || has('win64')
  let s:save_ssl = &shellslash
  set noshellslash
  if exists('$VS110COMNTOOLS')
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
if isdirectory(expand('~/.local/bundle/neobundle'))
  let g:neobundle#enable_name_conversion = 1
  if s:is_android
    let g:neobundle#types#git#default_protocol = 'ssh'
    let g:neobundle#types#hg#default_protocol  = 'ssh'
  endif
  set runtimepath+=~/.local/bundle/neobundle
  call neobundle#rc(expand('~/.local/bundle'))

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
    \     ['nvoi', '<Plug>(altr-forward)'], ['nvoi', '<Plug>(altr-back)']]}}

  NeoBundleLazy 'gist:iori-yja/1615430', {
    \ 'name' : 'arm',
    \ 'autoload' : {'filetypes' : 'arm'},
    \ 'script_type' : 'syntax'}

  NeoBundleLazy 'autodate.vim'

  NeoBundleLazy 'vim-jp/autofmt'

  NeoBundleLazy 'mattn/benchvimrc-vim', {
    \ 'autoload' : {'commands' : 'BenchVimrc'}}

  " NeoBundleLazy 'camelcasemotion', {
  NeoBundleLazy 'DeaR/camelcasemotion', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>CamelCaseMotion_w'],
    \     ['nvo', '<Plug>CamelCaseMotion_b'],
    \     ['nvo', '<Plug>CamelCaseMotion_e'],
    \     ['nvo', '<Plug>CamelCaseMotion_ge'],
    \     ['vo',  '<Plug>CamelCaseMotion_iw'],
    \     ['vo',  '<Plug>CamelCaseMotion_ib'],
    \     ['vo',  '<Plug>CamelCaseMotion_ie']]}}

  if has('python') && executable('clang')
    NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {'filetypes' : ['c', 'cpp', 'objc', 'objcpp']}}
  endif

  NeoBundleLazy 'rhysd/clever-f.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(clever-f-f)'], ['nvo', '<Plug>(clever-f-F)'],
    \     ['nvo', '<Plug>(clever-f-t)'], ['nvo', '<Plug>(clever-f-T)']]}}

  NeoBundleLazy 'deris/columnjump', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(columnjump-forward)'],
    \     ['nvo', '<Plug>(columnjump-backward)']]}}

  NeoBundleLazy 'vim-jp/cpp-vim', {
    \ 'autoload' : {'filetypes' : 'cpp'}}

  NeoBundleLazy 'JesseKPhillips/d.vim', {
    \ 'autoload' : {'filetypes' : 'd'}}

  if has('balloon_eval')
    NeoBundleLazy 'tyru/foldballoon.vim'
 endif

  NeoBundleLazy 'thinca/vim-ft-diff_fold', {
    \ 'autoload' : {'filetypes' : 'diff'}}

  NeoBundleLazy 'thinca/vim-ft-help_fold', {
    \ 'autoload' : {'filetypes' : 'help'}}

  NeoBundleLazy 'thinca/vim-ft-markdown_fold', {
    \ 'autoload' : {'filetypes' : 'markdown'}}

  NeoBundleLazy 'thinca/vim-ft-vim_fold', {
    \ 'autoload' : {'filetypes' : 'vim'}}

  NeoBundleLazy 'gist:mattn/5457352', {
    \ 'name' : 'ginger',
    \ 'autoload' : {'commands' : 'Ginger'},
    \ 'script_type' : 'plugin',
    \ 'depends' : 'mattn/webapi-vim'}

  NeoBundleLazy 'yomi322/vim-gitcomplete', {
    \ 'autoload' : {'filetypes' : 'vimshell'}}

  NeoBundleLazy 'gregsexton/gitv', {
    \ 'autoload' : {'commands' : 'Gitv'},
    \ 'depends' : 'tpope/vim-fugitive'}

  NeoBundleLazy 'kana/vim-grex', {
    \ 'autoload' : {
    \   'commands' : ['Gred', 'Grey'],
    \   'mappings' : [
    \     ['nvo', '<Plug>(operator-grex-delete)'],
    \     ['nvo', '<Plug>(operator-grex-yank)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  if has('python') || has('python3')
    NeoBundleLazy 'bitbucket:sjl/gundo.vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'GundoToggle', 'GundoShow', 'GundoHide', 'GundoRenderGraph']}}
  endif

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

  NeoBundleLazy 'kwbdi.vim', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>Kwbd']]}}

  NeoBundle 'thinca/vim-localrc'

  NeoBundleLazy 'https://raw.github.com/januswel/dotfiles/master/vimfiles/syntax/mayu.vim', {
    \ 'name' : 'mayu',
    \ 'autoload' : {'filetypes' : 'mayu'},
    \ 'script_type' : 'syntax'}

  if has('unix') && !has('gui_running')
    NeoBundle 'gist:DeaR/5560785', {
      \ 'name' : 'map-alt-keys',
      \ 'script_type' : 'plugin',
      \ 'terminal' : 1}
  endif

  NeoBundleLazy 'gist:DeaR/5558981', {
    \ 'name' : 'maplist',
    \ 'autoload' : {
    \   'commands' : [
    \     'MapList',  'NMapList', 'VMapList', 'OMapList', 'XMapList',
    \     'SMapList', 'IMapList', 'CMapList', 'LMapList']},
    \ 'script_type' : 'plugin'}

  if has('python') || has('python3')
    NeoBundleLazy 'mattn/mkdpreview-vim', {
      \ 'autoload' : {'filetypes' : 'markdown'},
      \ 'depends' : 'mattn/webapi-vim',
      \ 'gui' : 1}
  endif

  NeoBundle 'tomasr/molokai'

  NeoBundleLazy 'kana/vim-narrow', {
    \ 'autoload' : {'commands' : ['Narrow', 'Widen']}}

  NeoBundleLazy 'violetyk/neco-php', {
    \ 'autoload' : {'filetypes' : 'php'}}

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
      \   'unite_sources' : ['file_include', 'neocomplete'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'Shougo/context_filetype.vim',
      \   'Shougo/echodoc',
      \   'hrsh7th/vim-neco-calc',
      \   'ujihisa/neco-look',
      \   'Shougo/neosnippet.vim']}
    call extend(s:neocompl_vim_completefuncs, {
      \ 'NeoComplCacheCachingDictionary' : 'neocomplete#filetype_complete',
      \ 'NeoComplCacheCachingSyntax'     : 'neocomplete#filetype_complete'})
  else
    NeoBundleLazy 'Shougo/neocomplcache.vim', {
      \ 'autoload' : {
      \   'unite_sources' : ['file_include', 'neocomplcache'],
      \   'insert' : 1},
      \ 'depends' : [
      \   'Shougo/echodoc',
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
    \   'mappings' : [
    \     ['v', '<Plug>(neosnippet_expand_or_jump)'],
    \     ['v', '<Plug>(neosnippet_jump_or_expand)'],
    \     ['v', '<Plug>(neosnippet_expand)'],
    \     ['v', '<Plug>(neosnippet_jump)'],
    \     ['x', '<Plug>(neosnippet_get_selected_text)'],
    \     ['x', '<Plug>(neosnippet_expand_target)']],
    \   'unite_sources' : [
    \     'snippet', 'snippet/target',
    \     'neosnippet/user', 'neosnippet/runtime']},
    \ 'depends' : [
    \   'Shougo/context_filetype.vim',
    \   'Shougo/echodoc']}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'NeoSnippetEdit'                   : 'neosnippet#edit_complete',
    \ 'NeoSnippetMakeCache'              : 'neosnippet#filetype_complete',
    \ 'NeoComplCacheCachingSnippets'     : 'neosnippet#filetype_complete',
    \ 'NeoComplCacheEditSnippets'        : 'neosnippet#filetype_complete',
    \ 'NeoComplCacheEditRuntimeSnippets' : 'neosnippet#filetype_complete'})

  NeoBundleLazy 'Shougo/vim-nyaos', {
    \ 'autoload' : {'filetypes' : 'nyaos'}}

  if has('python') && (exists('$VCVARSALL') || executable('xbuild'))
    NeoBundleLazy 'nosami/Omnisharp', {
      \ 'autoload' : {'filetypes' : 'cs'},
      \ 'depends' : 'tpope/vim-dispatch',
      \ 'build' : {
      \   'windows' : join([
      \     $VCVARSALL, $PROCESSOR_ARCHITECTURE, '&',
      \     'msbuild server/OmniSharp.sln /p:Platform="Any CPU"']),
      \   'mac'     :
      \     'xbuild server/OmniSharp.sln /p:Platform="Any CPU"',
      \   'unix'    :
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
    \     ['nv', '<Plug>(openbrowser-open)'],
    \     ['nv', '<Plug>(openbrowser-search)'],
    \     ['nv', '<Plug>(openbrowser-smart-search)']]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'OpenBrowserSearch'      : 'openbrowser#_cmd_complete',
    \ 'OpenBrowserSmartSearch' : 'openbrowser#_cmd_complete'})

  NeoBundleLazy 'tyru/operator-camelize.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(operator-camelize)'],
    \     ['nvo', '<Plug>(operator-decamelize)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'tyru/operator-html-escape.vim', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(operator-html-escape)'],
    \     ['nvo', '<Plug>(operator-html-unescape)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'kana/vim-operator-replace', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>(operator-replace)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'emonkak/vim-operator-sort', {
    \ 'autoload' : {'mappings' : [['nvo', '<Plug>(operator-sort)']]},
    \ 'depends' : 'kana/vim-operator-user'}

  NeoBundleLazy 'kana/vim-operator-user', {
    \ 'autoload' : {'function_prefix' : 'operator'}}

  NeoBundleLazy 'deris/parajump', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(parajump-forward)'],
    \     ['nvo', '<Plug>(parajump-backward)']]}}

  if has('perl')
    NeoBundleLazy 'c9s/perlomni.vim', {
      \ 'autoload' : {'filetypes' : 'perl'}}
  endif

  NeoBundleLazy 'shawncplus/phpcomplete.vim', {
    \ 'autoload' : {'filetypes' : 'php'}}

  NeoBundleLazy '2072/PHP-Indenting-for-VIm', {
    \ 'autoload' : {'filetypes' : 'php'}}

  NeoBundleLazy 'osyo-manga/vim-precious', {
    \ 'autoload' : {'commands' : 'PreciousSwitch'},
    \ 'depends' : [
    \   'Shougo/context_filetype.vim',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'fuenor/qfixhowm', {
    \ 'autoload' : {
    \   'commands' : [
    \     'Grep',  'Grepadd',  'RGrep',  'RGrepadd',
    \     'EGrep', 'EGrepadd', 'REGrep', 'REGrepadd',
    \     'FGrep', 'FGrepadd', 'RFGrep', 'RFGrepadd',
    \     'BGrep', 'BGrepadd', 'VGrep',  'VGrepadd',
    \     'Vimgrep', 'Vimgrepadd', 'ToggleLocationListMode',
    \     'MyGrepWriteResult', 'MyGrepReadResult', 'FList',
    \     'OpenQFixWin', 'CloseQFixWin', 'ToggleQFixWin', 'MoveToQFixWin'],
    \   'mappings' : [['nv', 'g,']]},
    \   'explorer' : 1}

  NeoBundleLazy 'thinca/vim-quickrun', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'QuickRun',
    \      'complete' : 'customlist,quickrun#complete'}],
    \   'mappings' : [
    \     ['nv', '<Plug>(quickrun)'], ['n', '<Plug>(quickrun-op)']]},
    \ 'depends' : 'osyo-manga/shabadou.vim'}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'QuickRun' : 'quickrun#complete'})

  NeoBundleLazy 'thinca/vim-ref', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Ref',
    \      'complete' : 'customlist,ref#complete'}],
    \   'mappings' : [['nv', '<Plug>(ref-keyword)']],
    \   'unite_sources' : 'ref'}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Ref' : 'ref#complete'})

  if has('ruby')
    NeoBundleLazy 'vim-ruby/vim-ruby', {
      \ 'autoload' : {'filetypes' : ['eruby', 'ruby']}}
  endif

  " NeoBundleLazy 'savevers.vim', {
  NeoBundleLazy 'DeaR/savevers.vim', {
    \ 'autoload' : {'commands' : ['Purge', 'VersDiff']}}

  NeoBundleLazy 'thinca/vim-scouter', {
    \ 'autoload' : {'commands' : 'Scouter'}}

  NeoBundleLazy 'kana/vim-scratch', {
    \ 'autoload' : {'commands' : ['ScratchOpen', 'ScratchClose']}}

  NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
    \ 'autoload' : {'filetypes' : 'javascript'}}

  if has('clientserver')
    NeoBundleLazy 'thinca/vim-singleton', {
      \ 'sourced' : 1}
  endif

  NeoBundleLazy 'kana/vim-smartchr'

  NeoBundleLazy 'kana/vim-smartword', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nvo', '<Plug>(smartword-w)'], ['nvo', '<Plug>(smartword-b)'],
    \     ['nvo', '<Plug>(smartword-e)'], ['nvo', '<Plug>(smartword-ge)']]}}

  NeoBundleLazy 'tpope/vim-surround', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['nx', '<Plug>Dsurround'],  ['nx', '<Plug>Csurround'],
    \     ['nx', '<Plug>Ysurround'],  ['nx', '<Plug>YSurround'],
    \     ['nx', '<Plug>Yssurround'], ['nx', '<Plug>YSsurround'],
    \     ['v',  '<Plug>VSurround'],  ['v',  '<Plug>VgSurround'],
    \     ['i',  '<Plug>Isurround'],  ['i',  '<Plug>ISurround']]}}

  NeoBundleLazy 'AndrewRadev/switch.vim'

  NeoBundleLazy 'tomtom/tcomment_vim', {
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
    \     ['nvoi', '<C-_>'], ['nvo', '<Leader>_'],
    \     ['nx', 'gc'], ['nx', 'gC']]}}
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
    \     ['nv', '<Plug>(textmanip-duplicate-down)'],
    \     ['nv', '<Plug>(textmanip-duplicate-up)'],
    \     ['nv', '<Plug>(textmanip-move-left)'],
    \     ['nv', '<Plug>(textmanip-move-down)'],
    \     ['nv', '<Plug>(textmanip-move-up)'],
    \     ['nv', '<Plug>(textmanip-move-right)']]}}

  NeoBundleLazy 'thinca/vim-textobj-between', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-between-a)'],
    \     ['vo', '<Plug>(textobj-between-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'thinca/vim-textobj-comment', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-comment-a)'],
    \     ['vo', '<Plug>(textobj-comment-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'rhysd/vim-textobj-continuous-line', {
    \ 'autoload' : {'filetypes' : ['c', 'cpp', 'sh', 'vim', 'zsh']},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-datetime', {
    \ 'autoload' : {'mappings' : [['ox', 'ad'], ['ox', 'id']]},
    \ 'depends' : [
    \   'kana/vim-textobj-diff',
    \   'kana/vim-textobj-user']}

  NeoBundleLazy 'kana/vim-textobj-diff', {
    \ 'autoload' : {'mappings' : '<Leader>d'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-entire', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-entire-a)'],
    \     ['vo', '<Plug>(textobj-entire-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-fold', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-fold-a)'],
    \     ['vo', '<Plug>(textobj-fold-i)']]},
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
    \     ['vo', '<Plug>(textobj-indblock-a)'],
    \     ['vo', '<Plug>(textobj-indblock-i)'],
    \     ['vo', '<Plug>(textobj-indblock-same-a)'],
    \     ['vo', '<Plug>(textobj-indblock-same-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-indent', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-indent-a)'],
    \     ['vo', '<Plug>(textobj-indent-i)'],
    \     ['vo', '<Plug>(textobj-indent-same-a)'],
    \     ['vo', '<Plug>(textobj-indent-same-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-jabraces', {
    \ 'autoload' : {'mappings' : [['vo', 'aj'], ['vo', 'ij']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'rhysd/vim-textobj-lastinserted', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-lastinserted-a)'],
    \     ['vo', '<Plug>(textobj-lastinserted-i)']],
    \   'insert' : 1},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-lastpat', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-lastpat-n)'],
    \     ['vo', '<Plug>(textobj-lastpat-N)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-line', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-line-a)'],
    \     ['vo', '<Plug>(textobj-line-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'sgur/vim-textobj-parameter', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-parameter-a)'],
    \     ['vo', '<Plug>(textobj-parameter-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'akiyan/vim-textobj-php', {
    \ 'autoload' : {'filetypes' : 'php'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'bps/vim-textobj-python', {
    \ 'autoload' : {'filetypes' : 'python'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'nelstrom/vim-textobj-rubyblock', {
    \ 'autoload' : {'filetypes' : 'ruby'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'vimtaku/vim-textobj-sigil', {
    \ 'autoload' : {'filetypes' : 'perl'},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'saihoooooooo/vim-textobj-space', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-space-a)'],
    \     ['vo', '<Plug>(textobj-space-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-syntax', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-syntax-a)'],
    \     ['vo', '<Plug>(textobj-syntax-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'lucapette/vim-textobj-underscore', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-undcerscore-a)'],
    \     ['vo', '<Plug>(textobj-undcerscore-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'mattn/vim-textobj-url', {
    \ 'autoload' : {
    \   'mappings' : [
    \     ['vo', '<Plug>(textobj-url-a)'],
    \     ['vo', '<Plug>(textobj-url-i)']]},
    \ 'depends' : 'kana/vim-textobj-user'}

  NeoBundleLazy 'kana/vim-textobj-user', {
    \ 'autoload' : {'function_prefix' : 'textobj'}}

  NeoBundleLazy 'zaiste/tmux.vim', {
    \ 'autoload' : {'filetypes' : 'tmux'}}

  NeoBundleLazy 'Shougo/unite.vim', {
    \ 'autoload' : {
    \   'commands' : [
    \     {'name' : 'Unite',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteWithCurrentDir',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteWithBufferDir',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteWithCursorWord',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteWithInput',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteWithInputDirectory',
    \      'complete' : 'customlist,unite#complete_source'},
    \     {'name' : 'UniteResume',
    \      'complete' : 'customlist,unite#complete_buffer_name'},
    \     {'name' : 'UniteBookmarkAdd',
    \      'complete' : 'file'}]}}
  call extend(s:neocompl_vim_completefuncs, {
    \ 'Unite'                   : 'unite#complete_source',
    \ 'UniteWithCurrentDir'     : 'unite#complete_source',
    \ 'UniteWithBufferDir'      : 'unite#complete_source',
    \ 'UniteWithCursorWord'     : 'unite#complete_source',
    \ 'UniteWithInput'          : 'unite#complete_source',
    \ 'UniteWithInputDirectory' : 'unite#complete_source',
    \ 'UniteResume'             : 'unite#complete_buffer_name'})

  NeoBundleLazy 'osyo-manga/unite-quickrun_config', {
    \ 'autoload' : {'unite_sources' : 'quickrun_config'},
    \ 'depends' : 'thinca/vim-quickrun'}

  NeoBundleLazy 'osyo-manga/unite-filetype', {
    \ 'autoload' : {'unite_sources' : 'filetype'}}

  NeoBundleLazy 'tsukkee/unite-help', {
    \ 'autoload' : {'unite_sources' : 'help'}}

  NeoBundleLazy 'thinca/vim-unite-history', {
    \ 'autoload' : {
    \   'unite_sources' : [
    \     'history/command', 'history/search']}}

  NeoBundleLazy 'tacroe/unite-mark', {
    \ 'autoload' : {'unite_sources' : 'mark'}}

  NeoBundleLazy 'Shougo/unite-outline', {
    \ 'autoload' : {'unite_sources' : 'outline'}}

  NeoBundleLazy 'osyo-manga/unite-qfixhowm', {
    \ 'autoload' : {'unite_sources' : 'qfixhowm'},
    \ 'depends' : 'fuenor/qfixhowm'}

  NeoBundleLazy 'osyo-manga/unite-quickfix', {
    \ 'autoload' : {'unite_sources' : 'quickfix'}}

  NeoBundleLazy 'mattn/unite-remotefile', {
    \ 'autoload' : {'unite_sources' : 'remotefile'}}

  NeoBundleLazy 'Shougo/unite-ssh', {
    \ 'autoload' : {'unite_sources' : 'ssh'}}

  NeoBundleLazy 'Shougo/unite-sudo', {
    \ 'autoload' : {'unite_sources' : 'sudo'}}

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
    \   'explorer' : 1},
    \ 'depends' : 'Shougo/unite.vim'}
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

  NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \   'windows' : join([
    \     $VCVARSALL, $PROCESSOR_ARCHITECTURE, '&',
    \     'nmake -f Make_msvc.mak nodebug=1']),
    \   'cygwin'  : 'make -f make_cygwin.mak',
    \   'mac'     : 'make -f make_mac.mak',
    \   'unix'    : 'make -f make_unix.mak'}}

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
    \ 'depends' : [
    \   'Shougo/echodoc',
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
    \   'mappings' : [
    \     ['v', '<Plug>(visualstar-*)'], ['v', '<Plug>(visualstar-g*)'],
    \     ['v', '<Plug>(visualstar-#)'], ['v', '<Plug>(visualstar-g#)']]}}

  NeoBundleLazy 'mattn/zencoding-vim', {
    \ 'autoload' : {
    \   'commands' : 'Zen',
    \   'filetypes' : [
    \     'css', 'css.drupal', 'haml', 'html', 'html.django_template',
    \     'htmldjango', 'less', 'mustache', 'sass', 'scss', 'slim',
    \     'xhtml', 'xml', 'xsl', 'xslt'],
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

" Disable bell
set noerrorbells
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
set backupcopy=yes
set backupdir^=~/.bak
set backupskip+=*.clean
set patchmode=.clean
set suffixes+=.clean

" Swap
set swapfile
if has('win32') || has('win64')
  set directory^=$TEMP,~/.bak
else
  set directory^=$TMPDIR,~/.bak
endif

" Undo persistence
set undofile
set undodir^=~/.bak

" ClipBoard
set clipboard=unnamed

" Timeout
set timeout
set timeoutlen=3000
set ttimeoutlen=100

" Hidden buffer
set hidden

" Multi byte charactor width
set ambiwidth=double

" Wild menu
set wildmenu
set wildignore+=*.clean,.drive.r,.hg,.git,.bzr,.svn

" Shell
if has('win32') || has('win64')
  set shell=sh
  set shellslash
endif

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

" Language
if has('multi_lang')
  silent! language time C
endif

" Conceal
if has('conceal')
  set conceallevel=2
  set concealcursor=nc
endif

if &t_Co > 255
  " Syntax highlight
  syntax on

  " Display cursor line & column
  set cursorline
  set cursorcolumn

  " No cursor line & column at other window
  augroup MyVimrc
    autocmd BufWinEnter,WinEnter *
      \ if !exists('b:nocursorline') || !b:nocursorline |
      \   setlocal cursorline |
      \ endif |
      \ if !exists('b:nocursorcolumn') || !b:nocursorcolumn |
      \   setlocal cursorcolumn |
      \ endif
    autocmd BufWinLeave,WinLeave *
      \ if !exists('b:nocursorline') || !b:nocursorline |
      \   setlocal nocursorline |
      \ endif |
      \ if !exists('b:nocursorcolumn') || !b:nocursorcolumn |
      \   setlocal nocursorcolumn |
      \ endif
  augroup END

  " Colorscheme
  silent! colorscheme molokai
endif
"}}}

"-----------------------------------------------------------------------------
" File Encodings: {{{
if has('multi_byte')
  let s:enc_jisx0213 = has('iconv') &&
    \ iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"

  let &fileencodings = join([
    \ (s:enc_jisx0213 ? 'iso-2022-jp-3' : 'iso-2022-jp'),
    \ 'cp932',
    \ (s:enc_jisx0213 ? 'euc-jisx0213,euc-jp' : 'euc-jp'),
    \ 'ucs-bom'], ',')
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
" Status Line: {{{
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=

" Display encoding & format
if has('multi_byte') && has('iconv')
  function! g:Char2Hex()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &encoding, &fileencoding)
    return s:byte2hex(s:char2byte(c))
  endfunction
  function! s:char2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
  endfunction

  set statusline+=\ [0x%{g:Char2Hex()}]
endif

set statusline+=\ (%v,%l)/%L%8P
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
if executable('ag')
  set grepprg=ag\ --nocolor\ --nogroup\ --hidden\ --ignore-dir=.drive.r\
    \ --ignore-dir=.hg\ --ignore-dir=.git\ --ignore-dir=.bzr\ --ignore-dir=.svn
elseif executable('grep')
  set grepprg=grep\ -Hn
else
  set grepprg=internal
endif
"}}}

"-----------------------------------------------------------------------------
" Editing: {{{
" Complete
set completeopt=menu,menuone
silent! set completeopt+=noselect

" Format
set nrformats=hex
set formatoptions+=m
set formatoptions+=M

" Free cursor
set virtualedit=block

" Cursor can move to bol & eol
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start

" Ctags
set showfulltag

" Default file format
set fileformat=unix
set fileformats=unix,dos,mac

" Indent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set noexpandtab
set autoindent
set smartindent
set cinoptions=:0,l1,g0,(0,U1,Ws,j1,J1,)20

" Indent By FileType
let g:vim_indent_cont = 2

" Folding
set foldenable
set foldmethod=marker
set foldcolumn=2
set foldlevelstart=99
set commentstring=%s

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
"}}}

"=============================================================================
" Mappings: {{{

"-----------------------------------------------------------------------------
" Prefix: {{{
" <Leader> <LocalLeader>
NOXnoremap <Leader>      <Nop>
NOXnoremap <LocalLeader> <Nop>

" Mark
NOXnoremap m <Nop>
nnoremap <M-m> m

" Useless
NXnoremap ;     <Nop>
NXnoremap ,     <Nop>
NXnoremap s     <Nop>
NXnoremap S     <Nop>
nnoremap  <C-G> <Nop>
cnoremap  <C-G> <Nop>
"}}}

"-----------------------------------------------------------------------------
" Moving: {{{
" PageUp, PageDown
NOXnoremap <PageUp>   <C-U>
NOXnoremap <PageDOwn> <C-D>

" Jump
NOXnoremap ' `
NOXnoremap ` '
NOXnoremap gH H
NOXnoremap gM M
NOXnoremap gL L
NOXnoremap <Space> %

" Window Control
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-h> <C-W>h
nnoremap <M-l> <C-W>l
nnoremap <M-J> <C-W>J
nnoremap <M-K> <C-W>K
nnoremap <M-H> <C-W>H
nnoremap <M-L> <C-W>L
nnoremap <M-+> <C-W>+
nnoremap <M--> <C-W>-
nnoremap <M-<> <C-W><
nnoremap <M->> <C-W>>
nnoremap <M-=> <C-W>=

" Insert-mode & Command-line-mode
noremap! <M-j> <Down>
noremap! <M-k> <Up>
noremap! <M-h> <Left>
noremap! <M-l> <Right>

" Insert-mode
inoremap <M-W>      <C-O>W
inoremap <M-B>      <C-O>B
inoremap <M-E>      <C-O>E
inoremap <M-g><M-E> <C-O>gE

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
" BackSpace
nnoremap <BS> X

" Yank at end of line
nnoremap Y y$

" Undo branch
nnoremap <M-u> g-
nnoremap <M-r> g+

" Write File
nnoremap ;w :<C-U>update<CR>
nnoremap ;W :<C-U>wall<CR>

" Start Visual-mode with the same area
onoremap gv :<C-U>normal! gv<CR>

" Start Visual-mode with the last changed area
nnoremap  g[ `[v`]
OXnoremap g[ :<C-U>normal g[<CR>

" Delete at Insert-mode
inoremap <C-W> <C-G>u<C-W>
inoremap <C-U> <C-G>u<C-U>

" Help
nnoremap <expr> <F1>
  \ &columns < 160 ?
  \   ':<C-U>help<Space>' :
  \   ':<C-U>vertical help<Space>'
nnoremap <expr> g<F1>
  \ &columns < 160 ?
  \   ':<C-U>help<Space>' . expand('<cword>') :
  \   ':<C-U>vertical help<Space>' . expand('<cword>')

" Search
nnoremap <Esc><Esc> :<C-U>nohlsearch<CR><Esc>
nnoremap <C-N> :<C-U>global//print<CR>
xnoremap <C-N> :global//print<CR>
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
augroup MyVimrc
  autocmd CmdwinEnter / inoremap <buffer> / \/
  autocmd CmdwinEnter ? inoremap <buffer> ? \?
augroup END

" Search Split Window
if s:cmdwin_enable
  nnoremap <C-W>/  <C-W>sq/
  nnoremap <C-W>?  <C-W>sq?
else
  nnoremap <C-W>/  <C-W>s/
  nnoremap <C-W>?  <C-W>s?
endif
nnoremap <C-W>*  <C-W>s*
nnoremap <C-W>#  <C-W>s#
nnoremap <C-W>g/ <C-W>s*
nnoremap <C-W>g? <C-W>s#
nnoremap <C-W>g* <C-W>sg*
nnoremap <C-W>g# <C-W>sg#
"}}}

"-----------------------------------------------------------------------------
" Subrogation: {{{
" Rot13
NXnoremap <C-G>?  g?
nnoremap  <C-G>?? g??

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

" Unnecessary key
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>
nnoremap gQ gq

" Insert Tab
inoremap <C-T> <C-V><Tab>
"}}}
"}}}

"=============================================================================
" Commands: {{{

"-----------------------------------------------------------------------------
" Change File Format Option: {{{
command!
  \ FfUnix
  \ setlocal modified fileformat=unix
command!
  \ FfDos
  \ setlocal modified fileformat=dos
command!
  \ FfMac
  \ setlocal modified fileformat=mac
"}}}

"-----------------------------------------------------------------------------
" Change File Encoding Option: {{{
if has('multi_byte')
  command!
    \ FencUtf8
    \ setlocal modified fileencoding=utf-8
  command!
    \ FencUtf16le
    \ setlocal modified fileencoding=utf-16le
  command!
    \ FencUtf16
    \ setlocal modified fileencoding=utf-16
  command!
    \ FencCp932
    \ setlocal modified fileencoding=cp932
  command!
    \ FencEucjp
    \ setlocal modified fileencoding=euc-jp
  if s:enc_jisx0213
    command!
      \ FencEucJisx0213
      \ setlocal modified fileencoding=euc-jisx0213
    command!
      \ FencIso2022jp
      \ setlocal modified fileencoding=iso-2022-jp-3
  else
    command!
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
if has('win32') || has('win64')
  function! s:shell_cmd()
    set shell&
    set shellslash&
    set shellcmdflag=/c
    set shellquote=
    let &shellxquote = '('
  endfunction
  command!
    \ ShellCmd
    \ call s:shell_cmd()

  function! s:shell_sh(shell)
    let &shell = len(a:shell) ? a:shell : 'sh'
    set shellslash
    set shellcmdflag=-c
    set shellquote=
    set shellxquote="
  endfunction
  command! -bar -nargs=?
    \ ShellSh
    \ call s:shell_sh(<q-args>)

  function! s:shell_restore()
    let &shell        = s:save_sh
    let &shellslash   = s:save_ssl
    let &shellcmdflag = s:save_shcf
    let &shellquote   = s:save_shq
    let &shellxquote  = s:save_sxq
  endfunction
  command!
    \ ShellRestore
    \ call s:shell_restore()

  function! s:shell_backup()
    let s:save_sh   = &shell
    let s:save_ssl  = &shellslash
    let s:save_shcf = &shellcmdflag
    let s:save_shq  = &shellquote
    let s:save_sxq  = &shellxquote
  endfunction
  autocmd MyVimrc VimEnter *
    \ call s:shell_backup()
endif
"}}}

"-----------------------------------------------------------------------------
" VC Vars: {{{
if exists('$VCVARSALL')
  function! s:vcvarsall(arch)
    let save_sh   = &shell
    let save_ssl  = &shellslash
    let save_shcf = &shellcmdflag
    let save_shq  = &shellquote
    let save_sxq  = &shellxquote
    let save_isi  = &isident
    set shell&
    set shellslash&
    set shellcmdflag=/c
    set shellquote=
    let &shellxquote = '('
    let &isident = join([&insident, '(,)'], ',')
    try
      let env = system(join([$VCVARSALL, a:arch, '&', 'set']))
      for s in split(env, "\n")
        let e = matchlist(s, '\([^=]\+\)=\(.*\)')
        if len(e) > 2
          execute join(['let $', e[1], '=', "'", e[2], "'"], '')
        endif
      endfor
    finally
      let &shell        = save_sh
      let &shellslash   = save_ssl
      let &shellcmdflag = save_shcf
      let &shellquote   = save_shq
      let &shellxquote  = save_sxq
      let &isident      = save_isi
    endtry
  endfunction

  command!
    \ VCVars32
    \ call s:vcvarsall('x86')

  if exists('$PROGRAMFILES(x86)')
    command!
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
command!
  \ CdCurrent
  \ cd %:p:h
command! -nargs=1 -complete=file
  \ Diff
  \ vertical diffsplit <args>
command!
  \ Undiff
  \ setlocal nodiff scrollbind< wrap< cursorbind<

nnoremap ;d :<C-U>CdCurrent<CR>
nnoremap <F12> :<C-U>UnDiff<CR>
"}}}

"-----------------------------------------------------------------------------
" From Example: {{{
command!
  \ DiffOrig
  \ vertical new | setlocal buftype=nofile |
  \ read # | 0d_ | diffthis | wincmd p | diffthis

nnoremap <F9> :<C-U>DiffOrig<CR>
"}}}
"}}}

"=============================================================================
" Vim Script: {{{

"-----------------------------------------------------------------------------
" Script Scope: {{{
function! s:getscrname(expr, name)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return join(['<SNR>', m[1], '_', a:name], '')
      endif
  endfor
endfunction
function! s:getscrfunc(expr, funcname)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return function(join(['<SNR>', m[1], '_', a:funcname], ''))
      endif
  endfor
endfunction
function! s:getscrvar(expr, varname)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        return eval(join(['<SNR>', m[1], '_', a:varname], ''))
      endif
  endfor
endfunction
function! s:setscrvar(expr, varname, val)
  redir => sn
    silent! scriptnames
  redir END
  for l in split(sn, "\n")
      let m = matchlist(l, '^\s*\(\d\+\):\s*\(.*\)$')
      if m[2] =~? a:expr
        execute 'let' join(['<SNR>', m[1], '_', a:varname], '') '=' a:val
        return
      endif
  endfor
endfunction
"}}}

"-----------------------------------------------------------------------------
" Command Line Window: {{{
function! s:cmdwin_enter(mode)
  nnoremap <buffer><silent> q :<C-U>quit<CR>

  for key in keys(s:cmdwin_enter_functions['*'])
    call s:cmdwin_enter_functions['*'][key]()
  endfor
  for key in keys(s:cmdwin_enter_functions[a:mode])
    call s:cmdwin_enter_functions[a:mode][key]()
  endfor

  let s:save_bs = &backspace
  set backspace=
  startinsert!
endfunction
function! s:cmdwin_leave(mode)
  for key in keys(s:cmdwin_leave_functions['*'])
    call s:cmdwin_leave_functions['*'][key]()
  endfor
  for key in keys(s:cmdwin_leave_functions[a:mode])
    call s:cmdwin_leave_functions[a:mode][key]()
  endfor

  let &backspace = s:save_bs
endfunction
function! s:cmdline_enter(mode)
  for key in keys(s:cmdline_enter_functions['*'])
    call s:cmdline_enter_functions['*'][key]()
  endfor
  for key in keys(s:cmdline_enter_functions[a:mode])
    call s:cmdline_enter_functions[a:mode][key]()
  endfor

  return a:mode
endfunction

augroup MyVimrc
  autocmd CmdwinEnter : call s:cmdwin_enter(':')
  autocmd CmdwinLeave : call s:cmdwin_leave(':')
  autocmd CmdwinEnter / call s:cmdwin_enter('/')
  autocmd CmdwinLeave / call s:cmdwin_leave('/')
  autocmd CmdwinEnter ? call s:cmdwin_enter('?')
  autocmd CmdwinLeave ? call s:cmdwin_leave('?')
  autocmd CmdwinEnter > call s:cmdwin_enter('>')
  autocmd CmdwinLeave > call s:cmdwin_leave('>')
  autocmd CmdwinEnter @ call s:cmdwin_enter('@')
  autocmd CmdwinLeave @ call s:cmdwin_leave('@')
  autocmd CmdwinEnter - call s:cmdwin_enter('-')
  autocmd CmdwinLeave - call s:cmdwin_leave('-')
  autocmd CmdwinEnter = call s:cmdwin_enter('=')
  autocmd CmdwinLeave = call s:cmdwin_leave('=')
augroup END

if s:cmdwin_enable
  NXnoremap : q:
  NXnoremap / q/
  NXnoremap ? q?

  NXnoremap <expr> ;: <SID>cmdline_enter(':')
  NXnoremap <expr> ;/ <SID>cmdline_enter('/')
  NXnoremap <expr> ;? <SID>cmdline_enter('?')
else
  NXnoremap <expr> : <SID>cmdline_enter(':')
  NXnoremap <expr> / <SID>cmdline_enter('/')
  NXnoremap <expr> ? <SID>cmdline_enter('?')
endif

NXmap ;; :
"}}}

"-----------------------------------------------------------------------------
" Auto Mark: {{{
let s:mark_char = [
  \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

function! s:init_mark()
  if !exists('b:mark_pos')
    try
      silent execute 'marks' join(s:mark_char, '')
    catch /^Vim\%((\a\+)\)\?:E283/
      return
    endtry

    for c in range(len(s:mark_char))
      try
        silent execute 'marks' s:mark_char[c]
      catch /^Vim\%((\a\+)\)\?:E283/
        let b:mark_pos = c
        return
      endtry
    endfor
  endif
endfunction
function! s:auto_mark()
  if !exists('b:mark_pos')
    let b:mark_pos = 0
  endif
  let cmd = join(['mark', s:mark_char[b:mark_pos]])
  echo "\r:" . cmd
  execute cmd
  let b:mark_pos = (b:mark_pos + 1) % len(s:mark_char)
endfunction
function! s:clear_marks()
  let cmd = 'delmarks!'
  echo "\r:" . cmd
  execute cmd
endfunction

function! s:init_file_mark()
  if !exists('s:file_mark_pos')
    try
      silent execute 'marks' toupper(join(s:mark_char, ''))
    catch /^Vim\%((\a\+)\)\?:E283/
      return
    endtry

    for c in range(len(s:mark_char))
      try
        silent execute 'marks' toupper(s:mark_char[c])
      catch /^Vim\%((\a\+)\)\?:E283/
        let s:file_mark_pos = c
        return
      endtry
    endfor
  endif
endfunction
function! s:auto_file_mark()
  if !exists('s:file_mark_pos')
    let s:file_mark_pos = 0
  endif
  let cmd = join(['mark', toupper(s:mark_char[s:file_mark_pos])])
  echo "\r:" . cmd
  execute cmd
  let s:file_mark_pos = (s:file_mark_pos + 1) % len(s:mark_char)
endfunction
function! s:clear_file_marks()
  rviminfo
  let cmd = join(['delmarks', toupper(s:mark_char[s:file_mark_pos])])
  echo "\r:" . cmd
  execute cmd
  wviminfo!
endfunction

augroup MyVimrc
  autocmd BufRead *
    \ call s:init_mark()
  autocmd VimEnter *
    \ call s:init_file_mark()
augroup END

nnoremap <silent> mm :<C-U>call <SID>auto_mark()<CR>
nnoremap <silent> mc :<C-U>call <SID>clear_marks()<CR>
nnoremap <silent> mM :<C-U>call <SID>auto_file_mark()<CR>
nnoremap <silent> mC :<C-U>call <SID>clear_file_marks()<CR>
"}}}

"-----------------------------------------------------------------------------
" Smart BOL, EOL: {{{
function! s:smart_bol()
  let col = col('.')
  execute 'normal!'
    \ col <= 1 || col > match(getline('.'), '^\s*\zs') + 1 ?
    \   '^' :
    \   '0'
endfunction
function! s:smart_eol()
  execute 'normal!'
    \ col('.') < col('$') - 1 ?
    \   '$' :
    \   'g_'
endfunction

NOXnoremap <silent> H :<C-U>call <SID>smart_bol()<CR>
NOXnoremap <silent> L :<C-U>call <SID>smart_eol()<CR>
inoremap <silent> <M-H> <C-O>:<C-U>call <SID>smart_bol()<CR>
inoremap <silent> <M-L> <C-O>:<C-U>call <SID>smart_eol()<CR>
"}}}

"-----------------------------------------------------------------------------
" Substitute: {{{
if s:cmdwin_enable
  xnoremap <expr> s/
    \ 'q:s//gc<Left><Left><Left>'

  nnoremap <expr> s?
    \ 'q:<C-U>1,s//gc<Left><Left><Left>'
  nnoremap <expr> s#
    \ 'q:<C-U>1,s/\<' . expand('<cword>') . '\>//gc<Left><Left><Left>'
  nnoremap <expr> sg#
    \ 'q:<C-U>1,s/' . expand('<cword>') . '//gc<Left><Left><Left>'

  nnoremap <expr> s/
    \ 'q:<C-U>,$s//gc<Left><Left><Left>'
  nnoremap <expr> s*
    \ 'q:<C-U>,$s/\<' . expand('<cword>') . '\>//gc<Left><Left><Left>'
  nnoremap <expr> sg*
    \ 'q:<C-U>,$s/' . expand('<cword>') . '//gc<Left><Left><Left>'

  nnoremap <expr> sa/
    \ 'q:<C-U>argdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sa*
    \ 'q:<C-U>argdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> sag*
    \ 'q:<C-U>argdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> sb/
    \ 'q:<C-U>bufdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sb*
    \ 'q:<C-U>bufdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> sbg*
    \ 'q:<C-U>bufdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> st/
    \ 'q:<C-U>tabdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> st*
    \ 'q:<C-U>tabdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> stg*
    \ 'q:<C-U>tabdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> sw/
    \ 'q:<C-U>windo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sw*
    \ 'q:<C-U>windo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> swg*
    \ 'q:<C-U>windo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'
else
  xnoremap <expr> s/
    \ ':s//gc<Left><Left><Left>'

  nnoremap <expr> s?
    \ ':<C-U>1,s//gc<Left><Left><Left>'
  nnoremap <expr> s#
    \ ':<C-U>1,s/\<' . expand('<cword>') . '\>//gc<Left><Left><Left>'
  nnoremap <expr> sg#
    \ ':<C-U>1,s/' . expand('<cword>') . '//gc<Left><Left><Left>'

  nnoremap <expr> s/
    \ ':<C-U>,$s//gc<Left><Left><Left>'
  nnoremap <expr> s*
    \ ':<C-U>,$s/\<' . expand('<cword>') . '\>//gc<Left><Left><Left>'
  nnoremap <expr> sg*
    \ ':<C-U>,$s/' . expand('<cword>') . '//gc<Left><Left><Left>'

  nnoremap <expr> sa/
    \ ':<C-U>argdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sa*
    \ ':<C-U>argdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> sag*
    \ ':<C-U>argdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> sb/
    \ ':<C-U>bufdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sb*
    \ ':<C-U>bufdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> sbg*
    \ ':<C-U>bufdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> st/
    \ ':<C-U>tabdo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> st*
    \ ':<C-U>tabdo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> stg*
    \ ':<C-U>tabdo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'

  nnoremap <expr> sw/
    \ ':<C-U>windo %s//gce<Left><Left><Left><Left>'
  nnoremap <expr> sw*
    \ ':<C-U>windo %s/\<' . expand('<cword>') . '\>//gce<Left><Left><Left><Left>'
  nnoremap <expr> swg*
    \ ':<C-U>windo %s/' . expand('<cword>') . '//gce<Left><Left><Left><Left>'
endif

nmap sg?  s#
nmap sg/  s*
nmap sag/ sa*
nmap sbg/ sb*
nmap stg/ st*
nmap swg/ sw*

xnoremap sn  :s gc<CR>
nnoremap sN  :<C-U>1,s gc<CR>
nnoremap sn  :<C-U>,$s gc<CR>
nnoremap san :<C-U>argdo %s gce<CR>
nnoremap sbn :<C-U>bufdo %s gce<CR>
nnoremap stn :<C-U>tabdo %s gce<CR>
nnoremap swn :<C-U>windo %s gce<CR>
"}}}

"-----------------------------------------------------------------------------
" Make Searching Directions Consistent: {{{
function! s:search_forward_p()
  return exists('v:searchforward') ? v:searchforward : 1
endfunction

NXnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
NXnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
onoremap  <expr> n <SID>search_forward_p() ? 'n' : 'N'
onoremap  <expr> N <SID>search_forward_p() ? 'N' : 'n'
"}}}

"-----------------------------------------------------------------------------
" Insert One Character: {{{
function! s:keys_to_insert_one_character()
  echohl ModeMsg
  if v:lang =~? '^ja'
    echo '-- 挿入 (1文字) --'
  else
    echo '-- INSERT (one char) --'
  endif
  echohl None
  return nr2char(getchar()) . "\<Esc>"
endfunction
nnoremap <M-a> a<C-R>=<SID>keys_to_insert_one_character()<CR>
nnoremap <M-A> A<C-R>=<SID>keys_to_insert_one_character()<CR>
nnoremap <M-i> i<C-R>=<SID>keys_to_insert_one_character()<CR>
nnoremap <M-I> I<C-R>=<SID>keys_to_insert_one_character()<CR>
"}}}

"-----------------------------------------------------------------------------
" Windows Symlink Fix: {{{
if has('win32') || has('win64')
  augroup MyVimrc
    autocmd BufWritePre,FileWritePre,FileAppendPre *
      \ if filewritable(expand('%')) |
      \   let b:save_ar = &l:autoread |
      \ endif

    autocmd BufWritePost,FileWritePost,FileAppendPost *
      \ if exists('b:save_ar') |
      \   setlocal autoread |
      \   if s:has_vimproc() |
      \     call vimproc#system(join(['attrib -R', expand('%:p')])) |
      \   else |
      \     call system(join(['attrib -R', expand('%:p')])) |
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
  let hl = substitute(hl, "[\r\n]", ' ', 'g')
  return matchstr(hl, 'xxx\zs.*$')
endfunction

function! s:reverse_highlight(hl)
  function! l:reversing(hl, name)
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

  return join([a:hl,
    \ 'term='  . l:reversing(a:hl, 'term'),
    \ 'cterm=' . l:reversing(a:hl, 'cterm'),
    \ 'gui='   . l:reversing(a:hl, 'gui')])
endfunction
"}}}

"-----------------------------------------------------------------------------
" Reverse Status Line Color At Insert Mode: {{{
function! s:init_status_line_color()
  silent! let s:hi_status_line   = s:get_highlight('StatusLine')
  silent! let s:hi_status_line_i = s:reverse_highlight(s:hi_status_line)
endfunction

function! s:change_status_line_color(is_enter)
  if !exists('s:hi_status_line') || !exists('s:hi_status_line_i')
    call s:init_status_line_color()
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
    \ call s:init_status_line_color()
  autocmd InsertEnter *
    \ call s:change_status_line_color(1)
  autocmd InsertLeave *
    \ call s:change_status_line_color(0)
augroup END
"}}}

"-----------------------------------------------------------------------------
" Highlight Ideographic Space: {{{
function! s:init_ideographic_space()
  silent! let s:hi_ideographic_space = join([
    \ s:get_highlight('SpecialKey'),
    \ 'term=underline cterm=underline gui=underline'])
endfunction

function! s:set_ideographic_space()
  if !exists('s:hi_ideographic_space')
    call s:init_ideographic_space()
  endif

  if exists('s:hi_ideographic_space')
    execute 'highlight IdeographicSpace' s:hi_ideographic_space
    syntax match IdeographicSpace "　" display containedin=ALL
  endif
endfunction

augroup MyVimrc
  autocmd ColorScheme *
    \ call s:init_ideographic_space()
  autocmd BufWinEnter *
    \ call s:set_ideographic_space()
augroup END
"}}}

"-----------------------------------------------------------------------------
" From Example: {{{
autocmd MyVimrc BufRead *
  \ if line("'\"") > 1 && line("'\"") <= line('$') |
  \   execute 'normal! g`"' |
  \ endif
"}}}
"}}}

"=============================================================================
" Plugins: {{{

"-----------------------------------------------------------------------------
" Built In Plugins: {{{
" Assembler
let g:asmsyntax = 'masm'
" let g:asmsyntax = 'arm'
" let g:asmsyntax = 'z80'

" Shell Script
let g:is_bash = 1

" Unnecessary plugin
let g:loaded_getscriptPlugin = 1
let g:loaded_netrwPlugin     = 1
let g:loaded_vimballPlugin   = 1

" FileType Detect
augroup MyVimrc
  autocmd BufNewFile,BufRead *.c
    \ setfiletype cpp
  autocmd BufNewFile,BufRead *.txt,*.text
    \ setfiletype hybrid
  autocmd BufNewFile,BufRead *.md
    \ setfiletype markdown
  autocmd BufNewFile,BufRead *.vb
    \ setfiletype vbnet
augroup END

" Enable plugin
filetype plugin indent on
"}}}

"-----------------------------------------------------------------------------
" AlterCommand: {{{
silent! let s:bundle = neobundle#get('altercmd')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    call altercmd#load()
    for [key, value] in items(s:altercmd_define)
      execute 'CAlterCommand' key value
    endfor
  endfunction

  function! s:cmdwin_enter_functions[':'].AlterCommand()
    for [key, value] in items(s:altercmd_define)
      execute 'IAlterCommand <buffer>' key value
    endfor
  endfunction

  function! s:cmdline_enter_functions[':'].AlterCommand()
    NeoBundleSource altercmd
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Altr: {{{
silent! let s:bundle = neobundle#get('altr')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  nmap <F2>  <Plug>(altr-forward)
  nmap g<F2> <Plug>(altr-back)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" AutoDate: {{{
silent! let s:bundle = neobundle#get('autodate')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:autodate_lines        = 10
    let g:autodate_format       = '%Y-%m-%d %H:%M:%S DeaR'
    let g:autodate_keyword_post = '[>".]'
    let g:autodate_keyword_pre  = join([
      \ '\c\%(@\?time[-[:space:]]*stamp\s*:\?\|',
      \ 'Last\s*\%(Changed\?\|Updated\?\|Modified\)\s*:\)\s\+[<"]\?'], '')
  endfunction

  autocmd MyVimrc BufUnload,FileWritePre,BufWritePre *
    \ NeoBundleSource autodate
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" AutoFmt: {{{
silent! let s:bundle = neobundle#get('autofmt')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  set formatexpr=autofmt#japanese#formatexpr()
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" CamelCaseMotion: {{{
silent! let s:bundle = neobundle#get('camelcasemotion')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NOXmap ,w  <Plug>CamelCaseMotion_w
  NOXmap ,b  <Plug>CamelCaseMotion_b
  NOXmap ,e  <Plug>CamelCaseMotion_e
  NOXmap g,e <Plug>CamelCaseMotion_ge

  OXmap i,w <Plug>CamelCaseMotion_iw
  OXmap i,b <Plug>CamelCaseMotion_ib
  OXmap i,e <Plug>CamelCaseMotion_ie

  inoremap <silent> <M-,><M-w>
    \ <C-O>:<C-U>call camelcasemotion#Motion('w', v:count1, 'n')<CR>
  inoremap <silent> <M-,><M-b>
    \ <C-O>:<C-U>call camelcasemotion#Motion('b', v:count1, 'n')<CR>
  inoremap <silent> <M-,><M-e>
    \ <C-O>:<C-U>call camelcasemotion#Motion('e', v:count1, 'n')<CR>
  inoremap <silent> <M-,><M-g><M-e>
    \ <C-O>:<C-U>call camelcasemotion#Motion('ge', v:count1, 'n')<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Clang Complete: {{{
silent! let s:bundle = neobundle#get('clang_complete')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:clang_complete_auto          = 0
    let g:clang_auto_select            = 0
    let g:clang_user_options           = '-w'
    let g:clang_jumpto_declaration_key = '<LocalLeader><C-]>'
    let g:clang_jumpto_back_key        = '<LocalLeader><C-T>'

    if has('win64')
      if filereadable(expand('~/bin64/libclang.dll'))
        let g:clang_library_path = expand('~/bin64')
      endif
    elseif has('win32')
      if filereadable(expand('~/bin/libclang.dll'))
        let g:clang_library_path = expand('~/bin')
      endif
    else
      if filereadable(expand('~/lib/libclang.so'))
        let g:clang_library_path = expand('~/lib')
      elseif filereadable(expand('/usr/local/lib/libclang.so'))
        let g:clang_library_path = expand('/usr/local/lib')
      elseif filereadable(expand('/usr/lib/libclang.so'))
        let g:clang_library_path = expand('/usr/lib')
      endif
    endif
    if exists('g:clang_library_path') && len(g:clang_library_path)
      let g:clang_use_library = 1
    endif

    if has('win32') || has('win64')
      let $PATH = join([substitute(a:bundle.path, '/', '\\', 'g'), '\bin;', $PATH], '')
    else
      let $PATH = join([a:bundle.path, '/bin:', $PATH], '')
    endif
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
    function s:clang_complete_init_2(ext)
      silent! iunmap <buffer> <C-X><C-U>
      silent! iunmap <buffer> .
      silent! iunmap <buffer> >
      silent! iunmap <buffer> :

      if neobundle#is_installed('vim-smartchr')
        " from ~/.vim/bundle-settings/vim-smartchr/*.vim
        inoremap <buffer><expr> >
          \ search('\V ->\? \%#', 'bcn') ?
          \   smartchr#one_of(' - ', '->', ' -> ') :
          \   search('\V->\?\%#', 'bcn') ?
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
    doautocmd MyVimrc FileType
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:clever_f_not_overwrites_standard_mappings = 1
  endfunction

  NOXmap f <Plug>(clever-f-f)
  NOXmap F <Plug>(clever-f-F)
  NOXmap t <Plug>(clever-f-t)
  NOXmap T <Plug>(clever-f-T)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ColumnJump: {{{
silent! let s:bundle = neobundle#get('columnjump')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  nmap <C-K> <Plug>(columnjump-backward)zz
  nmap <C-J> <Plug>(columnjump-forward)zz
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" EchoDoc: {{{
silent! let s:bundle = neobundle#get('echodoc')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    call echodoc#enable()
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Fold Balloon: {{{
silent! let s:bundle = neobundle#get('foldballoon')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  set ballooneval
  set balloonexpr=foldballoon#balloonexpr()
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Gitv: {{{
silent! let s:bundle = neobundle#get('gitv')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    call fugitive#detect(expand('%:p'))
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Grex: {{{
silent! let s:bundle = neobundle#get('grex')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NXmap sd <Plug>(operator-grex-delete)
  NXmap sy <Plug>(operator-grex-yank)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" GUndo: {{{
silent! let s:bundle = neobundle#get('gundo')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    if has('python3')
      let g:gundo_prefer_python3 = 1
    endif
  endfunction

  nnoremap <Leader>u :<C-U>GundoToggle<CR>
else
  nnoremap <Leader>u :<C-U>undolist<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" IndentLine: {{{
silent! let s:bundle = neobundle#get('indentLine')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:indentLine_char     = '|'
    let g:indentLine_maxLines = 10000

    function! s:init_indent_line_color()
      let hi_special_key          = s:get_highlight('SpecialKey')
      let g:indentLine_color_term = matchstr(hi_special_key, 'ctermfg=\zs\S\+')
      let g:indentLine_color_gui  = matchstr(hi_special_key, 'guifg=\zs\S\+')
    endfunction
    call s:init_indent_line_color()

    augroup MyVimrc
      autocmd ColorScheme *
        \ call s:init_indent_line_color()
      autocmd InsertEnter,InsertLeave *
        \ if !exists("b:indentLine_enabled") || b:indentLine_enabled |
        \   execute 'IndentLinesReset' |
        \ endif
    augroup END
  endfunction

  function! s:cmdwin_enter_functions['*'].IndentLine()
    let b:indentLine_enabled = 0
  endfunction

  autocmd MyVimrc FileType *
    \ let b:indentLine_enabled = &expandtab
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Jedi: {{{
silent! let s:bundle = neobundle#get('jedi')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:jscomplete_use = ['dom', 'moz', 'xpcom', 'es6th']
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Kwbdi: {{{
silent! let s:bundle = neobundle#get('kwbdi')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  nmap ;c <Plug>Kwbd
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" MapList: {{{
silent! let s:bundle = neobundle#get('maplist')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:maplist_mode_length  = 4
    let g:maplist_key_length   = 60
    let g:maplist_local_length = 2
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Narrow: {{{
silent! let s:bundle = neobundle#get('narrow')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  xnoremap <Leader>n :Narrow<CR>
  nnoremap <Leader>w :Widen<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" NeoBundle: {{{
silent! let s:bundle = neobundle#get('neobundle')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:neobundle_git_gc(names)
    let names   = split(a:names)
    let bundles =
      \ empty(names) ?
      \   neobundle#config#get_neobundles() :
      \   neobundle#config#search(names)

    let cwd = getcwd()
    try
      for bundle in bundles
        if bundle.type != 'git'
          continue
        endif
        if isdirectory(bundle.path)
          lcd `=bundle.path`
        endif
        if s:has_vimproc()
          call vimproc#system('git gc')
        else
          call system('git gc')
        endif
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:neocomplcache_enable_at_startup            = 1
    let g:neocomplcache_enable_auto_select           = 0
    let g:neocomplcache_enable_auto_delimiter        = 1
    let g:neocomplcache_min_keyword_length           = 1
    let g:neocomplcache_min_syntax_length            = 1
    let g:neocomplcache_enable_camel_case_completion = 0
    let g:neocomplcache_enable_underbar_completion   = 0
    let g:neocomplcache_enable_fuzzy_completion      = 0
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:neocomplcache_temporary_dir                =
      \ expand('~/.local/.neocomplcache')

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

    inoremap <expr> <BS>  neocomplcache#smart_close_popup() . '<BS>'
    inoremap <expr> <C-G> neocomplcache#undo_completion()
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

    call neocomplcache#initialize()
  endfunction

  function! s:cmdwin_enter_functions['*'].NeoComplCache()
    let b:neocomplcache_sources_list = []

    inoremap <buffer><expr> <CR> neocomplcache#close_popup() . '<CR>'
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
    inoremap <buffer><silent><expr> <BS>
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   neocomplcache#smart_close_popup() . '<BS>'

    NeoBundleSource neocomplcache
  endfunction

  function! s:cmdwin_enter_functions[':'].NeoComplCache()
    let b:neocomplcache_sources_list = ['vim_complete']
  endfunction

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

"-----------------------------------------------------------------------------
" NeoComplete: {{{
silent! let s:bundle = neobundle#get('neocomplete')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_auto_select           = 0
    let g:neocomplete#enable_auto_delimiter        = 1
    let g:neocomplete#min_keyword_length           = 1
    let g:neocomplete#syntax#min_keyword_length    = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#data_directory               =
      \ expand('~/.local/.neocomplete')

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
      \ '_', 'matchers',  ['matcher_head'])
    call neocomplete#custom#source(
      \ 'syntax_complete', 'rank',  9)
    call neocomplete#custom#source(
      \ 'snippets_complete', 'rank', 80)

    inoremap <expr> <BS>  neocomplete#smart_close_popup() . '<BS>'
    inoremap <expr> <C-G> neocomplete#undo_completion()
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

    call neocomplete#initialize()
  endfunction

  function! s:cmdwin_enter_functions['*'].NeoComplete()
    let b:neocomplete_sources = []

    inoremap <buffer><expr> <CR> neocomplete#close_popup() . '<CR>'
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
    inoremap <buffer><silent><expr> <BS>
      \ col('.') == 1 ?
      \   '<Esc>:quit<CR>' :
      \   neocomplete#smart_close_popup() . '<BS>'

    NeoBundleSource neocomplete
  endfunction

  function! s:cmdwin_enter_functions[':'].NeoComplete()
    let b:neocomplete_sources = ['vim']
  endfunction

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

"-----------------------------------------------------------------------------
" NeoSnippet: {{{
silent! let s:bundle = neobundle#get('neosnippet')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:neosnippet#snippets_directory = expand('~/.vim/snippets')
    if !exists('g:neosnippet#disable_runtime_snippets')
      let g:neosnippet#disable_runtime_snippets = {}
    endif
    let g:neosnippet#disable_runtime_snippets._ = 1

    imap <C-J> <Plug>(neosnippet_expand_or_jump)'
  endfunction

  smap <C-J> <Plug>(neosnippet_expand_or_jump)
  xmap <C-J> <Plug>(neosnippet_expand_target)
else
  inoremap <SID>(Tab) <Tab>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" OmniSharp: {{{
silent! let s:bundle = neobundle#get('Omnisharp')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:OmniSharp_typeLookupInPreview = 0
    let g:OmniSharp_timeout             = 5
  endfunction

  call extend(s:neocompl_force_omni_patterns, {
    \ 'cs' : '[^.[:digit:] *\t]\.'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Camelize: {{{
silent! let s:bundle = neobundle#get('operator-camelize')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NXmap sc <Plug>(operator-camelize)
  NXmap sC <Plug>(operator-decamelize)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator HTML escape: {{{
silent! let s:bundle = neobundle#get('operator-html-escape')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NXmap sh <Plug>(operator-html-escape)
  NXmap sH <Plug>(operator-html-unescape)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Replace: {{{
silent! let s:bundle = neobundle#get('operator-replace')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NXmap ss <Plug>(operator-replace)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Operator Sort: {{{
silent! let s:bundle = neobundle#get('operator-sort')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NXmap sS <Plug>(operator-sort)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ParaJump: {{{
silent! let s:bundle = neobundle#get('parajump')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  nmap { <Plug>(parajump-backward)zz
  nmap } <Plug>(parajump-forward)zz
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" PerlOmni: {{{
silent! let s:bundle = neobundle#get('perlomni')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    if has('win32') || has('win64')
      let $PATH = join([substitute(a:bundle.path, '/', '\\', 'g'), '\bin;', $PATH], '')
    else
      let $PATH = join([a:bundle.path, '/bin:', $PATH], '')
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  call extend(s:neocompl_force_omni_patterns, {
    \ 'php' : '[^.[:digit:] *\t]->\|\h\w*::'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Precious: {{{
silent! let s:bundle = neobundle#get('precious')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_precious_no_default_key_mappings = 1
  endfunction

  OXmap iC <Plug>(textobj-precious-i)

  autocmd MyVimrc FileType *
    \ NeoBundleSource precious
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" QFixHowm: {{{
silent! let s:bundle = neobundle#get('qfixhowm')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:mygrepprg                      = 'internal'
    let g:myjpgrepprg                    = 'agrep.vim'
    let g:QFix_Height                    = 20
    let g:QFix_PreviewHeight             = 20
    let g:MyGrep_MenuBar                 = 0
    let g:MyGrep_MultiEncodingGrepScript = 1
    let g:MyGrep_Resultfile              = expand('~/.local/.qfgrep.txt')
    let g:MyGrep_ExcludeReg              =
      \ '/\.drive\.r/|/\.hg/|/\.git/|/\.bzr/|/\.svn/'

    let g:howm_dir                = expand('~/howm')
    let g:howm_filename           = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
    let g:howm_fileformat         = 'unix'
    let g:qfixmemo_menubar        = 0
    let g:QFixHowm_Menufile       = '0000-00-01-000000.howm'
    let g:QFixHowm_MenuHeight     = 20
    let g:QFixHowm_keywordfile    = expand('~/howm/.howm-keys')
    let g:QFixHowm_RandomWalkFile = expand('~/.local/.howm-random')
    let g:QFixHowm_VimEnterFile   = expand('~/.local/.vimenter.qf')
    let g:QFixMRU_Filename        = expand('~/.local/.qfixmru')
    if has('multi_byte')
      let g:howm_fileencoding = 'cp932'
    endif
  endfunction

  nnoremap <silent> <C-W>, :<C-U>ToggleQFixWin<CR>
  nnoremap <silent> <C-W>. :<C-U>MoveToQFixWin<CR>
  nnoremap <silent> <C-W>0 :<C-U>ToggleLocationListMode<CR>
  " nnoremap <silent> <C-W>/ :<C-U>ToggleLocationListMode<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" QuickRun: {{{
silent! let s:bundle = neobundle#get('quickrun')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:quickrun_no_default_key_mappings = 1

    let s:hook = {
      \ 'name' : 'vcvarsall',
      \ 'kind' : 'hook',
      \ 'config' : {
      \   'enable' : 0,
      \   'bat' : ''}}
    function! s:hook.on_module_loaded(session, context)
      if type(a:session.config.exec) == type([])
        let a:session.config.exec[0] = join([
          \ self.config.bat,
          \ $PROCESSOR_ARCHITECTURE,
          \ '\&',
          \ a:session.config.exec[0]])
      else
        let a:session.config.exec = join([
          \ self.config.bat,
          \ $PROCESSOR_ARCHITECTURE,
          \ '\&',
          \ a:session.config.exec])
      endif
    endfunction
    call quickrun#module#register(s:hook, 1)
    unlet s:hook

    if !exists('g:quickrun_config')
      let g:quickrun_config = {}
    endif
    if !exists('g:quickrun_config._')
      let g:quickrun_config._ = {}
    endif

    if s:has_vimproc()
      call extend(g:quickrun_config._, {
        \ 'runner' : 'vimproc',
        \ 'runner/vimproc/updatetime' : 100})
    endif

    if exists('$VCVARSALL')
      call extend(g:quickrun_config, {
        \ 'c' : {
        \   'type' : 'c/vc'},
        \ 'c/vc' : {
        \   'command' : 'cl',
        \   'exec' : [
        \     '%c %o %s /nologo /Fo%s:p:r.obj /Fe%s:p:r.exe',
        \     '%s:p:r.exe %a'],
        \   'tempfile' : '%{tempname()}.c',
        \   'hook/output_encode/encoding' : 'cp932',
        \   'hook/sweep/files' : ['%s:p:r.exe', '%s:p:r.obj'],
        \   'hook/vcvarsall/enable' : 1,
        \   'hook/vcvarsall/bat' : $VCVARSALL},
        \
        \ 'cpp' : {
        \   'type' : 'cpp/vc'},
        \ 'cpp/vc' : {
        \   'command' : 'cl',
        \   'exec' : [
        \     '%c %o %s /nologo /Fo%s:p:r.obj /Fe%s:p:r.exe',
        \     '%s:p:r.exe %a'],
        \   'tempfile' : '%{tempname()}.cpp',
        \   'hook/output_encode/encoding' : 'cp932',
        \   'hook/sweep/files' : ['%s:p:r.exe', '%s:p:r.obj'],
        \   'hook/vcvarsall/enable' : 1,
        \   'hook/vcvarsall/bat' : $VCVARSALL},
        \
        \ 'cs' : {
        \   'type' : 'cs/csc'},
        \ 'cs/csc' : {
        \   'command' : 'csc',
        \   'exec' : [
        \     '%c /nologo /out:%s:p:r.exe %s',
        \     '%s:p:r.exe %a'],
        \   'tempfile' : '%{tempname()}.cs',
        \   'hook/output_encode/encoding' : 'cp932',
        \   'hook/sweep/files' : ['%s:p:r.exe'],
        \   'hook/vcvarsall/enable' : 1,
        \   'hook/vcvarsall/bat' : $VCVARSALL},
        \
        \ 'vbnet' : {
        \   'type' : 'vbnet/vbc'},
        \ 'vbnet/vbc' : {
        \   'command' : 'vbc',
        \   'exec' : [
        \     '%c /nologo /out:%s:p:r.exe %s',
        \     '%s:p:r.exe %a'],
        \   'tempfile' : '%{tempname()}.vb',
        \   'hook/output_encode/encoding' : 'cp932',
        \   'hook/sweep/files' : ['%s:p:r.exe'],
        \   'hook/vcvarsall/enable' : 1,
        \   'hook/vcvarsall/bat' : $VCVARSALL}})
    endif
  endfunction

  nmap <silent> <F5> <Plug>(quickrun)
  nnoremap <expr><silent> <C-C>
    \ quickrun#is_running() ?
    \   quickrun#sweep_sessions() :
    \   '<C-C>'
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Ref: {{{
silent! let s:bundle = neobundle#get('ref')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:ref_no_default_key_mappings = 1
    let g:ref_cache_dir               = expand('~/local/.vim_ref_cache')
  endfunction

  NXmap <silent> K <Plug>(ref-keyword)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Ruby: {{{
silent! let s:bundle = neobundle#get('ruby')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  call extend(s:neocompl_force_omni_patterns, {
    \ 'ruby' : '[^.[:digit:] *\t]\.\|\h\w*::'})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SaveVers: {{{
silent! let s:bundle = neobundle#get('savevers')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:savevers_max          = 99
    let g:savevers_dirs         = &backupdir
    let g:savevers_hierarchical = 1
    let g:versdiff_no_resize    = 1
  endfunction

  nnoremap <F10> :<C-U>VersDiff -<CR>
  nnoremap <F11> :<C-U>VersDiff +<CR>

  autocmd MyVimrc BufNewFile,BufRead *
    \ NeoBundleSource savevers
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SmartChr: {{{
silent! let s:bundle = neobundle#get('smartchr')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:cmdwin_enter_functions['*'].SmartChr()
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
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" SmartWord: {{{
silent! let s:bundle = neobundle#get('smartword')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  NOXmap w  <Plug>(smartword-w)
  NOXmap b  <Plug>(smartword-b)
  NOXmap e  <Plug>(smartword-e)
  NOXmap ge <Plug>(smartword-ge)

  inoremap <silent> <M-w>
    \ <C-O>:<C-U>call smartword#move('w', 'n')<CR>
  inoremap <silent> <M-b>
    \ <C-O>:<C-U>call smartword#move('b', 'n')<CR>
  inoremap <silent> <M-e>
    \ <C-O>:<C-U>call smartword#move('e', 'n')<CR>
  inoremap <silent> <M-g><M-e>
    \ <C-O>:<C-U>call smartword#move('ge', 'n')<CR>
else
  inoremap <M-w>      <C-O>w
  inoremap <M-b>      <C-O>b
  inoremap <M-e>      <C-O>e
  inoremap <M-g><M-e> <C-O>ge
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Surround: {{{
silent! let s:bundle = neobundle#get('surround')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
      \  'august', 'september', 'october', 'november', 'december'],
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

    call extend(g:switch_increment_definitions, [
      \ {'\C\(-\?\d*0\)TH' : '\=(submatch(1) + 1) . "ST"',
      \  '\C\(-\?\d*1\)ST' : '\=(submatch(1) + 1) . "ND"',
      \  '\C\(-\?\d*2\)ND' : '\=(submatch(1) + 1) . "RD"',
      \  '\C\(-\?\d*3\)RD' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*4\)TH' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*5\)TH' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*6\)TH' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*7\)TH' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*8\)TH' : '\=(submatch(1) + 1) . "TH"',
      \  '\C\(-\?\d*9\)TH' : '\=(submatch(1) + 1) . "TH"'},
      \ {'\C\(-\?\d*0\)th' : '\=(submatch(1) + 1) . "st"',
      \  '\C\(-\?\d*1\)st' : '\=(submatch(1) + 1) . "nd"',
      \  '\C\(-\?\d*2\)nd' : '\=(submatch(1) + 1) . "rd"',
      \  '\C\(-\?\d*3\)rd' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*4\)th' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*5\)th' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*6\)th' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*7\)th' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*8\)th' : '\=(submatch(1) + 1) . "th"',
      \  '\C\(-\?\d*9\)th' : '\=(submatch(1) + 1) . "th"'}])

    call extend(g:switch_decrement_definitions, [
      \ {'\C\(-\?\d*0\)TH' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*1\)ST' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*2\)ND' : '\=(submatch(1) - 1) . "ST"',
      \  '\C\(-\?\d*3\)RD' : '\=(submatch(1) - 1) . "ND"',
      \  '\C\(-\?\d*4\)TH' : '\=(submatch(1) - 1) . "RD"',
      \  '\C\(-\?\d*5\)TH' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*6\)TH' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*7\)TH' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*8\)TH' : '\=(submatch(1) - 1) . "TH"',
      \  '\C\(-\?\d*9\)TH' : '\=(submatch(1) - 1) . "TH"'},
      \ {'\C\(-\?\d*0\)th' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*1\)st' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*2\)nd' : '\=(submatch(1) - 1) . "st"',
      \  '\C\(-\?\d*3\)rd' : '\=(submatch(1) - 1) . "nd"',
      \  '\C\(-\?\d*4\)th' : '\=(submatch(1) - 1) . "rd"',
      \  '\C\(-\?\d*5\)th' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*6\)th' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*7\)th' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*8\)th' : '\=(submatch(1) - 1) . "th"',
      \  '\C\(-\?\d*9\)th' : '\=(submatch(1) - 1) . "th"'}])
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

  nnoremap <silent> <C-A> :<C-U>call <SID>switch('+')<CR>
  nnoremap <silent> <C-X> :<C-U>call <SID>switch('-')<CR>

  autocmd MyVimrc VimEnter,BufNewFile,BufRead *
    \ let b:switch_no_builtins = 1
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TComment: {{{
silent! let s:bundle = neobundle#get('tcomment_vim')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:tcommentTextObjectInlineComment = ''
  endfunction

  function! s:bundle.hooks.on_post_source(bundle)
    if s:cmdwin_enable
      noremap  <C-_><Space> q:TComment<Space>
      inoremap <C-_><Space> <C-O>q:TComment<Space>
      noremap  <C-_>a       q:TCommentAs<Space>
      inoremap <C-_>a       <C-O>q:TCommentAs<Space>
      noremap  <C-_>n       q:TCommentAs <C-R>=&ft<CR><Space>
      inoremap <C-_>n       <C-O>q:TCommentAs <C-R>=&ft<CR><Space>
      noremap  <C-_>s       q:TCommentAs <C-R>=&ft<CR>_
      inoremap <C-_>s       <C-O>q:TCommentAs <C-R>=&ft<CR>_
      noremap  <Leader>_<Space> q:TComment<Space>
      noremap  <Leader>_a       q:TCommentAs<Space>
      noremap  <Leader>_n       q:TCommentAs <C-R>=&ft<CR><Space>
      noremap  <Leader>_s       q:TCommentAs <C-R>=&ft<CR>_
    endif
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextManipilation: {{{
silent! let s:bundle = neobundle#get('textmanip')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_comment_no_default_key_mappings = 1
  endfunction

  OXmap ac <Plug>(textobj-comment-a)
  OXmap ic <Plug>(textobj-comment-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Continuous Line: {{{
silent! let s:bundle = neobundle#get('textobj-continuous-line')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_continuous_line_no_default_key_mappings = 1
    let g:textobj_continuous_line_no_default_mappings     = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj DateTime: {{{
silent! let s:bundle = neobundle#get('textobj-datetime')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_datetime_no_default_key_mappings = 1

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
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Diff: {{{
silent! let s:bundle = neobundle#get('textobj-diff')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_diff_no_default_key_mappings = 1

    NOXnoremap <Leader>d <Nop>
    NOXmap <Leader>dfJ <Plug>(textobj-diff-file-N)
    NOXmap <Leader>dfK <Plug>(textobj-diff-file-P)
    NOXmap <Leader>dfj <Plug>(textobj-diff-file-n)
    NOXmap <Leader>dfk <Plug>(textobj-diff-file-p)
    NOXmap <Leader>dJ  <Plug>(textobj-diff-file-N)
    NOXmap <Leader>dK  <Plug>(textobj-diff-file-P)
    NOXmap <Leader>dj  <Plug>(textobj-diff-file-n)
    NOXmap <Leader>dk  <Plug>(textobj-diff-file-p)

    OXnoremap ad <Nop>
    OXmap adH <Plug>(textobj-diff-file)
    OXmap adf <Plug>(textobj-diff-file)
    OXmap adh <Plug>(textobj-diff-hunk)

    OXnoremap id <Nop>
    OXmap idH <Plug>(textobj-diff-file)
    OXmap idf <Plug>(textobj-diff-file)
    OXmap idh <Plug>(textobj-diff-hunk)
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Entrie: {{{
silent! let s:bundle = neobundle#get('textobj-entire')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_entire_no_default_key_mappings = 1
  endfunction

  OXmap ae <Plug>(textobj-entire-a)
  OXmap ie <Plug>(textobj-entire-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Fold: {{{
silent! let s:bundle = neobundle#get('textobj-fold')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_function_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Ifdef: {{{
silent! let s:bundle = neobundle#get('textobj-ifdef')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_ifdef_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj IndBlock: {{{
silent! let s:bundle = neobundle#get('textobj-indblock')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_jabraces_no_default_key_mappings = 1

    OXnoremap aj <Nop>
    OXmap ajb <Plug>(textobj-jabraces-parens-a)
    OXmap aj( <Plug>(textobj-jabraces-parens-a)
    OXmap aj) <Plug>(textobj-jabraces-parens-a)
    OXmap ajB <Plug>(textobj-jabraces-braces-a)
    OXmap aj{ <Plug>(textobj-jabraces-braces-a)
    OXmap aj} <Plug>(textobj-jabraces-braces-a)
    OXmap ajr <Plug>(textobj-jabraces-brackets-a)
    OXmap aj[ <Plug>(textobj-jabraces-brackets-a)
    OXmap aj] <Plug>(textobj-jabraces-brackets-a)
    OXmap aja <Plug>(textobj-jabraces-angles-a)
    OXmap aj< <Plug>(textobj-jabraces-angles-a)
    OXmap aj> <Plug>(textobj-jabraces-angles-a)
    OXmap ajA <Plug>(textobj-jabraces-double-angles-a)
    OXmap ajk <Plug>(textobj-jabraces-kakko-a)
    OXmap ajK <Plug>(textobj-jabraces-double-kakko-a)
    OXmap ajy <Plug>(textobj-jabraces-yama-kakko-a)
    OXmap ajY <Plug>(textobj-jabraces-double-yama-kakko-a)
    OXmap ajt <Plug>(textobj-jabraces-kikkou-kakko-a)
    OXmap ajs <Plug>(textobj-jabraces-sumi-kakko-a)

    OXnoremap ij <Nop>
    OXmap ijb <Plug>(textobj-jabraces-parens-i)
    OXmap ij( <Plug>(textobj-jabraces-parens-i)
    OXmap ij) <Plug>(textobj-jabraces-parens-i)
    OXmap ijB <Plug>(textobj-jabraces-braces-i)
    OXmap ij{ <Plug>(textobj-jabraces-braces-i)
    OXmap ij} <Plug>(textobj-jabraces-braces-i)
    OXmap ijr <Plug>(textobj-jabraces-brackets-i)
    OXmap ij[ <Plug>(textobj-jabraces-brackets-i)
    OXmap ij] <Plug>(textobj-jabraces-brackets-i)
    OXmap ija <Plug>(textobj-jabraces-ingles-i)
    OXmap ij< <Plug>(textobj-jabraces-ingles-i)
    OXmap ij> <Plug>(textobj-jabraces-ingles-i)
    OXmap ijA <Plug>(textobj-jabraces-double-ingles-i)
    OXmap ijk <Plug>(textobj-jabraces-kakko-i)
    OXmap ijK <Plug>(textobj-jabraces-double-kakko-i)
    OXmap ijy <Plug>(textobj-jabraces-yama-kakko-i)
    OXmap ijY <Plug>(textobj-jabraces-double-yama-kakko-i)
    OXmap ijt <Plug>(textobj-jabraces-kikkou-kakko-i)
    OXmap ijs <Plug>(textobj-jabraces-sumi-kakko-i)
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj LastInserted: {{{
silent! let s:bundle = neobundle#get('textobj-lastinserted')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_lastinserted_no_default_key_mappings = 1
  endfunction

  OXmap aU <Plug>(textobj-lastinserted-a)
  OXmap iU <Plug>(textobj-lastinserted-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj LastPat: {{{
silent! let s:bundle = neobundle#get('textobj-lastpat')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_lastpat_no_default_key_mappings = 1
  endfunction

  OXmap a/ <Plug>(textobj-lastpat-n)
  OXmap a? <Plug>(textobj-lastpat-N)
  OXmap i/ <Plug>(textobj-lastpat-n)
  OXmap i? <Plug>(textobj-lastpat-N)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Line: {{{
silent! let s:bundle = neobundle#get('textobj-line')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_line_no_default_key_mappings = 1
  endfunction

  OXmap al <Plug>(textobj-line-a)
  OXmap il <Plug>(textobj-line-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Parameter: {{{
silent! let s:bundle = neobundle#get('textobj-parameter')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_parameter_no_default_key_mappings = 1
  endfunction

  OXmap a,, <Plug>(textobj-parameter-a)
  OXmap i,, <Plug>(textobj-parameter-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj PHP: {{{
silent! let s:bundle = neobundle#get('textobj-php')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_php_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Python: {{{
silent! let s:bundle = neobundle#get('textobj-python')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_python_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj RubyBlock: {{{
silent! let s:bundle = neobundle#get('textobj-rubyblock')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_rubyblock_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Sigil: {{{
silent! let s:bundle = neobundle#get('textobj-sigil')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_sigil_no_default_key_mappings = 1
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Space: {{{
silent! let s:bundle = neobundle#get('textobj-space')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_syntax_no_default_key_mappings = 1
  endfunction

  OXmap ay <Plug>(textobj-syntax-a)
  OXmap iy <Plug>(textobj-syntax-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Underscore: {{{
silent! let s:bundle = neobundle#get('textobj-underscore')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_underscore_no_default_key_mappings = 1
  endfunction

  OXmap a_ <Plug>(textobj-underscore-a)
  OXmap i_ <Plug>(textobj-underscore-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" TextObj Url: {{{
silent! let s:bundle = neobundle#get('textobj-url')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:textobj_url_no_default_key_mappings = 1
  endfunction

  OXmap au <Plug>(textobj-url-a)
  OXmap iu <Plug>(textobj-url-i)
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite: {{{
silent! let s:bundle = neobundle#get('unite')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_data_directory             = expand('~/.local/.unite')
    let g:unite_enable_start_insert        = 1
    let g:unite_winheight                  = 25
    let g:unite_source_history_yank_enable = 1
    let g:unite_source_grep_max_candidates = 200
    let g:unite_cursor_line_highlight      = 'CursorLine'

    if executable('ag')
      let g:unite_source_grep_command       = 'ag'
      let g:unite_source_grep_recursive_opt = ''
      let g:unite_source_grep_default_opts  = join([
        \ '--nocolor --nogroup --hidden --ignore-dir=.drive.r',
        \ '--ignore-dir=.hg --ignore-dir=.git --ignore-dir=.bzr --ignore-dir=.svn'])
    endif

    if !exists('g:unite_source_menu_menus')
      let g:unite_source_menu_menus = {}
    endif

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
    return line('$') > 10000 ? 1 : 0
  endfunction
  function! s:unite_search_forward()
    if s:unite_search_expr()
      Unite line/fast
        \ -buffer-name=search -no-split -start-insert
    else
      Unite line
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_backward()
    if s:unite_search_expr()
      Unite line/fast:backward
        \ -buffer-name=search -no-split -start-insert
    else
      Unite line:backward
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_cword_forward()
    if s:unite_search_expr()
      UniteWithCursorWord line/fast
        \ -buffer-name=search -no-split -start-insert
    else
      UniteWithCursorWord line
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction
  function! s:unite_search_cword_backward()
    if s:unite_search_expr()
      UniteWithCursorWord line/fast:backward
        \ -buffer-name=search -no-split -start-insert
    else
      UniteWithCursorWord line:backward
        \ -buffer-name=search -no-split -start-insert -auto-preview
    endif
  endfunction

  nnoremap ;u <Nop>

  if s:cmdwin_enable
    nnoremap ;uu q:<C-U>Unite<Space>
  else
    nnoremap ;uu :<C-U>Unite<Space>
  endif

  nnoremap <silent> ;um :<C-U>Unite menu<CR>
  nnoremap <silent> ;u<CR> :<C-U>Unite menu:set_ff<CR>
  if has('multi_byte')
    nnoremap <silent> ;ue :<C-U>Unite menu:edit_enc<CR>
    nnoremap <silent> ;uf :<C-U>Unite menu:set_fenc<CR>
  endif

  nnoremap <silent> ;us
    \ :<C-U>Unite source
    \ -buffer-name=help -no-split -start-insert<CR>
  nnoremap <silent> ;u<F1>
    \ :<C-U>Unite help
    \ -buffer-name=help -no-split -start-insert<CR>
  nnoremap <silent> ;ug<F1>
    \ :<C-U>UniteWithCursorWord help
    \ -buffer-name=help -no-split -no-start-insert<CR>

  nnoremap <silent> ;uw
    \ :<C-U>Unite window
    \ -buffer-name=files -no-split<CR>
  nnoremap <silent> ;uT
    \ :<C-U>Unite tab
    \ -buffer-name=files -no-split<CR>
  nnoremap <silent> ;ut
    \ :<C-U>UniteWithCursorWord tag tag/include
    \ -buffer-name=files -no-split -auto-preview<CR>

  nnoremap <silent> ;b
    \ :<C-U>Unite buffer_tab
    \  -buffer-name=files -no-split -auto-preview<CR>
  nnoremap <silent> ;e
    \ :<C-U>Unite file_mru file file/new directory/new
    \ -buffer-name=files -no-split<CR>

  nnoremap <silent> ;j
    \ :<C-U>Unite jump change
    \ -buffer-name=files -no-split -auto-preview -multi-line -no-start-insert<CR>
  nnoremap <silent> ;o
    \ :<C-U>Unite outline
    \ -buffer-name=files -no-split -auto-preview -multi-line -no-start-insert<CR>

  nnoremap <silent> ml
    \ :<C-U>Unite mark bookmark
    \ -buffer-name=files -no-split -auto-preview -multi-line -no-start-insert<CR>
  nnoremap mu :<C-U>UniteBookmarkAdd<CR>

  if &grepprg == 'internal'
    nnoremap <silent> ;g
      \ :<C-U>Unite vimgrep
      \ -buffer-name=grep -no-split -multi-line<CR>
  else
    nnoremap <silent> ;g
      \ :<C-U>Unite grep
      \ -buffer-name=grep -no-split -multi-line<CR>
  endif
  nnoremap <silent> ;G
    \ :<C-U>UniteResume grep
    \ -no-split -multi-line -no-start-insert<CR>

  nnoremap <silent> <C-P>
    \ :<C-U>Unite register history/yank
    \ -buffer-name=register -multi-line<CR>
  xnoremap <silent> <C-P>
    \ d:<C-U>Unite register history/yank
    \ -buffer-name=register -multi-line<CR>
  inoremap <silent> <C-P>
    \ <C-O>:<C-U>UniteWithCursorWord register history/yank
    \ -buffer-name=register -multi-line<CR>

  nnoremap <silent> ;u/
    \ :<C-U>call <SID>unite_search_forward()<CR>
  nnoremap <silent> ;u?
    \ :<C-U>call <SID>unite_search_backward()<CR>
  nnoremap <silent> ;u*
    \ :<C-U>call <SID>unite_search_cword_forward()<CR>
  nnoremap <silent> ;u#
    \ :<C-U>call <SID>unite_search_cword_backward()<CR>
  nnoremap <silent> ;ug/
    \ :<C-U>call <SID>unite_search_cword_forward()<CR>
  nnoremap <silent> ;ug?
    \ :<C-U>call <SID>unite_search_cword_backward()<CR>
  nnoremap <silent> ;un
    \ :<C-U>UniteResume search -no-start-insert<CR>

  call extend(s:altercmd_define, {
    \ 'u[nite]' : 'Unite'})
else
  function! s:marks()
    let char = join(s:mark_char, '')
    let cmd = join([
      \ 'marks',
      \ char . toupper(char)])
    echo "\r:" . cmd
    execute cmd
  endfunction
  nnoremap ml :<C-U>call <SID>marks()<CR>
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" Unite Mark: {{{
silent! let s:bundle = neobundle#get('unite-mark')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_source_mark_marks =
      \ join(s:mark_char, '') . toupper(join(s:mark_char, ''))
  endfunction
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VerifyEnc: {{{
silent! let s:bundle = neobundle#get('verifyenc')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  autocmd MyVimrc BufReadPre *
    \ NeoBundleSource verifyenc
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VimFiler: {{{
silent! let s:bundle = neobundle#get('vimdoc-ja')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  set helplang^=ja
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VimFiler: {{{
silent! let s:bundle = neobundle#get('vimfiler')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_data_directory      = expand('~/.local/.vimfiler')
    let g:vimfiler_as_default_explorer = 1
  endfunction

  if len(@%)
    NeoBundleSource vimfiler
  endif
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VimProc: {{{
silent! let s:bundle = neobundle#get('vimproc')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
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
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:vimshell_temporary_directory      = expand('~/.local/.vimshell')
    let g:vimshell_vimshrc_path             = expand('~/.vim/.vimshrc')
    let g:vimshell_max_command_history      = 100000
    let g:vimshell_no_save_history_commands = {}
    let g:vimshell_scrollback_limit         = 500
    let g:vimshell_prompt                   = '$ '
    let g:vimshell_secondary_prompt         = '> '
    let g:vimshell_right_prompt             =
      \ 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'

    if has('win32') || has('win64')
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

    if executable('grep')
      call vimshell#set_alias('lld', 'ls -alF | grep "/$"')
      call vimshell#set_alias('llf', 'ls -alF | grep -v "/$"')
      call vimshell#set_alias('lle', 'ls -alF | grep "\*$"')
      call vimshell#set_alias('lls', 'ls -alF | grep "\->"')
    endif
    if executable('head')
      call vimshell#set_alias('h', 'head')
    endif
    if executable('tailf')
      call vimshell#set_alias('t', 'tailf')
    elseif executable('tail')
      call vimshell#set_alias('t', 'tail -f')
    endif
  endfunction

  call extend(s:altercmd_define, {
    \ 'sh[ell]' : 'VimShell',
    \
    \ '_sh[ell]' : 'shell'})
  call extend(s:neocompl_dictionary_filetype_lists, {
    \ 'vimshell' : expand('~/.local/.vimshell/command-history')})
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" VisualStar: {{{
silent! let s:bundle = neobundle#get('visualstar')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:visualstar_no_default_key_mappings = 1
  endfunction

  NOXmap *  <Plug>(visualstar-*)
  NOXmap #  <Plug>(visualstar-#)
  NOXmap g/ <Plug>(visualstar-*)
  NOXmap g? <Plug>(visualstar-#)
  NOXmap g* <Plug>(visualstar-g*)
  NOXmap g# <Plug>(visualstar-g#)

  vmap <S-LeftMouse>  <Plug>(visualstar-*)
  vmap g<S-LeftMouse> <Plug>(visualstar-g*)
else
  NOXnoremap g/ *
  NOXnoremap g? #
endif
unlet! s:bundle
"}}}

"-----------------------------------------------------------------------------
" ZenCoding: {{{
silent! let s:bundle = neobundle#get('zencoding')
if exists('s:bundle') && isdirectory(get(s:bundle, 'path', ''))
  function! s:bundle.hooks.on_source(bundle)
    let g:user_zen_settings   = {
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
  function! s:load_bundle_settings()
    for d in split(glob('~/.vim/bundle-settings/*'), "\n")
      if neobundle#is_installed(fnamemodify(d, ':t'))
        let &runtimepath .= ',' . d
      endif
    endfor
  endfunction
  call s:load_bundle_settings()

  if !has('vim_starting')
    call neobundle#call_hook('on_source')
  endif
endif

" IndentLine
if !has('vim_starting') && exists(':IndentLinesReset')
  IndentLinesReset
endif
"}}}
