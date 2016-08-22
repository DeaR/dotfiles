@echo off

mingw32-make CC=gcc %*
mingw32-make MKDIR="mkdir -p" prefix=~ install-main
