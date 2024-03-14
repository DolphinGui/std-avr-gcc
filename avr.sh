#!/usr/bin/sh
# from https://gist.github.com/ricardocosme/5ec8ad05b5f4adb66464a146dcc41545,
# replace with later with some
#[1] https://timsong-cpp.github.io/cppwp/n4861/compliance

BASEDIR=$(realpath $(dirname $0))
PREFIX=$BASEDIR/root
export PREFIX

wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz
tar zxf binutils-2.42.tar.gz
cd binutils-2.42
mkdir obj
cd obj
../configure --prefix=$PREFIX --target=avr --disable-nls
make -j32
make install
cd ../../

export PATH=$PREFIX/bin:$PATH

git clone https://github.com/DolphinGui/gcc.git --depth=1
cd gcc
mkdir obj
cd obj
../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 --program-prefix=avr-
make -j32
make install
cd ../..


git clone --depth=1 https://github.com/avrdudes/avr-libc.git
cd avr-libc
git fetch --depth=1 22d588c80066102993263018d5324d1424c13f0d
mkdir obj
cd obj
../configure --prefix=$PREFIX --build=`../config.guess` --host=avr
make -j16
make install
cd ../../

cd gcc
cd obj
../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --with-newlib --disable-__cxa_atexit --disable-threads --disable-shared --enable-libstdcxx --disable-bootstrap --enable-libstdcxx-static-eh-pool --program-prefix=avr- --enable-cxx-flags='-fexceptions -frtti' --enable-c-flags='-fexceptions' --disable-hosted-libstdcxx 
make -j16
make install

