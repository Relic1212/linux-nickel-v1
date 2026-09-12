#!/bin/sh -e

/usr/bin/mount -v -n -t tmpfs -o mode=775 tmpfs /run

/usr/bin/mkdir -p /run/var_overlay/upper
/usr/bin/mkdir -p /run/var_overlay/work
/usr/bin/modprobe overlay || /usr/bin/true
/usr/bin/mount -t overlay overlay -o lowerdir=/var,upperdir=/run/var_overlay/upper,workdir=/run/var_overlay/work /var

# export SYSTEMD_LOG_LEVEL=debug
# export SYSTEMD_LOG_LOCATION=1
# export DL_DEBUG=1

exec /usr/lib/systemd/systemd

