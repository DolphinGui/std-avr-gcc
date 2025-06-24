#!/usr/bin/bash
set -ex

links=(
    https://github.com/DolphinGui/avr-libc/releases/download/main-4/avr-libc.tar.xz
    https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz
    https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
    https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz
    https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
    https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.3.0/gcc-13.3.0.tar.xz
)

names=(
    avr-libc
    binutils
    gmp
    mpfr
    mpc
    gcc
)

parallel --link \
  'TMP=$(mktemp /tmp/aunpack.XXXXXXXXXX) \
  && wget {1} \
  && aunpack -q --save-outdir=$TMP {1/} && DIR=$(cat $TMP) \
  && if [ ! "$DIR" = {2} ]; then mv $DIR {2}; fi; rm $TMP' \
  ::: ${links[@]} ::: ${names[@]}

sh apply-patches.sh

export HOST="x86_64-pc-linux-gnu"

sh avr.sh /out/root

export PATH=/out/root/bin:$PATH

export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC="$HOST-gcc"
export CXX="$HOST-g++"

sh avr.sh /out/winroot

# darwin always has to be build last because it patches GCC

export HOST="aarch64-apple-darwin24"
export HOSTFLAG="--host=$HOST"
export CC="$HOST-gcc"
export CXX="$HOST-g++"

wget https://raw.githubusercontent.com/Homebrew/formula-patches/refs/heads/master/gcc/gcc-13.3.0.diff
patch -p1 -dgcc < gcc-13.3.0.diff
sh avr.sh /out/osxroot
