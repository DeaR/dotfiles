# -*- mode: shell-script; coding: unix -*-

# @name        .bash_profile.MINGW32_NT-6.1
# @description Bash settings
# @namespace   http://kuonn.mydns.jp/
# @author      DeaR
# @timestamp   <2013-06-27 20:13:17 DeaR>

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export MANPATH="${HOME}/share/man:${HOME}/man:/usr/local/share/man:/usr/local/man:/mingw/share/man:/mingw/man:/usr/share/man:/usr/man:${MANPATH}:${XYZZY}/man"
export INFOPATH="${HOME}/share/info:${HOME}/info:usr/local/share/info:/usr/local/info:/mingw/share/info:/mingw/info:/usr/share/info:/usr/info:${INFOPATH}:${XYZZY}/info:${EMACS}/info"
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