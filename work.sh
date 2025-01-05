#!/usr/bin/sh
set -ex

links=(
    https://github.com/DolphinGui/avr-libc/releases/download/main-3/avr-libc.tar.xz
    https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz
    https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
    https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz
    https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
    https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz
    https://github.com/DolphinGui/osxcross/releases/download/v1/target.tar.xz
)

names=(
    avr-libc
    binutils
    gmp
    mpfr
    mpc
    gcc
    osxtoolchain
)


parallel --plus --link "wget {1} && aunpack {1/} && if [ ! {1/..} = {2} ]; then mv {1/..} {2}; fi" ::: ${links[@]} ::: ${names[@]}

export PATH=$(pwd)/osxtoolchain/bin/:"$PATH"

ls $(pwd)/osxtoolchain

o64-clang --version

sh apply-patches.sh

export HOST="x86_64-pc-linux-gnu"

sh avr.sh /out/root

export HOST="arm64-apple-darwin23.5"
export HOSTFLAG="--host=$HOST"
export CC=arm64-apple-darwin23.5-clang
export CXX=arm64-apple-darwin23.5-clang-g++

sh avr.sh /out/osxroot

export PATH=/out/root/bin:$PATH
export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++

sh avr.sh /out/winroot
