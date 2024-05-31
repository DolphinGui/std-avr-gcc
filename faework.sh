#!/usr/bin/sh
set -ex

get()
{
FILE=$(basename $1)
DIR=${FILE%.*.*}
wget $1
dtrx -n $FILE
if [ ! $DIR = $2 ]; then
mv $DIR $2
fi
}

get https://github.com/DolphinGui/faeutil/releases/download/v1.3.2/faeutil-1.3.tar.xz faeutil

export PATH=/out/root/bin:$PATH
export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
sh fae.sh /out/winroot