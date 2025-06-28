#!/usr/bin/sh

set -ex

podman build -t avr-build .
mkdir -p out
podman run --mount type=bind,src="$(pwd)"/out,dst=/out --mount type=bind,src="$(pwd)"/cache,dst=/work/cache  avr-build bash work.sh
cd out
tar --use-compress-program="zstd -T0" -cf root.tar.zst root/
tar --use-compress-program="zstd -T0" -cf winroot.tar.zst winroot/
tar --use-compress-program="zstd -T0" -cf osxroot.tar.zst osxroot/
cd ..
