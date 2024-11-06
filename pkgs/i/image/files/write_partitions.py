#!/usr/bin/python

# Written with inspo from
# https://github.com/swysocki/gpt-image/blob/main/gpt_image/partition.py

import os

import argparse


def write_partition_to_image(gpt_image_path, filesystem, start):
    sector_size = 512
    print(f"write_partition_to_image({gpt_image_path},{filesystem},{start} )")
    with open(filesystem, "rb") as f:
        data = f.read()
    with open(gpt_image_path, "r+b") as f:
        f.seek(start * sector_size)
        f.write(data)


def write_gpt(out: str, partauuid: str, root_size: int, includeb: bool):
    if out is None:
        out = "/tmp/workdir/out/image"
    if partauuid is None:
        partauuid = "D17C04A8-398E-4809-92EE-C7F17F4D6FDB"
    if root_size is None:
        root_size = 5242880

    gpt_image = out + "/gpt.img"

    efi = out + "/efipart.vfat"
    efi_start = 2048

    xboota = out + "/image-boot-a.img"

    root = out + "/image.img"

    efi_size = 524288
    xboot_size = 524288

    uuid_a = partauuid  # "D17C04A8-398E-4809-92EE-C7F17F4D6FDB"
    uuid_b = "59364898-E253-49E8-BCE4-DDC225293B33"

    # allow this to be done by another package since this
    # should not change so often and takes a lot of time
    if not os.path.isfile(gpt_image):

        sfdisk_script = f"""
        label: gpt
        label-id: F128C731-03B8-43EA-88F1-4DC7CE8CA229
        device: gpt2.img
        unit: sectors
        sector-size: 512

        gpt2.img1 : start={efi_start}, size={efi_size}, type=21686148-6449-6E6F-744E-656564454649, uuid=10D20191-1A5A-4B43-A6E8-0EA129B9B4AA, name="ESP"
        gpt2.img2 : start={efi_start+efi_size}, size={xboot_size}, type=BC13C2FF-59E6-4262-A352-B275FD6F7172, uuid=B011C355-0EFD-4945-B2AD-5DB9A9D08EF9, name="boota"
        gpt2.img3 : start={efi_start+efi_size+xboot_size}, size={xboot_size}, type=BC13C2FF-59E6-4262-A352-B275FD6F7172, uuid=B391F903-3D5B-1F45-8262-3717A05E4202, name="bootb"
        gpt2.img4 : start={efi_start+efi_size+2*xboot_size}, size={root_size}, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709, uuid={uuid_a}, name="roota"

        """
        if includeb:
            sfdisk_script += f"""
        gpt2.img5 : start={efi_start+efi_size+2*xboot_size+root_size}, size= {root_size}, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709, uuid={uuid_b}, name="rootb"

        """
        with open(f"{out}/script.sfdisk", "w", encoding="utf-8") as f:
            f.write(sfdisk_script)

        dd = f"dd if=/dev/zero of={gpt_image} bs=1024M count=6"
        cmd = f"sfdisk < {out}/script.sfdisk {gpt_image}"
        os.system(dd)
        os.system(cmd)

    write_partition_to_image(gpt_image, efi, efi_start)

    write_partition_to_image(gpt_image, xboota, efi_start + efi_size)

    write_partition_to_image(gpt_image, root, efi_start + efi_size + 2 * xboot_size)


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("--out", type=str)
    parser.add_argument("--partauuid", type=str)

    parser.add_argument("--rootsize", type=int)

    parser.add_argument("--includeb", action="store_true")

    # root_size = 5242880
    args = parser.parse_args()
    out = args.out

    partauuid = args.partauuid
    root_size = args.rootsize

    includeb = args.includeb

    write_gpt(out, partauuid, root_size, includeb)


if __name__ == "__main__":
    main()
