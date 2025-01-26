#!/usr/bin/sh
set -ex

./download.sh

export HOST="x86_64-pc-linux-gnu"

sh avr.sh /out/root
