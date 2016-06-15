@echo off

mingw32-make CC=gcc LDFLAGS="-s" %*

chcp 65001 >nul
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy /y nkf.exe %HOME%\Bin\
