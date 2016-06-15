#!/bin/sh

# Install DotFiles
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  07-Jun-2016.
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

mklink() {
  if [ $# -lt 2 ]; then
    mklink "$1" "${HOME}/$1"
  elif [ ! -e "$2" ]; then
    ln -s "$(cd $(dirname $1) && pwd)/$(basename $1)" "$2"
  fi
}

dein() {
  if [ ! -e "$1" ]; then
    read -p "Install dein.vim? (y/N): " REPLY
    [ "${REPLY}" != "y" -a "${REPLY}" != "Y" ] && return

    mkdir -p "$1"
    git clone https://github.com/Shougo/dein.vim.git "$1"
  fi
}

cd $(dirname $0)/..

if [ -z "${XDG_DATA_HOME}" ]; then
  XDG_DATA_HOME="${HOME}/.local/share"
fi
if [ -z "${XDG_CACHE_HOME}" ]; then
  XDG_CACHE_HOME="${HOME}/.cache"
fi
if [ -z "${XDG_CONFIG_HOME}" ]; then
  XDG_CONFIG_HOME="${HOME}/.config"
fi
[ -d "${XDG_DATA_HOME}" ]   || mkdir -p "${XDG_DATA_HOME}"
[ -d "${XDG_CACHE_HOME}" ]  || mkdir -p "${XDG_CACHE_HOME}"
# [ -d "${XDG_CONFIG_HOME}" ] || mkdir -p "${XDG_CONFIG_HOME}"
mklink .config "${XDG_CONFIG_HOME}"

# Bash
if which bash >/dev/null 2>&1; then
  mklink .bash.d
  mklink .bash_profile
  mklink .bashrc
  mklink .inputrc
fi

# ColorDiff
if which colordiff >/dev/null 2>&1; then
  mklink .colordiffrc
fi

# Git
if which git >/dev/null 2>&1; then
  mklink .gitconfig
  mklink .gitignore
fi

# Mercurial
if which hg >/dev/null 2>&1; then
  mklink .hgignore
  mklink .hgrc
fi

# NYAGOS
# if which nyagos >/dev/null 2>&1; then
#   mklink .nyagos.d
#   mklink .nyagos
# fi

# Nodoka
# if which nodoka >/dev/null 2>&1; then
#   mklink .nodoka.d
#   mklink .nodoka
# fi

# Screen
if which screen >/dev/null 2>&1; then
  mklink .screenrc
fi

# tmux
if which tmux >/dev/null 2>&1; then
  mklink .tmux.conf
fi

# Vim
if which gvim >/dev/null 2>&1; then
  mklink .gvimrc
fi
if which vim >/dev/null 2>&1; then
  mklink .vim
  mklink .vimrc

  which git >/dev/null 2>&1 && dein "${XDG_DATA_HOME}/dein/repos/github.com/Shougo/dein.vim"
fi

cd -
