#!/bin/sh

if which gmake > /dev/null; then
  gmake $*
else
  make $*
fi
