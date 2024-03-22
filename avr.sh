#!/usr/bin/bash
# from https://gist.github.com/ricardocosme/5ec8ad05b5f4adb66464a146dcc41545,
# replace with later with some
#[1] https://timsong-cpp.github.io/cppwp/n4861/compliance

set -ex

PREFIX="$1"
WORKDIR="$2"
OLDDIR=$PWD
mkdir -p $WORKDIR
cd $WORKDIR

confbuild()
{
FILE=$(basename $1)
DIR=${FILE%.*.*}
if [ ! -f "$DIR" ];then
cd ..
if [ ! -f "$FILE" ];then
wget $1
fi
dtrx $FILE
mv $DIR $WORKDIR/$DIR
cd $WORKDIR
fi
cd $DIR
mkdir -p obj
cd obj
eval "$3"
../configure $2
make -j8
make install
cd ../..
}


if [ -n "$HOSTFLAG" ]; then
ARGS="$HOSTFLAG --prefix=$PREFIX --enable-static --disable-shared"
confbuild https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz "$ARGS"
confbuild https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz "$ARGS --with-gmp=$PREFIX"
confbuild https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz "$ARGS --with-gmp=$PREFIX --with-mpfr=$PREFIX"
LIBS="--with-gmp=$PREFIX --with-mpfr=$PREFIX --with-mpc=$PREFIX"
fi

confbuild https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz "--disable-bootstrap --prefix=$PREFIX --target=avr $HOSTFLAG --disable-nls"
export PATH=$PREFIX/bin:$PATH

# win build is always expected to happen after unix build, where unix build already has built avr-gcc
if ! type avr-gcc; then
confbuild https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz \
    "--prefix=$PREFIX --target=avr --build=`../config.guess` --enable-languages=c,c++ --disable-nls \
    --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --program-prefix=avr- --with-specs=%{!frtti:%{!frtti:-frtti}}% \
    --with-specs=%{!fexceptions:%{!fexceptions:-fexceptions}}"
fi

# c compiler needs to be chnaged to avr compiler temporarily
TMPC="$CC"
TMPCXX="$CXX"
export CC=avr-gcc
export CXX=avr-g++
confbuild https://github.com/DolphinGui/avr-libc/releases/download/main-1/avr-libc.tar.xz \
"--prefix=$PREFIX --host=avr"
export CC="$TMPC"
export CXX="$TMPCXX"


confbuild gcc-13.2.0.tar.xz "--prefix=$PREFIX --target=avr $HOSTFLAG  --build=`../config.guess` --enable-languages=c,c++ --disable-nls \
  --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --with-newlib --disable-__cxa_atexit $LIBS \
  --disable-threads --disable-shared --enable-libstdcxx --disable-bootstrap --enable-libstdcxx-static-eh-pool \
  --program-prefix=avr- --enable-c-flags='-fexceptions' \
  --disable-hosted-libstdcxx --with-specs=%{!frtti:%{!frtti:-frtti}}% --with-specs=%{!fexceptions:%{!fexceptions:-fexceptions}}"


git clone --depth=1 https://github.com/DolphinGui/avr-libstdcpp.git
cd avr-libstdcpp
./inject.sh $PREFIX/avr/include/c++/13.2.0/

cd $OLDDIR
