@echo off

mingw32-make CC=gcc %*

chcp 65001 >nul
if not exist "%HOME%\Bin" mkdir "%HOME%\Bin"
if exist nkf.exe copy /y nkf.exe %HOME%\Bin\
