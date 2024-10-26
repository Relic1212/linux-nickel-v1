#!/bin/sh

SIZE=1

rm -f home.img
dd if=/dev/zero of=home.img bs=1024M count=${SIZE}

mkfs.ext4 home.img
tune2fs -U dd95fdd6-681c-4ebe-98eb-25822368a556 home.img
