#!/usr/bin/sh
set -ex

links="
    https://github.com/DolphinGui/avr-libc/releases/download/main-4/avr-libc.tar.xz
    https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz
    https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
    https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz
    https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
    https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.3.0/gcc-13.3.0.tar.xz
"

names="
    avr-libc
    binutils
    gmp
    mpfr
    mpc
    gcc
"

parallel --link \
  'TMP=$(mktemp /tmp/aunpack.XXXXXXXXXX) \
  && wget {1} \
  && aunpack -q --save-outdir=$TMP {1/} && DIR=$(cat $TMP) \
  && if [ ! "$DIR" = {2} ]; then mv $DIR {2}; fi; rm $TMP' \
  ::: ${links[@]} ::: ${names[@]}

sh apply-patches.sh


