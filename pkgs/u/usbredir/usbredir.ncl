{
  lib,
  drvs,
  usbredir | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.spice-space.org/download/usbredir/usbredir-0.15.0.tar.xz",
      sha256sum = "6dc2a380277688a068191245dac2ab7063a552999d8ac3ad8e841c10ff050961",
    },

    pDrvs = [
      drvs.libusb,
      drvs.glib,
    ],
  }
}
