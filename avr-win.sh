#!/usr/bin/sh
# from https://gist.github.com/ricardocosme/5ec8ad05b5f4adb66464a146dcc41545,
# replace with later with some
#[1] https://timsong-cpp.github.io/cppwp/n4861/compliance

set -ex

HOST="--host=x86_64-w64-mingw32"

BASEDIR=$(realpath $(dirname $0))
PREFIX=$BASEDIR/"${1:-root}"
WORKDIR="$BASEDIR/${2:-work}"
WINROOT="$BASEDIR/winroot"
export PREFIX

mkdir $WORKDIR
cd $WORKDIR

export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-gcc

confbuild()
{
wget $1
dtrx $2
cd $3
mkdir obj
cd obj
../configure $4
make -j32
make install
cd ../..
}

ARGS="--disable-bootstrap $HOST --prefix=$PREFIX --target=avr --disable-nls"
confbuild https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz binutils-2.42.tar.gz  binutils-2.42 $ARGS

export PATH=$PREFIX/bin:$PATH

wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
tar -Jxf gmp-6.3.0.tar.xz


git clone https://github.com/DolphinGui/gcc.git --depth=1
cd gcc
mkdir obj
cd obj
../configure $HOST --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --program-prefix=avr-
make -j32
make install
cd ../..


git clone --depth=1 https://github.com/avrdudes/avr-libc.git
cd avr-libc
git fetch --depth=1 origin 22d588c80066102993263018d5324d1424c13f0d
git checkout  22d588c80066102993263018d5324d1424c13f0d
./bootstrap
mkdir obj
cd obj
../configure $HOST --prefix=$PREFIX --build=`../config.guess` --host=avr
make -j32
make install
cd ../../

cd gcc
cd obj
../configure $HOST --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --with-newlib --disable-__cxa_atexit --disable-threads --disable-shared --enable-libstdcxx --disable-bootstrap --enable-libstdcxx-static-eh-pool --program-prefix=avr- --enable-cxx-flags='-fexceptions -frtti' --enable-c-flags='-fexceptions' --disable-hosted-libstdcxx 
make -j32
make install
cd ../../

git clone --depth=1 https://github.com/DolphinGui/avr-libstdcpp.git
cd avr-libstdcpp
./inject.sh $PREFIX/avr/include/c++/14.0.1/
cd ..

cd ..
