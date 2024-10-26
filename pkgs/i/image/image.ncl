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
        pkgs.busybox,
        pkgs.basefiles,
        pkgs.dinit,
        pkgs.dinitServices,
        pkgs.dinitUtils,
        pkgs.shadow,
        pkgs.fscrypt,
        pkgs.utilLinux,
        pkgs.openssl,
        pkgs.fscryptUnlockHome,
        pkgs.dhcpcd,
        pkgs.iwd,
        pkgs.dropbear,
        pkgs.seatd,
        pkgs.linux,
        pkgs.eudev,
        pkgs.dbus,
        pkgs.bkeymaps,
        pkgs.openresolv,
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
