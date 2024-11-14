{
  lib,
  drvs,
  gnutar | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz",
        sha256sum = "4d62ff37342ec7aed748535323930c7cf94acf71c3591882b26a7ea50f3edc16",
      },
      extraEnv = {
        FORCE_UNSAFE_CONFIGURE = "1",
      },
      biDrvs = [
        drvs.xz,
        drvs.bzip2,
        drvs.zlibNg,
        drvs.lz4,
        drvs.pkgconf,
        drvs.zstd,
      ]
    }
}
