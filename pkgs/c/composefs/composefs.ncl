{
  lib,
  drvs,
  composefs | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/composefs/composefs/archive/refs/tags/v1.0.8.tar.gz",
      sha256sum = "2b2b11f9a25744c82e9e12b098eefd0ab42d56ae6322634c15f966b3a64926ef",
    },
    preConfigurePhase = [
      m%"sed -i 's@both_libraries@library@g' ${SRC}/libcomposefs/meson.build"%,
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.fuse,
      drvs.openssl,
    ]
  }
}
