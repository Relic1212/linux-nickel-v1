{
  lib,
  drvs,
  dav1d | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/videolan/dav1d/archive/refs/tags/0.1.0.tar.gz",
      sha256sum = "bd54884594997a35f0b5292d7afce6d1c9c2471b6866d231c18738a2d752c257",
    },

    extraMesonArgs = [
      "-Dbuild_tests=false",
    ],

    biDrvs = [
      drvs.nasm,
    ],
  }
}
