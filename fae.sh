#!/usr/bin/sh
set -ex

PREFIX="$1"
BUILDHOST=`realpath  $HOST-depout`
mkdir -p $BUILDHOST
export PKG_CONFIG_LIBDIR=$BUILDHOST
export LIBRARY_PATH="$BUILDHOST/lib"
export CPATH="$BUILDHOST/include"

confbuild()
{
mkdir -p "$HOST-build-$1"
cd "$HOST-build-$1"
../$1/configure $2
make -j -l 4
make install -j -l 4
cd ..
}

meson setup $HOST-build-faeutil faeutil --buildtype debugoptimized  --prefer-static \
            --pkg-config-path $BUILDHOST/lib/pkgconfig --prefix $PREFIX --wrap-mode nodownload -Dfmt:default_library=static \
            --cross-file meson-windows.txt
meson compile -C $HOST-build-faeutil 
meson install -C $HOST-build-faeutil 
