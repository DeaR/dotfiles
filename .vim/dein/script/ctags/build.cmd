@echo off

mingw32-make -f mk_mingw.mak WITH_ICONV=yes %*

chcp 65001 >nul
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy /y ctags.exe %HOME%\Bin\
