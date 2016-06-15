# Bash interactive settings
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  13-Jun-2016.
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

#------------------------------------------------------------------------------
# If not running interactively, don't do anything: {{{
[[ $- != *i* ]] && return
#}}}

#------------------------------------------------------------------------------
# Terminal Multiplexer: {{{
if [[ -z ${TMUX} && -z ${STY} ]]; then
  if type tmux >/dev/null 2>&1; then
    if tmux ls >/dev/null 2>&1; then
      if hash iselect; then
        REPLY=$(tmux ls | iselect -a -f | sed "s/:.*//")
      else
        tmux ls
        read -p "Select attach: " REPLY
      fi
      [[ -n ${REPLY} ]] && tmux a -t $REPLY && exit
    fi
    tmux && exit
  elif type screen >/dev/null 2>&1; then
    if [[ $(screen -ls | wc -l) -ge 3 ]]; then
      if hash iselect; then
        REPLY=$(screen -ls | sed -n "/^\t/p" | iselect -a -f | awk '{print $1}')
      else
        screen -ls
        read -p "Select attach: " REPLY
      fi
      [[ -n ${REPLY} ]] && screen -rx $REPLY && exit
    fi
    screen && exit
  fi
else
  _INIT_TITLE=0
  function _lastcmd {
    if [[ ${_INIT_TITLE} -ne 0 ]]; then
      echo -ne "\ek$(history 1 | awk '{if($4=="sudo")print $5;else print $4}')\e\\"
    fi
    _INIT_TITLE=1
  }
  PROMPT_COMMAND="_lastcmd;${PROMPT_COMMAND}"
fi
#}}}

#------------------------------------------------------------------------------
# Option: {{{
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
umask 022
ulimit -c 0
#}}}

#------------------------------------------------------------------------------
# Option For 4.x: {{{
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
  shopt -s autocd
  shopt -s dirspell
  shopt -s globstar
fi
#}}}

#------------------------------------------------------------------------------
# Emacs Like Keybind: {{{
set -o emacs
#}}}

#------------------------------------------------------------------------------
# Prompt: {{{
PS1="\[\e[32;1m\]\u@\h \[\e[33;1m\]\w\[\e[m\]\n\$ "
#}}}

#------------------------------------------------------------------------------
# History: {{{
HISTFILE="${XDG_CACHE_HOME}/bash_history"
HISTSIZE="100000"
HISTFILESIZE="100000"
HISTCONTROL="ignoredups"
HISTTIMEFORMAT="%F %T "
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
  function _histshare {
    history -a
    history -c
    history -r
  }
  PROMPT_COMMAND="_histshare;${PROMPT_COMMAND}"
fi
#}}}

#------------------------------------------------------------------------------
# Completion: {{{
if [[ -f ${HOME}/.bash.d/bash_completion ]]; then
  . "${HOME}/.bash.d/bash_completion"
elif [[ -f /usr/local/etc/bash_completion ]]; then
  . "/usr/local/etc/bash_completion"
elif [[ -f /etc/bash_completion ]]; then
  . "/etc/bash_completion"
fi
#}}}

#------------------------------------------------------------------------------
# Less TailF: {{{
if type less >/dev/null 2>&1; then
  function ltail {
    LESSOPEN=
    LESSCLOSE=
    less +F $@
  }
fi
#}}}

#-----------------------------------------------------------------------------
# LS: {{{
if type grep >/dev/null 2>&1; then
  alias ls="ls --color=auto --show-control-chars"
  alias ll="ls -alF"
  function lld {
    ll --color $@ | grep --color=never '/$'
  }
  function llf {
    ll --color $@ | grep --color=never -v '/$'
  }
  function lle {
    ll --color $@ | grep --color=never '\*$'
  }
  function lls {
    ll --color $@ | grep --color=never '\->'
  }
fi
#}}}

#-----------------------------------------------------------------------------
# Alias: {{{
alias q="exit"
alias cls="clear"
if [[ -n ${EDITOR} ]]; then
  alias e="${EDITOR}"
fi
if [[ -n ${PAGER} ]]; then
  alias l="${PAGER}"
fi
if type head >/dev/null 2>&1; then
  alias h="head"
fi
if type ltail >/dev/null 2>&1; then
  alias t="ltail"
elif type tailf >/dev/null 2>&1; then
  alias t="tailf"
elif type tail >/dev/null 2>&1; then
  alias t="tail -f"
fi
if type gvim >/dev/null 2>&1; then
  alias vi="gvim"
  alias vim="gvim"
elif type vim >/dev/null 2>&1; then
  alias vi="vim"
fi
if type hub >/dev/null 2>&1; then
  alias git="hub"
fi
if type hg >/dev/null 2>&1; then
  alias hg="hg --config pager.pager='$HGPAGER'"
fi
if type grep >/dev/null 2>&1; then
  alias grep="grep --color"
fi
if type head >/dev/null 2>&1; then
  alias diff="colordiff"
fi
#}}}

#------------------------------------------------------------------------------
# Stty: {{{
if type stty >/dev/null 2>&1; then
  stty start undef
  stty stop undef
fi
#}}}

#-----------------------------------------------------------------------------
# Post Init: {{{
if [[ -f ${HOME}/.bashrc_local ]]; then
  . "${HOME}/.bashrc_local"
elif [[ -f ${HOME}/.bash.d/bashrc_local ]]; then
  . "${HOME}/.bash.d/bashrc_local"
elif [[ -f ${HOME}/.bashrc_local.sh ]]; then
  . "${HOME}/.bashrc_local.sh"
elif [[ -f ${HOME}/.bash.d/bashrc_local.sh ]]; then
  . "${HOME}/.bash.d/bashrc_local.sh"
elif [[ -f ${HOME}/.bashrc_local.bash ]]; then
  . "${HOME}/.bashrc_local.bash"
elif [[ -f ${HOME}/.bash.d/bashrc_local.bash ]]; then
  . "${HOME}/.bash.d/bashrc_local.bash"
fi
# }}}
