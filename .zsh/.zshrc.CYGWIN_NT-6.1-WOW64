# -*- mode: shell-script; coding: unix -*-

# @name        .zshrc.CYGWIN_NT-6.1
# @description Zsh interactive settings
# @namespace   http://kuonn.mydns.jp/
# @author      DeaR
# @timestamp   <2013-06-27 20:13:21 DeaR>

#-----------------------------------------------------------------------------
# Alias: {{{
if hash apt-cyg 2> /dev/null; then
  alias apt-cyg="apt-cyg -m http://ftp.iij.ad.jp/pub/cygwin/"
fi
if hash cyg-pm 2> /dev/null; then
  alias cyg-pm="cyg-pm -mirror ftp.iij.ad.jp/pub/cygwin/"
fi
if hash vim; then
  if hash gvim; then
    alias vi="gvim"
  else
    alias vi="vim"
  fi
fi
#}}}

#-----------------------------------------------------------------------------
# Golang: {{{
if hash go 2> /dev/null; then
  function go_windows_386 {
    GOOS="windows"
    GOARCH="386"
    go $@
  }
  function go_windows_amd64 {
    GOOS="windows"
    GOARCH="amd64"
    go $@
  }
fi
#}}}
