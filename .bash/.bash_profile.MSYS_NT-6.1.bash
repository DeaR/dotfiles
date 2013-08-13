# Bash settings for MSYS
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  13-Aug-2013.
# License:      MIT License {{{
#     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
#
#     Permission is hereby granted, free of charge, to any person obtaining a
#     copy of this software and associated documentation files (the
#     "Software"), to deal in the Software without restriction, including
#     without limitation the rights to use, copy, modify, merge, publish,
#     distribute, sublicense, and/or sell copies of the Software, and to
#     permit persons to whom the Software is furnished to do so, subject to
#     the following conditions:
#
#     The above copyright notice and this permission notice shall be included
#     in all copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# }}}

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export MANPATH="${HOME}/share/man:${HOME}/man:/usr/local/share/man:/usr/local/man:/mingw/share/man:/mingw/man:/usr/share/man:/usr/man:${MANPATH}:${XYZZY}/man"
export INFOPATH="${HOME}/share/info:${HOME}/info:usr/local/share/info:/usr/local/info:/mingw/share/info:/mingw/info:/usr/share/info:/usr/info:${INFOPATH}:${XYZZY}/info:${EMACS}/info"
if [ -z "${TERM}" ]; then
  export TERM="cygwin"
fi

if [ -n "${CC}" ]; then
  export C_INCLUDE_PATH="${MINGW_HOME}/include"
  export LIBRARY_PATH="${MINGW_HOME}/lib"
fi
if [ -n "${CXX}" ]; then
  export CPP_INCLUDE_PATH="${MINGW_HOME}/include"
  export LIBRARY_PATH="${MINGW_HOME}/lib"
fi

if hash vim 2> /dev/null; then
  if hash gvim 2> /dev/null; then
    export EDITOR="gvim"
  else
    export EDITOR="vim"
  fi
  if hash git 2> /dev/null; then
    export GIT_EDITOR="${EDITOR} --remote-wait-silent"
  fi
  if hash hg 2> /dev/null; then
    export HGEDITOR="${EDITOR} --remote-wait-silent"
  fi
elif hash xyzzy 2> /dev/null; then
  if hash xyzzycli 2> /dev/null; then
    export EDITOR="xyzzycli"
  else
    export EDITOR="xyzzy"
  fi
  if hash git 2> /dev/null; then
    export GIT_EDITOR="${EDITOR} -wait"
  fi
  if hash hg 2> /dev/null; then
    export HGEDITOR="${EDITOR} -wait"
  fi
fi
#}}}
