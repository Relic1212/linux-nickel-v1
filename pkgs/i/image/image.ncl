(import "rootfs.ncl")
& {
  lib,
  pkgs,
  _rootfs,
  _rootfs2,
  busybox,
  busyboxFinal = busybox & { postInstallPhase = ["rm ${DEST}/usr/bin/modprobe"] },
  dashSh | lib.Package
    = {
      installPhase = [
        "install -d -m0755 ${DEST}/bin",
        "cd ${DEST}/bin",
        "ln -s /usr/bin/dash sh",
      ]
    },
  baseBaseRootfs = (
    _rootfs
    & {
      name = "base-base-rootfs",
      biDrvs =
        lib.biMap [
          # base
          # pkgs.busyboxFinal,
          pkgs.bsdutils,
          pkgs.dash,
          pkgs.dashSh,
          pkgs.iproute2,
          pkgs.kbd,
          pkgs.pigz,
          pkgs.curl,
          pkgs.metalog,
          pkgs.zsh,
          pkgs.fish,
          pkgs.mawk,
          pkgs.ncurses,
          pkgs.basefiles,
          pkgs.dinit,
          pkgs.dinitServicesV3,
          pkgs.dinitUtils,
          pkgs.shadow,
          pkgs.utilLinux,
          pkgs.linux,
          # pkgs.linuxFirmware,
          pkgs.linuxFirmwareSmaller,
          pkgs.eudev,
          # pkgs.mdevd,
          # pkgs.mdevdConf,
          pkgs.dbus,
          pkgs.bkeymaps,
          pkgs.kmod,
          pkgs.mandoc,
          pkgs.less,
          # pkgs.checkFirmware,

          # net
          pkgs.dhcpcd,
          pkgs.iwd,
          pkgs.dropbear,
          pkgs.openresolv,
          pkgs.caCertificates,

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
          pkgs.sndiod,
        ]
    }
  ),
  baseImage =
    _rootfs2
    & {
      enableCcache = false,
      name = "base-image",
      biDrvs =
        lib.biMap [
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
        name | priority 1 = "vm-image",
        installPhase = [
          "mkdir -p /tmp/workdir/out/efipart/EFI/BOOT",
          "mkdir -p /tmp/workdir/out/efipart/EFI/loader",
          "cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /tmp/workdir/out/efipart/EFI/BOOT/bootx64.efi",
          "echo \"timeout 5\n\" >  /tmp/workdir/out/efipart/EFI/loader/loader.conf",
          "dd if=/dev/zero of=/tmp/workdir/out/image/efipart.vfat bs=224M count=1",
          "mkfs.vfat /tmp/workdir/out/image/efipart.vfat",
          "mcopy -s -i  /tmp/workdir/out/image/efipart.vfat  /tmp/workdir/out/efipart/EFI ::/",
          "python /tmp/workdir/files/write_partitions.py --partauuid aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
        ],

        extraFiles = [
          {
            file = "write_partitions.py",
            sha256sum = "b55fd7c30c96b851b2354c6b163a881261fe603dd855cf1db4f0eef353fea087"
          }
        ]
      },

  aarch64Image | lib.Package
    = {
      biDrvs =
        lib.biMap [
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
