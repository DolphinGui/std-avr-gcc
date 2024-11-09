#!/usr/bin/bash

set -ex

git clone -b avr-exceptions --single-branch https://github.com/DolphinGui/crosstool-ng.git --depth=1
cd crosstool-ng
./bootstrap
cd ..
mkdir ctbuild
mkdir ctroot
cd ctbuild
../crosstool-ng/configure --prefix=`realpath ../ctroot`
make -j
make install -j
cd ..

