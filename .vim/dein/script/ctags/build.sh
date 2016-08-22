#!/bin/sh

./autogen.sh
./configure --prefix=~
make $*
make install
