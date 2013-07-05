# -*- mode: shell-script; coding: unix -*-

# @name        .bash_profile
# @description Bash settings
# @namespace   http://kuonn.mydns.jp/
# @author      DeaR
# @timestamp   <2013-07-05 14:07:21 DeaR>

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export SHELL="bash"
export TZ="JST-09"
export OUTPUT_CHARSET="utf-8"
export BASH_DIR="${HOME}/.bash"
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
if hash uname 2> /dev/null && [ -n "$(uname)" -a -f "${BASH_DIR}/.bash_profile.$(uname)" ]; then
  source "${BASH_DIR}/.bash_profile.$(uname)"
fi
if [ -n "${HOSTNAME}" -a -f "${BASH_DIR}/.bash_profile.${HOSTNAME}" ]; then
  source "${BASH_DIR}/.bash_profile.${HOSTNAME}"
fi
if [ -n "${USER}" -a -f "${BASH_DIR}/.bash_profile.${USER}" ]; then
  source "${BASH_DIR}/.bash_profile.${USER}"
fi
if [ -f "${LOCAL_DIR}/.bash_profile.local" ]; then
  source "${LOCAL_DIR}/.bash_profile.local"
fi
#}}}

#-----------------------------------------------------------------------------
# Source The Users Bashrc If It Exists: {{{
if [ -f "${BASH_DIR}/.bashrc" ]; then
  source "${BASH_DIR}/.bashrc"
fi
#}}}
