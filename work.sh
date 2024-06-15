#!/usr/bin/sh
set -ex

get()
{
FILE=$(basename $1)
DIR=${FILE%.*.*}
wget $1
dtrx --one rename $FILE
if [ ! $DIR = $2 ]; then
mv $DIR $2
fi
}

get https://github.com/DolphinGui/avr-libc/releases/download/main-1/avr-libc.tar.xz avr-libc
get https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz binutils
get https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz gmp
get https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz mpfr
get https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz mpc
get https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz gcc
get https://github.com/DolphinGui/faeutil/releases/download/v1.4.0/faeutil-1.4.0.tar.xz  faeutil
get https://github.com/DolphinGui/avrexcept/archive/refs/tags/v1.0.2.tar.gz avrexcept

sh apply-patches.sh

export HOST="x86_64-pc-linux-gnu"

sh avr.sh /out/root

export PATH=/out/root/bin:$PATH
export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++

sh avr.sh /out/winroot
