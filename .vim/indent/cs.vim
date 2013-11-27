" Vim indent file
" Language:        C#
" Maintainer: Aquila Deus
"             DeaR <nayuri@kuonn.mydns.jp>
"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal indentexpr=GetCSIndent()
setlocal cindent
setlocal cinkeys-=0#

function! GetCSIndent()

  let this_line = getline(v:lnum)
  let previous_line = getline(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if a:lnum == 0
    return 0
  endif

  " If previous_line is an attribute line:
  if previous_line =~? '^\s*\[[A-Za-z]' && previous_line =~? '\]$'
    let ind = indent(v:lnum - 1)
    return ind
  else
    try
      setlocal indentexpr=
      return cindent(v:lnum)
    finally
      setlocal indentexpr=GetCSIndent()
    endtry
  endif

endfunction

let b:undo_indent = '
  \ setlocal indentexpr< cindent< cinkeys<'

let &cpo = s:save_cpo
unlet s:save_cpo
