#!/bin/sh

make $*
make MKDIR="mkdir -p" prefix=~ install-main
