@echo off

mingw32-make -f %HOME%\.vim\tools\the_silver_searcher\Makefile.w32 %*
copy ag.exe %HOME%\bin\
