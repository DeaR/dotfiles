@echo off

mingw32-make CC=gcc %*
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy nkf.exe %HOME%\Bin\
