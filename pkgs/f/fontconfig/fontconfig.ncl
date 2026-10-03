{
  lib,
  drvs,
  fontconfig | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/2.18.3/fontconfig-2.18.3.tar.bz2",
      sha256sum = "8d28f79d2017cbe1fbb7da84b2502c86421b4f45860234d2f4ab5b35564c8d01",
    },
    biDrvs = [
      drvs.gperf,
    ],
    pDrvs = [
      drvs.freetype,
      drvs.expat
    ],
  }
}
