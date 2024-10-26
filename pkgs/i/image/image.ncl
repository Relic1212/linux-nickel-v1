(import "rootfs.ncl")
& {
  lib,
  pkgs,
  _rootfs,
  _rootfs2,
  baseBaseRootfs = (
    _rootfs
    & {
      name = "base-base-rootfs",
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
        pkgs.eudev,
        pkgs.dbus,
        pkgs.bkeymaps,

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
      ]
    }
  ),
  baseRootfs =
    _rootfs2
    & {
      name = "base-image",
      biPkgs = [
        baseBaseRootfs,
        pkgs.erofsUtils,
        pkgs.mtools,
        pkgs.genimage,
        pkgs.cryptsetup,
      ]
    }
}
