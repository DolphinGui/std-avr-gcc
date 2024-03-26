#!/usr/bin/sh
set -ex

get()
{
FILE=$(basename $1)
DIR=${FILE%.*.*}
wget $1
dtrx $FILE
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
git clone --depth=1 https://github.com/DolphinGui/avr-libstdcpp.git

sh apply-patches.sh

sh avr.sh /out/root

rm -rdf binutils && dtrx binutils-2.42.tar.gz && mv binutils-2.42 binutils
rm -rdf gcc && dtrx gcc-13.2.0.tar.xz && mv gcc-13.2.0 gcc

export PATH=/out/root/bin:$PATH
export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++

sh avr.sh /out/winroot
