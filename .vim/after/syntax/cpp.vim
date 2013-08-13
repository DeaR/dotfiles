" Syntax settings for C++/CLI
"
" Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
" Last Change:  13-Aug-2013.
" License:      MIT License {{{
"     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
"
"     Permission is hereby granted, free of charge, to any person obtaining a
"     copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

" Region folding
if !exists('cpp_no_region_fold')
  syntax region cppRegion matchgroup=cPreCondit start="^\s*#\s*pragma\s*region.*$" end ="^\s*#\s*pragma\s*endregion" transparent fold contains=TOP
endif

" Xml markup inside '///' comments
if !exists('cpp_no_xml_comment')
  syntax cluster xmlRegionHook   add=cppXmlCommentLeader
  syntax cluster xmlCdataHook    add=cppXmlCommentLeader
  syntax cluster xmlStartTagHook add=cppXmlCommentLeader
  syntax keyword cppXmlTag contained Libraries Packages Types Excluded ExcludedTypeName ExcludedLibraryName
  syntax keyword cppXmlTag contained ExcludedBucketName TypeExcluded Type TypeKind TypeSignature AssemblyInfo
  syntax keyword cppXmlTag contained AssemblyName AssemblyPublicKey AssemblyVersion AssemblyCulture Base
  syntax keyword cppXmlTag contained BaseTypeName Interfaces Interface InterfaceName Attributes Attribute
  syntax keyword cppXmlTag contained AttributeName Members Member MemberSignature MemberType MemberValue
  syntax keyword cppXmlTag contained ReturnValue ReturnType Parameters Parameter MemberOfPackage
  syntax keyword cppXmlTag contained ThreadingSafetyStatement Docs devdoc example overload remarks returns summary
  syntax keyword cppXmlTag contained threadsafe value internalonly nodoc exception param permission platnote
  syntax keyword cppXmlTag contained seealso b c i pre sub sup block code note paramref see subscript superscript
  syntax keyword cppXmlTag contained list listheader item term description altcompliant altmember

  syntax cluster xmlTagHook add=cppXmlTag

  syntax match cppXmlCommentLeader +\/\/\/+    contained
  syntax match cppXmlComment       +\/\/\/.*$+ contains=cppXmlCommentLeader,@cppXml,@Spell

  if exists('b:current_syntax')
    let b:save_current_syntax = b:current_syntax
    unlet b:current_syntax
  endif
  syntax include @cppXml syntax/xml.vim
  if exists('b:save_current_syntax')
    let b:current_syntax = b:save_current_syntax
    unlet b:save_current_syntax
  endif

  highlight def link xmlRegion           Comment
  highlight def link cppXmlCommentLeader Comment
  highlight def link cppXmlComment       Comment
  highlight def link cppXmlTag           Statement
endif

" C++/CLI
syntax keyword cppType         pin_ptr
syntax keyword cppStatement    get set
syntax keyword cppStorageClass abstract sealed ref value
syntax match   cppCast         "\<safe_cast\s*<"me=e-1
syntax match   cppCast         "\<safe_cast\s*$"

let &cpo = s:save_cpo
unlet s:save_cpo
