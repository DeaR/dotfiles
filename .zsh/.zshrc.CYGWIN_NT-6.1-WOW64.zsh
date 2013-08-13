# Zsh interactive settings for Cygwin
#
# Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
# Last Change:  13-Aug-2013.
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
