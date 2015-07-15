@echo off

mingw32-make -f ..\..\..\.vim\tools\the_silver_searcher\Makefile.w32 %*
copy ctags.exe %HOME%\bin\
