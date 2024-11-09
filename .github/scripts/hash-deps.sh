#!/usr/bin/bash

set -e

GCC_SUM=`git ls-remote https://github.com/DolphinGui/gcc.git refs/heads/avr-except | awk '{print $1;}'`
BIN_SUM=`git ls-remote https://github.com/DolphinGui/binutils.git refs/heads/main | awk '{print $1;}'`
LIBC_SUM=`git ls-remote https://github.com/DolphinGui/avr-libc.git refs/heads/main | awk '{print $1;}'`
CONFIG_SUM=`sha1sum linux-build/.config | awk '{print $1;}'`
CTNG_SUM=`git ls-remote https://github.com/DolphinGui/crosstool-ng.git refs/heads/avr-exceptions | awk '{print $1;}'`

echo -n "$GCC_SUM""$BIN_SUM""$LIBC_SUM""$CONFIG_SUM""$CTNG_SUM" | sha1sum  | awk '{print $1;}'
