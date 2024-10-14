#!/bin/sh

while getopts "r:c" opt; do
	case "$opt" in 
		r) ROOT="$OPTARG";;
		c) COMMAND="$OPTARG";;
		p) part="$OPTARG";;
		o) outdir="$OPTARG";;
	esac
done
ROOT=
unshare \
    --user \
    --map-user=0 \
    --map-group=0 \
    --mount \
    --mount-proc \
    --fork \
    --pid \
    --root= <<"EOT"
mount -t tmpfs tmpfs /tmp
mount -t devtmpfs devtmpfs /dev
mount -n -t tmpfs -o mode=775 tmpfs /run



"EOT"