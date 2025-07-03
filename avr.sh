#!/usr/bin/bash
# from https://gist.github.com/ricardocosme/5ec8ad05b5f4adb66464a146dcc41545,
# replace with later with some
#[1] https://timsong-cpp.github.io/cppwp/n4861/compliance

set -ex

PREFIX="$1"

cores=$(nproc)

confbuild() {
  mkdir -p "$HOST-build-$1"
  cd "$HOST-build-$1"
  ../$1/configure $2
  make -j -l $cores
  make install -j $cores
  cd ..
  if [ ! -n "$3" ]; then rm -rdf $HOST-build-$1; fi
}

if [ -n "$HOSTFLAG" ]; then
  ARGS="$HOSTFLAG --prefix=$PREFIX --enable-static --disable-shared --cache-file=/work/cache/native-$HOST.cache"
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
    --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --program-prefix=avr- --cache-file=/work/cache/avr-$HOST.cache" \
    nodelete

  # c compiler needs to be chnaged to avr compiler temporarily
  TMPC="$CC"
  TMPCXX="$CXX"
  export CC=avr-gcc
  export CXX=avr-g++
  confbuild avr-libc "--prefix=/tmp/avr-libc --host=avr"
  export CC="$TMPC"
  export CXX="$TMPCXX"
  # This is kinda stupid, but it beats compiling avr-libc 3 times
  cp -r -T /tmp/avr-libc $PREFIX
  cp -r -T /tmp/avr-libc /out/winroot
  cp -r -T /tmp/avr-libc /out/osxroot
  rm -rdf  /tmp/avr-libc
fi

# This is dumb, but for some reason parameter expansion reacts poorly with the
# enable-cxx-flags parameter

mkdir -p "$HOST-build-gcc"
cd "$HOST-build-gcc"
../gcc/configure --prefix=$PREFIX  --target=avr $HOSTFLAG \
  --enable-languages=c,c++ --disable-nls --disable-libssp --disable-sjlj-exceptions \
  --with-dwarf2 --with-avrlibc --disable-__cxa_atexit  --disable-threads --disable-shared \
  --enable-libstdcxx --disable-bootstrap --disable-libstdcxx-filesystem-ts  \
  --program-prefix=avr- --disable-libstdcxx-verbose --cache-file=/work/cache/avr2-$HOST.cache \
   --enable-cxx-flags='-fno-exceptions' --with-debug-prefix-map="$PWD=." $DEPFLAGS
   
make -j -l $cores
make install -j $cores
cd ..
rm -rdf $HOST-build-gcc
