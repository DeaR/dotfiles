" -*- mode: vimrc; coding: unix -*-

" @name        c.vim
" @description Syntax settings for C
" @namespace   http://kuonn.mydns.jp/
" @author      DeaR
" @timestamp   <2013-05-18 18:03:34 DeaR>

let s:save_cpo = &cpo
set cpo&vim

" No block folding
if exists('c_no_block_fold')
  syntax clear cBlock
  if exists('c_curly_error')
    syntax match cCurlyError "}"
    syntax region cBlock start="{" end="}" contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
  else
    syntax region cBlock start="{" end="}" transparent
  endif
endif

" More uses
syntax keyword cType    BOOL BYTE WORD DWORD
syntax keyword cBoolean TRUE FALSE

" Working uses
syntax keyword cType         u8 u16 u32 s8 s16 s32
syntax keyword cStorageClass sconst

highlight def link cBoolean Boolean

let &cpo = s:save_cpo
unlet s:save_cpo
