#!/usr/bin/sh

BASEDIR=$(realpath $(dirname $0))



sh avr.sh /out/root $BASEDIR/work

export PATH=$BASEDIR/root/bin:$PATH
export HOSTFLAG="--host=x86_64-w64-mingw32"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++

sh avr.sh /out/winroot $BASEDIR/winwork
