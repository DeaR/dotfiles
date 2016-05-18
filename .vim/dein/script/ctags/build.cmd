@echo off

mingw32-make -f mk_mingw.mak %*

chcp 65001
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy ctags.exe %HOME%\Bin\
