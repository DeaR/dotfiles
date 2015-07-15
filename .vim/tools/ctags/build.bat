@echo off

mingw32-make -f mk_mingw.mak %*
copy ctags.exe %HOME%\bin\
