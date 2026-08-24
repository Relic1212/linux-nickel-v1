#!/bin/sh

set -e


PATH=/usr/bin:/bin

# Must have sysfs mount -ved for udevtrigger to function.
mount -v -n -t sysfs sysfs /sys

# Ideally devtmpfs will be mount -ved by kernel, we can mount -v here anyway:
# mount -v -n -t devtmpfs tmpfs /dev
mkdir -p /dev/pts /dev/shm
mount -v -n -t tmpfs -o nodev,nosuid tmpfs /dev/shm
mount -v -n -t devpts -o gid=5 devpts /dev/pts

# /run, and various directories within it
mount -v -n -t tmpfs -o mode=775 tmpfs /run
mkdir /run/lock /run/udev

# "hidepid=1" doesn't appear to take effect on first mount -v of /proc,
# so we mount -v it and then remount:
mount -v -n -t proc -o hidepid=1 proc /proc
mount -v -n -t proc -o remount,hidepid=1 proc /proc

mkdir -p -m 0755 /sys/fs/cgroup 
mount -v -wt cgroup2 cgroup /sys/fs/cgroup 

mount -v -t selinuxfs selinuxfs /sys/fs/selinux || echo "Failed to mount selinuxfs. Is selinux enabled?"
mount -v -n -t tmpfs  tmpfs -o nosuid,nodev,mode=1777 /tmp 
