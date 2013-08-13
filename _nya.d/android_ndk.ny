# Android NDK for NYAOS 3.x
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

android_ndk{
  set NDK_TOP=C:\Apps\android-ndk-r9

  set SYSROOT=%NDK_TOP%\platforms\android-18\arch-arm
  set CFLAGS=-march=armv6 -msoft-float
  if %PROGRAMFILES(X86).defined% -ne 0 then
    set CC=%NDK_TOP%\toolchains\arm-linux-androideabi-4.8\prebuilt\windows-x86_64\bin\arm-linux-androideabi-gcc.exe -mandroid --sysroot=%SYSROOT%
  else
    set CC=%NDK_TOP%\toolchains\arm-linux-androideabi-4.8\prebuilt\windows-x86\bin\arm-linux-androideabi-gcc.exe -mandroid --sysroot=%SYSROOT%
  endif

  set CXX=
  set CCC=
  set C_INCLUDE_PATH=
  set CPP_INCLUDE_PATH=
  set LIBRARY_PATH=
}
