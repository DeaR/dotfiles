@echo off
goto :runas

rem Install DotFiles
rem
rem Maintainer:   DeaR <nayuri@kuonn.mydns.jp>
rem Last Change:  07-Jun-2016.
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

:mklink
if "%2" == "" (
  call :mklink %1 "%HOME%\%~1"
) else if not exist "%2" (
  if exist "%~1\" (
    mklink /j %2 "%~f1"
  ) else (
    mklink %2 "%~f1"
  )
)
exit /b 0

:dein
if not exist %1 (
  set /p REPLY="Install dein.vim? (y/N): "
  if /i "!REPLY!" neq "y" exit /b 0

  mkdir %1
  git clone https://github.com/Shougo/dein.vim.git %1
)
exit /b 0

:runas
whoami /priv | find "SeLoadDriverPrivilege" >nul
if errorlevel 1 (
  powershell.exe -Command Start-Process """%0""" -Verb Runas
  exit /b 0
)

:install
pushd "%~dp0\.."
setlocal enabledelayedexpansion

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

if not defined XDG_DATA_HOME (
  set "XDG_DATA_HOME=%HOME%\.local\share"
)
if not defined XDG_CACHE_HOME (
  set "XDG_CACHE_HOME=%HOME%\.cache"
)
if not defined XDG_CONFIG_HOME (
  set "XDG_CONFIG_HOME=%HOME%\.config"
)
if not exist "%XDG_DATA_HOME%"   mkdir "%XDG_DATA_HOME%"
if not exist "%XDG_CACHE_HOME%"  mkdir "%XDG_CACHE_HOME%"
rem if not exist "%XDG_CONFIG_HOME%" mkdir "%XDG_CONFIG_HOME%"
call :mklink .config "%XDG_CONFIG_HOME%"

rem Bash
where /q bash && (
  call :mklink .bash.d
  call :mklink .bash_profile
  call :mklink .bashrc
  call :mklink .inputrc
)

rem ColorDiff
where /q colordiff.pl && (
  call :mklink .colordiffrc
)

rem Git
where /q git && (
  call :mklink .gitconfig
  call :mklink .gitignore
)

rem Mercurial
where /q hg && (
  call :mklink .hgignore
  call :mklink .hgrc
)

rem Nyagos
if exist "%USERPROFILE%\Apps\nyagos-*" (
  call :mklink .nyagos.d
  call :mklink .nyagos
)

rem NODOKA
if exist "%PF64%\nodoka" (
  call :mklink .nodoka.d
  call :mklink .nodoka
)

rem Screen
where /q screen && (
  call :mklink .screenrc
)

rem tmux
where /q tmux && (
  call :mklink .tmux.conf
)

rem Vim
where /q gvim && (
  call :mklink .gvimrc
)
where /q vim && (
  call :mklink .vim
  call :mklink .vimrc

  where /q git && call :dein "%XDG_DATA_HOME%\dein\repos\github.com\Shougo\dein.vim"
)

endlocal
popd
pause
