{
  lib,
  pkgs,

  eudev | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/eudev-project/eudev/releases/download/v3.2.14/eudev-3.2.14.tar.gz",
      sha256sum = "8da4319102f24abbf7fff5ce9c416af848df163b29590e666d334cc1927f006f"
    },
    biDrvs =
      lib.biMap [
        pkgs.gperf,
        pkgs.kmod,
        pkgs.zlibNg,
        pkgs.xz,
        pkgs.openssl,
        pkgs.zstd,
        pkgs.utilLinux,
        pkgs.linuxHeaders,
        pkgs.file,
        pkgs.pkgconf
      ],
    patches = [
      {
        file = "0001-fix-static-kmod-in-eudev.patch",
        sha256sum = "20fa7a1d7605a1870dfb12e36191f0829677f1b55b55bd4aad0c870ff382f662"
      }
    ],
    extraConfigureFlags = [
      "--enable-kmod",
      "--with-rootrundir=/run"
    ]
  }
}
