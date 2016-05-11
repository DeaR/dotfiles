@echo off

mingw32-make -f mk_mingw.mak %*
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy ctags.exe %HOME%\Bin\
