#!/usr/bin/sh

set -ex

podman build -t avr-build .
mkdir -p out
podman run --mount type=bind,src="$(pwd)"/out,dst=/out --mount type=bind,src="$(pwd)"/cache,dst=/work/cache  avr-build bash work.sh
cd out
tar --use-compress-program="pixz -8" -cf root.tar.xz root/
tar --use-compress-program="pixz -8" -cf winroot.tar.xz winroot/
tar --use-compress-program="pixz -8" -cf osxroot.tar.xz osxroot/
cd ..
