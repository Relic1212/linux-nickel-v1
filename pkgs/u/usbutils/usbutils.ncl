{
  lib,
  drvs,
  usbutils | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/gregkh/usbutils/archive/refs/tags/v018.tar.gz",
      sha256sum = "7cb6f475730e6ac3348ced5def99974a5fa2897fda317808c64ca3e5139d0a9e",
    },

    biDrvs = [
      drvs.gperf,
      drvs.kmod,
      drvs.zlibNg,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.linuxHeaders,
      drvs.file,
      drvs.eudev,
      drvs.libusb,
    ]
  }
}
