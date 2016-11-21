@echo off

mingw32-make -f mk_mingw.mak WITH_ICONV=yes %*

if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
if exist ctags.exe copy /y ctags.exe %HOME%\Bin\
