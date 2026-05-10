#!/bin/sh -e

DIR="$(readlink -f .)"
EARGS=""
# EARGS="${EARGS} --userns=keep-id"

podman kill nickel-arch||true
podman rm nickel-arch||true


podman run \
	$@ \
	$EARGS  \
	-it  \
	 --userns keep-id \
	--network host \
	--volume $DIR:$DIR \
	--workdir $DIR \
	--name nickel-arch \
	localhost/nickel-arch:latest
