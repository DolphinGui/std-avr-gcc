#!/usr/bin/sh
#This is a step-by-step guide to build the avr-gcc 10.2 with the
#libstdc++ using the freestanding implementation[1]. 
#
#Don't expect a robust script without boilerplates or something coded
#to be resilient. This is only a short register of what I need to
#obtain the compiler in this mode.
#
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
exit
wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.1.0.tar.bz2
tar jxf avr-libc-2.1.0.tar.bz2
cd avr-libc-2.1.0
mkdir obj
cd obj
../configure --prefix=$PREFIX --build=`../config.guess` --host=avr
make -j16
make install
cd ../../

#cd gcc-13.2.0
#cd obj
#../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --disable-sjlj-exceptions --with-dwarf2 --with-newlib --disable-__cxa_atexit --disable-threads --disable-shared --enable-libstdcxx --disable-bootstrap --enable-libstdcxx-static-eh-pool --program-prefix=avr- --enable-cxx-flags='-fexceptions -frtti' --enable-c-flags='-fexceptions' --enable-clocale=generic
# --disable-hosted-libstdcxx 
#make -j16
#make install

