@echo off

mingw32-make CC=gcc %*

chcp 65001
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
copy nkf.exe %HOME%\Bin\
