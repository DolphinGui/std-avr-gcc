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
make -j -l 4
make install -j -l 4
cd ..
}

export CFLAGS='-fexceptions -Oz -ffunction-sections -fdata-sections'
export CXXFLAGS='-fexceptions -frtti -Oz -ffunction-sections -fdata-sections'

if [ -n "$HOSTFLAG" ]; then
ARGS="$HOSTFLAG --prefix=/usr/$HOST --enable-static --disable-shared"
confbuild gmp "$ARGS"
confbuild mpfr "$ARGS"
confbuild mpc "$ARGS"
fi

confbuild binutils "--prefix=$PREFIX --target=avr $HOSTFLAG"
export PATH=$PREFIX/bin:$PATH

# win build is always expected to happen after unix build, where unix build already has built avr-gcc
if ! type avr-gcc; then
confbuild gcc \
    "--prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls \
    --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --program-prefix=avr- --with-specs=%{!frtti:%{!frtti:-frtti}}% \
    --with-specs=%{!fexceptions:%{!fexceptions:-fexceptions}}"
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
 --program-prefix=avr- --disable-libstdcxx-verbose --with-libstdcxx-eh-pool-obj-count=2 \
 --with-specs=%{!frtti:%{!frtti:-frtti}} \
 --with-specs=%{!fexceptions:%{!fexceptions:-fexceptions}}"
