@echo off

mingw32-make -f ../../../.vim/tools/sudo/Makefile %*
copy sudo.exe %HOME%\bin\
copy sudow.exe %HOME%\bin\
