#!/usr/bin/bash
set -ex
set -uo pipefail

links=(
    https://github.com/DolphinGui/avr-libc/releases/download/main-5/avr-libc.tar.xz
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

mkdir -p cache

parallel --link \
  'TMP=$(mktemp /tmp/aunpack.XXXXXXXXXX) \
  && wget -nc {1} -P cache && ln -s cache/{1/} {1/} \
  && aunpack -q --save-outdir=$TMP {1/} && DIR=$(cat $TMP) \
  && if [ ! "$DIR" = {2} ]; then mv $DIR {2}; fi; rm $TMP' \
  ::: ${links[@]} ::: ${names[@]}

sh apply-patches.sh

export SCCACHE_CACHE_SIZE="30G"
export SCCACHE_DIR="/work/cache/sccache"

export HOST="x86_64-pc-linux-gnu"
export CC="sccache gcc"
export CXX="sccache g++"

sh avr.sh /out/root

export PATH=$PATH:/out/root/bin

export HOST="x86_64-w64-mingw32"
export HOSTFLAG="--host=$HOST"
export CC="sccache $HOST-gcc"
export CXX="sccache $HOST-g++"

sh avr.sh /out/winroot

# darwin always has to be build last because it patches GCC

export HOST="x86_64-apple-darwin24"
export HOSTFLAG="--host=$HOST"
export CC="sccache $HOST-gcc"
export CXX="sccache $HOST-g++"

wget https://raw.githubusercontent.com/Homebrew/formula-patches/refs/heads/main/gcc/gcc-13.3.0.diff
patch -p1 -dgcc < gcc-13.3.0.diff
sh avr.sh /out/osxroot
