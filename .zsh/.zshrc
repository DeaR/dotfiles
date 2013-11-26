# Zsh interactive settings
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  26-Nov-2013.
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
# Option: {{{
setopt append_history
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt chase_dots
setopt correct
setopt correct_all
setopt extended_glob
setopt extended_history
setopt hist_expand
setopt hist_ignore_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt list_packed
setopt magic_equal_subst
setopt mark_dirs
setopt nolistbeep
setopt print_eight_bit
setopt pushd_ignore_dups
setopt pushd_to_home
setopt share_history
#}}}

#------------------------------------------------------------------------------
# Emacs Like Keybind: {{{
bindkey -e
bindkey "^?"     backward-delete-char
bindkey "^H"     backward-delete-char
bindkey "^[[3~"  delete-char
bindkey "^[[1~"  beginning-of-line
bindkey "^[[4~"  end-of-line
#}}}

#------------------------------------------------------------------------------
# Prompt: {{{
autoload -Uz colors
colors
PROMPT="%{${fg[green]}%}%n@%m ${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "
PROMPT2="%{${fg[green]}%}%_>  %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R ->  %r [nyae]? %{${reset_color}%}"
RPROMPT="%1(v|%{${fg[cyan]}%}%1v%{${reset_color}%}|)"
#}}}

#------------------------------------------------------------------------------
# History: {{{
HISTFILE="${LOCAL_DIR}/.zsh_history"
HISTSIZE="100000"
SAVEHIST="100000"
HISTTIMEFORMAT="%Y-%m-%d %T "
#}}}

#------------------------------------------------------------------------------
# Completion: {{{
autoload -U compinit
compinit -u -d "${LOCAL_DIR}/.zcompdump"
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z} r:|[-_.]=**"
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*:default" menu select=1
#}}}

#------------------------------------------------------------------------------
# Vcs Info: {{{
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git hg svn
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:*" get-revision true
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" stagedstr "+"
zstyle ":vcs_info:git:*" unstagedstr "-"
zstyle ":vcs_info:git:*" formats "(%s)-[%b]%c%u"
zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a]%c%u"
zstyle ":vcs_info:(hg|svn):*" branchformat "%b:r%r"
zstyle ":vcs_info:hg:*" hgrevformat "%r"
function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  if [ -n "${vcs_info_msg_0_}" ]; then
    psvar[1]="${vcs_info_msg_0_}"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_vcs_info_msg
#}}}

#------------------------------------------------------------------------------
# Z: {{{
_Z_CMD="j"
_Z_DATA="${LOCAL_DIR}/.z"
if [ -f "${LOCAL_DIR}/z/z.sh" ]; then
  source "${LOCAL_DIR}/z/z.sh"
elif [ -f "${ZDOTDIR}/z/z.sh" ]; then
  source "${ZDOTDIR}/z/z.sh"
elif [ -f "${HOME}/z/z.sh" ]; then
  source "${HOME}/z/z.sh"
elif [ -f "${HOME}/.bash/z/z.sh" ]; then
  source "${HOME}/.bash/z/z.sh"
fi
#}}}

#------------------------------------------------------------------------------
# Less Tailf: {{{
if hash less 2> /dev/null; then
  function ltail {
    LESSOPEN=
    LESSCLOSE=
    less +F $@
  }
fi
#}}}

#------------------------------------------------------------------------------
# Abbreviations: {{{
typeset -A abbreviations
magic-abbrev-expand () {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}
magic-abbrev-expand-and-insert () {
  magic-abbrev-expand
  zle self-insert
}
magic-abbrev-expand-and-insert-complete () {
  magic-abbrev-expand
  zle self-insert
  zle expand-or-complete
}
magic-abbrev-expand-and-accept () {
  magic-abbrev-expand
  zle accept-line
}
magic-abbrev-expand-and-normal-complete () {
  magic-abbrev-expand
  zle expand-or-complete
}
no-magic-abbrev-expand () {
  LBUFFER+=" "
}
zle -N magic-abbrev-expand
zle -N magic-space
zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-insert-complete
zle -N magic-abbrev-expand-and-accept
zle -N magic-abbrev-expand-and-normal-complete
zle -N no-magic-abbrev-expand
bindkey " "   magic-abbrev-expand-and-insert
bindkey "."   magic-abbrev-expand-and-insert
bindkey "\r"  magic-abbrev-expand-and-accept
bindkey "^i"  magic-abbrev-expand-and-normal-complete
bindkey "^x"  no-magic-abbrev-expand
bindkey "^j"  accept-line
if [ -n "${PAGER}" ]; then
  abbreviations+=("L" "| ${PAGER}")
fi
if hash head 2> /dev/null; then
  abbreviations+=("H" "| head")
fi
if hash ltail 2> /dev/null; then
  abbreviations+=("T" "| ltail")
elif hash tail 2> /dev/null; then
  abbreviations+=("T" "| tail")
fi
if hash grep 2> /dev/null; then
  abbreviations+=("G" "| grep")
fi
if hash sort 2> /dev/null; then
  abbreviations+=("S" "| sort")
fi
if hash nkf 2> /dev/null; then
  abbreviations+=("N" "| nkf -w")
fi
#}}}

#------------------------------------------------------------------------------
# Alias (Color): {{{
alias ls="ls --color --show-control-chars"
if hash grep 2> /dev/null; then
  alias grep="grep --color"
fi
if hash colordiff 2> /dev/null; then
  alias diff="colordiff"
fi
#}}}

#------------------------------------------------------------------------------
# Alias (Shorty): {{{
alias q="exit"
alias cls="clear"
alias ll="ls -alF"
if hash grep 2> /dev/null; then
  alias lld="ll | grep --color=never '/$'"
  alias llf="ll | grep --color=never -v '/$'"
  alias lle="ll | grep --color=never '\*$'"
  alias lls="ll | grep --color=never '\->'"
fi
if [ -n "${EDITOR}" ]; then
  alias e="${EDITOR}"
fi
if [ -n "${PAGER}" ]; then
  alias l="${PAGER}"
fi
if hash head 2> /dev/null; then
  alias h="head"
fi
if hash ltail 2> /dev/null; then
  alias t="ltail"
elif hash tailf 2> /dev/null; then
  alias t="tailf"
elif hash tail 2> /dev/null; then
  alias t="tail -f"
fi
if hash vim 2> /dev/null; then
  if hash gvim 2> /dev/null; then
    alias vi="gvim"
  else
    alias vi="vim"
  fi
fi
if hash sublime_text 2> /dev/null; then
  alias subl="sublime_text"
fi
#}}}

#------------------------------------------------------------------------------
# Global Alias: {{{
#}}}

#------------------------------------------------------------------------------
# Suffix: {{{
alias -s sh="sh"
alias -s zsh="zsh"
if hash bash 2> /dev/null; then
  alias -s bash="bash"
fi
if hash perl 2> /dev/null; then
  alias -s pl="perl"
fi
if hash python 2> /dev/null; then
  alias -s py="python"
fi
if hash ruby 2> /dev/null; then
  alias -s rb="ruby"
fi
if hash java 2> /dev/null; then
  alias -s jar="java -jar"
fi
if hash lua 2> /dev/null; then
  alias -s lua="lua"
fi
if hash awk 2> /dev/null; then
  alias -s awk="awk -f"
fi
#}}}

#------------------------------------------------------------------------------
# Source By Platform, Host, User: {{{
if hash uname 2> /dev/null && [ -n "$(uname)" -a -f "${ZDOTDIR}/.zshrc.$(uname).zsh" ]; then
  source "${ZDOTDIR}/.zshrc.$(uname).zsh"
fi
if [ -n "${HOSTNAME}" -a -f "${ZDOTDIR}/.zshrc.${HOSTNAME}.zsh" ]; then
  source "${ZDOTDIR}/.zshrc.${HOSTNAME}.zsh"
fi
if [ -n "${USER}" -a -f "${ZDOTDIR}/.zshrc.${USER}.zsh" ]; then
  source "${ZDOTDIR}/.zshrc.${USER}.zsh"
fi
if [ -f "${LOCAL_DIR}/.zshrc.local.zsh" ]; then
  source "${LOCAL_DIR}/.zshrc.local.zsh"
fi
#}}}

#------------------------------------------------------------------------------
# Stty: {{{
if hash stty 2> /dev/null; then
  stty start undef
  stty stop undef
fi
#}}}

#------------------------------------------------------------------------------
# Terminal Multiplexer: {{{
if [ -z "${TMUX}" -a -z "${STY}" ]; then
  if hash tmux 2> /dev/null; then
    if tmux ls >& /dev/null; then
      tmux a
    else
      tmux
    fi
    exit
  elif hash screen 2> /dev/null; then
    screen -rx || screen -D -RR
    exit
  fi
else
  function _update_title() {
    emulate -L zsh
    local -a cmd
    cmd=(${(z)2})
    if [ "$cmd[1]" = "sudo" ]; then
      echo -n "\ek$cmd[2]:t\e\\"
    else
      echo -n "\ek$cmd[1]:t\e\\"
    fi
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _update_title
fi
#}}}
