#!/bin/sh

./autogen.sh
./configure
make $*
if which sudo > /dev.null; then
  sudo make install
else
  make install
fi
