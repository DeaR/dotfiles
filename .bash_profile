# Bash settings
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  10-Jun-2016.
# License:      MIT License {{{
#     Copyright (c) 2013 DeaR <nayuri@kuonn.mydns.jp>
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

#-----------------------------------------------------------------------------
# Pre Init: {{{
if [[ -z ${XDG_DATA_HOME} ]]; then
  export XDG_DATA_HOME="${HOME}/.local/share"
fi
if [[ -z ${XDG_CACHE_HOME} ]]; then
  export XDG_CACHE_HOME="${HOME}/.cache"
fi
if [[ -z ${XDG_CONFIG_HOME} ]]; then
  export XDG_CONFIG_HOME="${HOME}/.config"
fi

export PATH=".:${HOME}/bin:${PATH}"
# }}}

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export SHELL="bash"
export TZ="JST-09"
export OUTPUT_CHARSET="utf-8"

if [[ ${TERM} = "linux" ]]; then
  export LANG="C"
else
  export LANG="ja_JP.UTF-8"
  export LC_TIME="C"
fi

if type vim >/dev/null 2>&1; then
  if type gvim >/dev/null 2>&1; then
    export EDITOR="gvim"
  else
    export EDITOR="vim"
  fi
elif type vi >/dev/null 2>&1; then
  export EDITOR="vi"
fi

if type less >/dev/null 2>&1; then
  export PAGER="less"
elif type lv >/dev/null 2>&1; then
  export PAGER="lv"
elif type more >/dev/null 2>&1; then
  export PAGER="more"
fi

if type less >/dev/null 2>&1; then
  export LESS="-r"
  export LESSCHARSET="utf-8"
  export LESSHISTFILE="${XDG_CACHE_HOME}/lesshst"
  if type lesspipe >/dev/null 2>&1; then
    eval "$(lesspipe)"
  elif type lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN="| lesspipe.sh %s"
    export LESSCLOSE="lesspipe.sh %s %s"
  fi
fi
if type lv >/dev/null 2>&1; then
  export LV="-Ia -c"
fi

if type git >/dev/null 2>&1; then
  export GIT_PAGER="${PAGER}"
  if type diff-highlight >/dev/null 2>&1; then
    export GIT_PAGER="diff-highlight | ${GIT_PAGER}"
  fi
  if type nkf >/dev/null 2>&1; then
    export GIT_PAGER="nkf | ${GIT_PAGER}"
  fi
fi

if type hg >/dev/null 2>&1; then
  export HGENCODING="utf-8"
  export HGPAGER="${PAGER}"
  if type nkf >/dev/null 2>&1; then
    export HGPAGER="nkf | ${HGPAGER}"
  fi
fi

if [[ -z ${GOPATH} ]]; then
  export GOPATH="${HOME}/go"
fi
export PATH="${GOPATH}/bin:${PATH}"
# }}}

#-----------------------------------------------------------------------------
# Post Init: {{{
if [[ -f ${HOME}/.bash_profile_local ]]; then
  . "${HOME}/.bash_profile_local"
elif [[ -f ${HOME}/.bash.d/bash_profile_local ]]; then
  . "${HOME}/.bash.d/bash_profile_local"
elif [[ -f ${HOME}/.bash_profile_local.sh ]]; then
  . "${HOME}/.bash_profile_local.sh"
elif [[ -f ${HOME}/.bash.d/bash_profile_local.sh ]]; then
  . "${HOME}/.bash.d/bash_profile_local.sh"
elif [[ -f ${HOME}/.bash_profile_local.bash ]]; then
  . "${HOME}/.bash_profile_local.bash"
elif [[ -f ${HOME}/.bash.d/bash_profile_local.bash ]]; then
  . "${HOME}/.bash.d/bash_profile_local.bash"
fi

if [[ -f ${HOME}/.bashrc ]]; then
  . "${HOME}/.bashrc"
fi
# }}}
