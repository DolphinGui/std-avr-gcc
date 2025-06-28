#!/usr/bin/sh

set -ex

podman build -t avr-build .
mkdir -p out
podman run --mount type=bind,src="$(pwd)"/out,dst=/out --mount type=bind,src="$(pwd)"/downloads,dst=/work/downloads  avr-build bash work.sh
# cd out
# tar -Ipigz -cf root.tar.xz root/
# tar -Ipigz -cf winroot.tar.xz winroot/
# tar -Ipigz -cf osxroot.tar.xz osxroot/
# cd ..
