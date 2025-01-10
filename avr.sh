#!/usr/bin/bash
# from https://gist.github.com/ricardocosme/5ec8ad05b5f4adb66464a146dcc41545,
# replace with later with some
#[1] https://timsong-cpp.github.io/cppwp/n4861/compliance

set -ex

export PREFIX="$1"

confbuild()
{
mkdir -p "$HOST-build-$1"
cd "$HOST-build-$1"
../$1/configure $2
make -j -l 8
make install -j 8
cd ..
if [ ! -n "$3" ]; then rm -rdf $HOST-build-$1; fi
}

WARNINGFLAGS='-Wno-mismatched-tags'
export CFLAGS="-O3 $WARNINGFLAGS"
export CXXFLAGS="-O3 $WARNINGFLAGS"

if [ -n "$HOSTFLAG" ]; then
ARGS="$HOSTFLAG --prefix=$PREFIX --enable-static --disable-shared --cache-file=/out/native-$HOST.cache"
confbuild gmp "$ARGS" nodelete
GMPBUILD=$(realpath $HOST-build-gmp)
confbuild mpfr "$ARGS --with-gmp-build=$GMPBUILD" nodelete
confbuild mpc "$ARGS --with-gmp=$PREFIX --with-mpfr=$PREFIX" nodelete
rm -rdf $HOST-build-gmp $HOST-build-mpfr $HOST-build-mpc
DEPFLAGS="--with-gmp=$PREFIX --with-mpfr=$PREFIX --with-mpc=$PREFIX"
fi

confbuild binutils "--prefix=$PREFIX --target=avr $HOSTFLAG"

# When cross compiling we can't actually execute binutils
if [ ! -n "$HOSTFLAG" ]; then
export PATH=$PREFIX/bin:$PATH
fi

# canadian build is always expected to happen after unix build, where unix build already has built avr-gcc
if ! type avr-gcc; then
confbuild gcc \
    "--prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls \
    --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --program-prefix=avr- --cache-file=/out/avr-$HOST.cache"
fi

# c compiler needs to be chnaged to avr compiler temporarily
TMPC="$CC"
TMPCXX="$CXX"
export CC=avr-gcc
export CXX=avr-g++
confbuild avr-libc "--prefix=$PREFIX --host=avr"
export CC="$TMPC"
export CXX="$TMPCXX"


confbuild gcc "--prefix=$PREFIX  --target=avr $HOSTFLAG \
  --enable-languages=c,c++ --disable-nls --disable-libssp --disable-sjlj-exceptions \
  --with-dwarf2 --with-avrlibc --disable-__cxa_atexit  --disable-threads --disable-shared \
  --enable-libstdcxx --disable-bootstrap --enable-libstdcxx-static-eh-pool  \
 --program-prefix=avr- --disable-libstdcxx-verbose --with-libstdcxx-eh-pool-obj-count=2 --cache-file=/out/avr2-$HOST.cache \
   $DEPFLAGS"
