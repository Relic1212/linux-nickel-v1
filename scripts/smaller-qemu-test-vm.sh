#!/bin/sh
qemu_run=qemu-system-x86_64
command -v nixGL > /dev/null && qemu_run="nixGL  qemu-system-x86_64"
command -v nixGLIntel > /dev/null && qemu_run="nixGLIntel  qemu-system-x86_64"

P="./build/tmp/base-image-small/out"

VMLINUZ="${P}/destdir/rootfs/boot/bzImage"
# VMLINUZ="/tmp/vmlinux.bin.patched"
# VMLINUZ="/tmp/boot/bzImage"

# VMLINUZ="/tmp/bzImage"



# DISPLAY_ARGS="-display gtk,gl=on,show-cursor=off,grab-on-hover=on 	-device virtio-vga-gl"
DISPLAY_ARGS=" -vga qxl  -display gtk,gl=off"


USB_ARGS=" -usb -device nec-usb-xhci,id=xhci -global nec-usb-xhci.msi=off 	-device usb-ehci,id=ehci -device usb-tablet"

USB_ARGS=" -device qemu-xhci -usb -device usb-host,hostbus=1,hostport=1.4.1.4 -usbdevice tablet"

CMDLINE="$( cat ${P}/image/image.img.cmdline.txt )"

CMDLINE="${CMDLINE} console=ttyS0 ro rootwait dm-mod.waitfor=/dev/sda"



export ALSA_PLUGIN_DIR="${ALSA_PLUGIN_DIR_NIX}"
AUDIO_ARGS=""
# AUDIO_ARGS=" -audio driver=pa,model=virtio,server=${XDG_RUNTIME_DIR}/pulse/native "




echo "--------------------------------"
echo $CMDLINE
echo "--------------------------------"

$qemu_run $USB_ARGS $AUDIO_ARGS  \
	-m 4G -cpu host -smp 4  --enable-kvm \
	 $DISPLAY_ARGS \
	--kernel $VMLINUZ \
	--append  "${CMDLINE}" \
	  -nic user,hostfwd=tcp::60025-:22 \
	-hda "${P}/image/image.img" \
	-hdb home.img $@ #\
	#-hdc out/var_log.img 
