@echo off

mingw32-make CC=gcc %*
copy nkf.exe %HOME%\bin\
