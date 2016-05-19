@echo off
goto :install

rem Install DotFiles
rem
rem Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
rem Last Change:  19-May-2016.
rem License:      MIT License {{{
rem     Copyright (c) 2016 DeaR <nayuri@kuonn.mydns.jp>
rem
rem     Permission is hereby granted, free of charge, to any person obtaining a
rem     copy of this software and associated documentation files (the
rem     "Software"), to deal in the Software without restriction, including
rem     without limitation the rights to use, copy, modify, merge, publish,
rem     distribute, sublicense, and/or sell copies of the Software, and to
rem     permit persons to whom the Software is furnished to do so, subject to
rem     the following conditions:
rem
rem     The above copyright notice and this permission notice shall be included
rem     in all copies or substantial portions of the Software.
rem
rem     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
rem     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
rem     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
rem     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
rem     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
rem     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
rem     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
rem }}}

:mklink_f
if not exist "%HOME%\%~1" mklink "%HOME%\%~1" "%~f1"
exit /b 0

:mklink_d
if not exist "%HOME%\%~1" mklink /j "%HOME%\%~1" "%~f1"
exit /b 0

:dein
if not exist %1 (
  mkdir %1
  git clone https://github.com/DeaR/dein.vim.git %1
)
exit /b 0

:install
pushd "%~dp0\.."
setlocal

if not defined HOME (
  set "HOME=%USERPROFILE%"
)
if defined PROGRAMW6432 (
  set "PF64=%PROGRAMW6432%"
) else (
  set "PF64=%PROGRAMFILES%"
)
if defined PROGRAMFILES(X86) (
  set "PF32=%PROGRAMFILES(X86)%"
) else (
  set "PF32=%PROGRAMFILES%"
)
if not defined CACHE (
  if defined XDG_CACHE_HOME (
    set "CACHE=%XDG_CACHE_HOME%"
  ) else (
    set "CACHE=%HOME%\.cache"
  )
)
if not exist "%CACHE%" mkdir "%CACHE%"

rem ColorDiff
where /q colordiff.pl && (
  call :mklink_f .colordiffrc
)

rem Git
where /q git && (
  call :mklink_f .gitconfig
  call :mklink_f .gitignore
)

rem Mercurial
where /q hg && (
  call :mklink_f .hgignore
  call :mklink_f .hgrc
)

rem Nyagos
if exist "%USERPROFILE%\Apps\nyagos\nyagos.exe" (
  call :mklink_d .nyagos.d
  call :mklink_f .nyagos
)

rem NODOKA
if exist "%PF64%\nodoka\nodoka.exe" (
  call :mklink_d .nodoka.d
  call :mklink_f .nodoka
)

rem Screen
where /q screen && (
  call :mklink_f .screenrc
)

rem tmux
where /q tmux && (
  call :mklink_f .tmux.conf
)

rem Vim
where /q gvim && (
  call :mklink_f .gvimrc
)
where /q vim && (
  call :mklink_d .vim
  call :mklink_f .vimrc

  where /q git && call :dein "%CACHE%\dein\repos\github.com\Shougo\dein.vim"
)

endlocal
popd
pause
