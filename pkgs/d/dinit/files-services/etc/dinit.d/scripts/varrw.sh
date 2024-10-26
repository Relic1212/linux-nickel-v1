#!/bin/sh -e

mkdir -p /run/var_overlay/upper
mkdir -p /run/var_overlay/work

modprobe overlay || /usr/bin/true

mount -t overlay overlay -o lowerdir=/var,upperdir=/run/var_overlay/upper,workdir=/run/var_overlay/work /var
