{
  lib,
  drvs,
  libaom | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://storage.googleapis.com/aom-releases/libaom-3.14.1.tar.gz",
      sha256sum = "44bf90dbd23e734d50e70a8c41c285193922938bd0d3bc2ee56764d181d55ef5",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-D_GNU_SOURCE",
      ],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
    },

    biDrvs = [
      drvs.nasm,
      drvs.perl,
    ],
  }
}
