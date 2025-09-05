#!/usr/bin/env python 

import sys 
import os

import subprocess

def system_run(cmd):
    print(f"running command: \"{cmd}\"")
    os.system(cmd)

 
old_cmdline = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# new_cmdline = 'dm-mod.create="verity,,,ro,0 5062248 verity 1 /dev/sda /dev/sda 4096 4096 632781 632782 sha256 d5a57caaede53db1272e84b5b26000223451e872dacd61d9b57431a72d3dd3bb 48fb834b564d6763300b00bc6825474a903b026491c686a62be12ad9de82c25f 9 ignore_zero_blocks use_fec_from_device /dev/sda fec_roots 2 fec_start 637765 fec_blocks 637765" rootfstype=erofs root=/dev/dm-0 init=/usr/bin/dinit console=ttyS0 console=tty1 console=tty0'


new_cmdline = "console=ttyS0 "


# vmlinux_bin = sys.argv[1]
# setup_bin = sys.argv[2]
# new_cmdline = sys.argv[3]

# with open("build/tmp/base-image/out/image/image.img.cmdline.txt") as f:
#     new_cmdline = f.read()

new_cmdline = new_cmdline.strip()

# new_cmdline = " console=ttyS0 " + new_cmdline

print(f"new: \"{new_cmdline}\"")




# exit()

if len(new_cmdline) > len(old_cmdline):
    raise Exception()

while(len(new_cmdline.encode()) < len(old_cmdline.encode())):
    new_cmdline+=" "

# print(f"c: \"{old_cmdline}\"")
# print(f"c: \"{new_cmdline}\"")

if len(new_cmdline)!=len(old_cmdline):
    raise Exception()

old_cmdline_b = old_cmdline.encode()
new_cmdline_b = new_cmdline.encode()



old_cmdline_dots = chr(0).join([x for x in old_cmdline ])

new_cmdline_dots = chr(0).join([x  for x in new_cmdline ])

new_cmdline_dots_b = new_cmdline_dots.encode()
old_cmdline_dots_b = old_cmdline_dots.encode()

print(new_cmdline_dots_b)


# print("cmdline",old_cmdline_b)

# kernel_in = sys.argv[1]

# kernel_in = "build/tmp/linux-fedora/src/arch/x86/boot/compressed/vmlinux"
kernel_in = "/tmp/vmlinux"



# if len(sys.argv)>2:
#     kernel_out = sys.argv[2]
# else:
#     kernel_out = f"{kernel_in}.patched"
#     if os.path.exists(kernel_out):
#         raise Exception()

kernel_out = "/tmp/c-vmlinux"

with open(kernel_in,"rb") as f:
    data = f.read()

if not (old_cmdline_b in data):
    raise Exception("now nonex")

if not (old_cmdline_dots_b in data):
    raise Exception("old nonex")

# exit()
new_kernel = data
new_kernel = new_kernel.replace(old_cmdline_b,new_cmdline_b)
new_kernel = new_kernel.replace(old_cmdline_dots_b,new_cmdline_dots_b)



subprocess.run(["rm","-rf",kernel_out],check=True)
subprocess.run(["rm","-rf",kernel_out],check=True)

with open(kernel_out,"wb") as f:
    f.write(new_kernel)



vbo = "/tmp/vmlinux.bin"
bz = "/tmp/bzImage"
subprocess.run(["rm","-rf",vbo],check=True)

# subprocess.run(["cp",kernel_in,kernel_out],check=True)
# subprocess.run(["sed","-i" , f"'s@{old_cmdline}@{new_cmdline}@g'",kernel_out],check=True,)

# os.system( f"sed -i 's@{old_cmdline}@{new_cmdline}@g' {kernel_out}" )


# savedcmd_arch/x86/boot/bzImage := (dd if=arch/x86/boot/setup.bin bs=4k conv=sync status=none; cat arch/x86/boot/vmlinux.bin) >arch/x86/boot/bzImage

system_run(f"llvm-objcopy  -O binary -R .note -R .comment -S {kernel_out} {vbo}")


# setup_bin = "build/tmp/linux-fedora/src/arch/x86/boot/setup.bin"
setup_bin = "/tmp/setup.bin"
system_run(f"(dd if={setup_bin} bs=4k conv=sync status=none; cat {vbo}) >{bz}")

# savedcmd_arch/x86/boot/bzImage := (dd if=/tmp/boot/setup.bin bs=4k conv=sync status=none; cat /tmp/boot/vmlinux.bin.patched) >/tmp/bzImage

