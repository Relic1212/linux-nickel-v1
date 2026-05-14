{
  lib,
  drvs,
  sbc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/sbc-2.0.tar.xz",
      sha256sum = "8f12368e1dbbf55e14536520473cfb338c84b392939cc9b64298360fd4a07992"
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.linuxHeaders,
      drvs.libsndfile,
    ],
    pDrvs = [
      # no libsndfile in .pc
    ]
  }
}
