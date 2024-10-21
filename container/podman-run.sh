#!/bin/sh -e

DIR="$(realpath .)"
EARGS=""
# EARGS="${EARGS} --userns=keep-id"


podman run \
	$@ \
	$EARGS  \
	-it  \
	 --userns keep-id \
	--network host \
	--volume $DIR:$DIR \
	--workdir $DIR \
	--name nickel-llvm-alpine \
	localhost/nickel-llvm-alpine:latest
