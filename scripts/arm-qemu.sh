#!/bin/sh


# https://translatedcode.wordpress.com/2017/07/24/installing-debian-on-qemus-64-bit-arm-virt-board/

qemu-system-aarch64 \
	-nographic \
	-M virt \
	-m 4G  \
	-kernel build/tmp/aarch64-image/out/destdir/Image   \
	-append "root=/dev/vda rootwait ro rootfstype=erofs init=/bin/sh   debug "  \
	-hda build/tmp/aarch64-image/out/destdir/aarch64-root.img \
	-cpu cortex-a57
