#!/usr/bin/bash

set -ex

FILES=$(find patches -name '*.patch')

for patch in $FILES; do
target=${patch#patches/}
target=${target%.patch}
patch -p1 -d$target < $patch
done
