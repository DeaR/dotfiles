# Zsh settings
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
export SHELL="zsh"
export LISTMAX="0"
export skip_global_compinit="1"
export TZ="JST-09"
export OUTPUT_CHARSET="utf-8"
export ZDOTDIR="${HOME}/.zsh"
export LOCAL_DIR="${HOME}/.local"

if [ "${TERM}" = "linux" ]; then
  export LANG="C"
else
  export LANG="ja_JP.UTF-8"
  export LC_TIME="C"
fi

if hash gcc 2> /dev/null; then
  export CC="gcc"
elif hash cc 2> /dev/null; then
  export CC="cc"
fi

if hash g++ 2> /dev/null; then
  export CXX="g++"
  export CCC="g++"
elif hash c++ 2> /dev/null; then
  export CXX="c++"
  export CCC="c++"
elif hash gcc 2> /dev/null; then
  export CXX="gcc"
  export CCC="gcc"
elif hash cc 2> /dev/null; then
  export CXX="cc"
  export CCC="cc"
fi

if hash vim 2> /dev/null; then
  if hash gvim 2> /dev/null; then
    export EDITOR="gvim"
  else
    export EDITOR="vim"
  fi
elif hash emacs 2> /dev/null; then
  if hash emacsclient 2> /dev/null; then
    export EDITOR="emacsclient"
  else
    export EDITOR="emacs"
  fi
elif hash sublime_text 2> /dev/null; then
  export EDITOR="sublime_text"
elif hash vi 2> /dev/null; then
  export EDITOR="vi"
fi

if hash less 2> /dev/null; then
  export PAGER="less"
elif hash lv 2> /dev/null; then
  export PAGER="lv"
elif hash more 2> /dev/null; then
  export PAGER="more"
fi

if hash less 2> /dev/null; then
  export LESS="-r"
  export LESSCHARSET="utf-8"
  export LESSHISTFILE="${LOCAL_DIR}/.lesshst"
  if hash lesspipe 2> /dev/null; then
    eval "$(lesspipe)"
  elif hash lesspipe.sh 2> /dev/null; then
    export LESSOPEN="| lesspipe.sh %s"
    export LESSCLOSE="lesspipe.sh %s %s"
  fi
fi
if hash lv 2> /dev/null; then
  export LV="-Ia -Ow -c -l"
fi
if [ -n "${PAGER}" ] && hash nkf 2> /dev/null; then
  if hash git 2> /dev/null; then
    export GIT_PAGER="nkf -w | less"
  fi
  if hash hg 2> /dev/null; then
    export HGPAGER="nkf -w | less"
  fi
fi

if hash hg 2> /dev/null; then
  export HGENCODING="utf-8"
fi

if [ -d "/usr/local/lib/go" ]; then
  export GOROOT="/usr/local/lib/go"
elif [ -d "/usr/lib/go" ]; then
  export GOROOT="/usr/lib/go"
fi
if [ -n "${GOROOT}" -a -d "${GOROOT}/bin" ]; then
  export PATH="${GOROOT}/bin:${PATH}"
fi
if [ -z "${GOPATH}" ]; then
  export GOPATH="${HOME}/go"
  export PATH="${GOPATH}/bin:${PATH}"
fi
#}}}

#-----------------------------------------------------------------------------
# Source By Platform, Host, User: {{{
if hash uname 2> /dev/null && [ -n "$(uname)" -a -f "${ZDOTDIR}/.zshenv.$(uname).zsh" ]; then
  source "${ZDOTDIR}/.zshenv.$(uname).zsh"
fi
if [ -n "${HOSTNAME}" -a -f "${ZDOTDIR}/.zshenv.${HOSTNAME}.zsh" ]; then
  source "${ZDOTDIR}/.zshenv.${HOSTNAME}.zsh"
fi
if [ -n "${USER}" -a -f "${ZDOTDIR}/.zshenv.${USER}.zsh" ]; then
  source "${ZDOTDIR}/.zshenv.${USER}.zsh"
fi
if [ -f "${LOCAL_DIR}/.zshenv.local.zsh" ]; then
  source "${LOCAL_DIR}/.zshenv.local.zsh"
fi
#}}}
