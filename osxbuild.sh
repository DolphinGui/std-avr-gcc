#!/usr/bin/sh

set -ex

TMP=$(mktemp /tmp/aunpack.XXXXXXXXXX)

wget https://github.com/tpoechtrager/osxcross/archive/refs/heads/master.zip
aunpack --save-outdir=$TMP master.zip
DIR=$(cat $TMP)
echo $DIR
if [ ! "$DIR" = 'osxcross' ]; then mv $DIR osxcross; fi
rm $TMP

