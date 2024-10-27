#!/usr/bin/python

# Written with inspo from
# https://github.com/swysocki/gpt-image/blob/main/gpt_image/partition.py

import os

def write_partition_to_image(gpt_image_path,filesystem,start,sector_size=512 ):

    with open (filesystem,'rb') as f:
        data = f.read()
    with open(gpt_image_path,'r+b') as f:
        f.seek(start*sector_size)
        f.write(data)


out = "/tmp/workdir/out/image"

gpt_image = out + "/gpt.img"

efi = out + "/efipart.vfat"
efi_start = 2048

xboota = out +"/image-boot-a.img"
xboota_start = 526336

root = out + "/image.img"
roota_start = 1574912

# allow this to be done by another package since this
# should not change so often and takes a lot of time
if not os.path.isfile(gpt_image):

    sfdisk_script=f'''
    label: gpt
    label-id: F128C731-03B8-43EA-88F1-4DC7CE8CA229
    device: gpt2.img
    unit: sectors
    first-lba: 2048
    last-lba: 12582878
    sector-size: 512

    gpt2.img1 : start=        {efi_start}, size=      524288, type=21686148-6449-6E6F-744E-656564454649, uuid=10D20191-1A5A-4B43-A6E8-0EA129B9B4AA, name="ESP"
    gpt2.img2 : start=      {xboota_start}, size=      524288, type=BC13C2FF-59E6-4262-A352-B275FD6F7172, uuid=B011C355-0EFD-4945-B2AD-5DB9A9D08EF9, name="boota"
    gpt2.img3 : start=     1050624, size=      524288, type=BC13C2FF-59E6-4262-A352-B275FD6F7172, uuid=B391F903-3D5B-1F45-8262-3717A05E4202, name="bootb"
    gpt2.img4 : start=     {roota_start}, size=     5242880, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709, uuid=D17C04A8-398E-4809-92EE-C7F17F4D6FDB, name="roota"
    gpt2.img5 : start=     6817792, size=     5242880, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709, uuid=59364898-E253-49E8-BCE4-DDC225293B33, name="rootb"

    '''
    with open(f"{out}/script.sfdisk",'w',encoding="utf-8") as f:
        f.write(sfdisk_script)

    dd=f"dd if=/dev/zero of={gpt_image} bs=1024M count=6"
    cmd=f"sfdisk < {out}/script.sfdisk {gpt_image}"
    os.system(dd)
    os.system(cmd)


write_partition_to_image(gpt_image,efi,efi_start)

write_partition_to_image(gpt_image,xboota,xboota_start)

write_partition_to_image(gpt_image,root,roota_start)

