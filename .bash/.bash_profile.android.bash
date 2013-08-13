# Bash settings for Android
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
#     distribute, sublicense, and/or sell copies of the Software, and to
#     permit persons to whom the Software is furnished to do so, subject to
#     the following conditions:
#
#     The above copyright notice and this permission notice shall be included
#     in all copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# }}}

#-----------------------------------------------------------------------------
# Environment Variable: {{{
export TERM="xterm-256color"
export LANG="ja_JP.UTF-8"
export LC_TIME="C"
export PATH="/system/xbin:${PATH}"
export TMPDIR="/data/local/tmp"
#}}}

#-----------------------------------------------------------------------------
# Vim: {{{
export TERMINFO="/system/etc/terminfo"
export VIMRUNTIME="/system/etc/vimruntime"
#}}}

#-----------------------------------------------------------------------------
# Curl: {{{
export CURL_CA_BUNDLE="/system/ssl/certs/ca-bundle.crt"
#}}}
