#!/bin/sh

xbuild server/OmniSharp.sln /p:Configuration="Release" /p:Platform="Any CPU" $*
