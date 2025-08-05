{
  lib,
  drvs,
  botan2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://botan.randombit.net/releases/Botan-2.19.5.tar.xz",
      sha256sum = "dfeea0e0a6f26d6724c4af01da9a7b88487adb2d81ba7c72fcaf52db522c9ad4"
    },

    configureScript = "${SRC}/configure.py",
    configureFlags = [
      "--prefix=/usr",
      "--disable-shared-library",
    ],

    biDrvs = [
      drvs.boost,
      drvs.openssl,
      drvs.linuxHeaders,
      drvs.bzip2,
      drvs.zlibNg,
      drvs.xz,
      drvs.pkgconf,
      drvs.zstd,
      drvs.pythonFull
    ]
  }
}
