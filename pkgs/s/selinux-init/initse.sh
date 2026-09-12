#!/bin/sh -e

/usr/bin/load_policy -i 

/usr/bin/mount -v -n -t tmpfs -o mode=775 tmpfs /run
/usr/bin/restorecon -rvF /run

/usr/bin/mountpoint -q /sys || \
    /usr/bin/mount -v -n -t sysfs sysfs /sys

/usr/bin/mountpoint -q /sys/fs/selinux || \
    /usr/bin/mount -v -t selinuxfs selinuxfs /sys/fs/selinux

# /usr/bin/restorecon -rvF /sys



for s in $(cat /proc/cmdline); do 
    if [ "$s" = "single" ];then 
        printf "running single"
        exec /usr/bin/dinit single
    fi 
done  

exec /usr/bin/dinit
