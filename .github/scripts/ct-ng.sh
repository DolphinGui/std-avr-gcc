#!/usr/bin/bash

set -ex

git clone git@github.com:DolphinGui/crosstool-ng.git --depth=1
cd crosstool-ng
./bootstrap
cd ..
mkdir build
mkdir ctroot
cd build
../crosstool-ng/configure --prefix=`realpath ../ctroot`
make -j
make install -j
cd ..
echo `realpath ../ctroot` >> "$GITHUB_PATH"

