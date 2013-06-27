# -*- mode: shell-script; coding: unix -*-

# @name        .zshenv.CYGWIN_NT-6.1-WOW64
# @description Zsh settings
# @namespace   http://kuonn.mydns.jp/
# @author      DeaR
# @timestamp   <2013-06-27 20:13:19 DeaR>

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export PATH=".:${PATH}"
export MANPATH="${HOME}/share/man:${HOME}/man:${MANPATH}:${XYZZY}/man"
export INFOPATH="${HOME}/share/info:${HOME}/info:${INFOPATH}:${XYZZY}/info:${EMACS}/info"
if [ -z "${TERM}" ]; then
  export TERM="cygwin"
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
