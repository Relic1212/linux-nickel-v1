(import "rootfs.ncl")
& {
  lib,
  pkgs,
  _rootfs,
  _rootfs2,
  baseBaseRootfs = (
    _rootfs
    & {
      biPkgs = [
        # base
        pkgs.busybox,
        pkgs.basefiles,
        pkgs.dinit,
        pkgs.dinitServices,
        pkgs.dinitUtils,
        pkgs.shadow,
        pkgs.utilLinux,
        pkgs.linux,
        # pkgs.linuxFirmware,
        pkgs.linuxFirmwareSmaller,
        pkgs.eudev,
        pkgs.dbus,
        pkgs.bkeymaps,
        pkgs.kmod,
        # pkgs.checkFirmware,

        # net
        pkgs.dhcpcd,
        pkgs.iwd,
        pkgs.dropbear,
        pkgs.openresolv,

        # enc
        pkgs.e2fsprogs,
        pkgs.fscryptUnlockHome,
        pkgs.openssl,
        pkgs.fscrypt,

        # gui
        pkgs.seatd,
        pkgs.sway,
        pkgs.libinput,
        pkgs.libxkbcommon,
        pkgs.xkeyboardConfig,
        pkgs.xdgRuntimeRun,
        pkgs.foot,
        pkgs.fontconfig,
        pkgs.ttfCroscore,
      ]
    }
  ),
  baseImage =
    _rootfs2
    & {
      enableCcache = false,
      biPkgs = [
        baseBaseRootfs,
        pkgs.erofsUtils,
        pkgs.mtools,
        pkgs.genimage,
        pkgs.cryptsetup,
        pkgs.systemdBoot,
        pkgs.llvm, # objdump
        pkgs.pythonFull,
        pkgs.utilLinux,
      ]
    },

  vmImage | lib.Package
    =
      baseImage
      & {
        installPhase = [
          "mkdir -p /tmp/workdir/out/efipart/EFI/BOOT",
          "mkdir -p /tmp/workdir/out/efipart/EFI/loader",
          "cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /tmp/workdir/out/efipart/EFI/BOOT/bootx64.efi",
          "echo \"timeout 5\n\" >  /tmp/workdir/out/efipart/EFI/loader/loader.conf",
          "dd if=/dev/zero of=/tmp/workdir/out/image/efipart.vfat bs=224M count=1",
          "mkfs.vfat /tmp/workdir/out/image/efipart.vfat",
          "mcopy -s -i  /tmp/workdir/out/image/efipart.vfat  /tmp/workdir/out/efipart/EFI ::/",
          "python /tmp/workdir/files/write_partitions.py"
        ],

        extraFiles = [
          {
            file = "write_partitions.py",
            sha256sum = "a82241e070c53f517c964b301969b28993bcb748cbb8a2f9a48b392a0e841770"
          }
        ]
      },

  aarch64Image | lib.Package
    = {
      biPkgs = [
        pkgs.busyboxAarch64,
        pkgs.linuxAarch64,
        pkgs.basefiles,
        pkgs.erofsUtils,
        pkgs.basefilesAarch64,
      ],
      buildPhase = [
        m%"
          mkfs.erofs \
              -d 1 \
              -L aarch6-root \
                  \
              ${DEST}/aarch64-root.img /aarch64-unknown-linux-musl/
            "%
      ],
    }
}
