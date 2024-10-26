{
  lib,
  pkgs,
  libdrm | lib.MesonPackage
    = {
      name = "libdrm",
      singleSource = {
        uri = "https://dri.freedesktop.org/libdrm/libdrm-2.4.123.tar.xz",
        sha256sum = "a2b98567a149a74b0f50e91e825f9c0315d86e7be9b74394dae8b298caadb79e",
      },
      extraMesonArgs = [
        "-Dintel=enabled",
        "-Dradeon=enabled",
        "-Damdgpu=enabled",
        "-Dvmwgfx=disabled",
        "-Dnouveau=disabled",
      ],
      biPkgs = [
        pkgs.libpciaccess,
        pkgs.linuxHeaders,
      ]
    }
}
