#!/bin/sh

# Install DotFiles
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  27-Apr-2016.
# License:      MIT License {{{
#     Copyright (c) 2016 DeaR <nayuri@kuonn.mydns.jp>
#
#     Permission is hereby granted, free of charge, to any person obtaining a
#     copy of this software and associated documentation files (the
#     "Software"), to deal in the Software without restriction, including
#     without limitation the rights to use, copy, modify, merge, publish,
#     distribute, sublicense, and/or sell copies of the Software, and to permit
#     persons to whom the Software is furnished to do so, subject to the
#     following conditions:
#
#     The above copyright notice and this permission notice shall be included
#     in all copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
#     OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
#     THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# }}}

mklink_f() {
  [ -f "~/$1" ] || ln -s "$(cd $(dirname $1) && pwd)/$(basename $1)" "~/$1"
}

mklink_d() {
  [ -d "~/$1" ] || ln -s "$(cd $(dirname $1) && pwd)/$(basename $1)" "~/$1"
}

pushd $(dirname $0)/..

if [ -n "$CACHE" ]; then
  if [ -n "$XDG_CACHE_HOME" ]; then
    set CACHE="$XDG_CACHE_HOME"
  else
    set CACHE="~/.cache"
  fi
fi
[ -d "$CACHE" ] || mkdir "$CACHE"

# ColorDiff
if which colordiff > /dev/null; then
  mklink_f .colordiffrc
fi

# Git
if which git > /dev/null; then
  mklink_f .gitconfig
  mklink_f .gitignore
fi

# Mercurial
if which hg > /dev/null; then
  mklink_f .hgignore
  mklink_f .hgrc
fi

# NYAGOS
# if which nyagos > /dev/null; then
#   mklink_d .nyagos.d
#   mklink_f .nyagos
# fi

# Nodoka
# if which nodoka > /dev/null; then
#   mklink_d .nodoka.d
#   mklink_f .nodoka
# fi

# Screen
if which screen > /dev/null; then
  mklink_f .screenrc
fi

# tmux
if which tmux > /dev/null; then
  mklink_f .tmux.conf
fi

# Vim
if which gvim > /dev/null; then
  mklink_f .gvimrc
fi
if which vim > /dev/null; then
  mklink_d .vim
  mklink_f .vimrc
fi

popd
