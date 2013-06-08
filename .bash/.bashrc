# -*- mode: shell-script; coding: unix -*-

# @name        .bashrc
# @description Bash interactive settings
# @namespace   http://kuonn.mydns.jp/
# @author      DeaR
# @timestamp   <2013-06-07 14:37:30 DeaR>

#-----------------------------------------------------------------------------
# If not running interactively, don't do anything: {{{
[[ "$-" != *i* ]] && return
#}}}

#-----------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------
# Option For 4.x: {{{
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
	shopt -s autocd
	shopt -s dirspell
	shopt -s globstar
fi
#}}}

#-----------------------------------------------------------------------------
# Emacs Like Keybind: {{{
set -o emacs
#}}}

#-----------------------------------------------------------------------------
# Prompt: {{{
PS1="\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ "
#}}}

#-----------------------------------------------------------------------------
# History: {{{
HISTFILE="${LOCAL_DIR}/.bash_history"
HISTSIZE="100000"
HISTFILESIZE="100000"
HISTCONTROL="ignoreboth"
HISTTIMEFORMAT="%Y-%m-%d %T "
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
	function share_history {
		history -a
		history -c
		history -r
	}
	PROMPT_COMMAND="share_history;${PROMPT_COMMAND}"
fi
#}}}

#-----------------------------------------------------------------------------
# Completion: {{{
if [ -f "${BASH_DIR}/bash_completion" ]; then
	source "${BASH_DIR}/bash_completion"
elif [ -f "/usr/local/etc/bash_completion" ]; then
	source "/usr/local/etc/bash_completion"
elif [ -f "/etc/bash_completion" ]; then
	source "/etc/bash_completion"
fi
#}}}

#-----------------------------------------------------------------------------
# Z: {{{
_Z_CMD="j"
_Z_DATA="${LOCAL_DIR}/.z"
if [ -f "${LOCAL_DIR}/z/z.sh" ]; then
	source "${LOCAL_DIR}/z/z.sh"
elif [ -f "${BASH_DIR}/z/z.sh" ]; then
	source "${BASH_DIR}/z/z.sh"
elif [ -f "${HOME}/z/z.sh" ]; then
	source "${HOME}/z/z.sh"
elif [ -f "${HOME}/.zsh/z/z.sh" ]; then
	source "${HOME}/.zsh/z/z.sh"
fi
#}}}

#-----------------------------------------------------------------------------
# Less Tailf: {{{
if hash less 2> /dev/null; then
	function ltail {
		LESSOPEN=
		LESSCLOSE=
		less +F $@
	}
fi
#}}}

#-----------------------------------------------------------------------------
# Alias (Color): {{{
alias ls="ls --color --show-control-chars"
if hash grep 2> /dev/null; then
	alias grep="grep --color"
fi
if hash colordiff 2> /dev/null; then
	alias diff="colordiff"
fi
#}}}

#-----------------------------------------------------------------------------
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
if [ -n "${HGPAGER}" ]; then
	alias hg="hg --config pager.pager=\"${HGPAGER}\""
fi
#}}}

#-----------------------------------------------------------------------------
# Source By Platform, Host, User: {{{
if hash uname 2> /dev/null; then
	if [ -n "$(uname)" -a -f "${BASH_DIR}/.bashrc.$(uname)" ]; then
		source "${BASH_DIR}/.bashrc.$(uname)"
	fi
	if [ -n "$(uname -m)" -a -f "${BASH_DIR}/.bashrc.$(uname -m)" ]; then
		source "${BASH_DIR}/.bashrc.$(uname -m)"
	fi
	if [ -n "$(uname -n)" -a -f "${BASH_DIR}/.bashrc.$(uname -n)" ]; then
		source "${BASH_DIR}/.bashrc.$(uname -n)"
	fi
fi
if [ -n "${USER}" -a -f "${BASH_DIR}/.bashrc.${USER}" ]; then
	source "${BASH_DIR}/.bashrc.${USER}"
fi
if [ -f "${LOCAL_DIR}/.bashrc.local" ]; then
	source "${LOCAL_DIR}/.bashrc.local"
fi
#}}}

#-----------------------------------------------------------------------------
# Stty: {{{
if hash stty 2> /dev/null; then
	stty start undef
	stty stop undef
fi
#}}}

#-----------------------------------------------------------------------------
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
	_UPDATE_TITLE=
	function _update_title {
		if [ -n "$_UPDATE_TITLE" ]; then
			echo -ne "\ek`history 1|awk '{if($4==\"sudo\")print $5;else print$4}'`\e\\"
		fi
		_UPDATE_TITLE="1"
	}
	PROMPT_COMMAND="_update_title;${PROMPT_COMMAND}"
fi
#}}}
